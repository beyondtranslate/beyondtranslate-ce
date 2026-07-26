import 'package:flutter/material.dart';

import 'ui/panel.dart';
import 'ui/themes/design_theme.dart';

class Workbench extends StatelessWidget {
  const Workbench({
    super.key,
    required this.sidebar,
    required this.child,
    this.subtitle,
    this.footer,
  });

  final List<Widget> sidebar;
  final Widget child;
  final String? subtitle;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;
    return Panel(
      padding: EdgeInsets.zero,
      elevated: true,
      child: Column(
        children: [
          Container(
            height: 38,
            padding: EdgeInsets.only(
              left: isMacOS ? 78 : UiSpace.sm,
              right: UiSpace.sm,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.border)),
            ),
            child: Row(
              children: [
                if (subtitle != null) ...[
                  Expanded(
                    child: Text(
                      subtitle!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: colors.quietText),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 172,
                  child: ColoredBox(
                    color: colors.panel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: UiSpace.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: sidebar,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 1, color: colors.border),
                Expanded(child: child),
              ],
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
