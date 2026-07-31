import 'package:flutter/widgets.dart';

import 'ui.dart' show DesignThemeContext, NavItem;

/// A sidebar row: the design system's [NavItem] with a leading icon.
class NavigationItem extends StatelessWidget {
  const NavigationItem({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return NavItem(
      active: selected,
      onPressed: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: selected ? context.tokens.selectionFg : colors.fgNav,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
