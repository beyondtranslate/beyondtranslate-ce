import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

import '../painting/widget_property.dart';
import '../theme/theme.dart';

/// Overrides the default properties values for descendant [Badge] widgets.
///
/// Descendant widgets obtain the current [BadgeThemeData] object
/// using [BadgeTheme.of]. Instances of [BadgeThemeData] can
/// be customized with [BadgeThemeData.copyWith].
///
/// Typically a [BadgeThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.badgeTheme].
///
/// All [BadgeThemeData] properties are `null` by default.
/// When null, the [Badge] will use the values from [ThemeData]
/// if they exist, otherwise it will provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class BadgeThemeData extends ThemeExtension<BadgeThemeData>
    with Diagnosticable {
  /// Creates the set of color, style, and size properties used to configure [Badge].
  const BadgeThemeData({
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
  BadgeThemeData copyWith({
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
    return BadgeThemeData(
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

  /// Merges the given [other] [BadgeThemeData] with this [BadgeThemeData].
  BadgeThemeData merge(BadgeThemeData? other) {
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

  /// Linearly interpolates between this [BadgeThemeData] and another.
  @override
  BadgeThemeData lerp(
    covariant ThemeExtension<BadgeThemeData>? other,
    double t,
  ) {
    if (other is! BadgeThemeData) return this;
    return BadgeThemeData(
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
    return other is BadgeThemeData &&
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
/// parameters for [Badge]s in this widget's subtree.
///
/// Values specified here override the defaults for [Badge] properties which
/// are not given an explicit non-null value.
class BadgeTheme extends InheritedTheme {
  /// Creates a theme that overrides the default properties for [Badge]s
  /// in this widget's subtree.
  const BadgeTheme({super.key, required this.data, required super.child});

  /// Specifies the default property overrides for descendant [Badge] widgets.
  final BadgeThemeData data;

  /// Retrieves the [BadgeThemeData] from the closest ancestor [BadgeTheme].
  ///
  /// If there is no enclosing [BadgeTheme] widget, then
  /// [ThemeData.badgeTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// BadgeThemeData theme = BadgeTheme.of(context);
  /// ```
  static BadgeThemeData of(BuildContext context) {
    final BadgeTheme? badgeTheme = context
        .dependOnInheritedWidgetOfExactType<BadgeTheme>();
    return badgeTheme?.data ?? context.themeData.badgeTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return BadgeTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(BadgeTheme oldWidget) => data != oldWidget.data;
}
