import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/ui.dart'
    show
        DesignFont,
        DesignThemeName,
        DesignTokens,
        DesignTypography,
        DesignTypographyStyles;

const _windowsTypography = DesignTypography(
  display: DesignFont(
    family: 'Segoe UI',
    fallback: ['Microsoft YaHei UI', 'Microsoft YaHei'],
  ),
  sans: DesignFont(
    family: 'Segoe UI',
    fallback: ['Microsoft YaHei UI', 'Microsoft YaHei'],
  ),
  cjk: DesignFont(
    family: 'Microsoft YaHei UI',
    fallback: ['Microsoft YaHei', 'Segoe UI'],
  ),
  label: DesignFont(
    family: 'Segoe UI',
    fallback: ['Microsoft YaHei UI', 'Microsoft YaHei'],
  ),
  mono: DesignFont(
    family: 'Roboto Mono',
    fallback: ['Cascadia Mono', 'Consolas'],
  ),
);

const _linuxTypography = DesignTypography(
  display: DesignFont(
    family: 'Noto Sans',
    fallback: ['Noto Sans CJK SC', 'Noto Sans CJK TC'],
  ),
  sans: DesignFont(
    family: 'Noto Sans',
    fallback: ['Noto Sans CJK SC', 'Noto Sans CJK TC'],
  ),
  cjk: DesignFont(
    family: 'Noto Sans CJK SC',
    fallback: ['Noto Sans CJK TC', 'Noto Sans', 'Droid Sans Fallback'],
  ),
  label: DesignFont(
    family: 'Noto Sans',
    fallback: ['Noto Sans CJK SC', 'Noto Sans CJK TC'],
  ),
  mono: DesignFont(
    family: 'Noto Sans Mono',
    fallback: [
      'Noto Sans Mono CJK SC',
      'DejaVu Sans Mono',
      'monospace',
    ],
  ),
);

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

  DesignThemeName themeFor(Brightness brightness) => switch (this) {
        DesignThemeFamily.studio => brightness == Brightness.dark
            ? DesignThemeName.studioDark
            : DesignThemeName.studioLight,
        DesignThemeFamily.bright => brightness == Brightness.dark
            ? DesignThemeName.brightDark
            : DesignThemeName.brightLight,
      };
}

/// The design tokens behind a family / brightness pair.
///
/// Everything visual in the app comes from `beyondtranslate_ui`; this only
/// picks which token set a Material [Brightness] maps to.
DesignTokens tokensFor(
  Brightness brightness, {
  DesignThemeFamily family = DesignThemeFamily.bright,
}) {
  final tokens = family.themeFor(brightness).tokens;

  // Apply platform-native font stacks for the best rendering on each OS.
  if (defaultTargetPlatform == TargetPlatform.windows) {
    return tokens.copyWith(typography: _windowsTypography);
  }
  if (defaultTargetPlatform == TargetPlatform.linux) {
    return tokens.copyWith(typography: _linuxTypography);
  }

  // macOS and other platforms use the design-system default (AppKit faces).
  return tokens;
}

/// Projects a design token set onto Material's [ThemeData].
///
/// The app still hosts its pages in a `MaterialApp`, so the Material widgets it
/// leans on — [Scaffold], [InkWell], dialogs, the default text styles — need to
/// read the same palette the `ui` widgets paint themselves with. This is that
/// bridge, and the only place Material colours are decided.
ThemeData appThemeData(DesignTokens tokens) {
  final colors = tokens.colors;
  final typography = tokens.typography;
  final isDark = tokens.brightness == Brightness.dark;

  TextStyle text(double size, [FontWeight? weight, Color? color]) => typography
      .sansStyle(fontSize: size, fontWeight: weight, color: color ?? colors.fg);

  return ThemeData(
    brightness: tokens.brightness,
    colorScheme: ColorScheme(
      brightness: tokens.brightness,
      primary: colors.accent,
      onPrimary: colors.onAccent,
      secondary: colors.highlight,
      onSecondary: colors.onAccent,
      error: colors.danger,
      onError: colors.onAccent,
      surface: colors.window,
      onSurface: colors.fg,
      surfaceContainerHighest: colors.card,
      onSurfaceVariant: colors.fgSubtle,
      outline: colors.hairlineStrong,
      outlineVariant: colors.hairline,
      shadow: const Color(0xFF000000),
    ),
    primaryColor: colors.accent,
    canvasColor: colors.card,
    scaffoldBackgroundColor: colors.window,
    dividerColor: colors.hairline,
    disabledColor: colors.fgFaint,
    fontFamily: typography.sans.family,
    fontFamilyFallback: typography.sans.fallback,
    iconTheme: IconThemeData(color: colors.fg),
    dividerTheme: DividerThemeData(
      color: colors.hairline,
      space: 1,
      thickness: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.panel,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radii.popover),
        side: BorderSide(color: colors.hairlineStrong),
      ),
      titleTextStyle: text(typography.body, FontWeight.w600),
      contentTextStyle: text(typography.body),
    ),
    textTheme: TextTheme(
      titleLarge: text(typography.title, FontWeight.w600),
      titleMedium: text(typography.emphasis, FontWeight.w600),
      titleSmall: text(typography.body, FontWeight.w600),
      bodyLarge: text(typography.emphasis),
      bodyMedium: text(typography.body),
      bodySmall: text(typography.caption, null, colors.fgSubtle),
      labelLarge: text(typography.body),
      labelMedium: text(typography.small),
      labelSmall: text(10, null, colors.fgSubtle),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      backgroundColor: colors.chrome,
      foregroundColor: colors.fg,
      elevation: 0,
      iconTheme: IconThemeData(color: colors.fg, size: 20),
      actionsIconTheme: IconThemeData(color: colors.fg, size: 20),
      titleTextStyle: text(typography.body, FontWeight.w600),
    ),
  );
}
