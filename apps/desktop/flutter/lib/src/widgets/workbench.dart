import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../utils/platform_util.dart';
import 'icon_action_button.dart';
import 'ui.dart'
    show
        BrandLogo,
        CaptionButton,
        DesignThemeContext,
        DesignTypographyStyles,
        Sidebar,
        WindowBody,
        WindowMain,
        WindowPlatform,
        WindowTitlebar;

/// Which chrome the shell draws, derived from the real OS. macOS maps to null
/// so [WindowTitlebar] keeps its default — the same convention as the React
/// `platform` prop, where undefined means macOS.
WindowPlatform? get _shellPlatform => kIsWindows
    ? WindowPlatform.windows
    : kIsLinux
        ? WindowPlatform.linux
        : null;

/// Real-window verbs for the platforms whose chrome the app draws itself.
/// On macOS the system owns all four — the native traffic lights sit over the
/// sidebar header and the hidden titlebar still drags — so nothing is passed
/// and the shell stays inert.
class WorkbenchWindowActions {
  const WorkbenchWindowActions({
    this.onMinimize,
    this.onToggleMaximize,
    this.onClose,
    this.onDragStart,
  });

  final VoidCallback? onMinimize;
  final VoidCallback? onToggleMaximize;
  final VoidCallback? onClose;

  /// Hands the gesture to the OS move loop — the Flutter approximation of a
  /// titlebar answering `WM_NCHITTEST` with `HTCAPTION`.
  final VoidCallback? onDragStart;
}

/// App identity for the platforms that have no menu bar. On macOS the app name
/// lives in the system menu bar and the window never repeats it; on Windows
/// and Linux the brand mark takes the traffic lights' spot at the sidebar's
/// head. Same mark the extension popup carries.
class _BrandMark extends StatelessWidget {
  const _BrandMark({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandLogo(size: 20),
        if (!compact) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'BeyondTranslate',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.displayStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
                color: tokens.colors.fg,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Makes a stretch of chrome behave like the native titlebar: dragging any
/// point that no control claims moves the window. The detector loses the
/// arena to every button inside it, so controls keep their taps.
class _TitlebarDragArea extends StatelessWidget {
  const _TitlebarDragArea({this.onDragStart, required this.child});

  final VoidCallback? onDragStart;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (onDragStart == null) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (_) => onDragStart!(),
      child: child,
    );
  }
}

/// The workbench shell in the Finder/Mail layout: the sidebar runs the full
/// height of the window and the toolbar spans only the content pane.
///
/// The sidebar's header strip is what lines its top up with that toolbar, so it
/// is always present. On macOS the real traffic lights sit in it and the
/// collapse toggle holds its trailing edge. Windows and Linux have no menu bar
/// to carry the app's name, so the brand mark takes this strip instead — their
/// collapse toggle moves to the toolbar's left, and their window buttons sit
/// at the toolbar's right edge, drawn by [WindowTitlebar].
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
    this.sidebarWidth,
    this.onSidebarWidthChange,
    this.windowActions,
  });

  final List<Widget> sidebar;
  final Widget child;

  /// Pinned to the sidebar's foot — the version/updater card.
  final Widget? sidebarFooter;

  /// Whether the sidebar is hidden.
  final bool collapsed;
  final VoidCallback? onToggleCollapsed;

  /// The sidebar's width, held by the shell rather than the sidebar itself:
  /// collapsing unmounts the column, and a width kept inside it would reset to
  /// the token every time the sidebar came back.
  final double? sidebarWidth;
  final ValueChanged<double>? onSidebarWidthChange;

  /// Real-window wiring for the self-drawn Windows/Linux chrome. Left null —
  /// on macOS, or in a gallery — the caption buttons stay decorative and the
  /// titlebar stops answering drags.
  final WorkbenchWindowActions? windowActions;

  @override
  Widget build(BuildContext context) {
    final isMacChrome = _shellPlatform == null;

    return _WorkbenchScope(
      collapsed: collapsed,
      onToggleCollapsed: onToggleCollapsed,
      windowActions: windowActions,
      // WindowBody is Flexible so it can also live inside WindowFrame in the
      // widget gallery. The app shell supplies the Flex parent here.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WindowBody(
            children: [
              if (!collapsed)
                Sidebar(
                  header: isMacChrome
                      ? (onToggleCollapsed == null
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                const Spacer(),
                                IconActionButton(
                                  icon: FluentIcons
                                      .panel_left_contract_20_regular,
                                  iconSize: 16,
                                  tooltip: '收起侧边栏',
                                  onPressed: onToggleCollapsed,
                                ),
                              ],
                            ))
                      // The strip doubles as titlebar on these platforms, so
                      // the whole band drags, not just the mark.
                      : _TitlebarDragArea(
                          onDragStart: windowActions?.onDragStart,
                          child: const SizedBox(
                            height: double.infinity,
                            child: Row(children: [_BrandMark()]),
                          ),
                        ),
                  footer: sidebarFooter,
                  // Dragging the divider past the floor collapses the column,
                  // which is the same state the header's toggle puts it in.
                  resizable: true,
                  width: sidebarWidth,
                  onWidthChange: onSidebarWidthChange,
                  onCollapse: onToggleCollapsed,
                  children: sidebar,
                ),
              WindowMain(children: [Expanded(child: child)]),
            ],
          ),
        ],
      ),
    );
  }
}

