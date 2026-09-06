// ignore_for_file: annotate_overrides

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../painting/varianted_widget_state_color.dart';
import '../painting/widget_property.dart';
import '../widgets/badge_theme.dart';
import '../widgets/button_theme.dart';
import '../widgets/callout_theme.dart';
import '../widgets/card_theme.dart';
import '../widgets/checkbox_theme.dart';
import '../widgets/key_cap_theme.dart';
import 'icon_library.dart';

export 'icon_library.dart';

/// A theme data.
class ThemeData extends ThemeExtension<ThemeData> with DiagnosticableTreeMixin {
  /// Studio Light — the baseline every other theme is written against.
  static ThemeData studioLight({
    IconLibrary? iconLibrary,
  }) {
    return ThemeData(
      vars: themeVariables,
      iconLibrary: iconLibrary ?? IconLibrary.material(),
      brightness: Brightness.light,
    );
  }

  /// Studio Dark — the same skeleton over a near-black canvas.
  static ThemeData studioDark({
    IconLibrary? iconLibrary,
  }) {
    return ThemeData(
      vars: themeVariablesStudioDark,
      iconLibrary: iconLibrary ?? IconLibrary.material(),
      brightness: Brightness.dark,
    );
  }

  /// Bright Light — warm paper, ink navy, acid green marker.
  static ThemeData brightLight({
    IconLibrary? iconLibrary,
  }) {
    return ThemeData(
      vars: themeVariablesBrightLight,
      iconLibrary: iconLibrary ?? IconLibrary.material(),
      brightness: Brightness.light,
    );
  }

  /// Bright Dark — the same pair with the roles swapped.
  static ThemeData brightDark({
    IconLibrary? iconLibrary,
  }) {
    return ThemeData(
      vars: themeVariablesBrightDark,
      iconLibrary: iconLibrary ?? IconLibrary.material(),
      brightness: Brightness.dark,
    );
  }

  /// Creates a dark theme — Studio Dark under its older name.
  static ThemeData dark({
    IconLibrary? iconLibrary,
  }) {
    return studioDark(iconLibrary: iconLibrary);
  }

  /// Creates a light theme — Studio Light under its older name.
  static ThemeData light({
    IconLibrary? iconLibrary,
  }) {
    return studioLight(iconLibrary: iconLibrary);
  }

  const ThemeData({
    this.vars = themeVariables,
    required this.brightness,
    required this.iconLibrary,
    this.badgeTheme = const BadgeThemeData(),
    this.buttonTheme = const ButtonThemeData(),
    this.calloutTheme = const CalloutThemeData(),
    this.cardTheme = const CardThemeData(),
    this.checkboxTheme = const CheckboxThemeData(),
    this.keyCapTheme = const KeyCapThemeData(),
  });

  /// The variables of the theme.
  final ThemeVariables vars;

  /// The brightness of the design theme.
  final Brightness brightness;

  /// The icon library of the design theme.
  final IconLibrary iconLibrary;

  /// The badge theme of the design theme.
  final BadgeThemeData badgeTheme;

  /// The button theme of the design theme.
  final ButtonThemeData buttonTheme;

  /// The callout theme of the design theme.
  final CalloutThemeData calloutTheme;

  /// The card theme of the design theme.
  final CardThemeData cardTheme;

  /// The checkbox theme of the design theme.
  final CheckboxThemeData checkboxTheme;

  /// The kbd theme of the design theme.
  final KeyCapThemeData keyCapTheme;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  ThemeData copyWith({
    ThemeVariables? vars,
    Brightness? brightness,
    IconLibrary? iconLibrary,
    BadgeThemeData? badgeTheme,
    ButtonThemeData? buttonTheme,
    CalloutThemeData? calloutTheme,
    CardThemeData? cardTheme,
    CheckboxThemeData? checkboxTheme,
    KeyCapThemeData? keyCapTheme,
  }) {
    return ThemeData(
      vars: vars ?? this.vars,
      iconLibrary: iconLibrary ?? this.iconLibrary,
      brightness: brightness ?? this.brightness,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      calloutTheme: calloutTheme ?? this.calloutTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      keyCapTheme: keyCapTheme ?? this.keyCapTheme,
    );
  }

