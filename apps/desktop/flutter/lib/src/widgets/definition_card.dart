import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductTypography;
import 'ui.dart' show Badge, BadgeTint, Card, ThemeDataBuildContextProps;

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
    final vars = context.vars;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                term,
                style: vars.displayStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: vars.colorContent,
                ),
              ),
            ),
            Badge(tint: BadgeTint.neutral, child: Text(tag)),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          pronunciation,
          style: vars.monoStyle(
            fontSize: 11,
            height: 1,
            color: vars.colorContentSubtle,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          definition,
          style: vars.sansStyle(
            fontSize: 12,
            height: 1.6,
            color: vars.colorContentSecondary,
          ),
        ),
      ],
    );
    if (!outlined) return content;
    return Card(child: content);
  }
}
