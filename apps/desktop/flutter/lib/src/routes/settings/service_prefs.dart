import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Checkbox, Dialog;
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
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

/// 翻译目标 — one source/target pair. The same sheet adds and edits: editing
/// pre-fills the pair and gains 删除, which sits at the *left* of the footer
/// because it acts on what is already there, not on what the sheet is about to
/// produce. 取消 and 保存 stay together on the right.
Future<void> _showTargetDialog(
  BuildContext context, {
  TranslationTarget? target,
}) async {
  final targets = settingsStore.general.translationTargets;
  final index = target == null ? -1 : targets.indexOf(target);
  if (target != null && index < 0) return;

  var source = target?.source ?? kAutoSource;
  var targetLang = target?.target ?? defaultTargetLanguage;
  final editing = target != null;

  final saved = await showDialogInCurrentWindow<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        final tokens = context.tokens;
        final colors = tokens.colors;
        final editor = t.settings.general.editor;

        final sameLanguage = source == targetLang;
        final duplicate = settingsStore.general.translationTargets.indexed.any(
          (entry) =>
              entry.$1 != index &&
              entry.$2.source == source &&
              entry.$2.target == targetLang,
        );
        final canSave = !sameLanguage && !duplicate;

        return Center(
          child: Dialog(
            width: 400,
            children: [
              DialogHeader(
                title: Text(
                  editing
                      ? editor.title_edit
                      : t.settings.general.button.add_target,
                ),
                subtitle: Text(editor.subtitle),
              ),
              DialogBody(
                children: [
                  // The pair reads left to right, with the arrow on the
                  // controls' line rather than the labels'.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _LanguageField(
                          value: source,
                          label: editor.row.source_language,
                          commonLanguageCodes:
                              settingsStore.general.commonLanguages,
                          showAutoDetect: true,
                          showNative: true,
                          onChanged: (v) => setDialogState(() => source = v),
                        ),
                      ),
                      SizedBox(
                        height: 28,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            FluentIcons.arrow_right_20_regular,
                            size: 14,
                            color: colors.fgFaint,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _LanguageField(
                          value: targetLang,
                          label: editor.row.target_language,
                          commonLanguageCodes:
                              settingsStore.general.commonLanguages,
                          showNative: true,
                          onChanged: (v) =>
                              setDialogState(() => targetLang = v),
                        ),
                      ),
                    ],
                  ),
                  if (sameLanguage)
                    Callout(
                      tone: CalloutTone.warn,
                      child: Text(editor.same_language),
                    )
                  else if (duplicate)
                    Callout(
                      tone: CalloutTone.warn,
                      child: Text(editor.duplicate),
                    )
                  else
                    // Not a warning — what the pair will actually do, said
                    // plainly, so the sheet is readable before it is committed.
                    Text(
                      source == kAutoSource
                          ? formatTranslation(
                              editor.hint_auto,
                              args: [getLanguageName(targetLang)],
                            )
                          : formatTranslation(
                              editor.hint_source,
                              args: [
                                getSourceDisplayName(source),
                                getLanguageName(targetLang),
                              ],
                            ),
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        height: 1.7,
                        color: colors.fgSubtle,
                      ),
                    ),
                ],
              ),
              DialogFooter(
                children: [
                  if (editing)
                    Button(
                      variant: ButtonVariant.warning,
                      onPressed: () async {
                        final next = [
                          ...settingsStore.general.translationTargets
                        ]..removeAt(index);
                        await settingsStore.updateGeneral(
                          GeneralSettingsPatch(translationTargets: next),
                        );
                        if (context.mounted) Navigator.pop(context, false);
                      },
                      child: Text(t.common.ui.button.delete),
                    ),
                  const Spacer(),
                  Button(
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.md,
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(t.common.ui.button.cancel),
                  ),
                  Button(
                    variant: ButtonVariant.primary,
                    size: ButtonSize.md,
                    enabled: canSave,
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      editing
                          ? t.common.ui.button.save
                          : t.common.ui.button.add,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  if (saved != true) return;

  final next = [...settingsStore.general.translationTargets];
  final entry = TranslationTarget(
    source: source,
    target: targetLang,
    enabled: true,
  );
  if (editing) {
    next[index] = entry;
  } else {
    next.add(entry);
  }
  await settingsStore.updateGeneral(
    GeneralSettingsPatch(translationTargets: next),
  );
}

Future<void> showAddTargetDialog(BuildContext context) =>
    _showTargetDialog(context);

Future<void> showEditTargetDialog(
  BuildContext context,
  TranslationTarget target,
) =>
    _showTargetDialog(context, target: target);

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

/// The language menu that is up, or the last one that was — released on the
/// next open rather than on close, for the reason [_openLanguageMenu] gives.
nativeapi.Menu? _liveLanguageMenu;
List<nativeapi.MenuItem> _liveLanguageItems = const [];

void _releaseLanguageMenu() {
  for (final item in _liveLanguageItems) {
    item.dispose();
  }
  _liveLanguageItems = const [];
  _liveLanguageMenu?.dispose();
  _liveLanguageMenu = null;
}

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

    // Deliberately *not* torn down on close: AppKit closes the menu before it
    // fires the item's action, and disposing a MenuItem drops it from the
    // table the click callback looks itself up in — so releasing here would
    // swallow the very selection that closed the menu. The previous menu is
    // released on the next open instead.
    _releaseLanguageMenu();
    _liveLanguageMenu = menu;
    _liveLanguageItems = menuItems;

    menu.open(
      nativeapi.PositioningStrategy.relativeToWindow(window, offset),
      nativeapi.Placement.bottomStart,
    );
  }
}

/// Opens a native menu for service selection.
