import 'package:flutter/material.dart';

import 'themes/design_theme.dart';

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        color: selected ? colors.accent : colors.text,
        style: IconButton.styleFrom(
          minimumSize: const Size.square(32),
          backgroundColor:
              selected ? colors.accent.withValues(alpha: 0.14) : null,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
