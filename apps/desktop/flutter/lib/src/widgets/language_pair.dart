import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

class LanguagePair extends StatelessWidget {
  const LanguagePair({
    super.key,
    required this.source,
    required this.target,
    this.onSwap,
    this.note = '自动检测',
  });

  final String source;
  final String target;
  final VoidCallback? onSwap;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          color: context.design.accent.withValues(alpha: 0.16),
          child: Text(
            note,
            style: context.eyebrowTextStyle.copyWith(fontSize: 10),
          ),
        ),
        const SizedBox(width: UiSpace.sm),
        Text(
          source,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        Semantics(
          button: true,
          label: '交换语言',
          child: InkWell(
            onTap: onSwap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: UiSpace.sm),
              child: Text(
                '→',
                style: TextStyle(fontSize: 12, color: context.design.quietText),
              ),
            ),
          ),
        ),
        Text(
          target,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
