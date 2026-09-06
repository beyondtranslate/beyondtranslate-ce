import 'package:flutter/widgets.dart';

import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// How loud a [SectionLabel] is.
enum SectionLabelTone {
  /// The labelling ink. The default.
  normal,

  /// One step fainter, for a nav group's heading.
  faint,
}

/// The tint a [SectionLabel] may carry when it reports a status.
enum SectionLabelTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// The micro-heading that organises a pane.
///
/// One size, sentence case, no added tracking: tone is the only axis worth
/// varying — the labelling ink by default, one step fainter for a nav group's
/// heading, and a tint's *text* grade when the label carries a status,
/// because a label is read, not pressed.
class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.label, {
    super.key,
    this.tone = SectionLabelTone.normal,
    this.tint,
  });

  final String label;

  final SectionLabelTone tone;

  /// Set only when the caller asks for one, so an untinted label keeps the
  /// labelling ink rather than resolving against a ramp it never chose.
  final SectionLabelTint? tint;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    Color color = switch (tone) {
      SectionLabelTone.faint => vars.colorContentFaint,
      SectionLabelTone.normal => vars.colorContentSubtle,
    };
    if (tint != null) {
      final ColorSwatch<int> ramp = switch (tint!) {
        SectionLabelTint.primary => vars.colorPrimary,
        SectionLabelTint.neutral => vars.colorNeutral,
        SectionLabelTint.info => vars.colorInfo,
        SectionLabelTint.success => vars.colorSuccess,
        SectionLabelTint.warning => vars.colorWarning,
        SectionLabelTint.danger => vars.colorDanger,
      };
      // The *text* grade of the tint, not its fill.
      color = ramp[vars.controlColorPlainContent.normalShade!]!;
    }

    return Text(label, style: vars.labelSmall.copyWith(color: color));
  }
}
