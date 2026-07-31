import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../extensions/window_controller.dart';
import '../../i18n/i18n.dart';
import '../../utils/language_util.dart';
import '../../widgets/icon_action_button.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        BadgeTone,
        DesignThemeContext,
        DesignTypographyStyles,
        Pressable;
import '../app_router.dart' show miniTranslatorWindowController;

/// Opens a native context menu anchored near [buttonKey].
void _openMenu(
  GlobalKey buttonKey,
  nativeapi.Menu menu, {
  nativeapi.Placement placement = nativeapi.Placement.bottom,
  double anchorX = 0.5,
}) {
  final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) return;

  final localPosition = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;
  final anchorPosition = Offset(
    localPosition.dx + size.width * anchorX,
    localPosition.dy + size.height + 4,
  );

  menu.open(
    nativeapi.PositioningStrategy.relativeToWindow(
      miniTranslatorWindowController.window,
      anchorPosition,
    ),
    placement,
  );
}

/// Populates [menu] with common languages, a "more languages" submenu, and a
/// "manage common languages" item.
void _populateLanguageMenu(
  nativeapi.Menu menu,
  List<String> commonLanguageCodes,
  String? selectedLanguage, {
  required String Function(String) displayName,
  required void Function(String) onSelected,
  required VoidCallback onManageCommonLanguages,
}) {
  final common = getCommonLanguages(commonLanguageCodes);
  final other = getOtherLanguages(commonLanguageCodes);

  for (final lang in common) {
    final item = nativeapi.MenuItem(
      displayName(lang),
      nativeapi.MenuItemType.checkbox,
    );
    item.state = lang == selectedLanguage
        ? nativeapi.MenuItemState.checked
        : nativeapi.MenuItemState.unchecked;
    item.on<nativeapi.MenuItemClickedEvent>((_) {
      onSelected(lang);
    });
    menu.addItem(item);
  }

  if (other.isNotEmpty) {
    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    final moreMenu = nativeapi.Menu();
    for (final lang in other) {
      final item = nativeapi.MenuItem(
        displayName(lang),
        nativeapi.MenuItemType.checkbox,
      );
      item.state = lang == selectedLanguage
          ? nativeapi.MenuItemState.checked
          : nativeapi.MenuItemState.unchecked;
      item.on<nativeapi.MenuItemClickedEvent>((_) {
        onSelected(lang);
      });
      moreMenu.addItem(item);
    }

    final moreItem = nativeapi.MenuItem(
      t.mini_translator.language.more_languages,
      nativeapi.MenuItemType.submenu,
    );
    moreItem.submenu = moreMenu;
    menu.addItem(moreItem);
  }

  menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));
  final manageItem = nativeapi.MenuItem(
    t.mini_translator.language.manage_common_languages,
    nativeapi.MenuItemType.normal,
  );
  manageItem.on<nativeapi.MenuItemClickedEvent>((_) {
    onManageCommonLanguages();
  });
  menu.addItem(manageItem);
}

class MiniTranslatorLanguageBar extends StatelessWidget {
  MiniTranslatorLanguageBar({
    Key? key,
    required this.sourceLanguage,
    required this.selectedTargetLanguage,
    required this.detectedLanguage,
    required this.activeConfigIndex,
    required this.persistentTargets,
    required this.commonLanguageCodes,
    required this.onSourceChanged,
    required this.onTargetLanguageChanged,
    required this.onConfigTargetSelected,
    required this.onManageCommonLanguages,
    required this.onAddTarget,
    required this.onManageTargets,
  }) : super(key: key);

  final String sourceLanguage;
  final String? selectedTargetLanguage;
  final String? detectedLanguage;
  final int activeConfigIndex;
  final List<TranslationTarget> persistentTargets;
  final List<String> commonLanguageCodes;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String?> onTargetLanguageChanged;
  final ValueChanged<int> onConfigTargetSelected;
  final VoidCallback onManageCommonLanguages;
  final VoidCallback onAddTarget;
  final VoidCallback onManageTargets;

  // Keys for anchoring native menus
  final GlobalKey _sourceButtonKey = GlobalKey();
  final GlobalKey _targetButtonKey = GlobalKey();
  final GlobalKey _configButtonKey = GlobalKey();

  void _showSourceMenu() {
    final menu = nativeapi.Menu();

    final autoItem = nativeapi.MenuItem(
      t.mini_translator.language.auto_detect,
      nativeapi.MenuItemType.checkbox,
    );
    autoItem.state = isAutoSource(sourceLanguage)
        ? nativeapi.MenuItemState.checked
        : nativeapi.MenuItemState.unchecked;
    autoItem.on<nativeapi.MenuItemClickedEvent>((_) {
      onSourceChanged(kAutoSource);
    });
    menu.addItem(autoItem);
    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    _populateLanguageMenu(
      menu,
      commonLanguageCodes,
      sourceLanguage,
      displayName: (lang) => getLanguageName(lang, showNative: true),
      onSelected: onSourceChanged,
      onManageCommonLanguages: onManageCommonLanguages,
    );
    _openMenu(_sourceButtonKey, menu);
  }

