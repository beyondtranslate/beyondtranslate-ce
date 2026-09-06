import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// The tint a [Checkbox] fills with when it is checked.
enum CheckboxTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// A box and a label on one row.
///
/// The box defines the row — there is no minimum height, so a stacked
/// checklist sits at the density the boxes set — and the label carries the
/// selection signal twice over: it rests quiet (one ink step back, at the
/// quiet weight) and takes the full ink and the label weight only when its box
/// is checked. A checked row you cannot pick out of the list by its label
/// alone is not signalling.
class Checkbox extends StatelessWidget {
  const Checkbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.note,
    this.tint = CheckboxTint.primary,
    this.size = WidgetSize.medium,
    this.focusNode,
    this.autofocus = false,
    this.semanticsLabel,
  });

  final bool value;

  final ValueChanged<bool>? onChanged;

  /// The row's label. Without one the checkbox is the bare box.
  final Widget? label;

  /// A trailing de-emphasised note. It rides on the label rather than on the
  /// row, so it wraps with it instead of being pushed to the far edge the way
  /// a control would be.
  final Widget? note;

  final CheckboxTint tint;

  final WidgetSize size;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticsLabel;

  bool get _enabled => onChanged != null;

  void _handleTap() => onChanged!(!value);

  ColorSwatch<int> _ramp(ThemeVariables vars) {
    return switch (tint) {
      CheckboxTint.primary => vars.colorPrimary,
      CheckboxTint.neutral => vars.colorNeutral,
      CheckboxTint.info => vars.colorInfo,
      CheckboxTint.success => vars.colorSuccess,
      CheckboxTint.warning => vars.colorWarning,
      CheckboxTint.danger => vars.colorDanger,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool marked = value;

    final double box = switch (size.namedSize) {
      NamedSize.large => vars.checkboxLargeBox,
      NamedSize.medium => vars.checkboxMediumBox,
      _ => vars.checkboxSmallBox,
    };
    final Color fill = _ramp(
      vars,
    )[vars.controlColorFilledSurface.normalShade!]!;
    // The box corner is the component's own token: any shared step doubles as
    // a pill under Bright, and a checkbox that goes round is a radio.
    final BorderRadius radius = BorderRadius.circular(vars.checkboxRadius);

    return Pressable(
      enabled: _enabled,
      onPressed: _enabled ? _handleTap : null,
      borderRadius: radius,
      checked: value,
      isButton: false,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticsLabel: semanticsLabel,
      builder: (context, states) => Opacity(
        opacity: _enabled ? 1 : 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: vars.motionDuration,
              curve: vars.motionEasing,
              width: box,
              height: box,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: marked ? fill : null,
                borderRadius: radius,
                // Neutral while empty: an unchecked box is an outline, not a
                // quiet accent.
                border: marked
                    ? null
                    : Border.all(
                        color: vars.colorBorderMuted,
                        width: vars.checkboxThickness,
                      ),
              ),
              child: marked
                  ? _Mark(
                      color: vars.colorOnAccent,
                      // The glyph sits a step under the label so it clears the
                      // box's corners.
                      dimension: vars.labelSmall.fontSize!,
                    )
                  : null,
            ),
            if (label != null) ...[
              SizedBox(width: vars.spacing25),
              Flexible(
                child: DefaultTextStyle(
                  style: vars.labelQuiet.copyWith(
                    fontWeight: marked
                        ? vars.labelMedium.fontWeight
                        : vars.labelQuiet.fontWeight,
                    color: marked ? vars.colorContent : vars.colorContentMuted,
                  ),
                  child: note == null
                      ? label!
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(child: label!),
                            SizedBox(width: vars.spacing1),
                            DefaultTextStyle(
                              style: vars.labelQuiet.copyWith(
                                color: vars.colorContentFaint,
                              ),
                              child: note!,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The check.
class _Mark extends StatelessWidget {
  const _Mark({
    required this.color,
    required this.dimension,
  });

  final Color color;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(dimension),
      painter: _MarkPainter(color: color),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double w = size.width;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, w * 0.52)
        ..lineTo(w * 0.42, w * 0.72)
        ..lineTo(w * 0.78, w * 0.28),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) => oldDelegate.color != color;
}
