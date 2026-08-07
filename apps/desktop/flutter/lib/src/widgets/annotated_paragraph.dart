import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductTokens;
import 'ui.dart' show DesignThemeContext, DesignTypographyStyles;

enum ParagraphMode {
  /// Keeps the source above the annotation.
  insert,

  /// Hides the source and shows the annotation alone.
  replace,
}

/// A paragraph with a highlighted block inserted underneath it.
class AnnotatedParagraph extends StatelessWidget {
  const AnnotatedParagraph({
    super.key,
    required this.source,
    required this.annotation,
    this.mode = ParagraphMode.insert,
  });

  final Widget source;
  final Widget annotation;
  final ParagraphMode mode;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (mode == ParagraphMode.insert) ...[
          DefaultTextStyle(
            style: tokens.typography.sansStyle(
              fontSize: 13,
              height: 1.8,
              color: colors.fgSecondary,
            ),
            child: source,
          ),
          const SizedBox(height: 7),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: colors.accentSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: colors.highlight,
                // `max(2px, var(--highlight-rule))` in the deck; the token is
                // 2px in every theme, so it is the floor.
                width: ProductTokens.highlightRule,
              ),
            ),
          ),
          child: DefaultTextStyle(
            style: tokens.typography.cjkStyle(
              fontSize: 15,
              height: 1.85,
              color: colors.fg,
            ),
            child: annotation,
          ),
        ),
      ],
    );
  }
}
