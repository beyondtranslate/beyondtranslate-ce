import 'package:flutter/widgets.dart';

/// macOS draws the keyboard focus ring hugging the control — a soft, wide
/// accent halo with no gap — rather than the crisp offset outline the web
/// defaults to. This is the Flutter equivalent of
/// `:focus-visible { outline: 3px solid var(--bt-focus-ring); outline-offset: 0 }`:
/// a 3px stroke sitting just outside the box, following its corner radius.
class FocusRing extends StatelessWidget {
  const FocusRing({
    super.key,
    required this.visible,
    required this.color,
    this.borderRadius = BorderRadius.zero,
    this.width = 3,
    required this.child,
  });

  final bool visible;
  final Color color;
  final BorderRadius borderRadius;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;
    return CustomPaint(
      foregroundPainter: _FocusRingPainter(
        color: color,
        borderRadius: borderRadius,
        strokeWidth: width,
      ),
      child: child,
    );
  }
}

class _FocusRingPainter extends CustomPainter {
  const _FocusRingPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final Color color;
  final BorderRadius borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // The stroke is centred on the path, so offsetting by half the width puts
    // the whole ring outside the box — CSS's `outline-offset: 0`.
    final rect = borderRadius
        .toRRect(Offset.zero & size)
        .inflate(strokeWidth / 2);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(_FocusRingPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.strokeWidth != strokeWidth;
}
