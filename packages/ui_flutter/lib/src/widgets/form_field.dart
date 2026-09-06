import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// Label, control, hint.
///
/// The wrapper draws no box of its own — the control it holds does that — so
/// it owns only the space between the three and the type of the two it prints
/// itself.
class FormField extends StatelessWidget {
  const FormField({
    super.key,
    this.label,
    this.hint,
    this.invalid = false,
    required this.child,
  });

  final String? label;
  final String? hint;

  /// Erroring, the label and the hint join the control on the danger ramp,
  /// which the wrapper is re-tinted to rather than given its own error
  /// colours.
  final bool invalid;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final Color ink = invalid
        ? vars.colorDanger[vars.controlColorPlainContent.normalShade!]!
        : vars.colorContentSubtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: vars.spacing15,
      children: [
        if (label != null)
          Text(label!, style: vars.labelSmall.copyWith(color: ink)),
        child,
        if (hint != null)
          Text(
            hint!,
            style: vars.labelQuiet.copyWith(height: 1.6, color: ink),
          ),
      ],
    );
  }
}
