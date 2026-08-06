import 'package:flutter/widgets.dart';

import 'ui.dart' show NavItem;

/// A sidebar row: the design system's [NavItem] with a leading glyph, sized at
/// 15 like the deck's workspace navigation.
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
    return NavItem(
      active: selected,
      onPressed: onTap,
      // The row tints the glyph, so it is passed without a colour.
      icon: Icon(icon),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
