import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Label,
        LabelTone,
        Pressable;

/// A compact title/subtitle card for a sidebar column.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.note,
  });

  final Widget title;
  final Widget subtitle;

  /// A parenthetical aside after the subtitle — （非「标记」）.
  final Widget? note;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: colors.raised,
        border: Border.all(
          color: colors.hairline,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.box),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: tokens.typography.displayStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
              color: colors.fg,
            ),
            child: title,
          ),
          const SizedBox(height: 4),
          DefaultTextStyle(
            style: tokens.typography.cjkStyle(
              fontSize: 12,
              height: 1.6,
              color: colors.fgTertiary,
            ),
            child: note == null
                ? subtitle
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: subtitle),
                      const SizedBox(width: 4),
                      DefaultTextStyle(
                        style: tokens.typography.cjkStyle(
                          fontSize: 12,
                          height: 1.6,
                          color: colors.fgFaint,
                        ),
                        child: note!,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// A footer panel on the inset surface: a title with a secondary note and a
/// right-aligned tag, over a paragraph of detail.
class DetailBlock extends StatelessWidget {
  const DetailBlock({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTitlePressed,
    required this.child,
  });

  final Widget title;

  /// Sits beside the title on the same baseline — a phonetic, a count.
  final Widget? subtitle;

  /// Right-aligned tag — 术语库.
  final Widget? trailing;

  /// Makes the title a link — opens the glossary at this entry.
  final VoidCallback? onTitlePressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
      decoration: BoxDecoration(
        color: colors.inset,
        border: Border(
          top: BorderSide(
            color: colors.hairlineSoft,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (onTitlePressed != null)
                Pressable(
                  onPressed: onTitlePressed,
                  builder: (context, state) => DefaultTextStyle(
                    style: tokens.typography
                        .displayStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          color: state.hovered ? colors.accentText : colors.fg,
                        )
                        .copyWith(
                          decoration: state.hovered
                              ? TextDecoration.underline
                              : null,
                          decorationColor: colors.accentText,
                        ),
                    child: title,
                  ),
                )
              else
                DefaultTextStyle(
                  style: tokens.typography.displayStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: colors.fg,
                  ),
                  child: title,
                ),
              if (subtitle != null) ...[
                const SizedBox(width: 10),
                DefaultTextStyle(
                  style: tokens.typography.sansStyle(
                    fontSize: 11,
                    color: colors.fgSubtle,
                  ),
                  child: subtitle!,
                ),
              ],
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 6),
          DefaultTextStyle(
            style: tokens.typography.cjkStyle(
              fontSize: 12,
              height: 1.75,
              color: colors.fgTertiary,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// A settings row pairing a label with a right-aligned value — an action and
/// its key binding, a setting and its current state.
class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.label, required this.trailing});

  final Widget label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Expanded(
          child: DefaultTextStyle(
            style: tokens.typography.sansStyle(
              fontSize: 12,
              color: tokens.colors.fgSecondary,
            ),
            child: label,
          ),
        ),
        const SizedBox(width: 16),
        trailing,
      ],
    );
  }
}

/// Numeric summary in a sidebar card — 今日 148 段, 已收藏 64.
class Stat extends StatelessWidget {
  const Stat({
    super.key,
    this.label,
    required this.value,
    this.unit,
    this.child,
  });

  final Widget? label;
  final Widget value;

  /// Trailing unit — 段 / 条.
  final Widget? unit;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Label(tone: LabelTone.faint, child: label!),
          ),
          const SizedBox(height: 7),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            DefaultTextStyle(
              style: tokens.typography.numericStyle(
                fontSize: 24,
                height: 1,
                color: colors.fg,
              ),
              child: value,
            ),
            if (unit != null) ...[
              const SizedBox(width: 5),
              DefaultTextStyle(
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  color: colors.fgSubtle,
                ),
                child: unit!,
              ),
            ],
          ],
        ),
        if (child != null) ...[const SizedBox(height: 7), child!],
      ],
    );
  }
}

/// The four-tick strength gauge under the 今日 counter.
class SegmentGauge extends StatelessWidget {
  const SegmentGauge({
    super.key,
    this.total = 4,
    required this.filled,
    this.partial = false,
  });

  /// Total number of ticks.
  final int total;

  /// Ticks at full strength.
  final int filled;

  /// One extra tick at half strength, as in the 今日 card.
  final bool partial;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ExcludeSemantics(
      child: Row(
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index > 0) const SizedBox(width: 3),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: index < filled
                      ? colors.accent
                      : (partial && index == filled
                            ? colors.accent.withValues(alpha: 0.45)
                            : colors.track),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
