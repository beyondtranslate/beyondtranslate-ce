import 'package:flutter/widgets.dart';

/// The keyboard focus ring, drawn the way macOS draws it: a soft, wide accent
/// halo hugging the control with no gap — not the crisp offset outline the web
/// defaults to.
///
/// This is the Flutter equivalent of the stylesheet's
/// `:focus-visible { outline: var(--focus-width) solid var(--focus-ring);
/// outline-offset: var(--focus-offset) }`. It is a real stroke rather than a
/// spread `BoxShadow`: a shadow's corners take the box's own radius, so a ring
/// painted that way pinches at every corner instead of running parallel to the
/// edge it hugs.
class FocusRing extends StatelessWidget {
  const FocusRing({
    super.key,
    required this.visible,
    required this.color,
    this.borderRadius = BorderRadius.zero,
    this.width = 3,
    this.offset = 0,
    required this.child,
  });

  final bool visible;
  final Color color;
  final BorderRadius borderRadius;

  /// The ring's weight — `--focus-width`.
  final double width;

  /// The gap between the control's edge and the ring — `--focus-offset`.
  final double offset;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;
    return CustomPaint(
      foregroundPainter: _FocusRingPainter(
        color: color,
        borderRadius: borderRadius,
        strokeWidth: width,
        offset: offset,
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
    required this.offset,
  });

  final Color color;
  final BorderRadius borderRadius;
  final double strokeWidth;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    // The stroke is centred on the path, so inflating by half the width puts
    // the whole ring outside the box — the offset then pushes it further out.
    final RRect rect = borderRadius
        .toRRect(Offset.zero & size)
        .inflate(offset + strokeWidth / 2);
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
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.offset != offset;
}
