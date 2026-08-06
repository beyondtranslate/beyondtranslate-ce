import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum BadgeTone { accent, neutral, solid, success, warn, danger }

enum BadgeSize {
  /// 术语库 / 默认 — the smallest tag in the deck.
  xs,

  /// 3 SERVICES.
  sm,
}

class Badge extends StatelessWidget {
  const Badge({
    super.key,
    this.tone = BadgeTone.accent,
    this.size = BadgeSize.xs,
    required this.child,
  });

  final BadgeTone tone;
  final BadgeSize size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final (Color background, Color foreground) = switch (tone) {
      BadgeTone.accent => (
          colors.accent.withValues(alpha: 0.12),
          colors.accentText,
        ),
      BadgeTone.neutral => (colors.window, colors.fgTertiary),
      BadgeTone.solid => (colors.accent, colors.onAccent),
      BadgeTone.success => (colors.successSurface, colors.success),
      BadgeTone.warn => (colors.warnSurface, colors.warnFg),
      BadgeTone.danger => (colors.dangerSurface, colors.dangerFg),
    };

    final padding = switch (size) {
      BadgeSize.xs => const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      BadgeSize.sm => const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    };
    final radius = switch (size) {
      BadgeSize.xs => 7.0,
      BadgeSize.sm => tokens.radii.chip,
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: DefaultTextStyle(
        style: tokens.typography.displayStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: foreground,
        ),
        child: child,
      ),
    );
  }
}
