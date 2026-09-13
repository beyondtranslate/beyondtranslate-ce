import 'package:flutter/widgets.dart';
import '../foundation/color_descriptor.dart';
import '../foundation/font_face.dart';
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
    this.colorSurfaceSubtle = const Color(0x0F14162A),
    this.colorSurfaceInset = const Color(0xFFF0F0F5),
    this.colorSurfaceRaised = const Color(0xFFFFFFFF),
    this.colorSurfaceOverlay = const Color(0xFFFFFFFF),
    this.colorSurfaceChrome = const Color(0xFFF7F7FA),
    this.colorSurfaceColumn = const Color(0xFFFAFAFC),
    this.colorContent = const Color(0xFF12142A),
    this.colorContentSecondary = const Color(0xFF3C405C),
    this.colorContentNav = const Color(0xFF4A4F6B),
    this.colorContentMuted = const Color(0xFF565B78),
    this.colorContentSubtle = const Color(0xFF8C92AA),
    this.colorContentFaint = const Color(0xFFA2A7BD),
    this.colorBorder = const Color(0x1214162A),
    this.colorBorderStrong = const Color(0x1714162A),
    this.colorBorderMuted = const Color(0xFF5F6478),
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
    this.frameSidebarIconWidth = 48,
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
    this.controlContainerRadius = 10,
    this.controlTinySize = 24,
    this.controlSmallSize = 26,
    this.controlMediumSize = 28,
    this.controlLargeSize = 32,
    this.checkboxRadius = 5,
    this.dialogWidth = 440,
    this.dialogScrimAlpha = 0.25,
    this.drawerSize = 352,
    this.menuMinWidth = 176,
    this.menuItemPadding = 7,
    this.preferencesWidth = 480,
    this.previewCardWidth = 320,
    this.progressGradientFrom = const Color(0xFF6B4DFF),
    this.progressGradientTo = const Color(0xFFA08CFF),
    this.segmentedControlInset = 3,
    this.shortcutRecorderWidth = 132,
    this.switchMediumWidth = 32,
    this.switchMediumHeight = 18,
    this.switchMediumThumb = 14,
    this.toastMaxWidth = 420,
    this.fontCode = const FontFace(family: 'SF Mono', fallback: ['Menlo']),
    this.fontDisplay = const FontFace(
      fallback: ['SF Pro Display', 'PingFang SC'],
    ),
    this.fontUi = const FontFace(fallback: ['SF Pro Text', 'PingFang SC']),
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
  final Color colorSurfaceOverlay;
  final Color colorSurfaceChrome;
  final Color colorSurfaceColumn;
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
  final double frameSidebarIconWidth;
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
    fontFamily: fontDisplay.family,
    fontFamilyFallback: fontDisplay.fallback,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 26 / 20,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get headlineMedium => TextStyle(
    fontFamily: fontDisplay.family,
    fontFamilyFallback: fontDisplay.fallback,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 30 / 24,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get headlineLarge => TextStyle(
    fontFamily: fontDisplay.family,
    fontFamilyFallback: fontDisplay.fallback,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 34 / 28,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleSmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 20 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 22 / 15,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get titleLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 22 / 17,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodySmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodyMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get bodyLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 22 / 15,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelQuiet => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 12 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelStrong => TextStyle(
    fontFamily: fontDisplay.family,
    fontFamilyFallback: fontDisplay.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 12 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelSmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 11 / 11,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 12 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get labelLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 13 / 13,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get captionSmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 14 / 11,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get captionMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );
  TextStyle get captionLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
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
  final double controlContainerRadius;
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

  // Drawer
  final double drawerSize;

  // Menu
  final double menuMinWidth;
  final double menuItemPadding;

  // Preferences
  final double preferencesWidth;
  double get preferencesRowPadding => spacing15;
  double get preferencesRowGap => spacing1;
  double get preferencesHeadingGap => spacing2;
  double get preferencesFooterGap => spacing1;
  double get preferencesTitleGap => spacing4;
  double get preferencesSectionGap => spacing6;
  double get preferencesGroupGap => spacing10;

  // Preview Card
  final double previewCardWidth;

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

  // Slider
  double get sliderSmallTrack => spacing1;
  double get sliderSmallThumb => spacing35;
  double get sliderMediumTrack => spacing15;
  double get sliderMediumThumb => spacing4;
  double get sliderLargeTrack => spacing2;
  double get sliderLargeThumb => spacing5;

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

  // Type faces

  /// The face `base.font.code` declares. Everything set in it reads this
  /// field — the type styles that name it, and the widgets that reach it
  /// directly — so a host re-points the face rather than each of them.
  final FontFace fontCode;

  /// The face `base.font.display` declares. Everything set in it reads this
  /// field — the type styles that name it, and the widgets that reach it
  /// directly — so a host re-points the face rather than each of them.
  final FontFace fontDisplay;

  /// The face `base.font.ui` declares. Everything set in it reads this
  /// field — the type styles that name it, and the widgets that reach it
  /// directly — so a host re-points the face rather than each of them.
  final FontFace fontUi;

  /// This theme with the named values replaced.
  ///
  /// Everything derived — the type styles, the interactive recipes — reads
  /// the fields of the instance it is called on, so re-pointing one value
  /// moves everything drawn from it.
  ThemeVariables copyWith({
    ColorSwatch<int>? colorPrimary,
    ColorSwatch<int>? colorNeutral,
    ColorSwatch<int>? colorInfo,
    ColorSwatch<int>? colorSuccess,
    ColorSwatch<int>? colorWarning,
    ColorSwatch<int>? colorDanger,
    Color? colorCanvas,
    Color? colorSurface,
    Color? colorSurfaceMuted,
    Color? colorSurfaceSunken,
    Color? colorSurfaceSubtle,
    Color? colorSurfaceInset,
    Color? colorSurfaceRaised,
    Color? colorSurfaceOverlay,
    Color? colorSurfaceChrome,
    Color? colorSurfaceColumn,
    Color? colorContent,
    Color? colorContentSecondary,
    Color? colorContentNav,
    Color? colorContentMuted,
    Color? colorContentSubtle,
    Color? colorContentFaint,
    Color? colorBorder,
    Color? colorBorderStrong,
    Color? colorBorderMuted,
    Color? colorOnAccent,
    List<BoxShadow>? shadow2xs,
    List<BoxShadow>? shadowXs,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
    List<BoxShadow>? shadowXl,
    List<BoxShadow>? shadow2xl,
    double? focusWidth,
    double? focusOffset,
    int? focusGlowShade,
    double? focusGlowAlpha,
    int? focusRingShade,
    double? focusRingAlpha,
    double? frameWindowRadius,
    double? framePopoverRadius,
    double? frameTitlebarSize,
    double? frameSidebarWidth,
    double? frameSidebarIconWidth,
    double? frameRailWidth,
    double? frameAsideWidth,
    double? frameNavGap,
    Duration? motionDuration,
    Cubic? motionEasing,
    double? radiusNone,
    double? radiusTiny,
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    double? radiusBig,
    double? radiusFull,
    double? spacingPx,
    double? spacing0,
    double? spacing05,
    double? spacing1,
    double? spacing15,
    double? spacing2,
    double? spacing25,
    double? spacing3,
    double? spacing35,
    double? spacing4,
    double? spacing5,
    double? spacing6,
    double? spacing7,
    double? spacing8,
    double? spacing9,
    double? spacing10,
    double? spacing11,
    double? spacing12,
    double? spacing14,
    double? spacing16,
    double? spacing20,
    double? strokeHairline,
    double? strokeControl,
    double? washSurface,
    double? washEdge,
    ColorDescriptor? controlColorRecessedBorder,
    int? controlColorFilledSurfaceNormalShade,
    int? controlColorFilledSurfaceHoveredShade,
    int? controlColorFilledSurfacePressedShade,
    ColorDescriptor? controlColorFilledBorder,
    int? controlColorTintedContentNormalShade,
    int? controlColorTintedContentHoveredShade,
    int? controlColorTintedContentPressedShade,
    ColorDescriptor? controlColorTintedBorder,
    int? controlColorOutlinedContentNormalShade,
    int? controlColorOutlinedContentHoveredShade,
    int? controlColorOutlinedContentPressedShade,
    ColorDescriptor? controlColorOutlinedBorder,
    ColorDescriptor? controlColorPlainSurface,
    int? controlColorPlainContentNormalShade,
    int? controlColorPlainContentHoveredShade,
    int? controlColorPlainContentPressedShade,
    ColorDescriptor? controlColorPlainBorder,
    double? controlPressedAlpha,
    double? controlContainerRadius,
    double? controlTinySize,
    double? controlSmallSize,
    double? controlMediumSize,
    double? controlLargeSize,
    double? checkboxRadius,
    double? dialogWidth,
    double? dialogScrimAlpha,
    double? drawerSize,
    double? menuMinWidth,
    double? menuItemPadding,
    double? preferencesWidth,
    double? previewCardWidth,
    Color? progressGradientFrom,
    Color? progressGradientTo,
    double? segmentedControlInset,
    double? shortcutRecorderWidth,
    double? switchMediumWidth,
    double? switchMediumHeight,
    double? switchMediumThumb,
    double? toastMaxWidth,
    FontFace? fontCode,
    FontFace? fontDisplay,
    FontFace? fontUi,
  }) {
    return ThemeVariables(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorNeutral: colorNeutral ?? this.colorNeutral,
      colorInfo: colorInfo ?? this.colorInfo,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorDanger: colorDanger ?? this.colorDanger,
      colorCanvas: colorCanvas ?? this.colorCanvas,
      colorSurface: colorSurface ?? this.colorSurface,
      colorSurfaceMuted: colorSurfaceMuted ?? this.colorSurfaceMuted,
      colorSurfaceSunken: colorSurfaceSunken ?? this.colorSurfaceSunken,
      colorSurfaceSubtle: colorSurfaceSubtle ?? this.colorSurfaceSubtle,
      colorSurfaceInset: colorSurfaceInset ?? this.colorSurfaceInset,
      colorSurfaceRaised: colorSurfaceRaised ?? this.colorSurfaceRaised,
      colorSurfaceOverlay: colorSurfaceOverlay ?? this.colorSurfaceOverlay,
      colorSurfaceChrome: colorSurfaceChrome ?? this.colorSurfaceChrome,
      colorSurfaceColumn: colorSurfaceColumn ?? this.colorSurfaceColumn,
      colorContent: colorContent ?? this.colorContent,
      colorContentSecondary:
          colorContentSecondary ?? this.colorContentSecondary,
      colorContentNav: colorContentNav ?? this.colorContentNav,
      colorContentMuted: colorContentMuted ?? this.colorContentMuted,
      colorContentSubtle: colorContentSubtle ?? this.colorContentSubtle,
      colorContentFaint: colorContentFaint ?? this.colorContentFaint,
      colorBorder: colorBorder ?? this.colorBorder,
      colorBorderStrong: colorBorderStrong ?? this.colorBorderStrong,
      colorBorderMuted: colorBorderMuted ?? this.colorBorderMuted,
      colorOnAccent: colorOnAccent ?? this.colorOnAccent,
      shadow2xs: shadow2xs ?? this.shadow2xs,
      shadowXs: shadowXs ?? this.shadowXs,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
      shadowXl: shadowXl ?? this.shadowXl,
      shadow2xl: shadow2xl ?? this.shadow2xl,
      focusWidth: focusWidth ?? this.focusWidth,
      focusOffset: focusOffset ?? this.focusOffset,
      focusGlowShade: focusGlowShade ?? this.focusGlowShade,
      focusGlowAlpha: focusGlowAlpha ?? this.focusGlowAlpha,
      focusRingShade: focusRingShade ?? this.focusRingShade,
      focusRingAlpha: focusRingAlpha ?? this.focusRingAlpha,
      frameWindowRadius: frameWindowRadius ?? this.frameWindowRadius,
      framePopoverRadius: framePopoverRadius ?? this.framePopoverRadius,
      frameTitlebarSize: frameTitlebarSize ?? this.frameTitlebarSize,
      frameSidebarWidth: frameSidebarWidth ?? this.frameSidebarWidth,
      frameSidebarIconWidth:
          frameSidebarIconWidth ?? this.frameSidebarIconWidth,
      frameRailWidth: frameRailWidth ?? this.frameRailWidth,
      frameAsideWidth: frameAsideWidth ?? this.frameAsideWidth,
      frameNavGap: frameNavGap ?? this.frameNavGap,
      motionDuration: motionDuration ?? this.motionDuration,
      motionEasing: motionEasing ?? this.motionEasing,
      radiusNone: radiusNone ?? this.radiusNone,
      radiusTiny: radiusTiny ?? this.radiusTiny,
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      radiusBig: radiusBig ?? this.radiusBig,
      radiusFull: radiusFull ?? this.radiusFull,
      spacingPx: spacingPx ?? this.spacingPx,
      spacing0: spacing0 ?? this.spacing0,
      spacing05: spacing05 ?? this.spacing05,
      spacing1: spacing1 ?? this.spacing1,
      spacing15: spacing15 ?? this.spacing15,
      spacing2: spacing2 ?? this.spacing2,
      spacing25: spacing25 ?? this.spacing25,
      spacing3: spacing3 ?? this.spacing3,
      spacing35: spacing35 ?? this.spacing35,
      spacing4: spacing4 ?? this.spacing4,
      spacing5: spacing5 ?? this.spacing5,
      spacing6: spacing6 ?? this.spacing6,
      spacing7: spacing7 ?? this.spacing7,
      spacing8: spacing8 ?? this.spacing8,
      spacing9: spacing9 ?? this.spacing9,
      spacing10: spacing10 ?? this.spacing10,
      spacing11: spacing11 ?? this.spacing11,
      spacing12: spacing12 ?? this.spacing12,
      spacing14: spacing14 ?? this.spacing14,
      spacing16: spacing16 ?? this.spacing16,
      spacing20: spacing20 ?? this.spacing20,
      strokeHairline: strokeHairline ?? this.strokeHairline,
      strokeControl: strokeControl ?? this.strokeControl,
      washSurface: washSurface ?? this.washSurface,
      washEdge: washEdge ?? this.washEdge,
      controlColorRecessedBorder:
          controlColorRecessedBorder ?? this.controlColorRecessedBorder,
      controlColorFilledSurfaceNormalShade:
          controlColorFilledSurfaceNormalShade ??
          this.controlColorFilledSurfaceNormalShade,
      controlColorFilledSurfaceHoveredShade:
          controlColorFilledSurfaceHoveredShade ??
          this.controlColorFilledSurfaceHoveredShade,
      controlColorFilledSurfacePressedShade:
          controlColorFilledSurfacePressedShade ??
          this.controlColorFilledSurfacePressedShade,
      controlColorFilledBorder:
          controlColorFilledBorder ?? this.controlColorFilledBorder,
      controlColorTintedContentNormalShade:
          controlColorTintedContentNormalShade ??
          this.controlColorTintedContentNormalShade,
      controlColorTintedContentHoveredShade:
          controlColorTintedContentHoveredShade ??
          this.controlColorTintedContentHoveredShade,
      controlColorTintedContentPressedShade:
          controlColorTintedContentPressedShade ??
          this.controlColorTintedContentPressedShade,
      controlColorTintedBorder:
          controlColorTintedBorder ?? this.controlColorTintedBorder,
      controlColorOutlinedContentNormalShade:
          controlColorOutlinedContentNormalShade ??
          this.controlColorOutlinedContentNormalShade,
      controlColorOutlinedContentHoveredShade:
          controlColorOutlinedContentHoveredShade ??
          this.controlColorOutlinedContentHoveredShade,
      controlColorOutlinedContentPressedShade:
          controlColorOutlinedContentPressedShade ??
          this.controlColorOutlinedContentPressedShade,
      controlColorOutlinedBorder:
          controlColorOutlinedBorder ?? this.controlColorOutlinedBorder,
      controlColorPlainSurface:
          controlColorPlainSurface ?? this.controlColorPlainSurface,
      controlColorPlainContentNormalShade:
          controlColorPlainContentNormalShade ??
          this.controlColorPlainContentNormalShade,
      controlColorPlainContentHoveredShade:
          controlColorPlainContentHoveredShade ??
          this.controlColorPlainContentHoveredShade,
      controlColorPlainContentPressedShade:
          controlColorPlainContentPressedShade ??
          this.controlColorPlainContentPressedShade,
      controlColorPlainBorder:
          controlColorPlainBorder ?? this.controlColorPlainBorder,
      controlPressedAlpha: controlPressedAlpha ?? this.controlPressedAlpha,
      controlContainerRadius:
          controlContainerRadius ?? this.controlContainerRadius,
      controlTinySize: controlTinySize ?? this.controlTinySize,
      controlSmallSize: controlSmallSize ?? this.controlSmallSize,
      controlMediumSize: controlMediumSize ?? this.controlMediumSize,
      controlLargeSize: controlLargeSize ?? this.controlLargeSize,
      checkboxRadius: checkboxRadius ?? this.checkboxRadius,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      dialogScrimAlpha: dialogScrimAlpha ?? this.dialogScrimAlpha,
      drawerSize: drawerSize ?? this.drawerSize,
      menuMinWidth: menuMinWidth ?? this.menuMinWidth,
      menuItemPadding: menuItemPadding ?? this.menuItemPadding,
      preferencesWidth: preferencesWidth ?? this.preferencesWidth,
      previewCardWidth: previewCardWidth ?? this.previewCardWidth,
      progressGradientFrom: progressGradientFrom ?? this.progressGradientFrom,
      progressGradientTo: progressGradientTo ?? this.progressGradientTo,
      segmentedControlInset:
          segmentedControlInset ?? this.segmentedControlInset,
      shortcutRecorderWidth:
          shortcutRecorderWidth ?? this.shortcutRecorderWidth,
      switchMediumWidth: switchMediumWidth ?? this.switchMediumWidth,
      switchMediumHeight: switchMediumHeight ?? this.switchMediumHeight,
      switchMediumThumb: switchMediumThumb ?? this.switchMediumThumb,
      toastMaxWidth: toastMaxWidth ?? this.toastMaxWidth,
      fontCode: fontCode ?? this.fontCode,
      fontDisplay: fontDisplay ?? this.fontDisplay,
      fontUi: fontUi ?? this.fontUi,
    );
  }
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
  colorSurfaceMuted: Color(0xFFFFFFFF),
  colorSurfaceSunken: Color(0xFFE5E3DB),
  colorSurfaceSubtle: Color(0x0F111C2E),
  colorSurfaceInset: Color(0xFFF0EFE9),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceOverlay: Color(0xFFFBFAF7),
  colorSurfaceChrome: Color(0xFFFFFFFF),
  colorSurfaceColumn: Color(0xFFF4F3EE),
  colorContent: Color(0xFF111C2E),
  colorContentSecondary: Color(0xC7111C2E),
  colorContentNav: Color(0xB3111C2E),
  colorContentMuted: Color(0xA8111C2E),
  colorContentSubtle: Color(0x73111C2E),
  colorContentFaint: Color(0x61111C2E),
  colorBorder: Color(0x14111C2E),
  colorBorderStrong: Color(0x17111C2E),
  colorBorderMuted: Color(0x40111C2E),
  colorOnAccent: Color(0xFFD6FF3F),
  controlContainerRadius: 14,
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
  colorCanvas: Color(0xFF060B12),
  colorSurface: Color(0xFF0C141E),
  colorSurfaceMuted: Color(0xFF141D29),
  colorSurfaceSunken: Color(0xFF1C2734),
  colorSurfaceSubtle: Color(0x12F2F4EF),
  colorSurfaceInset: Color(0xFF16202C),
  colorSurfaceRaised: Color(0xFF2A3644),
  colorSurfaceOverlay: Color(0xFF111A26),
  colorSurfaceChrome: Color(0xFF111A26),
  colorSurfaceColumn: Color(0xFF0A111A),
  colorContent: Color(0xFFF2F4EF),
  colorContentSecondary: Color(0xC7F2F4EF),
  colorContentNav: Color(0xB3F2F4EF),
  colorContentMuted: Color(0xA8F2F4EF),
  colorContentSubtle: Color(0x73F2F4EF),
  colorContentFaint: Color(0x61F2F4EF),
  colorBorder: Color(0x14F2F4EF),
  colorBorderStrong: Color(0x17F2F4EF),
  colorBorderMuted: Color(0xFF35414F),
  colorOnAccent: Color(0xFF111C2E),
  controlContainerRadius: 14,
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

/// The `frost-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesFrostLight = ThemeVariables(
  colorCanvas: Color(0xFFE5EDF0),
  colorSurface: Color(0xFFFFFFFF),
  colorSurfaceMuted: Color(0xFFF2F6F8),
  colorSurfaceSunken: Color(0xFFDBE6EA),
  colorSurfaceSubtle: Color(0x0F0E1F26),
  colorSurfaceInset: Color(0xFFECF2F4),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceOverlay: Color(0xFFFFFFFF),
  colorSurfaceChrome: Color(0xFFF2F6F8),
  colorSurfaceColumn: Color(0xFFF2F6F8),
  colorContent: Color(0xFF0E1F26),
  colorContentSecondary: Color(0xFF2F4C58),
  colorContentNav: Color(0xFF3A5B68),
  colorContentMuted: Color(0xFF456573),
  colorContentSubtle: Color(0xFF7794A0),
  colorContentFaint: Color(0xFF9AB1BA),
  colorBorder: Color(0x210E1F26),
  colorBorderStrong: Color(0x2B0E1F26),
  colorBorderMuted: Color(0xFF456573),
  colorOnAccent: Color(0xFFFFFFFF),
  progressGradientFrom: Color(0xFF0F7A92),
  progressGradientTo: Color(0xFF74C9DC),
  colorPrimary: Colors.frost,
);

/// The `frost-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesFrostDark = ThemeVariables(
  colorCanvas: Color(0xFF070D11),
  colorSurface: Color(0xFF0D151A),
  colorSurfaceMuted: Color(0xFF111A20),
  colorSurfaceSunken: Color(0xFF23333D),
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF18262E),
  colorSurfaceRaised: Color(0xFF374B57),
  colorSurfaceOverlay: Color(0xFF111A20),
  colorSurfaceChrome: Color(0xFF111A20),
  colorSurfaceColumn: Color(0xFF111A20),
  colorContent: Color(0xFFEAF3F7),
  colorContentSecondary: Color(0xFFBCD0D9),
  colorContentNav: Color(0xFF93AAB5),
  colorContentMuted: Color(0xFF93AAB5),
  colorContentSubtle: Color(0xFF7F99A4),
  colorContentFaint: Color(0xFF62808D),
  colorBorder: Color(0x29FFFFFF),
  colorBorderStrong: Color(0x33FFFFFF),
  colorBorderMuted: Color(0xFF32454F),
  colorOnAccent: Color(0xFF04171D),
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
  progressGradientFrom: Color(0xFF1690A9),
  progressGradientTo: Color(0xFF74C9DC),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.frost,
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

