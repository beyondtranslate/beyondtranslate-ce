import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// The box the text controls share, and the geometry that sizes it.
///
/// `text-field.css` names five wearers of one box — the field, the read-only
/// value, the select trigger, the number field's group and the combobox's —
/// and says why: a select is a field with a chevron, so the three drifting
/// apart would be the bug rather than the feature. This file is that
/// stylesheet's rule, written once so the widgets here cannot drift either.
///
/// It takes a resolved ramp rather than a tint, so the file that owns the
/// tint enum can call it without either importing the other.
@immutable
class FieldMetrics {
  const FieldMetrics({
    required this.height,
    required this.paddingBlock,
    required this.face,
  });

  /// The control height, so a form can mix fields with buttons without the
  /// rows stepping.
  final double height;

  final double paddingBlock;

  /// The control profile's own type at this size.
  final TextStyle face;

  static FieldMetrics of(ThemeVariables vars, WidgetSize size) {
    return switch (size.namedSize) {
      NamedSize.tiny => FieldMetrics(
        height: vars.controlTinySize,
        paddingBlock: vars.controlTinyPaddingBlock,
        face: vars.labelSmall,
      ),
      NamedSize.small => FieldMetrics(
        height: vars.controlSmallSize,
        paddingBlock: vars.controlSmallPaddingBlock,
        face: vars.labelMedium,
      ),
      NamedSize.large => FieldMetrics(
        height: vars.controlLargeSize,
        paddingBlock: vars.controlLargePaddingBlock,
        face: vars.labelMedium,
      ),
      _ => FieldMetrics(
        height: vars.controlMediumSize,
        paddingBlock: vars.controlMediumPaddingBlock,
        face: vars.labelMedium,
      ),
    };
  }
}

/// The box: a recessed card one step below the paper, lifting to the paper on
/// focus behind an accent border and a soft accent wash.
///
/// That card→paper transition is the focus signal; a field that stays white
/// can only signal with its ring. An erroring field is re-tinted rather than
/// given a second palette, so its border, wash and ink all move together.
BoxDecoration fieldBoxDecoration(
  BuildContext context, {
  required ColorSwatch<int> ramp,
  bool focused = false,
  bool invalid = false,
  bool enabled = true,

  /// A control that grows — a multiline field — takes the container corner
  /// rather than the control one: a pill textarea reads as a lozenge.
  bool grows = false,
}) {
  final ThemeVariables vars = Theme.of(context).vars;
  final Color accent = ramp[vars.focusRingShade]!;
  final BorderRadius radius = BorderRadius.circular(
    grows ? vars.radiusLarge : vars.controlFieldRadius,
  );

  if (!enabled) {
    // Disabled flattens to the groove, but the edge stays where the base rule
    // put it: a field that lost its outline would read as a label rather than
    // as a control that is merely not taking input.
    return BoxDecoration(
      color: vars.controlColorNormalSurface.disabledColor!,
      border: Border.all(
        color: vars.colorBorderStrong,
        width: context.hairlineWidth,
      ),
      borderRadius: radius,
    );
  }

  return BoxDecoration(
    color: invalid
        ? ramp[50]!
        : (focused ? vars.colorSurface : vars.colorSurfaceMuted),
    border: Border.all(
      color: focused || invalid ? accent : vars.colorBorderStrong,
      // One width in every state: a border that thickened on focus would shift
      // the text it wraps by half a pixel.
      width: context.hairlineWidth,
    ),
    borderRadius: radius,
    boxShadow: focused
        ? [
            BoxShadow(
              color: accent.withValues(alpha: vars.focusGlowAlpha),
              spreadRadius: vars.focusWidth,
            ),
          ]
        : null,
  );
}
