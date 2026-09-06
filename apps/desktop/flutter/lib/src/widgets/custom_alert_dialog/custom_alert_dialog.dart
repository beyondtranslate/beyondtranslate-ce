import 'package:flutter/material.dart';

import '../ui.dart' show Button, ButtonVariant, Spinner, WidgetSize;

const kDialogActionTypePrimary = 'primary';
const kDialogActionTypeSecondary = 'secondary';
const kDialogActionTypeSuccess = 'success';
const kDialogActionTypeDanger = 'danger';

// ignore: must_be_immutable
class CustomDialogAction extends StatelessWidget {
  CustomDialogAction({
    super.key,
    this.type,
    this.processing = false,
    required this.child,
    this.onPressed,
  });

  String? type;
  final bool processing;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      height: 38,
      child: Button(
          variant: type == kDialogActionTypeSecondary
              ? ButtonVariant.normal
              : ButtonVariant.filled,
          size: WidgetSize.large,
          expand: true,
          onPressed: processing ? null : onPressed,
          child: processing
              ? const Spinner(size: WidgetSize.small, onAccent: true)
              : child),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key, this.title, this.content, this.actions});
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DefaultTextStyle(
        style: textTheme.bodyMedium!,
        child: Container(
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            color: theme.dialogTheme.backgroundColor ?? theme.canvasColor,
            borderRadius: BorderRadius.circular(2),
          ),
          margin: const EdgeInsets.only(left: 40, right: 40),
          padding: const EdgeInsets.only(top: 20, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: DefaultTextStyle(
                  style: textTheme.bodyMedium!.copyWith(fontSize: 16),
                  child: title ?? Container(),
                ),
              ),
              if (content != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 18,
                    bottom: 30,
                  ),
                  child: content,
                ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    for (var i = 0; i < (actions ?? []).length; i++)
                      Builder(
                        builder: (_) {
                          CustomDialogAction action =
                              actions![i] as CustomDialogAction;
                          if (action.type == null && i == actions!.length - 1) {
                            action.type = kDialogActionTypePrimary;
                          }
                          return Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: action,
                            ),
                          );
                        },
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
