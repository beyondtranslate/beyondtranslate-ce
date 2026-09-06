import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import '../../utils/shortcut_util.dart';
import '../../widgets/block_heading.dart';
import '../../widgets/plain_text_field.dart' show PlainTextField;
import '../../widgets/ui.dart'
    show
        ActionBar,
        Button,
        ButtonVariant,
        Pressable,
        ThemeDataBuildContextProps;

class MiniTranslatorInput extends StatelessWidget {
  const MiniTranslatorInput({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.inputSubmitMode,
    this.targetLanguageName,
    required this.sourceHeadingParts,
    required this.onChanged,
    required this.onSubmitted,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final InputSubmitMode inputSubmitMode;

  /// Repeats the chosen target in the placeholder — 输入单词或文本，翻译为X.
  final String? targetLanguageName;

  /// On 自动检测 the heading names the detected language, as over the main
  /// window's source block. A source chosen in the capsule is not repeated,
  /// and before anything is typed there is nothing to detect: both say 原文.
  final BlockHeadingParts sourceHeadingParts;
  final ValueChanged<String?> onChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final placeholder = targetLanguageName == null
        ? t.mini_translator.input.hint
        : t.mini_translator.input.hint_translate_to(
            language: targetLanguageName!,
          );

    // Inside the panel card; the result block below draws the separation.
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 11, 15, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style:
                context.vars.labelStyle(color: context.vars.colorContentFaint),
            child: BlockHeading(sourceHeadingParts),
          ),
          const SizedBox(height: 6),
          PlainTextField(
            focusNode: focusNode,
            controller: controller,
            padding: EdgeInsets.zero,
            placeholder: placeholder,
            // 原文 sits at the pane's 13px/1.7 `type-source`, as in the main
            // window. The typed source reads as content, so it takes
            // `fg-secondary`, a clear step above the 11px 原文 · English
            // caption (`fg-faint`) over it — `fg-muted` sat too close to the
            // label's grey to tell apart.
            placeholderStyle: vars.sourceStyle(
              color: vars.colorContentFaint,
            ),
            style: vars.sourceStyle(color: vars.colorContentSecondary),
            // 原文框的最小 / 最大行数 —— 短词一行，长文本长到六行后框内滚动。
            maxLines: 6,
            minLines: 1,
            // 提交方式 decides which key sends the box; the field takes
            // Enter into its own hands only because it was told which one.
            submitOnEnter: inputSubmitMode == InputSubmitMode.enter,
            submitOnMetaEnter: inputSubmitMode == InputSubmitMode.commandEnter,
            onChanged: onChanged,
            onSubmitted: (_) => onSubmitted(),
          ),
        ],
      ),
    );
  }
}

class MiniTranslatorActionButtons extends StatelessWidget {
  const MiniTranslatorActionButtons({
    super.key,
    required this.inputSubmitMode,
    required this.hasContent,
    this.copyVisible = true,
    required this.copied,
    required this.starred,
    required this.translateEnabled,
    this.clearVisible = true,
    required this.retry,
    required this.onCopy,
    required this.onBookmark,
    required this.onTranslate,
    required this.onClear,
  });

  /// Only so the 翻译 chip names the key that submits — the button is a way
  /// to the same place the key goes.
  final InputSubmitMode inputSubmitMode;

  final bool hasContent;

  /// Several targets: 复制 rides on each section's attribution row, so it
  /// acts on that language's text, and the footer keeps only the
  /// paragraph-level 收藏 and 翻译. One target: the footer serves as before.
  final bool copyVisible;

  /// 复制 flips to 已复制 for a beat after copying.
  final bool copied;

  /// 收藏 / 已收藏 toggle state.
  final bool starred;

  /// 翻译 stays disabled until there is something to translate.
  final bool translateEnabled;

  /// 清空 hangs beside 翻译 only while there is something to clear — a
  /// just-opened pane, with neither 原文 nor 译文, folds it away and leaves
  /// 翻译 alone on the right.
  final bool clearVisible;

  /// Every service came back empty, so the same button now asks again.
  final bool retry;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;
  final VoidCallback onTranslate;
  final VoidCallback onClear;

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
              if (copyVisible)
                Button(
                    variant: ButtonVariant.recessed,
                    onPressed: hasContent ? onCopy : null,
                    child: Text(copied ? buttons.copied : buttons.copy)),
              Button(
                  variant: ButtonVariant.recessed,
                  onPressed: hasContent ? onBookmark : null,
                  child: Text(starred ? buttons.bookmarked : buttons.bookmark)),
            ],
          ),
          const Spacer(),
          // 清空 + 翻译 hang off the bar's right margin; both act on the query
          // as a whole (unlike the per-result chips), so they sit together.
          if (clearVisible) ...[
            Button(
                variant: ButtonVariant.recessed,
                onPressed: onClear,
                child: Text(buttons.clear)),
            const SizedBox(width: 6),
          ],
          Button(
              variant: ButtonVariant.filled,
              onPressed: translateEnabled ? onTranslate : null,
              shortcut: Text(inputSubmitShortcutGlyphs(inputSubmitMode)),
              child: Text(
                retry ? t.mini_translator.result.retry : buttons.translate,
              )),
        ],
      ),
    );
  }
}

/// 原文已修改 gets a line of its own at the seam between the two blocks: it is
/// about the relation between them — the translation below no longer answers
/// the text above — so it belongs to neither. One full-width strip, the whole
/// of it the retry.
class MiniTranslatorStaleNotice extends StatelessWidget {
  const MiniTranslatorStaleNotice({
    super.key,
    required this.inputSubmitMode,
    required this.onRequery,
  });

  /// Only so the strip names the key that actually re-runs the query.
  final InputSubmitMode inputSubmitMode;
  final VoidCallback onRequery;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final result = t.mini_translator.result;

    return Pressable(
      onPressed: onRequery,
      semanticsLabel: result.stale_notice,
      builder: (context, states) => AnimatedContainer(
        duration: context.vars.motionDuration,
        width: double.infinity,
        // A touch taller than a caption row so it reads as a notice rather
        // than a seam. No rule above — the tinted surface against the white
        // source block is the edge; a hairline on top would double the line.
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        color: states.contains(WidgetState.hovered)
            ? Color.alphaBlend(
                vars.colorContent.withValues(alpha: 0.03),
                vars.warnSurface,
              )
            : vars.warnSurface,
        child: Row(
          children: [
            Flexible(
              child: Text(
                result.stale_notice,
                overflow: TextOverflow.ellipsis,
                style: vars.sansStyle(
                  fontSize: 11,
                  height: 1,
                  color: vars.warnFg,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              result.stale_retry(
                key: inputSubmitShortcutGlyphs(inputSubmitMode),
              ),
              style: vars.sansStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1,
                color: vars.warnStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
