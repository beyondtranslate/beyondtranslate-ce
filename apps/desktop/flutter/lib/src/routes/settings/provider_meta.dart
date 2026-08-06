import '../../i18n/i18n.dart';
import '../../services/runtime.dart';

/// Naming and classification shared by the providers list and a provider's
/// detail page. Kept out of both so the two never drift on what a provider
/// type is called or which fields it takes.

/// Provider types offered in the 添加提供商 picker, in the order it lists them.
const List<ProviderType> kKnownProviderTypes = <ProviderType>[
  ProviderType.anthropic,
  ProviderType.baidu,
  ProviderType.caiyun,
  ProviderType.deepL,
  ProviderType.deepSeek,
  ProviderType.doubao,
  ProviderType.gemini,
  ProviderType.google,
  ProviderType.groq,
  ProviderType.moonshot,
  ProviderType.openAi,
  ProviderType.openAiCompatible,
  ProviderType.ollama,
  ProviderType.qwen,
  ProviderType.system,
  ProviderType.tencent,
  ProviderType.xAi,
  ProviderType.youdao,
  ProviderType.zhipu,
];

/// The configuration keys each provider type takes. Mirrors the
/// `*ProviderConfig+Fields.swift` files (lowest common denominator).
const Map<ProviderType, List<String>> kProviderFields = {
  ProviderType.anthropic: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.baidu: ['appId', 'appKey'],
  ProviderType.caiyun: ['token'],
  ProviderType.deepL: ['authKey'],
  ProviderType.google: ['apiKey'],
  ProviderType.openAi: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.ollama: ['baseUrl', 'defaultModel'],
  ProviderType.xAi: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.deepSeek: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.qwen: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.zhipu: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.moonshot: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.doubao: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.groq: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.gemini: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.openAiCompatible: ['apiKey', 'baseUrl', 'defaultModel'],
  ProviderType.system: [],
  ProviderType.tencent: ['secretId', 'secretKey'],
  ProviderType.youdao: ['appKey', 'appSecret'],
};

/// The fields a provider type cannot work without. Everything else in
/// [kProviderFields] is optional: `defaultModel` falls back to the engine's
/// pick, and `baseUrl` to the endpoint baked into the provider's spec — except
/// for `openai_compatible`, which is nothing *but* an endpoint.
const Map<ProviderType, List<String>> kRequiredProviderFields = {
  ProviderType.anthropic: ['apiKey'],
  ProviderType.baidu: ['appId', 'appKey'],
  ProviderType.caiyun: ['token'],
  ProviderType.deepL: ['authKey'],
  ProviderType.deepSeek: ['apiKey'],
  ProviderType.doubao: ['apiKey'],
  ProviderType.gemini: ['apiKey'],
  ProviderType.google: ['apiKey'],
  ProviderType.groq: ['apiKey'],
  ProviderType.moonshot: ['apiKey'],
  // Self-hosted endpoints (vLLM, LM Studio, LiteLLM …) often take no key at
  // all, so only the URL is asked for.
  ProviderType.openAiCompatible: ['baseUrl'],
  ProviderType.openAi: ['apiKey'],
  ProviderType.ollama: [],
  ProviderType.qwen: ['apiKey'],
  ProviderType.system: [],
  ProviderType.tencent: ['secretId', 'secretKey'],
  ProviderType.xAi: ['apiKey'],
  ProviderType.youdao: ['appKey', 'appSecret'],
  ProviderType.zhipu: ['apiKey'],
};

/// What the engine derives from each provider type, mirroring which of
/// `translation()` / `dictionary()` / `ocr()` / `llm()` its provider
/// implements. Every LLM type answers translation only; a dictionary on top of
/// one is a service the user adds by hand.
const Map<ProviderType, List<ServiceType>> kProviderCapabilities = {
  ProviderType.anthropic: [ServiceType.translation],
  ProviderType.baidu: [ServiceType.translation],
  ProviderType.caiyun: [ServiceType.translation],
  ProviderType.deepL: [ServiceType.translation],
  ProviderType.deepSeek: [ServiceType.translation],
  ProviderType.doubao: [ServiceType.translation],
  ProviderType.gemini: [ServiceType.translation],
  ProviderType.google: [ServiceType.translation],
  ProviderType.groq: [ServiceType.translation],
  ProviderType.moonshot: [ServiceType.translation],
  ProviderType.openAi: [ServiceType.translation],
  ProviderType.openAiCompatible: [ServiceType.translation],
  ProviderType.ollama: [ServiceType.translation],
  ProviderType.qwen: [ServiceType.translation],
  ProviderType.system: [
    ServiceType.translation,
    ServiceType.dictionary,
    ServiceType.ocr,
  ],
  ProviderType.tencent: [ServiceType.translation],
  ProviderType.xAi: [ServiceType.translation],
  ProviderType.youdao: [
    ServiceType.translation,
    ServiceType.dictionary,
    ServiceType.ocr,
  ],
  ProviderType.zhipu: [ServiceType.translation],
};

