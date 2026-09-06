import 'package:flutter/widgets.dart';
import '../foundation/color_descriptor.dart';
import 'colors.dart';

/// Design tokens generated from Terrazzo
/// DO NOT EDIT - This file is auto-generated
class ThemeVariables {
  const ThemeVariables({
    this.colorPrimary = Colors.brand,
    this.colorNeutral = Colors.neutral,
    this.colorInfo = Colors.sky,
    this.colorSuccess = Colors.green,
    this.colorWarning = Colors.amber,
    this.colorDanger = Colors.red,
    this.colorCanvas = const Color(0xFFEEECF6),
    this.colorSurface = const Color(0xFFFFFFFF),
    this.colorSurfaceMuted = const Color(0xFFF7F7FA),
    this.colorSurfaceSunken = const Color(0xFFE3E3EC),
    this.colorSurfaceSubtle = const Color(0xFFF5F5F9),
    this.colorSurfaceInset = const Color(0xFFF0F0F5),
    this.colorSurfaceRaised = const Color(0xFFFFFFFF),
    this.colorSurfaceChrome = const Color(0xFFF7F7FA),
    this.colorContent = const Color(0xFF12142A),
    this.colorContentSecondary = const Color(0xFF3C405C),
    this.colorContentNav = const Color(0xFF4A4F6B),
    this.colorContentMuted = const Color(0xFF565B78),
    this.colorContentSubtle = const Color(0xFF8C92AA),
    this.colorContentFaint = const Color(0xFFA2A7BD),
    this.colorBorder = const Color(0x1214162A),
    this.colorBorderStrong = const Color(0x1A14162A),
    this.colorBorderMuted = const Color(0xFFCFD2DE),
    this.colorOnAccent = const Color(0xFFFFFFFF),
    this.shadow2xs = const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
        color: Color(0x1A000000),
      ),
    ],
    this.shadowXs = const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
        color: Color(0x1F000000),
      ),
    ],
    this.shadowSm = const [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
        color: Color(0x24000000),
      ),
    ],
    this.shadowMd = const [
      BoxShadow(
        offset: Offset(0, 8),
        blurRadius: 24,
        spreadRadius: 0,
        color: Color(0x33000000),
      ),
    ],
    this.shadowLg = const [
      BoxShadow(
        offset: Offset(0, 10),
        blurRadius: 30,
        spreadRadius: 0,
        color: Color(0x38000000),
      ),
    ],
    this.shadowXl = const [
      BoxShadow(
        offset: Offset(0, 12),
        blurRadius: 32,
        spreadRadius: 0,
        color: Color(0x3D000000),
      ),
    ],
    this.shadow2xl = const [
      BoxShadow(
        offset: Offset(0, 24),
        blurRadius: 56,
        spreadRadius: 0,
        color: Color(0x47000000),
      ),
    ],
    this.focusWidth = 3,
    this.focusOffset = 0,
    this.focusGlowShade = 600,
    this.focusGlowAlpha = 0.14,
    this.focusRingShade = 600,
    this.focusRingAlpha = 0.45,
    this.frameWindowRadius = 18,
    this.framePopoverRadius = 16,
    this.frameTitlebarSize = 52,
    this.frameSidebarWidth = 172,
    this.frameRailWidth = 150,
    this.frameAsideWidth = 214,
    this.frameNavGap = 3,
    this.motionDuration = const Duration(microseconds: 150000),
    this.motionEasing = const Cubic(0.4, 0, 0.2, 1),
    this.radiusNone = 0,
    this.radiusTiny = 7,
    this.radiusSmall = 8,
    this.radiusMedium = 10,
    this.radiusLarge = 12,
    this.radiusBig = 16,
    this.radiusFull = 9999,
    this.spacingPx = 1,
    this.spacing0 = 0,
    this.spacing05 = 2,
    this.spacing1 = 4,
    this.spacing15 = 6,
    this.spacing2 = 8,
    this.spacing25 = 10,
    this.spacing3 = 12,
    this.spacing35 = 14,
    this.spacing4 = 16,
    this.spacing5 = 20,
    this.spacing6 = 24,
    this.spacing7 = 28,
    this.spacing8 = 32,
    this.spacing9 = 36,
    this.spacing10 = 40,
    this.spacing11 = 44,
    this.spacing12 = 48,
    this.spacing14 = 56,
    this.spacing16 = 64,
    this.spacing20 = 80,
    this.strokeHairline = 1,
    this.strokeControl = 1.5,
    this.washSurface = 0.06,
    this.washEdge = 0.2,
    this.controlColorRecessedBorder = const ColorDescriptor(
      normalColor: Colors.transparent,
      hoveredColor: Colors.transparent,
      pressedColor: Colors.transparent,
      disabledColor: Colors.transparent,
    ),
    this.controlColorFilledSurfaceNormalShade = 600,
    this.controlColorFilledSurfaceHoveredShade = 700,
    this.controlColorFilledSurfacePressedShade = 700,
    this.controlColorFilledBorder = const ColorDescriptor(
      normalColor: Colors.transparent,
      hoveredColor: Colors.transparent,
      pressedColor: Colors.transparent,
      disabledColor: Colors.transparent,
    ),
    this.controlColorTintedContentNormalShade = 700,
    this.controlColorTintedContentHoveredShade = 800,
    this.controlColorTintedContentPressedShade = 800,
    this.controlColorTintedBorder = const ColorDescriptor(
      normalColor: Colors.transparent,
      hoveredColor: Colors.transparent,
      pressedColor: Colors.transparent,
      disabledColor: Colors.transparent,
    ),
    this.controlColorOutlinedContentNormalShade = 700,
    this.controlColorOutlinedContentHoveredShade = 800,
    this.controlColorOutlinedContentPressedShade = 800,
    this.controlColorOutlinedBorder = const ColorDescriptor(
      normalShade: 600,
      normalOpacity: 1.0,
      hoveredShade: 700,
      hoveredOpacity: 1.0,
      pressedShade: 700,
      pressedOpacity: 0.9,
      disabledColor: Colors.transparent,
    ),
    this.controlColorPlainSurface = const ColorDescriptor(
      normalColor: Colors.transparent,
      hoveredShade: 600,
      hoveredOpacity: 0.08,
      pressedShade: 600,
      pressedOpacity: 0.12,
      disabledColor: Colors.transparent,
    ),
    this.controlColorPlainContentNormalShade = 700,
    this.controlColorPlainContentHoveredShade = 800,
    this.controlColorPlainContentPressedShade = 800,
    this.controlColorPlainBorder = const ColorDescriptor(
      normalColor: Colors.transparent,
      hoveredColor: Colors.transparent,
      pressedColor: Colors.transparent,
      disabledColor: Colors.transparent,
    ),
    this.controlPressedAlpha = 0.9,
    this.controlTinySize = 24,
    this.controlSmallSize = 26,
    this.controlMediumSize = 28,
    this.controlLargeSize = 32,
    this.checkboxRadius = 5,
    this.dialogWidth = 440,
    this.dialogScrimAlpha = 0.25,
    this.menuMinWidth = 176,
    this.menuItemPadding = 7,
    this.progressGradientFrom = const Color(0xFF6B4DFF),
    this.progressGradientTo = const Color(0xFFA08CFF),
    this.segmentedControlInset = 3,
    this.shortcutRecorderWidth = 132,
    this.switchMediumWidth = 32,
    this.switchMediumHeight = 18,
    this.switchMediumThumb = 14,
    this.toastMaxWidth = 420,
  });

  // #region Global

  // Color
  final ColorSwatch<int> colorPrimary;
  final ColorSwatch<int> colorNeutral;
  final ColorSwatch<int> colorInfo;
  final ColorSwatch<int> colorSuccess;
  final ColorSwatch<int> colorWarning;
  final ColorSwatch<int> colorDanger;
  final Color colorCanvas;
  final Color colorSurface;
  final Color colorSurfaceMuted;
  final Color colorSurfaceSunken;
  final Color colorSurfaceSubtle;
  final Color colorSurfaceInset;
  final Color colorSurfaceRaised;
  final Color colorSurfaceChrome;
  final Color colorContent;
  final Color colorContentSecondary;
  final Color colorContentNav;
  final Color colorContentMuted;
  final Color colorContentSubtle;
  final Color colorContentFaint;
  final Color colorBorder;
  final Color colorBorderStrong;
  final Color colorBorderMuted;
  final Color colorOnAccent;

  // Control

  // Effect
  final List<BoxShadow> shadow2xs;
  final List<BoxShadow> shadowXs;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;
  final List<BoxShadow> shadowXl;
  final List<BoxShadow> shadow2xl;

  // Focus
  final double focusWidth;
  final double focusOffset;
  final int focusGlowShade;
  final double focusGlowAlpha;
  final int focusRingShade;
  final double focusRingAlpha;

  // Frame
  final double frameWindowRadius;
  final double framePopoverRadius;
  final double frameTitlebarSize;
  final double frameSidebarWidth;
  final double frameRailWidth;
  final double frameAsideWidth;
  final double frameNavGap;

  // Motion
  final Duration motionDuration;
  final Cubic motionEasing;

  // Radius
  final double radiusNone;
  final double radiusTiny;
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final double radiusBig;
  final double radiusFull;

  // Spacing
  final double spacingPx;
  final double spacing0;
  final double spacing05;
  final double spacing1;
  final double spacing15;
  final double spacing2;
  final double spacing25;
  final double spacing3;
  final double spacing35;
  final double spacing4;
  final double spacing5;
  final double spacing6;
  final double spacing7;
  final double spacing8;
  final double spacing9;
  final double spacing10;
  final double spacing11;
  final double spacing12;
  final double spacing14;
  final double spacing16;
  final double spacing20;

  // Stroke
  final double strokeHairline;
  final double strokeControl;

  // Typography
  TextStyle get headlineSmall => TextStyle(
    fontFamilyFallback: const ['SF Pro Display', 'PingFang SC'],
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 26 / 20,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get headlineMedium => TextStyle(
    fontFamilyFallback: const ['SF Pro Display', 'PingFang SC'],
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 30 / 24,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get headlineLarge => TextStyle(
    fontFamilyFallback: const ['SF Pro Display', 'PingFang SC'],
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 34 / 28,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleSmall => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 20 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleMedium => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 22 / 15,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleLarge => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 22 / 17,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodySmall => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodyMedium => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodyLarge => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 22 / 15,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelQuiet => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 12 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelStrong => TextStyle(
    fontFamilyFallback: const ['SF Pro Display', 'PingFang SC'],
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 12 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelSmall => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 11 / 11,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelMedium => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 12 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelLarge => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 13 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get captionSmall => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 14 / 11,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get captionMedium => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get captionLarge => TextStyle(
    fontFamilyFallback: const ['SF Pro Text', 'PingFang SC'],
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Wash
  final double washSurface;
  final double washEdge;

  // Control
  ColorDescriptor get controlColorNormalSurface => ColorDescriptor(
    normalColor: colorSurface,
    hoveredColor: colorSurfaceSubtle,
    pressedColor: colorSurfaceSubtle,
    pressedOpacity: 0.9,
    disabledColor: colorSurfaceSunken,
  );
  ColorDescriptor get controlColorNormalContent => ColorDescriptor(
    normalColor: colorContent,
    hoveredColor: colorContent,
    pressedColor: colorContent,
    pressedOpacity: 0.9,
    disabledColor: colorContentFaint,
  );
  ColorDescriptor get controlColorNormalBorder => ColorDescriptor(
    normalColor: colorBorderStrong,
    hoveredColor: colorBorderStrong,
    pressedColor: colorBorderStrong,
    pressedOpacity: 0.9,
    disabledColor: Colors.transparent,
  );
  ColorDescriptor get controlColorRecessedSurface => ColorDescriptor(
    normalColor: colorSurfaceInset,
    hoveredColor: colorSurfaceSunken,
    pressedColor: colorSurfaceSunken,
    pressedOpacity: 0.9,
    disabledColor: colorSurfaceSunken,
  );
  ColorDescriptor get controlColorRecessedContent => ColorDescriptor(
    normalColor: colorContent,
    hoveredColor: colorContent,
    pressedColor: colorContent,
    pressedOpacity: 0.9,
    disabledColor: colorContentFaint,
  );
  final ColorDescriptor controlColorRecessedBorder;

  /// The ramp step `controlColorFilledSurface` picks when normal; a theme re-points it.
  final int controlColorFilledSurfaceNormalShade;

  /// The ramp step `controlColorFilledSurface` picks when hovered; a theme re-points it.
  final int controlColorFilledSurfaceHoveredShade;

  /// The ramp step `controlColorFilledSurface` picks when pressed; a theme re-points it.
  final int controlColorFilledSurfacePressedShade;
  ColorDescriptor get controlColorFilledSurface => ColorDescriptor(
    normalShade: controlColorFilledSurfaceNormalShade,
    normalOpacity: 1.0,
    hoveredShade: controlColorFilledSurfaceHoveredShade,
    hoveredOpacity: 1.0,
    pressedShade: controlColorFilledSurfacePressedShade,
    pressedOpacity: 0.9,
    disabledColor: colorSurfaceSunken,
  );
  ColorDescriptor get controlColorFilledContent => ColorDescriptor(
    normalColor: colorOnAccent,
    hoveredColor: colorOnAccent,
    pressedColor: colorOnAccent,
    pressedOpacity: 0.9,
    disabledColor: colorContentFaint,
  );
  final ColorDescriptor controlColorFilledBorder;
  ColorDescriptor get controlColorTintedSurface => ColorDescriptor(
    normalShade: 600,
    normalOpacity: 0.12,
    hoveredShade: 600,
    hoveredOpacity: 0.2,
    pressedShade: 600,
    pressedOpacity: 0.24,
    disabledColor: colorSurfaceSunken,
  );

  /// The ramp step `controlColorTintedContent` picks when normal; a theme re-points it.
  final int controlColorTintedContentNormalShade;

  /// The ramp step `controlColorTintedContent` picks when hovered; a theme re-points it.
  final int controlColorTintedContentHoveredShade;

  /// The ramp step `controlColorTintedContent` picks when pressed; a theme re-points it.
  final int controlColorTintedContentPressedShade;
  ColorDescriptor get controlColorTintedContent => ColorDescriptor(
    normalShade: controlColorTintedContentNormalShade,
    normalOpacity: 1.0,
    hoveredShade: controlColorTintedContentHoveredShade,
    hoveredOpacity: 1.0,
    pressedShade: controlColorTintedContentPressedShade,
    pressedOpacity: 0.9,
    disabledColor: colorContentFaint,
  );
  final ColorDescriptor controlColorTintedBorder;
  ColorDescriptor get controlColorOutlinedSurface => ColorDescriptor(
    normalColor: Colors.transparent,
    hoveredShade: 600,
    hoveredOpacity: 0.08,
    pressedShade: 600,
    pressedOpacity: 0.12,
    disabledColor: colorSurfaceSunken,
  );

  /// The ramp step `controlColorOutlinedContent` picks when normal; a theme re-points it.
  final int controlColorOutlinedContentNormalShade;

  /// The ramp step `controlColorOutlinedContent` picks when hovered; a theme re-points it.
  final int controlColorOutlinedContentHoveredShade;

  /// The ramp step `controlColorOutlinedContent` picks when pressed; a theme re-points it.
  final int controlColorOutlinedContentPressedShade;
  ColorDescriptor get controlColorOutlinedContent => ColorDescriptor(
    normalShade: controlColorOutlinedContentNormalShade,
    normalOpacity: 1.0,
    hoveredShade: controlColorOutlinedContentHoveredShade,
    hoveredOpacity: 1.0,
    pressedShade: controlColorOutlinedContentPressedShade,
    pressedOpacity: 0.9,
    disabledColor: colorContentFaint,
  );
  final ColorDescriptor controlColorOutlinedBorder;
  final ColorDescriptor controlColorPlainSurface;

  /// The ramp step `controlColorPlainContent` picks when normal; a theme re-points it.
  final int controlColorPlainContentNormalShade;

  /// The ramp step `controlColorPlainContent` picks when hovered; a theme re-points it.
  final int controlColorPlainContentHoveredShade;

  /// The ramp step `controlColorPlainContent` picks when pressed; a theme re-points it.
  final int controlColorPlainContentPressedShade;
  ColorDescriptor get controlColorPlainContent => ColorDescriptor(
    normalShade: controlColorPlainContentNormalShade,
    normalOpacity: 1.0,
    hoveredShade: controlColorPlainContentHoveredShade,
    hoveredOpacity: 1.0,
    pressedShade: controlColorPlainContentPressedShade,
    pressedOpacity: 0.9,
    disabledColor: colorContentFaint,
  );
  final ColorDescriptor controlColorPlainBorder;
  final double controlPressedAlpha;
  double get controlTinyGap => spacing1;
  double get controlTinyPaddingBlock => spacing1;
  double get controlTinyPaddingInline => spacing25;
  final double controlTinySize;
  double get controlTinyRadius => radiusSmall;
  TextStyle get controlTinyContent => labelSmall;
  double get controlSmallGap => spacing15;
  double get controlSmallPaddingBlock => spacing1;
  double get controlSmallPaddingInline => spacing3;
  final double controlSmallSize;
  double get controlSmallRadius => radiusSmall;
  TextStyle get controlSmallContent => labelMedium;
  double get controlMediumGap => spacing2;
  double get controlMediumPaddingBlock => spacing15;
  double get controlMediumPaddingInline => spacing4;
  final double controlMediumSize;
  double get controlMediumRadius => radiusSmall;
  TextStyle get controlMediumContent => labelMedium;
  double get controlLargeGap => spacing2;
  double get controlLargePaddingBlock => spacing15;
  double get controlLargePaddingInline => spacing4;
  final double controlLargeSize;
  double get controlLargeRadius => radiusMedium;
  TextStyle get controlLargeContent => labelMedium;

  // #endregion

  // #region Component

  // Checkbox
  double get checkboxThickness => strokeControl;
  final double checkboxRadius;
  double get checkboxSmallBox => spacing35;
  double get checkboxMediumBox => spacing4;
  double get checkboxLargeBox => spacing5;

  // Dialog
  final double dialogWidth;
  Color get dialogScrimColor => colorContent;
  final double dialogScrimAlpha;

  // Menu
  final double menuMinWidth;
  final double menuItemPadding;

  // Progress
  final Color progressGradientFrom;
  final Color progressGradientTo;

  // Radio
  double get radioThickness => strokeControl;
  double get radioSmallBox => spacing35;
  double get radioSmallDot => spacing15;
  double get radioMediumBox => spacing4;
  double get radioMediumDot => spacing2;
  double get radioLargeBox => spacing5;
  double get radioLargeDot => spacing25;

  // Segmented Control
  final double segmentedControlInset;

  // Shortcut Recorder
  final double shortcutRecorderWidth;

  // Switch
  double get switchSmallWidth => spacing7;
  double get switchSmallHeight => spacing4;
  double get switchSmallThumb => spacing3;
  final double switchMediumWidth;
  final double switchMediumHeight;
  final double switchMediumThumb;
  double get switchLargeWidth => spacing11;
  double get switchLargeHeight => spacing6;
  double get switchLargeThumb => spacing5;

  // Toast
  final double toastMaxWidth;

  // #endregion
}

/// Global instance of ThemeVariables
const themeVariables = ThemeVariables();

/// The `bright-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesBrightLight = ThemeVariables(
  colorCanvas: Color(0xFFE6EADE),
  colorSurface: Color(0xFFFBFAF7),
  colorSurfaceMuted: Color(0xFFF6F5F1),
  colorSurfaceSunken: Color(0xFFE5E3DB),
  colorSurfaceSubtle: Color(0xFFF6F5F1),
  colorSurfaceInset: Color(0xFFF0EFE9),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceChrome: Color(0xFFFFFFFF),
  colorContent: Color(0xFF111C2E),
  colorContentSecondary: Color(0xC7111C2E),
  colorContentNav: Color(0xB3111C2E),
  colorContentMuted: Color(0xA8111C2E),
  colorContentSubtle: Color(0x73111C2E),
  colorContentFaint: Color(0x61111C2E),
  colorBorder: Color(0x14111C2E),
  colorBorderStrong: Color(0x1F111C2E),
  colorBorderMuted: Color(0x40111C2E),
  colorOnAccent: Color(0xFFD6FF3F),
  shadow2xs: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: Color(0x1F111C2E),
    ),
  ],
  shadowXs: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
      color: Color(0x24111C2E),
    ),
  ],
  shadowSm: [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
      color: Color(0x24111C2E),
    ),
  ],
  shadowMd: [
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
      color: Color(0x2E111C2E),
    ),
  ],
  shadowLg: [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 30,
      spreadRadius: 0,
      color: Color(0x2E111C2E),
    ),
  ],
  shadowXl: [
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: 0,
      color: Color(0x33111C2E),
    ),
  ],
  shadow2xl: [
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 56,
      spreadRadius: 0,
      color: Color(0x3D111C2E),
    ),
  ],
  frameWindowRadius: 16,
  framePopoverRadius: 14,
  radiusSmall: 9999,
  radiusMedium: 9999,
  radiusBig: 14,
  progressGradientFrom: Color(0xFF111C2E),
  progressGradientTo: Color(0xFFD6FF3F),
  colorPrimary: Colors.ink,
);

