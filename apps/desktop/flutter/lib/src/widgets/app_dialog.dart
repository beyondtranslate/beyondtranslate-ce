import 'package:flutter/widgets.dart';

import 'ui.dart'
    show Dialog, DialogBody, DialogFooter, DialogHeader, DialogTone;

/// The app's dialog shell, in the shape [AlertDialog] is normally used in but
/// drawn from the design system: a header band, a padded body and a footer with
/// the actions pushed right.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.width = 440,
    this.tone = DialogTone.standard,
    this.content,
    this.actions = const [],
  });

  final Widget title;
  final Widget? subtitle;
  final double width;
  final DialogTone tone;
  final Widget? content;

  /// Rendered right-aligned in the footer, primary action last.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    // No scroll view around the sheet: the body is the scroller now, so the
    // header and the footer stay put instead of scrolling off with it.
    return Center(
      child: Dialog(
        width: width,
        tone: tone,
        children: [
          DialogHeader(title: title, subtitle: subtitle),
          if (content != null) DialogBody(children: [content!]),
          if (actions.isNotEmpty)
            DialogFooter(children: [const Spacer(), ...actions]),
        ],
      ),
    );
  }
}
