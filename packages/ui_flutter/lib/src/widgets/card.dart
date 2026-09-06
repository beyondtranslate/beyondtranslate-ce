import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// The tint a [Card] resolves its wash against.
enum CardTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// The surface treatments a card can wear.
enum CardVariant {
  /// Paper with the hairline. The default.
  raised,

  /// The workaday card: one step off the paper, with the hairline — the
  /// surface most content sits on.
  sunken,

  /// The hairline alone, over whatever is behind it.
  outlined,

  /// A wash of the tint. It takes the shared surface wash rather than the
  /// `tinted` recipe's chip fill: a card is the largest thing a tint washes
  /// here, and the chip's 12% fills it instead of tinting it.
  tinted,
}

/// A surface. Content sits on it; it never answers the pointer itself, which
/// is why it reads the resting recipes directly rather than opting into the
/// shared control state machine.
class Card extends StatelessWidget {
  const Card({
    super.key,
    this.variant = CardVariant.raised,
    this.tint = CardTint.primary,
    this.size = WidgetSize.medium,
    this.child,
  });

  final CardVariant variant;

  final CardTint tint;

  final WidgetSize size;

  final Widget? child;

  ColorSwatch<int> _ramp(ThemeVariables vars) {
    return switch (tint) {
      CardTint.primary => vars.colorPrimary,
      CardTint.neutral => vars.colorNeutral,
      CardTint.info => vars.colorInfo,
      CardTint.success => vars.colorSuccess,
      CardTint.warning => vars.colorWarning,
      CardTint.danger => vars.colorDanger,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final Color ramp = _ramp(vars)[600]!;

    final (Color surface, Color border) = switch (variant) {
      CardVariant.raised => (vars.colorSurface, vars.colorBorder),
      CardVariant.sunken => (vars.colorSurfaceMuted, vars.colorBorder),
      CardVariant.outlined => (const Color(0x00000000), vars.colorBorder),
      // The edge is the matching wash, so the pair moves together when
      // either is retuned.
      CardVariant.tinted => (
        ramp.withValues(alpha: vars.washSurface),
        ramp.withValues(alpha: vars.washEdge),
      ),
    };

    final EdgeInsetsGeometry resolvedPadding = switch (size) {
      WidgetSize.small => EdgeInsets.all(vars.spacing3),
      // The card padding is asymmetric — a hair more inline than block —
      // which keeps a one-line row inside it optically centred.
      WidgetSize.large => EdgeInsets.all(vars.spacing4),
      _ => EdgeInsets.symmetric(
        vertical: vars.spacing3,
        horizontal: vars.spacing35,
      ),
    };

    final double radius = switch (size) {
      WidgetSize.small => vars.radiusMedium,
      _ => vars.radiusLarge,
    };

    return Semantics(
      container: true,
      child: Container(
        padding: resolvedPadding,
        decoration: BoxDecoration(
          color: surface,
          // Transparent rather than absent, so `outlined` and `tinted` do
          // not gain a pixel per side and sit a hair larger than the
          // filled variants.
          border: Border.all(color: border, width: context.hairlineWidth),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}
