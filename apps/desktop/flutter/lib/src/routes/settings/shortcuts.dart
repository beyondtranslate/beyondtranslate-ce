import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        Kbd,
        KbdVariant,
        PreferenceGroup,
        PreferenceRow,
        PreferenceSection,
        RadioItem,
        RadioList;

/// 快捷键 — the page splits by *where* a key works, not by what it does: one
/// group answers to the whole system, the other only inside this app's own
/// windows. Anything else on this page is a section within one of the two.
///
/// Mirrors the React `SettingsView`'s 快捷键 page. Bindings are read-only here;
/// the source of truth lives in the Rust runtime ([RuntimeSettings.getShortcuts]).
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
    // 提交键 came off 常规: which key sends the box is a key binding, and this
    // is the page you open when you want to know what a key does.
    settingsStore.reloadGeneral();
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
    final text = t.settings.shortcuts;

    return SettingsPage(
      children: [
        PreferenceGroup(
          title: Text(text.group.global.title),
          description: Text(text.group.global.description),
          children: [
            // The first run goes unlabelled — a single key that shows the
            // window is not a category.
            PreferenceSection(
              children: [
                _ShortcutRow(
                  title: text.row.toggle_mini_translator,
                  shortcut: shortcuts.toggleMiniTranslator,
                ),
              ],
            ),
            PreferenceSection(
              label: Text(text.section.text_extraction),
              children: [
                _ShortcutRow(
                  title: text.row.extract_text_from_screen_selection,
                  shortcut: shortcuts.extractTextFromScreenSelection,
                ),
                _ShortcutRow(
                  title: text.row.extract_text_from_screen_capture,
                  shortcut: shortcuts.extractTextFromScreenCapture,
                ),
                _ShortcutRow(
                  title: text.row.extract_text_from_clipboard,
                  shortcut: shortcuts.extractTextFromClipboard,
                ),
              ],
            ),
            PreferenceSection(
              label: Text(text.section.input_assist),
              children: [
                _ShortcutRow(
                  title: text.row.translate_input,
                  shortcut: shortcuts.translateInputContent,
                ),
              ],
            ),
          ],
        ),
        const SettingsSectionDivider(),
        PreferenceGroup(
          title: Text(text.group.in_app.title),
          description: Text(text.group.in_app.description),
          children: [
            PreferenceSection(
              label: Text(text.section.submit_mode),
              children: [
                RadioList<InputSubmitMode>(
                  value: settingsStore.general.inputSubmitMode,
                  semanticsLabel: text.section.submit_mode,
                  options: [
                    for (final mode in InputSubmitMode.values)
                      RadioItem(
                        value: mode,
                        label: Text(_inputSubmitModeTitle(mode)),
                      ),
                  ],
                  onChanged: (mode) => settingsStore.updateGeneral(
                    GeneralSettingsPatch(inputSubmitMode: mode),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SettingsSectionDivider(),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Button(
            variant: ButtonVariant.plain,
            onPressed: _resetToDefaults,
            child: Text(text.reset),
          ),
        ),
      ],
    );
  }

  String _inputSubmitModeTitle(InputSubmitMode mode) {
    switch (mode) {
      case InputSubmitMode.enter:
        return t.settings.general.row.submit_with_enter;
      case InputSubmitMode.commandEnter:
        return t.settings.general.row.submit_with_meta_enter_mac;
    }
  }
}

/// A shortcut row is a preference row whose control happens to be a key cap,
/// so it uses the same one.
class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.title, required this.shortcut});

  final String title;
  final String shortcut;

  @override
  Widget build(BuildContext context) {
    final label = _formatShortcut(shortcut);
    return PreferenceRow(
      title: Text(title),
      trailing: [
        if (label.isEmpty)
          const Text('—')
        else
          Kbd(label, variant: KbdVariant.key),
      ],
    );
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
