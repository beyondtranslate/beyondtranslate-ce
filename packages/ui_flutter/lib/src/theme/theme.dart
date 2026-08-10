import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/themes.dart';
import 'package:beyondtranslate_ui/src/theme/tokens.dart';
import 'package:flutter/widgets.dart';

/// Carries the active [DesignTokens] down the tree.
///
/// Theming is a token swap, so providers can be nested or placed side by side —
/// useful for showing two rounds on one page, exactly like the React package's
/// `data-theme` attribute.
class DesignTheme extends InheritedWidget {
  const DesignTheme({super.key, required this.tokens, required super.child});

  final DesignTokens tokens;

  /// The tokens the current subtree is rendered under, falling back to Studio
  /// Light so a widget dropped into a bare app still paints correctly.
  static DesignTokens of(BuildContext context) =>
      maybeOf(context) ?? DesignThemes.studioLight;

  static DesignTokens? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DesignTheme>()?.tokens;

  @override
  bool updateShouldNotify(DesignTheme oldWidget) => tokens != oldWidget.tokens;
}

/// Which of the four palettes a subtree is rendered under.
///
/// Deliberately separate from [DesignTheme]: widgets re-scope *tokens* fairly
/// often — the menu and select overlays carry them across into the app's
/// overlay, [WindowFrame] swaps the selection pair — and none of those change
/// which theme is active. React draws the same line, where a nested element may
/// override CSS variables while `data-theme` stays on the provider and
/// `useTheme()` walks past to find it.
///
/// The product layer needs this because it has tokens of its own that vary by
/// theme (see the app's `product_tokens.dart`).
class DesignThemeScope extends InheritedWidget {
  const DesignThemeScope({super.key, required this.name, required super.child});

  final DesignThemeName name;

  /// The active theme, Studio Light outside any provider.
  static DesignThemeName of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DesignThemeScope>()?.name ??
      DesignThemeName.studioLight;

  @override
  bool updateShouldNotify(DesignThemeScope oldWidget) => name != oldWidget.name;
}

/// Scopes a theme to a subtree and establishes the `.theme-root` defaults: the
/// sans face and the primary foreground colour.
class DesignThemeProvider extends StatelessWidget {
  const DesignThemeProvider({
    super.key,
    this.theme = DesignThemeName.studioLight,
    this.tokens,
    required this.child,
  });

  /// Which palette is active. Still the subtree's identity when [tokens]
  /// overrides the values, the way `data-theme` stays on the element no matter
  /// what a consumer's own CSS does to the variables under it.
  final DesignThemeName theme;

  /// An explicit token set, for consumers that customise the palette.
  final DesignTokens? tokens;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolved = tokens ?? theme.tokens;
    return DesignThemeScope(
      name: theme,
      child: DesignTheme(
        tokens: resolved,
        child: DefaultTextStyle(
          style: resolved.typography.sansStyle(
            fontSize: resolved.typography.body,
            color: resolved.colors.fg,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Convenience accessors, mirroring how the React components reach for a token.
extension DesignThemeContext on BuildContext {
  DesignTokens get tokens => DesignTheme.of(this);

  /// The active palette — React's `useTheme().theme`.
  DesignThemeName get themeName => DesignThemeScope.of(this);

  DesignColors get colors => DesignTheme.of(this).colors;

  DesignRadii get radii => DesignTheme.of(this).radii;

  DesignMetrics get metrics => DesignTheme.of(this).metrics;

  DesignTypography get typography => DesignTheme.of(this).typography;

  DesignShadows get shadows => DesignTheme.of(this).shadows;

  /// A separator is one *device* pixel. At 1x that is a 1px border; on Retina
  /// a 1px logical border is twice as heavy as the real thing, so it halves.
  double get hairlineWidth =>
      (MediaQuery.maybeDevicePixelRatioOf(this) ?? 1.0) >= 2 ? 0.5 : 1.0;
}
