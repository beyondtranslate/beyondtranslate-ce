import 'package:flutter/widgets.dart';

import '../foundation/color_descriptor.dart';
import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../foundation/widget_variant.dart';
import '../generated/colors.dart';
import '../painting/widget_property.dart';

class VariantedWidgetStateColor implements WidgetProperty<Color> {
  const VariantedWidgetStateColor({
    this.normal = const ColorDescriptor(),
    this.recessed,
    required this.filled,
    required this.tinted,
    required this.outlined,
    required this.plain,
    this.debugName,
  });

  final ColorDescriptor normal;
  final ColorDescriptor? recessed;
  final ColorDescriptor filled;
  final ColorDescriptor tinted;
  final ColorDescriptor outlined;
  final ColorDescriptor plain;

  final String? debugName;

  Map<NamedVariant?, ColorDescriptor> get _values {
    return {
      null: normal,
      NamedVariant.normal: normal,
      NamedVariant.recessed: recessed ?? normal,
      NamedVariant.filled: filled,
      NamedVariant.tinted: tinted,
      NamedVariant.outlined: outlined,
      NamedVariant.plain: plain,
    };
  }

  @override
  Color resolve(Set<WidgetState> states) => resolveWith(states);

  @override
  Color resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
  }) {
    Color? seedColor;
    if (extra != null) {
      seedColor = extra.containsKey('seedColor') ? extra['seedColor'] : null;
    }

    // Get the base color descriptor for the variant
    ColorDescriptor descriptor = _values[variant?.namedVariant]!;

    // Select color, shade, and opacity based on the current state
    Color? stateColor;
    int? stateShade;
    double? stateOpacity;

    if (states.contains(WidgetState.disabled)) {
      stateColor = descriptor.disabledColor;
      stateShade = descriptor.disabledShade;
      stateOpacity = descriptor.disabledOpacity;
    } else if (states.contains(WidgetState.pressed)) {
      stateColor = descriptor.pressedColor;
      stateShade = descriptor.pressedShade;
      stateOpacity = descriptor.pressedOpacity;
    } else if (states.contains(WidgetState.hovered)) {
      stateColor = descriptor.hoveredColor;
      stateShade = descriptor.hoveredShade;
      stateOpacity = descriptor.hoveredOpacity;
    } else {
      stateColor = descriptor.normalColor;
      stateShade = descriptor.normalShade;
      stateOpacity = descriptor.normalOpacity;
    }

    if (stateColor != null) {
      seedColor = stateColor;
    }

    Color resolvedColor = seedColor ?? Colors.black;
    if (seedColor is ColorSwatch<int> && stateShade != null) {
      if (stateShade != 0) {
        resolvedColor = seedColor[stateShade]!;
      } else {
        resolvedColor = Colors.transparent;
      }
    }
    if (stateOpacity != null) {
      resolvedColor = resolvedColor.withValues(alpha: stateOpacity);
    }
    return resolvedColor;
  }
}
