import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../foundation/widget_variant.dart';
import '../generated/theme_variables.dart';
import '../painting/widget_property.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// The tint of an icon button.
enum IconButtonTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// The variant of an icon button.
enum IconButtonVariant with WidgetVariant {
  normal,
  recessed,
  filled,
  tinted,
  outlined,
  plain,
}

/// A square button.
///
/// Colour comes from the shared control recipes, but the default posture —
/// the plain variant on the neutral tint — carries its own quiet chrome: a
/// subtle-ink glyph that washes grey and darkens to full ink under the
/// pointer, and turns accent when held on. A toolbar row of these has to read
/// as chrome until touched, and the recipes' neutral ramp is too flat a grey
/// for that.
class IconButton extends StatefulWidget {
  const IconButton({
    super.key,
    required this.icon,
    this.tint,
    this.variant,
    this.active = false,
    this.size = WidgetSize.tiny,
    this.iconSize,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHover,
    this.semanticsLabel,
    required this.onPressed,
  });

  final IconData icon;

  final IconButtonTint? tint;

  final IconButtonVariant? variant;

  /// A persistent on-state — a pin held down, a panel kept open. The glyph
  /// takes the accent's text grade and the fill goes: "this is on" is a
  /// colour statement, not a chip.
  final bool active;

  final WidgetSize size;

  /// The glyph is smaller than the square it sits in.
  final double? iconSize;

  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHover;
  final String? semanticsLabel;

  final VoidCallback? onPressed;

  bool get enabled => onPressed != null;

  @override
  State<IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<IconButton> {
  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final IconButtonVariant variant = widget.variant ?? IconButtonVariant.plain;
    final IconButtonTint tint = widget.tint ?? IconButtonTint.neutral;

    // The default posture keeps its own quiet chrome; anything else resolves
    // against the recipes like every other control.
    final bool quietChrome =
        variant == IconButtonVariant.plain && tint == IconButtonTint.neutral;

    final (double box, double radius) = switch (widget.size.namedSize) {
      NamedSize.small => (vars.controlSmallSize, vars.controlSmallRadius),
      NamedSize.medium => (vars.controlMediumSize, vars.controlMediumRadius),
      NamedSize.large => (vars.controlLargeSize, vars.controlLargeRadius),
      _ => (vars.controlTinySize, vars.controlTinyRadius),
    };
    final BorderRadius corner = BorderRadius.circular(radius);

    return Pressable(
      onPressed: widget.onPressed,
      enabled: widget.enabled,
      borderRadius: corner,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.onFocusChange,
      onHover: widget.onHover,
      semanticsLabel: widget.semanticsLabel,
      builder: (context, states) {
        final bool hovered = states.contains(WidgetState.hovered);

        Color surface;
        Color content;
        Color border;

        if (widget.active) {
          surface = const Color(0x00000000);
          content = vars.colorPrimary[700]!;
          border = const Color(0x00000000);
        } else if (quietChrome) {
          // A toolbar glyph washes neutral, not accent.
          surface = hovered && widget.enabled
              ? vars.colorSurfaceSubtle
              : const Color(0x00000000);
          content = widget.enabled
              ? (hovered ? vars.colorContent : vars.colorContentSubtle)
              : vars.controlColorNormalContent.disabledColor!;
          border = const Color(0x00000000);
        } else {
          final ColorSwatch<int> ramp = vars.controlColor.tinted(tint);
          Color resolve(WidgetProperty<Color> Function() get) =>
              get().resolveWith(
                states,
                variant: variant,
                extra: {
                  'seedColor': ramp,
                },
              );
          surface = resolve(() => vars.controlColorSurface);
          content = resolve(() => vars.controlColorContent);
          border = resolve(() => vars.controlColorBorder);
        }

        return AnimatedContainer(
          duration: vars.motionDuration,
          curve: vars.motionEasing,
          width: box,
          height: box,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: surface, borderRadius: corner),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: border, width: context.hairlineWidth),
            borderRadius: corner,
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize ?? vars.spacing35,
            color: content,
          ),
        );
      },
    );
  }
}
