import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:nativeapi_flutter/nativeapi_flutter.dart' as nativeapi;

import '../theme/product_tokens.dart' show ProductTypography;
import '../utils/platform_util.dart';
import 'brand_logo.dart' show BrandLogo;
import 'icon_action_button.dart';
import 'nav_columns.dart' show Sidebar;
import 'ui.dart' show Button, ButtonVariant, ThemeDataBuildContextProps;
import 'window_chrome.dart'
    show CaptionButton, WindowBody, WindowMain, WindowPlatform, WindowTitlebar;

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
    required this.window,
    this.onMinimize,
    this.onToggleMaximize,
    this.onClose,
  });

  /// The native window the shell stands for. Everything a titlebar does by
  /// being a titlebar — dragging the window, double-tapping to maximize,
  /// resizing from an edge — is nativeapi's to answer, so the window goes to
  /// its widgets rather than being wrapped in callbacks here. The buttons the
  /// shell draws are the part that is ours, and they keep their verbs below:
  /// close in particular has to hide rather than destroy.
  final nativeapi.Window window;

  final VoidCallback? onMinimize;
  final VoidCallback? onToggleMaximize;
  final VoidCallback? onClose;
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
    final vars = context.vars;

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
              style: vars.displayStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
                color: vars.colorContent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Makes a stretch of chrome behave like the native titlebar: dragging any
/// point that no control claims moves the window, and a double tap maximizes
/// or restores it. Both come from nativeapi's [nativeapi.DragToMoveArea],
/// which hands the gesture to the OS move loop — the Flutter answer to a
/// titlebar replying `HTCAPTION` to `WM_NCHITTEST`. It hit-tests translucent
/// and loses the arena to every button inside it, so controls keep their taps.
///
/// With no window — macOS, or a gallery — the band is left as it is rather
/// than resolving whatever window happens to be current.
class _TitlebarDragArea extends StatelessWidget {
  const _TitlebarDragArea({this.window, required this.child});

  final nativeapi.Window? window;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (window == null) return child;
    return nativeapi.DragToMoveArea(window: window, child: child);
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
      child: _ResizeEdges(
        window: windowActions?.window,
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
                            window: windowActions?.window,
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
      ),
    );
  }
}

/// Gives a frameless window its resize borders back.
///
/// Hiding the titlebar costs the two platforms different things. Windows keeps
/// its frame — nativeapi leaves the edges resizable when it takes the caption
/// away — but a GTK window with its decorations off has no frame left at all,
/// and with it go the borders the window manager would have resized from. So
/// Linux gets nativeapi's [nativeapi.DragToResizeArea], which puts the handles
/// back inside the window and answers them with `startResizing`, and Windows
/// is left to its own frame rather than carrying a second set over it.
class _ResizeEdges extends StatelessWidget {
  const _ResizeEdges({this.window, required this.child});

  final nativeapi.Window? window;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (window == null || !kIsLinux) return child;
    return nativeapi.DragToResizeArea(window: window, child: child);
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
      window: actions?.window,
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

/// The key that opens a view's search. ⌘ is a Mac keyboard's; elsewhere the
/// key in that position is Ctrl, the same split the input box's submit key
/// makes, so the chip and the binding are both spelled from the platform.
SingleActivator get workbenchSearchActivator => SingleActivator(
      LogicalKeyboardKey.keyF,
      meta: kIsMacOS,
      control: !kIsMacOS,
    );

/// 搜索 ⌘F — the titlebar's way into a view's search field, shared by every
/// view that has one so they all put it in the same place and draw it alike.
///
/// Recessed, the deck's `ghost` on the inset ground: it is chrome that opens
/// something, not the view's primary action, and the filled button beside it
/// on 术语库 has to stay the one accent in the band.
class WorkbenchSearchButton extends StatelessWidget {
  const WorkbenchSearchButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.recessed,
      // The chip names the key [WorkbenchSearchScope] actually binds; a
      // hint for a key nothing answers is worse than no hint.
      shortcut: Text(kIsMacOS ? '⌘F' : '⌃F'),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// Puts the caret in the search field below it, which the key is opened from
/// as often as the button and has to be typed into straight after.
///
/// The field's own `autofocus` cannot be relied on for this: it only lands
/// while nothing else in the view has held focus, and a view with its own
/// inputs — 术语库's draft row — often has. So the field's node is found once
/// it is attached — on mount, and again each time [request] moves, which is
/// the key pressed with the field already open and the caret somewhere else.
class WorkbenchSearchFocus extends StatefulWidget {
  const WorkbenchSearchFocus({
    super.key,
    this.request = 0,
    required this.child,
  });

