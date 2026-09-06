import 'dart:ui';

extension BrightnessExtension on Brightness {
  /// Whether the brightness is dark.
  bool isDark() => this == Brightness.dark;

  /// Whether the brightness is light.
  bool isLight() => this == Brightness.light;
}
