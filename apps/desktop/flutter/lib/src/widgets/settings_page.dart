import 'package:flutter/widgets.dart';

/// The scrolling body of a settings pane, in the deck's flat layout: sections
/// sit directly on the pane, separated by the deck's 22px of air — no cards,
/// no rules between them.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.children,
    this.actions = const [],
  });

  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[
      if (actions.isNotEmpty)
        Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
      ...children,
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      itemCount: blocks.length,
      itemBuilder: (_, index) => blocks[index],
      separatorBuilder: (_, __) => const SizedBox(height: 22),
    );
  }
}
