import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Pressable,
        Spinner,
        SpinnerSize,
        kTransitionDuration;

enum FloatingBallState {
  /// Outline mark — the page has not been translated yet.
  idle,

  /// 静息 · 贴边半隐: dimmed after 3s of inactivity.
  resting,

  /// 翻译中: the ring stroke is the progress bar.
  translating,

  /// 已翻译: solid fill; one click restores the source.
  translated,

  /// 悬停 · 展开动作条: the capsule with inline actions.
  expanded,
}

const List<String> _kDefaultActions = ['翻译', '仅译文', '还原', '隐藏'];

/// The in-page floating trigger. The design's rule: the ball is the switch
/// and the progress bar for whole-page translation, nothing more — it speaks
/// only through position, fill and ring stroke. Anything textual lives in the
/// expanded capsule, the popup or the bubble.
class FloatingBall extends StatelessWidget {
  const FloatingBall({
    super.key,
    this.state = FloatingBallState.idle,
    this.glyph = 'B',
    this.progress,
    this.actions,
    this.onPressed,
    this.semanticsLabel,
  });

  final FloatingBallState state;

  /// The mark inside the ball.
  final String glyph;

  /// 0–100 while translating; omitted, the ball shows a plain spinner.
  final double? progress;

  /// Buttons inside the expanded capsule — four short verbs in the design.
  /// Left null, the deck's defaults are drawn as inert labels.
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    if (state == FloatingBallState.expanded) {
      final radius = BorderRadius.circular(tokens.radii.pill);
      return Container(
        padding: const EdgeInsets.fromLTRB(3, 3, 8, 3),
        decoration: BoxDecoration(
          color: colors.window,
          borderRadius: radius,
          border: Border.all(
            color: colors.hairlineStrong,
            width: context.hairlineWidth,
          ),
          boxShadow: tokens.shadows.lift,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pressable(
              onPressed: onPressed,
              borderRadius: BorderRadius.circular(999),
              semanticsLabel: semanticsLabel ?? 'BeyondTranslate',
              builder: (context, pressState) => Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  glyph,
                  style: tokens.typography.displayStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: colors.onAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            ...actions ??
                [
                  for (final label in _kDefaultActions)
                    _CapsuleAction(label: label),
                ],
          ],
        ),
      );
    }

    if (state == FloatingBallState.translating) {
      final clamped = progress?.clamp(0, 100).toDouble();

      return Semantics(
        label: clamped == null ? '正在翻译' : '翻译进度 ${clamped.round()}%',
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: tokens.shadows.ball,
          ),
          child: clamped == null
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.window,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.hairlineStrong,
                      width: context.hairlineWidth,
                    ),
                  ),
                  child: const Spinner(size: SpinnerSize.lg),
                )
              : CustomPaint(
                  painter: _ProgressRingPainter(
                    progress: clamped / 100,
                    ring: colors.accent,
                    track: colors.accentSurface,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.window,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${clamped.round()}%',
                      style: tokens.typography.displayStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: colors.accentText,
                      ),
                    ),
                  ),
                ),
        ),
      );
    }

    final solid = state == FloatingBallState.translated;
    final resting = state == FloatingBallState.resting;

    return Pressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(999),
      semanticsLabel:
          semanticsLabel ?? (solid ? '已翻译 · 点击还原原文' : 'BeyondTranslate'),
      builder: (context, pressState) => AnimatedOpacity(
        duration: kTransitionDuration,
        opacity: resting && !pressState.hovered ? 0.4 : 1,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: solid ? colors.accent : colors.window,
            shape: BoxShape.circle,
            border: solid
                ? null
                : Border.all(
                    color: colors.hairlineStrong,
                    width: context.hairlineWidth,
                  ),
            boxShadow: solid ? tokens.shadows.ball : tokens.shadows.lift,
          ),
          child: Text(
            glyph,
            style: tokens.typography.displayStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1,
              color: solid ? colors.onAccent : colors.accentText,
            ),
          ),
        ),
      ),
    );
  }
}

/// One verb of the expanded capsule — 翻译 / 仅译文 / 还原 / 隐藏.
class _CapsuleAction extends StatelessWidget {
  const _CapsuleAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.chip);

    return Pressable(
      onPressed: () {},
      borderRadius: radius,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          label,
          style: tokens.typography.sansStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1,
            color: state.hovered ? colors.accentText : colors.fgNav,
          ),
        ),
      ),
    );
  }
}

/// The conic progress ring: accent sweep over an accent-surface track.
class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.ring,
    required this.track,
  });

  final double progress;
  final Color ring;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final trackPaint = Paint()..color = track;
    canvas.drawOval(rect, trackPaint);

    final sweep = progress * 2 * math.pi;
    final ringPaint = Paint()..color = ring;
    canvas.drawArc(rect, -math.pi / 2, sweep, true, ringPaint);
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.ring != ring ||
      oldDelegate.track != track;
}
