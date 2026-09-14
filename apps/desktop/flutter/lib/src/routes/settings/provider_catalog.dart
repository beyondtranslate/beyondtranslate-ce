import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../widgets/confirm_dialog.dart';
import 'provider_meta.dart';

/// What the 提供商 page knows about a provider beyond its stored fields, and
/// the few things the list, the detail page and the settings shell have to
/// agree on while one of them is open.
///
/// Mirrors `provider-state.ts` in the Storybook deck.

/// How a configured provider last answered.
///
/// Nothing on disk records this — a key that worked yesterday may not today —
/// so it is what this session has seen: the detail page asks the endpoint for
/// its models on open and after every save, and that answer is the health. A
/// provider nobody has asked yet has none, and the list says nothing about its
/// connection rather than vouch for one.
enum ProviderHealth {
  /// The endpoint answered with the stored config.
  ok,

  /// The endpoint turned the stored config down.
  invalid,

  /// Saved, and not yet put to the endpoint.
  unverified,
}

/// This session's [ProviderHealth] by provider id.
final ValueNotifier<Map<String, ProviderHealth>> providerHealth =
    ValueNotifier(const {});

void setProviderHealth(String providerId, ProviderHealth? health) {
  final next = Map<String, ProviderHealth>.of(providerHealth.value);
  if (health == null) {
    next.remove(providerId);
  } else {
    next[providerId] = health;
  }
  providerHealth.value = next;
}

/// One row of the catalogue: a provider type, and the stored provider behind
/// it when there is one.
///
/// Which providers exist is the engine's to say, so the list is every LLM type
/// the app can build rather than only the ones already added — an unconfigured
/// row opens the same detail page, and that page is where its key goes.
typedef ProviderCatalogRow = ({ProviderType type, ProviderConfigEntry? entry});

/// The rows 提供商 lists, configured first.
///
/// Every LLM type gets a row; a type already added once or more shows each of
/// its providers instead. Traditional providers — the ones 服务 lists by the
/// service — are not catalogued here, but one the user already configured
/// keeps its row, since this is still the only place its key can be changed.
List<ProviderCatalogRow> providerCatalogRows(
  List<ProviderConfigEntry> configured,
) {
  final rows = <ProviderCatalogRow>[];
  for (final type in kKnownProviderTypes.where(isLlmProviderType)) {
    final entries = configured.where((entry) => entry.type == type);
    if (entries.isEmpty) {
      rows.add((type: type, entry: null));
    } else {
      rows.addAll(entries.map((entry) => (type: type, entry: entry)));
    }
  }
  for (final entry in configured) {
    if (!isLlmProviderType(entry.type)) {
      rows.add((type: entry.type, entry: entry));
    }
  }
  // Stable, so the catalogue order survives within each half: the page is most
  // often opened to go back to a provider already connected.
  return [
    ...rows.where((row) => row.entry != null),
    ...rows.where((row) => row.entry == null),
  ];
}

/// Whether [row] answers [query] — by name or by id, the way the deck's
/// search reads it. An unconfigured row's id is the one it would be saved
/// under, which is its type's.
bool providerRowMatches(ProviderCatalogRow row, String query) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return true;
  final id = row.entry?.id ?? providerTypeValue(row.type);
  return providerTypeDisplayName(row.type).toLowerCase().contains(needle) ||
      id.toLowerCase().contains(needle);
}

/// What an unconfigured provider needs before it can be used — the second
/// line of its catalogue row.
String providerNeedLine(ProviderType type) {
  final need = t.settings.providers.need;
  return switch (type) {
    ProviderType.anthropic => need.anthropic,
    ProviderType.openAi => need.openai,
    ProviderType.gemini => need.gemini,
    ProviderType.deepSeek => need.deepseek,
    ProviderType.qwen => need.qwen,
    ProviderType.moonshot => need.moonshot,
    ProviderType.doubao => need.doubao,
    ProviderType.zhipu => need.zhipu,
    ProviderType.xAi => need.xai,
    ProviderType.groq => need.groq,
    ProviderType.ollama => need.ollama,
    ProviderType.openAiCompatible => need.openai_compatible,
    _ => providerTypeDescription(type),
  };
}

