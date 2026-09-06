import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'spinner_ring.dart';

/// The tint a [Spinner] draws in.
enum SpinnerTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// A ring with one segment picked out: the track is the tint at quarter
/// strength, the head the tint itself, and the whole thing turns once a
/// second — fast enough to read as work, slow enough not to read as alarm.
class Spinner extends StatelessWidget {
  const Spinner({
    super.key,
    this.size = WidgetSize.medium,
    this.tint = SpinnerTint.primary,
    this.color,
    this.onAccent = false,
  });

  final WidgetSize size;

  final SpinnerTint tint;

  final Color? color;

  /// On a filled control the ring goes to the accent's contrasting ink — a
  /// tinted spinner on its own tint's fill is invisible.
  final bool onAccent;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    final Color resolvedColor =
        color ??
        (onAccent
            ? vars.colorOnAccent
            : switch (tint) {
                SpinnerTint.primary => vars.colorPrimary[600]!,
                SpinnerTint.neutral => vars.colorNeutral[600]!,
                SpinnerTint.info => vars.colorInfo[600]!,
                SpinnerTint.success => vars.colorSuccess[600]!,
                SpinnerTint.warning => vars.colorWarning[600]!,
                SpinnerTint.danger => vars.colorDanger[600]!,
              });

    final double dimension = switch (size.namedSize) {
      NamedSize.large => vars.spacing5,
      NamedSize.medium => vars.spacing4,
      _ => vars.spacing35,
    };

    return SizedBox(
      width: dimension,
      height: dimension,
      child: SpinnerRing(
        size: dimension,
        color: resolvedColor,
        // A wash rather than a ramp step, so the track sits as correctly over
        // a tinted chip or a dark canvas as over the paper.
        trackAlpha: onAccent ? 0.35 : 0.25,
        strokeWidth: vars.spacing05,
      ),
    );
  }
}
