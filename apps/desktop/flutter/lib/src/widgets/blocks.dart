import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart'
    show ProductTokens, ProductTokensContext, ProductTypographyStyles;
import 'ui.dart'
    show
        DesignTheme,
        DesignThemeContext,
        DesignTokens,
        DesignTypographyStyles,
        FocusRing,
        Label,
        LabelTone;

enum MarkTone {
  /// The term is under control — a glossary hit that was honoured.
  accent,

  /// The term needs attention — a glossary conflict.
  warn,
}

/// A glossary entry a [Mark] points at — shown in the hover/focus popover.
@immutable
class MarkDetail {
  const MarkDetail({
    required this.term,
    required this.translation,
    this.forbidden,
    this.book,
    this.hits,
  });

  /// Source term — `token`.
  final String term;

  /// 指定译法 — the glossary-mandated translation.
  final String translation;

  /// 禁用 — translations the glossary forbids.
  final String? forbidden;

  /// 所属术语库 — 机器学习.
  final String? book;

  /// 命中次数.
  final int? hits;
}

/// Inline highlight around a run of text inside a paragraph.
///
/// Inline marks are text spans, so this is exposed both as a widget (for a
/// standalone term) and as [markSpan], for use inside a [Text.rich] run.
///
/// A [detail] payload turns the mark into a glossary entry: hovering or
/// focusing opens the detail popover, click/Enter activates the term — the
/// caller decides what that means (e.g. revealing a term card). Without it
/// the mark stays a plain inline highlight.
class Mark extends StatelessWidget {
  const Mark({
    super.key,
    this.tone = MarkTone.accent,
    required this.text,
    this.detail,
    this.onActivate,
  });

  final MarkTone tone;
  final String text;
  final MarkDetail? detail;

  /// What activation does — click / Enter / popover click.
  final VoidCallback? onActivate;

  @override
  Widget build(BuildContext context) {
    if (detail == null) return _MarkChip(tone: tone, text: text);
    return _InteractiveMark(
      tone: tone,
      text: text,
      detail: detail!,
      onActivate: onActivate,
    );
  }
}

/// The plain visual: tinted capsule around the term.
class _MarkChip extends StatelessWidget {
  const _MarkChip({required this.tone, required this.text});

  final MarkTone tone;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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

/// Glossary-aware mark: focusable (Tab), hover/focus opens the detail
/// popover, click/Enter activates. The popover renders in the app overlay so
/// clipping panels never cut it off.
class _InteractiveMark extends StatefulWidget {
  const _InteractiveMark({
    required this.tone,
    required this.text,
    required this.detail,
    this.onActivate,
  });

  final MarkTone tone;
  final String text;
  final MarkDetail detail;
  final VoidCallback? onActivate;

  @override
  State<_InteractiveMark> createState() => _InteractiveMarkState();
}

class _InteractiveMarkState extends State<_InteractiveMark> {
  final OverlayPortalController _controller = OverlayPortalController();
  final LayerLink _link = LayerLink();
  Timer? _closeTimer;
  bool _hovered = false;
  bool _focused = false;

  void _cancelClose() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  /// Mirrors the React 160ms grace so the pointer can travel into the popover.
  void _scheduleClose() {
    _cancelClose();
    _closeTimer = Timer(const Duration(milliseconds: 160), _hide);
  }

  void _show() {
    _cancelClose();
    if (!_controller.isShowing) _controller.show();
  }

  void _hide() {
    _cancelClose();
    if (_controller.isShowing) _controller.hide();
  }

  void _activate() {
    _hide();
    widget.onActivate?.call();
  }

