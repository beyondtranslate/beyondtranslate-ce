use std::sync::{mpsc, Arc};

use async_trait::async_trait;
use beyondtranslate_core::{
    ChatMessage, ChatRequest, ChatResponse, ChatRole, LlmError, LlmService, LlmStreamReceiver,
    Provider, ResponseFormat, StreamChunk,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;

// ── Config ────────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct AnthropicProviderConfig {
    #[serde(rename = "apiKey", alias = "api_key")]
    pub api_key: String,
    #[serde(rename = "baseUrl", alias = "base_url")]
    pub base_url: Option<String>,
    #[serde(rename = "defaultModel", alias = "default_model", default)]
    pub default_model: String,
}

fn configured_default_model(default_model: &str) -> Result<String, String> {
    let default_model = default_model.trim().to_string();
    if default_model.is_empty() {
        return Err("default_model must be configured".to_owned());
    }
    Ok(default_model)
}

// ── Provider ──────────────────────────────────────────────────────────────────

pub struct AnthropicProvider {
    #[allow(dead_code)]
    config: AnthropicProviderConfig,
    llm_service: Arc<AnthropicLlmService>,
}

impl AnthropicProvider {
    pub fn new(config: AnthropicProviderConfig) -> Result<Self, String> {
        if config.api_key.trim().is_empty() {
            return Err("api_key must not be empty".to_owned());
        }
        let base_url = config
            .base_url
            .clone()
            .unwrap_or_else(|| "https://api.anthropic.com".to_string());

        let http = HttpClient::new(&base_url, &config.api_key);
        let default_model = configured_default_model(&config.default_model)?;

        let llm_service = Arc::new(AnthropicLlmService {
            base_url,
            api_key: config.api_key.clone(),
            default_model: default_model.clone(),
            http: http.clone(),
        });

        Ok(Self {
            config: config.clone(),
            llm_service: llm_service.clone(),
        })
    }
}

#[async_trait]
impl Provider for AnthropicProvider {
    fn name(&self) -> &'static str {
        "anthropic"
    }

    fn llm(&self) -> Option<&dyn LlmService> {
        Some(self.llm_service.as_ref())
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        self.llm_service.list_models().await
    }
}

// ── LLM Service (core) ────────────────────────────────────────────────────────

#[derive(Clone)]
struct HttpClient {
    base_url: String,
    api_key: String,
    client: reqwest::Client,
}

impl HttpClient {
    fn new(base_url: &str, api_key: &str) -> Self {
        Self {
            base_url: base_url.to_string(),
            api_key: api_key.to_string(),
            client: reqwest::Client::new(),
        }
    }

    fn join_url(&self, path: &str) -> String {
        format!("{}{}", self.base_url.trim_end_matches('/'), path)
    }
}

pub struct AnthropicLlmService {
    base_url: String,
    api_key: String,
    default_model: String,
    http: HttpClient,
}

impl AnthropicLlmService {
    fn build_anthropic_body(&self, request: &ChatRequest, stream: bool) -> Value {
        // Anthropic does NOT support system role as a message — it's a top-level field.
        let mut system_prompts: Vec<String> = Vec::new();
        let messages: Vec<Value> = request
            .messages
            .iter()
            .filter_map(|m| match m.role {
                ChatRole::System => {
                    system_prompts.push(m.content.clone());
                    None
                }
                ChatRole::User => Some(serde_json::json!({
                    "role": "user",
                    "content": m.content,
                })),
                ChatRole::Assistant => Some(serde_json::json!({
                    "role": "assistant",
                    "content": m.content,
                })),
            })
            .collect();

        let model = if request.model.is_empty() {
            &self.default_model
        } else {
            &request.model
        };

        let max_tokens = request.max_tokens.unwrap_or(4096);

        let mut body = serde_json::json!({
            "model": model,
            "max_tokens": max_tokens,
            "messages": messages,
            "stream": stream,
        });

        // The Messages API has no `response_format` parameter; fall back to a
        // system-level instruction so JSON modes still take effect.
        match &request.response_format {
            Some(ResponseFormat::JsonObject) => {
                system_prompts.push(
                    "You must respond with a single valid JSON object and nothing else — \
                     no markdown fences, no commentary."
                        .to_string(),
                );
            }
            Some(ResponseFormat::JsonSchema { json_schema }) => {
                let schema = json_schema.get("schema").unwrap_or(json_schema);
                system_prompts.push(format!(
                    "You must respond with a single valid JSON object matching this JSON \
                     schema and nothing else — no markdown fences, no commentary:\n{schema}"
                ));
            }
            Some(ResponseFormat::Text) | None => {}
        }

        if !system_prompts.is_empty() {
            let system = system_prompts.join("\n\n");
            body["system"] = serde_json::json!(system);
        }

        if let Some(temp) = request.temperature {
            body["temperature"] = serde_json::json!(temp);
        }

        body
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        let response = self
            .http
            .client
            .get(self.http.join_url("/v1/models"))
            .header("x-api-key", &self.api_key)
            .header("anthropic-version", "2023-06-01")
            .header("Content-Type", "application/json")
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body),
                429 => LlmError::RateLimitError(body),
                400..=499 => LlmError::InvalidRequest(body),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body}")),
            });
        }

        let json: serde_json::Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        // Anthropic API returns { "data": [{ "id": "...", ... }] }
        let models = json["data"]
            .as_array()
            .map(|arr| {
                arr.iter()
                    .filter_map(|m| m["id"].as_str().map(String::from))
                    .collect::<Vec<_>>()
            })
            .unwrap_or_default();

        Ok(models)
    }
}

