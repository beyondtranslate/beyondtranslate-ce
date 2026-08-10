import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum StageVariant {
  backdrop,

  /// Uses the solid canvas colour instead of the gradient plate.
  flat,
}

enum StagePadding { sm, md, lg }

/// The tinted plate the design deck floats every mockup on. Useful in
/// galleries and marketing shots; app shells normally render the window
/// directly.
class Stage extends StatelessWidget {
  const Stage({
    super.key,
    this.variant = StageVariant.backdrop,
    this.padding = StagePadding.md,
    this.child,
  });

  final StageVariant variant;
  final StagePadding padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final insets = switch (padding) {
      StagePadding.sm => const EdgeInsets.all(30),
      StagePadding.md => const EdgeInsets.all(34),
      StagePadding.lg => const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 34,
        ),
    };

    return Container(
      padding: insets,
      decoration: BoxDecoration(
        color: variant == StageVariant.flat ? tokens.colors.canvas : null,
        gradient: variant == StageVariant.backdrop ? tokens.backdrop : null,
        borderRadius: BorderRadius.circular(tokens.radii.backdrop),
      ),
      child: child,
    );
  }
}

/// Row of small controls — 朗读 / 复制 / 收藏 with a primary action pushed
/// right.
class ActionBar extends StatelessWidget {
  const ActionBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            children[i],
          ],
        ],
      );
}
