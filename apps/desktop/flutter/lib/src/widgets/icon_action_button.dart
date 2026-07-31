import 'package:flutter/material.dart';

import 'ui.dart' show DesignThemeContext, Pressable, kTransitionDuration;

/// A 32pt square icon affordance for toolbars, built on the design system's
/// [Pressable] so it gets the same hover, focus ring and keyboard activation
/// as every other control.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    this.tooltip,
    required this.onPressed,
    this.selected = false,
    this.iconTurns = 0,
  });

  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final bool selected;

  /// Animated rotation of the glyph, in turns — the pin lies at -45° until
  /// pinned, matching the deck.
  final double iconTurns;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.controlSm);

    final button = Pressable(
      onPressed: onPressed,
      enabled: onPressed != null,
      borderRadius: radius,
      semanticsLabel: tooltip,
      builder: (context, state) => Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? colors.accentSurface
              : (state.hovered ? colors.controlHover : null),
          borderRadius: radius,
        ),
        child: AnimatedRotation(
          turns: iconTurns,
          duration: kTransitionDuration,
          child: Icon(
            icon,
            size: 17,
            color: selected
                ? colors.accentText
                : (onPressed == null ? colors.fgFaint : colors.fgControl),
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