#[async_trait]
impl LlmService for AnthropicLlmService {
    fn provider_name(&self) -> &'static str {
        "anthropic"
    }

    fn available_models(&self) -> Vec<String> {
        vec![self.default_model.clone()]
    }

    async fn chat(&self, request: ChatRequest) -> Result<ChatResponse, LlmError> {
        let body = self.build_anthropic_body(&request, false);

        let response = self
            .http
            .client
            .post(self.http.join_url("/v1/messages"))
            .header("x-api-key", &self.api_key)
            .header("anthropic-version", "2023-06-01")
            .header("Content-Type", "application/json")
            .json(&body)
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body_text = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body_text),
                429 => LlmError::RateLimitError(body_text),
                400..=499 => LlmError::InvalidRequest(body_text),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body_text}")),
            });
        }

        let raw: Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        let chat_response = parse_anthropic_response(&raw);
        Ok(chat_response)
    }

    async fn chat_stream(&self, request: ChatRequest) -> Result<LlmStreamReceiver, LlmError> {
        let body = self.build_anthropic_body(&request, true);

        let response = self
            .http
            .client
            .post(self.http.join_url("/v1/messages"))
            .header("x-api-key", &self.api_key)
            .header("anthropic-version", "2023-06-01")
            .header("Content-Type", "application/json")
            .json(&body)
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body_text = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body_text),
                429 => LlmError::RateLimitError(body_text),
                400..=499 => LlmError::InvalidRequest(body_text),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body_text}")),
            });
        }

        let (tx, rx) = mpsc::channel();

        tokio::spawn(async move {
            use futures_util::StreamExt;
            let mut byte_stream = response.bytes_stream();
            let mut buffer = String::new();
            let mut current_event: Option<String> = None;

            while let Some(chunk_result) = byte_stream.next().await {
                match chunk_result {
                    Ok(bytes) => {
                        buffer.push_str(&String::from_utf8_lossy(&bytes));
                        while let Some(line_end) = buffer.find('\n') {
                            let line = buffer[..line_end].trim().to_string();
                            buffer = buffer[line_end + 1..].to_string();

                            if line.is_empty() {
                                continue;
                            }

                            if let Some(event) = line.strip_prefix("event: ") {
                                current_event = Some(event.to_string());
                                continue;
                            }

                            if let Some(data) = line.strip_prefix("data: ") {
                                let event_type = current_event
                                    .take()
                                    .unwrap_or_else(|| "message".to_string());

                                match event_type.as_str() {
                                    "content_block_delta" => {
                                        if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                                            if let Some(delta) = parsed["delta"].as_object() {
                                                if delta["type"] == "text_delta" {
                                                    let text = delta["text"]
                                                        .as_str()
                                                        .unwrap_or("")
                                                        .to_string();
                                                    if !text.is_empty() {
                                                        let index =
                                                            parsed["index"].as_u64().unwrap_or(0)
                                                                as u32;
                                                        let _ = tx.send(StreamChunk {
                                                            content: text,
                                                            index,
                                                            finish_reason: None,
                                                        });
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    "message_stop" => {
                                        let _ = tx.send(StreamChunk {
                                            content: String::new(),
                                            index: 0,
                                            finish_reason: Some("stop".to_string()),
                                        });
                                        return;
                                    }
                                    "error" => {
                                        if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                                            let error_msg = parsed["error"]["message"]
                                                .as_str()
                                                .unwrap_or("Unknown stream error");
                                            let _ = tx.send(StreamChunk {
                                                content: error_msg.to_string(),
                                                index: 0,
                                                finish_reason: Some("error".to_string()),
                                            });
                                        }
                                        return;
                                    }
                                    _ => {}
                                }
                            }
                        }
                    }
                    Err(e) => {
                        let _ = tx.send(StreamChunk {
                            content: format!("Stream error: {e}"),
                            index: 0,
                            finish_reason: Some("error".to_string()),
                        });
                        return;
                    }
                }
            }
        });

        Ok(LlmStreamReceiver { rx })
    }
}

/// Parse Anthropic's non-streaming JSON response into a `ChatResponse`.
fn parse_anthropic_response(raw: &Value) -> ChatResponse {
    let id = raw["id"].as_str().map(|s| s.to_string());
    let model = raw["model"].as_str().unwrap_or("unknown").to_string();

    let content_text = raw["content"]
        .as_array()
        .and_then(|blocks| {
            blocks.iter().find_map(|block| {
                if block["type"] == "text" {
                    block["text"].as_str().map(|s| s.to_string())
                } else {
                    None
                }
            })
        })
        .unwrap_or_default();

    let stop_reason = raw["stop_reason"].as_str().map(|s| s.to_string());

    let message = ChatMessage::assistant(content_text);
    let choice = beyondtranslate_core::ChatChoice {
        index: 0,
        message,
        finish_reason: stop_reason,
    };

    let usage = raw.get("usage").map(|u| {
        let input = u["input_tokens"].as_u64().unwrap_or(0) as u32;
        let output = u["output_tokens"].as_u64().unwrap_or(0) as u32;
        beyondtranslate_core::ChatUsage {
            prompt_tokens: input,
            completion_tokens: output,
            total_tokens: input + output,
        }
    });

    ChatResponse {
        id,
        model,
        choices: vec![choice],
        usage,
    }
}
