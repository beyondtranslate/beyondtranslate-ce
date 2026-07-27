import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../extensions/window_controller.dart';
import '../../i18n/i18n.dart';
import '../../utils/language_util.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/themes/design_theme.dart';
import '../app_router.dart'
    show miniTranslatorWindowController;

/// Opens a native context menu anchored near [buttonKey].
void _openMenu(
  GlobalKey buttonKey,
  nativeapi.Menu menu, {
  nativeapi.Placement placement = nativeapi.Placement.bottom,
  double anchorX = 0.5,
}) {
  final renderBox =
      buttonKey.currentContext?.findRenderObject() as RenderBox?;
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
    final theme = Theme.of(context);
    final design = context.design;
    final sourceName = getSourceDisplayName(sourceLanguage);
    final targetName = selectedTargetLanguage == null
        ? t.mini_translator.language.auto_match
        : getLanguageName(selectedTargetLanguage!);
    final isDetected = detectedLanguage != null &&
        !isAutoSource(sourceLanguage);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: design.border),
        ),
      ),
      child: Row(
        children: [
          // Auto-detect badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: design.accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              isDetected
                  ? getLanguageName(detectedLanguage!)
                  : t.mini_translator.language.auto_detect,
              style: TextStyle(
                fontFamily: 'Barlow Condensed',
                fontWeight: FontWeight.w600,
                fontSize: 10,
                height: 1.4,
                letterSpacing: 0.12,
                color: design.accentDark,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Source language (clickable)
          Button(
            key: _sourceButtonKey,
            minSize: 0,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            onPressed: _showSourceMenu,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sourceName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  FluentIcons.chevron_down_20_regular,
                  size: 12,
                  color: design.mutedText,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Swap button
          SizedBox(
            width: 20,
            height: 20,
            child: Button(
              borderRadius: BorderRadius.zero,
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: isAutoSource(sourceLanguage)
                  ? null
                  : () {
                      onSourceChanged(
                        selectedTargetLanguage ?? defaultTargetLanguage,
                      );
                      onTargetLanguageChanged(
                        sourceLanguage,
                      );
                    },
              child: Icon(
                FluentIcons.arrow_swap_20_regular,
                size: 14,
                color: isAutoSource(sourceLanguage)
                    ? design.quietText
                    : design.mutedText,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Target language (clickable)
          Button(
            key: _targetButtonKey,
            minSize: 0,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            onPressed: _showTargetMenu,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  targetName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  FluentIcons.chevron_down_20_regular,
                  size: 12,
                  color: design.mutedText,
                ),
              ],
            ),
          ),
          const Spacer(),
          // Config button
          SizedBox(
            width: 24,
            height: 24,
            child: Button(
              key: _configButtonKey,
              minSize: 0,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.zero,
              onPressed: _showConfigMenu,
              child: Icon(
                FluentIcons.options_20_regular,
                size: 16,
                color: design.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
