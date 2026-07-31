import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart' show Button, ButtonVariant, Kbd, KbdVariant;

/// Mirrors macOS `ShortcutsView.swift`.
///
/// Shortcuts are displayed read-only here. Editing of shortcut bindings is
/// not yet implemented for the Flutter shell; the source of truth lives in
/// the Rust runtime ([RuntimeSettings.getShortcuts]).
class ShortcutsSettingsPage extends StatefulWidget {
  const ShortcutsSettingsPage({super.key});

  @override
  State<ShortcutsSettingsPage> createState() => _ShortcutsSettingsPageState();
}

class _ShortcutsSettingsPageState extends State<ShortcutsSettingsPage> {
  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    settingsStore.reloadShortcuts();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _resetToDefaults() async {
    final confirmed = await showDialogInCurrentWindow<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: Text(t.settings.shortcuts.reset_dialog.title),
        content: Text(t.settings.shortcuts.reset_dialog.message),
        actions: [
          Button(
            variant: ButtonVariant.secondary,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.settings.shortcuts.reset_dialog.cancel),
          ),
          Button(
            variant: ButtonVariant.primary,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.settings.shortcuts.reset_dialog.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await settingsStore.resetShortcuts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShortcutSettings shortcuts = settingsStore.shortcuts;
    final shortcutsText = t.settings.shortcuts;

    return SettingsPage(
      actions: [
        IconButton(
          tooltip: shortcutsText.reset_dialog.title,
          onPressed: _resetToDefaults,
          icon: const Icon(FluentIcons.arrow_counterclockwise_20_regular),
        ),
      ],
      children: [
        PreferenceListSection(
          children: [
            _ShortcutRow(
              title: shortcutsText.row.toggle_mini_translator,
              shortcut: shortcuts.toggleMiniTranslator,
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(shortcutsText.section.text_extraction),
          children: [
            _ShortcutRow(
              title: shortcutsText.row.extract_text_from_screen_selection,
              shortcut: shortcuts.extractTextFromScreenSelection,
            ),
            _ShortcutRow(
              title: shortcutsText.row.extract_text_from_screen_capture,
              shortcut: shortcuts.extractTextFromScreenCapture,
            ),
            _ShortcutRow(
              title: shortcutsText.row.extract_text_from_clipboard,
              shortcut: shortcuts.extractTextFromClipboard,
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(shortcutsText.section.input_assist),
          children: [
            _ShortcutRow(
              title: shortcutsText.row.translate_input,
              shortcut: shortcuts.translateInputContent,
            ),
          ],
        ),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({
    required this.title,
    required this.shortcut,
  });

  final String title;
  final String shortcut;

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text(title),
      detailText: _ShortcutBadge(shortcut: shortcut),
    );
  }
}

class _ShortcutBadge extends StatelessWidget {
  const _ShortcutBadge({required this.shortcut});

  final String shortcut;

  @override
  Widget build(BuildContext context) {
    final label = _formatShortcut(shortcut);
    if (label.isEmpty) {
      return Text(
        '—',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Kbd(label, variant: KbdVariant.key);
  }

  String _formatShortcut(String value) {
    const aliases = <String, String>{
      'alt': '⌥',
      'option': '⌥',
      'shift': '⇧',
      'control': '⌃',
      'ctrl': '⌃',
      'command': '⌘',
      'cmd': '⌘',
      'meta': '⌘',
      'space': 'Space',
    };
    return value
        .split('+')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .map((part) => aliases[part.toLowerCase()] ?? part.toUpperCase())
        .join(' ');
  }
}
