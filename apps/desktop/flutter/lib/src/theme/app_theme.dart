import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/ui.dart' as ui;
import 'product_tokens.dart'
    show ProductFonts, ProductPalette, ProductTokens, ProductTypography;

/// The palette family the design system paints with.
///
/// Each family carries its own light and dark pair, so this is orthogonal to
/// [Brightness]: the family picks the character, the brightness picks the pair.
enum DesignThemeFamily {
  /// Muted violet on near-white / near-black — the default.
  studio('studio'),

  /// Higher-contrast palette with a separate highlight hue.
  bright('bright');

  const DesignThemeFamily(this.id);

  /// The value persisted in `appearance.theme`.
  final String id;

  static DesignThemeFamily fromId(String id) => DesignThemeFamily.values
      .firstWhere((family) => family.id == id, orElse: () => bright);

  AppThemeName themeFor(Brightness brightness) => switch (this) {
        DesignThemeFamily.studio => brightness == Brightness.dark
            ? AppThemeName.studioDark
            : AppThemeName.studioLight,
        DesignThemeFamily.bright => brightness == Brightness.dark
            ? AppThemeName.brightDark
            : AppThemeName.brightLight,
      };
}

/// One of the kit's four palettes, named.
///
/// The kit itself hands out its themes as constructors rather than as an enum,
/// but the product layer has tokens that vary by palette (see
/// [ProductTokens]), so the app keeps the name around and carries it on the
/// theme it publishes.
enum AppThemeName {
  studioLight,
  studioDark,
  brightLight,
  brightDark;

  bool get isDark =>
      this == AppThemeName.studioDark || this == AppThemeName.brightDark;
}

/// The glyphs the kit reaches for on its own — the app draws with Fluent
/// throughout, so the kit's chevrons come from the same set as everything else.
final ui.IconLibrary _iconLibrary = const ui.IconLibrary(
  chevronLeft: FluentIcons.chevron_left_20_regular,
  chevronRight: FluentIcons.chevron_right_20_regular,
);

/// The kit's token set for a palette.
///
/// Everything visual in the app comes from `beyondtranslate_ui`; this only
/// names which of its four themes a [Brightness] and family map to.
ui.ThemeData designThemeFor(AppThemeName name) => switch (name) {
      AppThemeName.studioLight => ui.ThemeData.studioLight(
          iconLibrary: _iconLibrary,
        ),
      AppThemeName.studioDark => ui.ThemeData.studioDark(
          iconLibrary: _iconLibrary,
        ),
      AppThemeName.brightLight => ui.ThemeData.brightLight(
          iconLibrary: _iconLibrary,
        ),
      AppThemeName.brightDark => ui.ThemeData.brightDark(
          iconLibrary: _iconLibrary,
        ),
    };

/// Scopes a palette to a subtree and establishes the root defaults the kit's
/// widgets inherit: the body face and the primary foreground colour.
///
/// The kit reads its tokens from either its own [ui.Theme] or a Material theme
/// extension, and the app publishes both — Material so [Scaffold] and friends
/// paint from the same palette, the kit's own so a subtree can re-scope tokens
/// without rebuilding a Material theme.
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
      child: DefaultTextStyle(
        style: vars.sansStyle(color: vars.colorContent),
        child: IconTheme(
          data: IconThemeData(color: vars.colorContent),
          child: child,
        ),
      ),
    );
  }
}

/// Projects the kit's tokens onto Material's [ThemeData].
///
/// The app still hosts its pages in a `MaterialApp`, so the Material widgets it
/// leans on — [Scaffold], [InkWell], dialogs, the default text styles — need to
/// read the same palette the kit's widgets paint themselves with. This is that
/// bridge, and the only place Material colours are decided. It also carries the
/// kit's [ui.ThemeData] and the product's [ProductTokens] as theme extensions,
/// which is how `context.vars` and `context.product` reach a widget that sits
/// under no closer scope.
ThemeData appThemeData(AppThemeName name) {
  final ui.ThemeData design = designThemeFor(name);
  final ui.ThemeVariables vars = design.vars;
  final bool isDark = name.isDark;

  TextStyle text(double size, [FontWeight? weight, Color? color]) =>
      vars.sansStyle(
        fontSize: size,
        fontWeight: weight,
        color: color ?? vars.colorContent,
      );

  return ThemeData(
    brightness: design.brightness,
    extensions: <ThemeExtension<dynamic>>[
      design,
      ProductTokens.forTheme(name),
    ],
    colorScheme: ColorScheme(
      brightness: design.brightness,
      primary: vars.accent,
      onPrimary: vars.colorOnAccent,
      secondary: vars.highlight,
      onSecondary: vars.colorOnAccent,
      error: vars.danger,
      onError: vars.colorOnAccent,
      surface: vars.colorSurface,
      onSurface: vars.colorContent,
      surfaceContainerHighest: vars.colorSurfaceMuted,
      onSurfaceVariant: vars.colorContentSubtle,
      outline: vars.colorBorderStrong,
      outlineVariant: vars.colorBorder,
      shadow: const Color(0xFF000000),
    ),
    primaryColor: vars.accent,
    canvasColor: vars.colorSurfaceMuted,
    scaffoldBackgroundColor: vars.colorSurface,
    dividerColor: vars.colorBorder,
    disabledColor: vars.colorContentFaint,
    fontFamily: ProductFonts.sansFamily,
    fontFamilyFallback: ProductFonts.sansFallback,
    iconTheme: IconThemeData(color: vars.colorContent),
    dividerTheme: DividerThemeData(
      color: vars.colorBorder,
      space: 1,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: vars.colorSurfaceRaised,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(vars.framePopoverRadius),
        side: BorderSide(color: vars.colorBorderStrong),
      ),
      titleTextStyle: text(13, FontWeight.w600),
      contentTextStyle: text(13),
    ),
    textTheme: TextTheme(
      titleLarge: text(17, FontWeight.w600),
      titleMedium: text(15, FontWeight.w600),
      titleSmall: text(13, FontWeight.w600),
      bodyLarge: text(15),
      bodyMedium: text(13),
      bodySmall: text(11, null, vars.colorContentSubtle),
      labelLarge: text(13),
      labelMedium: text(12),
      labelSmall: text(10, null, vars.colorContentSubtle),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      backgroundColor: vars.colorSurfaceChrome,
      foregroundColor: vars.colorContent,
      elevation: 0,
      iconTheme: IconThemeData(color: vars.colorContent, size: 20),
      actionsIconTheme: IconThemeData(color: vars.colorContent, size: 20),
      titleTextStyle: text(13, FontWeight.w600),
    ),
  );
}
