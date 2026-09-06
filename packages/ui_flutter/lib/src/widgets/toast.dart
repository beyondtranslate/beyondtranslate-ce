import 'package:flutter/widgets.dart';

import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'icon_button.dart';

/// The tint a [Toast]'s glyph carries.
enum ToastTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// A transient receipt for something that happened out of view.
///
/// One line, no wrapping — anything needing a second sentence belongs in an
/// [Callout] in the flow instead.
class Toast extends StatelessWidget {
  const Toast({
    super.key,
    required this.message,
    this.icon,
    this.tint = ToastTint.neutral,
    this.action,
    this.onDismiss,
  });

  final String message;
  final IconData? icon;
  final ToastTint tint;
  final Widget? action;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final ColorSwatch<int> ramp = switch (tint) {
      ToastTint.primary => vars.colorPrimary,
      ToastTint.neutral => vars.colorNeutral,
      ToastTint.info => vars.colorInfo,
      ToastTint.success => vars.colorSuccess,
      ToastTint.warning => vars.colorWarning,
      ToastTint.danger => vars.colorDanger,
    };

    return ConstrainedBox(
      constraints: BoxConstraints(
        // Sized to its content but never past the viewport, so the stack
        // needs no magic width and a long message truncates instead of
        // pushing wide.
        maxWidth: vars.toastMaxWidth,
        minHeight: vars.spacing9,
      ),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsetsDirectional.only(
            top: vars.spacing15,
            bottom: vars.spacing15,
            // Asymmetric on purpose: the text gets breathing room, the
            // dismiss button sits tight in the corner it lives in.
            start: vars.spacing3,
            end: vars.spacing15,
          ),
          decoration: BoxDecoration(
            color: vars.colorSurface,
            border: Border.all(
              color: vars.colorBorderStrong,
              width: context.hairlineWidth,
            ),
            borderRadius: BorderRadius.circular(vars.radiusBig),
            boxShadow: vars.shadowMd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: vars.spacing25,
            children: [
              if (icon != null)
                Icon(icon, size: vars.spacing4, color: ramp[600]),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: vars.spacing05),
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: vars.labelMedium.copyWith(
                      height: 1.4,
                      color: vars.colorContent,
                    ),
                  ),
                ),
              ),
              ?action,
              if (onDismiss != null)
                IconButton(
                  icon: _kDismiss,
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The dismiss glyph, from the icon library the package already ships.
const IconData _kDismiss = IconData(0xe5cd, fontFamily: 'MaterialIcons');
