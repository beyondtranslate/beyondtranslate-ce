import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

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
    final colors = context.design;
    final blocks = <Widget>[
      if (actions.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ...children,
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      itemCount: blocks.length,
      itemBuilder: (_, index) => blocks[index],
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Divider(height: 1, color: colors.border),
      ),
    );
  }
}
