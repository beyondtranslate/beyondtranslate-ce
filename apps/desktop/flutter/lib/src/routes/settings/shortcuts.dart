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
        DesignThemeContext,
        PreferenceGroup,
        PreferenceRow,
        PreferenceSection,
        RadioItem,
        RadioList,
        ShortcutRecorder,
        ShortcutRecorderState;

/// The bindings the page edits, in the order it lists them. A row is its
/// section label, the patch that writes it, and the field that reads it —
/// keeping the three together is what lets the page detect a conflict without
/// naming any binding twice.
enum _Binding {
  toggleMiniTranslator,
  extractTextFromScreenSelection,
  extractTextFromScreenCapture,
  extractTextFromClipboard,
  translateInputContent,
}

extension on _Binding {
  String read(ShortcutSettings shortcuts) => switch (this) {
        _Binding.toggleMiniTranslator => shortcuts.toggleMiniTranslator,
        _Binding.extractTextFromScreenSelection =>
          shortcuts.extractTextFromScreenSelection,
        _Binding.extractTextFromScreenCapture =>
          shortcuts.extractTextFromScreenCapture,
        _Binding.extractTextFromClipboard => shortcuts.extractTextFromClipboard,
        _Binding.translateInputContent => shortcuts.translateInputContent,
      };

  ShortcutSettingsPatch patch(String value) => switch (this) {
        _Binding.toggleMiniTranslator =>
          ShortcutSettingsPatch(toggleMiniTranslator: value),
        _Binding.extractTextFromScreenSelection =>
          ShortcutSettingsPatch(extractTextFromScreenSelection: value),
        _Binding.extractTextFromScreenCapture =>
          ShortcutSettingsPatch(extractTextFromScreenCapture: value),
        _Binding.extractTextFromClipboard =>
          ShortcutSettingsPatch(extractTextFromClipboard: value),
        _Binding.translateInputContent =>
          ShortcutSettingsPatch(translateInputContent: value),
      };

  String get label => switch (this) {
        _Binding.toggleMiniTranslator =>
          t.settings.shortcuts.row.toggle_mini_translator,
        _Binding.extractTextFromScreenSelection =>
          t.settings.shortcuts.row.extract_text_from_screen_selection,
        _Binding.extractTextFromScreenCapture =>
          t.settings.shortcuts.row.extract_text_from_screen_capture,
        _Binding.extractTextFromClipboard =>
          t.settings.shortcuts.row.extract_text_from_clipboard,
        _Binding.translateInputContent =>
          t.settings.shortcuts.row.translate_input,
      };
}

/// Every binding at its default — the state 恢复默认 returns the page to, and
/// the one it compares against to know whether there is anywhere to go back to.
/// Mirrors `ShortcutSettings::default()` in
/// `packages/runtime/rust/src/domain/settings.rs`; the reset itself is the
/// runtime's, this map only decides whether to offer it.
const Map<_Binding, String> _kDefaultBindings = {
  _Binding.toggleMiniTranslator: 'Option+1',
  _Binding.extractTextFromScreenSelection: 'Option+Q',
  _Binding.extractTextFromScreenCapture: 'Option+W',
  _Binding.extractTextFromClipboard: 'Option+E',
  _Binding.translateInputContent: 'Option+Z',
};

/// The runtime stores `Option+Shift+2`; the design prints `⌥⇧2`. The two are
/// one mapping apart, and this is the mapping — both ways, so what the recorder
/// hands back can go straight into a patch.
const Map<String, String> _kModifierGlyphs = {
  'control': '⌃',
  'ctrl': '⌃',
  'alt': '⌥',
  'option': '⌥',
  'shift': '⇧',
  'command': '⌘',
  'cmd': '⌘',
  'meta': '⌘',
};

/// Keys the recorder prints as a symbol, by the name the runtime stores.
const Map<String, String> _kNamedKeyGlyphs = {
  'space': 'Space',
  'enter': '↩',
  'return': '↩',
  'tab': '⇥',
  'backspace': '⌫',
  'delete': '⌦',
  'up': '↑',
  'down': '↓',
  'left': '←',
  'right': '→',
  'home': '↖',
  'end': '↘',
  'pageup': '⇞',
  'pagedown': '⇟',
};

/// `Option+Shift+2` → `⌥⇧2`. A word key keeps a space after the modifiers so
/// `⌥ Space` reads as two things and `⌥⇧2` as one.
String shortcutGlyphs(String stored) {
  final parts = stored
      .split('+')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '';
  final modifiers = StringBuffer();
  var key = '';
  for (final part in parts) {
    final glyph = _kModifierGlyphs[part.toLowerCase()];
    if (glyph != null) {
      modifiers.write(glyph);
    } else {
      key = _kNamedKeyGlyphs[part.toLowerCase()] ?? part.toUpperCase();
    }
  }
  if (key.isEmpty) return modifiers.toString();
  final mods = modifiers.toString();
  if (key.length > 1) return '$mods${mods.isEmpty ? '' : ' '}$key';
  return '$mods$key';
}

