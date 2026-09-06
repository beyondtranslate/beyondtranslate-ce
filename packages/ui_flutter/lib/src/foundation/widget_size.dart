import 'package:flutter/widgets.dart';

/// The named size of a widget.
enum NamedSize {
  /// The size of the widget is tiny — the smallest control step, what an
  /// icon button in a toolbar row is.
  tiny,

  /// The size of the widget is small.
  small,

  /// The size of the widget is medium.
  medium,

  /// The size of the widget is large.
  large,
}

/// The size of a widget.
class WidgetSize extends Size {
  const WidgetSize(this.namedSize) : super(0.0, 0.0);

  /// The name of the size.
  final NamedSize namedSize;

  @override
  int get hashCode => Object.hash(width, height, namedSize);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is WidgetSize && other.namedSize == namedSize;
  }

  /// The size of the widget is small.
  static const WidgetSize tiny = WidgetSize(NamedSize.tiny);

  static const WidgetSize small = WidgetSize(NamedSize.small);

  /// The size of the widget is medium.
  static const WidgetSize medium = WidgetSize(NamedSize.medium);

  /// The size of the widget is large.
  static const WidgetSize large = WidgetSize(NamedSize.large);
}
