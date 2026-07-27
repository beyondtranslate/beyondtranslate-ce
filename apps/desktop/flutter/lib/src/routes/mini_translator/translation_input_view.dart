import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide TextField;

import '../../i18n/i18n.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/text_field.dart' as app;
import '../../widgets/ui/themes/design_theme.dart';

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
    final design = context.design;

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 6, left: 12, right: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: design.border),
        ),
      ),
      child: Row(
        children: [
          // Pin button
          SizedBox(
            width: 24,
            height: 24,
            child: Button(
              borderRadius: BorderRadius.zero,
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onTogglePin,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  isAlwaysOnTop ? 0 : -0.78,
                ),
                child: Icon(
                  isAlwaysOnTop
                      ? FluentIcons.pin_20_filled
                      : FluentIcons.pin_20_regular,
                  size: 18,
                  color: isAlwaysOnTop
                      ? design.accent
                      : design.mutedText,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Text extract buttons
          Tooltip(
            message: t.mini_translator.toolbar.tooltip
                .extract_text_from_screen_capture,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Button(
                borderRadius: BorderRadius.zero,
                minSize: 0,
                padding: EdgeInsets.zero,
                onPressed: onExtractScreenCapture,
                child: Icon(
                  FluentIcons.crop_20_regular,
                  size: 18,
                  color: design.mutedText,
                ),
              ),
            ),
          ),
          Tooltip(
            message: t.mini_translator.toolbar.tooltip
                .extract_text_from_clipboard,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Button(
                borderRadius: BorderRadius.zero,
                minSize: 0,
                padding: EdgeInsets.zero,
                onPressed: onExtractClipboard,
                child: Icon(
                  FluentIcons.clipboard_text_ltr_20_regular,
                  size: 18,
                  color: design.mutedText,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Open in workbench
          SizedBox(
            width: 24,
            height: 24,
            child: Button(
              borderRadius: BorderRadius.zero,
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onOpenWorkbench,
              child: Icon(
                FluentIcons.open_20_regular,
                size: 18,
                color: design.mutedText,
              ),
            ),
          ),
          // Settings
          SizedBox(
            width: 24,
            height: 24,
            child: Button(
              borderRadius: BorderRadius.zero,
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: onOpenSettings,
              child: Icon(
                FluentIcons.settings_20_regular,
                size: 18,
                color: design.mutedText,
              ),
            ),
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
    final theme = Theme.of(context);
    final design = context.design;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: design.border),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              app.TextField(
                focusNode: focusNode,
                controller: controller,
                padding: const EdgeInsets.only(right: 20),
                placeholder: t.mini_translator.input.hint,
                placeholderStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: design.quietText,
                  fontSize: 13.5,
                  height: 1.6,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.5,
                  height: 1.6,
                  color: design.text,
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
                Positioned(
                  right: 0,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Button(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.zero,
                      onPressed: onClear,
                      child: Icon(
                        FluentIcons.dismiss_20_regular,
                        size: 16,
                        color: design.mutedText,
                      ),
                    ),
                  ),
                ),
            ],
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
    final design = context.design;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: hasContent
            ? Border(top: BorderSide(color: design.border))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 22,
            child: Button.outlined(
              borderRadius: BorderRadius.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0x381d1f20),
              onPressed: onRead,
              child: const Text(
                '朗读',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Barlow',
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 22,
            child: Button.outlined(
              borderRadius: BorderRadius.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0x381d1f20),
              onPressed: onCopy,
              child: const Text(
                '复制',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Barlow',
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 22,
            child: Button.outlined(
              borderRadius: BorderRadius.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0x381d1f20),
              onPressed: onBookmark,
              child: const Text(
                '收藏',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Barlow',
                  height: 1,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 22,
            child: Button.filled(
              borderRadius: BorderRadius.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: onTranslate,
              child: Text(
                t.mini_translator.button.translate,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Barlow',
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