  void _showTargetMenu() {
    final menu = nativeapi.Menu();

    final autoItem = nativeapi.MenuItem(
      t.mini_translator.language.auto_match,
      nativeapi.MenuItemType.checkbox,
    );
    autoItem.state = selectedTargetLanguage == null
        ? nativeapi.MenuItemState.checked
        : nativeapi.MenuItemState.unchecked;
    autoItem.on<nativeapi.MenuItemClickedEvent>((_) {
      onTargetLanguageChanged(null);
    });
    menu.addItem(autoItem);
    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    _populateLanguageMenu(
      menu,
      commonLanguageCodes,
      selectedTargetLanguage,
      displayName: (lang) => getLanguageName(lang, showNative: true),
      onSelected: onTargetLanguageChanged,
      onManageCommonLanguages: onManageCommonLanguages,
    );
    _openMenu(_targetButtonKey, menu);
  }

  void _showConfigMenu() {
    final menu = nativeapi.Menu();

    final autoLabel =
        '${t.mini_translator.language.auto_detect} -> ${t.mini_translator.language.auto_match}';
    final autoItem = nativeapi.MenuItem(
      autoLabel,
      nativeapi.MenuItemType.checkbox,
    );
    autoItem.state = activeConfigIndex == -1 &&
            isAutoSource(sourceLanguage) &&
            selectedTargetLanguage == null
        ? nativeapi.MenuItemState.checked
        : nativeapi.MenuItemState.unchecked;
    autoItem.on<nativeapi.MenuItemClickedEvent>((_) {
      onConfigTargetSelected(-1);
    });
    menu.addItem(autoItem);
    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    for (var i = 0; i < persistentTargets.length; i++) {
      final target = persistentTargets[i];
      final label =
          '${getSourceDisplayName(target.source)} -> ${getLanguageName(target.target)}';
      final item = nativeapi.MenuItem(label, nativeapi.MenuItemType.checkbox);
      item.state = activeConfigIndex == i
          ? nativeapi.MenuItemState.checked
          : nativeapi.MenuItemState.unchecked;
      item.on<nativeapi.MenuItemClickedEvent>((_) {
        onConfigTargetSelected(i);
      });
      menu.addItem(item);
    }

    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    final addItem = nativeapi.MenuItem(
      t.mini_translator.language.add_target,
      nativeapi.MenuItemType.normal,
    );
    addItem.on<nativeapi.MenuItemClickedEvent>((_) => onAddTarget());
    menu.addItem(addItem);

    final manageItem = nativeapi.MenuItem(
      t.mini_translator.language.manage_targets,
      nativeapi.MenuItemType.normal,
    );
    manageItem.on<nativeapi.MenuItemClickedEvent>((_) => onManageTargets());
    menu.addItem(manageItem);

    _openMenu(_configButtonKey, menu,
        placement: nativeapi.Placement.bottomEnd, anchorX: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final sourceName = getSourceDisplayName(sourceLanguage);
    final targetName = selectedTargetLanguage == null
        ? t.mini_translator.language.auto_match
        : getLanguageName(selectedTargetLanguage!);
    final isDetected =
        detectedLanguage != null && !isAutoSource(sourceLanguage);
    final canSwap = !isAutoSource(sourceLanguage);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          Badge(
            tone: BadgeTone.accent,
            child: Text(
              isDetected
                  ? getLanguageName(detectedLanguage!)
                  : t.mini_translator.language.auto_detect,
            ),
          ),
          const SizedBox(width: 8),
          // The language capsule, shaped like the design system's SwapPair —
          // but each end opens a native menu, so the labels are pressable.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: colors.control,
              borderRadius: BorderRadius.circular(tokens.radii.control),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageChip(
                  key: _sourceButtonKey,
                  label: sourceName,
                  onPressed: _showSourceMenu,
                ),
                const SizedBox(width: 4),
                _SwapButton(
                  onPressed: !canSwap
                      ? null
                      : () {
                          onSourceChanged(
                            selectedTargetLanguage ?? defaultTargetLanguage,
                          );
                          onTargetLanguageChanged(sourceLanguage);
                        },
                ),
                const SizedBox(width: 4),
                _LanguageChip(
                  key: _targetButtonKey,
                  label: targetName,
                  onPressed: _showTargetMenu,
                ),
              ],
            ),
          ),
          const Spacer(),
          IconActionButton(
            key: _configButtonKey,
            icon: FluentIcons.options_20_regular,
            onPressed: _showConfigMenu,
          ),
        ],
      ),
    );
  }
}

/// One end of the language capsule: a label with a disclosure chevron.
class _LanguageChip extends StatelessWidget {
  const _LanguageChip({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.chip);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      semanticsLabel: label,
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: state.hovered ? colors.window : null,
          borderRadius: radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: tokens.typography.sansStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1,
                color: colors.fg,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              FluentIcons.chevron_down_20_regular,
              size: 11,
              color: colors.fgTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

/// The capsule's centre swap control, matching SwapPair's raised square.
class _SwapButton extends StatelessWidget {
  const _SwapButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.chip);

    return Pressable(
      onPressed: onPressed,
      enabled: onPressed != null,
      borderRadius: radius,
      semanticsLabel: '交换语言',
      builder: (context, state) => Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.window,
          borderRadius: radius,
        ),
        child: Icon(
          FluentIcons.arrow_swap_20_regular,
          size: 13,
          color: onPressed == null
              ? colors.fgFaint
              : (state.hovered ? colors.fg : colors.fgTertiary),
        ),
      ),
    );
  }
}
