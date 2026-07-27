import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../utils/utils.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/ui/themes/design_theme.dart';
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
      color: context.design.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              t.settings.layout.title,
              style: context.eyebrowTextStyle.copyWith(fontSize: 12),
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
    final colors = context.design;
    final tabs = <(String, String)>[
      (t.settings.general.title, const GeneralSettingsRoute().location),
      (t.settings.appearance.title, const AppearanceSettingsRoute().location),
      (t.settings.shortcuts.title, const ShortcutsSettingsRoute().location),
      (t.settings.providers.title, const ProvidersSettingsRoute().location),
      (t.settings.advanced.title, const AdvancedSettingsRoute().location),
    ];

    return Theme(
      data: _settingsTheme(context),
      child: ColoredBox(
        color: colors.paper,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var index = 0; index < tabs.length; index++) ...[
                      if (index > 0) const SizedBox(width: 14),
                      Builder(
                        builder: (context) {
                          final tab = tabs[index];
                          final selected = location.startsWith(tab.$2);
                          return InkWell(
                            onTap: () => context.go(tab.$2),
                            splashColor: Colors.transparent,
                            hoverColor: colors.accent.withValues(alpha: 0.08),
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: selected
                                        ? colors.accent
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab.$1,
                                style: TextStyle(
                                  color: selected
                                      ? colors.text
                                      : colors.text.withValues(alpha: 0.55),
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

ThemeData _settingsTheme(BuildContext context) {
  final base = Theme.of(context);
  final colors = context.design;
  return base.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: colors.translatedSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      labelStyle: TextStyle(fontSize: 12, color: colors.mutedText),
      hintStyle: TextStyle(fontSize: 12.5, color: colors.quietText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colors.text.withValues(alpha: 0.28)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colors.text.withValues(alpha: 0.28)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colors.accent),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: colors.text.withValues(alpha: 0.40)),
      ),
      titleTextStyle: context.eyebrowTextStyle.copyWith(
        color: colors.text,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: colors.text,
        fontSize: 13,
        fontFamily: 'MiSans',
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colors.paper,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: colors.border),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      side: BorderSide(color: colors.text.withValues(alpha: 0.30)),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colors.accent
            : Colors.transparent,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colors.accent
            : colors.text.withValues(alpha: 0.30),
      ),
    ),
  );
}