/// The `graphite-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesGraphiteLight = ThemeVariables(
  colorCanvas: Color(0xFFE8E8EC),
  colorSurface: Color(0xFFFFFFFF),
  colorSurfaceMuted: Color(0xFFF6F6F8),
  colorSurfaceSunken: Color(0xFFE2E2E7),
  colorSurfaceSubtle: Color(0x0F17171B),
  colorSurfaceInset: Color(0xFFEFEFF2),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceOverlay: Color(0xFFFFFFFF),
  colorSurfaceChrome: Color(0xFFF6F6F8),
  colorSurfaceColumn: Color(0xFFF6F6F8),
  colorContent: Color(0xFF17171B),
  colorContentSecondary: Color(0xFF3D3D45),
  colorContentNav: Color(0xFF4C4C56),
  colorContentMuted: Color(0xFF57575F),
  colorContentSubtle: Color(0xFF8A8A93),
  colorContentFaint: Color(0xFFA3A3AB),
  colorBorder: Color(0x2117171B),
  colorBorderStrong: Color(0x2B17171B),
  colorBorderMuted: Color(0xFF57575F),
  colorOnAccent: Color(0xFFFAFAFA),
  controlContainerRadius: 8,
  frameWindowRadius: 16,
  framePopoverRadius: 12,
  radiusSmall: 7,
  radiusMedium: 8,
  radiusLarge: 10,
  radiusBig: 12,
  progressGradientFrom: Color(0xFF3F3F46),
  progressGradientTo: Color(0xFF8F8F99),
  colorPrimary: Colors.graphite,
);

