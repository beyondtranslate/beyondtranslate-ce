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

/// Scopes a theme to a subtree and establishes the `.bt-root` defaults: the
/// sans face and the primary foreground colour.
class DesignThemeProvider extends StatelessWidget {
  const DesignThemeProvider({
    super.key,
    this.theme = DesignThemeName.studioLight,
    this.tokens,
    required this.child,
  });

  /// Named theme to apply. Ignored when [tokens] is given.
  final DesignThemeName theme;

  /// An explicit token set, for consumers that customise the palette.
  final DesignTokens? tokens;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolved = tokens ?? theme.tokens;
    return DesignTheme(
      tokens: resolved,
      child: DefaultTextStyle(
        style: resolved.typography.sansStyle(
          fontSize: resolved.typography.body,
          color: resolved.colors.fg,
        ),
        child: child,
      ),
    );
  }
}

/// Convenience accessors, mirroring how the React components reach for a token.
extension DesignThemeContext on BuildContext {
  DesignTokens get tokens => DesignTheme.of(this);

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
