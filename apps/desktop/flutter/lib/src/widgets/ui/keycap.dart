import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'themes/design_theme.dart';

class Keycap extends StatelessWidget {
  const Keycap(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.design.text;
    final parts = label.split(' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.design.text.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < parts.length; index++) ...[
            if (index > 0) const SizedBox(width: 4),
            _KeycapPart(label: parts[index], color: color),
          ],
        ],
      ),
    );
  }
}

class _KeycapPart extends StatelessWidget {
  const _KeycapPart({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (label == '⌥' || label == '⌃') {
      return CustomPaint(
        size: const Size(13, 12),
        painter: _ModifierKeyPainter(label: label, color: color),
      );
    }
    final icon = switch (label) {
      '⌘' => FluentIcons.key_command_16_regular,
      '⇧' => FluentIcons.keyboard_shift_16_regular,
      _ => null,
    };
    if (icon != null) {
      return Icon(icon, size: 13, color: color);
    }
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontFamily: 'Roboto Mono',
        fontFamilyFallback: const ['MiSans'],
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1,
      ),
    );
  }
}

class _ModifierKeyPainter extends CustomPainter {
  const _ModifierKeyPainter({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;
    final path = Path();
    if (label == '⌥') {
      path
        ..moveTo(0.75, 2.25)
        ..lineTo(3.5, 2.25)
        ..lineTo(9.5, 9.75)
        ..lineTo(12.25, 9.75)
        ..moveTo(0.75, 9.75)
        ..lineTo(3.75, 9.75)
        ..moveTo(9.25, 2.25)
        ..lineTo(12.25, 2.25);
    } else {
      path
        ..moveTo(1.5, 8.5)
        ..lineTo(6.5, 3.25)
        ..lineTo(11.5, 8.5);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ModifierKeyPainter oldDelegate) {
    return oldDelegate.label != label || oldDelegate.color != color;
  }
}
