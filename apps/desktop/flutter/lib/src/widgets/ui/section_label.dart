import 'package:flutter/material.dart';

import 'themes/design_theme.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.index,
    required this.label,
  });

  final String index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(index, style: context.eyebrowTextStyle),
        const SizedBox(width: UiSpace.xs),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: context.design.quietText,
            fontFamily: 'Roboto Mono',
            fontFamilyFallback: const ['MiSans'],
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
