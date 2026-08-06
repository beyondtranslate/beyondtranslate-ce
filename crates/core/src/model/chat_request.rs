use serde::{Deserialize, Serialize};

use super::ChatMessage;

/// Desired output format of the model response.
///
/// Serializes to the OpenAI `response_format` wire shape:
/// `{"type": "text"}`, `{"type": "json_object"}`, or
/// `{"type": "json_schema", "json_schema": {...}}`.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "snake_case")]
pub enum ResponseFormat {
    /// Plain text (default behaviour when omitted).
    Text,
    /// The model must return a valid JSON object.
    JsonObject,
    /// The model must return JSON matching the given schema. The value uses
    /// the OpenAI shape: `{"name": "...", "schema": {...}, "strict": true}`.
    JsonSchema { json_schema: serde_json::Value },
}

/// Request to an LLM chat/completion API.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ChatRequest {
    /// The model identifier (e.g. "gpt-4o", "claude-sonnet-4-20250514").
    pub model: String,
    /// The conversation messages.
    pub messages: Vec<ChatMessage>,
    /// Sampling temperature (0.0–2.0). Lower values are more deterministic.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub temperature: Option<f32>,
    /// Maximum tokens to generate.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub max_tokens: Option<u32>,
    /// Whether to return a streaming response.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub stream: Option<bool>,
    /// Desired output format. Providers without native support fall back to
    /// prompt-level instructions or ignore it.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub response_format: Option<ResponseFormat>,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn response_format_serializes_to_openai_wire_shape() {
        assert_eq!(
            serde_json::to_value(ResponseFormat::Text).unwrap(),
            serde_json::json!({"type": "text"})
        );
        assert_eq!(
            serde_json::to_value(ResponseFormat::JsonObject).unwrap(),
            serde_json::json!({"type": "json_object"})
        );
        assert_eq!(
            serde_json::to_value(ResponseFormat::JsonSchema {
                json_schema: serde_json::json!({"name": "answer", "schema": {"type": "object"}}),
            })
            .unwrap(),
            serde_json::json!({
                "type": "json_schema",
                "json_schema": {"name": "answer", "schema": {"type": "object"}},
            })
        );
    }

    #[test]
    fn chat_request_omits_response_format_when_none() {
        let request = ChatRequest {
            model: "gpt-4o".to_string(),
            messages: vec![ChatMessage::user("hi")],
            temperature: None,
            max_tokens: None,
            stream: None,
            response_format: None,
        };
        let value = serde_json::to_value(&request).unwrap();
        assert!(value.get("response_format").is_none());
    }
}
