import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

import '../painting/widget_property.dart';
import '../theme/theme.dart';

/// Overrides the default properties values for descendant [KeyCap] widgets.
///
/// Descendant widgets obtain the current [KeyCapThemeData] object
/// using [KeyCapTheme.of]. Instances of [KeyCapThemeData] can
/// be customized with [KeyCapThemeData.copyWith].
///
/// Typically a [KeyCapThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.keyCapTheme].
///
/// All [KeyCapThemeData] properties are `null` by default.
/// When null, the [KeyCap] will use the values from [ThemeData]
/// if they exist, otherwise it will provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class KeyCapThemeData extends ThemeExtension<KeyCapThemeData>
    with Diagnosticable {
  /// Creates the set of color, style, and size properties used to configure [KeyCap].
  const KeyCapThemeData({
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.labelStyle,
  });

  /// Overrides the default value for [KeyCap.textColor].
  final Color? textColor;

  /// Overrides the default value for [KeyCap.smallSize].
  final double? smallSize;

  /// Overrides the default value for [KeyCap.largeSize].
  final double? largeSize;

  /// Overrides the default value for [KeyCap.textStyle].
  final TextStyle? textStyle;

  /// Overrides the default value for [KeyCap.padding].
  final SizedWidgetProperty<EdgeInsetsGeometry>? padding;

  /// Overrides the key's type face.
  final SizedWidgetProperty<TextStyle>? labelStyle;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  KeyCapThemeData copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? smallSize,
    double? largeSize,
    TextStyle? textStyle,
    SizedWidgetProperty<EdgeInsetsGeometry>? padding,
    SizedWidgetProperty<TextStyle>? labelStyle,
  }) {
    return KeyCapThemeData(
      textColor: textColor ?? this.textColor,
      smallSize: smallSize ?? this.smallSize,
      largeSize: largeSize ?? this.largeSize,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }

  /// Linearly interpolates between this [KeyCapThemeData] and another.
  @override
  KeyCapThemeData lerp(
    covariant ThemeExtension<KeyCapThemeData>? other,
    double t,
  ) {
    if (other is! KeyCapThemeData) return this;
    return KeyCapThemeData(
      textColor: Color.lerp(textColor, other.textColor, t),
      smallSize: lerpDouble(smallSize, other.smallSize, t),
      largeSize: lerpDouble(largeSize, other.largeSize, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      padding: t < 0.5 ? padding : other.padding,
      labelStyle: t < 0.5 ? labelStyle : other.labelStyle,
    );
  }

  @override
  int get hashCode => Object.hash(
    textColor,
    smallSize,
    largeSize,
    textStyle,
    padding,
    labelStyle,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is KeyCapThemeData &&
        other.textColor == textColor &&
        other.smallSize == smallSize &&
        other.largeSize == largeSize &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.labelStyle == labelStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('textColor', textColor, defaultValue: null));
    properties.add(DoubleProperty('smallSize', smallSize, defaultValue: null));
    properties.add(DoubleProperty('largeSize', largeSize, defaultValue: null));
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'textStyle',
        textStyle,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SizedWidgetProperty<EdgeInsetsGeometry>>(
        'padding',
        padding,
        defaultValue: null,
      ),
    );
  }
}

/// An inherited widget that overrides the default color style, and size
/// parameters for [KeyCap]s in this widget's subtree.
///
/// Values specified here override the defaults for [KeyCap] properties which
/// are not given an explicit non-null value.
class KeyCapTheme extends InheritedTheme {
  /// Creates a theme that overrides the default properties for [KeyCap]s
  /// in this widget's subtree.
  const KeyCapTheme({super.key, required this.data, required super.child});

  /// Specifies the default property overrides for descendant [KeyCap] widgets.
  final KeyCapThemeData data;

  /// Retrieves the [KeyCapThemeData] from the closest ancestor [KeyCapTheme].
  ///
  /// If there is no enclosing [KeyCapTheme] widget, then
  /// [ThemeData.keyCapTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// KeyCapThemeData theme = KeyCapTheme.of(context);
  /// ```
  static KeyCapThemeData of(BuildContext context) {
    final KeyCapTheme? keyCapTheme = context
        .dependOnInheritedWidgetOfExactType<KeyCapTheme>();
    return keyCapTheme?.data ?? context.themeData.keyCapTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return KeyCapTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(KeyCapTheme oldWidget) => data != oldWidget.data;
}
