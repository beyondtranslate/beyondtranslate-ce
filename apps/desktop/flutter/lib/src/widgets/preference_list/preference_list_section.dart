import 'package:flutter/widgets.dart';

import '../ui.dart' show DesignThemeContext, DesignTypographyStyles, Label;

/// A titled group of preference rows in the deck's flat shape: a section
/// label over the rows themselves — no card, no per-row rules. Sections are
/// separated by the page, not by their own chrome.
class PreferenceListSection extends StatelessWidget {
  const PreferenceListSection({
    Key? key,
    this.leading,
    this.title,
    this.action,
    this.description,
    this.labelInset = 0,
    required this.children,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;

  /// The group's own action, pinned to the right of the label — 添加提供商...,
  /// 刷新列表. The deck aligns it to the label's baseline rather than its box,
  /// so a taller button does not push the heading off its line.
  final Widget? action;

  final Widget? description;

  /// How far the label and the footnote sit inside the rows.
  ///
  /// A list row draws its hover wash wider than its text, so on panes built
  /// from rows the pane narrows its gutter and the group pushes its prose back
  /// out by the row's own inset — that is what lines a heading up with the
  /// names under it while the wash still bleeds past both.
  final double labelInset;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final proseInset = EdgeInsets.symmetric(horizontal: labelInset);

    final rows = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || action != null) ...[
          Padding(
            padding: proseInset,
            child: action == null
                ? Label(child: title!)
                // Baseline, not centre: the action is taller than the heading,
                // and centring it would lift the heading off the line its rows
                // sit on.
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Label(child: title ?? const Text('')),
                      action!,
                    ],
                  ),
          ),
          const SizedBox(height: 11),
        ],
        if (leading == null)
          rows
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading!,
              const SizedBox(width: 12),
              Expanded(child: rows),
            ],
          ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: proseInset,
            child: DefaultTextStyle(
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 1.6,
                color: tokens.colors.fgSubtle,
              ),
              child: description!,
            ),
          ),
        ],
      ],
    );
  }
}
