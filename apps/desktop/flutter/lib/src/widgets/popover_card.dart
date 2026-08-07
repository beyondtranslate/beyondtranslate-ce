import 'package:flutter/widgets.dart';

import 'ui.dart'
    show DesignThemeContext, DesignTypographyStyles, Label, LabelTone;

/// A floating card with up to four bands: a body, a labelled secondary band,
/// an action row and a hint strip. The pop-up over a text selection is built
/// from one.
class PopoverCard extends StatelessWidget {
  const PopoverCard({
    super.key,
    required this.title,
    required this.body,
    this.trailing,
    this.note,
    this.attribution,
    this.secondary,
    this.secondaryLabel,
    this.actions,
    this.hint,
    this.width = 352,
  });

  final Widget title;

  /// The prominent line under the title.
  final Widget body;

  /// Right of the title — 名词 · 术语, as on the desktop selection card.
  final Widget? trailing;

  /// A receded line under the body.
  final Widget? note;

  /// Row under the body — a badge and its source.
  final Widget? attribution;

  /// The second band, on the card surface.
  final Widget? secondary;

  /// The micro-heading above [secondary] — 整句.
  final Widget? secondaryLabel;
  final Widget? actions;

  /// Footer strip with a keyboard route — ⌥Space 展开全文.
  final Widget? hint;
  final double width;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final hairline = context.hairlineWidth;
    final topBorder = Border(
      top: BorderSide(color: colors.hairline, width: hairline),
    );

    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.window,
        border: Border.all(color: colors.hairlineStrong, width: hairline),
        borderRadius: BorderRadius.circular(tokens.radii.card),
        boxShadow: tokens.shadows.float,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: DefaultTextStyle(
                        style: tokens.typography.displayStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: colors.fg,
                        ),
                        child: title,
                      ),
                    ),
                    const Spacer(),
                    if (trailing != null) ...[
                      const SizedBox(width: 12),
                      Label(tone: LabelTone.faint, child: trailing!),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                DefaultTextStyle(
                  style: tokens.typography.cjkStyle(
                    fontSize: 15,
                    height: 1.85,
                    color: colors.fg,
                  ),
                  child: body,
                ),
                if (note != null) ...[
                  const SizedBox(height: 8),
                  DefaultTextStyle(
                    style: tokens.typography.cjkStyle(
                      fontSize: 12,
                      height: 1.7,
                      color: colors.fgTertiary,
                    ),
                    child: note!,
                  ),
                ],
                if (attribution != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: attribution,
                  ),
                ],
              ],
            ),
          ),
          if (secondary != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(color: colors.card, border: topBorder),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (secondaryLabel != null) ...[
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Label(
                        tone: LabelTone.faint,
                        child: secondaryLabel!,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  DefaultTextStyle(
                    style: tokens.typography.cjkStyle(
                      fontSize: 12,
                      height: 1.75,
                      color: colors.fgTertiary,
                    ),
                    child: secondary!,
                  ),
                ],
              ),
            ),
          if (actions != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(border: topBorder),
              child: actions,
            ),
          if (hint != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: colors.inset, border: topBorder),
              child: hint,
            ),
        ],
      ),
    );
  }
}
