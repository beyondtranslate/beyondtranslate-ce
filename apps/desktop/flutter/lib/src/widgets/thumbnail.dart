import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Pressable,
        kTransitionDuration;

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
    final tokens = context.tokens;
    final colors = tokens.colors;
    // 74px tall — a miniature page, so it takes the content-surface corner
    // rather than the chip corner a pill theme would blow out.
    final radius = BorderRadius.circular(tokens.radii.card);
    final label = page is int
        ? page.toString().padLeft(2, '0')
        : page.toString();

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      selected: active,
      isButton: false,
      builder: (context, state) => Opacity(
        opacity: dimmed ? 0.55 : 1,
        child: AnimatedContainer(
          duration: kTransitionDuration,
          height: 74,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: active ? colors.accentSurface : colors.window,
            borderRadius: radius,
            border: Border.all(
              color: active ? colors.highlight : colors.hairlineStrong,
              width: active ? 1.5 : context.hairlineWidth,
            ),
          ),
          child: Text(
            label,
            style: tokens.typography.displayStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
              color: active ? colors.accentText : colors.fgFaint,
            ),
          ),
        ),
      ),
    );
  }
}
