import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
        DialogTone,
        ThemeDataBuildContextProps,
        ThemeVariables;

/// Centres a sheet and keeps it clear of the window's edges.
///
/// The kit's [Dialog] sizes to its content and caps only its width: how far a
/// sheet may grow before its body starts scrolling is a window decision, and
/// the kit draws no window. Every sheet in the app goes through here, so they
/// all stop at the same margin.
class DialogFrame extends StatelessWidget {
  const DialogFrame({super.key, required this.child});

  /// The margin a sheet keeps from the top and bottom of the window.
  static const double margin = 24;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height - margin * 2,
        ),
        child: child,
      ),
    );
  }
}

/// The app's dialog shell, in the shape [AlertDialog] is normally used in but
/// drawn from the design system: a header band, a padded body and a footer with
/// the actions pushed right.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.tone = DialogTone.normal,
    this.content,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final DialogTone tone;
  final Widget? content;

  /// Rendered right-aligned in the footer, primary action last.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    // No scroll view around the sheet: the body is the scroller now, so the
    // header and the footer stay put instead of scrolling off with it.
    return DialogFrame(
      child: Dialog(tone: tone, children: [
        DialogHeader(title: title, subtitle: subtitle),
        if (content != null) DialogBody(children: [content!]),
        if (actions.isNotEmpty)
          DialogFooter(children: [const Spacer(), ...actions]),
      ]),
    );
  }
}

/// A header band with a mark beside its title.
///
/// The kit's [DialogHeader] prints a title and a strapline, which is the whole
/// of what a dialog header is in the design. Two of the app's sheets name a
/// *provider*, and a provider is drawn with its icon everywhere else it
/// appears, so this repeats the kit's header with room for the mark. The type
/// and the spacing are the kit's own.
class AppDialogHeader extends StatelessWidget {
  const AppDialogHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final Widget icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = context.vars;

    return Container(
      padding: EdgeInsets.fromLTRB(
        vars.spacing5,
        vars.spacing4,
        vars.spacing5,
        vars.spacing2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: vars.spacing1,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: vars.spacing2,
            children: [
              icon,
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: vars.titleSmall.copyWith(color: vars.colorContent),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: vars.captionMedium.copyWith(
                color: vars.colorContentSubtle,
              ),
            ),
        ],
      ),
    );
  }
}
