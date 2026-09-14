import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show runtime;
import '../../services/settings_store.dart';
import '../../theme/product_tokens.dart' show ProductTypography;
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        Button,
        ButtonTint,
        ButtonVariant,
        Callout,
        CalloutTint,
        DialogTone,
        HoverRegion,
        PreferenceGroup,
        PreferenceRow,
        PreferenceSection,
        Switch,
        ThemeDataBuildContextProps,
        WidgetSize;
import 'add_service_dialog.dart';
import 'index.dart';
import 'provider_catalog.dart';
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
        // The built-in provider's services are fixed, so it is not on offer.
        providers: configurableProviders(settingsStore.providers),
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
          title: formatTranslation(
            t.settings.services.detail.delete_dialog.title,
            args: [entry.name.isEmpty ? entry.id : entry.name],
          ),
          content: Text(t.settings.services.detail.delete_dialog.message),
          actions: [
            Button(
                variant: ButtonVariant.normal,
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(t.common.ui.button.cancel)),
            Button(
                variant: ButtonVariant.tinted,
                tint: ButtonTint.warning,
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(t.common.ui.button.delete)),
          ]),
    );
    if (confirmed != true) return;

    try {
      await runtime.settings().deleteService(serviceId: entry.id);
      await settingsStore.reloadServices();
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    }
  }

  /// A switch that fails to write says so on the page rather than snapping
  /// back without a word.
  Future<void> _setEnabled(ServiceConfigEntry service, bool enabled) async {
    try {
      await setServiceEnabled(service, enabled);
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    }
  }

  /// The capability's own options — what 常规 used to carry under 文字识别 and
  /// 翻译, now sitting with the services they configure.
  List<Widget> _behaviourSections(ServiceType type) {
    final general = t.settings.general;
    final settings = settingsStore.general;

    switch (type) {
      case ServiceType.ocr:
        return [
          PreferenceSection(label: general.section.ocr_behaviour, children: [
            PreferenceRow(
                title: general.row.auto_copy_detected_text,
                trailing: Switch(
                    value: settings.autoCopyDetectedText,
                    onChanged: (v) => settingsStore.updateGeneral(
                          GeneralSettingsPatch(autoCopyDetectedText: v),
                        ))),
            // Capture is what the grants on 常规 are for, so a missing one is
            // said where the feature is configured, with the way there.
            if (kIsMacOS) const _PermissionsMissingRow(),
          ]),
        ];
      case ServiceType.translation:
        return [
          // 常用语言 is a section of its own: it is an ordered list, not a
          // switch — under 翻译行为 its 编辑 would read as one more behaviour.
          PreferenceSection(
              label: general.row.common_languages,
              action: Button(
                  variant: ButtonVariant.plain,
                  onPressed: () => showCommonLanguagesDialog(context),
                  child: Text(t.common.ui.button.edit)),
              footer: general.row.common_languages_hint,
              children: [
                _CommonLanguageStrip(codes: settings.commonLanguages),
              ]),
          PreferenceSection(
              label: general.section.translation_target,
              children: [
                for (final (index, target)
                    in settings.translationTargets.indexed)
                  PreferenceRow(
                      // The kit's row prints its own title; a target that is
                      // switched off is told apart by its switch, which is the
                      // control that turned it off.
                      title: '${getSourceDisplayName(target.source)}'
                          ' → ${getLanguageName(target.target)}',
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        Button(
                            variant: ButtonVariant.plain,
                            onPressed: () =>
                                showEditTargetDialog(context, target),
                            child: Text(t.common.ui.button.edit)),
                        const SizedBox(width: 10),
                        Switch(
                            value: target.enabled,
                            onChanged: canToggleTranslationTarget(
                              settings.translationTargets,
                              index,
                            )
                                ? (value) =>
                                    setTranslationTargetEnabled(index, value)
                                : null),
                      ])),
                if (settings.translationTargets.isEmpty)
                  Text(
                    general.row.no_translation_targets,
                    style: context.vars.sansStyle(
                      fontSize: 12,
                      height: 1,
                      color: context.vars.colorContentFaint,
                    ),
                  ),
                _AddRow(
                  title: general.button.add_target,
                  onOpen: () => showAddTargetDialog(context),
                ),
              ]),
          // 翻译行为 comes after the targets: what is left is what happens once
          // a translation is in hand, which reads better after the rules.
          PreferenceSection(
              label: general.section.translation_behaviour,
              children: [
                PreferenceRow(
                    title: general.row.double_click_copy_result,
                    trailing: Switch(
                        value: settings.doubleClickCopyResult,
                        onChanged: (v) => settingsStore.updateGeneral(
                              GeneralSettingsPatch(doubleClickCopyResult: v),
                            ))),
              ]),
        ];
      case ServiceType.dictionary:
      case ServiceType.llm:
        return const [];
    }
  }

  /// What a capability is called on this page — 翻译 / 查词 / 文字识别, the
  /// names of the features. The provider capsules keep their terser
  /// 词典 / OCR, where they sit three to a row.
  String _capabilityTitle(ServiceType type) {
    final capability = t.settings.services.capability;
    return switch (type) {
      ServiceType.translation => capability.translation,
      ServiceType.dictionary => capability.dictionary,
      ServiceType.ocr => capability.ocr,
      ServiceType.llm => serviceTypeLabel(type),
    };
  }

  @override
  Widget build(BuildContext context) {
    final services = settingsStore.services;
    // Only a configured provider can take another service; the built-in one
    // already lists its fixed rows.
    final providers = configurableProviders(settingsStore.providers);

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
          title: _capabilityTitle(type),
          children: [
            PreferenceSection(
              label: t.settings.services.section.available_services,
              children: [
                if (rows.isEmpty)
                  PreferenceRow(
                      title: t.settings.general.option.no_services_available,
                      subtitle: formatTranslation(
                        t.settings.services.item.none_of_kind,
                        args: [_capabilityTitle(type)],
                      ))
                else
                  for (final service in rows)
                    _ServiceRow(
                      service: service,
                      provider: providers
                          .where((entry) => entry.id == service.providerId)
                          .firstOrNull,
                      isDefault: isDefaultService(service),
                      enabled: isServiceEnabled(service),
                      onMakeDefault: () => makeDefaultService(service),
                      onEnabledChange: (value) => _setEnabled(service, value),
                      // A built-in service has nothing to edit and cannot be
                      // deleted, so the row offers neither.
                      onEdit: isBuiltinService(service)
                          ? null
                          : () => _openServiceEditor(type, existing: service),
                    ),
                // 添加服务 is the roster's last row rather than a button beside
                // the heading: what it adds are the rows above it, so the way
                // out sits where the eye ends up running down the list — and
                // an empty list needs no second button of its own. It is raised
                // from inside the capability, so the sheet opens with the kind
                // already decided.
                if (providers.isNotEmpty)
                  _AddRow(
                    title: t.settings.services.button.add_service,
                    onOpen: () => _openServiceEditor(type),
                  )
                else
                  // No provider can derive a service yet, so there is nothing
                  // to add here: the row becomes the way to the page that can.
                  PreferenceRow(
                    title: t.settings.services.go_to_providers,
                    subtitle: t.settings.services.go_to_providers_hint,
                    trailing: const _Chevron(),
                    onPressed: () =>
                        context.go(const ProvidersSettingsRoute().location),
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
              tint: CalloutTint.danger,
              actions: [
                Button(
                    variant: ButtonVariant.plain,
                    onPressed: () => setState(() => _errorMessage = null),
                    child: Text(t.common.ui.button.cancel))
              ],
              message: Text(_errorMessage!)),
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

  /// Null for a fixed service — the built-in ones — which has no editor.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final name = serviceDisplayName(service);

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
                    provider?.type ?? ProviderType.system,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: vars.sansStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        // A service that is switched off still reads, but it
                        // stops competing with the ones that are running.
                        color: enabled
                            ? vars.colorContent
                            : vars.colorContentFaint,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      service.providerId,
                      overflow: TextOverflow.ellipsis,
                      style: vars.monoStyle(
                        fontSize: 11,
                        height: 1,
                        color: vars.colorContentSubtle,
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
              duration: context.vars.motionDuration,
              opacity: hovered ? 1 : 0,
              child: IgnorePointer(
                ignoring: !hovered,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Only a service that is on can be the one that runs.
                    if (!isDefault && enabled) ...[
                      Button(
                          variant: ButtonVariant.plain,
                          onPressed: onMakeDefault,
                          size: WidgetSize.tiny,
                          child: Text(t.settings.services.make_default)),
                      if (onEdit != null) const SizedBox(width: 10),
                    ],
                    if (onEdit != null)
                      Button(
                          variant: ButtonVariant.plain,
                          onPressed: onEdit,
                          child: Text(t.common.ui.button.edit)),
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
                  size: WidgetSize.tiny,
                  child: Text(t.settings.providers.detail.models.default_badge))
            else
              Switch(value: enabled, onChanged: onEnabledChange),
          ],
        ),
      ),
    );
  }
}

