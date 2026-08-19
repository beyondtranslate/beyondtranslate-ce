import 'package:flutter/material.dart' hide TextField;

import '../theme/product_tokens.dart'
    show ProductTokensContext, ProductTypographyStyles;
import 'text_field.dart' show TextField;
import 'translation_text.dart';
import 'ui.dart' show DesignThemeContext, Label, LabelTone;

class TranslationPane extends StatelessWidget {
  const TranslationPane({
    super.key,
    required this.label,
    required this.language,
    required this.text,
    this.trailing,
    this.highlighted = false,
    this.editable = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.submitOnEnter = false,
    this.submitOnMetaEnter = false,
    this.hintText,
    this.footer,
  });

  final String label;
  final String language;
  final String text;
  final Widget? trailing;
  final bool highlighted;
  final bool editable;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool submitOnEnter;
  final bool submitOnMetaEnter;
  final String? hintText;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    return ColoredBox(
      // The preferred pane carries the accent surface, the way a
      // HighlightBlock marks the answer a view is pointing at.
      color: highlighted ? colors.accentSurface : colors.window,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: highlighted ? colors.accentHairline : colors.hairline,
                  width: context.hairlineWidth,
                ),
              ),
            ),
            child: Row(
              children: [
                if (highlighted) ...[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.highlight,
                      shape: BoxShape.circle,
                      boxShadow: context.product.highlightGlow,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Label(
                  tone: highlighted ? LabelTone.accent : LabelTone.subtle,
                  child: Text('$label · $language'),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: editable
                  ? TextField(
                      controller: controller,
                      focusNode: focusNode,
                      minLines: null,
                      maxLines: null,
                      expands: true,
                      submitOnEnter: submitOnEnter,
                      submitOnMetaEnter: submitOnMetaEnter,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      placeholder: hintText,
                      placeholderStyle: tokens.typography.sourceStyle(
                        color: colors.fgFaint,
                      ),
                      style: tokens.typography.sourceStyle(color: colors.fg),
                      padding: EdgeInsets.zero,
                    )
                  : SingleChildScrollView(
                      child: TranslationText(
                        text,
                        style: highlighted
                            ? tokens.typography.translationStyle(
                                color: colors.fg,
                              )
                            : tokens.typography.sourceStyle(color: colors.fg),
                      ),
                    ),
            ),
          ),
          if (footer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        highlighted ? colors.accentHairline : colors.hairline,
                    width: context.hairlineWidth,
                  ),
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 132),
                child: SingleChildScrollView(child: footer),
              ),
            ),
        ],
      ),
    );
  }
}
