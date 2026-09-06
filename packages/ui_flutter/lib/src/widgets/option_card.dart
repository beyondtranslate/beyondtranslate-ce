import 'package:flutter/widgets.dart';

import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// The ramp a chosen card is washed and drawn in.
enum OptionCardTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// A selectable card — the shape a small set of mutually exclusive choices
/// takes when each needs a line of explanation and a radio row would not
/// carry it.
///
/// The type runs title-over-description in the strong/caption pair: a display
/// face title at the strong weight over a caption. The card is one of the two
/// places the hierarchy is carried by *both* size and weight, because the two
/// lines sit closer than anywhere else in the system.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    this.description,
    required this.selected,
    required this.onPressed,
    this.tint = OptionCardTint.primary,
    this.semanticsLabel,
  });

  final String title;
  final String? description;
  final bool selected;

  /// The ramp the chosen state is washed and drawn in.
  final OptionCardTint tint;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final BorderRadius radius = BorderRadius.circular(vars.radiusLarge);
    final ColorSwatch<int> ramp = switch (tint.namedTint) {
      NamedTint.primary => vars.colorPrimary,
      NamedTint.neutral => vars.colorNeutral,
      NamedTint.info => vars.colorInfo,
      NamedTint.success => vars.colorSuccess,
      NamedTint.warning => vars.colorWarning,
      NamedTint.danger => vars.colorDanger,
    };

    return Pressable(
      onPressed: onPressed,
      enabled: _enabled,
      checked: selected,
      isButton: false,
      borderRadius: radius,
      semanticsLabel: semanticsLabel,
      builder: (context, states) {
        final bool hovered = states.contains(WidgetState.hovered);

        Color surface = vars.colorSurfaceMuted;
        Color border = vars.colorBorder;
        double borderWidth = context.hairlineWidth;
        Color descriptionColor = vars.colorContentSubtle;

        if (!_enabled) {
          surface = vars.controlColorNormalSurface.disabledColor!;
          descriptionColor = vars.controlColorNormalContent.disabledColor!;
        } else if (selected) {
          // The surface wash with the accent drawn around it at the control
          // stroke — the border *thickens* as well as colours, which is what
          // makes the chosen card survive a glance across its neighbours. The
          // wash, not the `tinted` recipe's chip fill: a card is a surface,
          // and the chip's 12% fills it rather than tinting it.
          surface = ramp[600]!.withValues(alpha: vars.washSurface);
          border = ramp[vars.controlColorOutlinedBorder.normalShade!]!;
          borderWidth = vars.strokeControl;
          descriptionColor = vars.colorContentMuted;
        } else if (hovered) {
          surface = vars.colorSurfaceSubtle;
        }

        return AnimatedContainer(
          duration: vars.motionDuration,
          curve: vars.motionEasing,
          padding: EdgeInsets.symmetric(
            vertical: vars.spacing35,
            horizontal: vars.spacing3,
          ),
          decoration: BoxDecoration(
            color: surface,
            border: Border.all(color: border, width: borderWidth),
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: vars.spacing15,
            children: [
              Text(
                title,
                style: vars.labelStrong.copyWith(
                  color: _enabled
                      ? vars.colorContent
                      : vars.controlColorNormalContent.disabledColor,
                ),
              ),
              if (description != null)
                Text(
                  description!,
                  style: vars.captionSmall.copyWith(
                    fontSize: vars.labelSmall.fontSize,
                    height: 1.5,
                    color: descriptionColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
