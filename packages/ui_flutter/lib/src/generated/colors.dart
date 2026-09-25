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

  static const ColorSwatch<int> frost = ColorSwatch<int>(
    0xff0f7a92,
    <int, Color>{
      50: Color(0xFFEEF8FA),
      100: Color(0xFFD7EFF4),
      200: Color(0xFFB2E0EA),
      300: Color(0xFF74C9DC),
      400: Color(0xFF35ABC4),
      500: Color(0xFF1690A9),
      600: Color(0xFF0F7A92),
      700: Color(0xFF0C6277),
      800: Color(0xFF0B4F61),
      900: Color(0xFF0D3C4A),
      950: Color(0xFF08262F),
    },
  );

  static const ColorSwatch<int> graphite = ColorSwatch<int>(
    0xff3f3f46,
    <int, Color>{
      50: Color(0xFFF6F6F7),
      100: Color(0xFFEDEDEF),
      200: Color(0xFFE2E2E6),
      300: Color(0xFFC9C9CF),
      400: Color(0xFF8F8F99),
      500: Color(0xFF52525B),
      600: Color(0xFF3F3F46),
      700: Color(0xFF2B2B31),
      800: Color(0xFF1C1C21),
      900: Color(0xFF131317),
      950: Color(0xFF0B0B0E),
    },
  );

  static const ColorSwatch<int> graphiteDark = ColorSwatch<int>(
    0xffd4d4d8,
    <int, Color>{
      50: Color(0xFF1C1C20),
      100: Color(0xFF26262B),
      200: Color(0xFFFAFAFA),
      300: Color(0xFFE6E6EA),
      400: Color(0xFFA1A1AA),
      500: Color(0xFFEDEDF0),
      600: Color(0xFFD4D4D8),
      700: Color(0xFFA1A1AA),
      800: Color(0xFF71717A),
      900: Color(0xFF52525B),
      950: Color(0xFF3F3F46),
    },
  );

  static const ColorSwatch<int> ember = ColorSwatch<int>(
    0xffad5717,
    <int, Color>{
      50: Color(0xFFFDF4EC),
      100: Color(0xFFFAE4D0),
      200: Color(0xFFF3C8A0),
      300: Color(0xFFE9A969),
      400: Color(0xFFD9863A),
      500: Color(0xFFC46A1E),
      600: Color(0xFFAD5717),
      700: Color(0xFF8C4415),
      800: Color(0xFF6D3513),
      900: Color(0xFF512810),
      950: Color(0xFF33190B),
    },
  );

  static const ColorSwatch<int> emberDark = ColorSwatch<int>(
    0xffe0954a,
    <int, Color>{
      50: Color(0xFFFDF2E4),
      100: Color(0xFFFAE0C4),
      200: Color(0xFFF6CF9F),
      300: Color(0xFFF0B877),
      400: Color(0xFFE9A45C),
      500: Color(0xFFD9832E),
      600: Color(0xFFE0954A),
      700: Color(0xFFB96A20),
      800: Color(0xFF7D4718),
      900: Color(0xFF4A2B11),
      950: Color(0xFF2C1A0C),
    },
  );

  static const ColorSwatch<int> nocturne = ColorSwatch<int>(
    0xff8375d1,
    <int, Color>{
      50: Color(0xFFF5F4FF),
      100: Color(0xFFE7E5FE),
      200: Color(0xFFD2CEFD),
      300: Color(0xFFB5ABFC),
      400: Color(0xFFA094E8),
      500: Color(0xFF9184D9),
      600: Color(0xFF8375D1),
      700: Color(0xFF6F60C6),
      800: Color(0xFF5B4BB4),
      900: Color(0xFF453897),
      950: Color(0xFF2D2465),
    },
  );

  static const ColorSwatch<int> omarchyTokyoNightLight = ColorSwatch<int>(
    0xff4c6499,
    <int, Color>{
      50: Color(0xFFF3F7FE),
      100: Color(0xFFE4ECFB),
      200: Color(0xFFCAD8F3),
      300: Color(0xFFAABEE7),
      400: Color(0xFF829ACD),
      500: Color(0xFF657FB6),
      600: Color(0xFF4C6499),
      700: Color(0xFF3F5483),
      800: Color(0xFF32456D),
      900: Color(0xFF29385A),
      950: Color(0xFF1A263F),
    },
  );

  static const ColorSwatch<int> omarchyTokyoNightDark = ColorSwatch<int>(
    0xff5e84d6,
    <int, Color>{
      50: Color(0xFFF3F7FF),
      100: Color(0xFFE8EFFE),
      200: Color(0xFFD4E2FC),
      300: Color(0xFFBAD0FD),
      400: Color(0xFF95B7FC),
      500: Color(0xFF7AA2F7),
      600: Color(0xFF5E84D6),
      700: Color(0xFF496BB4),
      800: Color(0xFF375392),
      900: Color(0xFF294073),
      950: Color(0xFF14244A),
    },
  );

  static const ColorSwatch<int> omarchyCatppuccinLight = ColorSwatch<int>(
    0xff55709b,
    <int, Color>{
      50: Color(0xFFF3F7FD),
      100: Color(0xFFE5EDF9),
      200: Color(0xFFCDDBF0),
      300: Color(0xFFAEC3E5),
      400: Color(0xFF88A2CC),
      500: Color(0xFF6D89B5),
      600: Color(0xFF55709B),
      700: Color(0xFF455D83),
      800: Color(0xFF364B6C),
      900: Color(0xFF2B3C57),
      950: Color(0xFF1A273B),
    },
  );

  static const ColorSwatch<int> omarchyCatppuccinDark = ColorSwatch<int>(
    0xff6992d6,
    <int, Color>{
      50: Color(0xFFF3F7FE),
      100: Color(0xFFE9F1FF),
      200: Color(0xFFD7E6FE),
      300: Color(0xFFC1D8FD),
      400: Color(0xFFA1C4FE),
      500: Color(0xFF89B4FA),
      600: Color(0xFF6992D6),
      700: Color(0xFF5176B2),
      800: Color(0xFF3C5B8E),
      900: Color(0xFF2C456F),
      950: Color(0xFF142644),
    },
  );

  static const ColorSwatch<int> omarchyCatppuccinLatteLight = ColorSwatch<int>(
    0xff1e66f5,
    <int, Color>{
      50: Color(0xFFF3F7FF),
      100: Color(0xFFE4EDFE),
      200: Color(0xFFC9DBFC),
      300: Color(0xFFA7C5FB),
      400: Color(0xFF76A3F7),
      500: Color(0xFF4B86F9),
      600: Color(0xFF1E66F5),
      700: Color(0xFF1152D3),
      800: Color(0xFF0740AF),
      900: Color(0xFF05338E),
      950: Color(0xFF001E61),
    },
  );

  static const ColorSwatch<int> omarchyCatppuccinLatteDark = ColorSwatch<int>(
    0xff5882d8,
    <int, Color>{
      50: Color(0xFFF3F7FE),
      100: Color(0xFFE7EFFF),
      200: Color(0xFFD3E1FD),
      300: Color(0xFFB7CFFE),
      400: Color(0xFF90B5FE),
      500: Color(0xFF74A0F9),
      600: Color(0xFF5882D8),
      700: Color(0xFF4469B6),
      800: Color(0xFF335294),
      900: Color(0xFF253F75),
      950: Color(0xFF12244B),
    },
  );

  static const ColorSwatch<int> omarchyEtherealLight = ColorSwatch<int>(
    0xff4e5187,
    <int, Color>{
      50: Color(0xFFF5F6FE),
      100: Color(0xFFE7E9F9),
      200: Color(0xFFCED2EE),
      300: Color(0xFFB0B4DF),
      400: Color(0xFF878CC1),
      500: Color(0xFF696EA6),
      600: Color(0xFF4E5187),
      700: Color(0xFF434576),
      800: Color(0xFF383A64),
      900: Color(0xFF2F3154),
      950: Color(0xFF22233D),
    },
  );

  static const ColorSwatch<int> omarchyEtherealDark = ColorSwatch<int>(
    0xff666abe,
    <int, Color>{
      50: Color(0xFFF5F6FF),
      100: Color(0xFFE9EBFF),
      200: Color(0xFFD3D8FE),
      300: Color(0xFFB8BEFF),
      400: Color(0xFF969CEC),
      500: Color(0xFF7D82D9),
      600: Color(0xFF666ABE),
      700: Color(0xFF5457A2),
      800: Color(0xFF434485),
      900: Color(0xFF34366B),
      950: Color(0xFF202148),
    },
  );

  static const ColorSwatch<int> omarchyEverforestLight = ColorSwatch<int>(
    0xff4f746f,
    <int, Color>{
      50: Color(0xFFF3F8F7),
      100: Color(0xFFE5EFED),
      200: Color(0xFFCBDDDA),
      300: Color(0xFFACC7C3),
      400: Color(0xFF85A7A2),
      500: Color(0xFF688E88),
      600: Color(0xFF4F746F),
      700: Color(0xFF40615D),
      800: Color(0xFF334F4B),
      900: Color(0xFF28403D),
      950: Color(0xFF192A28),
    },
  );

  static const ColorSwatch<int> omarchyEverforestDark = ColorSwatch<int>(
    0xff5f9b93,
    <int, Color>{
      50: Color(0xFFF1F8F7),
      100: Color(0xFFE5F4F1),
      200: Color(0xFFD0EAE6),
      300: Color(0xFFB5DED8),
      400: Color(0xFF95CBC4),
      500: Color(0xFF7FBBB3),
      600: Color(0xFF5F9B93),
      700: Color(0xFF497E78),
      800: Color(0xFF35635D),
      900: Color(0xFF264C47),
      950: Color(0xFF102C29),
    },
  );

  static const ColorSwatch<int> omarchyFlexokiLightLight = ColorSwatch<int>(
    0xff205ea6,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFDFECFD),
      200: Color(0xFFBCD8FD),
      300: Color(0xFF92BEF5),
      400: Color(0xFF6198DD),
      500: Color(0xFF3E7BC5),
      600: Color(0xFF205EA6),
      700: Color(0xFF175090),
      800: Color(0xFF11427A),
      900: Color(0xFF0F3765),
      950: Color(0xFF092649),
    },
  );

  static const ColorSwatch<int> omarchyFlexokiLightDark = ColorSwatch<int>(
    0xff5b80ac,
    <int, Color>{
      50: Color(0xFFF2F7FD),
      100: Color(0xFFE5EFFB),
      200: Color(0xFFCEE0F6),
      300: Color(0xFFB1CDEE),
      400: Color(0xFF8EB1DA),
      500: Color(0xFF759BC8),
      600: Color(0xFF5B80AC),
      700: Color(0xFF486990),
      800: Color(0xFF375374),
      900: Color(0xFF2A415C),
      950: Color(0xFF16273B),
    },
  );

  static const ColorSwatch<int> omarchyGruvboxLight = ColorSwatch<int>(
    0xff4e6c65,
    <int, Color>{
      50: Color(0xFFF4F8F7),
      100: Color(0xFFE5EEEB),
      200: Color(0xFFCCDBD7),
      300: Color(0xFFADC3BE),
      400: Color(0xFF85A19A),
      500: Color(0xFF68877F),
      600: Color(0xFF4E6C65),
      700: Color(0xFF405B55),
      800: Color(0xFF344B46),
      900: Color(0xFF2A3D39),
      950: Color(0xFF1C2A26),
    },
  );

  static const ColorSwatch<int> omarchyGruvboxDark = ColorSwatch<int>(
    0xff609086,
    <int, Color>{
      50: Color(0xFFF2F8F7),
      100: Color(0xFFE6F2EF),
      200: Color(0xFFD0E6E1),
      300: Color(0xFFB5D8CF),
      400: Color(0xFF94C1B6),
      500: Color(0xFF7DAEA3),
      600: Color(0xFF609086),
      700: Color(0xFF4B776D),
      800: Color(0xFF385D56),
      900: Color(0xFF2A4942),
      950: Color(0xFF152B27),
    },
  );

  static const ColorSwatch<int> omarchyHackermanLight = ColorSwatch<int>(
    0xff519c61,
    <int, Color>{
      50: Color(0xFFF1FAF2),
      100: Color(0xFFE2F4E4),
      200: Color(0xFFC8EACD),
      300: Color(0xFFA8DCB0),
      400: Color(0xFF81C58D),
      500: Color(0xFF66B175),
      600: Color(0xFF519C61),
      700: Color(0xFF3D804C),
      800: Color(0xFF2A6538),
      900: Color(0xFF1E4E2A),
      950: Color(0xFF0A2F14),
    },
  );

  static const ColorSwatch<int> omarchyHackermanDark = ColorSwatch<int>(
    0xff53ce72,
    <int, Color>{
      50: Color(0xFFEEFBEF),
      100: Color(0xFFE2FDE5),
      200: Color(0xFFD1FED7),
      300: Color(0xFFBDFDC7),
      400: Color(0xFF94FFA9),
      500: Color(0xFF82FB9C),
      600: Color(0xFF53CE72),
      700: Color(0xFF33A654),
      800: Color(0xFF157F39),
      900: Color(0xFF145D2A),
      950: Color(0xFF00300F),
    },
  );

  static const ColorSwatch<int> omarchyKanagawaLight = ColorSwatch<int>(
    0xff888573,
    <int, Color>{
      50: Color(0xFFF7F7F4),
      100: Color(0xFFEFEEE9),
      200: Color(0xFFE0DFD6),
      300: Color(0xFFCDCBBE),
      400: Color(0xFFB2B09F),
      500: Color(0xFF9D9A88),
      600: Color(0xFF888573),
      700: Color(0xFF6F6D5D),
      800: Color(0xFF575547),
      900: Color(0xFF444237),
      950: Color(0xFF28271F),
    },
  );

  static const ColorSwatch<int> omarchyKanagawaDark = ColorSwatch<int>(
    0xffb2ad91,
    <int, Color>{
      50: Color(0xFFF7F7F3),
      100: Color(0xFFF5F4ED),
      200: Color(0xFFF1EFE2),
      300: Color(0xFFECE8D4),
      400: Color(0xFFE3DFC4),
      500: Color(0xFFDCD7BA),
      600: Color(0xFFB2AD91),
      700: Color(0xFF8E8A71),
      800: Color(0xFF6C6853),
      900: Color(0xFF504D3C),
      950: Color(0xFF29271B),
    },
  );

  static const ColorSwatch<int> omarchyLastHorizonLight = ColorSwatch<int>(
    0xff705e59,
    <int, Color>{
      50: Color(0xFFF9F6F5),
      100: Color(0xFFEFEAE8),
      200: Color(0xFFDED4D2),
      300: Color(0xFFC7B9B5),
      400: Color(0xFFA6948F),
      500: Color(0xFF8B7873),
      600: Color(0xFF705E59),
      700: Color(0xFF5F4F4B),
      800: Color(0xFF4F413D),
      900: Color(0xFF413532),
      950: Color(0xFF2D2422),
    },
  );

  static const ColorSwatch<int> omarchyLastHorizonDark = ColorSwatch<int>(
    0xff987b74,
    <int, Color>{
      50: Color(0xFFFAF6F5),
      100: Color(0xFFF5ECEB),
      200: Color(0xFFEBDCD9),
      300: Color(0xFFDEC8C2),
      400: Color(0xFFC8ACA6),
      500: Color(0xFFB59790),
      600: Color(0xFF987B74),
      700: Color(0xFF7E645E),
      800: Color(0xFF644E49),
      900: Color(0xFF4E3C38),
      950: Color(0xFF302320),
    },
  );

  static const ColorSwatch<int> omarchyLumonLight = ColorSwatch<int>(
    0xff567d92,
    <int, Color>{
      50: Color(0xFFF3F8FA),
      100: Color(0xFFE5EFF5),
      200: Color(0xFFCCDFE9),
      300: Color(0xFFAECADA),
      400: Color(0xFF88ACC0),
      500: Color(0xFF6D95AA),
      600: Color(0xFF567D92),
      700: Color(0xFF45687A),
      800: Color(0xFF355363),
      900: Color(0xFF29414F),
      950: Color(0xFF172933),
    },
  );

  static const ColorSwatch<int> omarchyLumonDark = ColorSwatch<int>(
    0xff67a4c5,
    <int, Color>{
      50: Color(0xFFF1F8FC),
      100: Color(0xFFE5F4FD),
      200: Color(0xFFD2EDFD),
      300: Color(0xFFB9E4FC),
      400: Color(0xFF9ED5F4),
      500: Color(0xFF8BC9EB),
      600: Color(0xFF67A4C5),
      700: Color(0xFF4E84A2),
      800: Color(0xFF37667F),
      900: Color(0xFF264D61),
      950: Color(0xFF0D2A38),
    },
  );

  static const ColorSwatch<int> omarchyLupineLight = ColorSwatch<int>(
    0xff3264eb,
    <int, Color>{
      50: Color(0xFFF3F7FE),
      100: Color(0xFFE4EDFE),
      200: Color(0xFFCADBFD),
      300: Color(0xFFA7C3FD),
      400: Color(0xFF78A0FA),
      500: Color(0xFF4F81FC),
      600: Color(0xFF3264EB),
      700: Color(0xFF2551CA),
      800: Color(0xFF1B3FA8),
      900: Color(0xFF143288),
      950: Color(0xFF091E5E),
    },
  );

  static const ColorSwatch<int> omarchyLupineDark = ColorSwatch<int>(
    0xff6481d3,
    <int, Color>{
      50: Color(0xFFF3F7FF),
      100: Color(0xFFE9EFFE),
      200: Color(0xFFD5E1FE),
      300: Color(0xFFBDCFFB),
      400: Color(0xFF99B4F9),
      500: Color(0xFF809FF3),
      600: Color(0xFF6481D3),
      700: Color(0xFF4F69B1),
      800: Color(0xFF3C518F),
      900: Color(0xFF2D3F71),
      950: Color(0xFF172449),
    },
  );

  static const ColorSwatch<int> omarchyMatteBlackLight = ColorSwatch<int>(
    0xff8f5808,
    <int, Color>{
      50: Color(0xFFFDF5EE),
      100: Color(0xFFF9E9D9),
      200: Color(0xFFEED2B6),
      300: Color(0xFFE0B589),
      400: Color(0xFFC48F55),
      500: Color(0xFFAB722E),
      600: Color(0xFF8F5808),
      700: Color(0xFF774B12),
      800: Color(0xFF623C0A),
      900: Color(0xFF513109),
      950: Color(0xFF382104),
    },
  );

  static const ColorSwatch<int> omarchyMatteBlackDark = ColorSwatch<int>(
    0xffba761f,
    <int, Color>{
      50: Color(0xFFFEF5EC),
      100: Color(0xFFFFECD9),
      200: Color(0xFFFDDBBA),
      300: Color(0xFFFDC489),
      400: Color(0xFFF5A448),
      500: Color(0xFFE68E0D),
      600: Color(0xFFBA761F),
      700: Color(0xFF9B5E06),
      800: Color(0xFF794A0D),
      900: Color(0xFF5F3806),
      950: Color(0xFF392002),
    },
  );

  static const ColorSwatch<int> omarchyMiasmaLight = ColorSwatch<int>(
    0xff4a512f,
    <int, Color>{
      50: Color(0xFFF6F7F3),
      100: Color(0xFFE8EBE1),
      200: Color(0xFFCFD4C2),
      300: Color(0xFFB1B79D),
      400: Color(0xFF878F6E),
      500: Color(0xFF686F4C),
      600: Color(0xFF4A512F),
      700: Color(0xFF414728),
      800: Color(0xFF383D22),
      900: Color(0xFF30351F),
      950: Color(0xFF252818),
    },
  );

  static const ColorSwatch<int> omarchyMiasmaDark = ColorSwatch<int>(
    0xff646e37,
    <int, Color>{
      50: Color(0xFFF6F8F1),
      100: Color(0xFFEAEDDF),
      200: Color(0xFFD4DAC0),
      300: Color(0xFFB9C19A),
      400: Color(0xFF949E6C),
      500: Color(0xFF78824B),
      600: Color(0xFF646E37),
      700: Color(0xFF545C2B),
      800: Color(0xFF444C21),
      900: Color(0xFF373D1B),
      950: Color(0xFF25290F),
    },
  );

  static const ColorSwatch<int> omarchyNordLight = ColorSwatch<int>(
    0xff506478,
    <int, Color>{
      50: Color(0xFFF4F7FA),
      100: Color(0xFFE6ECF2),
      200: Color(0xFFCED8E2),
      300: Color(0xFFAFBECE),
      400: Color(0xFF879BAE),
      500: Color(0xFF6A7F94),
      600: Color(0xFF506478),
      700: Color(0xFF435567),
      800: Color(0xFF364655),
      900: Color(0xFF2D3946),
      950: Color(0xFF1E2731),
    },
  );

  static const ColorSwatch<int> omarchyNordDark = ColorSwatch<int>(
    0xff6685a4,
    <int, Color>{
      50: Color(0xFFF3F7FB),
      100: Color(0xFFE7F0F8),
      200: Color(0xFFD2E1F1),
      300: Color(0xFFB8CFE7),
      400: Color(0xFF98B6D3),
      500: Color(0xFF81A1C1),
      600: Color(0xFF6685A4),
      700: Color(0xFF516D88),
      800: Color(0xFF3E566D),
      900: Color(0xFF2F4356),
      950: Color(0xFF1A2836),
    },
  );

  static const ColorSwatch<int> omarchyOsakaJadeLight = ColorSwatch<int>(
    0xff325c49,
    <int, Color>{
      50: Color(0xFFF3F8F5),
      100: Color(0xFFE2EDE7),
      200: Color(0xFFC4D8CE),
      300: Color(0xFF9FBEAE),
      400: Color(0xFF719885),
      500: Color(0xFF4F7A66),
      600: Color(0xFF325C49),
      700: Color(0xFF2A503F),
      800: Color(0xFF234435),
      900: Color(0xFF1F3A2E),
      950: Color(0xFF172B22),
    },
  );

  static const ColorSwatch<int> omarchyOsakaJadeDark = ColorSwatch<int>(
    0xff397e60,
    <int, Color>{
      50: Color(0xFFF1F9F5),
      100: Color(0xFFE0F1E8),
      200: Color(0xFFC3E1D1),
      300: Color(0xFF9ECDB5),
      400: Color(0xFF71AD90),
      500: Color(0xFF509475),
      600: Color(0xFF397E60),
      700: Color(0xFF2B694F),
      800: Color(0xFF20563F),
      900: Color(0xFF194532),
      950: Color(0xFF0C2D20),
    },
  );

  static const ColorSwatch<int> omarchyRetro82Light = ColorSwatch<int>(
    0xff9b6940,
    <int, Color>{
      50: Color(0xFFFCF5F0),
      100: Color(0xFFF8EADF),
      200: Color(0xFFEFD6C2),
      300: Color(0xFFE3BC9E),
      400: Color(0xFFCA9A75),
      500: Color(0xFFB48057),
      600: Color(0xFF9B6940),
      700: Color(0xFF825631),
      800: Color(0xFF6A4424),
      900: Color(0xFF55351B),
      950: Color(0xFF37200D),
    },
  );

  static const ColorSwatch<int> omarchyRetro82Dark = ColorSwatch<int>(
    0xffd38543,
    <int, Color>{
      50: Color(0xFFFFF5ED),
      100: Color(0xFFFEEEE3),
      200: Color(0xFFFEE2CE),
      300: Color(0xFFFDD3B3),
      400: Color(0xFFFEBB88),
      500: Color(0xFFFAA968),
      600: Color(0xFFD38543),
      700: Color(0xFFAE692C),
      800: Color(0xFF894E18),
      900: Color(0xFF6A3A0B),
      950: Color(0xFF3C1D02),
    },
  );

  static const ColorSwatch<int> omarchyRistrettoLight = ColorSwatch<int>(
    0xff975745,
    <int, Color>{
      50: Color(0xFFFEF4F2),
      100: Color(0xFFFBE7E2),
      200: Color(0xFFF2D0C6),
      300: Color(0xFFE5B3A4),
      400: Color(0xFFCB8D7B),
      500: Color(0xFFB3705D),
      600: Color(0xFF975745),
      700: Color(0xFF814737),
      800: Color(0xFF6A392B),
      900: Color(0xFF562E22),
      950: Color(0xFF3B1D15),
    },
  );

  static const ColorSwatch<int> omarchyRistrettoDark = ColorSwatch<int>(
    0xffd06d51,
    <int, Color>{
      50: Color(0xFFFEF4F1),
      100: Color(0xFFFEEBE6),
      200: Color(0xFFFFDAD0),
      300: Color(0xFFFCC5B5),
      400: Color(0xFFFAA58D),
      500: Color(0xFFF38D70),
      600: Color(0xFFD06D51),
      700: Color(0xFFAD553D),
      800: Color(0xFF8A402A),
      900: Color(0xFF6C2F1E),
      950: Color(0xFF43170A),
    },
  );

  static const ColorSwatch<int> omarchyRosePineLight = ColorSwatch<int>(
    0xff56949f,
    <int, Color>{
      50: Color(0xFFF1F8FA),
      100: Color(0xFFE3F2F5),
      200: Color(0xFFCAE5EA),
      300: Color(0xFFAAD5DD),
      400: Color(0xFF85BDC7),
      500: Color(0xFF6AA9B4),
      600: Color(0xFF56949F),
      700: Color(0xFF3E7680),
      800: Color(0xFF2F5F68),
      900: Color(0xFF224950),
      950: Color(0xFF0D2B30),
    },
  );

  static const ColorSwatch<int> omarchyRosePineDark = ColorSwatch<int>(
    0xff759ba1,
    <int, Color>{
      50: Color(0xFFF3F8F8),
      100: Color(0xFFE9F3F4),
      200: Color(0xFFD8EAEC),
      300: Color(0xFFC2DEE2),
      400: Color(0xFFA8CCD1),
      500: Color(0xFF96BDC3),
      600: Color(0xFF759BA1),
      700: Color(0xFF5C7E83),
      800: Color(0xFF456266),
      900: Color(0xFF334A4E),
      950: Color(0xFF182A2C),
    },
  );

  static const ColorSwatch<int> omarchySolitudeLight = ColorSwatch<int>(
    0xff4b5053,
    <int, Color>{
      50: Color(0xFFF6F7F7),
      100: Color(0xFFE8EAEB),
      200: Color(0xFFD0D2D4),
      300: Color(0xFFB1B5B7),
      400: Color(0xFF888D90),
      500: Color(0xFF686E71),
      600: Color(0xFF4B5053),
      700: Color(0xFF414648),
      800: Color(0xFF383C3E),
      900: Color(0xFF303335),
      950: Color(0xFF242728),
    },
  );

  static const ColorSwatch<int> omarchySolitudeDark = ColorSwatch<int>(
    0xff656c71,
    <int, Color>{
      50: Color(0xFFF6F7F8),
      100: Color(0xFFEAECED),
      200: Color(0xFFD4D8DA),
      300: Color(0xFFB9BFC3),
      400: Color(0xFF959CA1),
      500: Color(0xFF798186),
      600: Color(0xFF656C71),
      700: Color(0xFF545B5F),
      800: Color(0xFF44494D),
      900: Color(0xFF363B3E),
      950: Color(0xFF232729),
    },
  );

  static const ColorSwatch<int> omarchyVantablackLight = ColorSwatch<int>(
    0xff575757,
    <int, Color>{
      50: Color(0xFFF7F7F7),
      100: Color(0xFFEAEAEA),
      200: Color(0xFFD4D4D4),
      300: Color(0xFFB8B8B8),
      400: Color(0xFF919191),
      500: Color(0xFF737373),
      600: Color(0xFF575757),
      700: Color(0xFF4B4B4B),
      800: Color(0xFF3F3F3F),
      900: Color(0xFF353535),
      950: Color(0xFF262626),
    },
  );

  static const ColorSwatch<int> omarchyVantablackDark = ColorSwatch<int>(
    0xff757575,
    <int, Color>{
      50: Color(0xFFF7F7F7),
      100: Color(0xFFEDEDED),
      200: Color(0xFFDBDBDB),
      300: Color(0xFFC4C4C4),
      400: Color(0xFFA5A5A5),
      500: Color(0xFF8D8D8D),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF4D4D4D),
      900: Color(0xFF3D3D3D),
      950: Color(0xFF262626),
    },
  );

  static const ColorSwatch<int> omarchyWhiteLight = ColorSwatch<int>(
    0xff6e6e6e,
    <int, Color>{
      50: Color(0xFFF7F7F7),
      100: Color(0xFFECECEC),
      200: Color(0xFFD9D9D9),
      300: Color(0xFFC1C1C1),
      400: Color(0xFFA0A0A0),
      500: Color(0xFF878787),
      600: Color(0xFF6E6E6E),
      700: Color(0xFF5C5C5C),
      800: Color(0xFF4A4A4A),
      900: Color(0xFF3B3B3B),
      950: Color(0xFF262626),
    },
  );

  static const ColorSwatch<int> omarchyWhiteDark = ColorSwatch<int>(
    0xff878787,
    <int, Color>{
      50: Color(0xFFF7F7F7),
      100: Color(0xFFEFEFEF),
      200: Color(0xFFE1E1E1),
      300: Color(0xFFD0D0D0),
      400: Color(0xFFB8B8B8),
      500: Color(0xFFA5A5A5),
      600: Color(0xFF878787),
      700: Color(0xFF6E6E6E),
      800: Color(0xFF565656),
      900: Color(0xFF424242),
      950: Color(0xFF262626),
    },
  );

  static const ColorSwatch<int> macos27Light = ColorSwatch<int>(
    0xff0088ff,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE4F0FF),
      200: Color(0xFFCCE2FD),
      300: Color(0xFFABD0FE),
      400: Color(0xFF7CB6FD),
      500: Color(0xFF58A0F7),
      600: Color(0xFF0088FF),
      700: Color(0xFF0F6FCE),
      800: Color(0xFF12579F),
      900: Color(0xFF09437E),
      950: Color(0xFF03264C),
    },
  );

  static const ColorSwatch<int> macos27Dark = ColorSwatch<int>(
    0xff1b79ce,
    <int, Color>{
      50: Color(0xFFF2F7FE),
      100: Color(0xFFE1EFFE),
      200: Color(0xFFC4DFFD),
      300: Color(0xFF9CCAFE),
      400: Color(0xFF60ACFC),
      500: Color(0xFF0091FF),
      600: Color(0xFF1B79CE),
      700: Color(0xFF0763B0),
      800: Color(0xFF10508A),
      900: Color(0xFF0B3F6F),
      950: Color(0xFF02274A),
    },
  );

  static const ColorSwatch<int> macos15Light = ColorSwatch<int>(
    0xff007aff,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE4EFFE),
      200: Color(0xFFCBDFFD),
      300: Color(0xFFA8CCFE),
      400: Color(0xFF77AEFD),
      500: Color(0xFF5396F6),
      600: Color(0xFF007AFF),
      700: Color(0xFF0E65CE),
      800: Color(0xFF1250A1),
      900: Color(0xFF0A3E80),
      950: Color(0xFF002454),
    },
  );

  static const ColorSwatch<int> macos15Dark = ColorSwatch<int>(
    0xff1c6fcf,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE1EEFF),
      200: Color(0xFFC2DCFE),
      300: Color(0xFF99C5FE),
      400: Color(0xFF5DA2FC),
      500: Color(0xFF0A84FF),
      600: Color(0xFF1C6FCF),
      700: Color(0xFF0D5CB1),
      800: Color(0xFF024993),
      900: Color(0xFF033A77),
      950: Color(0xFF04264D),
    },
  );

  static const ColorSwatch<int> windows11Light = ColorSwatch<int>(
    0xff005fb8,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFDEEDFF),
      200: Color(0xFFBDD9FD),
      300: Color(0xFF8FBFFC),
      400: Color(0xFF559AEE),
      500: Color(0xFF2C7CD7),
      600: Color(0xFF005FB8),
      700: Color(0xFF0E5198),
      800: Color(0xFF084380),
      900: Color(0xFF08376A),
      950: Color(0xFF05264C),
    },
  );

  static const ColorSwatch<int> windows11Dark = ColorSwatch<int>(
    0xff35a8d8,
    <int, Color>{
      50: Color(0xFFEDF9FF),
      100: Color(0xFFE4F5FE),
      200: Color(0xFFCFEEFF),
      300: Color(0xFFB3E5FF),
      400: Color(0xFF8ED7FC),
      500: Color(0xFF60CDFF),
      600: Color(0xFF35A8D8),
      700: Color(0xFF1888B3),
      800: Color(0xFF166889),
      900: Color(0xFF084F69),
      950: Color(0xFF062A3A),
    },
  );

  static const ColorSwatch<int> ubuntuLight = ColorSwatch<int>(
    0xffe95420,
    <int, Color>{
      50: Color(0xFFFFF4F1),
      100: Color(0xFFFEEAE4),
      200: Color(0xFFFDD6CA),
      300: Color(0xFFFDBCA8),
      400: Color(0xFFF99678),
      500: Color(0xFFF87248),
      600: Color(0xFFE95420),
      700: Color(0xFFC33D06),
      800: Color(0xFF97320D),
      900: Color(0xFF772304),
      950: Color(0xFF471101),
    },
  );

  static const ColorSwatch<int> ubuntuDark = ColorSwatch<int>(
    0xffc54313,
    <int, Color>{
      50: Color(0xFFFFF4F1),
      100: Color(0xFFFDE7E1),
      200: Color(0xFFFECFC0),
      300: Color(0xFFFDAE96),
      400: Color(0xFFFD774D),
      500: Color(0xFFE95420),
      600: Color(0xFFC54313),
      700: Color(0xFFA73201),
      800: Color(0xFF842B0B),
      900: Color(0xFF6B2108),
      950: Color(0xFF471101),
    },
  );

  static const ColorSwatch<int> debianLight = ColorSwatch<int>(
    0xff3584e4,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE4EFFF),
      200: Color(0xFFCAE1FF),
      300: Color(0xFFAACDFC),
      400: Color(0xFF7AB2FA),
      500: Color(0xFF4C9AFC),
      600: Color(0xFF3584E4),
      700: Color(0xFF236BC1),
      800: Color(0xFF13539D),
      900: Color(0xFF0B407D),
      950: Color(0xFF05264D),
    },
  );

  static const ColorSwatch<int> debianDark = ColorSwatch<int>(
    0xff1a6dcb,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE0EDFE),
      200: Color(0xFFC1DBFC),
      300: Color(0xFF98C3FC),
      400: Color(0xFF5BA0F8),
      500: Color(0xFF3584E4),
      600: Color(0xFF1A6DCB),
      700: Color(0xFF0B5AAE),
      800: Color(0xFF024891),
      900: Color(0xFF033A75),
      950: Color(0xFF05264D),
    },
  );

  static const ColorSwatch<int> fedoraLight = ColorSwatch<int>(
    0xff3584e4,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE4EFFF),
      200: Color(0xFFCAE1FF),
      300: Color(0xFFAACDFC),
      400: Color(0xFF7AB2FA),
      500: Color(0xFF4C9AFC),
      600: Color(0xFF3584E4),
      700: Color(0xFF236BC1),
      800: Color(0xFF13539D),
      900: Color(0xFF0B407D),
      950: Color(0xFF05264D),
    },
  );

  static const ColorSwatch<int> fedoraDark = ColorSwatch<int>(
    0xff1a6dcb,
    <int, Color>{
      50: Color(0xFFF2F7FF),
      100: Color(0xFFE0EDFE),
      200: Color(0xFFC1DBFC),
      300: Color(0xFF98C3FC),
      400: Color(0xFF5BA0F8),
      500: Color(0xFF3584E4),
      600: Color(0xFF1A6DCB),
      700: Color(0xFF0B5AAE),
      800: Color(0xFF024891),
      900: Color(0xFF033A75),
      950: Color(0xFF05264D),
    },
  );

  static const ColorSwatch<int> kdeLight = ColorSwatch<int>(
    0xff3daee9,
    <int, Color>{
      50: Color(0xFFEFF8FE),
      100: Color(0xFFE2F3FF),
      200: Color(0xFFCBEAFE),
      300: Color(0xFFADDEFD),
      400: Color(0xFF7ACDFE),
      500: Color(0xFF50BEFA),
      600: Color(0xFF3DAEE9),
      700: Color(0xFF1073A1),
      800: Color(0xFF1B6B93),
      900: Color(0xFF0B5070),
      950: Color(0xFF052A3D),
    },
  );

  static const ColorSwatch<int> kdeDark = ColorSwatch<int>(
    0xff0890c9,
    <int, Color>{
      50: Color(0xFFEFF8FE),
      100: Color(0xFFDFF2FF),
      200: Color(0xFFC4E7FD),
      300: Color(0xFF9AD8FE),
      400: Color(0xFF63C1F7),
      500: Color(0xFF3DAEE9),
      600: Color(0xFF0890C9),
      700: Color(0xFF1475A3),
      800: Color(0xFF165C7F),
      900: Color(0xFF0D4764),
      950: Color(0xFF052A3D),
    },
  );
}
