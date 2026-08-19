import 'package:flutter/material.dart' hide Dialog;
import 'package:flutter/services.dart';

import '../i18n/i18n.dart';
import 'app_dialog.dart';
import 'custom_alert_dialog/show_dialog.dart';
import 'ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        DialogTone;

/// The one-question sheet: a title, a sentence, and a yes/no. Used wherever the
/// app is about to do something it cannot undo — 重置快捷键, 删除记录, 清空历史 —
/// so those all ask in the same voice.
///
/// `⏎` confirms and `esc` cancels; the confirming button takes focus on open
/// because the body has no field to hold it the way the forms do.
///
/// Port of `apps/storybook/src/screens/confirm-dialog.tsx`.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,

  /// `true` draws the sheet's danger border for something that throws data away.
  bool danger = false,
}) async {
  final confirmed = await showDialogInCurrentWindow<bool>(
    context: context,
    builder: (ctx) => _ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel ?? t.common.ui.button.cancel,
      danger: danger,
    ),
  );
  return confirmed == true;
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.danger,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () =>
            Navigator.of(context).pop(true),
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(false),
      },
      child: Focus(
        autofocus: true,
        child: AppDialog(
          width: 360,
          tone: danger ? DialogTone.danger : DialogTone.standard,
          title: Text(title),
          content: Text(
            message,
            style: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1.6,
              color: tokens.colors.fgSecondary,
            ),
          ),
          actions: [
            Button(
              variant: ButtonVariant.secondary,
              size: ButtonSize.md,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelLabel),
            ),
            Button(
              variant: ButtonVariant.primary,
              size: ButtonSize.md,
              shortcut: const Text('⏎'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ),
    );
  }
}
