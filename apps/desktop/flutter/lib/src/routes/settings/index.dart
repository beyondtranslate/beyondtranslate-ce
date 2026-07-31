import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../utils/utils.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/ui.dart'
    show DesignThemeContext, DesignTypographyStyles, TabItem, Tabs;
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

// ignore: unused_element
enum _SettingsCategory {
  general,
  appearance,
  shortcuts,
  providers,
  advanced;

  // ignore: unused_element
  static _SettingsCategory fromLocation(String location) {
    if (location.startsWith('/settings/providers')) {
      return _SettingsCategory.providers;
    }
    if (location.startsWith('/settings/appearance')) {
      return _SettingsCategory.appearance;
    }
    if (location.startsWith('/settings/shortcuts')) {
      return _SettingsCategory.shortcuts;
    }
    if (location.startsWith('/settings/advanced')) {
      return _SettingsCategory.advanced;
    }
    return _SettingsCategory.general;
  }
}

// ignore: unused_element
class _SettingsShellPage extends StatelessWidget {
  const _SettingsShellPage({
    required this.selectedCategory,
    required this.child,
  });

  final _SettingsCategory selectedCategory;
  final Widget child;

  void _navigateToCategory(BuildContext context, _SettingsCategory category) {
    switch (category) {
      case _SettingsCategory.general:
        const GeneralSettingsRoute().go(context);
      case _SettingsCategory.appearance:
        const AppearanceSettingsRoute().go(context);
      case _SettingsCategory.shortcuts:
        const ShortcutsSettingsRoute().go(context);
      case _SettingsCategory.providers:
        const ProvidersSettingsRoute().go(context);
      case _SettingsCategory.advanced:
        const AdvancedSettingsRoute().go(context);
    }
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required _SettingsCategory category,
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: NavigationItem(
        label: title,
        icon: icon,
        selected: selectedCategory == category,
        onTap: () => _navigateToCategory(context, category),
      ),
    );
  }

  Widget _buildCompactSidebarItem(
    BuildContext context, {
    required _SettingsCategory category,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedCategory == category;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
        label: Text(title),
        onSelected: (_) => _navigateToCategory(context, category),
      ),
    );
  }

  Widget _buildComponentShowcaseItem(BuildContext context,
      {bool compact = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final item = compact
        ? ChoiceChip(
            selected: false,
            showCheckmark: false,
            avatar: Icon(
              FluentIcons.data_bar_vertical_20_regular,
              size: 18,
              color: colorScheme.onSurface,
            ),
            label: const Text('UI Components'),
            onSelected: (_) => context.go('/debug/components'),
          )
        : NavigationItem(
            label: 'UI Components',
            icon: FluentIcons.data_bar_vertical_20_regular,
            onTap: () => context.go('/debug/components'),
          );

    return compact
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: item,
          )
        : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: item,
          );
  }

  Widget _buildSidebar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 210,
      color: context.colors.chrome,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              t.settings.layout.title,
              style: context.typography
                  .labelStyle(color: context.colors.accentText)
                  .copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              children: [
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.general,
                  icon: FluentIcons.settings_20_regular,
                  title: t.settings.general.title,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.appearance,
                  icon: FluentIcons.color_20_regular,
                  title: t.settings.appearance.title,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.shortcuts,
                  icon: FluentIcons.keyboard_20_regular,
                  title: t.settings.shortcuts.title,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.providers,
                  icon: FluentIcons.connector_20_regular,
                  title: t.settings.providers.title,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.advanced,
                  icon: FluentIcons.options_20_regular,
                  title: t.settings.advanced.title,
                ),
                _buildComponentShowcaseItem(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Text(
              formatTranslation(
                t.settings.version,
                args: [
                  sharedEnv.appVersion,
                  '${sharedEnv.appBuildNumber}',
                ],
              ),
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSidebar(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        children: [
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.general,
            icon: FluentIcons.settings_20_regular,
            title: t.settings.general.title,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.appearance,
            icon: FluentIcons.color_20_regular,
            title: t.settings.appearance.title,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.shortcuts,
            icon: FluentIcons.keyboard_20_regular,
            title: t.settings.shortcuts.title,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.providers,
            icon: FluentIcons.connector_20_regular,
            title: t.settings.providers.title,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.advanced,
            icon: FluentIcons.options_20_regular,
            title: t.settings.advanced.title,
          ),
          _buildComponentShowcaseItem(context, compact: true),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        if (isCompact) {
          return Column(
            children: [
              _buildCompactSidebar(context),
              const Divider(height: 1),
              Expanded(child: child),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSidebar(context),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.16),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}

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
    final colors = context.colors;
    final tabs = <TabItem<String>>[
      TabItem(
        value: const GeneralSettingsRoute().location,
        label: Text(t.settings.general.title),
      ),
      TabItem(
        value: const AppearanceSettingsRoute().location,
        label: Text(t.settings.appearance.title),
      ),
      TabItem(
        value: const ShortcutsSettingsRoute().location,
        label: Text(t.settings.shortcuts.title),
      ),
      TabItem(
        value: const ProvidersSettingsRoute().location,
        label: Text(t.settings.providers.title),
      ),
      TabItem(
        value: const AdvancedSettingsRoute().location,
        label: Text(t.settings.advanced.title),
      ),
    ];
    final active =
        tabs.firstWhereOrNull((tab) => location.startsWith(tab.value))?.value ??
            tabs.first.value;

    return ColoredBox(
      color: colors.window,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkbenchToolbar(
            title: t.settings.layout.title,
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Tabs<String>(
                    items: tabs,
                    value: active,
                    onChanged: context.go,
                    semanticsLabel: t.settings.layout.title,
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
