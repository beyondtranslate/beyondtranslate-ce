import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

enum SwapPairSize { sm, md }

/// A capsule holding two labels with a swap button between them — the
/// English ⇄ 简体中文 control that anchors every titlebar.
class SwapPair extends StatelessWidget {
  const SwapPair({
    super.key,
    required this.start,
    required this.end,
    this.onSwap,
    this.onEndPressed,
    this.endOpen = false,
    this.size = SwapPairSize.md,
    this.swapSemanticsLabel = '交换',
  });

  final String start;

  /// Set in the CJK face, since it is normally the target language.
  final String end;
  final VoidCallback? onSwap;

  /// Makes the end label a menu trigger — chevron, hover wash, expanded state.
  final VoidCallback? onEndPressed;

  /// Open state of the end menu, when [onEndPressed] is set.
  final bool endOpen;
  final SwapPairSize size;
  final String swapSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final swapBox = size == SwapPairSize.md ? 20.0 : 19.0;
    final swapRadius = BorderRadius.circular(tokens.radii.chip);

    return Container(
      padding: const EdgeInsets.fromLTRB(11, 5, 6, 5),
      decoration: BoxDecoration(
        color: colors.control,
        borderRadius: BorderRadius.circular(tokens.radii.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            start,
            style: tokens.typography.sansStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1,
              color: colors.fg,
            ),
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
                  color: state.hovered ? colors.fg : colors.fgTertiary,
                ),
                child: const Icon(FluentIcons.arrow_swap_20_regular),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (onEndPressed != null)
            Pressable(
              onPressed: onEndPressed,
              borderRadius: swapRadius,
              builder: (context, state) => AnimatedContainer(
                duration: kTransitionDuration,
                padding: const EdgeInsets.fromLTRB(6, 4, 4, 4),
                decoration: BoxDecoration(
                  color: endOpen || state.hovered ? colors.window : null,
                  borderRadius: swapRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      end,
                      style: tokens.typography.cjkStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        color: colors.fg,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconTheme(
                      data: IconThemeData(size: 9, color: colors.fgTertiary),
                      child: const Icon(FluentIcons.chevron_down_20_regular),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                end,
                style: tokens.typography.cjkStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: colors.fg,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
