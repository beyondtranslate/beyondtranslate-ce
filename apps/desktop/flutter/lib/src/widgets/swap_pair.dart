import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Pressable,
        kTransitionDuration;

enum SwapPairSize { sm, md }

/// A capsule holding two labels with a swap button between them — the
/// English ⇄ 简体中文 control that anchors every titlebar.
///
/// Either end can be turned into a menu trigger by passing its callback, which
/// adds the disclosure chevron and the hover wash. A trigger on the start end
/// also tightens the capsule's leading inset, because the chip brings its own.
class SwapPair extends StatelessWidget {
  const SwapPair({
    super.key,
    required this.start,
    required this.end,
    this.onSwap,
    this.onStartPressed,
    this.startOpen = false,
    this.onEndPressed,
    this.endOpen = false,
    this.startKey,
    this.endKey,
    this.size = SwapPairSize.md,
    this.swapSemanticsLabel = '交换',
  });

  final String start;

  /// Set in the CJK face, since it is normally the target language.
  final String end;
  final VoidCallback? onSwap;

  /// Makes the start label a menu trigger — chevron, hover wash, expanded
  /// state.
  final VoidCallback? onStartPressed;

  /// Open state of the start menu, when [onStartPressed] is set.
  final bool startOpen;

  /// Makes the end label a menu trigger — chevron, hover wash, expanded state.
  final VoidCallback? onEndPressed;

  /// Open state of the end menu, when [onEndPressed] is set.
  final bool endOpen;

  /// Attached to each end so a native menu can be anchored under the label it
  /// belongs to rather than under the whole capsule.
  final Key? startKey;
  final Key? endKey;

  final SwapPairSize size;
  final String swapSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final swapBox = size == SwapPairSize.md ? 20.0 : 18.0;
    final swapRadius = BorderRadius.circular(tokens.radii.chip);

    return Container(
      // The trigger chip carries its own leading inset, so the capsule gives
      // back the difference when the start end is one.
      padding: EdgeInsets.fromLTRB(onStartPressed == null ? 11 : 6, 5, 6, 5),
      decoration: BoxDecoration(
        color: colors.control,
        borderRadius: BorderRadius.circular(tokens.radii.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SwapPairSide(
            key: startKey,
            label: start,
            onPressed: onStartPressed,
            open: startOpen,
          ),
          const SizedBox(width: 8),
          Pressable(
            onPressed: onSwap,
            borderRadius: swapRadius,
            semanticsLabel: swapSemanticsLabel,
            builder: (context, state) => AnimatedContainer(
              duration: kTransitionDuration,
              width: swapBox,
              height: swapBox,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.window,
                borderRadius: swapRadius,
              ),
              child: IconTheme(
                data: IconThemeData(
                  size: 12,
                  color: onSwap == null
                      ? colors.fgFaint
                      : (state.hovered ? colors.fg : colors.fgTertiary),
                ),
                child: const Icon(FluentIcons.arrow_swap_20_regular),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SwapPairSide(
            key: endKey,
            label: end,
            cjk: true,
            onPressed: onEndPressed,
            open: endOpen,
          ),
        ],
      ),
    );
  }
}

/// One side of the pair: a static label, or a menu trigger when wired.
class _SwapPairSide extends StatelessWidget {
  const _SwapPairSide({
    super.key,
    required this.label,
    this.cjk = false,
    this.onPressed,
    this.open = false,
  });

  final String label;

  /// The end side prints CJK; the start side keeps the sans face.
  final bool cjk;
  final VoidCallback? onPressed;
  final bool open;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final style = cjk
        ? tokens.typography.cjkStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: colors.fg,
          )
        : tokens.typography.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: colors.fg,
          );

    if (onPressed == null) {
      return Padding(
        // The static end keeps a hair of breathing room inside the capsule;
        // the static start sits against the capsule's own 11px inset.
        padding: EdgeInsets.only(right: cjk ? 5 : 0),
        child: Text(label, style: style),
      );
    }

    final radius = BorderRadius.circular(tokens.radii.chip);
    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      semanticsLabel: label,
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.fromLTRB(6, 4, 4, 4),
        decoration: BoxDecoration(
          color: open || state.hovered ? colors.window : null,
          borderRadius: radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: style),
            const SizedBox(width: 4),
            IconTheme(
              data: IconThemeData(size: 9, color: colors.fgTertiary),
              child: const Icon(FluentIcons.chevron_down_20_regular),
            ),
          ],
        ),
      ),
    );
  }
}
