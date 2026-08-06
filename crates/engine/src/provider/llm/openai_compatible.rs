use std::sync::{mpsc, Arc};

use async_trait::async_trait;
use beyondtranslate_core::{
    ChatRequest, ChatResponse, ChatRole, LlmError, LlmService, LlmStreamReceiver, Provider,
    StreamChunk,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;

// ── Spec ──────────────────────────────────────────────────────────────────────

/// Static description of an OpenAI-compatible endpoint. One shared
/// implementation serves every vendor; each vendor only differs in its
/// defaults.
#[derive(Debug)]
pub struct OpenAiCompatibleSpec {
    pub name: &'static str,
    /// Default endpoint root. Empty means the user must configure `base_url`.
    pub default_base_url: &'static str,
    /// Path (relative to the base URL) of the chat completions endpoint.
    pub chat_completions_path: &'static str,
    /// Path (relative to the base URL) of the model listing endpoint.
    pub models_path: &'static str,
    /// Whether an API key is mandatory (self-hosted endpoints often need none).
    pub requires_api_key: bool,
}

pub mod specs {
    use super::OpenAiCompatibleSpec;

    macro_rules! spec {
        ($const_name:ident, $name:literal, $base:literal, $chat:literal, $models:literal, $key:literal) => {
            pub const $const_name: OpenAiCompatibleSpec = OpenAiCompatibleSpec {
                name: $name,
                default_base_url: $base,
                chat_completions_path: $chat,
                models_path: $models,
                requires_api_key: $key,
            };
        };
    }

    spec!(
        OPENAI,
        "openai",
        "https://api.openai.com",
        "/v1/chat/completions",
        "/v1/models",
        true
    );
    spec!(
        XAI,
        "xai",
        "https://api.x.ai",
        "/v1/chat/completions",
        "/v1/models",
        true
    );
    spec!(
        DEEPSEEK,
        "deepseek",
        "https://api.deepseek.com",
        "/v1/chat/completions",
        "/v1/models",
        true
    );
    spec!(
        QWEN,
        "qwen",
        "https://dashscope.aliyuncs.com/compatible-mode",
        "/v1/chat/completions",
        "/v1/models",
        true
    );
    spec!(
        ZHIPU,
        "zhipu",
        "https://open.bigmodel.cn",
        "/api/paas/v4/chat/completions",
        "/api/paas/v4/models",
        true
    );
    spec!(
        MOONSHOT,
        "moonshot",
        "https://api.moonshot.cn",
        "/v1/chat/completions",
        "/v1/models",
        true
    );
    spec!(
        DOUBAO,
        "doubao",
        "https://ark.cn-beijing.volces.com",
        "/api/v3/chat/completions",
        "/api/v3/models",
        true
    );
    spec!(
        GROQ,
        "groq",
        "https://api.groq.com/openai",
        "/v1/chat/completions",
        "/v1/models",
        true
    );
    spec!(
        GEMINI,
        "gemini",
        "https://generativelanguage.googleapis.com/v1beta/openai",
        "/chat/completions",
        "/models",
        true
    );
    // Catch-all for self-hosted or aggregator endpoints (vLLM, LM Studio,
    // LiteLLM, OpenRouter, SiliconFlow, ...): the user supplies the base URL.
    spec!(
        OPENAI_COMPATIBLE,
        "openai_compatible",
        "",
        "/v1/chat/completions",
        "/v1/models",
        false
    );
}

// ── Config ────────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct OpenAiCompatibleProviderConfig {
    #[serde(rename = "apiKey", alias = "api_key", default)]
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

pub struct OpenAiCompatibleProvider {
    name: &'static str,
    llm_service: Arc<OpenAiCompatibleLlmService>,
}

impl OpenAiCompatibleProvider {
    pub fn new(
        spec: &'static OpenAiCompatibleSpec,
        config: OpenAiCompatibleProviderConfig,
    ) -> Result<Self, String> {
        let api_key = config.api_key.trim().to_string();
        if spec.requires_api_key && api_key.is_empty() {
            return Err("api_key must not be empty".to_owned());
        }
        let base_url = config
            .base_url
            .as_deref()
            .map(str::trim)
            .filter(|url| !url.is_empty())
            .unwrap_or(spec.default_base_url)
            .to_string();
        if base_url.is_empty() {
            return Err("base_url must be configured".to_owned());
        }
        let default_model = configured_default_model(&config.default_model)?;

        let llm_service = Arc::new(OpenAiCompatibleLlmService {
            spec,
            base_url,
            api_key,
            default_model,
            client: reqwest::Client::new(),
        });

        Ok(Self {
            name: spec.name,
            llm_service,
        })
    }
}

#[async_trait]
impl Provider for OpenAiCompatibleProvider {
    fn name(&self) -> &'static str {
        self.name
    }

    fn llm(&self) -> Option<&dyn LlmService> {
        Some(self.llm_service.as_ref())
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        self.llm_service.list_models().await
    }
}

