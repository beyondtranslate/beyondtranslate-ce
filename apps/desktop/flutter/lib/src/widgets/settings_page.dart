import 'package:flutter/widgets.dart';

import 'ui.dart' show Divider;

/// The scrolling body of a settings pane, in the deck's flat layout: sections
/// sit directly on the pane, separated by the deck's 22px of air — no cards,
/// no rules between them.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.children,
    this.actions = const [],
    this.horizontalPadding = 24,
  });

  final List<Widget> children;
  final List<Widget> actions;

  /// The pane's gutter. Panes built from list rows narrow it, because a row
  /// carries its own 8px inset and its hover wash is meant to run wider than
  /// the text — see [PreferenceListSection.labelInset].
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[
      if (actions.isNotEmpty)
        Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
      ...children,
    ];
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        22,
        horizontalPadding,
        24,
      ),
      itemCount: blocks.length,
      itemBuilder: (_, index) => blocks[index],
      // A rule brings its own air, so the page does not add the usual gap
      // around it as well.
      separatorBuilder: (_, index) => blocks[index] is SettingsSectionDivider ||
              blocks[index + 1] is SettingsSectionDivider
          ? const SizedBox.shrink()
          : const SizedBox(height: 22),
    );
  }
}

/// The rule a page draws between two groups, for the few panes that need one.
///
/// Its air is deliberately lopsided: the rule sits closer to the group it
/// closes (14px) than to the label that opens the next one (20px), so each
/// heading belongs to the rows under it rather than floating midway between
/// two groups.
class SettingsSectionDivider extends StatelessWidget {
  const SettingsSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 14, bottom: 20),
      child: Divider(),
    );
  }
}
