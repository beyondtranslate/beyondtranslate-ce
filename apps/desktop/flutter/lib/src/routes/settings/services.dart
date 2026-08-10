import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show runtime;
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        BadgeSize,
        Button,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles,
        PreferenceGroup,
        PreferenceRow,
        PreferenceSection,
        Switch;
import 'add_service_dialog.dart';
import 'index.dart';
import 'provider_meta.dart';
import 'service_prefs.dart';

/// 服务 — one section per capability, and each section owns that capability
/// end to end: the services available to it and which one runs by default.
///
/// Mirrors the React `SettingsView`'s 服务 page. Splitting this across 常规 and
/// 提供商 is what made the old settings ask the user to hold two pages in
/// their head at once.
class ServicesSettingsPage extends StatefulWidget {
  const ServicesSettingsPage({super.key});

  /// When set before the page is opened, the common languages sheet opens
  /// once the page is built. Set by the mini translator and the workbench,
  /// which both offer 管理常用语言 without owning the sheet.
  static bool pendingOpenCommonLanguages = false;

  /// The same, for 添加翻译目标.
  static bool pendingOpenAddTarget = false;

  @override
  State<ServicesSettingsPage> createState() => _ServicesSettingsPageState();
}

class _ServicesSettingsPageState extends State<ServicesSettingsPage> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    settingsStore.reloadServices();
    settingsStore.reloadProviders();
    // Each capability owns its own options here, so the page reads 常规's
    // store as well — the rows moved, the settings did not.
    settingsStore.reloadGeneral();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ServicesSettingsPage.pendingOpenCommonLanguages) {
      ServicesSettingsPage.pendingOpenCommonLanguages = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCommonLanguagesDialog(context);
      });
    }

    if (ServicesSettingsPage.pendingOpenAddTarget) {
      ServicesSettingsPage.pendingOpenAddTarget = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAddTargetDialog(context);
      });
    }
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openServiceEditor(ServiceType type) async {
    final draft = await showDialogInCurrentWindow<ServiceDraft>(
      context: context,
      builder: (_) => AddServiceDialog(
        providers: settingsStore.providers,
        // The derived services count as taken ids, so a second service of the
        // same kind gets a suffix instead of shadowing the provider's own.
        existing: settingsStore.services,
        defaultType: type,
      ),
    );
    if (draft == null) return;

    try {
      await runtime.settings().updateService(
        serviceId: draft.id,
        providerId: draft.providerId,
        serviceType: draft.type,
        name: draft.name,
        fields: draft.fields,
      );
      await settingsStore.reloadServices();
    } catch (error) {
      // The runtime refuses a service it cannot construct — a bad key, an
      // endpoint it cannot reach. Say so on the page rather than dropping the
      // failure on the floor.
      if (mounted) setState(() => _errorMessage = error.toString());
    }
  }

  /// Which service currently runs for a capability. The default is marked on
  /// the roster rather than chosen from a picker above it: a dropdown would
  /// restate the list it draws from, and "which one runs" is a property of a
  /// service, not a separate setting.
  String _defaultOf(ServiceType type) {
    final general = settingsStore.general;
    return switch (type) {
      ServiceType.translation => general.defaultTranslationService,
      ServiceType.dictionary => general.defaultDirectoryService,
      ServiceType.ocr => general.defaultOcrService,
      ServiceType.llm => '',
    };
  }

  Future<void> _setDefault(ServiceType type, String serviceId) async {
    final id = providerIdOfService(serviceId);
    final patch = switch (type) {
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

  /// The capability's own options — what 常规 used to carry under 文字识别 and
  /// 翻译, now sitting with the services they configure.
  List<Widget> _behaviourSections(ServiceType type) {
    final general = t.settings.general;
    final settings = settingsStore.general;

    switch (type) {
      case ServiceType.ocr:
        return [
          PreferenceSection(
            label: Text(general.section.ocr_behaviour),
            children: [
              PreferenceRow(
                title: Text(general.row.auto_copy_detected_text),
                trailing: [
                  Switch(
                    checked: settings.autoCopyDetectedText,
                    semanticsLabel: general.row.auto_copy_detected_text,
                    onChanged: (v) => settingsStore.updateGeneral(
                      GeneralSettingsPatch(autoCopyDetectedText: v),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ];
      case ServiceType.translation:
        return [
          PreferenceSection(
            label: Text(general.section.translation_behaviour),
            children: [
              PreferenceRow(
                title: Text(general.row.double_click_copy_result),
                trailing: [
                  Switch(
                    checked: settings.doubleClickCopyResult,
                    semanticsLabel: general.row.double_click_copy_result,
                    onChanged: (v) => settingsStore.updateGeneral(
                      GeneralSettingsPatch(doubleClickCopyResult: v),
                    ),
                  ),
                ],
              ),
              PreferenceRow(
                title: Text(general.row.common_languages),
                subtitle: Text(general.row.common_languages_hint),
                trailing: [
                  Text(
                    '${settings.commonLanguages.length}'
                    ' / ${supportedLanguages.length}',
                    style: context.typography.sansStyle(
                      fontSize: 12,
                      height: 1,
                      color: context.colors.fgSubtle,
                    ),
                  ),
                  Button(
                    variant: ButtonVariant.quiet,
                    onPressed: () => showCommonLanguagesDialog(context),
                    child: Text(t.common.ui.button.edit),
                  ),
                ],
              ),
            ],
          ),
          PreferenceSection(
            label: Text(general.section.translation_target),
            action: Button(
              variant: ButtonVariant.quiet,
              onPressed: () => showAddTargetDialog(context),
              child: Text(general.button.add_target),
            ),
            children: [
              for (final target in settings.translationTargets)
                PreferenceRow(
                  title: Text(
                    '${getSourceDisplayName(target.source)}'
                    '  →  ${getLanguageName(target.target)}',
                  ),
                  trailing: [
                    Button(
                      variant: ButtonVariant.quiet,
                      onPressed: () => showEditTargetDialog(context, target),
                      child: Text(t.common.ui.button.edit),
                    ),
                  ],
                ),
              if (settings.translationTargets.isEmpty)
                PreferenceRow(title: Text(general.row.no_translation_targets)),
            ],
          ),
        ];
      case ServiceType.dictionary:
      case ServiceType.llm:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = settingsStore.services;
    final providers = settingsStore.providers;

    // Every capability the app can serve gets a group, whether or not one is
    // configured yet: an empty group is where 添加服务 lives, and filtering it
    // out is what made adding the first service of a kind unreachable.
    // `llm` is excluded — no provider declares it in `kProviderCapabilities`,
    // so it names nothing a user could add.
    const servable = {
      ServiceType.translation,
      ServiceType.dictionary,
      ServiceType.ocr,
    };
    final types = [
      for (final type in kServiceTypeOrder)
        if (servable.contains(type)) type,
    ];

    final blocks = <Widget>[];
    for (final (index, type) in types.indexed) {
      if (index > 0) blocks.add(const SettingsSectionDivider());
      final rows = services
          .where((service) => service.type == type)
          .toList(growable: false);
      blocks.add(
        // A capability is a group, not a section: its roster and its options
        // are sections that happen to be about one subject. Making it a group
        // keeps every section heading the same size.
        PreferenceGroup(
          title: Text(serviceTypeLabel(type)),
          children: [
            PreferenceSection(
              label: Text(t.settings.services.section.available_services),
              // 添加服务 is raised from inside the capability's own group, so
              // the sheet opens with the kind already decided.
              action: Button(
                variant: ButtonVariant.quiet,
                enabled: providers.isNotEmpty,
                onPressed: () => _openServiceEditor(type),
                child: Text(t.settings.services.button.add_service),
              ),
              children: [
                if (rows.isEmpty)
                  PreferenceRow(
                    title: Text(
                      t.settings.general.option.no_services_available,
                    ),
                    subtitle: Text(
                      formatTranslation(
                        t.settings.services.item.none_of_kind,
                        args: [serviceTypeLabel(type)],
                      ),
                    ),
                    trailing: [
                      if (providers.isEmpty)
                        Button(
                          variant: ButtonVariant.secondary,
                          onPressed: () => context.go(
                            const ProvidersSettingsRoute().location,
                          ),
                          child: Text(t.settings.providers.button.add),
                        ),
                    ],
                  )
                else
                  for (final service in rows)
                    _ServiceRow(
                      service: service,
                      provider: providers
                          .where((entry) => entry.id == service.providerId)
                          .firstOrNull,
                      isDefault: service.id == _defaultOf(type),
                      onMakeDefault: () => _setDefault(type, service.id),
                    ),
              ],
            ),
            // Anything specific to how the feature behaves comes below the
            // services it runs on.
            ..._behaviourSections(type),
          ],
        ),
      );
    }

    return SettingsPage(
      children: [
        if (_errorMessage != null)
          Callout(
            tone: CalloutTone.danger,
            action: Button(
              variant: ButtonVariant.quiet,
              onPressed: () => setState(() => _errorMessage = null),
              child: Text(t.common.ui.button.cancel),
            ),
            child: Text(_errorMessage!),
          ),
        ...blocks,
      ],
    );
  }
}

/// One row of a capability's services — the thing that actually runs, so it
/// carries the 默认 mark beside its name.
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.provider,
    required this.isDefault,
    required this.onMakeDefault,
  });

  final ServiceConfigEntry service;
  final ProviderConfigEntry? provider;
  final bool isDefault;
  final VoidCallback onMakeDefault;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final name = service.name.isEmpty ? service.id : service.name;

    return PreferenceRow(
      icon: ProviderIcon(
        providerTypeValue(provider?.type ?? ProviderType.system),
        size: 16,
      ),
      // The badge sits with the name because it says what this service *is*,
      // not what you can do to it.
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(name, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          Text(
            service.providerId,
            style: tokens.typography.monoStyle(
              fontSize: 11,
              height: 1,
              color: colors.fgSubtle,
            ),
          ),
          if (isDefault) ...[
            const SizedBox(width: 8),
            Badge(
              size: BadgeSize.xs,
              child: Text(t.settings.providers.detail.models.default_badge),
            ),
          ],
        ],
      ),
      // 设为默认 is the doing, so it stays off the name — and it is the only
      // way to change which service runs now that the picker is gone.
      trailing: [
        if (!isDefault)
          Button(
            variant: ButtonVariant.quiet,
            onPressed: onMakeDefault,
            child: Text(t.settings.services.make_default),
          ),
      ],
    );
  }
}
