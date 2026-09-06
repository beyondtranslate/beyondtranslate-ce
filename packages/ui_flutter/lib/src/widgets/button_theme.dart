import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

import '../painting/widget_property.dart';
import '../theme/theme.dart';

/// Overrides the default properties values for descendant [Button] widgets.
///
/// Descendant widgets obtain the current [ButtonThemeData] object
/// using [ButtonTheme.of]. Instances of [ButtonThemeData] can
/// be customized with [ButtonThemeData.copyWith].
///
/// Typically a [ButtonThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.buttonTheme].
///
/// All [ButtonThemeData] properties are `null` by default.
/// When null, the [Button] will use the values from [ThemeData]
/// if they exist, otherwise it will provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class ButtonThemeData extends ThemeExtension<ButtonThemeData>
    with Diagnosticable {
  /// Creates the set of color, style, and size properties used to configure [Button].
  const ButtonThemeData({
    this.color,
    this.minSize,
    this.margin,
    this.padding,
    this.surfaceColor,
    this.contentColor,
    this.borderColor,
    this.borderRadius,
    this.labelStyle,
  });

  final WidgetProperty<ColorSwatch<int>>? color;

  final WidgetProperty<Size>? minSize;

  final WidgetProperty<EdgeInsets>? margin;

  final WidgetProperty<EdgeInsets>? padding;

  final WidgetProperty<Color>? surfaceColor;

  final WidgetProperty<Color>? contentColor;

  final WidgetProperty<Color>? borderColor;

  final WidgetProperty<BorderRadius>? borderRadius;

  final WidgetProperty<TextStyle>? labelStyle;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  ButtonThemeData copyWith({
    WidgetProperty<ColorSwatch<int>>? color,
    WidgetProperty<Size>? minSize,
    WidgetProperty<EdgeInsets>? margin,
    WidgetProperty<EdgeInsets>? padding,
    WidgetProperty<Color>? surfaceColor,
    WidgetProperty<Color>? contentColor,
    WidgetProperty<Color>? borderColor,
    WidgetProperty<BorderRadius>? borderRadius,
    WidgetProperty<TextStyle>? labelStyle,
  }) {
    return ButtonThemeData(
      color: color ?? this.color,
      minSize: minSize ?? this.minSize,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      contentColor: contentColor ?? this.contentColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }

  /// Merges the given [other] [ButtonThemeData] with this [ButtonThemeData].
  ButtonThemeData merge(ButtonThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      color: color ?? other.color,
      minSize: minSize ?? other.minSize,
      margin: margin ?? other.margin,
      padding: padding ?? other.padding,
      surfaceColor: surfaceColor ?? other.surfaceColor,
      contentColor: contentColor ?? other.contentColor,
      borderColor: borderColor ?? other.borderColor,
      borderRadius: borderRadius ?? other.borderRadius,
      labelStyle: labelStyle ?? other.labelStyle,
    );
  }

  /// Linearly interpolates between this [ButtonThemeData] and another.
  @override
  ButtonThemeData lerp(
    covariant ThemeExtension<ButtonThemeData>? other,
    double t,
  ) {
    if (other is! ButtonThemeData) return this;
    return ButtonThemeData(
      color: t < 0.5 ? color : other.color,
      minSize: t < 0.5 ? minSize : other.minSize,
      margin: t < 0.5 ? margin : other.margin,
      padding: t < 0.5 ? padding : other.padding,
      surfaceColor: t < 0.5 ? surfaceColor : other.surfaceColor,
      contentColor: t < 0.5 ? contentColor : other.contentColor,
      borderColor: t < 0.5 ? borderColor : other.borderColor,
      borderRadius: t < 0.5 ? borderRadius : other.borderRadius,
      labelStyle: t < 0.5 ? labelStyle : other.labelStyle,
    );
  }

  @override
  int get hashCode => Object.hash(
    color,
    minSize,
    margin,
    padding,
    surfaceColor,
    contentColor,
    borderColor,
    borderRadius,
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
    return other is ButtonThemeData &&
        other.color == color &&
        other.minSize == minSize &&
        other.margin == margin &&
        other.padding == padding &&
        other.surfaceColor == surfaceColor &&
        other.contentColor == contentColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.labelStyle == labelStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<WidgetProperty<ColorSwatch<int>>>(
        'color',
        color,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<Size>>(
        'minSize',
        minSize,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<EdgeInsetsGeometry>>(
        'margin',
        margin,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<EdgeInsetsGeometry>>(
        'padding',
        padding,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<Color>>(
        'surfaceColor',
        surfaceColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<Color>>(
        'contentColor',
        contentColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<Color>>(
        'borderColor',
        borderColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<BorderRadius>>(
        'borderRadius',
        borderRadius,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<TextStyle>>(
        'labelStyle',
        labelStyle,
        defaultValue: null,
      ),
    );
  }
}

/// An inherited widget that overrides the default color style, and size
/// parameters for [Button]s in this widget's subtree.
///
/// Values specified here override the defaults for [Button] properties which
/// are not given an explicit non-null value.
class ButtonTheme extends InheritedTheme {
  /// Creates a theme that overrides the default properties for [Button]s
  /// in this widget's subtree.
  const ButtonTheme({super.key, required this.data, required super.child});

  /// Specifies the default property overrides for descendant [Button] widgets.
  final ButtonThemeData data;

  /// Retrieves the [ButtonThemeData] from the closest ancestor [ButtonTheme].
  ///
  /// If there is no enclosing [ButtonTheme] widget, then
  /// [ThemeData.buttonTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ButtonThemeData theme = ButtonTheme.of(context);
  /// ```
  static ButtonThemeData of(BuildContext context) {
    final ButtonTheme? buttonTheme = context
        .dependOnInheritedWidgetOfExactType<ButtonTheme>();
    return buttonTheme?.data ?? context.themeData.buttonTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ButtonTheme oldWidget) => data != oldWidget.data;
}