/// `⌥⇧2` → `Option+Shift+2`, the form the runtime persists.
String storedShortcut(String glyphs) {
  final trimmed = glyphs.trim();
  if (trimmed.isEmpty) return '';
  const names = {'⌃': 'Control', '⌥': 'Option', '⇧': 'Shift', '⌘': 'Command'};
  final parts = <String>[];
  var index = 0;
  while (index < trimmed.length && names.containsKey(trimmed[index])) {
    parts.add(names[trimmed[index]]!);
    index++;
  }
  final key = trimmed.substring(index).trim();
  if (key.isEmpty) return '';
  final named = _kNamedKeyGlyphs.entries
      .where((entry) => entry.value == key)
      .map((entry) => entry.key)
      .firstOrNull;
  parts.add(named == null ? key : _capitalise(named));
  return parts.join('+');
}

String _capitalise(String value) =>
    value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

/// 快捷键 — the page splits by *where* a key works, not by what it does: one
/// group answers to the whole system, the other only inside this app's own
/// windows. Anything else on this page is a section within one of the two.
///
/// Mirrors the React `SettingsView`'s 快捷键 page. Each row's control is a
/// recorder: click it, press the keys, done. The source of truth stays the Rust
/// runtime ([RuntimeSettings.getShortcuts]); the page only writes patches to it.
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

  /// The binding this one collides with, if any. A key can be given to two
  /// actions; the page lets it happen and marks both rows rather than silently
  /// stealing it, so the fix is the user's and visible.
  _Binding? _conflictOf(_Binding binding, ShortcutSettings shortcuts) {
    final keys = binding.read(shortcuts).trim();
    if (keys.isEmpty) return null;
    for (final other in _Binding.values) {
      if (other == binding) continue;
      if (other.read(shortcuts).trim() == keys) return other;
    }
    return null;
  }

  Future<void> _bind(_Binding binding, String glyphs) =>
      settingsStore.updateShortcuts(binding.patch(storedShortcut(glyphs)));

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
      // 提交方式 is a binding this page owns too, so 恢复默认 has to reach it.
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(inputSubmitMode: InputSubmitMode.enter),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShortcutSettings shortcuts = settingsStore.shortcuts;
    final text = t.settings.shortcuts;
    final atDefault =
        settingsStore.general.inputSubmitMode == InputSubmitMode.enter &&
            _Binding.values.every(
              (binding) =>
                  binding.read(shortcuts) == _kDefaultBindings[binding],
            );

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
                _buildRow(_Binding.toggleMiniTranslator, shortcuts),
              ],
            ),
            PreferenceSection(
              label: Text(text.section.text_extraction),
              children: [
                _buildRow(_Binding.extractTextFromScreenSelection, shortcuts),
                _buildRow(_Binding.extractTextFromScreenCapture, shortcuts),
                _buildRow(_Binding.extractTextFromClipboard, shortcuts),
              ],
            ),
            PreferenceSection(
              label: Text(text.section.input_assist),
              children: [
                _buildRow(_Binding.translateInputContent, shortcuts),
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
          // Inert while nothing has moved: the button is a way back, and there
          // is nowhere to go back to.
          child: Button(
            variant: ButtonVariant.plain,
            enabled: !atDefault,
            onPressed: _resetToDefaults,
            child: Text(text.reset),
          ),
        ),
      ],
    );
  }

  /// A shortcut row is a preference row whose control is a recorder. The
  /// compact `Kbd` chip stays for the status-bar hints and the sidebar, where
  /// the keys are shown, not changed.
  Widget _buildRow(_Binding binding, ShortcutSettings shortcuts) {
    final conflict = _conflictOf(binding, shortcuts);
    final text = t.settings.shortcuts;

    return PreferenceRow(
      title: Text(binding.label),
      subtitle: conflict == null
          ? null
          : Builder(
              builder: (context) => Text(
                text.conflict(label: conflict.label),
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(color: context.colors.dangerFg),
              ),
            ),
      trailing: [
        ShortcutRecorder(
          value: shortcutGlyphs(binding.read(shortcuts)),
          onValueChanged: (glyphs) => _bind(binding, glyphs),
          state: conflict == null
              ? ShortcutRecorderState.normal
              : ShortcutRecorderState.error,
          placeholder: text.record_placeholder,
          recordingLabel: text.recording,
          clearLabel: text.clear,
          semanticsLabel: binding.label,
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