/// The `graphite-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesGraphiteDark = ThemeVariables(
  colorCanvas: Color(0xFF08080A),
  colorSurface: Color(0xFF0F0F12),
  colorSurfaceMuted: Color(0xFF141417),
  colorSurfaceSunken: Color(0xFF27272C),
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF1C1C21),
  colorSurfaceRaised: Color(0xFF3B3B43),
  colorSurfaceOverlay: Color(0xFF141417),
  colorSurfaceChrome: Color(0xFF141417),
  colorSurfaceColumn: Color(0xFF141417),
  colorContent: Color(0xFFF4F4F6),
  colorContentSecondary: Color(0xFFC9C9D0),
  colorContentNav: Color(0xFF9D9DA6),
  colorContentMuted: Color(0xFF9D9DA6),
  colorContentSubtle: Color(0xFF8A8A93),
  colorContentFaint: Color(0xFF6A6A73),
  colorBorder: Color(0x29FFFFFF),
  colorBorderStrong: Color(0x33FFFFFF),
  colorBorderMuted: Color(0xFF38383F),
  colorOnAccent: Color(0xFF131316),
  controlContainerRadius: 8,
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
  frameWindowRadius: 16,
  framePopoverRadius: 12,
  radiusSmall: 7,
  radiusMedium: 8,
  radiusLarge: 10,
  radiusBig: 12,
  progressGradientFrom: Color(0xFFEDEDF0),
  progressGradientTo: Color(0xFFA1A1AA),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.graphiteDark,
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