// ── LLM Service (core) ────────────────────────────────────────────────────────

pub struct OpenAiCompatibleLlmService {
    spec: &'static OpenAiCompatibleSpec,
    base_url: String,
    api_key: String,
    default_model: String,
    client: reqwest::Client,
}

impl OpenAiCompatibleLlmService {
    fn join_url(&self, path: &str) -> String {
        format!("{}{}", self.base_url.trim_end_matches('/'), path)
    }

    fn authorized(&self, request: reqwest::RequestBuilder) -> reqwest::RequestBuilder {
        let request = request.header("Content-Type", "application/json");
        if self.api_key.is_empty() {
            request
        } else {
            request.header("Authorization", format!("Bearer {}", self.api_key))
        }
    }

    fn build_openai_body(&self, request: &ChatRequest, stream: bool) -> Value {
        let messages: Vec<Value> = request
            .messages
            .iter()
            .map(|m| {
                let role = match m.role {
                    ChatRole::System => "system",
                    ChatRole::User => "user",
                    ChatRole::Assistant => "assistant",
                };
                serde_json::json!({
                    "role": role,
                    "content": m.content,
                })
            })
            .collect();

        let model = if request.model.is_empty() {
            &self.default_model
        } else {
            &request.model
        };

        let mut body = serde_json::json!({
            "model": model,
            "messages": messages,
            "stream": stream,
        });

        if let Some(temp) = request.temperature {
            body["temperature"] = serde_json::json!(temp);
        }
        if let Some(max_tokens) = request.max_tokens {
            body["max_tokens"] = serde_json::json!(max_tokens);
        }
        if let Some(response_format) = &request.response_format {
            body["response_format"] = serde_json::to_value(response_format).unwrap_or(Value::Null);
        }

        body
    }

