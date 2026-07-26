import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

class GlossaryHit extends StatelessWidget {
  const GlossaryHit({
    super.key,
    required this.source,
    required this.target,
    this.collection,
  });

  final String source;
  final String target;
  final String? collection;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    return Container(
      padding: const EdgeInsets.all(UiSpace.sm),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.08),
        border: Border(left: BorderSide(color: colors.accent, width: 2)),
      ),
      child: Wrap(
        spacing: UiSpace.xs,
        runSpacing: 2,
        children: [
          Text(
            '命中术语表',
            style: context.eyebrowTextStyle.copyWith(fontSize: 9),
          ),
          Text('$source → $target', style: const TextStyle(fontSize: 12.5)),
          if (collection != null)
            Text(
              collection!,
              style: TextStyle(fontSize: 12, color: colors.quietText),
            ),
        ],
      ),
    );
  }
}