/// Hands the collapse state and the window verbs down to [WorkbenchToolbar],
/// which owns the expand affordance once the sidebar is gone and draws the
/// Windows/Linux caption cluster.
class _WorkbenchScope extends InheritedWidget {
  const _WorkbenchScope({
    required this.collapsed,
    required this.onToggleCollapsed,
    required this.windowActions,
    required super.child,
  });

  final bool collapsed;
  final VoidCallback? onToggleCollapsed;
  final WorkbenchWindowActions? windowActions;

  static _WorkbenchScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WorkbenchScope>();

  @override
  bool updateShouldNotify(_WorkbenchScope oldWidget) =>
      collapsed != oldWidget.collapsed ||
      onToggleCollapsed != oldWidget.onToggleCollapsed ||
      windowActions != oldWidget.windowActions;
}

/// A view's toolbar band, at the same height as the sidebar's header strip.
///
/// With the sidebar collapsed it opens with the expand toggle, inset past the
/// native traffic lights on macOS. On Windows and Linux the collapse toggle
/// lives here in both states — the sidebar header belongs to the brand mark —
/// and a collapsed sidebar hands the compact mark over so the app identity
/// never leaves the window.
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
    final platform = _shellPlatform;
    final isMacChrome = platform == null;
    final collapsed = scope != null && scope.collapsed;
    final canToggle = scope?.onToggleCollapsed != null;
    final actions = scope?.windowActions;

    Widget? leading;
    if (collapsed && canToggle) {
      leading = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The native traffic lights sit over this toolbar once the
          // sidebar is gone; keep clear of them. AppKit gives the trio hit
          // frames out to 80pt into the window (the visible dots end at 72);
          // past the band's own 16pt padding and the deck's 14pt toolbar gap,
          // the toggle starts at 94.
          if (kIsMacOS) const SizedBox(width: 78),
          // Collapsing the sidebar must not lose the app identity on the
          // platforms that carry it in the window.
          if (!isMacChrome) ...[
            const _BrandMark(compact: true),
            const SizedBox(width: 14),
          ],
          IconActionButton(
            icon: FluentIcons.panel_left_expand_20_regular,
            iconSize: 16,
            tooltip: '展开侧边栏',
            onPressed: scope.onToggleCollapsed,
          ),
        ],
      );
    } else if (!collapsed && canToggle && !isMacChrome) {
      leading = IconActionButton(
        icon: FluentIcons.panel_left_contract_20_regular,
        iconSize: 16,
        tooltip: '收起侧边栏',
        onPressed: scope!.onToggleCollapsed,
      );
    }

    return _TitlebarDragArea(
      onDragStart: actions?.onDragStart,
      child: WindowTitlebar(
        lights: false,
        platform: platform,
        onCaptionPressed: actions == null
            ? null
            : (button) {
                switch (button) {
                  case CaptionButton.minimize:
                    actions.onMinimize?.call();
                  case CaptionButton.maximize:
                    actions.onToggleMaximize?.call();
                  case CaptionButton.close:
                    actions.onClose?.call();
                }
              },
        leading: leading,
        title: title == null ? null : Text(title!),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, overflow: TextOverflow.ellipsis),
        children: children,
      ),
    );
  }
}