  /// Linearly interpolates between this [ThemeData] and another.
  @override
  ThemeData lerp(
    covariant ThemeExtension<ThemeData>? other,
    double t,
  ) {
    if (other is! ThemeData) return this;
    return ThemeData(
      vars: t < 0.5 ? vars : other.vars,
      brightness: t < 0.5 ? brightness : other.brightness,
      iconLibrary: t < 0.5 ? iconLibrary : other.iconLibrary,
      badgeTheme: t < 0.5 ? badgeTheme : other.badgeTheme,
      buttonTheme: t < 0.5 ? buttonTheme : other.buttonTheme,
      calloutTheme: t < 0.5 ? calloutTheme : other.calloutTheme,
      cardTheme: t < 0.5 ? cardTheme : other.cardTheme,
      checkboxTheme: t < 0.5 ? checkboxTheme : other.checkboxTheme,
      keyCapTheme: t < 0.5 ? keyCapTheme : other.keyCapTheme,
    );
  }

  @override
  int get hashCode => Object.hash(
    vars,
    iconLibrary,
    brightness,
    badgeTheme,
    buttonTheme,
    calloutTheme,
    checkboxTheme,
    keyCapTheme,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ThemeData &&
        other.vars == vars &&
        other.iconLibrary == iconLibrary &&
        other.brightness == brightness &&
        other.badgeTheme == badgeTheme &&
        other.buttonTheme == buttonTheme &&
        other.calloutTheme == calloutTheme &&
        other.cardTheme == cardTheme &&
        other.checkboxTheme == checkboxTheme &&
        other.keyCapTheme == keyCapTheme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('brightness', brightness))
      ..add(DiagnosticsProperty('iconLibrary', iconLibrary))
      ..add(DiagnosticsProperty('badgeTheme', badgeTheme))
      ..add(DiagnosticsProperty('buttonTheme', buttonTheme))
      ..add(DiagnosticsProperty('calloutTheme', calloutTheme))
      ..add(DiagnosticsProperty('cardTheme', cardTheme))
      ..add(DiagnosticsProperty('checkboxTheme', checkboxTheme))
      ..add(DiagnosticsProperty('keyCapTheme', keyCapTheme));
  }
}

/// A extension that provides the design theme data.
extension ThemeDataBuildContextProps on BuildContext {
  /// The design theme data.
  ThemeData get themeData => Theme.of(this);

  /// The design theme's variables.
  ThemeVariables get vars => Theme.of(this).vars;

  /// A separator is one *device* pixel. At 1x that is the 1px the token
  /// holds; on Retina a 1px logical line is twice the weight of the real
  /// thing, so it halves — the same rule `ui_react`'s base.css applies with
  /// `@media (min-resolution: 2dppx)`.
  ///
  /// Drawn control outlines use `stroke.control` instead and stay put.
  double get hairlineWidth {
    final double ratio = MediaQuery.maybeDevicePixelRatioOf(this) ?? 1.0;
    return ratio >= 2 ? vars.strokeHairline / 2 : vars.strokeHairline;
  }
}

/// A inherited widget that provides the design theme data.
class Theme extends InheritedTheme {
  const Theme({
    super.key,
    required this.data,
    required super.child,
  });

  final ThemeData data;

  @override
  bool updateShouldNotify(Theme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return Theme(
      data: data,
      child: child,
    );
  }

  /// The theme the current subtree is rendered under, falling back to Studio
  /// Light so a widget dropped into a bare app still paints correctly rather
  /// than throwing on a missing extension.
  static ThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<Theme>();
    return theme?.data ??
        material.Theme.of(context).extension<ThemeData>() ??
        ThemeData.studioLight();
  }
}

extension ThemeVariablesX on ThemeVariables {
  /// The control seed color.
  WidgetProperty<ColorSwatch<int>> get controlColor {
    return TintedWidgetProperty<ColorSwatch<int>>(
      primary: colorPrimary,
      neutral: colorNeutral,
      success: colorSuccess,
      info: colorInfo,
      warning: colorWarning,
      danger: colorDanger,
    );
  }

  WidgetProperty<Color> get controlColorSurface {
    return VariantedWidgetStateColor(
      normal: controlColorNormalSurface,
      recessed: controlColorRecessedSurface,
      filled: controlColorFilledSurface,
      tinted: controlColorTintedSurface,
      outlined: controlColorOutlinedSurface,
      plain: controlColorPlainSurface,
    );
  }

  WidgetProperty<Color> get controlColorContent {
    return VariantedWidgetStateColor(
      normal: controlColorNormalContent,
      recessed: controlColorRecessedContent,
      filled: controlColorFilledContent,
      tinted: controlColorTintedContent,
      outlined: controlColorOutlinedContent,
      plain: controlColorPlainContent,
    );
  }

  WidgetProperty<Color> get controlColorBorder {
    return VariantedWidgetStateColor(
      normal: controlColorNormalBorder,
      recessed: controlColorRecessedBorder,
      filled: controlColorFilledBorder,
      tinted: controlColorTintedBorder,
      outlined: controlColorOutlinedBorder,
      plain: controlColorPlainBorder,
    );
  }
}
