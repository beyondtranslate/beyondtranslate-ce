import 'package:flutter/material.dart' hide IconButton;

import 'ui.dart' show IconButton, kTransitionDuration;

/// The design system's 24pt flat toolbar affordance, taking an [IconData]
/// instead of a widget, wearing a native tooltip, and adding the optional
/// rotation the mini translator's pin needs.
///
/// Everything visual — geometry, hover wash, active read, disabled dimming —
/// comes from the package's [IconButton], so this stays a convenience adapter
/// rather than a second implementation.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    this.tooltip,
    required this.onPressed,
    this.selected = false,
    this.iconTurns = 0,
    this.iconSize = 14,
  });

  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final bool selected;

  /// The deck sizes the glyph per call site: 18 in the mini-window toolbar,
  /// 16 in the sidebar header.
  final double iconSize;

  /// Animated rotation of the glyph, in turns — the pin lies at -45° until
  /// pinned, matching the deck.
  final double iconTurns;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      label: tooltip ?? '',
      active: selected,
      iconSize: iconSize,
      onPressed: onPressed,
      icon: AnimatedRotation(
        turns: iconTurns,
        duration: kTransitionDuration,
        child: Icon(icon),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