  @override
  void dispose() {
    _cancelClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final (
      Color background,
      Color foreground,
      Color accentColor,
    ) = switch (widget.tone) {
      MarkTone.accent => (
          colors.accentMark,
          colors.accentMarkFg,
          colors.accent,
        ),
      MarkTone.warn => (colors.warnMark, colors.warnFg, colors.warn),
    };
    const radius = BorderRadius.all(Radius.circular(5));

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (overlayContext) => Align(
          alignment: Alignment.topLeft,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 6),
            child: MouseRegion(
              onEnter: (_) => _cancelClose(),
              onExit: (_) => _scheduleClose(),
              child: GestureDetector(
                onTap: widget.onActivate != null ? _activate : null,
                // Re-established because the overlay child is built under the
                // app's overlay, not under this provider's subtree.
                child: DesignTheme(
                  tokens: tokens,
                  child: _MarkPopover(
                    detail: widget.detail,
                    showsActivate: widget.onActivate != null,
                  ),
                ),
              ),
            ),
          ),
        ),
        child: Semantics(
          container: true,
          button: true,
          expanded: _controller.isShowing,
          child: FocusableActionDetector(
            mouseCursor: SystemMouseCursors.click,
            onShowHoverHighlight: (value) {
              setState(() => _hovered = value);
              value ? _show() : _scheduleClose();
            },
            onShowFocusHighlight: (value) {
              setState(() => _focused = value);
              value ? _show() : _hide();
            },
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _activate();
                  return null;
                },
              ),
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  _hide();
                  return null;
                },
              ),
            },
            child: GestureDetector(
              onTap: _activate,
              child: FocusRing(
                visible: _hovered || _focused,
                color: accentColor.withValues(alpha: _focused ? 0.5 : 0.4),
                borderRadius: radius,
                width: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: radius,
                  ),
                  child: Text(
                    widget.text,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(color: foreground),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The glossary card the mark reveals — term, mandated translation, source.
class _MarkPopover extends StatelessWidget {
  const _MarkPopover({required this.detail, required this.showsActivate});

  final MarkDetail detail;
  final bool showsActivate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      width: 224,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: colors.window,
        border: Border.all(
          color: colors.hairlineStrong,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.box),
        boxShadow: tokens.shadows.float,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  detail.term,
                  style: tokens.typography.displayStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: colors.fg,
                  ),
                ),
              ),
              if (detail.hits != null)
                Text(
                  '命中 ${detail.hits}',
                  style: tokens.typography.sansStyle(
                    fontSize: 10,
                    height: 1,
                    color: colors.fgFaint,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: '指定译法 ${detail.translation}',
              children: [
                if (detail.forbidden != null)
                  TextSpan(
                    text: ' · 禁用 ${detail.forbidden}',
                    style: TextStyle(color: colors.fgFaint),
                  ),
              ],
            ),
            style: tokens.typography.cjkStyle(
              fontSize: 12,
              height: 1.6,
              color: colors.fgSecondary,
            ),
          ),
          if (detail.book != null) ...[
            const SizedBox(height: 6),
            Text(
              detail.book!,
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 1,
                color: colors.fgTertiary,
              ),
            ),
          ],
          if (showsActivate) ...[
            const SizedBox(height: 8),
            Text(
              '点击查看词条 →',
              style: tokens.typography.sansStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1,
                color: colors.accentText,
              ),
            ),
          ],
        ],
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
  MarkDetail? detail,
  VoidCallback? onActivate,
}) =>
    WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child:
          Mark(tone: tone, text: text, detail: detail, onActivate: onActivate),
    );

/// A paragraph with its column heading; receded relative to the block below.
class TextBlock extends StatelessWidget {
  const TextBlock({super.key, this.label, this.meta, required this.child});

  final Widget? label;

  /// Right-aligned hint, riding on the label's line — 翻译中, 我改过.
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
            color: colors.hairline,
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

/// Which colour key a [HighlightBlock] is drawn in.
enum HighlightTone {
  /// The answer the view is pointing at.
  accent,

  /// The slot the answer never arrived in — 服务全部失效.
  danger,
}

/// The one block on screen that carries the accent surface, a marker dot
/// and the largest, airiest type — the answer the view is pointing at.
class HighlightBlock extends StatelessWidget {
  const HighlightBlock({
    super.key,
    required this.label,
    this.meta,
    this.actions,
    this.rule = HighlightRule.bottom,
    this.tone = HighlightTone.accent,
    this.stretch = false,
    required this.child,
  });

  /// The micro-heading above the block — 内置模型 · 首选译文.
  final Widget label;

  /// Right-aligned quality note — 2 处术语已对齐.
  final Widget? meta;

  /// Action row rendered under the translation.
  final Widget? actions;

  /// Where the accent rule sits. Its thickness is a layout token — 2px in
  /// every theme, so the rule reads as the marker it is rather than as another
  /// hairline.
  final HighlightRule rule;

  /// [HighlightTone.danger] when the slot has nothing to show because every
  /// service failed: the block keeps its place, size and rhythm — marker,
  /// label, body, action row — and only the colour key changes, so the failure
  /// reads as "the translation did not arrive" rather than as a different
  /// screen.
  final HighlightTone tone;

  /// Fill the height the parent grants and pin [actions] to the block's foot —
  /// the deck's `mt-auto` when the 翻译 pane runs the block to its bottom edge.
  final bool stretch;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final danger = tone == HighlightTone.danger;
    final side = BorderSide(
      color: danger ? colors.dangerHairline : colors.accentHairline,
      width: ProductTokens.highlightRule,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: danger ? colors.dangerSurface : colors.accentSurface,
        border: Border(
          top: rule == HighlightRule.top ? side : BorderSide.none,
          bottom: rule == HighlightRule.bottom ? side : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: danger ? colors.danger : colors.accentText,
                  shape: BoxShape.circle,
                  // No glow: the glow is the "this is the one" signal, and a
                  // failed slot is not the one.
                  boxShadow: danger ? null : context.product.highlightGlow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Label(
                    tone: danger ? LabelTone.danger : LabelTone.accent,
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
          if (actions != null) ...[
            const SizedBox(height: 12),
            if (stretch) const Spacer(),
            actions!,
          ],
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
          color: colors.hairline,
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
