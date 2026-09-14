import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../widgets/nav_columns.dart' show Rail, RailGroup, RailItem;
import '../../widgets/ui.dart' show ThemeDataBuildContextProps;
import '../../widgets/workbench.dart'
    show WorkbenchSearchButton, WorkbenchSearchScope, WorkbenchToolbar;
import 'about.dart';
import 'advanced.dart';
import 'general.dart';
import 'provider_catalog.dart';
import 'providers.dart';
import 'services.dart';
import 'shortcuts.dart';

part 'index.g.dart';

@TypedShellRoute<SettingsShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<GeneralSettingsRoute>(path: '/settings/general'),
    TypedGoRoute<ServicesSettingsRoute>(path: '/settings/services'),
    TypedGoRoute<ShortcutsSettingsRoute>(path: '/settings/shortcuts'),
    TypedGoRoute<ProvidersSettingsRoute>(path: '/settings/providers'),
    TypedGoRoute<AdvancedSettingsRoute>(path: '/settings/advanced'),
    TypedGoRoute<AboutSettingsRoute>(path: '/settings/about'),
  ],
)
class SettingsShellRoute extends ShellRouteData {
  const SettingsShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return SettingsTabsShell(location: state.uri.path, child: navigator);
  }
}

class GeneralSettingsRoute extends GoRouteData with $GeneralSettingsRoute {
  const GeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(state: state, child: const GeneralSettingsPage());
  }
}

class ServicesSettingsRoute extends GoRouteData with $ServicesSettingsRoute {
  const ServicesSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ServicesSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(
      state: state,
      child: const ServicesSettingsPage(),
    );
  }
}

class AboutSettingsRoute extends GoRouteData with $AboutSettingsRoute {
  const AboutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(state: state, child: const AboutSettingsPage());
  }
}

class ShortcutsSettingsRoute extends GoRouteData with $ShortcutsSettingsRoute {
  const ShortcutsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ShortcutsSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(
      state: state,
      child: const ShortcutsSettingsPage(),
    );
  }
}

class AdvancedSettingsRoute extends GoRouteData with $AdvancedSettingsRoute {
  const AdvancedSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdvancedSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(
      state: state,
      child: const AdvancedSettingsPage(),
    );
  }
}

class ProvidersSettingsRoute extends GoRouteData with $ProvidersSettingsRoute {
  const ProvidersSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProvidersSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(
      state: state,
      child: const ProvidersSettingsPage(),
    );
  }
}

Page<void> _buildSettingsPage({
  required GoRouterState state,
  required Widget child,
}) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

/// One row of the settings rail: a page and its route.
typedef _SettingsPage = ({String location, String label});

/// One run of the rail. The first run goes unlabelled — the pane's own title
/// already says what it is.
typedef _SettingsRun = ({String? label, List<_SettingsPage> pages});

/// The settings shell in the deck's layout: the toolbar names the view, and
/// under it the settings rail sits beside the content column — inside the
/// workbench that makes three columns (sidebar · rail · content), exactly
/// like the React SettingsView.
class SettingsTabsShell extends StatelessWidget {
  const SettingsTabsShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final runs = <_SettingsRun>[
      (
        label: null,
        pages: [
          (
            location: const GeneralSettingsRoute().location,
            label: t.settings.general.title,
          ),
          (
            location: const ServicesSettingsRoute().location,
            label: t.settings.services.title,
          ),
          (
            location: const ShortcutsSettingsRoute().location,
            label: t.settings.shortcuts.title,
          ),
          (
            location: const ProvidersSettingsRoute().location,
            label: t.settings.providers.title,
          ),
          // 高级 is hidden for now. The page and its route stay wired, so
          // /settings/advanced still opens when something navigates there —
          // only the way in from the rail is off.
          // (
          //   location: const AdvancedSettingsRoute().location,
          //   label: t.settings.advanced.title,
          // ),
        ],
      ),
      // 关于 sits in its own run: everything above it is something you change,
      // and this run is what the app says about itself. 支持 rather than 其他,
      // because we can already name what lands here next — 帮助、反馈、诊断 —
      // and a run called 其他 is one nobody ever knows to look in.
      (
        label: t.settings.layout.support,
        pages: [
          (
            location: const AboutSettingsRoute().location,
            label: t.settings.about.title,
          ),
        ],
      ),
    ];
    final pages = [for (final run in runs) ...run.pages];
    final active = pages
            .firstWhereOrNull((page) => location.startsWith(page.location))
            ?.location ??
        pages.first.location;

    // 搜索 belongs to the window's titlebar, as on 历史 and 术语库, but only
    // one screen here has anything to search — the provider catalogue — so
    // the button and its key come and go with it.
    return ValueListenableBuilder<bool>(
      valueListenable: providersSearchable,
      builder: (context, searchable, _) => _buildShell(
        context,
        runs: runs,
        active: active,
        onSearch:
            searchable && active == const ProvidersSettingsRoute().location
                ? () => providersSearchRequest.value++
                : null,
      ),
    );
  }

  Widget _buildShell(
    BuildContext context, {
    required List<_SettingsRun> runs,
    required String active,
    required VoidCallback? onSearch,
  }) {
    final vars = context.vars;
    return WorkbenchSearchScope(
      onSearch: onSearch,
      child: ColoredBox(
        color: vars.colorSurface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WorkbenchToolbar(
              title: t.settings.layout.title,
              children: [
                if (onSearch != null) ...[
                  const Spacer(),
                  WorkbenchSearchButton(
                    label: t.settings.providers.search.button,
                    onPressed: onSearch,
                  ),
                ],
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Rail(
                    resizable: true,
                    children: [
                      for (var i = 0; i < runs.length; i++)
                        RailGroup(
                          first: i == 0,
                          label: runs[i].label == null
                              ? null
                              : Text(runs[i].label!),
                          children: [
                            for (final page in runs[i].pages)
                              RailItem(
                                active: page.location == active,
                                // Switching page leaves a provider's detail page
                                // too, so an unsaved key is asked about here as
                                // well as on its own 返回.
                                onPressed: () async {
                                  final leave =
                                      await confirmLeavingProviderDetail(
                                    context,
                                  );
                                  if (!leave || !context.mounted) return;
                                  if (page.location == active) {
                                    providersCatalogRequest.value++;
                                  } else {
                                    context.go(page.location);
                                  }
                                },
                                child: Text(page.label),
                              ),
                          ],
                        ),
                    ],
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
