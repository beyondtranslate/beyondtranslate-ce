import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        Badge,
        BadgeTone,
        DesignThemeContext,
        DesignTypographyStyles,
        Surface,
        SurfacePadding;

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
    final tokens = context.tokens;
    final colors = tokens.colors;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                term,
                style: tokens.typography.displayStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.fg,
                ),
              ),
            ),
            Badge(tone: BadgeTone.neutral, child: Text(tag)),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          pronunciation,
          style: tokens.typography.monoStyle(
            fontSize: 11,
            height: 1,
            color: colors.fgSubtle,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          definition,
          style: tokens.typography.sansStyle(
            fontSize: 12,
            height: 1.6,
            color: colors.fgSecondary,
          ),
        ),
      ],
    );
    if (!outlined) return content;
    return Surface(padding: SurfacePadding.sm, child: content);
  }
}
