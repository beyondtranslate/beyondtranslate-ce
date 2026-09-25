import 'package:flutter/widgets.dart';

import '../widgets/ui.dart' as ui;
import 'product_tokens.dart'
    show ProductFonts, ProductTokens, ProductTypography;

/// Where a [DesignThemeFamily] comes from, which is how 设置 groups them.
///
/// The same three groups, in the same order, as the kit's own storybook
/// toolbar: the families drawn for the kit, then the ones imported from
/// desktop environments and from Omarchy, each derived from a few colours.
enum DesignThemeGroup {
  /// The six families the kit is drawn in and tested against.
  builtin,

  /// The desktops the app runs on — macOS, Windows, the GNOME and KDE Linuxes.
  desktops,

  /// Omarchy's themes, in its own order.
  omarchy,
}

/// The palette family the design system paints with.
///
/// Each family carries its own light and dark pair, so this is orthogonal to
/// [Brightness]: the family picks the character, the brightness picks the pair.
/// The two are chosen separately in 设置 › 外观 and stored separately, so a
/// theme survives a switch to 跟随系统 and back.
enum DesignThemeFamily {
  /// Muted violet on near-white / near-black — the kit's baseline.
  studio('studio', 'Studio', DesignThemeGroup.builtin, ui.themeVariables,
      ui.themeVariablesStudioDark),

  /// Warm paper and ink navy, marked in acid green. The default.
  bright('bright', 'Bright', DesignThemeGroup.builtin,
      ui.themeVariablesBrightLight, ui.themeVariablesBrightDark),

  /// Cool teal on a blue-grey ground.
  frost('frost', 'Frost', DesignThemeGroup.builtin, ui.themeVariablesFrostLight,
      ui.themeVariablesFrostDark),

  /// Neutral greys, no hue at all beyond the state colours.
  graphite('graphite', 'Graphite', DesignThemeGroup.builtin,
      ui.themeVariablesGraphiteLight, ui.themeVariablesGraphiteDark),

  /// Warm rust on a sand ground.
  ember('ember', 'Ember', DesignThemeGroup.builtin, ui.themeVariablesEmberLight,
      ui.themeVariablesEmberDark),

  /// Cool white paper and blue-grey ink, marked in blurple.
  nocturne('nocturne', 'Nocturne', DesignThemeGroup.builtin,
      ui.themeVariablesNocturneLight, ui.themeVariablesNocturneDark),

  macos27('macos27', 'macOS 27 Golden Gate', DesignThemeGroup.desktops,
      ui.themeVariablesMacos27Light, ui.themeVariablesMacos27Dark),
  macos15('macos15', 'macOS 15 Sequoia', DesignThemeGroup.desktops,
      ui.themeVariablesMacos15Light, ui.themeVariablesMacos15Dark),
  windows11('windows11', 'Windows 11', DesignThemeGroup.desktops,
      ui.themeVariablesWindows11Light, ui.themeVariablesWindows11Dark),
  ubuntu('ubuntu', 'Ubuntu', DesignThemeGroup.desktops,
      ui.themeVariablesUbuntuLight, ui.themeVariablesUbuntuDark),
  debian('debian', 'Debian (GNOME)', DesignThemeGroup.desktops,
      ui.themeVariablesDebianLight, ui.themeVariablesDebianDark),
  fedora('fedora', 'Fedora (GNOME)', DesignThemeGroup.desktops,
      ui.themeVariablesFedoraLight, ui.themeVariablesFedoraDark),
  kde('kde', 'KDE Plasma', DesignThemeGroup.desktops, ui.themeVariablesKdeLight,
      ui.themeVariablesKdeDark),
  omarchyTokyoNight(
      'omarchy-tokyo-night',
      'Tokyo Night',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyTokyoNightLight,
      ui.themeVariablesOmarchyTokyoNightDark),
  omarchyCatppuccin(
      'omarchy-catppuccin',
      'Catppuccin',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyCatppuccinLight,
      ui.themeVariablesOmarchyCatppuccinDark),
  omarchyCatppuccinLatte(
      'omarchy-catppuccin-latte',
      'Catppuccin Latte',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyCatppuccinLatteLight,
      ui.themeVariablesOmarchyCatppuccinLatteDark),
  omarchyEthereal(
      'omarchy-ethereal',
      'Ethereal',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyEtherealLight,
      ui.themeVariablesOmarchyEtherealDark),
  omarchyEverforest(
      'omarchy-everforest',
      'Everforest',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyEverforestLight,
      ui.themeVariablesOmarchyEverforestDark),
  omarchyFlexokiLight(
      'omarchy-flexoki-light',
      'Flexoki Light',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyFlexokiLightLight,
      ui.themeVariablesOmarchyFlexokiLightDark),
  omarchyGruvbox(
      'omarchy-gruvbox',
      'Gruvbox',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyGruvboxLight,
      ui.themeVariablesOmarchyGruvboxDark),
  omarchyHackerman(
      'omarchy-hackerman',
      'Hackerman',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyHackermanLight,
      ui.themeVariablesOmarchyHackermanDark),
  omarchyKanagawa(
      'omarchy-kanagawa',
      'Kanagawa',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyKanagawaLight,
      ui.themeVariablesOmarchyKanagawaDark),
  omarchyLastHorizon(
      'omarchy-last-horizon',
      'Last Horizon',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyLastHorizonLight,
      ui.themeVariablesOmarchyLastHorizonDark),
  omarchyLumon('omarchy-lumon', 'Lumon', DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyLumonLight, ui.themeVariablesOmarchyLumonDark),
  omarchyLupine('omarchy-lupine', 'Lupine', DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyLupineLight, ui.themeVariablesOmarchyLupineDark),
  omarchyMatteBlack(
      'omarchy-matte-black',
      'Matte Black',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyMatteBlackLight,
      ui.themeVariablesOmarchyMatteBlackDark),
  omarchyMiasma('omarchy-miasma', 'Miasma', DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyMiasmaLight, ui.themeVariablesOmarchyMiasmaDark),
  omarchyNord('omarchy-nord', 'Nord', DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyNordLight, ui.themeVariablesOmarchyNordDark),
  omarchyOsakaJade(
      'omarchy-osaka-jade',
      'Osaka Jade',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyOsakaJadeLight,
      ui.themeVariablesOmarchyOsakaJadeDark),
  omarchyRetro82(
      'omarchy-retro-82',
      'Retro 82',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyRetro82Light,
      ui.themeVariablesOmarchyRetro82Dark),
  omarchyRistretto(
      'omarchy-ristretto',
      'Ristretto',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyRistrettoLight,
      ui.themeVariablesOmarchyRistrettoDark),
  omarchyRosePine(
      'omarchy-rose-pine',
      'Rosé Pine',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyRosePineLight,
      ui.themeVariablesOmarchyRosePineDark),
  omarchySolitude(
      'omarchy-solitude',
      'Solitude',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchySolitudeLight,
      ui.themeVariablesOmarchySolitudeDark),
  omarchyVantablack(
      'omarchy-vantablack',
      'Vantablack',
      DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyVantablackLight,
      ui.themeVariablesOmarchyVantablackDark),
  omarchyWhite('omarchy-white', 'White', DesignThemeGroup.omarchy,
      ui.themeVariablesOmarchyWhiteLight, ui.themeVariablesOmarchyWhiteDark);

