import 'dart:async';

import 'package:flutter/widgets.dart';

import 'toast_viewport.dart' show ToastPlacement, ToastViewport;
import 'ui.dart' show Toast, ToastTint;

/// Shows a toast in the window that owns [context].
///
/// The design contract the kit leaves to the host: 4s for a plain notice, 6s
/// when it carries an action, [ToastTint.danger] stays until its ✕ is
/// clicked, and hovering pauses the clock.
void showToast(
  BuildContext context,
  String message, {
  ToastTint tone = ToastTint.neutral,
  IconData? icon,
  Widget? action,
}) {
  ToastHost.of(context).show(message, tone: tone, icon: icon, action: action);
}

/// The window-level surface toasts land on — one per `MaterialApp`, mounted in
/// its `builder` so both the workbench and the mini translator get their own
/// stack (each window is its own tree; a global singleton would put a
/// workbench receipt over the mini window).
class ToastHost extends StatefulWidget {
  const ToastHost({
    super.key,
    this.placement = ToastPlacement.bottom,
    required this.child,
  });

  final ToastPlacement placement;
  final Widget child;

  static ToastHostState of(BuildContext context) {
    final state = context.findAncestorStateOfType<ToastHostState>();
    assert(state != null, 'showToast used outside a ToastHost');
    return state!;
  }

  @override
  State<ToastHost> createState() => ToastHostState();
}

class _ToastEntry {
  _ToastEntry({
    required this.id,
    required this.message,
    required this.tone,
    this.icon,
    this.action,
    this.remaining,
  });

  final int id;
  final String message;
  final ToastTint tone;
  final IconData? icon;
  final Widget? action;

  /// Time left on the clock; `null` keeps the toast until dismissed.
  Duration? remaining;
  Timer? timer;
  DateTime? startedAt;
}

class ToastHostState extends State<ToastHost> {
  final List<_ToastEntry> _entries = [];
  int _nextId = 0;

  void show(
    String message, {
    ToastTint tone = ToastTint.neutral,
    IconData? icon,
    Widget? action,
  }) {
    final entry = _ToastEntry(
      id: _nextId++,
      message: message,
      tone: tone,
      icon: icon,
      action: action,
      remaining: tone == ToastTint.danger
          ? null
          : Duration(seconds: action != null ? 6 : 4),
    );
    setState(() => _entries.add(entry));
    _resume(entry);
  }

  void _dismiss(_ToastEntry entry) {
    entry.timer?.cancel();
    if (!mounted) return;
    setState(() => _entries.remove(entry));
  }

  void _pause(_ToastEntry entry) {
    final startedAt = entry.startedAt;
    if (entry.remaining == null || startedAt == null) return;
    entry.timer?.cancel();
    entry.timer = null;
    entry.remaining = entry.remaining! - DateTime.now().difference(startedAt);
    entry.startedAt = null;
  }

  void _resume(_ToastEntry entry) {
    final remaining = entry.remaining;
    if (remaining == null || entry.timer != null) return;
    entry.startedAt = DateTime.now();
    entry.timer = Timer(
      remaining.isNegative ? Duration.zero : remaining,
      () => _dismiss(entry),
    );
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ToastViewport(
          placement: widget.placement,
          children: [
            for (final entry in _entries)
              MouseRegion(
                key: ValueKey(entry.id),
                onEnter: (_) => _pause(entry),
                onExit: (_) => _resume(entry),
                child: Toast(
                    // danger keeps its ✕; timed toasts just leave on their own.
                    onDismiss:
                        entry.remaining == null ? () => _dismiss(entry) : null,
                    tint: entry.tone,
                    icon: entry.icon,
                    action: entry.action,
                    message: entry.message),
              ),
          ],
        ),
      ],
    );
  }
}
