import 'package:flutter/widgets.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../i18n/i18n.dart';
import '../utils/language_util.dart';
import 'native_menu.dart' show openNativeMenuBelow;
import 'swap_pair.dart' show SwapPair, SwapPairSize;
import 'ui.dart' show Badge, BadgeTone;

/// Populates [menu] with the common languages, a 更多语言 submenu, and the
/// 管理常用语言 item that leads into settings.
void populateLanguageMenu(
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

/// The language capsule that anchors a translation view — the design system's
/// SwapPair with both ends wired as menu triggers, so it is the one language
/// control the mini translator and the workbench share.
///
/// The start end opens 自动检测 plus the language list; the end opens the
/// target list, prefixed with 自动匹配 where [allowAutoTarget] is set. The
/// raised square between them swaps the pair and stays disabled while the
/// source is 自动检测 — there is nothing concrete to swap in.
class LanguageSelector extends StatefulWidget {
  const LanguageSelector({
    super.key,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.commonLanguageCodes,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onManageCommonLanguages,
    this.detectedLanguage,
    this.allowAutoTarget = false,
    this.size = SwapPairSize.md,
    this.window,
  });

  /// [kAutoSource] renders as 自动检测.
  final String sourceLanguage;

  /// Null renders as 自动匹配, and is only reachable with [allowAutoTarget].
  final String? targetLanguage;

  /// Shown as a badge beside the capsule when it says something the capsule
  /// does not — the detection behind 自动检测, or a source that disagrees
  /// with what was typed.
  final String? detectedLanguage;

  final List<String> commonLanguageCodes;

  /// Whether the target menu offers 自动匹配, which hands the choice to the
  /// configured translation targets.
  final bool allowAutoTarget;

  /// The capsule's size. The deck draws the main window's a step smaller than
  /// the popover's.
  final SwapPairSize size;

  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String?> onTargetChanged;
  final VoidCallback onManageCommonLanguages;

  /// The window the menus anchor to; defaults to the focused one.
  final nativeapi.Window? window;

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final GlobalKey _sourceKey = GlobalKey();
  final GlobalKey _targetKey = GlobalKey();

  void _showSourceMenu() {
    final menu = nativeapi.Menu();

    final autoItem = nativeapi.MenuItem(
      t.mini_translator.language.auto_detect,
      nativeapi.MenuItemType.checkbox,
    );
    autoItem.state = isAutoSource(widget.sourceLanguage)
        ? nativeapi.MenuItemState.checked
        : nativeapi.MenuItemState.unchecked;
    autoItem.on<nativeapi.MenuItemClickedEvent>((_) {
      widget.onSourceChanged(kAutoSource);
    });
    menu.addItem(autoItem);
    menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));

    populateLanguageMenu(
      menu,
      widget.commonLanguageCodes,
      widget.sourceLanguage,
      displayName: (lang) => getLanguageName(lang, showNative: true),
      onSelected: widget.onSourceChanged,
      onManageCommonLanguages: widget.onManageCommonLanguages,
    );
    openNativeMenuBelow(_sourceKey, menu, window: widget.window);
  }

  void _showTargetMenu() {
    final menu = nativeapi.Menu();

    if (widget.allowAutoTarget) {
      final autoItem = nativeapi.MenuItem(
        t.mini_translator.language.auto_match,
        nativeapi.MenuItemType.checkbox,
      );
      autoItem.state = widget.targetLanguage == null
          ? nativeapi.MenuItemState.checked
          : nativeapi.MenuItemState.unchecked;
      autoItem.on<nativeapi.MenuItemClickedEvent>((_) {
        widget.onTargetChanged(null);
      });
      menu.addItem(autoItem);
      menu.addItem(nativeapi.MenuItem('', nativeapi.MenuItemType.separator));
    }

    populateLanguageMenu(
      menu,
      widget.commonLanguageCodes,
      widget.targetLanguage,
      displayName: (lang) => getLanguageName(lang, showNative: true),
      onSelected: widget.onTargetChanged,
      onManageCommonLanguages: widget.onManageCommonLanguages,
    );
    openNativeMenuBelow(_targetKey, menu, window: widget.window);
  }

  void _swap() {
    widget.onSourceChanged(widget.targetLanguage ?? defaultTargetLanguage);
    widget.onTargetChanged(widget.sourceLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final sourceName = getSourceDisplayName(widget.sourceLanguage);
    final targetName = widget.targetLanguage == null
        ? t.mini_translator.language.auto_match
        : getLanguageName(widget.targetLanguage!);
    final detected = widget.detectedLanguage;
    final canSwap = !isAutoSource(widget.sourceLanguage);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Both ends are menu triggers here, which is the design system's
        // LanguagePair with `onSourceClick` and `onTargetClick` both wired.
        SwapPair(
          size: widget.size,
          start: sourceName,
          end: targetName,
          startKey: _sourceKey,
          endKey: _targetKey,
          onStartPressed: _showSourceMenu,
          onEndPressed: _showTargetMenu,
          // Nothing concrete to swap in while the source is 自动检测.
          onSwap: canSwap ? _swap : null,
          swapSemanticsLabel: '交换语言',
        ),
        if (detected != null && detected != widget.sourceLanguage) ...[
          const SizedBox(width: 8),
          Badge(tone: BadgeTone.accent, child: Text(getLanguageName(detected))),
        ],
      ],
    );
  }
}