  final int request;
  final Widget child;

  @override
  State<WorkbenchSearchFocus> createState() => _WorkbenchSearchFocusState();
}

class _WorkbenchSearchFocusState extends State<WorkbenchSearchFocus> {
  /// A marker in the focus tree, never a focus target of its own.
  final FocusNode _slot = FocusNode(
    debugLabel: 'WorkbenchSearchFocus',
    skipTraversal: true,
    canRequestFocus: false,
  );

  @override
  void initState() {
    super.initState();
    _focusField();
  }

  @override
  void didUpdateWidget(WorkbenchSearchFocus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.request != oldWidget.request) _focusField();
  }

  void _focusField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _slot.traversalDescendants.firstOrNull?.requestFocus();
    });
  }

  @override
  void dispose() {
    _slot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Focus(focusNode: _slot, child: widget.child);
}

/// Binds [workbenchSearchActivator] across a view, so the key the
/// [WorkbenchSearchButton] advertises does what the button does.
///
/// A shortcut only fires for focus inside its subtree, and a click on a row
/// or on the sidebar moves no focus, so the view holds focus of its own and
/// takes it whenever it is shown. Shown means the shell's branch went live:
/// the views stay mounted offstage in an indexed stack, and [TickerMode] is
/// what flips when the sidebar switches to one — the same signal 翻译 uses to
/// put the caret back in its source box.
///
/// What it holds is a scope rather than a plain node, because a desktop text
/// field drops its focus on any click outside it, and unfocusing hands focus
/// to the nearest enclosing scope. Were that the route's, it would sit above
/// this binding and the key would go dead until the view was shown again; as
/// this one, focus falls back inside the view and the key keeps working.
class WorkbenchSearchScope extends StatefulWidget {
  const WorkbenchSearchScope({
    super.key,
    required this.onSearch,
    required this.child,
  });

  /// Null while the view has nothing to search — the key is then left to
  /// whoever else wants it.
  final VoidCallback? onSearch;

  final Widget child;

  @override
  State<WorkbenchSearchScope> createState() => _WorkbenchSearchScopeState();
}

class _WorkbenchSearchScopeState extends State<WorkbenchSearchScope> {
  /// Skipped by traversal: it is where the view's keys land, not a stop a
  /// tab should pause on with nothing to show for it.
  final FocusScopeNode _node = FocusScopeNode(
    debugLabel: 'WorkbenchSearchScope',
    skipTraversal: true,
  );

  bool _shown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shown = TickerMode.valuesOf(context).enabled;
    if (shown && !_shown) {
      // After the frame: on the first showing the scope is not in the focus
      // tree yet, and a scope asked for focus before it is attached drops the
      // request rather than holding it the way a plain node does.
      WidgetsBinding.instance.addPostFrameCallback((_) => _claimFocus());
    }
    _shown = shown;
  }

  /// A scope asked for focus hands it to whatever in the view held it last —
  /// the search field, say — before it keeps it for itself, so focus already
  /// somewhere in the view is left where it is.
  void _claimFocus() {
    if (!mounted || !_shown || _node.hasFocus) return;
    _node.requestFocus();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSearch = widget.onSearch;
    return CallbackShortcuts(
      bindings: {if (onSearch != null) workbenchSearchActivator: onSearch},
      child: FocusScope(node: _node, child: widget.child),
    );
  }
}
