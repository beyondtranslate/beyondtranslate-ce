import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:beyondtranslate_ui/src/widgets/progress.dart';
import 'package:flutter/widgets.dart';

enum FloatingBallState { idle, translating, expanded }

/// The in-page floating trigger, in the three states the design specifies:
/// resting mark, in-flight spinner, and the hover capsule with a summary.
class FloatingBall extends StatelessWidget {
  const FloatingBall({
    super.key,
    this.state = FloatingBallState.idle,
    this.glyph = 'B',
    this.summary = '',
    this.onPressed,
    this.semanticsLabel,
  });

  final FloatingBallState state;

  /// The mark inside the ball.
  final String glyph;

  /// Text shown beside the mark when expanded — 已译 392 段.
  final String summary;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    if (state == FloatingBallState.expanded) {
      final radius = BorderRadius.circular(tokens.radii.pill);
      return Pressable(
        onPressed: onPressed,
        borderRadius: radius,
        builder: (context, pressState) => Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
          decoration: BoxDecoration(
            color: colors.inverse,
            borderRadius: radius,
            boxShadow: tokens.shadows.lift,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  glyph,
                  style: tokens.typography.displayStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: colors.onAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                summary,
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.inverseFg,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final translating = state == FloatingBallState.translating;
    return Pressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(999),
      semanticsLabel: semanticsLabel,
      builder: (context, pressState) => Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.accent,
          shape: BoxShape.circle,
          boxShadow: tokens.shadows.ball,
        ),
        child: translating
            ? const Spinner(size: SpinnerSize.lg, onAccent: true)
            : Text(
                glyph,
                style: tokens.typography.displayStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.onAccent,
                ),
              ),
      ),
    );
  }
}
