/// Whether the window a subtree is drawn in is the key window.
///
/// AppKit fills a list's current row with the accent only while its window is
/// key, and desaturates it the moment another window takes key status — so
/// only the frontmost window's selection shouts. React's `WindowFrame` does it
/// by swapping `--selection` on blur and letting every row inherit the custom
/// property. Flutter has no paint property that inherits, so the state rides
/// on [WindowFocus] instead, and the rows that draw a selection —
/// `SidebarItem` and `RailItem` — ask it.
library;

import 'package:flutter/widgets.dart';
import 'package:nativeapi_flutter/nativeapi_flutter.dart' as nativeapi;

/// Scopes a window's key status to the subtree below it.
class WindowFocus extends InheritedWidget {
  const WindowFocus({super.key, required this.focused, required super.child});

  /// Whether the window is key.
  final bool focused;

  /// Whether the window [context] is drawn in is key.
  ///
  /// A subtree with no [WindowFocus] over it — a gallery, a golden, a widget
  /// test — reads as focused: the emphasized selection is the one the design
  /// draws, and a specimen has no window to lose.
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WindowFocus>()?.focused ??
      true;

  @override
  bool updateShouldNotify(WindowFocus oldWidget) =>
      focused != oldWidget.focused;
}

/// Follows a native window's key status and scopes it as a [WindowFocus].
///
/// The same nativeapi focus and blur events the mini translator listens for,
/// seeded from `Window.isFocused` so a window mounted in the background does
/// not start out drawn as key.
class WindowFocusTracker extends StatefulWidget {
  const WindowFocusTracker({
    super.key,
    required this.window,
    required this.child,
  });

  /// The window to follow.
  final nativeapi.Window window;

  final Widget child;

  @override
  State<WindowFocusTracker> createState() => _WindowFocusTrackerState();
}

class _WindowFocusTrackerState extends State<WindowFocusTracker> {
  late bool _focused = widget.window.isFocused;
  nativeapi.ListenerId? _listenerId;

  @override
  void initState() {
    super.initState();
    _listenerId = nativeapi.WindowManager.instance.addListener(_handleEvent);
  }

  @override
  void didUpdateWidget(WindowFocusTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.window.id != oldWidget.window.id) {
      _focused = widget.window.isFocused;
    }
  }

  @override
  void dispose() {
    if (_listenerId != null) {
      nativeapi.WindowManager.instance.removeListener(_listenerId!);
    }
    super.dispose();
  }

  void _handleEvent(nativeapi.WindowEvent event) {
    final bool? focused = switch (event) {
      nativeapi.WindowFocusedEvent(:final windowId)
          when windowId == widget.window.id =>
        true,
      nativeapi.WindowBlurredEvent(:final windowId)
          when windowId == widget.window.id =>
        false,
      _ => null,
    };
    if (focused == null || focused == _focused || !mounted) return;
    setState(() => _focused = focused);
  }

  @override
  Widget build(BuildContext context) =>
      WindowFocus(focused: _focused, child: widget.child);
}
