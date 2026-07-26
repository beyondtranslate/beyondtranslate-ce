import 'package:flutter/material.dart';

import '../../widgets/ui/themes/design_theme.dart';

class WorkbenchPlaceholderPage extends StatelessWidget {
  const WorkbenchPlaceholderPage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: colors.accent),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 13, color: colors.mutedText),
          ),
        ],
      ),
    );
  }
}
