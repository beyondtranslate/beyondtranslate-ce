//! LLM translation providers.
//!
//! [`openai_compatible`] carries every vendor that speaks the OpenAI chat
//! completions protocol (OpenAI, xAI, DeepSeek, Qwen, Zhipu, Moonshot,
//! Doubao, Groq, Gemini, plus self-hosted endpoints); only Anthropic and
//! Ollama need dedicated implementations.

pub mod anthropic;
pub mod ollama;
pub mod openai_compatible;
pub mod prompt;

#[cfg(feature = "anthropic")]
pub use anthropic::AnthropicProvider;
pub use anthropic::AnthropicProviderConfig;
#[cfg(feature = "ollama")]
pub use ollama::OllamaProvider;
pub use ollama::OllamaProviderConfig;
pub use openai_compatible::{
    specs, OpenAiCompatibleProvider, OpenAiCompatibleProviderConfig, OpenAiCompatibleSpec,
};

/// Back-compat aliases from the pre-`openai_compatible` era.
pub type OpenAiProviderConfig = OpenAiCompatibleProviderConfig;
pub type XAiProviderConfig = OpenAiCompatibleProviderConfig;