  const DesignThemeFamily(
      this.id, this.label, this.group, this._light, this._dark);

  /// The value persisted in `appearance.theme` — the kit's own theme name
  /// without its `-light` / `-dark` suffix.
  final String id;

  /// What 设置 shows. A proper noun, so it is not translated — the palettes
  /// are named the same in every locale, the way a typeface is.
  final String label;

  final DesignThemeGroup group;

  final ui.ThemeVariables _light;
  final ui.ThemeVariables _dark;

  static DesignThemeFamily fromId(String id) => DesignThemeFamily.values
      .firstWhere((family) => family.id == id, orElse: () => bright);

  /// This family's palette at a brightness.
  AppThemeName themeFor(Brightness brightness) =>
      AppThemeName(this, brightness);

  /// The kit's token set for this family at a brightness.
  ui.ThemeVariables varsFor(Brightness brightness) =>
      brightness == Brightness.dark ? _dark : _light;
}

/// One of the kit's palettes: a family under a brightness.
///
/// The kit hands out its themes as token sets rather than as an enum, but
/// the product layer has tokens that vary by palette (see [ProductTokens]),
/// so the app keeps the name around and carries it on the theme it publishes.
/// A value rather than an enum since the families came to number in the
/// dozens; the kit's own twelve keep their names as constants.
@immutable
class AppThemeName {
  const AppThemeName(this.family, this.brightness);

  static const studioLight =
      AppThemeName(DesignThemeFamily.studio, Brightness.light);
  static const studioDark =
      AppThemeName(DesignThemeFamily.studio, Brightness.dark);
  static const brightLight =
      AppThemeName(DesignThemeFamily.bright, Brightness.light);
  static const brightDark =
      AppThemeName(DesignThemeFamily.bright, Brightness.dark);
  static const frostLight =
      AppThemeName(DesignThemeFamily.frost, Brightness.light);
  static const frostDark =
      AppThemeName(DesignThemeFamily.frost, Brightness.dark);
  static const graphiteLight =
      AppThemeName(DesignThemeFamily.graphite, Brightness.light);
  static const graphiteDark =
      AppThemeName(DesignThemeFamily.graphite, Brightness.dark);
  static const emberLight =
      AppThemeName(DesignThemeFamily.ember, Brightness.light);
  static const emberDark =
      AppThemeName(DesignThemeFamily.ember, Brightness.dark);
  static const nocturneLight =
      AppThemeName(DesignThemeFamily.nocturne, Brightness.light);
  static const nocturneDark =
      AppThemeName(DesignThemeFamily.nocturne, Brightness.dark);

