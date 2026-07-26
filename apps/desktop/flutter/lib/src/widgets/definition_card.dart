import 'package:flutter/material.dart';

import 'ui/panel.dart';
import 'ui/themes/design_theme.dart';

class DefinitionCard extends StatelessWidget {
  const DefinitionCard({
    super.key,
    required this.term,
    required this.pronunciation,
    required this.definition,
    this.tag = '名词 · 术语',
    this.outlined = true,
  });

  final String term;
  final String pronunciation;
  final String definition;
  final String tag;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          term,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 3),
        Text(
          '$pronunciation · $tag',
          style: TextStyle(
            fontFamily: 'Roboto Mono',
            fontSize: 10.5,
            color: context.design.quietText,
          ),
        ),
        const SizedBox(height: UiSpace.xs),
        Text(
          definition,
          style: const TextStyle(fontSize: 13, height: 1.55),
        ),
      ],
    );
    if (!outlined) return content;
    return Panel(
      padding: const EdgeInsets.all(UiSpace.sm),
      child: content,
    );
  }
}
