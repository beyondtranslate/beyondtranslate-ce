import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui.dart' show Button, ButtonVariant, DesignThemeContext;

class CustomAppBarActionItem extends StatelessWidget {
  const CustomAppBarActionItem({
    Key? key,
    this.icon,
    this.text,
    this.child,
    this.padding,
    this.onPressed,
  }) : super(key: key);

  final IconData? icon;
  final String? text;
  final Widget? child;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 12),
      child: Button(
        variant: ButtonVariant.quiet,
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
            return;
          }
          if (context.canPop()) {
            context.pop();
          }
        },
        child: child ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(icon, size: 20, color: context.colors.fg),
                if (text != null)
                  Padding(
                    padding: EdgeInsets.only(left: icon != null ? 4 : 0),
                    child: Text(text!),
                  ),
              ],
            ),
      ),
    );
  }
}
