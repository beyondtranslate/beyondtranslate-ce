import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

import '../painting/widget_property.dart';
import '../theme/theme.dart';

/// Overrides the default properties values for descendant [Card] widgets.
///
/// Descendant widgets obtain the current [CardThemeData] object
/// using [CardTheme.of]. Instances of [CardThemeData] can
/// be customized with [CardThemeData.copyWith].
///
/// Typically a [CardThemeData] is specified as part of the
/// overall [Theme] with [ThemeData.cardTheme].
///
/// All [CardThemeData] properties are `null` by default.
/// When null, the [Card] will use the values from [ThemeData]
/// if they exist, otherwise it will provide its own defaults.
///
/// See also:
///
///  * [ThemeData], which describes the overall theme information for the
///    application.
@immutable
class CardThemeData extends ThemeExtension<CardThemeData> with Diagnosticable {
  /// Creates the set of color, style, and size properties used to configure [Card].
  const CardThemeData({
    this.margin,
    this.padding,
    this.surfaceColor,
    this.contentColor,
    this.borderColor,
    this.borderRadius,
  });

  final WidgetProperty<EdgeInsets>? margin;

  final WidgetProperty<EdgeInsets>? padding;

  final WidgetProperty<Color>? surfaceColor;

  final WidgetProperty<Color>? contentColor;

  final WidgetProperty<Color>? borderColor;

  final WidgetProperty<BorderRadius>? borderRadius;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  CardThemeData copyWith({
    WidgetProperty<EdgeInsets>? margin,
    WidgetProperty<EdgeInsets>? padding,
    WidgetProperty<Color>? surfaceColor,
    WidgetProperty<Color>? contentColor,
    WidgetProperty<Color>? borderColor,
    WidgetProperty<BorderRadius>? borderRadius,
  }) {
    return CardThemeData(
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      contentColor: contentColor ?? this.contentColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  /// Merges the given [other] [CardThemeData] with this [CardThemeData].
  CardThemeData merge(CardThemeData? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      margin: margin ?? other.margin,
      padding: padding ?? other.padding,
      surfaceColor: surfaceColor ?? other.surfaceColor,
      contentColor: contentColor ?? other.contentColor,
      borderColor: borderColor ?? other.borderColor,
      borderRadius: borderRadius ?? other.borderRadius,
    );
  }

  /// Linearly interpolates between this [CardThemeData] and another.
  @override
  CardThemeData lerp(
    covariant ThemeExtension<CardThemeData>? other,
    double t,
  ) {
    if (other is! CardThemeData) return this;
    return CardThemeData(
      margin: t < 0.5 ? margin : other.margin,
      padding: t < 0.5 ? padding : other.padding,
      surfaceColor: t < 0.5 ? surfaceColor : other.surfaceColor,
      contentColor: t < 0.5 ? contentColor : other.contentColor,
      borderColor: t < 0.5 ? borderColor : other.borderColor,
      borderRadius: t < 0.5 ? borderRadius : other.borderRadius,
    );
  }

  @override
  int get hashCode => Object.hash(
    margin,
    padding,
    surfaceColor,
    contentColor,
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
    return other is CardThemeData &&
        other.margin == margin &&
        other.padding == padding &&
        other.surfaceColor == surfaceColor &&
        other.contentColor == contentColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
  }
}

/// An inherited widget that overrides the default color style, and size
/// parameters for [Card]s in this widget's subtree.
///
/// Values specified here override the defaults for [Card] properties which
/// are not given an explicit non-null value.
class CardTheme extends InheritedTheme {
  /// Creates a theme that overrides the default properties for [Card]s
  /// in this widget's subtree.
  const CardTheme({super.key, required this.data, required super.child});

  /// Specifies the default property overrides for descendant [Card] widgets.
  final CardThemeData data;

  /// Retrieves the [CardThemeData] from the closest ancestor [CardTheme].
  ///
  /// If there is no enclosing [CardTheme] widget, then
  /// [ThemeData.cardTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// CardThemeData theme = CardTheme.of(context);
  /// ```
  static CardThemeData of(BuildContext context) {
    final CardTheme? cardTheme = context
        .dependOnInheritedWidgetOfExactType<CardTheme>();
    return cardTheme?.data ?? context.themeData.cardTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CardTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(CardTheme oldWidget) => data != oldWidget.data;
}
