// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$settingsShellRoute];

RouteBase get $settingsShellRoute => ShellRouteData.$route(
      factory: $SettingsShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/settings/general',
          factory: $GeneralSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/services',
          factory: $ServicesSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/shortcuts',
          factory: $ShortcutsSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/providers',
          factory: $ProvidersSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/advanced',
          factory: $AdvancedSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/about',
          factory: $AboutSettingsRoute._fromState,
        ),
      ],
    );

extension $SettingsShellRouteExtension on SettingsShellRoute {
  static SettingsShellRoute _fromState(GoRouterState state) =>
      const SettingsShellRoute();
}

mixin $GeneralSettingsRoute on GoRouteData {
  static GeneralSettingsRoute _fromState(GoRouterState state) =>
      const GeneralSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/general');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ServicesSettingsRoute on GoRouteData {
  static ServicesSettingsRoute _fromState(GoRouterState state) =>
      const ServicesSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/services');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ShortcutsSettingsRoute on GoRouteData {
  static ShortcutsSettingsRoute _fromState(GoRouterState state) =>
      const ShortcutsSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/shortcuts');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProvidersSettingsRoute on GoRouteData {
  static ProvidersSettingsRoute _fromState(GoRouterState state) =>
      const ProvidersSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/providers');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdvancedSettingsRoute on GoRouteData {
  static AdvancedSettingsRoute _fromState(GoRouterState state) =>
      const AdvancedSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/advanced');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AboutSettingsRoute on GoRouteData {
  static AboutSettingsRoute _fromState(GoRouterState state) =>
      const AboutSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
