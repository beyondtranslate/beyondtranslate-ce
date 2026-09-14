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
        22,
      ),
      itemCount: blocks.length,
      itemBuilder: (_, index) => blocks[index],
      separatorBuilder: (_, index) => const SizedBox(height: 22),
    );
  }
}

/// The rule a page draws between two groups, for the few panes that need one.
///
/// It is one more block in the page's column and takes the same 22px on
/// either side as any other — the deck's rule sits in that gap rather than
/// bringing air of its own.
class SettingsSectionDivider extends StatelessWidget {
  const SettingsSectionDivider({super.key});

  @override
  Widget build(BuildContext context) => const Divider();
}
