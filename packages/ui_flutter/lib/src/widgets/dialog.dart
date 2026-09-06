import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';

/// What a dialog is about to do.
enum DialogTone { normal, danger }

/// The sheet a modal form or a confirmation is built in.
///
/// It never grows past its scrim, and when the content still does not fit,
/// the body scrolls while the header and footer stay put.
class Dialog extends StatelessWidget {
  const Dialog({
    super.key,
    this.tone = DialogTone.normal,
    required this.children,
  });

  final DialogTone tone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: vars.dialogWidth),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: vars.colorSurface,
          border: Border.all(
            color: tone == DialogTone.danger
                // A dangerous sheet is edged in its own hue.
                ? vars.colorDanger[600]!.withValues(alpha: 0.34)
                : vars.colorBorderStrong,
            width: context.hairlineWidth,
          ),
          // The window corner and the popover shadow: a dialog is a window
          // that floats, not a panel that hovers at the window's own
          // elevation.
          borderRadius: BorderRadius.circular(vars.frameWindowRadius),
          boxShadow: vars.shadowLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// The title band.
class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      // Floored so a subtitle-less header still balances the footer.
      constraints: BoxConstraints(minHeight: vars.spacing11),
      padding: EdgeInsets.symmetric(
        vertical: vars.spacing3,
        horizontal: vars.spacing5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: vars.spacing1,
        children: [
          Text(
            title,
            style: vars.labelStrong.copyWith(
              fontSize: vars.titleSmall.fontSize,
              height: 1,
              letterSpacing: -0.01 * vars.titleSmall.fontSize!,
              color: vars.colorContent,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: vars.captionSmall.copyWith(
                color: vars.colorContentSubtle,
              ),
            ),
        ],
      ),
    );
  }
}

/// The only part that scrolls, so the only part that may shrink.
class DialogBody extends StatelessWidget {
  const DialogBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Flexible(
      child: SingleChildScrollView(
        // A step and a half: the body pads deeper than the chrome above and
        // below it, so the content sits clear of both rules rather than level
        // with their text.
        padding: EdgeInsets.symmetric(
          vertical: vars.spacing4 + vars.spacing05,
          horizontal: vars.spacing5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: vars.spacing4,
          children: children,
        ),
      ),
    );
  }
}

/// The action band.
class DialogFooter extends StatelessWidget {
  const DialogFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: vars.spacing3,
        horizontal: vars.spacing5,
      ),
      decoration: BoxDecoration(
        color: vars.colorSurfaceChrome,
        border: Border(
          top: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(spacing: vars.spacing2, children: children),
    );
  }
}

/// Puts a dialog over the window.
///
/// The stylesheet's scrim is `position: fixed`, which has no counterpart in
/// Flutter's layout — a widget placed in the tree is bounded by whatever
/// holds it. A modal has to reach the [Navigator] to cover the window, so
/// this is what makes the scrim mean what the stylesheet says it means.
///
/// Returns whatever the dialog pops with.
Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool dismissible = true,
}) {
  final ThemeData theme = Theme.of(context);

  return Navigator.of(context, rootNavigator: true).push<T>(
    RawDialogRoute<T>(
      barrierDismissible: dismissible,
      barrierLabel: 'Dismiss',
      // The scrim paints itself, so the barrier stays out of the way.
      barrierColor: const Color(0x00000000),
      transitionDuration: theme.vars.motionDuration,
      pageBuilder: (context, animation, secondaryAnimation) => Theme(
        data: theme,
        child: Builder(
          builder: (context) => DialogScrim(
            onDismiss: dismissible ? () => Navigator.of(context).pop() : null,
            child: builder(context),
          ),
        ),
      ),
      transitionBuilder: (context, animation, secondary, child) =>
          FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: theme.vars.motionEasing,
            ),
            child: child,
          ),
    ),
  );
}

/// The dim behind a modal.
class DialogScrim extends StatelessWidget {
  const DialogScrim({super.key, this.onDismiss, required this.child});

  final VoidCallback? onDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        // The ink at quarter strength — a wash of the theme's own foreground,
        // so a dark theme dims with its pale ink rather than with more black
        // on black.
        color: vars.colorContent.withValues(alpha: vars.dialogScrimAlpha),
        child: Padding(
          padding: EdgeInsets.all(vars.spacing6),
          child: Center(
            child: GestureDetector(onTap: () {}, child: child),
          ),
        ),
      ),
    );
  }
}
