import 'package:flutter/foundation.dart';
import 'package:nativeapi/nativeapi.dart' show Shortcut, ShortcutManager;

import '../settings_store.dart';

abstract mixin class ShortcutListener {
  void onShortcutKeyDownToggleMiniTranslator();
  void onShortcutKeyDownExtractFromScreenSelection();
  void onShortcutKeyDownExtractFromScreenCapture();
  void onShortcutKeyDownExtractFromClipboard();
  void onShortcutKeyDownTranslateInputContent();
}

/// Manages global hotkeys for the mini translator.
///
/// The Rust runtime owns the bindings (`RuntimeSettings.getShortcuts`) as
/// accelerator strings such as `Option+Q`, which is the exact form nativeapi's
/// [ShortcutManager] parses — so registration is a straight pass-through.
/// While started, the service follows [SettingsStore] so an edit on the
/// 快捷键 page re-registers the keys without a restart.
class ShortcutService {
  ShortcutService._();

  /// The shared instance of [ShortcutService].
  static final ShortcutService instance = ShortcutService._();

  ShortcutListener? _listener;

  bool _started = false;
  final List<Shortcut> _registered = [];

  /// The accelerators last handed to the OS, one per action in the order of
  /// [_bindings] — the cheap way to tell a shortcut edit apart from the many
  /// other [SettingsStore] notifications.
  List<String> _applied = const [];

  void setListener(ShortcutListener? listener) {
    _listener = listener;
  }

  /// Each action's current accelerator, paired with what pressing it does.
  /// An empty string is an unbound action and registers nothing.
  List<(String, VoidCallback)> get _bindings {
    final shortcuts = settingsStore.shortcuts;
    return [
      (shortcuts.toggleMiniTranslator, notifyToggleMiniTranslator),
      (
        shortcuts.extractTextFromScreenSelection,
        notifyExtractTextFromScreenSelection,
      ),
      (
        shortcuts.extractTextFromScreenCapture,
        notifyExtractTextFromScreenCapture,
      ),
      (shortcuts.extractTextFromClipboard, notifyExtractTextFromClipboard),
      (shortcuts.translateInputContent, notifyTranslateInputContent),
    ];
  }

  void start() {
    if (_started) return;
    if (!ShortcutManager.instance.isSupported()) return;
    _started = true;
    settingsStore.addListener(_handleSettingsChanged);
    _apply();
  }

  void stop() {
    if (!_started) return;
    _started = false;
    settingsStore.removeListener(_handleSettingsChanged);
    _unregisterAll();
    _applied = const [];
  }

  void _handleSettingsChanged() {
    final accelerators = [
      for (final (accelerator, _) in _bindings) accelerator
    ];
    if (listEquals(accelerators, _applied)) return;
    _apply();
  }

  void _apply() {
    _unregisterAll();
    final bindings = _bindings;
    _applied = [for (final (accelerator, _) in bindings) accelerator];
    for (final (accelerator, callback) in bindings) {
      if (accelerator.trim().isEmpty) continue;
      final shortcut = ShortcutManager.instance
          .registerWithAcceleratorAndCallback(accelerator, callback);
      if (shortcut == null) {
        // Invalid accelerator, or the key is taken — by another app, or by
        // another row on the 快捷键 page (the page shows that conflict).
        debugPrint('ShortcutService: failed to register "$accelerator"');
        continue;
      }
      _registered.add(shortcut);
    }
  }

  void _unregisterAll() {
    for (final shortcut in _registered) {
      ShortcutManager.instance.unregisterWithId(shortcut.id);
      shortcut.dispose();
    }
    _registered.clear();
  }

  // Hooks for tests / future direct invocation.
  void notifyToggleMiniTranslator() =>
      _listener?.onShortcutKeyDownToggleMiniTranslator();
  void notifyExtractTextFromScreenSelection() =>
      _listener?.onShortcutKeyDownExtractFromScreenSelection();
  void notifyExtractTextFromScreenCapture() =>
      _listener?.onShortcutKeyDownExtractFromScreenCapture();
  void notifyExtractTextFromClipboard() =>
      _listener?.onShortcutKeyDownExtractFromClipboard();
  void notifyTranslateInputContent() =>
      _listener?.onShortcutKeyDownTranslateInputContent();
}
