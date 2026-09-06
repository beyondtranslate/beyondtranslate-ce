import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui.dart' show Button, ButtonVariant, ThemeDataBuildContextProps;

class CustomAppBarBackButton extends StatelessWidget {
  const CustomAppBarBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Button(
          variant: ButtonVariant.plain,
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
            FluentIcons.chevron_left_20_regular,
            color: context.vars.colorContent,
            size: 24,
          )),
    );
  }
}