/// The chosen languages, read left to right in the order the menus print them.
///
/// The row used to carry a bare 6 / 32, which is the least a row can say about
/// a list: it named a size and left the contents — and their order, the whole
/// point of the setting — behind a click. The strip is the menu's own top
/// block, shown in the row that configures it.
class _CommonLanguageStrip extends StatelessWidget {
  const _CommonLanguageStrip({required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;

    if (codes.isEmpty) {
      return Text(
        t.settings.general.row.common_languages_empty(
          count: supportedLanguages.length,
        ),
        style: vars.sansStyle(
          fontSize: 11,
          height: 1,
          color: vars.colorContentFaint,
        ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final code in getCommonLanguages(codes))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: vars.colorSurfaceInset,
              borderRadius: BorderRadius.circular(vars.radiusSmall),
            ),
            child: Text(
              getLanguageNativeName(code),
              style: vars.sansStyle(
                fontSize: 11,
                height: 1,
                fontWeight: FontWeight.w500,
                color: vars.colorContentMuted,
              ),
            ),
          ),
      ],
    );
  }
}

/// The last row of a list: the way to add one more of what is above it.
///
/// Shared by 可用服务 and 翻译目标, which are the same shape — a roster whose
/// exit belongs to the roster rather than to a button beside its heading.
class _AddRow extends StatelessWidget {
  const _AddRow({required this.title, required this.onOpen});

