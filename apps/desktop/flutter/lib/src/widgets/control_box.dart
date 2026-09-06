/// The box a native control is drawn in.
///
/// The kit draws this box inside each of its own controls, where it belongs.
/// Two places in the app put a *platform* view where a kit control would go —
/// the macOS dropdown and the language field — and those still have to match
/// the fields beside them, so the recipe is spelled out once here, from the
/// same tokens the kit resolves.
library;

import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductPalette;
import 'ui.dart' show TextFieldState, ThemeVariables;

BoxDecoration controlDecoration(
  ThemeVariables vars, {
  required TextFieldState state,
  required bool focused,
  required double hairline,
  double? radius,
}) {
  final bool error = state == TextFieldState.error;
  final Color ring = vars.colorPrimary[vars.focusRingShade]!;

  return BoxDecoration(
    // Focus lifts the field to the paper behind it — the move every kit text
    // control makes.
    color: error
        ? vars.dangerSurface
        : (focused ? vars.colorSurface : vars.colorSurfaceMuted),
    // Focus and error change the border's *colour* only, so the width stays on
    // the hairline in every state: thickening it would shift the text by half
    // a pixel the moment the field takes focus.
    border: Border.all(
      color: error ? vars.danger : (focused ? ring : vars.colorBorderStrong),
      width: hairline,
    ),
    borderRadius: BorderRadius.circular(radius ?? vars.radiusMedium),
    boxShadow: focused
        ? [
            BoxShadow(
              color: ring.withValues(alpha: vars.focusGlowAlpha),
              spreadRadius: vars.focusWidth,
            ),
          ]
        : null,
  );
}
