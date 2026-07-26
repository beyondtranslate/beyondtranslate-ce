import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show TranslationTarget;
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/ui/themes/design_theme.dart';
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
        subtitle: _subtitle,
        footer: _StatusBar(location: location),
        sidebar: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Text(
              t.workbench.workspace,
              style: context.eyebrowTextStyle.copyWith(fontSize: 9),
            ),
          ),
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
          const Spacer(),
          _RecentLanguages(targets: settingsStore.general.translationTargets),
        ],
        child: child,
      ),
    );
  }

  String? get _subtitle {
    if (_selected('/translate')) return t.workbench.subtitle.translate;
    if (_selected('/settings')) return t.workbench.subtitle.settings;
    if (_selected('/document')) return t.workbench.document;
    if (_selected('/history')) return t.workbench.history;
    if (_selected('/glossary')) return t.workbench.glossary;
    return null;
  }
}

class _RecentLanguages extends StatelessWidget {
  const _RecentLanguages({required this.targets});

  final List<TranslationTarget> targets;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    final visible = targets.take(3).toList(growable: false);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.workbench.recent_languages,
            style: context.eyebrowTextStyle.copyWith(
              color: colors.quietText,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 5),
          if (visible.isEmpty)
            Text(
              t.workbench.not_configured,
              style: TextStyle(fontSize: 12, color: colors.quietText),
            )
          else
            for (final target in visible)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '${getSourceDisplayName(target.source)} → '
                  '${getLanguageName(target.target)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: colors.mutedText),
                ),
              ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Text(
            location.startsWith('/settings')
                ? t.workbench.status.settings_synced
                : t.workbench.status.runtime_ready,
            style: context.eyebrowTextStyle.copyWith(
              color: colors.quietText,
              fontSize: 9,
            ),
          ),
          const Spacer(),
          Text(
            t.workbench.status.shortcuts,
            style: context.eyebrowTextStyle.copyWith(
              color: colors.quietText,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
