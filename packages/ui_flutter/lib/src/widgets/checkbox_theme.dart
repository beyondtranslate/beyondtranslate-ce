import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

import '../painting/widget_property.dart';
import '../theme/theme.dart';

/// Overrides the default properties values for descendant [Checkbox] widgets.
///
/// Descendant widgets obtain the current [CheckboxThemeData] object
/// using [CheckboxTheme.of]. Instances of [CheckboxThemeData] can
/// be customized with [CheckboxThemeData.copyWith].
///
/// Typically a [CheckboxThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.checkboxTheme].
///
/// All [CheckboxThemeData] properties are `null` by default.
/// When null, the [Checkbox] will use the values from [ThemeData]
/// if they exist, otherwise it will provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class CheckboxThemeData extends ThemeExtension<CheckboxThemeData>
    with Diagnosticable {
  /// Creates the set of color, style, and size properties used to configure [Checkbox].
  const CheckboxThemeData({
    this.color,
    this.interactiveSize,
    this.size,
    this.margin,
    this.padding,
    this.borderColor,
    this.borderRadius,
  });

  final WidgetProperty<ColorSwatch<int>>? color;

  final WidgetProperty<Size>? interactiveSize;

  final WidgetProperty<Size>? size;

  final WidgetProperty<EdgeInsets>? margin;

  final WidgetProperty<EdgeInsets>? padding;

  final WidgetProperty<Color>? borderColor;

  final WidgetProperty<BorderRadius>? borderRadius;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  CheckboxThemeData copyWith({
    WidgetProperty<ColorSwatch<int>>? color,
    WidgetProperty<Size>? interactiveSize,
    WidgetProperty<Size>? size,
    WidgetProperty<EdgeInsets>? margin,
    WidgetProperty<EdgeInsets>? padding,
    WidgetProperty<Color>? borderColor,
    WidgetProperty<BorderRadius>? borderRadius,
  }) {
    return CheckboxThemeData(
      color: color ?? this.color,
      interactiveSize: interactiveSize ?? this.interactiveSize,
      size: size ?? this.size,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  /// Merges the given [other] [CheckboxThemeData] with this [CheckboxThemeData].
  CheckboxThemeData merge(CheckboxThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      color: color ?? other.color,
      interactiveSize: interactiveSize ?? other.interactiveSize,
      size: size ?? other.size,
      margin: margin ?? other.margin,
      padding: padding ?? other.padding,
      borderColor: borderColor ?? other.borderColor,
      borderRadius: borderRadius ?? other.borderRadius,
    );
  }

  /// Linearly interpolates between this [CheckboxThemeData] and another.
  @override
  CheckboxThemeData lerp(
    covariant ThemeExtension<CheckboxThemeData>? other,
    double t,
  ) {
    if (other is! CheckboxThemeData) return this;
    return CheckboxThemeData(
      color: t < 0.5 ? color : other.color,
      interactiveSize: t < 0.5 ? interactiveSize : other.interactiveSize,
      size: t < 0.5 ? size : other.size,
      margin: t < 0.5 ? margin : other.margin,
      padding: t < 0.5 ? padding : other.padding,
      borderColor: t < 0.5 ? borderColor : other.borderColor,
      borderRadius: t < 0.5 ? borderRadius : other.borderRadius,
    );
  }

  @override
  int get hashCode => Object.hash(
    color,
    size,
    margin,
    padding,
    borderColor,
    borderRadius,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CheckboxThemeData &&
        other.color == color &&
        other.interactiveSize == interactiveSize &&
        other.size == size &&
        other.margin == margin &&
        other.padding == padding &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius;
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
        'interactiveSize',
        interactiveSize,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetProperty<Size>>(
        'size',
        size,
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
  }
}

/// An inherited widget that overrides the default color style, and size
/// parameters for [Checkbox]s in this widget's subtree.
///
/// Values specified here override the defaults for [Checkbox] properties which
/// are not given an explicit non-null value.
class CheckboxTheme extends InheritedTheme {
  /// Creates a theme that overrides the default properties for [Checkbox]s
  /// in this widget's subtree.
  const CheckboxTheme({super.key, required this.data, required super.child});

  /// Specifies the default property overrides for descendant [Checkbox] widgets.
  final CheckboxThemeData data;

  /// Retrieves the [CheckboxThemeData] from the closest ancestor [CheckboxTheme].
  ///
  /// If there is no enclosing [CheckboxTheme] widget, then
  /// [ThemeData.checkboxTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// CheckboxThemeData theme = CheckboxTheme.of(context);
  /// ```
  static CheckboxThemeData of(BuildContext context) {
    final CheckboxTheme? checkboxTheme = context
        .dependOnInheritedWidgetOfExactType<CheckboxTheme>();
    return checkboxTheme?.data ?? context.themeData.checkboxTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CheckboxTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(CheckboxTheme oldWidget) => data != oldWidget.data;
}
