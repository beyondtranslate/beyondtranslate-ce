import 'dart:math' as math;

import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum ProgressTone { accent, success, warn, gradient }

enum ProgressThickness {
  /// 4px, for quality meters.
  thin,

  /// 6px, for document progress.
  thick,
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    this.tone = ProgressTone.accent,
    this.thickness = ProgressThickness.thin,
  });

  /// 0–100.
  final double value;
  final ProgressTone tone;
  final ProgressThickness thickness;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final clamped = value.clamp(0.0, 100.0);

    final height = thickness == ProgressThickness.thin ? 4.0 : 6.0;
    final radius = BorderRadius.circular(
      thickness == ProgressThickness.thin ? 2 : 3,
    );

    final fill = switch (tone) {
      ProgressTone.accent => colors.accent,
      ProgressTone.success => colors.success,
      ProgressTone.warn => colors.warn,
      ProgressTone.gradient => null,
    };

    return Semantics(
      value: '${clamped.round()}%',
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          height: height,
          width: double.infinity,
          color: colors.track,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: clamped / 100,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: fill,
                  gradient: tone == ProgressTone.gradient
                      ? tokens.progressGradient
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Label / value / bar triplet used by the 质量信号 panel.
class Meter extends StatelessWidget {
  const Meter({
    super.key,
    required this.label,
    required this.value,
    this.display,
    this.tone = ProgressTone.success,
  }) : assert(
          tone != ProgressTone.gradient,
          'A meter reads a single value, so it takes a solid tone.',
        );

  final Widget label;
  final double value;

  /// Defaults to `value%`.
  final Widget? display;
  final ProgressTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final valueColor = switch (tone) {
      ProgressTone.success => colors.success,
      ProgressTone.warn => colors.warnStrong,
      ProgressTone.accent => colors.accentText,
      ProgressTone.gradient => colors.accentText,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                style: tokens.typography.sansStyle(
                  fontSize: 12,
                  color: colors.fgTertiary,
                ),
                child: label,
              ),
            ),
            const SizedBox(width: 12),
            DefaultTextStyle(
              style: tokens.typography.displayStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
                color: valueColor,
              ),
              child: display ?? Text('${value.round()}%'),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ProgressBar(value: value, tone: tone),
      ],
    );
  }
}

enum SpinnerSize { sm, md, lg }

/// The ring spinner: a two-tone ring with the top quarter in the accent.
class Spinner extends StatefulWidget {
  const Spinner({super.key, this.size = SpinnerSize.md, this.onAccent = false});

  final SpinnerSize size;

  /// Use on accent fills, where the ring must be white.
  final bool onAccent;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (double diameter, double stroke) = switch (widget.size) {
      SpinnerSize.sm => (14, 2),
      SpinnerSize.md => (16, 2),
      SpinnerSize.lg => (18, 2.5),
    };

    final track = widget.onAccent
        ? const Color(0xFFFFFFFF).withValues(alpha: 0.35)
        : colors.accent.withValues(alpha: 0.25);
    final head = widget.onAccent ? const Color(0xFFFFFFFF) : colors.accent;

    return Semantics(
      label: '加载中',
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          size: Size.square(diameter),
          painter: _RingPainter(track: track, head: head, strokeWidth: stroke),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.track,
    required this.head,
    required this.strokeWidth,
  });

  final Color track;
  final Color head;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = track;
    canvas.drawOval(rect, paint);
    // `border-t-accent` colours the top edge only, which on a circle is the
    // quarter arc between the two corner miters.
    canvas.drawArc(
      rect,
      -3 * math.pi / 4,
      math.pi / 2,
      false,
      paint..color = head,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.track != track ||
      oldDelegate.head != head ||
      oldDelegate.strokeWidth != strokeWidth;
}
