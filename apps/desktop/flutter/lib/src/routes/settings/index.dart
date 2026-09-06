import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../widgets/nav_columns.dart' show Rail, RailGroup, RailItem;
import '../../widgets/ui.dart' show KeyCap, ThemeDataBuildContextProps;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import 'about.dart';
import 'advanced.dart';
import 'general.dart';
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
    final vars = context.vars;
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
          (
            location: const AdvancedSettingsRoute().location,
            label: t.settings.advanced.title,
          ),
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

    return ColoredBox(
      color: vars.colorSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkbenchToolbar(
            title: t.settings.layout.title,
            children: [const Spacer(), KeyCap(t.settings.layout.effect_hint)],
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
                        label:
                            runs[i].label == null ? null : Text(runs[i].label!),
                        children: [
                          for (final page in runs[i].pages)
                            RailItem(
                              active: page.location == active,
                              onPressed: () => context.go(page.location),
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
    );
  }
}
