/// Where a window stacks its toasts.
///
/// The kit ships the [Toast] itself; the column it lives in belongs to the
/// window, which is why the app owns this half.
library;

import 'package:flutter/widgets.dart';

enum ToastPlacement { bottom, top }

/// Where a window's toasts land: centred on the stage, 16px off the edge,
/// newest nearest the edge. Pin it inside the [Stack] that should own the
/// notifications — usually the window's root, so the stack clears the sidebar
/// the way a sheet does. Transparent to the pointer between toasts.
class ToastViewport extends StatelessWidget {
  const ToastViewport({
    super.key,
    this.placement = ToastPlacement.bottom,
    this.children = const [],
  });

  final ToastPlacement placement;

  /// Append in order shown; the column direction keeps the newest toast
  /// nearest the edge, pushing older ones inward.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ordered =
        placement == ToastPlacement.top ? children.reversed.toList() : children;

    return Positioned(
      left: 0,
      right: 0,
      top: placement == ToastPlacement.top ? 16 : null,
      bottom: placement == ToastPlacement.bottom ? 16 : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < ordered.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              ordered[i],
            ],
          ],
        ),
      ),
    );
  }
}