  final String title;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return PreferenceRow(
      icon: Icon(
        FluentIcons.add_20_regular,
        size: 16,
        color: context.vars.colorContentSubtle,
      ),
      title: title,
      trailing: const _Chevron(),
      onPressed: onOpen,
    );
  }
}

/// The `›` an opening row ends on. The React row draws it for any row that
/// opens something; the Flutter kit leaves it to the caller.
class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Text('›', style: vars.labelQuiet.copyWith(color: vars.colorContent));
  }
}

/// 尚未授予系统权限 — shown under 取词行为 while either grant capture needs is
/// missing, with the way to 常规, where the grants live.
class _PermissionsMissingRow extends StatefulWidget {
  const _PermissionsMissingRow();

  @override
  State<_PermissionsMissingRow> createState() => _PermissionsMissingRowState();
}

class _PermissionsMissingRowState extends State<_PermissionsMissingRow> {
  bool _missing = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final permission = runtime.permission();
    final granted = await permission.isScreenRecordingPermissionGranted() &&
        await permission.isAccessibilityPermissionGranted();
    if (mounted) setState(() => _missing = !granted);
  }

  @override
  Widget build(BuildContext context) {
    if (!_missing) return const SizedBox.shrink();
    final copy = t.settings.services.permissions_missing;
    return PreferenceRow(
      title: copy.title,
      subtitle: copy.hint,
      trailing: Button(
        variant: ButtonVariant.normal,
        onPressed: () => context.go(const GeneralSettingsRoute().location),
        child: Text(copy.open_general),
      ),
    );
  }
}
