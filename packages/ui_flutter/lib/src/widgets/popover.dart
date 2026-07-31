import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// The menu-bar popover shell: a padded tray whose contents sit on an inner
/// card, so the tray colour reads as a frame around the result.
class PopoverWindow extends StatelessWidget {
  const PopoverWindow({super.key, this.width, this.child});

  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      width: width ?? tokens.metrics.miniWidth,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.tray,
        border: Border.all(
          color: colors.border,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.popover),
        boxShadow: tokens.shadows.popover,
      ),
      child: child,
    );
  }
}

/// The inner card of the mini window (and of the extension popup). `panel` is
/// its own token rather than `window`, because which of tray/panel is the
/// brighter surface flips between the Studio and Bright palettes.
class PopoverPanel extends StatelessWidget {
  const PopoverPanel({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border.all(
          color: colors.border,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.card),
      ),
      child: child,
    );
  }
}

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
    final label =
        page is int ? page.toString().padLeft(2, '0') : page.toString();

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
              color: active ? colors.highlight : colors.borderStrong,
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
