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
    this.description,
    required this.children,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;
  final Widget? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final rows = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Label(child: title!),
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
          DefaultTextStyle(
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1.6,
              color: tokens.colors.fgSubtle,
            ),
            child: description!,
          ),
        ],
      ],
    );
  }
}
