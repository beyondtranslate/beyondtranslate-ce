import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

/// Where an [ActionBar]'s controls sit.
enum ActionBarAlign { start, end, between }

/// A row of controls.
///
/// It owns no colour and no box — only the rhythm — so it takes the shared
/// control gap rather than a token of its own: the small profile's, whatever
/// the children's size, since the design draws every action row on that one
/// step.
class ActionBar extends StatelessWidget {
  const ActionBar({
    super.key,
    this.align = ActionBarAlign.start,
    required this.children,
  });

  final ActionBarAlign align;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: switch (align) {
        ActionBarAlign.start => MainAxisAlignment.start,
        ActionBarAlign.end => MainAxisAlignment.end,
        ActionBarAlign.between => MainAxisAlignment.spaceBetween,
      },
      mainAxisSize: align == ActionBarAlign.start
          ? MainAxisSize.min
          : MainAxisSize.max,
      spacing: align == ActionBarAlign.between
          ? 0
          : context.vars.controlSmallGap,
      children: children,
    );
  }
}
