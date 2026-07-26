import 'package:flutter/material.dart';

import 'ui/text_field.dart' as app_ui;
import 'ui/themes/design_theme.dart';

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
    final colors = context.design;
    return ColoredBox(
      color: highlighted ? colors.translatedSurface : colors.paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: UiSpace.md,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.text.withValues(alpha: 0.10),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '$label · $language',
                  style: context.eyebrowTextStyle.copyWith(
                    color: highlighted ? colors.accent : colors.quietText,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(UiSpace.md),
              child: editable
                  ? app_ui.TextField(
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
                      placeholderStyle: TextStyle(
                        fontSize: 14,
                        height: 1.85,
                        color: colors.quietText,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.85,
                        color: colors.text,
                      ),
                      padding: EdgeInsets.zero,
                    )
                  : SingleChildScrollView(
                      child: SelectableText(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.7,
                          color: colors.text,
                        ),
                      ),
                    ),
            ),
          ),
          if (footer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: UiSpace.md,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colors.text.withValues(alpha: 0.12),
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
