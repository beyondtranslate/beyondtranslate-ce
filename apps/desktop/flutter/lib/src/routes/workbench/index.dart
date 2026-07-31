import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show TranslationTarget;
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Label,
        LabelTone,
        SidebarCard,
        SidebarGroup;
import '../../widgets/workbench.dart';
import '../settings/advanced.dart';
import '../settings/appearance.dart';
import '../settings/general.dart';
import '../settings/index.dart';
import '../settings/providers.dart';
import '../settings/shortcuts.dart';
import 'placeholder.dart';
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
              WorkbenchPlaceholderPage(
                title: t.workbench.document,
                message: t.workbench.placeholder.document,
                icon: FluentIcons.document_48_regular,
              ),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (_, state) => _noTransitionPage(
              state,
              WorkbenchPlaceholderPage(
                title: t.workbench.history,
                message: t.workbench.placeholder.history,
                icon: FluentIcons.bookmark_32_regular,
              ),
            ),
          ),
          GoRoute(
            path: '/glossary',
            pageBuilder: (_, state) => _noTransitionPage(
              state,
              WorkbenchPlaceholderPage(
                title: t.workbench.glossary,
                message: t.workbench.placeholder.glossary,
                icon: FluentIcons.book_open_48_regular,
              ),
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

class WorkbenchShell extends StatelessWidget {
  const WorkbenchShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  bool _selected(String path) =>
      location == path || location.startsWith('$path/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Workbench(
        footer: _StatusBar(location: location),
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
                icon: FluentIcons.document_20_regular,
                selected: _selected('/document'),
                onTap: () => context.go('/document'),
              ),
              NavigationItem(
                label: t.workbench.history,
                icon: FluentIcons.bookmark_20_regular,
                selected: _selected('/history'),
                onTap: () => context.go('/history'),
              ),
              NavigationItem(
                label: t.workbench.glossary,
                icon: FluentIcons.book_open_20_regular,
                selected: _selected('/glossary'),
                onTap: () => context.go('/glossary'),
              ),
              NavigationItem(
                label: t.settings.layout.title,
                icon: FluentIcons.settings_20_regular,
                selected: _selected('/settings'),
                onTap: () => context.go('/settings/general'),
              ),
            ],
          ),
          _RecentLanguages(targets: settingsStore.general.translationTargets),
        ],
        child: child,
      ),
    );
  }
}

class _RecentLanguages extends StatelessWidget {
  const _RecentLanguages({required this.targets});

  final List<TranslationTarget> targets;

  @override
  Widget build(BuildContext context) {
    final visible = targets.take(3).toList(growable: false);
    return SidebarCard(
      label: Text(t.workbench.recent_languages),
      children: [
        if (visible.isEmpty)
          Text(
            t.workbench.not_configured,
            style: context.typography.sansStyle(
              fontSize: 11,
              color: context.colors.fgSubtle,
            ),
          )
        else
          for (final target in visible)
            Text(
              '${getSourceDisplayName(target.source)} → '
              '${getLanguageName(target.target)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typography.sansStyle(
                fontSize: 11,
                color: context.colors.fgMuted,
              ),
            ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(
          tone: LabelTone.faint,
          child: Text(
            location.startsWith('/settings')
                ? t.workbench.status.settings_synced
                : t.workbench.status.runtime_ready,
          ),
        ),
        const Spacer(),
        Label(
          tone: LabelTone.faint,
          child: Text(t.workbench.status.shortcuts),
        ),
      ],
    );
  }
}
