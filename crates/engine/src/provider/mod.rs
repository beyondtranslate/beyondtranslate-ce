//! Translation providers.
//!
//! LLM providers ([`llm`]) are the primary translation path; traditional
//! API-based providers live under [`traditional`].

pub mod llm;
pub mod traditional;

pub use llm::prompt;
#[cfg(feature = "anthropic")]
pub use llm::AnthropicProvider;
pub use llm::AnthropicProviderConfig;
#[cfg(feature = "ollama")]
pub use llm::OllamaProvider;
pub use llm::OllamaProviderConfig;
pub use llm::{
    specs, OpenAiCompatibleProvider, OpenAiCompatibleProviderConfig, OpenAiCompatibleSpec,
    OpenAiProviderConfig, XAiProviderConfig,
};
