import 'package:flutter/material.dart';

import 'themes/design_theme.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(UiSpace.md),
    this.backgroundColor,
    this.elevated = false,
    this.showCorners = false,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool elevated;
  final bool showCorners;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    final panel = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.paper,
        border: Border.all(color: colors.border),
        boxShadow: boxShadow ??
            (elevated
                ? [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null),
      ),
      child: child,
    );
    if (!showCorners) return panel;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        panel,
        for (final alignment in const [
          Alignment.topLeft,
          Alignment.topRight,
          Alignment.bottomLeft,
          Alignment.bottomRight,
        ])
          Align(
            alignment: alignment,
            child: Transform.translate(
              offset: Offset(
                alignment.x.isNegative ? -6 : 6,
                alignment.y.isNegative ? -6 : 6,
              ),
              child: Icon(Icons.add, size: 12, color: colors.mutedText),
            ),
          ),
      ],
    );
  }
}
