import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

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
    final colors = context.design;
    final itemColor =
        selected ? colors.text : colors.text.withValues(alpha: 0.70);
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        hoverColor: colors.accent.withValues(alpha: 0.08),
        highlightColor: colors.accent.withValues(alpha: 0.10),
        child: Container(
          height: 34,
          color: selected ? colors.accent.withValues(alpha: 0.14) : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (selected)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(width: 2, color: colors.accent),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: selected ? colors.accent : itemColor,
                    ),
                    const SizedBox(width: UiSpace.xs),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: itemColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
