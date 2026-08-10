import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Checkbox;
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
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

/// The sheets and pickers a capability's own settings open — 常用语言,
/// 翻译目标, and the service pickers behind them.
///
/// These moved off 常规 with the rows that raise them: in the deck each
/// capability owns its options end to end, on 服务.

Future<void> showAddTargetDialog(BuildContext context) async {
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
                  commonLanguageCodes: settingsStore.general.commonLanguages,
                  showAutoDetect: true,
                  showNative: true,
                  onChanged: (v) => setDialogState(() => source = v),
                ),
                const SizedBox(height: 12),
                _LanguageField(
                  value: target,
                  label: t.settings.general.editor.row.target_language,
                  commonLanguageCodes: settingsStore.general.commonLanguages,
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
      ...settingsStore.general.translationTargets,
      TranslationTarget(source: source, target: target, enabled: true),
    ];
    await settingsStore.updateGeneral(
      GeneralSettingsPatch(translationTargets: newTargets),
    );
  }
}

Future<void> showEditTargetDialog(
  BuildContext context,
  TranslationTarget target,
) async {
  final index = settingsStore.general.translationTargets.indexOf(target);
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
                  commonLanguageCodes: settingsStore.general.commonLanguages,
                  showAutoDetect: true,
                  showNative: true,
                  onChanged: (v) => setDialogState(() => source = v),
                ),
                const SizedBox(height: 12),
                _LanguageField(
                  value: targetLang,
                  label: t.settings.general.editor.row.target_language,
                  commonLanguageCodes: settingsStore.general.commonLanguages,
                  showNative: true,
                  onChanged: (v) => setDialogState(() => targetLang = v),
                ),
              ],
            ),
            actions: [
              Button(
                variant: ButtonVariant.warning,
                onPressed: () async {
                  final newTargets = [
                    ...settingsStore.general.translationTargets,
                  ];
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
    final newTargets = [...settingsStore.general.translationTargets];
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

Future<void> showCommonLanguagesDialog(BuildContext context) async {
  final selected = Set<String>.from(settingsStore.general.commonLanguages);
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
