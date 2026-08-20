import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../extensions/window_controller.dart';
import '../../i18n/i18n.dart';
import '../../services/app_windows.dart' show miniTranslatorWindowController;
import '../../utils/language_util.dart';
import '../../widgets/icon_action_button.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/native_menu.dart' show openNativeMenuBelow;

/// 顶部栏 — the deck's MiniTranslator chrome: the language capsule on the
/// left (each end opens a native menu, matching the deck's target-language
/// menu trigger), window-level actions on the right: the ⋯ native menu
/// (取词 / 主窗口 / 设置 / 切换目标) and the pin.
class MiniTranslatorTopBar extends StatelessWidget {
  MiniTranslatorTopBar({
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
    required this.isAlwaysOnTop,
    required this.onTogglePin,
    required this.onExtractScreenCapture,
    required this.onExtractClipboard,
    required this.onOpenWorkbench,
    required this.onOpenSettings,
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
  final bool isAlwaysOnTop;
  final VoidCallback onTogglePin;
  final VoidCallback onExtractScreenCapture;
  final VoidCallback onExtractClipboard;
  final VoidCallback onOpenWorkbench;
  final VoidCallback onOpenSettings;

  // Key for anchoring the ⋯ menu; the capsule owns its own.
  final GlobalKey _moreButtonKey = GlobalKey();

  /// The ⋯ menu — 取词 sources, window-level entries, and the 切换目标
  /// submenu that used to live behind its own options button.
  void _showMoreMenu() {
    final menu = nativeapi.Menu();

    final captureItem = nativeapi.MenuItem(
      t.mini_translator.toolbar.menu.extract_from_screen_capture,
      nativeapi.MenuItemType.normal,
    );
    captureItem.on<nativeapi.MenuItemClickedEvent>(
      (_) => onExtractScreenCapture(),
    );
    menu.addItem(captureItem);

    final clipboardItem = nativeapi.MenuItem(
      t.mini_translator.toolbar.menu.extract_from_clipboard,
      nativeapi.MenuItemType.normal,
    );
    clipboardItem.on<nativeapi.MenuItemClickedEvent>(
      (_) => onExtractClipboard(),
    );
    menu.addItem(clipboardItem);

    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));
    menu.addItem(_buildConfigSubmenuItem());
    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    final workbenchItem = nativeapi.MenuItem(
      t.mini_translator.toolbar.menu.open_main_window,
      nativeapi.MenuItemType.normal,
    );
    workbenchItem.on<nativeapi.MenuItemClickedEvent>((_) => onOpenWorkbench());
    menu.addItem(workbenchItem);

    final settingsItem = nativeapi.MenuItem(
      t.mini_translator.toolbar.menu.open_settings,
      nativeapi.MenuItemType.normal,
    );
    settingsItem.on<nativeapi.MenuItemClickedEvent>((_) => onOpenSettings());
    menu.addItem(settingsItem);

    openNativeMenuBelow(
      _moreButtonKey,
      menu,
      placement: nativeapi.Placement.bottomEnd,
      anchorX: 1.0,
      window: miniTranslatorWindowController.window,
    );
  }

  nativeapi.MenuItem _buildConfigSubmenuItem() {
    final submenu = nativeapi.Menu();

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
    submenu.addItem(autoItem);
    submenu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

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
      submenu.addItem(item);
    }

    submenu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    final addItem = nativeapi.MenuItem(
      t.mini_translator.language.add_target,
      nativeapi.MenuItemType.normal,
    );
    addItem.on<nativeapi.MenuItemClickedEvent>((_) => onAddTarget());
    submenu.addItem(addItem);

    final manageItem = nativeapi.MenuItem(
      t.mini_translator.language.manage_targets,
      nativeapi.MenuItemType.normal,
    );
    manageItem.on<nativeapi.MenuItemClickedEvent>((_) => onManageTargets());
    submenu.addItem(manageItem);

    final configItem = nativeapi.MenuItem(
      t.mini_translator.language.switch_config,
      nativeapi.MenuItemType.submenu,
    );
    configItem.submenu = submenu;
    return configItem;
  }

  @override
  Widget build(BuildContext context) {
    // Sits on the window's tray surface; the panel below provides the
    // separation, so the bar carries no border of its own.
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: Row(
        children: [
          LanguageSelector(
            sourceLanguage: sourceLanguage,
            targetLanguage: selectedTargetLanguage,
            detectedLanguage: detectedLanguage,
            commonLanguageCodes: commonLanguageCodes,
            allowAutoTarget: true,
            window: miniTranslatorWindowController.window,
            onSourceChanged: onSourceChanged,
            onTargetChanged: onTargetLanguageChanged,
            onManageCommonLanguages: onManageCommonLanguages,
          ),
          const Spacer(),
          IconActionButton(
            key: _moreButtonKey,
            // The 16-grid glyph at 16, not the 20-grid one at 18: a Fluent
            // icon is drawn for one size, and rendering it at 0.9 puts each of
            // the three dots on a different subpixel phase — they come out
            // visibly unequal. Every other shape hides that; three circles
            // cannot.
            icon: FluentIcons.more_horizontal_16_regular,
            iconSize: 16,
            tooltip: t.mini_translator.toolbar.tooltip.more_actions,
            onPressed: _showMoreMenu,
          ),
          IconActionButton(
            // Sized to its own grid for the same reason, and to the same 16
            // as the ⋯ beside it — two toolbar buttons at different glyph
            // sizes read as a mistake.
            icon: isAlwaysOnTop
                ? FluentIcons.pin_16_filled
                : FluentIcons.pin_16_regular,
            iconSize: 16,
            tooltip: t.mini_translator.toolbar.tooltip.pin,
            selected: isAlwaysOnTop,
            // The pin lies at -45° until pinned, matching the deck.
            iconTurns: isAlwaysOnTop ? 0 : -0.125,
            onPressed: onTogglePin,
          ),
        ],
      ),
    );
  }
}
