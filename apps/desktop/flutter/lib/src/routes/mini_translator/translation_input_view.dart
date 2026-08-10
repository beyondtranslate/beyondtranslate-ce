import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide TextField;

import '../../i18n/i18n.dart';
import '../../widgets/text_field.dart' show TextField;
import '../../widgets/ui.dart'
    show
        ActionBar,
        Button,
        ButtonSize,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles;

class MiniTranslatorInput extends StatelessWidget {
  const MiniTranslatorInput({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.text,
    required this.inputSubmitMode,
    this.targetLanguageName,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final String text;
  final InputSubmitMode inputSubmitMode;

  /// Repeats the chosen target in the placeholder — 输入单词或文本，翻译为X.
  final String? targetLanguageName;
  final ValueChanged<String?> onChanged;
  final VoidCallback onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final placeholder = targetLanguageName == null
        ? t.mini_translator.input.hint
        : t.mini_translator.input.hint_translate_to(
            language: targetLanguageName!,
          );

    // Inside the panel card; the result block below draws the separation.
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 12),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          TextField(
            focusNode: focusNode,
            controller: controller,
            padding: const EdgeInsets.only(right: 26),
            placeholder: placeholder,
            placeholderStyle: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1.7,
              color: colors.fgFaint,
            ),
            style: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1.7,
              color: colors.fgMuted,
            ),
            maxLines: 4,
            minLines: 1,
            textInputAction: inputSubmitMode == InputSubmitMode.enter
                ? TextInputAction.done
                : TextInputAction.newline,
            onChanged: onChanged,
            onSubmitted: (_) => onSubmitted(),
          ),
          if (text.isNotEmpty)
            Button(
              variant: ButtonVariant.quiet,
              size: ButtonSize.xs,
              onPressed: onClear,
              child: Icon(
                FluentIcons.dismiss_20_regular,
                size: 15,
                color: colors.fgFaint,
              ),
            ),
        ],
      ),
    );
  }
}

class MiniTranslatorActionButtons extends StatelessWidget {
  const MiniTranslatorActionButtons({
    Key? key,
    required this.hasContent,
    required this.copied,
    required this.starred,
    required this.translateEnabled,
    required this.onRead,
    required this.onCopy,
    required this.onBookmark,
    required this.onTranslate,
  }) : super(key: key);

  final bool hasContent;

  /// 复制 flips to 已复制 for a beat after copying.
  final bool copied;

  /// 收藏 / 已收藏 toggle state.
  final bool starred;

  /// 翻译 stays disabled until there is something to translate.
  final bool translateEnabled;
  final VoidCallback onRead;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;
  final VoidCallback onTranslate;

  @override
  Widget build(BuildContext context) {
    final buttons = t.mini_translator.button;

    // Sits on the window's tray surface, under the panel — no rule of its own.
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 4),
      child: Row(
        children: [
          ActionBar(
            children: [
              Button(
                variant: ButtonVariant.ghost,
                enabled: hasContent,
                onPressed: onRead,
                child: Text(buttons.read),
              ),
              Button(
                variant: ButtonVariant.ghost,
                enabled: hasContent,
                onPressed: onCopy,
                child: Text(copied ? buttons.copied : buttons.copy),
              ),
              Button(
                variant: ButtonVariant.ghost,
                enabled: hasContent,
                onPressed: onBookmark,
                child: Text(starred ? buttons.bookmarked : buttons.bookmark),
              ),
            ],
          ),
          const Spacer(),
          Button(
            variant: ButtonVariant.primary,
            enabled: translateEnabled,
            onPressed: onTranslate,
            shortcut: const Text('⏎'),
            child: Text(buttons.translate),
          ),
        ],
      ),
    );
  }
}
