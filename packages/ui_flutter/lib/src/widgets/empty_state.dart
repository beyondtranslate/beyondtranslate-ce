import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

/// What a pane shows before it has content: one muted line and at most one
/// action. The surrounding chrome already names the pane, so no label, no
/// explainer copy, no illustration.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, this.action});

  final Widget title;

  /// Primary affordance out of the empty state.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: tokens.typography.sansStyle(
                fontSize: 13,
                color: tokens.colors.fgSubtle,
              ),
              child: title,
            ),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}
