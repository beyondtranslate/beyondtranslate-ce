import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/theme/tokens.dart';
import 'package:beyondtranslate_ui/src/widgets/label.dart';
import 'package:flutter/widgets.dart';

enum MarkTone {
  /// The term is under control — a glossary hit that was honoured.
  accent,

  /// The term needs attention — a glossary conflict.
  warn,
}

/// Inline highlight around a run of text inside a paragraph.
///
/// Inline marks are text spans, so this is exposed both as a widget (for a
/// standalone term) and as [markSpan], for use inside a [Text.rich] run.
class Mark extends StatelessWidget {
  const Mark({
    super.key,
    this.tone = MarkTone.accent,
    required this.text,
  });

  final MarkTone tone;
  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final (Color background, Color foreground) = switch (tone) {
      MarkTone.accent => (colors.accentMark, colors.accentMarkFg),
      MarkTone.warn => (colors.warnMark, colors.warnFg),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: DefaultTextStyle.of(context).style.copyWith(color: foreground),
      ),
    );
  }
}

/// The span form of [Mark], for placing a mark inside a running
/// paragraph: `Text.rich(TextSpan(children: [..., markSpan(tokens, '标记')]))`.
InlineSpan markSpan(
  DesignTokens tokens,
  String text, {
  MarkTone tone = MarkTone.accent,
}) =>
    WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: Mark(tone: tone, text: text),
    );

/// A paragraph with its column heading; receded relative to the block below.
class TextBlock extends StatelessWidget {
  const TextBlock({
    super.key,
    this.label,
    this.meta,
    required this.child,
  });

  final Widget? label;

  /// Right-aligned hint — ⌥⏎ 重译 · ⌥→ 下一段.
  final Widget? meta;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null || meta != null) ...[
            Row(
              children: [
                Expanded(
                  child: label == null
                      ? const SizedBox.shrink()
                      : Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Label(child: label!),
                        ),
                ),
                if (meta != null)
                  DefaultTextStyle(
                    style: tokens.typography.displayStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      color: colors.fgFaint,
                    ),
                    child: meta!,
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          DefaultTextStyle(
            style: tokens.typography.sourceStyle(color: colors.fgMuted),
            child: child,
          ),
        ],
      ),
    );
  }
}

enum HighlightRule { top, bottom, none }

/// The one block on screen that carries the accent surface, a marker dot
/// and the largest, airiest type — the answer the view is pointing at.
class HighlightBlock extends StatelessWidget {
  const HighlightBlock({
    super.key,
    required this.label,
    this.meta,
    this.actions,
    this.rule = HighlightRule.bottom,
    required this.child,
  });

  /// The micro-heading above the block — 内置模型 · 首选译文.
  final Widget label;

  /// Right-aligned quality note — 2 处术语已对齐.
  final Widget? meta;

  /// Action row rendered under the translation.
  final Widget? actions;

  /// Where the accent rule sits. Its thickness is a theme token: 1px in the
  /// Studio themes, 2px in the Bright themes.
  final HighlightRule rule;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final side = BorderSide(
      color: colors.accentBorder,
      width: tokens.highlightRule,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: colors.accentSurface,
        border: Border(
          top: rule == HighlightRule.top ? side : BorderSide.none,
          bottom: rule == HighlightRule.bottom ? side : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.highlight,
                  shape: BoxShape.circle,
                  boxShadow: tokens.highlightGlow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Label(
                    tone: LabelTone.accent,
                    child: label,
                  ),
                ),
              ),
              if (meta != null)
                DefaultTextStyle(
                  style: tokens.typography.displayStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    color: colors.fgSubtle,
                  ),
                  child: meta!,
                ),
            ],
          ),
          const SizedBox(height: 12),
          DefaultTextStyle(
            style: tokens.typography.translationStyle(color: colors.fg),
            child: child,
          ),
          if (actions != null) ...[const SizedBox(height: 12), actions!],
        ],
      ),
    );
  }
}

/// A titled card: leading mark, title, trailing hint, body and a footer.
class TitledCard extends StatelessWidget {
  const TitledCard({
    super.key,
    required this.title,
    this.avatar,
    this.shortcut,
    this.footer,
    required this.child,
  });

  final Widget title;
  final Widget? avatar;
  final Widget? shortcut;

  /// Bottom row: 设为首选, or a glossary-conflict warning.
  final Widget? footer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(
          color: colors.border,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (avatar != null) ...[avatar!, const SizedBox(width: 7)],
              Expanded(
                child: DefaultTextStyle(
                  style: tokens.typography.displayStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: colors.fg,
                  ),
                  child: title,
                ),
              ),
              if (shortcut != null) ...[const SizedBox(width: 7), shortcut!],
            ],
          ),
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: tokens.typography.cjkStyle(
              fontSize: 13,
              height: 1.8,
              color: colors.fgSecondary,
            ),
            child: child,
          ),
          if (footer != null) ...[const SizedBox(height: 8), footer!],
        ],
      ),
    );
  }
}