/// The `ember-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesEmberLight = ThemeVariables(
  colorCanvas: Color(0xFFEAE2D4),
  colorSurface: Color(0xFFFFFDF9),
  colorSurfaceMuted: Color(0xFFF6F1E8),
  colorSurfaceSunken: Color(0xFFE6DDCD),
  colorSurfaceSubtle: Color(0x0F241A11),
  colorSurfaceInset: Color(0xFFF2EBDF),
  colorSurfaceRaised: Color(0xFFFFFDF9),
  colorSurfaceOverlay: Color(0xFFFFFDF9),
  colorSurfaceChrome: Color(0xFFF6F1E8),
  colorSurfaceColumn: Color(0xFFF6F1E8),
  colorContent: Color(0xFF241A11),
  colorContentSecondary: Color(0xFF4B3A2B),
  colorContentNav: Color(0xFF5B4839),
  colorContentMuted: Color(0xFF6A5747),
  colorContentSubtle: Color(0xFF96867A),
  colorContentFaint: Color(0xFFB0A294),
  colorBorder: Color(0x21241A11),
  colorBorderStrong: Color(0x2B241A11),
  colorBorderMuted: Color(0xFF6A5747),
  colorOnAccent: Color(0xFFFFFAF3),
  progressGradientFrom: Color(0xFFAD5717),
  progressGradientTo: Color(0xFFE9A969),
  colorPrimary: Colors.ember,
);

