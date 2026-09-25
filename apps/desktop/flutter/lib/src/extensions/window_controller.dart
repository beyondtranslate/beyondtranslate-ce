// ignore_for_file: invalid_use_of_internal_member, implementation_imports

import 'dart:io';

import 'package:flutter/src/widgets/_window.dart' as flutter_window
    show BaseWindowController;
import 'package:nativeapi_flutter/nativeapi_flutter.dart';
import 'package:nativeapi_flutter/windowing.dart';

/// The nativeapi [Window] behind each controller, kept so repeated reads from
/// a `build` do not re-wrap the same native handle.
final Expando<Window> _windows = Expando<Window>('nativeWindow');

final Map<WindowId, bool Function(Window window)> _windowWillShowHooks = {};
final Map<WindowId, bool Function(Window window)> _windowWillHideHooks = {};

bool _globalWillShowHookInitialized = false;
bool _globalWillHideHookInitialized = false;

void setupGlobalWillShowHook() {
  // Flutter's experimental Windows windowing backend owns ShowWindow calls.
  // cnativeapi's hook cancels those calls before dispatching its Dart callback,
  // leaving every Flutter-managed window hidden.
  if (Platform.isWindows) return;
  if (_globalWillShowHookInitialized) return;
  _globalWillShowHookInitialized = true;
  // The native side cancels the show once a hook is set; letting it proceed
  // is done explicitly through callOriginalShow.
  //
  // The binding invokes this synchronously from inside the platform's show
  // call, so the work is deferred one event-loop turn rather than run from
  // inside it.
  WindowManager.instance.setWillShowHook((windowId) {
    Future(() {
      final window = WindowManager.instance.get(windowId);
      var proceed = true;
      if (window != null) {
        window._incrementShowCount();
        final hook = _windowWillShowHooks[windowId];
        if (hook != null) {
          proceed = hook(window);
        }
      }
      if (proceed) {
        WindowManager.instance.callOriginalShow(windowId);
      }
    });
  });
}

void setupGlobalWillHideHook() {
  if (Platform.isWindows) return;
  if (_globalWillHideHookInitialized) return;
  _globalWillHideHookInitialized = true;
  WindowManager.instance.setWillHideHook((windowId) {
    // Deferred for the same reason as the will-show hook above.
    Future(() {
      final window = WindowManager.instance.get(windowId);
      var proceed = true;
      if (window != null) {
        final hook = _windowWillHideHooks[windowId];
        if (hook != null) {
          proceed = hook(window);
        }
      }
      if (proceed) {
        WindowManager.instance.callOriginalHide(windowId);
      }
    });
  });
}

/// Extension for Flutter's window controller to add native window hooks.
extension ExtendedWindowController on flutter_window.BaseWindowController {
  /// The native window this controller drives.
  ///
  /// nativeapi's [nativeWindow] hands back the very `NSWindow*` / `HWND` /
  /// `GtkWindow*` Flutter created, wrapped around the id the native window
  /// already carries — so it is the same window `WindowManager` reports, and
  /// no guessing from titles is involved. It is available as soon as the
  /// controller is, because constructing one creates the native window.
  ///
  /// Throws once the controller has been destroyed, which for this app's two
  /// windows means never: both outlive the process's UI, closing hides them.
  Window get window {
    final cached = _windows[this];
    if (cached != null) return cached;
    final window = nativeWindow;
    if (window == null) {
      throw StateError(
        'No native window for $runtimeType — it was destroyed, or this '
        'platform does not expose a window handle.',
      );
    }
    _windows[this] = window;
    return window;
  }

  /// Set the hook to be called when the window is shown.
  /// [callback] The callback to be called when the window is shown.
  /// Returns true if the window should be shown, false otherwise.
  void setWillShowHook(bool Function(Window window) callback) {
    _windowWillShowHooks[window.id] = callback;
  }

  /// Set the hook to be called when the window is hidden.
  /// [callback] The callback to be called when the window is hidden.
  /// Returns true if the window should be hidden, false otherwise.
  void setWillHideHook(bool Function(Window window) callback) {
    _windowWillHideHooks[window.id] = callback;
  }
}

extension ExtendedWindow on Window {
  static final Map<int, int> _showCounts = {};

  /// Whether the window is the first time to be shown.
  bool get isFirstShow {
    final showCount = _showCounts.containsKey(id) ? _showCounts[id]! : 0;
    return Platform.isMacOS ? showCount <= 2 : showCount <= 1;
  }

  /// Increment the show count.
  void _incrementShowCount() {
    final showCount = _showCounts.containsKey(id) ? _showCounts[id]! : 0;
    _showCounts[id] = showCount + 1;
  }
}
