import 'package:flutter/widgets.dart';

import 'ui.dart'
    show Sidebar, WindowBody, WindowFooter, WindowMain, WindowTitlebar;

/// The workbench shell in the Finder/Mail layout: the sidebar runs the full
/// height of the window and the toolbar spans only the content pane.
///
/// The sidebar's header strip is what lines its top up with that toolbar, so it
/// is always present. In the design deck it holds the traffic lights; here they
/// are the window's own, so the strip stays empty and only reserves the height —
/// on macOS the real lights sit in it, elsewhere it is blank chrome.
///
/// The toolbar belongs to the view, not to the shell — each page renders its
/// own [WorkbenchToolbar] as the first thing in [child].
class Workbench extends StatelessWidget {
  const Workbench({
    super.key,
    required this.sidebar,
    required this.child,
    this.footer,
  });

  final List<Widget> sidebar;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WindowBody(
          children: [
            Sidebar(
              header: const SizedBox.shrink(),
              children: sidebar,
            ),
            WindowMain(children: [Expanded(child: child)]),
          ],
        ),
        if (footer != null) WindowFooter(children: [Expanded(child: footer!)]),
      ],
    );
  }
}

/// A view's toolbar band, at the same height as the sidebar's header strip.
class WorkbenchToolbar extends StatelessWidget {
  const WorkbenchToolbar({
    super.key,
    this.title,
    this.subtitle,
    this.children = const [],
  });

  final String? title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return WindowTitlebar(
      lights: false,
      title: title == null ? null : Text(title!),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, overflow: TextOverflow.ellipsis),
      children: children,
    );
  }
}
