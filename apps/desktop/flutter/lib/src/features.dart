import 'services/runtime.dart';

/// Whether the dictionary capability shows up anywhere in the app: the 服务
/// group on settings, the capability tags on providers, and the look-up that
/// runs beside a translation. The runtime still synthesises `+dictionary`
/// services for providers that support them; this only decides whether the UI
/// acknowledges them.
const bool kDictionaryFeatureEnabled = false;

/// Whether 术语库 is reachable: its workbench navigation item and route, and
/// the 加入术语库 actions on 历史. The store still loads so nothing else has
/// to null-check it.
const bool kGlossaryFeatureEnabled = false;

/// Whether 翻译 shows its right-hand aside (命中术语 / 质量信号 / 快捷键).
const bool kTranslationAsideEnabled = false;

/// True when the UI should surface a service of this kind at all.
bool isServiceTypeVisible(ServiceType type) {
  return type != ServiceType.dictionary || kDictionaryFeatureEnabled;
}
