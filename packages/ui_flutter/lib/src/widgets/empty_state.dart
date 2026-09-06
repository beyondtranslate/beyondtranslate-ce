import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// What a pane shows before it has content: one muted line and at most one
/// action.
///
/// The surrounding chrome already names the pane, so there is no heading, no
/// explainer copy, and no illustration.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, this.actions = const []});

  final String title;

  /// A row of controls, so it takes the control gap rather than the block gap.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vars.spacing14,
        horizontal: vars.spacing8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: vars.spacing3,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: vars.bodyMedium.copyWith(color: vars.colorContentSubtle),
          ),
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: vars.controlMediumGap,
              children: actions,
            ),
        ],
      ),
    );
  }
}
