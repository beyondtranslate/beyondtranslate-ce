import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../utils/platform_util.dart';
import 'icon_action_button.dart';
import 'ui.dart' show Sidebar, WindowBody, WindowMain, WindowTitlebar;

/// The workbench shell in the Finder/Mail layout: the sidebar runs the full
/// height of the window and the toolbar spans only the content pane.
///
/// The sidebar's header strip is what lines its top up with that toolbar, so it
/// is always present. In the design deck it holds the traffic lights; here they
/// are the window's own, so the strip stays empty and only reserves the height —
/// on macOS the real lights sit in it, elsewhere it is blank chrome. The
/// collapse toggle sits at the strip's trailing edge; collapsed, the sidebar
/// disappears entirely and [WorkbenchToolbar] picks the toggle up as its
/// leading control, right after where the native traffic lights sit.
///
/// The toolbar belongs to the view, not to the shell — each page renders its
/// own [WorkbenchToolbar] as the first thing in [child].
class Workbench extends StatelessWidget {
  const Workbench({
    super.key,
    required this.sidebar,
    required this.child,
    this.sidebarFooter,
    this.collapsed = false,
    this.onToggleCollapsed,
  });

  final List<Widget> sidebar;
  final Widget child;

  /// Pinned to the sidebar's foot — the version/updater card.
  final Widget? sidebarFooter;

  /// Whether the sidebar is hidden.
  final bool collapsed;
  final VoidCallback? onToggleCollapsed;

  @override
  Widget build(BuildContext context) {
    return _WorkbenchScope(
      collapsed: collapsed,
      onToggleCollapsed: onToggleCollapsed,
      child: WindowBody(
        children: [
          if (!collapsed)
            Sidebar(
              header: onToggleCollapsed == null
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        const Spacer(),
                        IconActionButton(
                          icon: FluentIcons.panel_left_contract_20_regular,
                          tooltip: '收起侧边栏',
                          onPressed: onToggleCollapsed,
                        ),
                      ],
                    ),
              footer: sidebarFooter,
              children: sidebar,
            ),
          WindowMain(children: [Expanded(child: child)]),
        ],
      ),
    );
  }
}

/// Hands the collapse state down to [WorkbenchToolbar], which owns the
/// expand affordance once the sidebar is gone.
class _WorkbenchScope extends InheritedWidget {
  const _WorkbenchScope({
    required this.collapsed,
    required this.onToggleCollapsed,
    required super.child,
  });

  final bool collapsed;
  final VoidCallback? onToggleCollapsed;

  static _WorkbenchScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WorkbenchScope>();

  @override
  bool updateShouldNotify(_WorkbenchScope oldWidget) =>
      collapsed != oldWidget.collapsed ||
      onToggleCollapsed != oldWidget.onToggleCollapsed;
}

/// A view's toolbar band, at the same height as the sidebar's header strip.
/// With the sidebar collapsed it opens with the expand toggle, inset past the
/// native traffic lights on macOS.
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
    final scope = _WorkbenchScope.maybeOf(context);
    final showExpand =
        scope != null && scope.collapsed && scope.onToggleCollapsed != null;

    return WindowTitlebar(
      lights: false,
      leading: showExpand
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The native traffic lights sit over this toolbar once the
                // sidebar is gone; keep clear of them.
                if (kIsMacOS) const SizedBox(width: 56),
                IconActionButton(
                  icon: FluentIcons.panel_left_expand_20_regular,
                  tooltip: '展开侧边栏',
                  onPressed: scope.onToggleCollapsed,
                ),
              ],
            )
          : null,
      title: title == null ? null : Text(title!),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, overflow: TextOverflow.ellipsis),
      children: children,
    );
  }
}
