import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide TextField;

import '../../i18n/i18n.dart';
import '../../widgets/icon_action_button.dart';
import '../../widgets/text_field.dart' show TextField;
import '../../widgets/ui.dart'
    show
        ActionBar,
        Button,
        ButtonSize,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles;

class MiniTranslatorToolbar extends StatelessWidget {
  const MiniTranslatorToolbar({
    Key? key,
    required this.isAlwaysOnTop,
    required this.onTogglePin,
    required this.onExtractScreenCapture,
    required this.onExtractClipboard,
    required this.onOpenWorkbench,
    required this.onOpenSettings,
  }) : super(key: key);

  final bool isAlwaysOnTop;
  final VoidCallback onTogglePin;
  final VoidCallback onExtractScreenCapture;
  final VoidCallback onExtractClipboard;
  final VoidCallback onOpenWorkbench;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          IconActionButton(
            icon: isAlwaysOnTop
                ? FluentIcons.pin_20_filled
                : FluentIcons.pin_20_regular,
            selected: isAlwaysOnTop,
            onPressed: onTogglePin,
          ),
          const Spacer(),
          IconActionButton(
            icon: FluentIcons.crop_20_regular,
            tooltip: t.mini_translator.toolbar.tooltip
                .extract_text_from_screen_capture,
            onPressed: onExtractScreenCapture,
          ),
          IconActionButton(
            icon: FluentIcons.clipboard_text_ltr_20_regular,
            tooltip:
                t.mini_translator.toolbar.tooltip.extract_text_from_clipboard,
            onPressed: onExtractClipboard,
          ),
          IconActionButton(
            icon: FluentIcons.open_20_regular,
            onPressed: onOpenWorkbench,
          ),
          IconActionButton(
            icon: FluentIcons.settings_20_regular,
            onPressed: onOpenSettings,
          ),
        ],
      ),
    );
  }
}

class MiniTranslatorInput extends StatelessWidget {
  const MiniTranslatorInput({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.text,
    required this.inputSubmitMode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final String text;
  final InputSubmitMode inputSubmitMode;
  final ValueChanged<String?> onChanged;
  final VoidCallback onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          TextField(
            focusNode: focusNode,
            controller: controller,
            padding: const EdgeInsets.only(right: 26),
            placeholder: t.mini_translator.input.hint,
            placeholderStyle:
                tokens.typography.sourceStyle(color: colors.fgFaint),
            style: tokens.typography.sourceStyle(color: colors.fg),
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
    required this.onRead,
    required this.onCopy,
    required this.onBookmark,
    required this.onTranslate,
  }) : super(key: key);

  final bool hasContent;
  final VoidCallback onRead;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;
  final VoidCallback onTranslate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: hasContent
            ? Border(
                top: BorderSide(
                  color: colors.border,
                  width: context.hairlineWidth,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          ActionBar(
            children: [
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.xs,
                onPressed: onRead,
                child: const Text('朗读'),
              ),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.xs,
                onPressed: onCopy,
                child: const Text('复制'),
              ),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.xs,
                onPressed: onBookmark,
                child: const Text('收藏'),
              ),
            ],
          ),
          const Spacer(),
          Button(
            variant: ButtonVariant.primary,
            size: ButtonSize.xs,
            onPressed: onTranslate,
            child: Text(t.mini_translator.button.translate),
          ),
        ],
      ),
    );
  }
}