/// The fields a provider's detail page offers.
///
/// A provider with a model roster picks its default model there — 设为默认 on
/// a row — so 默认模型 is not also a box in 配置: an input and a list each
/// saying which model runs is the easiest way for the page to contradict
/// itself.
List<String> providerFormFields(ProviderType type) {
  final keys = kProviderFields[type] ?? const <String>[];
  if (!isLlmProviderType(type)) return keys;
  return [
    for (final key in keys)
      if (key != 'defaultModel') key,
  ];
}

/// The form's required fields, out of [providerFormFields].
List<String> providerFormRequiredFields(ProviderType type) {
  final form = providerFormFields(type);
  return [
    for (final key in kRequiredProviderFields[type] ?? const <String>[])
      if (form.contains(key)) key,
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Leaving the detail page
// ─────────────────────────────────────────────────────────────────────────────

/// Whether the provider detail page holds edits nobody saved.
///
/// Every way off that page reads it — 返回, a rail entry, a link from 服务 —
/// so the question the user is asked is the same whichever they took, rather
/// than only 返回 asking while a click on the rail quietly drops a half-typed
/// key.
final ValueNotifier<bool> providerDetailDirty = ValueNotifier(false);

/// Bumped when 提供商 is picked on the rail while it is already the page: a
/// provider's detail page is a step into 提供商, and the rail entry is the way
/// back to its top, the catalogue.
final ValueNotifier<int> providersCatalogRequest = ValueNotifier(0);

/// Asks before leaving an edited detail page; true when it is fine to go.
Future<bool> confirmLeavingProviderDetail(BuildContext context) async {
  if (!providerDetailDirty.value) return true;
  final copy = t.settings.providers.discard_dialog;
  final discard = await showConfirmDialog(
    context,
    title: copy.title,
    message: copy.message,
    confirmLabel: copy.confirm,
    cancelLabel: copy.cancel,
    danger: true,
  );
  if (discard) providerDetailDirty.value = false;
  return discard;
}

// ─────────────────────────────────────────────────────────────────────────────
// Search
// ─────────────────────────────────────────────────────────────────────────────

/// Whether the catalogue is on screen — the settings titlebar shows 搜索 for
/// it, and only for it: the other panes and a provider's detail page have
/// nothing to search.
final ValueNotifier<bool> providersSearchable = ValueNotifier(false);

/// Bumped by the titlebar's 搜索 and its key; the catalogue opens its field
/// (or puts the caret back in it) each time it moves.
final ValueNotifier<int> providersSearchRequest = ValueNotifier(0);

// ─────────────────────────────────────────────────────────────────────────────
// Services
// ─────────────────────────────────────────────────────────────────────────────

/// Which service currently runs for a capability.
String defaultServiceOf(ServiceType type) {
  final general = settingsStore.general;
  return switch (type) {
    ServiceType.translation => general.defaultTranslationService,
    ServiceType.dictionary => general.defaultDirectoryService,
    ServiceType.ocr => general.defaultOcrService,
    ServiceType.llm => '',
  };
}

/// The default is stored as the service id `list_services` hands out; older
/// settings carried the bare provider id, which the runtime now rewrites on
/// load, but a row still answers to it in the meantime.
bool isDefaultService(ServiceConfigEntry service) {
  final current = defaultServiceOf(service.type);
  return current == service.id ||
      (isImplicitService(service) && current == service.providerId);
}

Future<void> makeDefaultService(ServiceConfigEntry service) async {
  final id = service.id;
  final patch = switch (service.type) {
    ServiceType.translation => GeneralSettingsPatch(
        defaultTranslationService: id,
      ),
    ServiceType.dictionary => GeneralSettingsPatch(
        defaultDirectoryService: id,
      ),
    ServiceType.ocr => GeneralSettingsPatch(defaultOcrService: id),
    ServiceType.llm => null,
  };
  if (patch != null) await settingsStore.updateGeneral(patch);
}

/// Switching a service off stores the flag on the service itself, so it
/// survives a restart and the translation flows can skip it.
Future<void> setServiceEnabled(
  ServiceConfigEntry service,
  bool enabled,
) async {
  final fields = Map<String, String>.from(service.fields);
  if (enabled) {
    fields.remove(kServiceEnabledField);
  } else {
    fields[kServiceEnabledField] = 'false';
  }
  await runtime.settings().updateService(
        serviceId: service.id,
        providerId: service.providerId,
        serviceType: service.type,
        name: service.name,
        fields: fields,
      );
  await settingsStore.reloadServices();
}
