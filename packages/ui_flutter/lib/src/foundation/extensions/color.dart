import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// An extension on [Color] to add methods for working with shades.
extension ColorWithShade on Color {
  /// Returns a color that is a shade of the current color.
  Color withShade(int shade) {
    if (this is ColorSwatch) {
      return (this as ColorSwatch<int>)[shade] ?? this;
    } else {
      debugPrint('Color $this is not a ColorSwatch<int>');
    }
    return this;
  }

  Color get shade50 => withShade(50);
  Color get shade100 => withShade(100);
  Color get shade200 => withShade(200);
  Color get shade300 => withShade(300);
  Color get shade400 => withShade(400);
  Color get shade500 => withShade(500);
  Color get shade600 => withShade(600);
  Color get shade700 => withShade(700);
  Color get shade800 => withShade(800);
  Color get shade900 => withShade(900);
  Color get shade950 => withShade(950);
}
