mod common;
mod engine;
mod languages;
mod provider;

pub use beyondtranslate_core::{
    DictionaryError, DictionaryService, OcrError, OcrService, Provider, TranslationError,
    TranslationService,
};
pub use engine::{
    from_yaml_str, load_from_file, Engine, EngineConfig, EngineError, ProviderConfig, ProviderType,
};
pub use languages::{all_languages, app_languages};

// LLM providers (primary).
pub use provider::{
    prompt, specs, OpenAiCompatibleProvider, OpenAiCompatibleProviderConfig, OpenAiCompatibleSpec,
    OpenAiProviderConfig, XAiProviderConfig,
};

// Traditional providers.
#[cfg(feature = "baidu")]
pub use provider::traditional::BaiduProvider;
#[cfg(feature = "caiyun")]
pub use provider::traditional::CaiyunProvider;
pub use provider::traditional::DeepLProvider;
#[cfg(feature = "google")]
pub use provider::traditional::GoogleProvider;
pub use provider::traditional::SystemProvider;
pub use provider::traditional::SystemTranslationService;
#[cfg(feature = "tencent")]
pub use provider::traditional::TencentProvider;
#[cfg(feature = "youdao")]
pub use provider::traditional::YoudaoProvider;
pub use provider::traditional::{
    BaiduProviderConfig, CaiyunProviderConfig, DeepLProviderConfig, GoogleProviderConfig,
    TencentProviderConfig, YoudaoProviderConfig,
};

#[cfg(test)]
mod tests;
