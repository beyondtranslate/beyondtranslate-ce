import 'package:flutter/painting.dart';

extension ExtendedColorSwatch on ColorSwatch<int> {
  Color get shade50 => this[50]!;
  Color get shade100 => this[100]!;
  Color get shade200 => this[200]!;
  Color get shade300 => this[300]!;
  Color get shade400 => this[400]!;
  Color get shade500 => this[500]!;
  Color get shade600 => this[600]!;
  Color get shade700 => this[700]!;
  Color get shade800 => this[800]!;
  Color get shade900 => this[900]!;
  Color get shade950 => this[950]!;
}

/// Primitive color tokens
/// DO NOT EDIT - This file is auto-generated
abstract final class Colors {
  /// Completely invisible.
  static const Color transparent = Color(0x00000000);

  /// Completely opaque black.
  static const Color black = Color(0xFF000000);

  /// Completely opaque white.
  static const Color white = Color(0xFFFFFFFF);

  static const ColorSwatch<int> brand = ColorSwatch<int>(
    0xff6b4dff,
    <int, Color>{
      50: Color(0xFFF4F1FE),
      100: Color(0xFFE6DFFF),
      200: Color(0xFFCDC0FF),
      300: Color(0xFFB9A8FF),
      400: Color(0xFF9A82FF),
      500: Color(0xFF7C5CFF),
      600: Color(0xFF6B4DFF),
      700: Color(0xFF5B3FE0),
      800: Color(0xFF4C33CC),
      900: Color(0xFF3D2AA3),
      950: Color(0xFF2A1C6B),
    },
  );

  static const ColorSwatch<int> ink = ColorSwatch<int>(
    0xff111c2e,
    <int, Color>{
      50: Color(0xFFF6FAE2),
      100: Color(0xFFF1F7D2),
      200: Color(0xFFE6F77A),
      300: Color(0xFFD6FF3F),
      400: Color(0xFF8FA06A),
      500: Color(0xFF3D5470),
      600: Color(0xFF111C2E),
      700: Color(0xFF1C2A41),
      800: Color(0xFF263449),
      900: Color(0xFF0B1420),
      950: Color(0xFF060B12),
    },
  );

  static const ColorSwatch<int> acid = ColorSwatch<int>(
    0xffc2ea2c,
    <int, Color>{
      50: Color(0xFFF6FAE2),
      100: Color(0xFFF1F7D2),
      200: Color(0xFFE9FF8F),
      300: Color(0xFFD6FF3F),
      400: Color(0xFFB8E034),
      500: Color(0xFFD6FF3F),
      600: Color(0xFFC2EA2C),
      700: Color(0xFFA8CC22),
      800: Color(0xFF4A5C14),
      900: Color(0xFF24310F),
      950: Color(0xFF1A2410),
    },
  );

  static const ColorSwatch<int> neutral = ColorSwatch<int>(
    0xff525252,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFE5E5E5),
      300: Color(0xFFD4D4D4),
      400: Color(0xFFA1A1A1),
      500: Color(0xFF737373),
      600: Color(0xFF525252),
      700: Color(0xFF404040),
      800: Color(0xFF262626),
      900: Color(0xFF171717),
      950: Color(0xFF0A0A0A),
    },
  );

  static const ColorSwatch<int> red = ColorSwatch<int>(
    0xffd64040,
    <int, Color>{
      50: Color(0xFFFDF2F2),
      100: Color(0xFFF9E2E2),
      200: Color(0xFFF2C1C1),
      300: Color(0xFFEBA1A1),
      400: Color(0xFFE48181),
      500: Color(0xFFDD6060),
      600: Color(0xFFD64040),
      700: Color(0xFFC4342F),
      800: Color(0xFF7E1F1C),
      900: Color(0xFF4B1210),
      950: Color(0xFF310B0A),
    },
  );

  static const ColorSwatch<int> green = ColorSwatch<int>(
    0xff1f9d5e,
    <int, Color>{
      50: Color(0xFFE9F5EF),
      100: Color(0xFFD7EDE2),
      200: Color(0xFFB2DDC7),
      300: Color(0xFF8DCDAD),
      400: Color(0xFF68BD93),
      500: Color(0xFF44AD78),
      600: Color(0xFF1F9D5E),
      700: Color(0xFF177D4A),
      800: Color(0xFF105B37),
      900: Color(0xFF093924),
      950: Color(0xFF06281A),
    },
  );

  static const ColorSwatch<int> amber = ColorSwatch<int>(
    0xffe0912a,
    <int, Color>{
      50: Color(0xFFFDF6EA),
      100: Color(0xFFFEF1DE),
      200: Color(0xFFFFE6C7),
      300: Color(0xFFF7D1A0),
      400: Color(0xFFF0BC78),
      500: Color(0xFFE8A651),
      600: Color(0xFFE0912A),
      700: Color(0xFFB96F12),
      800: Color(0xFF8A5210),
      900: Color(0xFF573409),
      950: Color(0xFF3D2506),
    },
  );

  static const ColorSwatch<int> redDark = ColorSwatch<int>(
    0xffd64040,
    <int, Color>{
      50: Color(0xFFFDF2F2),
      100: Color(0xFFF9E2E2),
      200: Color(0xFFF2C1C1),
      300: Color(0xFFFF8F8F),
      400: Color(0xFFE48181),
      500: Color(0xFFFF6B6B),
      600: Color(0xFFD64040),
      700: Color(0xFFC4342F),
      800: Color(0xFF7E1F1C),
      900: Color(0xFF4B1210),
      950: Color(0xFF310B0A),
    },
  );

  static const ColorSwatch<int> greenDark = ColorSwatch<int>(
    0xff1f9d5e,
    <int, Color>{
      50: Color(0xFFE9F5EF),
      100: Color(0xFFD7EDE2),
      200: Color(0xFFB2DDC7),
      300: Color(0xFF7FD7A8),
      400: Color(0xFF68BD93),
      500: Color(0xFF34D399),
      600: Color(0xFF1F9D5E),
      700: Color(0xFF177D4A),
      800: Color(0xFF105B37),
      900: Color(0xFF093924),
      950: Color(0xFF06281A),
    },
  );

  static const ColorSwatch<int> amberDark = ColorSwatch<int>(
    0xffe0912a,
    <int, Color>{
      50: Color(0xFFFDF6EA),
      100: Color(0xFFFEF1DE),
      200: Color(0xFFFFE6C7),
      300: Color(0xFFFFCF9C),
      400: Color(0xFFF0BC78),
      500: Color(0xFFFFB86B),
      600: Color(0xFFE0912A),
      700: Color(0xFFB96F12),
      800: Color(0xFF8A5210),
      900: Color(0xFF573409),
      950: Color(0xFF3D2506),
    },
  );

  static const ColorSwatch<int> sky = ColorSwatch<int>(
    0xff0084d1,
    <int, Color>{
      50: Color(0xFFF0F9FF),
      100: Color(0xFFDFF2FE),
      200: Color(0xFFB8E6FE),
      300: Color(0xFF74D4FF),
      400: Color(0xFF00BCFF),
      500: Color(0xFF00A6F4),
      600: Color(0xFF0084D1),
      700: Color(0xFF0069A8),
      800: Color(0xFF00598A),
      900: Color(0xFF024A70),
      950: Color(0xFF052F4A),
    },
  );
}
