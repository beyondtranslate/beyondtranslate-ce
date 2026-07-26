import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

class TranslationTextArea extends StatelessWidget {
  const TranslationTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.readOnly = false,
    this.minLines = 4,
    this.maxLines,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool readOnly;
  final int minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: colors.border),
    );
    return TextField(
      controller: controller,
      readOnly: readOnly,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(color: colors.text, fontSize: 14, height: 1.65),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: colors.quietText),
        filled: true,
        fillColor: colors.paper,
        contentPadding: const EdgeInsets.all(UiSpace.sm),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
      ),
    );
  }
}
