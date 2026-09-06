import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../foundation/widget_variant.dart';
import '../theme/theme.dart';

extension WidgetPropertyX on WidgetProperty {
  /// Resolves the property for the given [tint].
  T tinted<T>(WidgetTint? tint) {
    return resolveWith({}, tint: tint);
  }

  /// Resolves the property for the given [size].
  T sized<T>(Size size) {
    if (size is! WidgetSize) {
      throw ArgumentError('size must be a WidgetSize');
    }
    return resolveWith({}, size: size);
  }

  /// Resolves the property for the given [variant].
  T varianted<T>(
    WidgetVariant? variant,
    Set<WidgetState> states,
    Color? seedColor,
  ) {
    return resolveWith(
      states,
      variant: variant,
      extra: {
        'seedColor': seedColor,
      }..removeWhere((key, value) => value == null),
    );
  }

  /// Resolves the property for the given [states].
  T stated<T>({Set<WidgetState> states = const {}}) {
    return resolveWith(states);
  }
}

abstract class WidgetProperty<T> extends WidgetStateProperty<T> {
  /// Returns a value of type `T` that depends on [states] and the other
  /// properties.
  T resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
  });

  static WidgetProperty<T> all<T>(T value) => WidgetPropertyAll<T>(value);

  /// Creates a [SizedWidgetProperty] that resolves to a set of [Size]
  /// based on the given [baseDimension] and [sizingUnit].
  static SizedWidgetProperty<Size> sizedSize(
    double baseDimension,
    double sizingUnit, [
    double scale = 1,
  ]) {
    return SizedWidgetProperty<Size>(
      small: Size.square((baseDimension - sizingUnit) * scale),
      medium: Size.square(baseDimension * scale),
      large: Size.square((baseDimension + sizingUnit) * scale),
    );
  }

  /// Creates a [SizedWidgetProperty] that resolves to a set of [EdgeInsets]
  /// based on the given [baseDimension] and [spacingUnit].
  static SizedWidgetProperty<EdgeInsets> sizedInsets(
    double baseDimension,
    double spacingUnit, [
    double scale = 1,
  ]) {
    return SizedWidgetProperty<EdgeInsets>(
      small: EdgeInsets.all((baseDimension - spacingUnit) * scale),
      medium: EdgeInsets.all(baseDimension * scale),
      large: EdgeInsets.all((baseDimension + spacingUnit) * scale),
    );
  }
}

class WidgetPropertyAll<T> implements WidgetProperty<T> {
  /// Constructs a [WidgetProperty] that always resolves to the given
  /// value.
  const WidgetPropertyAll(this.value);

  /// The value of the property that will be used for all states.
  final T value;

  @override
  T resolve(Set<WidgetState> states) => value;

  @override
  T resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
    ThemeData? theme,
  }) {
    return value;
  }

  @override
  String toString() {
    if (value is double) {
      return 'WidgetPropertyAll(${debugFormatDouble(value as double)})';
    } else {
      return 'WidgetPropertyAll($value)';
    }
  }
}

class TintedWidgetProperty<T> implements WidgetProperty<T> {
  const TintedWidgetProperty({
    required this.primary,
    required this.neutral,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    this.debugName,
  });

  final T primary;
  final T neutral;
  final T success;
  final T danger;
  final T warning;
  final T info;

  final String? debugName;

  Map<NamedTint, T> get _values {
    return {
      NamedTint.primary: primary,
      NamedTint.neutral: neutral,
      NamedTint.success: success,
      NamedTint.danger: danger,
      NamedTint.warning: warning,
      NamedTint.info: info,
    };
  }

  @override
  T resolve(Set<WidgetState> states) => resolveWith(states);

  @override
  T resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
  }) {
    if (tint == null) {
      throw ArgumentError(
        'tint is required for ${debugName ?? T.runtimeType} property.',
      );
    }
    return _values[tint.namedTint]!;
  }
}

class VariantedWidgetProperty<T> implements WidgetProperty<T> {
  const VariantedWidgetProperty({
    required this.normal,
    required this.filled,
    required this.tinted,
    required this.outlined,
    required this.plain,
    this.debugName,
  });

  final T normal;
  final T filled;
  final T tinted;
  final T outlined;
  final T plain;

  final String? debugName;

  Map<NamedVariant, T> get _values {
    return {
      NamedVariant.filled: filled,
      NamedVariant.tinted: tinted,
      NamedVariant.outlined: outlined,
      NamedVariant.plain: plain,
    };
  }

  @override
  T resolve(Set<WidgetState> states) => resolveWith(states);

  @override
  T resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
    ThemeData? theme,
  }) {
    if (variant == null) {
      throw ArgumentError(
        'variant is required for ${debugName ?? T.runtimeType} property.',
      );
    }
    return _values[variant.namedVariant]!;
  }
}

class SizedWidgetProperty<T> implements WidgetProperty<T> {
  const SizedWidgetProperty({
    this.tiny,
    required this.small,
    required this.medium,
    required this.large,
    this.debugName,
  });

  /// The tiny step of the profile. A component without one falls back to
  /// [small], the way most of the vocabulary only spans three sizes.
  final T? tiny;
  final T small;
  final T medium;
  final T large;

  final String? debugName;

  Map<NamedSize, T> get _values {
    return {
      NamedSize.tiny: tiny ?? small,
      NamedSize.small: small,
      NamedSize.medium: medium,
      NamedSize.large: large,
    };
  }

  @override
  T resolve(Set<WidgetState> states) => resolveWith(states);

  @override
  T resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
    ThemeData? theme,
  }) {
    if (size == null) {
      throw ArgumentError(
        'size is required for ${debugName ?? T.runtimeType} property.',
      );
    }
    return _values[size.namedSize]!;
  }
}

class StatedWidgetProperty<T> implements WidgetProperty<T> {
  const StatedWidgetProperty({
    required this.normal,
    required this.hovered,
    required this.focused,
    required this.pressed,
    required this.selected,
    required this.disabled,
    this.debugName,
  });

  final T normal;
  final T? hovered;
  final T? focused;
  final T? pressed;
  final T? selected;
  final T? disabled;

  final String? debugName;

  Map<WidgetState?, T?> get _values {
    return {
      null: normal,
      WidgetState.hovered: hovered,
      WidgetState.focused: focused,
      WidgetState.pressed: pressed,
      WidgetState.selected: selected,
      WidgetState.disabled: disabled,
    };
  }

  @override
  T resolve(Set<WidgetState> states) => resolveWith(states);

  @override
  T resolveWith(
    Set<WidgetState> states, {
    WidgetTint? tint,
    WidgetVariant? variant,
    WidgetSize? size,
    Map<String, dynamic>? extra,
    ThemeData? theme,
  }) {
    const List<WidgetState> sortedStates = [
      WidgetState.disabled,
      WidgetState.selected,
      WidgetState.pressed,
      WidgetState.focused,
      WidgetState.hovered,
    ];
    for (final state in sortedStates) {
      if (states.contains(state) && _values[state] != null) {
        return _values[state]!;
      }
    }
    return _values[null]!;
  }
}
