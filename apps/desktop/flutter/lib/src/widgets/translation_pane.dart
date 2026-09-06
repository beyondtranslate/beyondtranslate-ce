import 'package:flutter/material.dart';

import '../theme/product_tokens.dart'
    show ProductPalette, ProductTokensContext, ProductTypography;
import 'plain_text_field.dart' show PlainTextField;
import 'translation_text.dart';
import 'ui.dart' show SectionLabel, ThemeDataBuildContextProps;

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
    final vars = context.vars;
    return ColoredBox(
      // The preferred pane carries the accent surface, the way a
      // HighlightBlock marks the answer a view is pointing at.
      color: highlighted ? vars.accentSurface : vars.colorSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: highlighted ? vars.accentHairline : vars.colorBorder,
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
                      color: vars.highlight,
                      shape: BoxShape.circle,
                      boxShadow: context.product.highlightGlow,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                SectionLabel('$label · $language'),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: editable
                  ? PlainTextField(
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
                      placeholderStyle: vars.sourceStyle(
                        color: vars.colorContentFaint,
                      ),
                      style: vars.sourceStyle(color: vars.colorContent),
                      padding: EdgeInsets.zero,
                    )
                  : SingleChildScrollView(
                      child: TranslationText(
                        text,
                        style: highlighted
                            ? vars.translationStyle(
                                color: vars.colorContent,
                              )
                            : vars.sourceStyle(color: vars.colorContent),
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
                    color: highlighted ? vars.accentHairline : vars.colorBorder,
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
