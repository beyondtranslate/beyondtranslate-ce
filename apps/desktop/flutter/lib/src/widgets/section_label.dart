import 'package:flutter/widgets.dart';

import 'ui.dart' show DesignThemeContext, DesignTypographyStyles, Label;

/// A numbered section heading — `01  质量信号`.
class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.index, required this.label});

  final String index;
  final String label;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    return Row(
      children: [
        Text(
          index,
          style: typography.numericStyle(
            fontSize: typography.caption,
            color: context.colors.accentText,
          ),
        ),
        const SizedBox(width: 8),
        Label(child: Text(label)),
      ],
    );
  }
}