/// The `bright-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesBrightDark = ThemeVariables(
  colorCanvas: Color(0xFF0A111A),
  colorSurface: Color(0xFF0C141E),
  colorSurfaceMuted: Color(0xFF141D29),
  colorSurfaceSunken: Color(0xFF1C2734),
  colorSurfaceSubtle: Color(0xFF101923),
  colorSurfaceInset: Color(0xFF16202C),
  colorSurfaceRaised: Color(0xFF2A3644),
  colorSurfaceChrome: Color(0xFF111A26),
  colorContent: Color(0xFFF2F4EF),
  colorContentSecondary: Color(0xC7F2F4EF),
  colorContentNav: Color(0xB3F2F4EF),
  colorContentMuted: Color(0xA8F2F4EF),
  colorContentSubtle: Color(0x73F2F4EF),
  colorContentFaint: Color(0x61F2F4EF),
  colorBorder: Color(0x14F2F4EF),
  colorBorderStrong: Color(0x24F2F4EF),
  colorBorderMuted: Color(0xFF35414F),
  colorOnAccent: Color(0xFF111C2E),
  shadow2xs: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: Color(0x66000000),
    ),
  ],
  shadowXs: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
      color: Color(0x73000000),
    ),
  ],
  shadowSm: [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 14,
      spreadRadius: 0,
      color: Color(0x73000000),
    ),
  ],
  shadowMd: [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 28,
      spreadRadius: 0,
      color: Color(0x8C000000),
    ),
  ],
  shadowLg: [
    BoxShadow(
      offset: Offset(0, 14),
      blurRadius: 36,
      spreadRadius: 0,
      color: Color(0x94000000),
    ),
  ],
  shadowXl: [
    BoxShadow(
      offset: Offset(0, 16),
      blurRadius: 40,
      spreadRadius: 0,
      color: Color(0x99000000),
    ),
  ],
  shadow2xl: [
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 64,
      spreadRadius: 0,
      color: Color(0xB3000000),
    ),
  ],
  focusRingAlpha: 0.55,
  frameWindowRadius: 16,
  framePopoverRadius: 14,
  radiusSmall: 9999,
  radiusMedium: 9999,
  radiusBig: 14,
  progressGradientFrom: Color(0xFFD6FF3F),
  progressGradientTo: Color(0xFFD6FF3F),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.acid,
  colorSuccess: Colors.greenDark,
  colorWarning: Colors.amberDark,
  controlColorFilledSurfaceNormalShade: 500,
  controlColorFilledSurfaceHoveredShade: 600,
  controlColorFilledSurfacePressedShade: 600,
  controlColorOutlinedBorder: ColorDescriptor(
    normalShade: 400,
    normalOpacity: 1.0,
    hoveredShade: 300,
    hoveredOpacity: 1.0,
    pressedShade: 300,
    pressedOpacity: 0.9,
  ),
  controlColorOutlinedContentNormalShade: 300,
  controlColorOutlinedContentHoveredShade: 200,
  controlColorOutlinedContentPressedShade: 200,
  controlColorPlainContentNormalShade: 300,
  controlColorPlainContentHoveredShade: 200,
  controlColorPlainContentPressedShade: 200,
  controlColorTintedContentNormalShade: 300,
  controlColorTintedContentHoveredShade: 200,
  controlColorTintedContentPressedShade: 200,
);