/// The `ember-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesEmberDark = ThemeVariables(
  colorCanvas: Color(0xFF0C0906),
  colorSurface: Color(0xFF14100B),
  colorSurfaceMuted: Color(0xFF191410),
  colorSurfaceSunken: Color(0xFF2F271E),
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF231D16),
  colorSurfaceRaised: Color(0xFF453A2D),
  colorSurfaceOverlay: Color(0xFF191410),
  colorSurfaceChrome: Color(0xFF191410),
  colorSurfaceColumn: Color(0xFF191410),
  colorContent: Color(0xFFF6EFE4),
  colorContentSecondary: Color(0xFFD5C6B4),
  colorContentNav: Color(0xFFAB9886),
  colorContentMuted: Color(0xFFAB9886),
  colorContentSubtle: Color(0xFF94806D),
  colorContentFaint: Color(0xFF71604F),
  colorBorder: Color(0x29FFFFFF),
  colorBorderStrong: Color(0x33FFFFFF),
  colorBorderMuted: Color(0xFF443A2D),
  colorOnAccent: Color(0xFF241206),
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
  progressGradientFrom: Color(0xFFD9832E),
  progressGradientTo: Color(0xFFF0B877),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.emberDark,
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

/// The `nocturne-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesNocturneLight = ThemeVariables(
  colorCanvas: Color(0xFFE7E7EF),
  colorSurface: Color(0xFFFFFFFF),
  colorSurfaceMuted: Color(0xFFF6F6FA),
  colorSurfaceSunken: Color(0xFFE2E2EC),
  colorSurfaceSubtle: Color(0x0F23242E),
  colorSurfaceInset: Color(0xFFEEEEF5),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceOverlay: Color(0xFFFFFFFF),
  colorSurfaceChrome: Color(0xFFF6F6FA),
  colorSurfaceColumn: Color(0xFFF6F6FA),
  colorContent: Color(0xFF23242E),
  colorContentSecondary: Color(0xFF383A49),
  colorContentNav: Color(0xFF4C4E61),
  colorContentMuted: Color(0xFF63667D),
  colorContentSubtle: Color(0xFF85889E),
  colorContentFaint: Color(0xFFADAFC1),
  colorBorder: Color(0x2123242E),
  colorBorderStrong: Color(0x2B23242E),
  colorBorderMuted: Color(0xFFD8D9E4),
  colorOnAccent: Color(0xFFFFFFFF),
  controlContainerRadius: 8,
  frameWindowRadius: 16,
  framePopoverRadius: 12,
  radiusSmall: 7,
  radiusMedium: 8,
  radiusLarge: 10,
  radiusBig: 12,
  progressGradientFrom: Color(0xFF8375D1),
  progressGradientTo: Color(0xFFB5ABFC),
  colorPrimary: Colors.nocturne,
);