  /// Every palette, family by family, light before dark.
  static final List<AppThemeName> values = List.unmodifiable([
    for (final family in DesignThemeFamily.values)
      for (final brightness in const [Brightness.light, Brightness.dark])
        AppThemeName(family, brightness),
  ]);

  final DesignThemeFamily family;
  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;

  /// The kit's name for this palette — `studio-light`, `omarchy-nord-dark`.
  String get name => '${family.id}-${brightness.name}';

  @override
  bool operator ==(Object other) =>
      other is AppThemeName &&
      other.family == family &&
      other.brightness == brightness;

  @override
  int get hashCode => Object.hash(family, brightness);

  @override
  String toString() => 'AppThemeName($name)';
}

/// The kit's token set for a palette, in the app's own faces.
///
/// Everything visual comes from `beyondtranslate_ui`; this names which of its
/// themes a family and brightness map to, and re-points the two type faces it
/// carries. The kit names Apple faces and leaves the family slot empty, which
/// is right on a Mac and resolves to whatever the engine defaults to
/// everywhere else — Segoe UI with an Apple fallback list behind it on
/// Windows, so a kit label falls back to a Chinese face that is not installed.
/// Pointing `fontUi` and `fontDisplay` at the app's own stacks puts the kit's
/// widgets in the same type as the product's, on every platform.
ui.ThemeData designThemeFor(AppThemeName name) {
  final ui.ThemeVariables vars = name.family.varsFor(name.brightness);
  return ui.ThemeData(
    vars: vars.copyWith(
      fontUi: ProductFonts.ui,
      fontDisplay: ProductFonts.display,
    ),
    brightness: name.brightness,
  );
}

/// Scopes a palette to a subtree and establishes the root defaults below it:
/// the body face, the primary foreground colour, and the product's own tokens.
///
/// This is the only thing that carries them. The kit left material behind, so
/// its [ui.ThemeData] is not something a Material theme can hold — and the app
/// has no Material theme to hold it in any case. A subtree with no
/// [AppThemeProvider] over it falls back to Studio Light rather than to
/// whatever the window is set to, so every window wraps its router in one,
/// above the navigator, which is what puts a dialog or a menu in the overlay
/// inside it too.
class AppThemeProvider extends StatelessWidget {
  const AppThemeProvider({
    super.key,
    this.theme = AppThemeName.studioLight,
    this.data,
    required this.child,
  });

  /// The palette to scope, ignored when [data] is given.
  final AppThemeName theme;

  /// A token set to scope directly, for a subtree that varies from its parent.
  final ui.ThemeData? data;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ui.ThemeData resolved = data ?? designThemeFor(theme);
    final ui.ThemeVariables vars = resolved.vars;

    return ui.Theme(
      data: resolved,
      child: ProductScope(
        tokens:
            ProductTokens.forTheme(data == null ? theme : _nameOf(resolved)),
        child: DefaultTextStyle(
          style: vars.sansStyle(color: vars.colorContent),
          child: IconTheme(
            data: IconThemeData(color: vars.colorContent),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Which palette a token set came from.
///
/// A subtree given a [ui.ThemeData] directly still needs the product tokens
/// that go with it, and the only thing the kit's theme carries is its
/// variables — so the name is recovered by matching them.
AppThemeName _nameOf(ui.ThemeData data) => AppThemeName.values.firstWhere(
      (name) => designThemeFor(name).vars == data.vars,
      orElse: () => AppThemeName.studioLight,
    );

/// Carries [ProductTokens] down the tree.
///
/// They used to ride on Material's theme as an extension. With material gone
/// they need a scope of their own, which [AppThemeProvider] installs beside
/// the kit's.
class ProductScope extends InheritedWidget {
  const ProductScope({super.key, required this.tokens, required super.child});

  final ProductTokens tokens;

  static ProductTokens of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProductScope>()?.tokens ??
      const ProductTokens();

  @override
  bool updateShouldNotify(ProductScope oldWidget) => tokens != oldWidget.tokens;
}

/// Light, dark, or whatever the OS is set to.
///
/// `MaterialApp` used to resolve this from its `themeMode`; with the shell on
/// `WidgetsApp` the app resolves it, which is a `MediaQuery` lookup and the
/// stored preference.
enum AppThemeMode {
  light('light'),
  dark('dark'),
  system('system');

  const AppThemeMode(this.id);

  /// The value persisted in `appearance.themeMode`.
  final String id;

  static AppThemeMode fromId(String id) => AppThemeMode.values
      .firstWhere((mode) => mode.id == id, orElse: () => system);

  Brightness resolve(BuildContext context) => switch (this) {
        AppThemeMode.light => Brightness.light,
        AppThemeMode.dark => Brightness.dark,
        AppThemeMode.system => MediaQuery.platformBrightnessOf(context),
      };
}
