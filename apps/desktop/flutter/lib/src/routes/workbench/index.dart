import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../utils/utils.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        DesignThemeContext,
        DesignTypographyStyles,
        SidebarCard,
        SidebarGroup;
import '../../widgets/workbench.dart';
import '../settings/advanced.dart';
import '../settings/appearance.dart';
import '../settings/general.dart';
import '../settings/index.dart';
import '../settings/providers.dart';
import '../settings/shortcuts.dart';
import 'document.dart';
import 'glossary.dart';
import 'library.dart';
import 'translation.dart';

final ValueNotifier<String?> workbenchTextHandoff = ValueNotifier(null);

List<RouteBase> get $appRoutes => <RouteBase>[
      ShellRoute(
        builder: (context, state, child) => WorkbenchShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/translate',
            pageBuilder: (_, state) => _noTransitionPage(
              state,
              const WorkbenchTranslationPage(),
            ),
          ),
          GoRoute(
            path: '/document',
            pageBuilder: (_, state) => _noTransitionPage(
              state,
              const WorkbenchDocumentPage(),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (_, state) => _noTransitionPage(
              state,
              const WorkbenchLibraryPage(),
            ),
          ),
          GoRoute(
            path: '/glossary',
            pageBuilder: (_, state) => _noTransitionPage(
              state,
              const WorkbenchGlossaryPage(),
            ),
          ),
          ShellRoute(
            pageBuilder: (context, state, child) => _noTransitionPage(
              state,
              SettingsTabsShell(
                location: state.uri.path,
                child: child,
              ),
            ),
            routes: [
              GoRoute(
                path: '/settings/general',
                pageBuilder: (_, state) => _noTransitionPage(
                  state,
                  const GeneralSettingsPage(),
                ),
              ),
              GoRoute(
                path: '/settings/appearance',
                pageBuilder: (_, state) => _noTransitionPage(
                  state,
                  const AppearanceSettingsPage(),
                ),
              ),
              GoRoute(
                path: '/settings/shortcuts',
                pageBuilder: (_, state) => _noTransitionPage(
                  state,
                  const ShortcutsSettingsPage(),
                ),
              ),
              GoRoute(
                path: '/settings/providers',
                pageBuilder: (_, state) => _noTransitionPage(
                  state,
                  const ProvidersSettingsPage(),
                ),
              ),
              GoRoute(
                path: '/settings/advanced',
                pageBuilder: (_, state) => _noTransitionPage(
                  state,
                  const AdvancedSettingsPage(),
                ),
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

  bool _selected(String path) =>
      widget.location == path || widget.location.startsWith('$path/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Workbench(
        collapsed: _collapsed,
        onToggleCollapsed: () => setState(() => _collapsed = !_collapsed),
        sidebarFooter: const _SidebarVersion(),
        sidebar: [
          SidebarGroup(
            first: true,
            label: Text(t.workbench.workspace),
            children: [
              NavigationItem(
                label: t.workbench.translate,
                icon: FluentIcons.translate_20_regular,
                selected: _selected('/translate'),
                onTap: () => context.go('/translate'),
              ),
              NavigationItem(
                label: t.workbench.document,
                icon: FluentIcons.document_text_20_regular,
                selected: _selected('/document'),
                onTap: () => context.go('/document'),
              ),
              NavigationItem(
                label: t.workbench.glossary,
                icon: FluentIcons.book_20_regular,
                selected: _selected('/glossary'),
                onTap: () => context.go('/glossary'),
              ),
              NavigationItem(
                label: t.workbench.history,
                icon: FluentIcons.history_20_regular,
                selected: _selected('/history'),
                onTap: () => context.go('/history'),
              ),
              NavigationItem(
                label: t.settings.layout.title,
                icon: FluentIcons.settings_20_regular,
                selected: _selected('/settings'),
                onTap: () => context.go('/settings/general'),
              ),
            ],
          ),
        ],
        child: widget.child,
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
    final tokens = context.tokens;
    final colors = tokens.colors;

    // No 版本 label: the number carries the line on its own, and the three
    // lines are then one fact, one status and one control.
    return SidebarCard(
      gap: 6,
      children: [
        Text(
          sharedEnv.appVersion,
          style: tokens.typography.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: colors.fg,
          ),
        ),
        Text(
          _checking ? t.workbench.version_checking : t.workbench.version_latest,
          style: tokens.typography.sansStyle(
            fontSize: 11,
            height: 1,
            color: colors.fgSubtle,
          ),
        ),
        // The updater sits a hair lower than the two lines above it, the
        // deck's `mt-0.5`.
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Button(
            size: ButtonSize.xs,
            fullWidth: true,
            enabled: !_checking,
            onPressed: _check,
            child: Text(t.workbench.check_updates),
          ),
        ),
      ],
    );
  }
}
