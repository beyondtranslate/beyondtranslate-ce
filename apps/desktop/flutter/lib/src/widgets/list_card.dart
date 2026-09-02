import 'package:flutter/widgets.dart';

import '../i18n/i18n.dart';
import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        HoverRegion,
        Pressable,
        kTransitionDuration;

/// The collapsed row's budget. A record can be a whole abstract, and a list
/// whose rows are a screen tall has stopped being a list — so at rest the row
/// shows two lines of 原文 and three of 译文, and opens to the full record on
/// click.
const _kPrimaryLines = 2;
const _kSecondaryLines = 3;

/// A selectable row under a labelled header — one entry of a feed or a history
/// list.
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.eyebrow,
    this.meta,
    this.flag,
    required this.primary,
    required this.secondary,
    this.active = false,
    this.expanded = false,
    this.expandable = true,
    this.onPressed,
    this.actions = const [],
  });

  /// The micro-label above the row — 内置模型 / Claude / DeepL.
  final Widget eyebrow;

  /// Context after the eyebrow — 今天 14:22 · arxiv.org.
  final Widget? meta;

  /// Right-aligned accent flag — 我改过.
  final Widget? flag;

  /// The receded first line. Skipped when empty.
  final String primary;

  /// The prominent second line.
  final String secondary;
  final bool active;

  /// Show the record whole. Collapsed is the resting state; the row says
  /// 展开全文 only when something is actually cut off, and the whole row is
  /// the target — no second control competes with 收藏 and ⋯ in the corner.
  final bool expanded;

  /// Whether a press opens the record at all. 多选时整行是个勾选框，展开无从
  /// 谈起 —— 提示语也就不该出现，尽管钳制照旧。
  final bool expandable;

  final VoidCallback? onPressed;

  /// Row actions — 收藏 as a word and a ⋯ menu for the rest. They surface on
  /// hover, in the flag's corner: the flag says what the row is, the actions
  /// are what you can do to it, and only one is needed at a time. They sit over
  /// the row rather than inside it, because the row is itself a button.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return _buildRow(context, showActions: false);
    return HoverRegion(
      builder: (context, hovered) => Stack(
        children: [
          _buildRow(context, showActions: hovered),
          // Pinned to the header line, 24px controls centred on the 11px label.
          PositionedDirectional(
            top: 9,
            end: 16,
            child: AnimatedOpacity(
              duration: kTransitionDuration,
              opacity: hovered ? 1 : 0,
              child: IgnorePointer(
                ignoring: !hovered,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Whether [_kPrimaryLines]/[_kSecondaryLines] of the texts would leave
  /// anything behind at [maxWidth] — measured, not guessed, so the label only
  /// appears when the clamp actually cuts something off. Measured against the
  /// line budget rather than the current display, so the answer still holds
  /// while the row is open and the clamp is off.
  bool _clamps(
    BuildContext context,
    TextStyle primaryStyle,
    TextStyle secondaryStyle,
    double maxWidth,
  ) {
    bool overflows(String text, TextStyle style, int maxLines) {
      if (text.isEmpty) return false;
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: maxLines,
      )..layout(maxWidth: maxWidth);
      final exceeded = painter.didExceedMaxLines;
      painter.dispose();
      return exceeded;
    }

    return overflows(primary, primaryStyle, _kPrimaryLines) ||
        overflows(secondary, secondaryStyle, _kSecondaryLines);
  }

  Widget _buildRow(BuildContext context, {required bool showActions}) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final primaryStyle = tokens.typography.sansStyle(
      fontSize: 12,
      height: 1.7,
      color: colors.fgMuted,
    );
    final secondaryStyle = tokens.typography.cjkStyle(
      fontSize: 15,
      height: 1.85,
      color: colors.fg,
    );

    return Pressable(
      onPressed: onPressed,
      selected: active,
      isButton: false,
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: active
              ? colors.accentSurface
              : (state.hovered ? colors.subtle : null),
          border: Border(
            bottom: BorderSide(
              color: colors.hairlineSoft,
              width: context.hairlineWidth,
            ),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // The pane is resizable, and the same record clamps at 420px and
            // fits at 700px — so the label follows the width, not the
            // character count.
            final clamped = _clamps(
              context,
              primaryStyle,
              secondaryStyle,
              constraints.maxWidth,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    DefaultTextStyle(
                      style: tokens.typography.labelStyle(
                        color: active ? colors.accentText : colors.fgSubtle,
                      ),
                      child: eyebrow,
                    ),
                    if (meta != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: DefaultTextStyle(
                          style: tokens.typography.sansStyle(
                            fontSize: 11,
                            color: active ? colors.fgSubtle : colors.fgFaint,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: meta!,
                        ),
                      ),
                    ] else
                      const Spacer(),
                    if (flag != null)
                      // The actions land where the flag sits; the flag steps
                      // aside rather than sharing the corner with two buttons.
                      AnimatedOpacity(
                        duration: kTransitionDuration,
                        opacity: showActions ? 0 : 1,
                        child: DefaultTextStyle(
                          style: tokens.typography.sansStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: colors.accentText,
                          ),
                          softWrap: false,
                          child: flag!,
                        ),
                      ),
                  ],
                ),
                if (primary.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    primary,
                    style: primaryStyle,
                    maxLines: expanded ? null : _kPrimaryLines,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 7),
                Text(
                  secondary,
                  style: secondaryStyle,
                  maxLines: expanded ? null : _kSecondaryLines,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                ),
                if (clamped && expandable) ...[
                  // A label, not a button: the row is already the target.
                  const SizedBox(height: 8),
                  Text(
                    expanded
                        ? t.workbench.history_page.collapse
                        : t.workbench.history_page.expand,
                    style: tokens.typography.labelStyle(
                      color: active ? colors.accentText : colors.fgFaint,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