/// The endpoint the engine falls back to when `baseUrl` is left blank. Shown
/// as the field's placeholder rather than filled in, so a provider added today
/// still follows the spec if the endpoint moves.
String defaultBaseUrl(ProviderType type) {
  switch (type) {
    case ProviderType.anthropic:
      return 'https://api.anthropic.com';
    case ProviderType.ollama:
      return 'http://localhost:11434';
    case ProviderType.openAi:
      return 'https://api.openai.com';
    case ProviderType.xAi:
      return 'https://api.x.ai';
    case ProviderType.deepSeek:
      return 'https://api.deepseek.com';
    case ProviderType.qwen:
      return 'https://dashscope.aliyuncs.com/compatible-mode';
    case ProviderType.zhipu:
      return 'https://open.bigmodel.cn';
    case ProviderType.moonshot:
      return 'https://api.moonshot.cn';
    case ProviderType.doubao:
      return 'https://ark.cn-beijing.volces.com';
    case ProviderType.groq:
      return 'https://api.groq.com/openai';
    case ProviderType.gemini:
      return 'https://generativelanguage.googleapis.com/v1beta/openai';
    // Nothing to fall back to: the endpoint is the whole configuration.
    case ProviderType.openAiCompatible:
      return 'https://api.example.com/v1';
    case ProviderType.baidu:
    case ProviderType.caiyun:
    case ProviderType.deepL:
    case ProviderType.google:
    case ProviderType.system:
    case ProviderType.tencent:
    case ProviderType.youdao:
      return '';
  }
}

/// The one-line description under a provider type's name, chosen by what it
/// can do — the deck writes a bespoke line per type; we only know capabilities.
String providerTypeDescription(ProviderType type) {
  final capabilities = kProviderCapabilities[type] ?? const <ServiceType>[];
  final translates = capabilities.contains(ServiceType.translation);
  final defines = capabilities.contains(ServiceType.dictionary);
  final description = t.settings.providers.description;
  if (translates && defines) return description.all;
  if (defines) return description.dictionary;
  if (translates) return description.translation;
  return description.fallback;
}

/// What enabling a capability buys you — the note beside each 可用服务 row.
String capabilityNote(ServiceType type) {
  final note = t.settings.providers.editor.capability_note;
  switch (type) {
    case ServiceType.translation:
    case ServiceType.llm:
      return note.translation;
    case ServiceType.dictionary:
      return note.dictionary;
    case ServiceType.ocr:
      return note.ocr;
  }
}

/// The suffixes the runtime appends when it synthesises a service from a
/// provider's capabilities — see `list_services` in the Rust runtime.
const List<String> kImplicitServiceSuffixes = [
  '+translation',
  '+dictionary',
  '+ocr',
];

/// True when the runtime derived this service from its provider rather than
/// the user creating it. Such a service has nothing of its own to edit or
/// delete: it exists exactly as long as the provider does.
bool isImplicitService(ServiceConfigEntry service) {
  return kImplicitServiceSuffixes.any(
    (suffix) => service.id == '${service.providerId}$suffix',
  );
}

/// Strips the capability suffix a synthesised service id carries, so a stored
/// default ("deepl+translation") resolves back to its provider.
String providerIdOfService(String serviceId) {
  for (final suffix in kImplicitServiceSuffixes) {
    if (serviceId.endsWith(suffix)) {
      return serviceId.substring(0, serviceId.length - suffix.length);
    }
  }
  return serviceId;
}

