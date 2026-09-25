import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/window_controller.dart';
import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/app_windows.dart'
    show hideWorkbenchWindow, workbenchWindowController;
import '../../theme/product_tokens.dart' show ProductTypography;
import '../../utils/platform_util.dart';
import '../../utils/utils.dart';
import '../../widgets/nav_columns.dart' show SidebarItem;
import '../../widgets/ui.dart'
    show
        Button,
        SidebarCard,
        SidebarGroup,
        ThemeDataBuildContextProps,
        WidgetSize;
import '../../widgets/window_focus.dart' show WindowFocusTracker;
import '../../widgets/workbench.dart';
import '../settings/about.dart';
import '../settings/advanced.dart';
import '../settings/general.dart';
import '../settings/index.dart';
import '../settings/providers.dart';
import '../settings/services.dart';
import '../settings/shortcuts.dart';
import 'glossary.dart';
import 'library.dart';
import 'translation.dart';

List<RouteBase> get $appRoutes => <RouteBase>[
      // An indexed-stack shell so each destination keeps its Navigator (and
      // page state — 翻译 keeps its source text and results) while the
      // sidebar switches between them.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            WorkbenchShell(location: state.uri.path, child: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/translate',
                pageBuilder: (_, state) =>
                    _noTransitionPage(state, const WorkbenchTranslationPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                pageBuilder: (_, state) =>
                    _noTransitionPage(state, const WorkbenchLibraryPage()),
              ),
            ],
          ),
          if (kGlossaryFeatureEnabled)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/glossary',
                  pageBuilder: (_, state) =>
                      _noTransitionPage(state, const WorkbenchGlossaryPage()),
                ),
              ],
            ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                pageBuilder: (context, state, child) => _noTransitionPage(
                  state,
                  SettingsTabsShell(location: state.uri.path, child: child),
                ),
                routes: [
                  GoRoute(
                    path: '/settings/general',
                    pageBuilder: (_, state) =>
                        _noTransitionPage(state, const GeneralSettingsPage()),
                  ),
                  GoRoute(
                    path: '/settings/services',
                    pageBuilder: (_, state) =>
                        _noTransitionPage(state, const ServicesSettingsPage()),
                  ),
                  GoRoute(
                    path: '/settings/shortcuts',
                    pageBuilder: (_, state) =>
                        _noTransitionPage(state, const ShortcutsSettingsPage()),
                  ),
                  GoRoute(
                    path: '/settings/providers',
                    pageBuilder: (_, state) =>
                        _noTransitionPage(state, const ProvidersSettingsPage()),
                  ),
                  GoRoute(
                    path: '/settings/advanced',
                    pageBuilder: (_, state) =>
                        _noTransitionPage(state, const AdvancedSettingsPage()),
                  ),
                  GoRoute(
                    path: '/settings/about',
                    pageBuilder: (_, state) =>
                        _noTransitionPage(state, const AboutSettingsPage()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];

Page<void> _noTransitionPage(GoRouterState state, Widget child) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

class WorkbenchShell extends StatefulWidget {
  const WorkbenchShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  State<WorkbenchShell> createState() => _WorkbenchShellState();
}

class _WorkbenchShellState extends State<WorkbenchShell> {
  bool _collapsed = false;

  /// Kept here rather than in the sidebar: collapsing unmounts that column, so
  /// a width held inside it would go back to the token on every re-open.
  double? _sidebarWidth;

  bool _selected(String path) =>
      widget.location == path || widget.location.startsWith('$path/');

  /// The shell draws its own window buttons on Windows and Linux, so they get
  /// the real verbs. Close hides rather than destroys — the app lives on in
  /// the tray, the same answer the window delegate gives the native close.
  /// Dragging and resizing are not wired here: the shell hands the window
  /// itself to nativeapi's widgets, which run the OS's own move and resize
  /// loops.
  WorkbenchWindowActions? get _windowActions {
    if (!kIsWindows && !kIsLinux) return null;
    final window = workbenchWindowController.window;
    return WorkbenchWindowActions(
      window: window,
      onMinimize: window.minimize,
      onToggleMaximize: () {
        if (window.isMaximized) {
          window.unmaximize();
        } else {
          window.maximize();
        }
      },
      onClose: hideWorkbenchWindow,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Over the whole shell, not just the sidebar: the settings, history and
    // glossary rails ride in `child` and have to lose the accent with it.
    return WindowFocusTracker(
      window: workbenchWindowController.window,
      child: ColoredBox(
        color: context.vars.colorSurface,
        child: Workbench(
          collapsed: _collapsed,
          onToggleCollapsed: () => setState(() => _collapsed = !_collapsed),
          sidebarWidth: _sidebarWidth,
          onSidebarWidthChange: (width) =>
              setState(() => _sidebarWidth = width),
          windowActions: _windowActions,
          sidebarFooter: const _SidebarVersion(),
          sidebar: [
            SidebarGroup(label: t.workbench.workspace, children: [
              SidebarItem(
                  label: t.workbench.translate,
                  icon: FluentIcons.translate_20_regular,
                  current: _selected('/translate'),
                  onPressed: () => context.go('/translate')),
              if (kGlossaryFeatureEnabled)
                SidebarItem(
                    label: t.workbench.glossary,
                    icon: FluentIcons.book_20_regular,
                    current: _selected('/glossary'),
                    onPressed: () => context.go('/glossary')),
              SidebarItem(
                  label: t.workbench.history,
                  icon: FluentIcons.history_20_regular,
                  current: _selected('/history'),
                  onPressed: () => context.go('/history')),
              SidebarItem(
                  label: t.settings.layout.title,
                  icon: FluentIcons.settings_20_regular,
                  current: _selected('/settings'),
                  onPressed: () => context.go('/settings/general')),
            ]),
          ],
          child: widget.child,
        ),
      ),
    );
  }
}

/// The card pinned to the sidebar's foot, the deck's SidebarVersion: the
/// version, its status, and the updater button — three lines in every state.
/// There is no updater service yet, so 检查更新 plays its checking state and
/// lands back on 已是最新.
class _SidebarVersion extends StatefulWidget {
  const _SidebarVersion();

  @override
  State<_SidebarVersion> createState() => _SidebarVersionState();
}

class _SidebarVersionState extends State<_SidebarVersion> {
  bool _checking = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _check() {
    setState(() => _checking = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _checking = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;

    // No 版本 label: the number carries the line on its own, and the three
    // lines are then one fact, one status and one control.
    return SidebarCard(
      children: [
        Text(
          sharedEnv.appVersion,
          style: vars.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: vars.colorContent,
          ),
        ),
        Text(
          _checking ? t.workbench.version_checking : t.workbench.version_latest,
          style: vars.sansStyle(
            fontSize: 11,
            height: 1,
            color: vars.colorContentSubtle,
          ),
          // The ellipsis in 正在检查… comes from a fallback face whose metrics
          // differ from the sans; the strut keeps the line the same height in
          // both states so the card never jumps.
          strutStyle: const StrutStyle(
            fontSize: 11,
            height: 1,
            forceStrutHeight: true,
          ),
        ),
        // The updater sits a hair lower than the two lines above it, the
        // deck's `mt-0.5`.
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Button(
              size: WidgetSize.tiny,
              expand: true,
              onPressed: !_checking ? _check : null,
              child: Text(t.workbench.check_updates)),
        ),
      ],
    );
  }
}
