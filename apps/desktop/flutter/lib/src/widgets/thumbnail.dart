import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import 'ui.dart' show Pressable, ThemeDataBuildContextProps;

/// Page thumbnail in the document-translation rail.
class Thumbnail extends StatelessWidget {
  const Thumbnail({
    super.key,
    required this.page,
    this.active = false,
    this.dimmed = false,
    this.onPressed,
  });

  /// An `int` is zero-padded to two digits, matching the deck.
  final Object page;
  final bool active;

  /// Not yet reached in the pipeline.
  final bool dimmed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    // 74px tall — a miniature page, so it takes the content-surface corner
    // rather than the chip corner a pill theme would blow out.
    final radius = BorderRadius.circular(vars.radiusLarge);
    final label =
        page is int ? page.toString().padLeft(2, '0') : page.toString();

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      selected: active,
      isButton: false,
      builder: (context, states) => Opacity(
        opacity: dimmed ? 0.55 : 1,
        child: AnimatedContainer(
          duration: context.vars.motionDuration,
          height: 74,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: active ? vars.accentSurface : vars.colorSurface,
            borderRadius: radius,
            border: Border.all(
              color: active ? vars.highlight : vars.colorBorderStrong,
              width: active ? 1.5 : context.hairlineWidth,
            ),
          ),
          child: Text(
            label,
            style: vars.displayStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
              color: active ? vars.accentText : vars.colorContentFaint,
            ),
          ),
        ),
      ),
    );
  }
}
