import 'package:flutter/widgets.dart';

/// The scrolling body of a settings pane. Each block is its own bordered card,
/// so the blocks are separated by space rather than a rule.
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      itemCount: blocks.length,
      itemBuilder: (_, index) => blocks[index],
      separatorBuilder: (_, __) => const SizedBox(height: 22),
    );
  }
}
