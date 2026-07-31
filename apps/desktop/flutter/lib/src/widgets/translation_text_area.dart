import 'package:flutter/widgets.dart';

import 'ui.dart' show TextArea;

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
    return TextArea(
      controller: controller,
      placeholder: hintText,
      enabled: !readOnly,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
}
