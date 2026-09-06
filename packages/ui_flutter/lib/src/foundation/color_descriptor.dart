import 'package:flutter/widgets.dart';

/// A descriptor for defining colors across different widget states.
///
/// [ColorDescriptor] allows you to specify colors, shades, and opacity values
/// for various widget states (normal, hovered, pressed, disabled). This provides
/// a flexible way to define state-dependent styling for widgets.
///
/// Each state can have its own color, shade, and opacity. When a state-specific
/// value is not provided, it falls back to the normal state value.
class ColorDescriptor {
  const ColorDescriptor({
    this.normalColor,
    this.normalShade,
    this.normalOpacity,
    this.hoveredColor,
    this.hoveredShade,
    this.hoveredOpacity,
    this.pressedColor,
    this.pressedShade,
    this.pressedOpacity,
    this.disabledColor,
    this.disabledShade,
    this.disabledOpacity,
  });

  // Normal state
  final Color? normalColor;
  final int? normalShade;
  final double? normalOpacity;

  // Hovered state
  final Color? hoveredColor;
  final int? hoveredShade;
  final double? hoveredOpacity;

  // Pressed state
  final Color? pressedColor;
  final int? pressedShade;
  final double? pressedOpacity;

  // Disabled state
  final Color? disabledColor;
  final int? disabledShade;
  final double? disabledOpacity;
}