/// The `nocturne-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesNocturneDark = ThemeVariables(
  colorCanvas: Color(0xFF101120),
  colorSurface: Color(0xFF161826),
  colorSurfaceMuted: Color(0xFF232532),
  colorSurfaceSunken: Color(0xFF2F313C),
  colorSurfaceSubtle: Color(0x12E9E9ED),
  colorSurfaceInset: Color(0xFF292B31),
  colorSurfaceRaised: Color(0xFF3F424D),
  colorSurfaceOverlay: Color(0xFF232532),
  colorSurfaceChrome: Color(0xFF1C1E2C),
  colorSurfaceColumn: Color(0xFF232532),
  colorContent: Color(0xFFE9E9ED),
  colorContentSecondary: Color(0xFFCFD3E5),
  colorContentNav: Color(0xFFB2B6CA),
  colorContentMuted: Color(0xFF9397AB),
  colorContentSubtle: Color(0xFF75798C),
  colorContentFaint: Color(0xFF595D6C),
  colorBorder: Color(0x29E9E9ED),
  colorBorderStrong: Color(0x33E9E9ED),
  colorBorderMuted: Color(0xFF3F424D),
  colorOnAccent: Color(0xFF161826),
  controlContainerRadius: 8,
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
  frameWindowRadius: 16,
  framePopoverRadius: 12,
  radiusSmall: 7,
  radiusMedium: 8,
  radiusLarge: 10,
  radiusBig: 12,
  progressGradientFrom: Color(0xFF9184D9),
  progressGradientTo: Color(0xFFB5ABFC),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.nocturne,
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
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF1B1E26),
  colorSurfaceRaised: Color(0xFF3A3F4D),
  colorSurfaceOverlay: Color(0xFF12141A),
  colorSurfaceChrome: Color(0xFF12141A),
  colorSurfaceColumn: Color(0xFF0A0C11),
  colorContent: Color(0xFFF2F3FA),
  colorContentSecondary: Color(0xFFC3C8DC),
  colorContentNav: Color(0xFF9AA1BB),
  colorContentMuted: Color(0xFF9AA1BB),
  colorContentSubtle: Color(0xFF8B93B0),
  colorContentFaint: Color(0xFF6A7090),
  colorBorder: Color(0x0FFFFFFF),
  colorBorderStrong: Color(0x17FFFFFF),
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
