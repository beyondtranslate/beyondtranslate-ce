import 'package:flutter/material.dart';

/// Shows a dialog as an overlay within the **current window**, bypassing the
/// Flutter multi-window dialog-window behavior.
///
/// In Flutter 3.47+ (main channel), when the new multi-window API
/// (Flutter's multi-window API and [ViewCollection]) is used, the standard [showDialog]
/// function opens dialogs in a **separate native dialog window** instead of
/// rendering them as overlays over the current window. This is because
/// [showRawDialog] checks for a [WindowRegistry] in the context and, if found,
/// creates a [_DialogWindowRoute] — a new native window.
///
/// This function bypasses that behavior by pushing a [DialogRoute] directly
/// onto the current window's [Navigator], exactly as [showDialog] did before
/// the multi-window changes.
Future<T?> showDialogInCurrentWindow<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
  bool fullscreenDialog = false,
  bool? requestFocus,
  AnimationStyle? animationStyle,
}) {
  final NavigatorState navigator = Navigator.of(context, rootNavigator: true);

  // Capture inherited themes from the caller's context so that the dialog
  // (which renders inside the navigator's context) inherits the same theme,
  // text direction, and media query data.
  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: navigator.context,
  );

  return navigator.push<T>(
    DialogRoute<T>(
      context: context,
      builder: builder,
      themes: themes,
      barrierColor: barrierColor ?? Colors.black54,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior:
          traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
      requestFocus: requestFocus,
      animationStyle: animationStyle,
      fullscreenDialog: fullscreenDialog,
    ),
  );
}
