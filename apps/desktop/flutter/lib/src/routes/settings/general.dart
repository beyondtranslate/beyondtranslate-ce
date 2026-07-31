import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Checkbox;
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show runtime;
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        Checkbox,
        DesignThemeContext,
        DesignTypographyStyles,
        Field,
        FieldState,
        Pressable,
        controlDecoration;

/// Mirrors macOS `GeneralView.swift`.
class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  /// When set to true before the page is opened, the common languages
  /// dialog will auto-open once the page is built. Set by
  /// [MiniTranslatorPageState._handleManageCommonLanguages].
  static bool pendingOpenCommonLanguages = false;

  /// When set to true before the page is opened, the add target dialog
  /// will auto-open once the page is built. Set by
  /// [MiniTranslatorPageState._handleAddTarget].
  static bool pendingOpenAddTarget = false;

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    // Refresh when entering the page.
    settingsStore.reloadGeneral();
    settingsStore.reloadProviders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (GeneralSettingsPage.pendingOpenCommonLanguages) {
      GeneralSettingsPage.pendingOpenCommonLanguages = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCommonLanguagesDialog(context);
      });
    }

    if (GeneralSettingsPage.pendingOpenAddTarget) {
      GeneralSettingsPage.pendingOpenAddTarget = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddTargetDialog(context);
      });
    }
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  GeneralSettings get _general => settingsStore.general;

  // Service options. The id is the service id consumed by the runtime.
  List<_ServiceOption> get _ocrServiceOptions {
    return [
      _ServiceOption(
          id: 'builtin', name: t.settings.general.option.built_in_ocr),
      _ServiceOption(
          id: 'tesseract', name: t.settings.general.option.tesseract),
      _ServiceOption(id: 'youdao', name: t.settings.general.option.youdao_ocr),
    ];
  }

  List<_ServiceOption> get _dictionaryServiceOptions {
    return settingsStore.services
        .where((service) => service.type == ServiceType.dictionary)
        .map((service) => _ServiceOption(
              id: service.id,
              name: service.name.isEmpty ? service.id : service.name,
            ))
        .toList();
  }

  List<_ServiceOption> get _translationServiceOptions {
    return settingsStore.services
        .where((service) => service.type == ServiceType.translation)
        .map((service) => _ServiceOption(
              id: service.id,
              name: service.name.isEmpty ? service.id : service.name,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final general = t.settings.general;
    final hasDirectoryServices = _dictionaryServiceOptions.isNotEmpty;
    final hasTranslationServices = _translationServiceOptions.isNotEmpty;

    return SettingsPage(
      children: [
        PreferenceListSection(
          children: [
            PreferenceListSwitchItem(
              title: Text(general.row.launch_at_login),
              value: _general.launchAtLogin,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(launchAtLogin: v),
                );
              },
            ),
            PreferenceListSwitchItem(
              title: Text(general.row.show_in_menu_bar),
              value: _general.showInMenuBar,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(showInMenuBar: v),
                );
              },
            ),
          ],
        ),
        if (kIsMacOS)
          PreferenceListSection(
            title: Text(general.section.permissions),
            children: [
              _PermissionAccessRow(
                title: general.row.screen_capture_access,
                accessibility: false,
              ),
              _PermissionAccessRow(
                title: general.row.screen_selection_access,
                accessibility: true,
              ),
            ],
          ),
        PreferenceListSection(
          title: Text(general.section.ocr),
          children: [
            _ServicePickerItem(
              title: general.row.default_ocr_service,
              options: _ocrServiceOptions,
              value: _providerId(_general.defaultOcrService),
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(defaultOcrService: _providerId(v)),
                );
              },
            ),
            PreferenceListSwitchItem(
              title: Text(general.row.auto_copy_detected_text),
              value: _general.autoCopyDetectedText,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(autoCopyDetectedText: v),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(general.section.directory),
          children: [
            if (hasDirectoryServices)
              _ServicePickerItem(
                title: general.row.default_directory_service,
                options: _dictionaryServiceOptions,
                value: _providerId(_general.defaultDirectoryService),
                onChanged: (v) async {
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(
                      defaultDirectoryService: _providerId(v),
                    ),
                  );
                },
              )
            else
              _ServiceUnavailableItem(
                title: general.row.default_directory_service,
                onAddProvider: () => context.go('/settings/providers'),
              ),
          ],
        ),
        PreferenceListSection(
          title: Text(general.section.translation),
          children: [
            if (hasTranslationServices)
              _ServicePickerItem(
                title: general.row.default_translation_service,
                options: _translationServiceOptions,
                value: _providerId(_general.defaultTranslationService),
                onChanged: (v) async {
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(
                      defaultTranslationService: _providerId(v),
                    ),
                  );
                },
              )
            else
              _ServiceUnavailableItem(
                title: general.row.default_translation_service,
                onAddProvider: () => context.go('/settings/providers'),
              ),
            PreferenceListSwitchItem(
              title: Text(general.row.double_click_copy_result),
              value: _general.doubleClickCopyResult,
              disabled: !hasTranslationServices,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(doubleClickCopyResult: v),
                );
              },
            ),
            PreferenceListItem(
              title: Text(general.row.common_languages),
              summary: Text(
                '${_general.commonLanguages.length} / ${supportedLanguages.length}',
              ),
              onTap: () => _showCommonLanguagesDialog(context),
              detailText: Text(
                t.common.ui.button.edit,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        if (hasTranslationServices)
          PreferenceListSection(
            title: Text(general.section.translation_target),
            children: [
              for (final target in _general.translationTargets)
                PreferenceListItem(
                  title: Row(
                    children: [
                      Text(getSourceDisplayName(target.source)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, size: 16),
                      ),
                      Text(getLanguageName(target.target)),
                    ],
                  ),
                  detailText: Button(
                    variant: ButtonVariant.quiet,
                    onPressed: () => _showEditTargetDialog(context, target),
                    child: Text(t.common.ui.button.edit),
                  ),
                ),
              if (_general.translationTargets.isEmpty)
                PreferenceListItem(
                  title: Text(
                    'No translation targets configured.',
                    style: context.typography.sansStyle(
                      color: context.colors.fgSubtle,
                    ),
                  ),
                ),
              PreferenceListItem(
                title: Button(
                  variant: ButtonVariant.quiet,
                  onPressed: () => _showAddTargetDialog(context),
                  child: Text(general.button.add_target),
                ),
                accessoryView: const SizedBox.shrink(),
              ),
            ],
          ),
        PreferenceListSection(
          title: Text(general.section.input),
          children: [
            for (final mode in InputSubmitMode.values)
              PreferenceListRadioItem<InputSubmitMode>(
                title: Text(_inputSubmitModeTitle(context, mode)),
                value: mode,
                groupValue: _general.inputSubmitMode,
                onChanged: (v) async {
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(inputSubmitMode: v),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _showAddTargetDialog(BuildContext context) async {
    String source = kAutoSource;
    String target = defaultTargetLanguage;

    final result = await showDialogInCurrentWindow<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: Text(t.settings.general.button.add_target),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LanguageField(
                    value: source,
                    label: t.settings.general.editor.row.source_language,
                    commonLanguageCodes: _general.commonLanguages,
                    showAutoDetect: true,
                    showNative: true,
                    onChanged: (v) => setDialogState(() => source = v),
                  ),
                  const SizedBox(height: 12),
                  _LanguageField(
                    value: target,
                    label: t.settings.general.editor.row.target_language,
                    commonLanguageCodes: _general.commonLanguages,
                    showNative: true,
                    onChanged: (v) => setDialogState(() => target = v),
                  ),
                ],
              ),
              actions: [
                Button(
                  variant: ButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(t.common.ui.button.cancel),
                ),
                Button(
                  variant: ButtonVariant.primary,
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(t.common.ui.button.ok),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final newTargets = [
        ..._general.translationTargets,
        TranslationTarget(
          source: source,
          target: target,
          enabled: true,
        ),
      ];
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(translationTargets: newTargets),
      );
    }
  }

  Future<void> _showEditTargetDialog(
      BuildContext context, TranslationTarget target) async {
    final index = _general.translationTargets.indexOf(target);
    if (index < 0) return;

    String source = target.source;
    String targetLang = target.target;

    final result = await showDialogInCurrentWindow<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: Text(t.common.ui.button.edit),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LanguageField(
                    value: source,
                    label: t.settings.general.editor.row.source_language,
                    commonLanguageCodes: _general.commonLanguages,
                    showAutoDetect: true,
                    showNative: true,
                    onChanged: (v) => setDialogState(() => source = v),
                  ),
                  const SizedBox(height: 12),
                  _LanguageField(
                    value: targetLang,
                    label: t.settings.general.editor.row.target_language,
                    commonLanguageCodes: _general.commonLanguages,
                    showNative: true,
                    onChanged: (v) => setDialogState(() => targetLang = v),
                  ),
                ],
              ),
              actions: [
                Button(
                  variant: ButtonVariant.warning,
                  onPressed: () async {
                    final newTargets = [..._general.translationTargets];
                    newTargets.removeAt(index);
                    await settingsStore.updateGeneral(
                      GeneralSettingsPatch(translationTargets: newTargets),
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(t.common.ui.button.delete),
                ),
                Button(
                  variant: ButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.common.ui.button.cancel),
                ),
                Button(
                  variant: ButtonVariant.primary,
                  onPressed: () => Navigator.pop(context, 'save'),
                  child: Text(t.common.ui.button.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == 'save') {
      final newTargets = [..._general.translationTargets];
      newTargets[index] = TranslationTarget(
        source: source,
        target: targetLang,
        enabled: true,
      );
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(translationTargets: newTargets),
      );
    }
  }

  Future<void> _showCommonLanguagesDialog(BuildContext context) async {
    final selected = Set<String>.from(_general.commonLanguages);
    final available = supportedLanguages;

    final result = await showDialogInCurrentWindow<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              width: 380,
              title: Text(t.settings.general.row.common_languages),
              subtitle: Text(t.settings.general.row.common_languages_hint),
              content: SizedBox(
                height: 360,
                child: ListView(
                  children: [
                    for (final lang in available)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Checkbox(
                          checked: selected.contains(lang),
                          onChanged: (checked) {
                            setDialogState(() {
                              if (checked) {
                                selected.add(lang);
                              } else {
                                selected.remove(lang);
                              }
                            });
                          },
                          child: Text(getLanguageName(lang, showNative: true)),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                Button(
                  variant: ButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.common.ui.button.cancel),
                ),
                Button(
                  variant: ButtonVariant.primary,
                  onPressed: () => Navigator.pop(context, selected.toList()),
                  child: Text(t.common.ui.button.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(commonLanguages: result),
      );
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Native dropdown helpers
// ──────────────────────────────────────────────────────────────────────────────

/// A language picker field that opens a native menu with grouped languages.
class _LanguageField extends StatelessWidget {
  const _LanguageField({
    required this.value,
    required this.label,
    required this.commonLanguageCodes,
    this.showAutoDetect = false,
    this.showNative = false,
    required this.onChanged,
  });

  final String value;
  final String label;
  final List<String> commonLanguageCodes;
  final bool showAutoDetect;
  final bool showNative;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.control);

    return Field(
      label: Text(label),
      child: Pressable(
        onPressed: () => _openLanguageMenu(context),
        borderRadius: radius,
        semanticsLabel: label,
        builder: (context, state) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: controlDecoration(
            tokens,
            state: FieldState.standard,
            focused: state.focused,
            hairline: context.hairlineWidth,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedLabel(),
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.sansStyle(
                    fontSize: 12,
                    height: 1,
                    color: colors.fg,
                  ),
                ),
              ),
              Icon(
                FluentIcons.chevron_down_20_regular,
                size: 13,
                color: colors.fgSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _selectedLabel() {
    if (showAutoDetect && value == kAutoSource) {
      return t.mini_translator.language.auto_detect;
    }
    return getLanguageName(value, showNative: showNative);
  }

  void _openLanguageMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final offset = Offset(position.dx, position.dy + renderBox.size.height);

    final window = nativeapi.WindowManager.instance.getCurrent();
    if (window == null) return;

    final menu = nativeapi.Menu();
    final menuItems = <nativeapi.MenuItem>[];
    final itemIds = <int, String>{};

    // Auto detect
    if (showAutoDetect) {
      final item = nativeapi.MenuItem(t.mini_translator.language.auto_detect);
      menuItems.add(item);
      itemIds[item.id] = kAutoSource;
      item.on<nativeapi.MenuItemClickedEvent>((e) {
        final v = itemIds[e.menuItemId];
        if (v != null) onChanged(v);
      });
      menu.addItem(item);
    }

    // Common languages
    final common = getCommonLanguages(commonLanguageCodes);
    for (final lang in common) {
      final item = nativeapi.MenuItem(
        getLanguageName(lang, showNative: showNative),
      );
      menuItems.add(item);
      itemIds[item.id] = lang;
      item.on<nativeapi.MenuItemClickedEvent>((e) {
        final v = itemIds[e.menuItemId];
        if (v != null) onChanged(v);
      });
      menu.addItem(item);
    }

    // Other languages
    final other = getOtherLanguages(commonLanguageCodes);
    if (other.isNotEmpty && common.isNotEmpty) {
      menu.addSeparator();
    }
    for (final lang in other) {
      final item = nativeapi.MenuItem(
        getLanguageName(lang, showNative: showNative),
      );
      menuItems.add(item);
      itemIds[item.id] = lang;
      item.on<nativeapi.MenuItemClickedEvent>((e) {
        final v = itemIds[e.menuItemId];
        if (v != null) onChanged(v);
      });
      menu.addItem(item);
    }

    // Clean up after close
    late int closeListenerId;
    closeListenerId = menu.on<nativeapi.MenuClosedEvent>((_) {
      menu.off(closeListenerId);
      for (final mi in menuItems) {
        mi.dispose();
      }
      menu.dispose();
    });

    menu.open(
      nativeapi.PositioningStrategy.relativeToWindow(window, offset),
      nativeapi.Placement.bottomStart,
    );
  }
}

/// Opens a native menu for service selection.
void _openServiceMenu(
  BuildContext context, {
  required List<String> items,
  required Map<String, String> labels,
  required String currentValue,
  required ValueChanged<String> onSelected,
}) {
  final renderBox = context.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) return;

  final position = renderBox.localToGlobal(Offset.zero);
  final offset = Offset(position.dx, position.dy + renderBox.size.height);

  final window = nativeapi.WindowManager.instance.getCurrent();
  if (window == null) return;

  final menu = nativeapi.Menu();
  final menuItems = <nativeapi.MenuItem>[];
  final itemIds = <int, String>{};

  for (final item in items) {
    final menuItem = nativeapi.MenuItem(labels[item] ?? item);
    menuItems.add(menuItem);
    itemIds[menuItem.id] = item;
    menuItem.on<nativeapi.MenuItemClickedEvent>((e) {
      final v = itemIds[e.menuItemId];
      if (v != null) onSelected(v);
    });
    menu.addItem(menuItem);
  }

  late int closeListenerId;
  closeListenerId = menu.on<nativeapi.MenuClosedEvent>((_) {
    menu.off(closeListenerId);
    for (final mi in menuItems) {
      mi.dispose();
    }
    menu.dispose();
  });

  menu.open(
    nativeapi.PositioningStrategy.relativeToWindow(window, offset),
    nativeapi.Placement.bottomStart,
  );
}

String _providerId(String serviceId) {
  for (final suffix in const ['+translation', '+dictionary', '+ocr']) {
    if (serviceId.endsWith(suffix)) {
      return serviceId.substring(0, serviceId.length - suffix.length);
    }
  }
  return serviceId;
}

String _inputSubmitModeTitle(BuildContext context, InputSubmitMode mode) {
  switch (mode) {
    case InputSubmitMode.enter:
      return t.settings.general.row.submit_with_enter;
    case InputSubmitMode.commandEnter:
      return t.settings.general.row.submit_with_meta_enter_mac;
  }
}

class _ServiceOption {
  const _ServiceOption({required this.id, required this.name});
  final String id;
  final String name;
}

class _ServicePickerItem extends StatelessWidget {
  const _ServicePickerItem({
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final List<_ServiceOption> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <String>[''];
    final labels = <String, String>{'': t.settings.general.option.none};
    for (final opt in options) {
      items.add(opt.id);
      labels[opt.id] = opt.name;
    }

    // If the persisted value is not present in the options, keep it
    final hasValue = value.isEmpty || options.any((o) => o.id == value);
    if (!hasValue) {
      items.add(value);
      labels[value] = value;
    }

    return PreferenceListItem(
      title: Text(title),
      detailText: options.isEmpty
          ? Text(t.settings.general.option.no_services_available)
          : GestureDetector(
              onTap: () => _openServiceMenu(
                context,
                items: items,
                labels: labels,
                currentValue: value,
                onSelected: onChanged,
              ),
              child: Text(
                labels[value] ?? value,
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
    );
  }
}

class _ServiceUnavailableItem extends StatelessWidget {
  const _ServiceUnavailableItem({
    required this.title,
    required this.onAddProvider,
  });

  final String title;
  final VoidCallback onAddProvider;

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text(title),
      detailText: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t.settings.general.option.no_services_available),
          const SizedBox(width: 8),
          Button(
            variant: ButtonVariant.secondary,
            onPressed: onAddProvider,
            child: Text(t.settings.general.button.add_provider),
          ),
        ],
      ),
    );
  }
}

class _PermissionAccessRow extends StatefulWidget {
  const _PermissionAccessRow({
    required this.title,
    required this.accessibility,
  });

  final String title;
  final bool accessibility;

  @override
  State<_PermissionAccessRow> createState() => _PermissionAccessRowState();
}

class _PermissionAccessRowState extends State<_PermissionAccessRow> {
  bool? _granted;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final permission = runtime.permission();
    final granted = widget.accessibility
        ? await permission.isAccessibilityPermissionGranted()
        : await permission.isScreenRecordingPermissionGranted();
    if (mounted) setState(() => _granted = granted);
  }

  Future<void> _request() async {
    final permission = runtime.permission();
    if (widget.accessibility) {
      await permission.requestAccessibilityPermission(
        onlyOpenSystemSettings: false,
      );
    } else {
      await permission.requestScreenRecordingPermission(
        onlyOpenSystemSettings: false,
      );
    }
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text(widget.title),
      detailText: Button(
        variant: ButtonVariant.secondary,
        onPressed: _granted == true ? _refresh : _request,
        child: Text(
          _granted == true
              ? t.settings.general.option.granted
              : t.settings.general.button.grant,
        ),
      ),
    );
  }
}