/// The `studio-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesStudioDark = ThemeVariables(
  colorCanvas: Color(0xFF0A0B10),
  colorSurface: Color(0xFF0D0F14),
  colorSurfaceMuted: Color(0xFF12141A),
  colorSurfaceSunken: Color(0xFF262A34),
  colorSurfaceSubtle: Color(0xFF151821),
  colorSurfaceInset: Color(0xFF1B1E26),
  colorSurfaceRaised: Color(0xFF3A3F4D),
  colorSurfaceChrome: Color(0xFF12141A),
  colorContent: Color(0xFFF2F3FA),
  colorContentSecondary: Color(0xFFC3C8DC),
  colorContentNav: Color(0xFF9AA1BB),
  colorContentMuted: Color(0xFF9AA1BB),
  colorContentSubtle: Color(0xFF8B93B0),
  colorContentFaint: Color(0xFF6A7090),
  colorBorder: Color(0x0FFFFFFF),
  colorBorderStrong: Color(0x1AFFFFFF),
  colorBorderMuted: Color(0xFF363C4D),
  shadow2xs: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: Color(0x66000000),
    ),
  ],
  shadowXs: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
      color: Color(0x73000000),
    ),
  ],
  shadowSm: [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 14,
      spreadRadius: 0,
      color: Color(0x73000000),
    ),
  ],
  shadowMd: [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 28,
      spreadRadius: 0,
      color: Color(0x8C000000),
    ),
  ],
  shadowLg: [
    BoxShadow(
      offset: Offset(0, 14),
      blurRadius: 36,
      spreadRadius: 0,
      color: Color(0x94000000),
    ),
  ],
  shadowXl: [
    BoxShadow(
      offset: Offset(0, 16),
      blurRadius: 40,
      spreadRadius: 0,
      color: Color(0x99000000),
    ),
  ],
  shadow2xl: [
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 64,
      spreadRadius: 0,
      color: Color(0xB3000000),
    ),
  ],
  focusRingAlpha: 0.5,
  progressGradientFrom: Color(0xFF7C5CFF),
  progressGradientTo: Color(0xFFB9A8FF),
  colorDanger: Colors.redDark,
  colorSuccess: Colors.greenDark,
  colorWarning: Colors.amberDark,
  controlColorFilledSurfaceNormalShade: 500,
  controlColorFilledSurfaceHoveredShade: 600,
  controlColorFilledSurfacePressedShade: 600,
  controlColorOutlinedBorder: ColorDescriptor(
    normalShade: 400,
    normalOpacity: 1.0,
    hoveredShade: 300,
    hoveredOpacity: 1.0,
    pressedShade: 300,
    pressedOpacity: 0.9,
  ),
  controlColorOutlinedContentNormalShade: 300,
  controlColorOutlinedContentHoveredShade: 200,
  controlColorOutlinedContentPressedShade: 200,
  controlColorPlainContentNormalShade: 300,
  controlColorPlainContentHoveredShade: 200,
  controlColorPlainContentPressedShade: 200,
  controlColorTintedContentNormalShade: 300,
  controlColorTintedContentHoveredShade: 200,
  controlColorTintedContentPressedShade: 200,
);
