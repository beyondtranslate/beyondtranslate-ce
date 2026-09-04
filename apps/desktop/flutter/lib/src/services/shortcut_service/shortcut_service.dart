import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nativeapi/nativeapi.dart' show Shortcut, ShortcutManager;

import '../app_windows.dart' show showMiniTranslatorWindow;
import '../settings_store.dart';

abstract mixin class ShortcutListener {
  void onShortcutKeyDownToggleMiniTranslator();
  void onShortcutKeyDownExtractFromScreenSelection();
  void onShortcutKeyDownExtractFromScreenCapture();
  void onShortcutKeyDownExtractFromClipboard();
  void onShortcutKeyDownTranslateInputContent();
}

/// The actions the global keys fire, named apart from [ShortcutListener] so one
/// can be held over the gap between the press and the page that carries it out.
enum _ShortcutAction {
  toggleMiniTranslator,
  extractFromScreenSelection,
  extractFromScreenCapture,
  extractFromClipboard,
  translateInputContent,
}

/// Manages global hotkeys for the mini translator.
///
/// The Rust runtime owns the bindings (`RuntimeSettings.getShortcuts`) as
/// accelerator strings such as `Option+Q`, which is the exact form nativeapi's
/// [ShortcutManager] parses — so registration is a straight pass-through.
/// While started, the service follows [SettingsStore] so an edit on the
/// 快捷键 page re-registers the keys without a restart.
///
/// [start] belongs to the app's lifetime rather than to any one window's. The
/// mini translator window is created on first use, and a key whose whole job is
/// to summon it has to work before it exists — registering from the page it
/// summons would mean the key only ever works after the window has already been
/// opened by hand.
///
/// What a key *does* still belongs to the mini translator page, which owns the
/// input box and the results ([setListener]). A press that lands before the page
/// exists therefore brings the window up, and is replayed to the page as soon as
/// it attaches.
class ShortcutService {
  ShortcutService._();

  /// The shared instance of [ShortcutService].
  static final ShortcutService instance = ShortcutService._();

  ShortcutListener? _listener;

  /// A press that arrived with no listener and is waiting for one. Only ever
  /// the last such press: keys that queue up behind a window that is still
  /// coming up are the same request made twice, not two requests.
  _ShortcutAction? _pendingAction;

  bool _started = false;
  final List<Shortcut> _registered = [];

  /// The accelerators last handed to the OS, one per action in the order of
  /// [_bindings] — the cheap way to tell a shortcut edit apart from the many
  /// other [SettingsStore] notifications.
  List<String> _applied = const [];

  void setListener(ShortcutListener? listener) {
    _listener = listener;
    if (listener == null) return;
    final pending = _pendingAction;
    _pendingAction = null;
    if (pending != null) _deliver(pending, listener);
  }

  /// Each action's current accelerator, paired with the action it fires. An
  /// empty string is an unbound action and registers nothing.
  List<(String, _ShortcutAction)> get _bindings {
    final shortcuts = settingsStore.shortcuts;
    return [
      (shortcuts.toggleMiniTranslator, _ShortcutAction.toggleMiniTranslator),
      (
        shortcuts.extractTextFromScreenSelection,
        _ShortcutAction.extractFromScreenSelection,
      ),
      (
        shortcuts.extractTextFromScreenCapture,
        _ShortcutAction.extractFromScreenCapture,
      ),
      (
        shortcuts.extractTextFromClipboard,
        _ShortcutAction.extractFromClipboard,
      ),
      (shortcuts.translateInputContent, _ShortcutAction.translateInputContent),
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
    for (final (accelerator, action) in bindings) {
      if (accelerator.trim().isEmpty) continue;
      final shortcut =
          ShortcutManager.instance.registerWithAcceleratorAndCallback(
        accelerator,
        () => _dispatch(action),
      );
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

  void _dispatch(_ShortcutAction action) {
    final listener = _listener;
    if (listener != null) {
      _deliver(action, listener);
      return;
    }

    switch (action) {
      // Putting the window up *is* the toggle when there is no window yet, so
      // this one is answered here rather than replayed — handing it on would
      // toggle the window straight back off.
      case _ShortcutAction.toggleMiniTranslator:
        unawaited(showMiniTranslatorWindow());
      case _ShortcutAction.extractFromScreenSelection:
      case _ShortcutAction.extractFromScreenCapture:
      case _ShortcutAction.extractFromClipboard:
        _pendingAction = action;
        unawaited(showMiniTranslatorWindow());
      // Reads the frontmost app's own input box; the mini translator window
      // has no part in it, so a press with nobody listening is simply dropped.
      case _ShortcutAction.translateInputContent:
        break;
    }
  }

  void _deliver(_ShortcutAction action, ShortcutListener listener) {
    switch (action) {
      case _ShortcutAction.toggleMiniTranslator:
        listener.onShortcutKeyDownToggleMiniTranslator();
      case _ShortcutAction.extractFromScreenSelection:
        listener.onShortcutKeyDownExtractFromScreenSelection();
      case _ShortcutAction.extractFromScreenCapture:
        listener.onShortcutKeyDownExtractFromScreenCapture();
      case _ShortcutAction.extractFromClipboard:
        listener.onShortcutKeyDownExtractFromClipboard();
      case _ShortcutAction.translateInputContent:
        listener.onShortcutKeyDownTranslateInputContent();
    }
  }

  // Hooks for tests / direct invocation; they take the same path a key press
  // does, pending replay included.
  void notifyToggleMiniTranslator() =>
      _dispatch(_ShortcutAction.toggleMiniTranslator);
  void notifyExtractTextFromScreenSelection() =>
      _dispatch(_ShortcutAction.extractFromScreenSelection);
  void notifyExtractTextFromScreenCapture() =>
      _dispatch(_ShortcutAction.extractFromScreenCapture);
  void notifyExtractTextFromClipboard() =>
      _dispatch(_ShortcutAction.extractFromClipboard);
  void notifyTranslateInputContent() =>
      _dispatch(_ShortcutAction.translateInputContent);
}
