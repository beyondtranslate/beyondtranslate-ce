import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// The second column: the groups, books or pages inside whatever the sidebar
/// selected. Lighter than the sidebar, because it sits closer to the content.
class Rail extends StatelessWidget {
  const Rail({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      width: vars.frameRailWidth,
      decoration: BoxDecoration(
        color: vars.colorSurface,
        border: BorderDirectional(
          end: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: vars.spacing35,
          horizontal: vars.spacing25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: vars.frameNavGap,
          children: children,
        ),
      ),
    );
  }
}

/// The trailing information column.
///
/// It shares the sidebar's surface rather than the rail's, so a window reads
/// as content between two quieter edges rather than as three different greys.
class Aside extends StatelessWidget {
  const Aside({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      width: vars.frameAsideWidth,
      decoration: BoxDecoration(
        color: vars.colorSurfaceMuted,
        border: BorderDirectional(
          start: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(vars.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: vars.spacing5,
          children: children,
        ),
      ),
    );
  }
}