bool isLlmProviderType(ProviderType type) {
  switch (type) {
    case ProviderType.anthropic:
    case ProviderType.openAi:
    case ProviderType.ollama:
    case ProviderType.xAi:
    case ProviderType.deepSeek:
    case ProviderType.qwen:
    case ProviderType.zhipu:
    case ProviderType.moonshot:
    case ProviderType.doubao:
    case ProviderType.groq:
    case ProviderType.gemini:
    case ProviderType.openAiCompatible:
      return true;
    case ProviderType.baidu:
    case ProviderType.caiyun:
    case ProviderType.deepL:
    case ProviderType.google:
    case ProviderType.system:
    case ProviderType.tencent:
    case ProviderType.youdao:
      return false;
  }
}

/// A field the UI masks — anything that reads like a credential.
bool isSecretField(String key) {
  final lower = key.toLowerCase();
  return lower.contains('key') ||
      lower.contains('secret') ||
      lower.contains('token') ||
      lower.contains('password');
}

/// The value the runtime persists for a provider type.
String providerTypeValue(ProviderType type) {
  switch (type) {
    case ProviderType.anthropic:
      return 'anthropic';
    case ProviderType.baidu:
      return 'baidu';
    case ProviderType.caiyun:
      return 'caiyun';
    case ProviderType.deepL:
      return 'deepl';
    case ProviderType.google:
      return 'google';
    case ProviderType.openAi:
      return 'openai';
    case ProviderType.ollama:
      return 'ollama';
    case ProviderType.xAi:
      return 'xai';
    case ProviderType.deepSeek:
      return 'deepseek';
    case ProviderType.qwen:
      return 'qwen';
    case ProviderType.zhipu:
      return 'zhipu';
    case ProviderType.moonshot:
      return 'moonshot';
    case ProviderType.doubao:
      return 'doubao';
    case ProviderType.groq:
      return 'groq';
    case ProviderType.gemini:
      return 'gemini';
    case ProviderType.openAiCompatible:
      return 'openai_compatible';
    case ProviderType.system:
      return 'system';
    case ProviderType.tencent:
      return 'tencent';
    case ProviderType.youdao:
      return 'youdao';
  }
}

String providerTypeDisplayName(ProviderType type) {
  switch (type) {
    case ProviderType.anthropic:
      return t.common.provider.anthropic;
    case ProviderType.baidu:
      return t.common.provider.baidu;
    case ProviderType.caiyun:
      return t.common.provider.caiyun;
    case ProviderType.deepL:
      return t.common.provider.deepl;
    case ProviderType.google:
      return t.common.provider.google;
    case ProviderType.openAi:
      return t.common.provider.openai;
    case ProviderType.ollama:
      return t.common.provider.ollama;
    case ProviderType.xAi:
      return t.common.provider.xai;
    case ProviderType.deepSeek:
      return 'DeepSeek';
    case ProviderType.qwen:
      return 'Qwen';
    case ProviderType.zhipu:
      return 'Zhipu GLM';
    case ProviderType.moonshot:
      return 'Moonshot Kimi';
    case ProviderType.doubao:
      return 'Doubao';
    case ProviderType.groq:
      return 'Groq';
    case ProviderType.gemini:
      return 'Gemini';
    case ProviderType.openAiCompatible:
      return 'OpenAI Compatible';
    case ProviderType.system:
      return t.common.provider.system;
    case ProviderType.tencent:
      return t.common.provider.tencent;
    case ProviderType.youdao:
      return t.common.provider.youdao;
  }
}

/// The capability label a service type carries — 翻译 / 查词 / OCR / AI, the
/// same words the deck prints on a provider row's tags and over each group of
/// 可用服务.
String serviceTypeLabel(ServiceType type) {
  switch (type) {
    case ServiceType.translation:
      return t.settings.providers.capability.translation;
    case ServiceType.dictionary:
      return t.settings.providers.capability.dictionary;
    case ServiceType.ocr:
      return t.settings.providers.capability.ocr;
    case ServiceType.llm:
      return t.settings.providers.capability.llm;
  }
}

/// The order the deck groups 可用服务 in.
const List<ServiceType> kServiceTypeOrder = [
  ServiceType.translation,
  ServiceType.dictionary,
  ServiceType.ocr,
  ServiceType.llm,
];
