import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        HoverRegion,
        Pressable,
        kTransitionDuration;

/// A selectable two-line row under a labelled header — one entry of a feed or
/// a history list.
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.eyebrow,
    this.meta,
    this.flag,
    required this.primary,
    required this.secondary,
    this.active = false,
    this.onPressed,
    this.actions = const [],
  });

  /// The micro-label above the row — 内置模型 / Claude / DeepL.
  final Widget eyebrow;

  /// Context after the eyebrow — 今天 14:22 · arxiv.org.
  final Widget? meta;

  /// Right-aligned accent flag — 我改过.
  final Widget? flag;

  /// The receded first line.
  final Widget primary;

  /// The prominent second line.
  final Widget secondary;
  final bool active;
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

  Widget _buildRow(BuildContext context, {required bool showActions}) {
    final tokens = context.tokens;
    final colors = tokens.colors;

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
        child: Column(
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
                      child: meta!,
                    ),
                  ),
                ] else
                  const Spacer(),
                if (flag != null)
                  // The actions land where the flag sits; the flag steps aside
                  // rather than sharing the corner with two buttons.
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
                      child: flag!,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 7),
            DefaultTextStyle(
              style: tokens.typography.sansStyle(
                fontSize: 12,
                height: 1.7,
                color: colors.fgMuted,
              ),
              child: primary,
            ),
            const SizedBox(height: 7),
            DefaultTextStyle(
              style: tokens.typography.cjkStyle(
                fontSize: 15,
                height: 1.85,
                color: colors.fg,
              ),
              child: secondary,
            ),
          ],
        ),
      ),
    );
  }
}
