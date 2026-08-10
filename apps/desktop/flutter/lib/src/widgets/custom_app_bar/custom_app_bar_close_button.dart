import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui.dart' show Button, ButtonVariant, DesignThemeContext;

class CustomAppBarCloseButton extends StatelessWidget {
  const CustomAppBarCloseButton({Key? key, this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
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
        child: Icon(
          FluentIcons.dismiss_20_regular,
          color: context.colors.fg,
          size: 22,
        ),
      ),
    );
  }
}