    async fn send_chat(
        &self,
        request: &ChatRequest,
        stream: bool,
    ) -> Result<reqwest::Response, LlmError> {
        let body = self.build_openai_body(request, stream);
        let response = self
            .authorized(
                self.client
                    .post(self.join_url(self.spec.chat_completions_path)),
            )
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

        Ok(response)
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        let response = self
            .authorized(self.client.get(self.join_url(self.spec.models_path)))
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body}")),
            });
        }

        let json: serde_json::Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

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
impl LlmService for OpenAiCompatibleLlmService {
    fn provider_name(&self) -> &'static str {
        self.spec.name
    }

    fn available_models(&self) -> Vec<String> {
        vec![self.default_model.clone()]
    }

    async fn chat(&self, request: ChatRequest) -> Result<ChatResponse, LlmError> {
        let response = self.send_chat(&request, false).await?;

        let chat_response: ChatResponse = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        Ok(chat_response)
    }

    async fn chat_stream(&self, request: ChatRequest) -> Result<LlmStreamReceiver, LlmError> {
        let response = self.send_chat(&request, true).await?;

        let (tx, rx) = mpsc::channel();

        tokio::spawn(async move {
            use futures_util::StreamExt;
            let mut byte_stream = response.bytes_stream();
            let mut buffer = String::new();

            while let Some(chunk_result) = byte_stream.next().await {
                match chunk_result {
                    Ok(bytes) => {
                        buffer.push_str(&String::from_utf8_lossy(&bytes));
                        while let Some(line_end) = buffer.find('\n') {
                            let line = buffer[..line_end].trim().to_string();
                            buffer = buffer[line_end + 1..].to_string();

                            if line.is_empty() || line.starts_with(':') {
                                continue;
                            }

                            if line == "data: [DONE]" {
                                let _ = tx.send(StreamChunk {
                                    content: String::new(),
                                    index: 0,
                                    finish_reason: Some("stop".to_string()),
                                });
                                return;
                            }

                            if let Some(data) = line.strip_prefix("data: ") {
                                if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                                    if let Some(choices) = parsed["choices"].as_array() {
                                        for choice in choices {
                                            let index =
                                                choice["index"].as_u64().unwrap_or(0) as u32;
                                            let delta_content = choice["delta"]["content"]
                                                .as_str()
                                                .unwrap_or("")
                                                .to_string();
                                            let finish_reason = choice["finish_reason"]
                                                .as_str()
                                                .map(|s| s.to_string());

                                            if !delta_content.is_empty() || finish_reason.is_some()
                                            {
                                                let _ = tx.send(StreamChunk {
                                                    content: delta_content,
                                                    index,
                                                    finish_reason,
                                                });
                                            }
                                        }
                                    }
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

#[cfg(test)]
mod tests {
    use super::*;

    fn config(
        api_key: &str,
        base_url: Option<&str>,
        model: &str,
    ) -> OpenAiCompatibleProviderConfig {
        OpenAiCompatibleProviderConfig {
            api_key: api_key.to_owned(),
            base_url: base_url.map(str::to_owned),
            default_model: model.to_owned(),
        }
    }

    #[test]
    fn preset_uses_default_base_url() {
        let provider = OpenAiCompatibleProvider::new(
            &specs::DEEPSEEK,
            config("sk-test", None, "deepseek-chat"),
        )
        .expect("provider");
        assert_eq!(provider.name(), "deepseek");
        assert_eq!(
            provider
                .llm_service
                .join_url(specs::DEEPSEEK.chat_completions_path),
            "https://api.deepseek.com/v1/chat/completions"
        );
    }

    #[test]
    fn zhipu_uses_paas_paths() {
        let provider =
            OpenAiCompatibleProvider::new(&specs::ZHIPU, config("sk-test", None, "glm-4.5"))
                .expect("provider");
        assert_eq!(
            provider
                .llm_service
                .join_url(specs::ZHIPU.chat_completions_path),
            "https://open.bigmodel.cn/api/paas/v4/chat/completions"
        );
    }

    #[test]
    fn requires_api_key_when_spec_demands_it() {
        let error = OpenAiCompatibleProvider::new(&specs::OPENAI, config("", None, "gpt-4o-mini"))
            .map(|_| ())
            .expect_err("missing api key");
        assert!(error.contains("api_key"));
    }

    #[test]
    fn custom_endpoint_requires_base_url_but_not_api_key() {
        let error =
            OpenAiCompatibleProvider::new(&specs::OPENAI_COMPATIBLE, config("", None, "qwen3:8b"))
                .map(|_| ())
                .expect_err("missing base url");
        assert!(error.contains("base_url"));

        let provider = OpenAiCompatibleProvider::new(
            &specs::OPENAI_COMPATIBLE,
            config("", Some("http://localhost:1234"), "qwen3:8b"),
        )
        .expect("provider");
        assert_eq!(provider.name(), "openai_compatible");
    }

    #[test]
    fn body_includes_response_format_when_set() {
        use beyondtranslate_core::{ChatMessage, ResponseFormat};

        let provider =
            OpenAiCompatibleProvider::new(&specs::OPENAI, config("sk-test", None, "gpt-4o-mini"))
                .expect("provider");
        let mut request = ChatRequest {
            model: String::new(),
            messages: vec![ChatMessage::user("hi")],
            temperature: None,
            max_tokens: None,
            stream: None,
            response_format: None,
        };

        let body = provider.llm_service.build_openai_body(&request, false);
        assert!(body.get("response_format").is_none());

        request.response_format = Some(ResponseFormat::JsonObject);
        let body = provider.llm_service.build_openai_body(&request, false);
        assert_eq!(
            body["response_format"],
            serde_json::json!({"type": "json_object"})
        );
    }

    #[test]
    fn user_base_url_overrides_default() {
        let provider = OpenAiCompatibleProvider::new(
            &specs::OPENAI,
            config("sk-test", Some("https://proxy.example.com/"), "gpt-4o-mini"),
        )
        .expect("provider");
        assert_eq!(
            provider
                .llm_service
                .join_url(specs::OPENAI.chat_completions_path),
            "https://proxy.example.com/v1/chat/completions"
        );
    }
}
