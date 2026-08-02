import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../widgets/ui.dart' show DesignThemeContext, Kbd, Rail, RailItem;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import 'advanced.dart';
import 'appearance.dart';
import 'general.dart';
import 'providers.dart';
import 'shortcuts.dart';

part 'index.g.dart';

@TypedShellRoute<SettingsShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<GeneralSettingsRoute>(path: '/settings/general'),
    TypedGoRoute<ProvidersSettingsRoute>(path: '/settings/providers'),
    TypedGoRoute<AppearanceSettingsRoute>(path: '/settings/appearance'),
    TypedGoRoute<ShortcutsSettingsRoute>(path: '/settings/shortcuts'),
    TypedGoRoute<AdvancedSettingsRoute>(path: '/settings/advanced'),
  ],
)
class SettingsShellRoute extends ShellRouteData {
  const SettingsShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return SettingsTabsShell(
      location: state.uri.path,
      child: navigator,
    );
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
    return _buildSettingsPage(
      state: state,
      child: const GeneralSettingsPage(),
    );
  }
}

class AppearanceSettingsRoute extends GoRouteData
    with $AppearanceSettingsRoute {
  const AppearanceSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppearanceSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSettingsPage(
      state: state,
      child: const AppearanceSettingsPage(),
    );
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
  return NoTransitionPage<void>(
    key: state.pageKey,
    child: child,
  );
}

/// One row of the settings rail: a group and its route.
typedef _SettingsGroup = ({String location, String label});

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
    final tokens = context.tokens;
    final colors = tokens.colors;
    final groups = <_SettingsGroup>[
      (
        location: const GeneralSettingsRoute().location,
        label: t.settings.general.title,
      ),
      (
        location: const AppearanceSettingsRoute().location,
        label: t.settings.appearance.title,
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
    ];
    final active = groups
            .firstWhereOrNull((group) => location.startsWith(group.location))
            ?.location ??
        groups.first.location;

    return ColoredBox(
      color: colors.window,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkbenchToolbar(
            title: t.settings.layout.title,
            children: [
              const Spacer(),
              Kbd(t.settings.layout.effect_hint),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Rail(
                  children: [
                    for (final group in groups)
                      RailItem(
                        active: group.location == active,
                        onPressed: () => context.go(group.location),
                        child: Text(group.label),
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
