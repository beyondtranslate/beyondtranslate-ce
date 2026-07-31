import 'package:flutter/widgets.dart';

import '../../widgets/ui.dart' show EmptyState;
import '../../widgets/workbench.dart' show WorkbenchToolbar;

class WorkbenchPlaceholderPage extends StatelessWidget {
  const WorkbenchPlaceholderPage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkbenchToolbar(title: title),
        Expanded(
          child: EmptyState(
            title: Text(title),
            description: Text(message),
          ),
        ),
      ],
    );
  }
}
