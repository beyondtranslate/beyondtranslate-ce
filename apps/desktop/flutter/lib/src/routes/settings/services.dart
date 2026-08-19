import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show runtime;
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        BadgeSize,
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles,
        PreferenceGroup,
        PreferenceRow,
        PreferenceSection,
        DialogTone,
        HoverRegion,
        Switch,
        kTransitionDuration;
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

  Future<void> _openServiceEditor(
    ServiceType type, {
    ServiceConfigEntry? existing,
  }) async {
    final draft = await showDialogInCurrentWindow<ServiceDraft>(
      context: context,
      builder: (_) => AddServiceDialog(
        providers: settingsStore.providers,
        // The derived services count as taken ids, so a second service of the
        // same kind gets a suffix instead of shadowing the provider's own.
        existing: settingsStore.services,
        service: existing,
        defaultType: type,
        onDelete: existing == null ? null : () => _deleteService(existing),
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

  Future<void> _deleteService(ServiceConfigEntry entry) async {
    final confirmed = await showDialogInCurrentWindow<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        tone: DialogTone.danger,
        title: Text(
          formatTranslation(
            t.settings.services.detail.delete_dialog.title,
            args: [entry.name.isEmpty ? entry.id : entry.name],
          ),
        ),
        content: Text(t.settings.services.detail.delete_dialog.message),
        actions: [
          Button(
            variant: ButtonVariant.secondary,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.ui.button.cancel),
          ),
          Button(
            variant: ButtonVariant.warning,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.common.ui.button.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await runtime.settings().deleteService(serviceId: entry.id);
      await settingsStore.reloadServices();
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    }
  }

  /// Switching a service off stores the flag on the service itself, so it
  /// survives a restart and the translation flows can skip it.
  Future<void> _setEnabled(ServiceConfigEntry service, bool enabled) async {
    final fields = Map<String, String>.from(service.fields);
    if (enabled) {
      fields.remove(kServiceEnabledField);
    } else {
      fields[kServiceEnabledField] = 'false';
    }
    try {
      await runtime.settings().updateService(
            serviceId: service.id,
            providerId: service.providerId,
            serviceType: service.type,
            name: service.name,
            fields: fields,
          );
      await settingsStore.reloadServices();
    } catch (error) {
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
        if (servable.contains(type) && isServiceTypeVisible(type)) type,
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
                variant: ButtonVariant.primary,
                size: ButtonSize.xs,
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
                      enabled: isServiceEnabled(service),
                      onMakeDefault: () => _setDefault(type, service.id),
                      onEnabledChange: (value) => _setEnabled(service, value),
                      onEdit: () => _openServiceEditor(type, existing: service),
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
/// owns the 默认 mark, the switch, and what you can do to it.
///
/// 设为默认 and 编辑 are the doing, and they stay hidden until the pointer is on
/// the row.
/// A list of five services otherwise shows ten buttons at rest, and the eye has
/// to sort the labels from the controls before it can read the list. They keep
/// their space while hidden, so the row does not jump.
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.provider,
    required this.isDefault,
    required this.enabled,
    required this.onMakeDefault,
    required this.onEnabledChange,
    required this.onEdit,
  });

  final ServiceConfigEntry service;
  final ProviderConfigEntry? provider;
  final bool isDefault;
  final bool enabled;
  final VoidCallback onMakeDefault;
  final ValueChanged<bool> onEnabledChange;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final name = service.name.isEmpty ? service.id : service.name;

    return HoverRegion(
      builder: (context, hovered) => ConstrainedBox(
        // `min-h-7 gap-2.5` — the same floor a PreferenceRow keeps, so a
        // roster and a settings row stack to one rhythm.
        constraints: const BoxConstraints(minHeight: 28),
        child: Row(
          children: [
            // The name block takes the slack and stays left; without wrapping
            // it the row's `Flexible` children would each claim a share of the
            // free space and the trailing controls would drift off the edge.
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProviderIcon(
                    providerTypeValue(provider?.type ?? ProviderType.system),
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.sansStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        // A service that is switched off still reads, but it
                        // stops competing with the ones that are running.
                        color: enabled ? colors.fg : colors.fgFaint,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      service.providerId,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.monoStyle(
                        fontSize: 11,
                        height: 1,
                        color: colors.fgSubtle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Hidden rather than absent: the row keeps its geometry, so the
            // list does not shuffle as the pointer runs down it.
            AnimatedOpacity(
              duration: kTransitionDuration,
              opacity: hovered ? 1 : 0,
              child: IgnorePointer(
                ignoring: !hovered,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Only a service that is on can be the one that runs.
                    if (!isDefault && enabled) ...[
                      Button(
                        variant: ButtonVariant.quiet,
                        onPressed: onMakeDefault,
                        child: Text(t.settings.services.make_default),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Button(
                      variant: ButtonVariant.quiet,
                      onPressed: onEdit,
                      child: Text(t.common.ui.button.edit),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // The slot at the row's end says what state the service is in. The
            // default one cannot be switched off — you would first hand 默认 to
            // another — so a switch there would be a control with one position;
            // the badge takes its place. That also keeps the column from
            // becoming a stack of identical filled pills: one row per
            // capability reads as the anchor, the rest as things you can turn
            // on or off.
            if (isDefault)
              Badge(
                size: BadgeSize.xs,
                child: Text(t.settings.providers.detail.models.default_badge),
              )
            else
              Switch(
                checked: enabled,
                semanticsLabel: name,
                onChanged: onEnabledChange,
              ),
          ],
        ),
      ),
    );
  }
}
