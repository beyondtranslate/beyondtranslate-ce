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
    this.titleSmallFontSize = 13,
    this.titleSmallLineHeight = 20,
    this.titleMediumFontSize = 15,
    this.titleMediumLineHeight = 22,
    this.titleLargeFontSize = 17,
    this.titleLargeLineHeight = 22,
    this.bodySmallFontSize = 12,
    this.bodySmallLineHeight = 18,
    this.bodyMediumFontSize = 13,
    this.bodyMediumLineHeight = 20,
    this.bodyLargeFontSize = 15,
    this.bodyLargeLineHeight = 22,
    this.labelQuietFontSize = 12,
    this.labelQuietLineHeight = 12,
    this.labelStrongFontSize = 12,
    this.labelStrongLineHeight = 12,
    this.labelSmallFontSize = 11,
    this.labelSmallLineHeight = 11,
    this.labelMediumFontSize = 12,
    this.labelMediumLineHeight = 12,
    this.labelLargeFontSize = 13,
    this.labelLargeLineHeight = 13,
    this.captionSmallFontSize = 11,
    this.captionSmallLineHeight = 14,
    this.captionMediumFontSize = 12,
    this.captionMediumLineHeight = 18,
    this.captionLargeFontSize = 13,
    this.captionLargeLineHeight = 20,
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
    this.controlFieldRadius = 10,
    this.controlContainerRadius = 10,
    this.controlTinySize = 24,
    this.controlSmallSize = 26,
    this.controlMediumPaddingInline = 16,
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

  /// The size `titleSmall` is set at; a theme re-points it.
  final double titleSmallFontSize;

  /// The line height `titleSmall` is set at; a theme re-points it.
  final double titleSmallLineHeight;
  TextStyle get titleSmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: titleSmallFontSize,
    fontWeight: FontWeight.w600,
    height: titleSmallLineHeight / titleSmallFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `titleMedium` is set at; a theme re-points it.
  final double titleMediumFontSize;

  /// The line height `titleMedium` is set at; a theme re-points it.
  final double titleMediumLineHeight;
  TextStyle get titleMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: titleMediumFontSize,
    fontWeight: FontWeight.w600,
    height: titleMediumLineHeight / titleMediumFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `titleLarge` is set at; a theme re-points it.
  final double titleLargeFontSize;

  /// The line height `titleLarge` is set at; a theme re-points it.
  final double titleLargeLineHeight;
  TextStyle get titleLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: titleLargeFontSize,
    fontWeight: FontWeight.w600,
    height: titleLargeLineHeight / titleLargeFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `bodySmall` is set at; a theme re-points it.
  final double bodySmallFontSize;

  /// The line height `bodySmall` is set at; a theme re-points it.
  final double bodySmallLineHeight;
  TextStyle get bodySmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: bodySmallFontSize,
    fontWeight: FontWeight.w400,
    height: bodySmallLineHeight / bodySmallFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `bodyMedium` is set at; a theme re-points it.
  final double bodyMediumFontSize;

  /// The line height `bodyMedium` is set at; a theme re-points it.
  final double bodyMediumLineHeight;
  TextStyle get bodyMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: bodyMediumFontSize,
    fontWeight: FontWeight.w400,
    height: bodyMediumLineHeight / bodyMediumFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `bodyLarge` is set at; a theme re-points it.
  final double bodyLargeFontSize;

  /// The line height `bodyLarge` is set at; a theme re-points it.
  final double bodyLargeLineHeight;
  TextStyle get bodyLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: bodyLargeFontSize,
    fontWeight: FontWeight.w400,
    height: bodyLargeLineHeight / bodyLargeFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `labelQuiet` is set at; a theme re-points it.
  final double labelQuietFontSize;

  /// The line height `labelQuiet` is set at; a theme re-points it.
  final double labelQuietLineHeight;
  TextStyle get labelQuiet => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: labelQuietFontSize,
    fontWeight: FontWeight.w500,
    height: labelQuietLineHeight / labelQuietFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `labelStrong` is set at; a theme re-points it.
  final double labelStrongFontSize;

  /// The line height `labelStrong` is set at; a theme re-points it.
  final double labelStrongLineHeight;
  TextStyle get labelStrong => TextStyle(
    fontFamily: fontDisplay.family,
    fontFamilyFallback: fontDisplay.fallback,
    fontSize: labelStrongFontSize,
    fontWeight: FontWeight.w700,
    height: labelStrongLineHeight / labelStrongFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `labelSmall` is set at; a theme re-points it.
  final double labelSmallFontSize;

  /// The line height `labelSmall` is set at; a theme re-points it.
  final double labelSmallLineHeight;
  TextStyle get labelSmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: labelSmallFontSize,
    fontWeight: FontWeight.w600,
    height: labelSmallLineHeight / labelSmallFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `labelMedium` is set at; a theme re-points it.
  final double labelMediumFontSize;

  /// The line height `labelMedium` is set at; a theme re-points it.
  final double labelMediumLineHeight;
  TextStyle get labelMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: labelMediumFontSize,
    fontWeight: FontWeight.w600,
    height: labelMediumLineHeight / labelMediumFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `labelLarge` is set at; a theme re-points it.
  final double labelLargeFontSize;

  /// The line height `labelLarge` is set at; a theme re-points it.
  final double labelLargeLineHeight;
  TextStyle get labelLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: labelLargeFontSize,
    fontWeight: FontWeight.w600,
    height: labelLargeLineHeight / labelLargeFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `captionSmall` is set at; a theme re-points it.
  final double captionSmallFontSize;

  /// The line height `captionSmall` is set at; a theme re-points it.
  final double captionSmallLineHeight;
  TextStyle get captionSmall => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: captionSmallFontSize,
    fontWeight: FontWeight.w400,
    height: captionSmallLineHeight / captionSmallFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `captionMedium` is set at; a theme re-points it.
  final double captionMediumFontSize;

  /// The line height `captionMedium` is set at; a theme re-points it.
  final double captionMediumLineHeight;
  TextStyle get captionMedium => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: captionMediumFontSize,
    fontWeight: FontWeight.w400,
    height: captionMediumLineHeight / captionMediumFontSize,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// The size `captionLarge` is set at; a theme re-points it.
  final double captionLargeFontSize;

  /// The line height `captionLarge` is set at; a theme re-points it.
  final double captionLargeLineHeight;
  TextStyle get captionLarge => TextStyle(
    fontFamily: fontUi.family,
    fontFamilyFallback: fontUi.fallback,
    fontSize: captionLargeFontSize,
    fontWeight: FontWeight.w400,
    height: captionLargeLineHeight / captionLargeFontSize,
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
  final double controlFieldRadius;
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
  final double controlMediumPaddingInline;
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
    double? titleSmallFontSize,
    double? titleSmallLineHeight,
    double? titleMediumFontSize,
    double? titleMediumLineHeight,
    double? titleLargeFontSize,
    double? titleLargeLineHeight,
    double? bodySmallFontSize,
    double? bodySmallLineHeight,
    double? bodyMediumFontSize,
    double? bodyMediumLineHeight,
    double? bodyLargeFontSize,
    double? bodyLargeLineHeight,
    double? labelQuietFontSize,
    double? labelQuietLineHeight,
    double? labelStrongFontSize,
    double? labelStrongLineHeight,
    double? labelSmallFontSize,
    double? labelSmallLineHeight,
    double? labelMediumFontSize,
    double? labelMediumLineHeight,
    double? labelLargeFontSize,
    double? labelLargeLineHeight,
    double? captionSmallFontSize,
    double? captionSmallLineHeight,
    double? captionMediumFontSize,
    double? captionMediumLineHeight,
    double? captionLargeFontSize,
    double? captionLargeLineHeight,
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
    double? controlFieldRadius,
    double? controlContainerRadius,
    double? controlTinySize,
    double? controlSmallSize,
    double? controlMediumPaddingInline,
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
      titleSmallFontSize: titleSmallFontSize ?? this.titleSmallFontSize,
      titleSmallLineHeight: titleSmallLineHeight ?? this.titleSmallLineHeight,
      titleMediumFontSize: titleMediumFontSize ?? this.titleMediumFontSize,
      titleMediumLineHeight:
          titleMediumLineHeight ?? this.titleMediumLineHeight,
      titleLargeFontSize: titleLargeFontSize ?? this.titleLargeFontSize,
      titleLargeLineHeight: titleLargeLineHeight ?? this.titleLargeLineHeight,
      bodySmallFontSize: bodySmallFontSize ?? this.bodySmallFontSize,
      bodySmallLineHeight: bodySmallLineHeight ?? this.bodySmallLineHeight,
      bodyMediumFontSize: bodyMediumFontSize ?? this.bodyMediumFontSize,
      bodyMediumLineHeight: bodyMediumLineHeight ?? this.bodyMediumLineHeight,
      bodyLargeFontSize: bodyLargeFontSize ?? this.bodyLargeFontSize,
      bodyLargeLineHeight: bodyLargeLineHeight ?? this.bodyLargeLineHeight,
      labelQuietFontSize: labelQuietFontSize ?? this.labelQuietFontSize,
      labelQuietLineHeight: labelQuietLineHeight ?? this.labelQuietLineHeight,
      labelStrongFontSize: labelStrongFontSize ?? this.labelStrongFontSize,
      labelStrongLineHeight:
          labelStrongLineHeight ?? this.labelStrongLineHeight,
      labelSmallFontSize: labelSmallFontSize ?? this.labelSmallFontSize,
      labelSmallLineHeight: labelSmallLineHeight ?? this.labelSmallLineHeight,
      labelMediumFontSize: labelMediumFontSize ?? this.labelMediumFontSize,
      labelMediumLineHeight:
          labelMediumLineHeight ?? this.labelMediumLineHeight,
      labelLargeFontSize: labelLargeFontSize ?? this.labelLargeFontSize,
      labelLargeLineHeight: labelLargeLineHeight ?? this.labelLargeLineHeight,
      captionSmallFontSize: captionSmallFontSize ?? this.captionSmallFontSize,
      captionSmallLineHeight:
          captionSmallLineHeight ?? this.captionSmallLineHeight,
      captionMediumFontSize:
          captionMediumFontSize ?? this.captionMediumFontSize,
      captionMediumLineHeight:
          captionMediumLineHeight ?? this.captionMediumLineHeight,
      captionLargeFontSize: captionLargeFontSize ?? this.captionLargeFontSize,
      captionLargeLineHeight:
          captionLargeLineHeight ?? this.captionLargeLineHeight,
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
      controlFieldRadius: controlFieldRadius ?? this.controlFieldRadius,
      controlContainerRadius:
          controlContainerRadius ?? this.controlContainerRadius,
      controlTinySize: controlTinySize ?? this.controlTinySize,
      controlSmallSize: controlSmallSize ?? this.controlSmallSize,
      controlMediumPaddingInline:
          controlMediumPaddingInline ?? this.controlMediumPaddingInline,
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
  controlFieldRadius: 9999,
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
  controlFieldRadius: 9999,
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
  controlFieldRadius: 8,
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
  controlFieldRadius: 8,
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
  controlFieldRadius: 8,
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
  controlFieldRadius: 8,
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

/// The `omarchy-tokyo-night-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyTokyoNightLight = ThemeVariables(
  colorCanvas: Color(0xFFDBDCE5),
  colorSurface: Color(0xFFECEEF6),
  colorSurfaceMuted: Color(0xFFE5E6EF),
  colorSurfaceSunken: Color(0xFFCFD0D9),
  colorSurfaceSubtle: Color(0x101A1B26),
  colorSurfaceInset: Color(0xFFDDDEE7),
  colorSurfaceRaised: Color(0xFFECEEF6),
  colorSurfaceOverlay: Color(0xFFECEEF6),
  colorSurfaceChrome: Color(0xFFE5E6EF),
  colorSurfaceColumn: Color(0xFFE8E9F2),
  colorContent: Color(0xFF1A1B26),
  colorContentSecondary: Color(0xFF40414B),
  colorContentNav: Color(0xFF555660),
  colorContentMuted: Color(0xFF666771),
  colorContentSubtle: Color(0xFF83848E),
  colorContentFaint: Color(0xFFA0A2AB),
  colorBorder: Color(0x211A1B26),
  colorBorderStrong: Color(0x2B1A1B26),
  colorBorderMuted: Color(0xFF9C9EA7),
  colorOnAccent: Color(0xFFECEEF6),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF4C6499),
  progressGradientTo: Color(0xFFAABEE7),
  colorPrimary: Colors.omarchyTokyoNightLight,
);

/// The `omarchy-tokyo-night-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyTokyoNightDark = ThemeVariables(
  colorCanvas: Color(0xFF161721),
  colorSurface: Color(0xFF1A1B26),
  colorSurfaceMuted: Color(0xFF20212D),
  colorSurfaceSunken: Color(0xFF2E303E),
  colorSurfaceSubtle: Color(0x14A9B1D6),
  colorSurfaceInset: Color(0xFF262835),
  colorSurfaceRaised: Color(0xFF434659),
  colorSurfaceOverlay: Color(0xFF20212D),
  colorSurfaceChrome: Color(0xFF20212D),
  colorSurfaceColumn: Color(0xFF171822),
  colorContent: Color(0xFFA9B1D6),
  colorContentSecondary: Color(0xFF8F96B6),
  colorContentNav: Color(0xFF8187A5),
  colorContentMuted: Color(0xFF7E84A1),
  colorContentSubtle: Color(0xFF62667E),
  colorContentFaint: Color(0xFF4D5165),
  colorBorder: Color(0x29A9B1D6),
  colorBorderStrong: Color(0x33A9B1D6),
  colorBorderMuted: Color(0xFF505469),
  colorOnAccent: Color(0xFF1A1B26),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF7AA2F7),
  progressGradientTo: Color(0xFFBAD0FD),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyTokyoNightDark,
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

/// The `omarchy-catppuccin-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyCatppuccinLight = ThemeVariables(
  colorCanvas: Color(0xFFE3E4EC),
  colorSurface: Color(0xFFF4F6FD),
  colorSurfaceMuted: Color(0xFFEDEEF6),
  colorSurfaceSunken: Color(0xFFD6D8E0),
  colorSurfaceSubtle: Color(0x0F1E1E2E),
  colorSurfaceInset: Color(0xFFE4E6EE),
  colorSurfaceRaised: Color(0xFFF4F6FD),
  colorSurfaceOverlay: Color(0xFFF4F6FD),
  colorSurfaceChrome: Color(0xFFEDEEF6),
  colorSurfaceColumn: Color(0xFFF0F1F9),
  colorContent: Color(0xFF1E1E2E),
  colorContentSecondary: Color(0xFF454553),
  colorContentNav: Color(0xFF5A5A68),
  colorContentMuted: Color(0xFF6B6C79),
  colorContentSubtle: Color(0xFF898A96),
  colorContentFaint: Color(0xFFA7A8B2),
  colorBorder: Color(0x211E1E2E),
  colorBorderStrong: Color(0x2B1E1E2E),
  colorBorderMuted: Color(0xFFA3A4AE),
  colorOnAccent: Color(0xFFF4F6FD),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF55709B),
  progressGradientTo: Color(0xFFAEC3E5),
  colorPrimary: Colors.omarchyCatppuccinLight,
);

/// The `omarchy-catppuccin-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyCatppuccinDark = ThemeVariables(
  colorCanvas: Color(0xFF1A1A29),
  colorSurface: Color(0xFF1E1E2E),
  colorSurfaceMuted: Color(0xFF242535),
  colorSurfaceSunken: Color(0xFF323445),
  colorSurfaceSubtle: Color(0x12CDD6F4),
  colorSurfaceInset: Color(0xFF2A2B3B),
  colorSurfaceRaised: Color(0xFF484A5E),
  colorSurfaceOverlay: Color(0xFF242535),
  colorSurfaceChrome: Color(0xFF242535),
  colorSurfaceColumn: Color(0xFF1B1B2A),
  colorContent: Color(0xFFCDD6F4),
  colorContentSecondary: Color(0xFFAEB5D0),
  colorContentNav: Color(0xFF9CA2BD),
  colorContentMuted: Color(0xFF8E94AD),
  colorContentSubtle: Color(0xFF767A91),
  colorContentFaint: Color(0xFF5D6075),
  colorBorder: Color(0x29CDD6F4),
  colorBorderStrong: Color(0x33CDD6F4),
  colorBorderMuted: Color(0xFF616479),
  colorOnAccent: Color(0xFF1E1E2E),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF89B4FA),
  progressGradientTo: Color(0xFFC1D8FD),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyCatppuccinDark,
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

/// The `omarchy-catppuccin-latte-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyCatppuccinLatteLight = ThemeVariables(
  colorCanvas: Color(0xFFDDDFE6),
  colorSurface: Color(0xFFEFF1F5),
  colorSurfaceMuted: Color(0xFFE7E9EF),
  colorSurfaceSunken: Color(0xFFD0D3DB),
  colorSurfaceSubtle: Color(0x144C4F69),
  colorSurfaceInset: Color(0xFFDFE1E8),
  colorSurfaceRaised: Color(0xFFEFF1F5),
  colorSurfaceOverlay: Color(0xFFEFF1F5),
  colorSurfaceChrome: Color(0xFFE7E9EF),
  colorSurfaceColumn: Color(0xFFEAECF1),
  colorContent: Color(0xFF4C4F69),
  colorContentSecondary: Color(0xFF686B81),
  colorContentNav: Color(0xFF686B81),
  colorContentMuted: Color(0xFF686B81),
  colorContentSubtle: Color(0xFF9EA0AF),
  colorContentFaint: Color(0xFFB4B7C3),
  colorBorder: Color(0x214C4F69),
  colorBorderStrong: Color(0x2B4C4F69),
  colorBorderMuted: Color(0xFFB1B3C0),
  colorOnAccent: Color(0xFFEFF1F5),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF1E66F5),
  progressGradientTo: Color(0xFFA7C5FB),
  colorPrimary: Colors.omarchyCatppuccinLatteLight,
);

/// The `omarchy-catppuccin-latte-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyCatppuccinLatteDark = ThemeVariables(
  colorCanvas: Color(0xFF1E2029),
  colorSurface: Color(0xFF22242F),
  colorSurfaceMuted: Color(0xFF292B35),
  colorSurfaceSunken: Color(0xFF383A44),
  colorSurfaceSubtle: Color(0x12EFF1F5),
  colorSurfaceInset: Color(0xFF2F313B),
  colorSurfaceRaised: Color(0xFF4F515A),
  colorSurfaceOverlay: Color(0xFF292B35),
  colorSurfaceChrome: Color(0xFF292B35),
  colorSurfaceColumn: Color(0xFF1F212A),
  colorContent: Color(0xFFEFF1F5),
  colorContentSecondary: Color(0xFFCACCD1),
  colorContentNav: Color(0xFFB6B8BE),
  colorContentMuted: Color(0xFFA5A7AE),
  colorContentSubtle: Color(0xFF898B92),
  colorContentFaint: Color(0xFF6C6E76),
  colorBorder: Color(0x29EFF1F5),
  colorBorderStrong: Color(0x33EFF1F5),
  colorBorderMuted: Color(0xFF70727A),
  colorOnAccent: Color(0xFF22242F),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF74A0F9),
  progressGradientTo: Color(0xFFB7CFFE),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyCatppuccinLatteDark,
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

/// The `omarchy-ethereal-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyEtherealLight = ThemeVariables(
  colorCanvas: Color(0xFFECE3DE),
  colorSurface: Color(0xFFFFF4ED),
  colorSurfaceMuted: Color(0xFFF7EDE6),
  colorSurfaceSunken: Color(0xFFDFD6D3),
  colorSurfaceSubtle: Color(0x0F060B1E),
  colorSurfaceInset: Color(0xFFEEE4DF),
  colorSurfaceRaised: Color(0xFFFFF4ED),
  colorSurfaceOverlay: Color(0xFFFFF4ED),
  colorSurfaceChrome: Color(0xFFF7EDE6),
  colorSurfaceColumn: Color(0xFFFAEFE9),
  colorContent: Color(0xFF060B1E),
  colorContentSecondary: Color(0xFF333543),
  colorContentNav: Color(0xFF4C4C58),
  colorContentMuted: Color(0xFF605F69),
  colorContentSubtle: Color(0xFF838086),
  colorContentFaint: Color(0xFFA5A0A2),
  colorBorder: Color(0x21060B1E),
  colorBorderStrong: Color(0x2B060B1E),
  colorBorderMuted: Color(0xFFA09B9E),
  colorOnAccent: Color(0xFFFFF4ED),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF4E5187),
  progressGradientTo: Color(0xFFB0B4DF),
  colorPrimary: Colors.omarchyEtherealLight,
);

/// The `omarchy-ethereal-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyEtherealDark = ThemeVariables(
  colorCanvas: Color(0xFF02050C),
  colorSurface: Color(0xFF060B1E),
  colorSurfaceMuted: Color(0xFF111324),
  colorSurfaceSunken: Color(0xFF22212E),
  colorSurfaceSubtle: Color(0x12FFCEAD),
  colorSurfaceInset: Color(0xFF181929),
  colorSurfaceRaised: Color(0xFF3C363D),
  colorSurfaceOverlay: Color(0xFF111324),
  colorSurfaceChrome: Color(0xFF111324),
  colorSurfaceColumn: Color(0xFF040612),
  colorContent: Color(0xFFFFCEAD),
  colorContentSecondary: Color(0xFFD2AB93),
  colorContentNav: Color(0xFFB99785),
  colorContentMuted: Color(0xFFA5887A),
  colorContentSubtle: Color(0xFF836D66),
  colorContentFaint: Color(0xFF605151),
  colorBorder: Color(0x29FFCEAD),
  colorBorderStrong: Color(0x33FFCEAD),
  colorBorderMuted: Color(0xFF655554),
  colorOnAccent: Color(0xFF060B1E),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF7D82D9),
  progressGradientTo: Color(0xFFB8BEFF),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyEtherealDark,
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

/// The `omarchy-everforest-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyEverforestLight = ThemeVariables(
  colorCanvas: Color(0xFFE3E1DC),
  colorSurface: Color(0xFFF5F2EC),
  colorSurfaceMuted: Color(0xFFEDEBE5),
  colorSurfaceSunken: Color(0xFFD6D4D0),
  colorSurfaceSubtle: Color(0x112D353B),
  colorSurfaceInset: Color(0xFFE5E2DD),
  colorSurfaceRaised: Color(0xFFF5F2EC),
  colorSurfaceOverlay: Color(0xFFF5F2EC),
  colorSurfaceChrome: Color(0xFFEDEBE5),
  colorSurfaceColumn: Color(0xFFF0EDE8),
  colorContent: Color(0xFF2D353B),
  colorContentSecondary: Color(0xFF51575B),
  colorContentNav: Color(0xFF656A6D),
  colorContentMuted: Color(0xFF696E70),
  colorContentSubtle: Color(0xFF919394),
  colorContentFaint: Color(0xFFADAEAC),
  colorBorder: Color(0x212D353B),
  colorBorderStrong: Color(0x2B2D353B),
  colorBorderMuted: Color(0xFFA9AAA9),
  colorOnAccent: Color(0xFFF5F2EC),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF4F746F),
  progressGradientTo: Color(0xFFACC7C3),
  colorPrimary: Colors.omarchyEverforestLight,
);

/// The `omarchy-everforest-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyEverforestDark = ThemeVariables(
  colorCanvas: Color(0xFF293036),
  colorSurface: Color(0xFF2D353B),
  colorSurfaceMuted: Color(0xFF343C40),
  colorSurfaceSunken: Color(0xFF474C4C),
  colorSurfaceSubtle: Color(0x16D3C6AA),
  colorSurfaceInset: Color(0xFF3C4345),
  colorSurfaceRaised: Color(0xFF62635E),
  colorSurfaceOverlay: Color(0xFF343C40),
  colorSurfaceChrome: Color(0xFF343C40),
  colorSurfaceColumn: Color(0xFF2A3137),
  colorContent: Color(0xFFD3C6AA),
  colorContentSecondary: Color(0xFFB5AC96),
  colorContentNav: Color(0xFFA59D8B),
  colorContentMuted: Color(0xFFA59D8B),
  colorContentSubtle: Color(0xFF807E72),
  colorContentFaint: Color(0xFF696963),
  colorBorder: Color(0x29D3C6AA),
  colorBorderStrong: Color(0x33D3C6AA),
  colorBorderMuted: Color(0xFF6C6C65),
  colorOnAccent: Color(0xFF2D353B),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF7FBBB3),
  progressGradientTo: Color(0xFFB5DED8),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyEverforestDark,
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

/// The `omarchy-flexoki-light-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyFlexokiLightLight = ThemeVariables(
  colorCanvas: Color(0xFFEDEADF),
  colorSurface: Color(0xFFFFFCF0),
  colorSurfaceMuted: Color(0xFFF7F5E9),
  colorSurfaceSunken: Color(0xFFE0DED3),
  colorSurfaceSubtle: Color(0x0F100F0F),
  colorSurfaceInset: Color(0xFFEFECE1),
  colorSurfaceRaised: Color(0xFFFFFCF0),
  colorSurfaceOverlay: Color(0xFFFFFCF0),
  colorSurfaceChrome: Color(0xFFF7F5E9),
  colorSurfaceColumn: Color(0xFFFAF7EC),
  colorContent: Color(0xFF100F0F),
  colorContentSecondary: Color(0xFF3B3A38),
  colorContentNav: Color(0xFF53514E),
  colorContentMuted: Color(0xFF666460),
  colorContentSubtle: Color(0xFF888680),
  colorContentFaint: Color(0xFFA9A79F),
  colorBorder: Color(0x21100F0F),
  colorBorderStrong: Color(0x2B100F0F),
  colorBorderMuted: Color(0xFFA4A29B),
  colorOnAccent: Color(0xFFFFFCF0),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF205EA6),
  progressGradientTo: Color(0xFF92BEF5),
  colorPrimary: Colors.omarchyFlexokiLightLight,
);

/// The `omarchy-flexoki-light-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyFlexokiLightDark = ThemeVariables(
  colorCanvas: Color(0xFF0E0E0D),
  colorSurface: Color(0xFF070707),
  colorSurfaceMuted: Color(0xFF111110),
  colorSurfaceSunken: Color(0xFF20201E),
  colorSurfaceSubtle: Color(0x12FFFCF0),
  colorSurfaceInset: Color(0xFF181817),
  colorSurfaceRaised: Color(0xFF353532),
  colorSurfaceOverlay: Color(0xFF111110),
  colorSurfaceChrome: Color(0xFF111110),
  colorSurfaceColumn: Color(0xFF010101),
  colorContent: Color(0xFFFFFCF0),
  colorContentSecondary: Color(0xFFD2D0C6),
  colorContentNav: Color(0xFFBAB7AF),
  colorContentMuted: Color(0xFFA6A49C),
  colorContentSubtle: Color(0xFF83827C),
  colorContentFaint: Color(0xFF605F5B),
  colorBorder: Color(0x29FFFCF0),
  colorBorderStrong: Color(0x33FFFCF0),
  colorBorderMuted: Color(0xFF656460),
  colorOnAccent: Color(0xFF070707),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF759BC8),
  progressGradientTo: Color(0xFFB1CDEE),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyFlexokiLightDark,
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

/// The `omarchy-gruvbox-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyGruvboxLight = ThemeVariables(
  colorCanvas: Color(0xFFE4E0D8),
  colorSurface: Color(0xFFF6F1E8),
  colorSurfaceMuted: Color(0xFFEEEAE1),
  colorSurfaceSunken: Color(0xFFD8D3CC),
  colorSurfaceSubtle: Color(0x10282828),
  colorSurfaceInset: Color(0xFFE6E1D9),
  colorSurfaceRaised: Color(0xFFF6F1E8),
  colorSurfaceOverlay: Color(0xFFF6F1E8),
  colorSurfaceChrome: Color(0xFFEEEAE1),
  colorSurfaceColumn: Color(0xFFF1ECE4),
  colorContent: Color(0xFF282828),
  colorContentSecondary: Color(0xFF4D4C4B),
  colorContentNav: Color(0xFF62605E),
  colorContentMuted: Color(0xFF6E6C69),
  colorContentSubtle: Color(0xFF8F8D88),
  colorContentFaint: Color(0xFFACA9A3),
  colorBorder: Color(0x21282828),
  colorBorderStrong: Color(0x2B282828),
  colorBorderMuted: Color(0xFFA8A59F),
  colorOnAccent: Color(0xFFF6F1E8),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF4E6C65),
  progressGradientTo: Color(0xFFADC3BE),
  colorPrimary: Colors.omarchyGruvboxLight,
);

/// The `omarchy-gruvbox-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyGruvboxDark = ThemeVariables(
  colorCanvas: Color(0xFF232323),
  colorSurface: Color(0xFF282828),
  colorSurfaceMuted: Color(0xFF2F2F2D),
  colorSurfaceSunken: Color(0xFF413E38),
  colorSurfaceSubtle: Color(0x14D4BE98),
  colorSurfaceInset: Color(0xFF363531),
  colorSurfaceRaised: Color(0xFF5B5549),
  colorSurfaceOverlay: Color(0xFF2F2F2D),
  colorSurfaceChrome: Color(0xFF2F2F2D),
  colorSurfaceColumn: Color(0xFF242424),
  colorContent: Color(0xFFD4BE98),
  colorContentSecondary: Color(0xFFB5A384),
  colorContentNav: Color(0xFFA49479),
  colorContentMuted: Color(0xFF9D8E74),
  colorContentSubtle: Color(0xFF7E7360),
  colorContentFaint: Color(0xFF665E50),
  colorBorder: Color(0x29D4BE98),
  colorBorderStrong: Color(0x33D4BE98),
  colorBorderMuted: Color(0xFF696153),
  colorOnAccent: Color(0xFF282828),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF7DAEA3),
  progressGradientTo: Color(0xFFB5D8CF),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyGruvboxDark,
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

/// The `omarchy-hackerman-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyHackermanLight = ThemeVariables(
  colorCanvas: Color(0xFFE7EBEE),
  colorSurface: Color(0xFFF8FDFF),
  colorSurfaceMuted: Color(0xFFF1F5F8),
  colorSurfaceSunken: Color(0xFFDADEE2),
  colorSurfaceSubtle: Color(0x0F0B0C16),
  colorSurfaceInset: Color(0xFFE8EDF0),
  colorSurfaceRaised: Color(0xFFF8FDFF),
  colorSurfaceOverlay: Color(0xFFF8FDFF),
  colorSurfaceChrome: Color(0xFFF1F5F8),
  colorSurfaceColumn: Color(0xFFF4F8FB),
  colorContent: Color(0xFF0B0C16),
  colorContentSecondary: Color(0xFF363740),
  colorContentNav: Color(0xFF4D4F57),
  colorContentMuted: Color(0xFF60636A),
  colorContentSubtle: Color(0xFF82858B),
  colorContentFaint: Color(0xFFA3A6AB),
  colorBorder: Color(0x210B0C16),
  colorBorderStrong: Color(0x2B0B0C16),
  colorBorderMuted: Color(0xFF9EA1A6),
  colorOnAccent: Color(0xFFF8FDFF),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF519C61),
  progressGradientTo: Color(0xFFA8DCB0),
  colorPrimary: Colors.omarchyHackermanLight,
);

/// The `omarchy-hackerman-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyHackermanDark = ThemeVariables(
  colorCanvas: Color(0xFF05050A),
  colorSurface: Color(0xFF0B0C16),
  colorSurfaceMuted: Color(0xFF13141E),
  colorSurfaceSunken: Color(0xFF1F232C),
  colorSurfaceSubtle: Color(0x12DDF7FF),
  colorSurfaceInset: Color(0xFF181B24),
  colorSurfaceRaised: Color(0xFF333942),
  colorSurfaceOverlay: Color(0xFF13141E),
  colorSurfaceChrome: Color(0xFF13141E),
  colorSurfaceColumn: Color(0xFF06070D),
  colorContent: Color(0xFFDDF7FF),
  colorContentSecondary: Color(0xFFB7CDD5),
  colorContentNav: Color(0xFFA2B5BE),
  colorContentMuted: Color(0xFF91A2AB),
  colorContentSubtle: Color(0xFF74828B),
  colorContentFaint: Color(0xFF57616A),
  colorBorder: Color(0x29DDF7FF),
  colorBorderStrong: Color(0x33DDF7FF),
  colorBorderMuted: Color(0xFF5B656F),
  colorOnAccent: Color(0xFF0B0C16),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF82FB9C),
  progressGradientTo: Color(0xFFBDFDC7),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyHackermanDark,
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

/// The `omarchy-kanagawa-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyKanagawaLight = ThemeVariables(
  colorCanvas: Color(0xFFE5E4E0),
  colorSurface: Color(0xFFF7F6F0),
  colorSurfaceMuted: Color(0xFFEFEFE9),
  colorSurfaceSunken: Color(0xFFD8D8D4),
  colorSurfaceSubtle: Color(0x0F1F1F28),
  colorSurfaceInset: Color(0xFFE7E6E2),
  colorSurfaceRaised: Color(0xFFF7F6F0),
  colorSurfaceOverlay: Color(0xFFF7F6F0),
  colorSurfaceChrome: Color(0xFFEFEFE9),
  colorSurfaceColumn: Color(0xFFF2F1EC),
  colorContent: Color(0xFF1F1F28),
  colorContentSecondary: Color(0xFF46464C),
  colorContentNav: Color(0xFF5B5B60),
  colorContentMuted: Color(0xFF6D6C70),
  colorContentSubtle: Color(0xFF8B8B8C),
  colorContentFaint: Color(0xFFA9A9A8),
  colorBorder: Color(0x211F1F28),
  colorBorderStrong: Color(0x2B1F1F28),
  colorBorderMuted: Color(0xFFA5A4A4),
  colorOnAccent: Color(0xFFF7F6F0),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF888573),
  progressGradientTo: Color(0xFFCDCBBE),
  colorPrimary: Colors.omarchyKanagawaLight,
);

/// The `omarchy-kanagawa-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyKanagawaDark = ThemeVariables(
  colorCanvas: Color(0xFF1B1B23),
  colorSurface: Color(0xFF1F1F28),
  colorSurfaceMuted: Color(0xFF26262D),
  colorSurfaceSunken: Color(0xFF353539),
  colorSurfaceSubtle: Color(0x12DCD7BA),
  colorSurfaceInset: Color(0xFF2C2C32),
  colorSurfaceRaised: Color(0xFF4D4C4B),
  colorSurfaceOverlay: Color(0xFF26262D),
  colorSurfaceChrome: Color(0xFF26262D),
  colorSurfaceColumn: Color(0xFF1C1C24),
  colorContent: Color(0xFFDCD7BA),
  colorContentSecondary: Color(0xFFBAB6A0),
  colorContentNav: Color(0xFFA7A391),
  colorContentMuted: Color(0xFF989585),
  colorContentSubtle: Color(0xFF7E7B71),
  colorContentFaint: Color(0xFF63615D),
  colorBorder: Color(0x29DCD7BA),
  colorBorderStrong: Color(0x33DCD7BA),
  colorBorderMuted: Color(0xFF67655F),
  colorOnAccent: Color(0xFF1F1F28),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFFDCD7BA),
  progressGradientTo: Color(0xFFECE8D4),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyKanagawaDark,
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

/// The `omarchy-last-horizon-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyLastHorizonLight = ThemeVariables(
  colorCanvas: Color(0xFFEDECED),
  colorSurface: Color(0xFFFEFEFE),
  colorSurfaceMuted: Color(0xFFF7F6F7),
  colorSurfaceSunken: Color(0xFFE0DFE0),
  colorSurfaceSubtle: Color(0x0F0C0B0C),
  colorSurfaceInset: Color(0xFFEEEEEE),
  colorSurfaceRaised: Color(0xFFFEFEFE),
  colorSurfaceOverlay: Color(0xFFFEFEFE),
  colorSurfaceChrome: Color(0xFFF7F6F7),
  colorSurfaceColumn: Color(0xFFFAF9FA),
  colorContent: Color(0xFF0C0B0C),
  colorContentSecondary: Color(0xFF383738),
  colorContentNav: Color(0xFF504F50),
  colorContentMuted: Color(0xFF636263),
  colorContentSubtle: Color(0xFF858485),
  colorContentFaint: Color(0xFFA7A7A7),
  colorBorder: Color(0x210C0B0C),
  colorBorderStrong: Color(0x2B0C0B0C),
  colorBorderMuted: Color(0xFFA2A2A2),
  colorOnAccent: Color(0xFFFEFEFE),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF705E59),
  progressGradientTo: Color(0xFFC7B9B5),
  colorPrimary: Colors.omarchyLastHorizonLight,
);

/// The `omarchy-last-horizon-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyLastHorizonDark = ThemeVariables(
  colorCanvas: Color(0xFF040404),
  colorSurface: Color(0xFF0C0B0C),
  colorSurfaceMuted: Color(0xFF141414),
  colorSurfaceSunken: Color(0xFF222222),
  colorSurfaceSubtle: Color(0x12FAFCFB),
  colorSurfaceInset: Color(0xFF1A1A1A),
  colorSurfaceRaised: Color(0xFF383738),
  colorSurfaceOverlay: Color(0xFF141414),
  colorSurfaceChrome: Color(0xFF141414),
  colorSurfaceColumn: Color(0xFF060506),
  colorContent: Color(0xFFFAFCFB),
  colorContentSecondary: Color(0xFFCFD1D0),
  colorContentNav: Color(0xFFB7B9B8),
  colorContentMuted: Color(0xFFA4A5A5),
  colorContentSubtle: Color(0xFF838484),
  colorContentFaint: Color(0xFF626262),
  colorBorder: Color(0x29FAFCFB),
  colorBorderStrong: Color(0x33FAFCFB),
  colorBorderMuted: Color(0xFF666767),
  colorOnAccent: Color(0xFF0C0B0C),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFFB59790),
  progressGradientTo: Color(0xFFDEC8C2),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyLastHorizonDark,
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

/// The `omarchy-lumon-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyLumonLight = ThemeVariables(
  colorCanvas: Color(0xFFE4E8EA),
  colorSurface: Color(0xFFF6F9FB),
  colorSurfaceMuted: Color(0xFFEEF2F4),
  colorSurfaceSunken: Color(0xFFD7DBDE),
  colorSurfaceSubtle: Color(0x0F16242D),
  colorSurfaceInset: Color(0xFFE6E9EC),
  colorSurfaceRaised: Color(0xFFF6F9FB),
  colorSurfaceOverlay: Color(0xFFF6F9FB),
  colorSurfaceChrome: Color(0xFFEEF2F4),
  colorSurfaceColumn: Color(0xFFF1F4F7),
  colorContent: Color(0xFF16242D),
  colorContentSecondary: Color(0xFF3E4A52),
  colorContentNav: Color(0xFF556067),
  colorContentMuted: Color(0xFF677177),
  colorContentSubtle: Color(0xFF868F94),
  colorContentFaint: Color(0xFFA5ACB1),
  colorBorder: Color(0x2116242D),
  colorBorderStrong: Color(0x2B16242D),
  colorBorderMuted: Color(0xFFA1A8AD),
  colorOnAccent: Color(0xFFF6F9FB),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF567D92),
  progressGradientTo: Color(0xFFAECADA),
  colorPrimary: Colors.omarchyLumonLight,
);

/// The `omarchy-lumon-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyLumonDark = ThemeVariables(
  colorCanvas: Color(0xFF131F27),
  colorSurface: Color(0xFF16242D),
  colorSurfaceMuted: Color(0xFF1D2B34),
  colorSurfaceSunken: Color(0xFF2C3A43),
  colorSurfaceSubtle: Color(0x12D6E2EE),
  colorSurfaceInset: Color(0xFF23313A),
  colorSurfaceRaised: Color(0xFF43515A),
  colorSurfaceOverlay: Color(0xFF1D2B34),
  colorSurfaceChrome: Color(0xFF1D2B34),
  colorSurfaceColumn: Color(0xFF142029),
  colorContent: Color(0xFFD6E2EE),
  colorContentSecondary: Color(0xFFB3C0CB),
  colorContentNav: Color(0xFFA0ADB8),
  colorContentMuted: Color(0xFF919EA9),
  colorContentSubtle: Color(0xFF76838E),
  colorContentFaint: Color(0xFF5B6872),
  colorBorder: Color(0x29D6E2EE),
  colorBorderStrong: Color(0x33D6E2EE),
  colorBorderMuted: Color(0xFF5F6C76),
  colorOnAccent: Color(0xFF16242D),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF8BC9EB),
  progressGradientTo: Color(0xFFB9E4FC),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyLumonDark,
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

/// The `omarchy-lupine-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyLupineLight = ThemeVariables(
  colorCanvas: Color(0xFFE8E8E8),
  colorSurface: Color(0xFFFAFAFA),
  colorSurfaceMuted: Color(0xFFF2F2F2),
  colorSurfaceSunken: Color(0xFFDCDCDC),
  colorSurfaceSubtle: Color(0x0F212121),
  colorSurfaceInset: Color(0xFFEAEAEA),
  colorSurfaceRaised: Color(0xFFFAFAFA),
  colorSurfaceOverlay: Color(0xFFFAFAFA),
  colorSurfaceChrome: Color(0xFFF2F2F2),
  colorSurfaceColumn: Color(0xFFF5F5F5),
  colorContent: Color(0xFF212121),
  colorContentSecondary: Color(0xFF484848),
  colorContentNav: Color(0xFF5E5E5E),
  colorContentMuted: Color(0xFF6F6F6F),
  colorContentSubtle: Color(0xFF8E8E8E),
  colorContentFaint: Color(0xFFACACAC),
  colorBorder: Color(0x21212121),
  colorBorderStrong: Color(0x2B212121),
  colorBorderMuted: Color(0xFFA8A8A8),
  colorOnAccent: Color(0xFFFAFAFA),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF3264EB),
  progressGradientTo: Color(0xFFA7C3FD),
  colorPrimary: Colors.omarchyLupineLight,
);

/// The `omarchy-lupine-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyLupineDark = ThemeVariables(
  colorCanvas: Color(0xFF080808),
  colorSurface: Color(0xFF0F0F0F),
  colorSurfaceMuted: Color(0xFF171717),
  colorSurfaceSunken: Color(0xFF252525),
  colorSurfaceSubtle: Color(0x12FAFAFA),
  colorSurfaceInset: Color(0xFF1D1D1D),
  colorSurfaceRaised: Color(0xFF3A3A3A),
  colorSurfaceOverlay: Color(0xFF171717),
  colorSurfaceChrome: Color(0xFF171717),
  colorSurfaceColumn: Color(0xFF0A0A0A),
  colorContent: Color(0xFFFAFAFA),
  colorContentSecondary: Color(0xFFD0D0D0),
  colorContentNav: Color(0xFFB8B8B8),
  colorContentMuted: Color(0xFFA5A5A5),
  colorContentSubtle: Color(0xFF848484),
  colorContentFaint: Color(0xFF646464),
  colorBorder: Color(0x29FAFAFA),
  colorBorderStrong: Color(0x33FAFAFA),
  colorBorderMuted: Color(0xFF686868),
  colorOnAccent: Color(0xFF0F0F0F),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF809FF3),
  progressGradientTo: Color(0xFFBDCFFB),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyLupineDark,
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

/// The `omarchy-matte-black-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyMatteBlackLight = ThemeVariables(
  colorCanvas: Color(0xFFDFDFDF),
  colorSurface: Color(0xFFF1F1F1),
  colorSurfaceMuted: Color(0xFFE9E9E9),
  colorSurfaceSunken: Color(0xFFD3D3D3),
  colorSurfaceSubtle: Color(0x0F121212),
  colorSurfaceInset: Color(0xFFE1E1E1),
  colorSurfaceRaised: Color(0xFFF1F1F1),
  colorSurfaceOverlay: Color(0xFFF1F1F1),
  colorSurfaceChrome: Color(0xFFE9E9E9),
  colorSurfaceColumn: Color(0xFFECECEC),
  colorContent: Color(0xFF121212),
  colorContentSecondary: Color(0xFF3A3A3A),
  colorContentNav: Color(0xFF505050),
  colorContentMuted: Color(0xFF626262),
  colorContentSubtle: Color(0xFF828282),
  colorContentFaint: Color(0xFFA1A1A1),
  colorBorder: Color(0x21121212),
  colorBorderStrong: Color(0x2B121212),
  colorBorderMuted: Color(0xFF9C9C9C),
  colorOnAccent: Color(0xFFF1F1F1),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF8F5808),
  progressGradientTo: Color(0xFFE0B589),
  colorPrimary: Colors.omarchyMatteBlackLight,
);

/// The `omarchy-matte-black-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyMatteBlackDark = ThemeVariables(
  colorCanvas: Color(0xFF0C0C0C),
  colorSurface: Color(0xFF121212),
  colorSurfaceMuted: Color(0xFF191919),
  colorSurfaceSunken: Color(0xFF272727),
  colorSurfaceSubtle: Color(0x12BEBEBE),
  colorSurfaceInset: Color(0xFF1F1F1F),
  colorSurfaceRaised: Color(0xFF3D3D3D),
  colorSurfaceOverlay: Color(0xFF191919),
  colorSurfaceChrome: Color(0xFF191919),
  colorSurfaceColumn: Color(0xFF0D0D0D),
  colorContent: Color(0xFFBEBEBE),
  colorContentSecondary: Color(0xFF9F9F9F),
  colorContentNav: Color(0xFF8E8E8E),
  colorContentMuted: Color(0xFF808080),
  colorContentSubtle: Color(0xFF686868),
  colorContentFaint: Color(0xFF505050),
  colorBorder: Color(0x29BEBEBE),
  colorBorderStrong: Color(0x33BEBEBE),
  colorBorderMuted: Color(0xFF535353),
  colorOnAccent: Color(0xFF121212),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFFE68E0D),
  progressGradientTo: Color(0xFFFDC489),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyMatteBlackDark,
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

/// The `omarchy-miasma-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyMiasmaLight = ThemeVariables(
  colorCanvas: Color(0xFFE0E0DD),
  colorSurface: Color(0xFFF2F2EE),
  colorSurfaceMuted: Color(0xFFEAEAE7),
  colorSurfaceSunken: Color(0xFFD4D4D1),
  colorSurfaceSubtle: Color(0x10222222),
  colorSurfaceInset: Color(0xFFE2E2DF),
  colorSurfaceRaised: Color(0xFFF2F2EE),
  colorSurfaceOverlay: Color(0xFFF2F2EE),
  colorSurfaceChrome: Color(0xFFEAEAE7),
  colorSurfaceColumn: Color(0xFFEDEDEA),
  colorContent: Color(0xFF222222),
  colorContentSecondary: Color(0xFF474747),
  colorContentNav: Color(0xFF5C5C5B),
  colorContentMuted: Color(0xFF6D6D6B),
  colorContentSubtle: Color(0xFF8A8A88),
  colorContentFaint: Color(0xFFA7A7A5),
  colorBorder: Color(0x21222222),
  colorBorderStrong: Color(0x2B222222),
  colorBorderMuted: Color(0xFFA3A3A0),
  colorOnAccent: Color(0xFFF2F2EE),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF4A512F),
  progressGradientTo: Color(0xFFB1B79D),
  colorPrimary: Colors.omarchyMiasmaLight,
);

/// The `omarchy-miasma-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyMiasmaDark = ThemeVariables(
  colorCanvas: Color(0xFF1D1D1D),
  colorSurface: Color(0xFF222222),
  colorSurfaceMuted: Color(0xFF292928),
  colorSurfaceSunken: Color(0xFF383835),
  colorSurfaceSubtle: Color(0x13C2C2B0),
  colorSurfaceInset: Color(0xFF2F2F2D),
  colorSurfaceRaised: Color(0xFF4F4F49),
  colorSurfaceOverlay: Color(0xFF292928),
  colorSurfaceChrome: Color(0xFF292928),
  colorSurfaceColumn: Color(0xFF1E1E1E),
  colorContent: Color(0xFFC2C2B0),
  colorContentSecondary: Color(0xFFA5A596),
  colorContentNav: Color(0xFF959588),
  colorContentMuted: Color(0xFF8C8C80),
  colorContentSubtle: Color(0xFF727269),
  colorContentFaint: Color(0xFF5C5C55),
  colorBorder: Color(0x29C2C2B0),
  colorBorderStrong: Color(0x33C2C2B0),
  colorBorderMuted: Color(0xFF5F5F58),
  colorOnAccent: Color(0xFF222222),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF78824B),
  progressGradientTo: Color(0xFFB9C19A),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyMiasmaDark,
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

/// The `omarchy-nord-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyNordLight = ThemeVariables(
  colorCanvas: Color(0xFFE4E7E9),
  colorSurface: Color(0xFFF6F8FA),
  colorSurfaceMuted: Color(0xFFEEF1F3),
  colorSurfaceSunken: Color(0xFFD7DADE),
  colorSurfaceSubtle: Color(0x112E3440),
  colorSurfaceInset: Color(0xFFE6E8EB),
  colorSurfaceRaised: Color(0xFFF6F8FA),
  colorSurfaceOverlay: Color(0xFFF6F8FA),
  colorSurfaceChrome: Color(0xFFEEF1F3),
  colorSurfaceColumn: Color(0xFFF1F3F6),
  colorContent: Color(0xFF2E3440),
  colorContentSecondary: Color(0xFF525761),
  colorContentNav: Color(0xFF666B74),
  colorContentMuted: Color(0xFF6C717A),
  colorContentSubtle: Color(0xFF92969D),
  colorContentFaint: Color(0xFFAEB1B7),
  colorBorder: Color(0x212E3440),
  colorBorderStrong: Color(0x2B2E3440),
  colorBorderMuted: Color(0xFFAAAEB3),
  colorOnAccent: Color(0xFFF6F8FA),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF506478),
  progressGradientTo: Color(0xFFAFBECE),
  colorPrimary: Colors.omarchyNordLight,
);

/// The `omarchy-nord-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyNordDark = ThemeVariables(
  colorCanvas: Color(0xFF2A2F3A),
  colorSurface: Color(0xFF2E3440),
  colorSurfaceMuted: Color(0xFF353B46),
  colorSurfaceSunken: Color(0xFF454B56),
  colorSurfaceSubtle: Color(0x13D8DEE9),
  colorSurfaceInset: Color(0xFF3C424D),
  colorSurfaceRaised: Color(0xFF5D636E),
  colorSurfaceOverlay: Color(0xFF353B46),
  colorSurfaceChrome: Color(0xFF353B46),
  colorSurfaceColumn: Color(0xFF2B303C),
  colorContent: Color(0xFFD8DEE9),
  colorContentSecondary: Color(0xFFB9BFCB),
  colorContentNav: Color(0xFFA8AEBA),
  colorContentMuted: Color(0xFF9BA1AC),
  colorContentSubtle: Color(0xFF838994),
  colorContentFaint: Color(0xFF6B717D),
  colorBorder: Color(0x29D8DEE9),
  colorBorderStrong: Color(0x33D8DEE9),
  colorBorderMuted: Color(0xFF6F7580),
  colorOnAccent: Color(0xFF2E3440),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF81A1C1),
  progressGradientTo: Color(0xFFB8CFE7),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyNordDark,
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

/// The `omarchy-osaka-jade-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyOsakaJadeLight = ThemeVariables(
  colorCanvas: Color(0xFFDFE1D8),
  colorSurface: Color(0xFFF1F2E8),
  colorSurfaceMuted: Color(0xFFE9EBE1),
  colorSurfaceSunken: Color(0xFFD2D4CB),
  colorSurfaceSubtle: Color(0x0F111C18),
  colorSurfaceInset: Color(0xFFE1E2D9),
  colorSurfaceRaised: Color(0xFFF1F2E8),
  colorSurfaceOverlay: Color(0xFFF1F2E8),
  colorSurfaceChrome: Color(0xFFE9EBE1),
  colorSurfaceColumn: Color(0xFFECEDE4),
  colorContent: Color(0xFF111C18),
  colorContentSecondary: Color(0xFF39433D),
  colorContentNav: Color(0xFF505852),
  colorContentMuted: Color(0xFF626963),
  colorContentSubtle: Color(0xFF818780),
  colorContentFaint: Color(0xFFA0A59D),
  colorBorder: Color(0x21111C18),
  colorBorderStrong: Color(0x2B111C18),
  colorBorderMuted: Color(0xFF9CA199),
  colorOnAccent: Color(0xFFF1F2E8),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF325C49),
  progressGradientTo: Color(0xFF9FBEAE),
  colorPrimary: Colors.omarchyOsakaJadeLight,
);

/// The `omarchy-osaka-jade-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyOsakaJadeDark = ThemeVariables(
  colorCanvas: Color(0xFF0E1714),
  colorSurface: Color(0xFF111C18),
  colorSurfaceMuted: Color(0xFF18221D),
  colorSurfaceSunken: Color(0xFF273128),
  colorSurfaceSubtle: Color(0x12C1C497),
  colorSurfaceInset: Color(0xFF1E2921),
  colorSurfaceRaised: Color(0xFF3F4839),
  colorSurfaceOverlay: Color(0xFF18221D),
  colorSurfaceChrome: Color(0xFF18221D),
  colorSurfaceColumn: Color(0xFF0F1815),
  colorContent: Color(0xFFC1C497),
  colorContentSecondary: Color(0xFFA1A680),
  colorContentNav: Color(0xFF909573),
  colorContentMuted: Color(0xFF828869),
  colorContentSubtle: Color(0xFF697058),
  colorContentFaint: Color(0xFF505846),
  colorBorder: Color(0x29C1C497),
  colorBorderStrong: Color(0x33C1C497),
  colorBorderMuted: Color(0xFF545C48),
  colorOnAccent: Color(0xFF111C18),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF509475),
  progressGradientTo: Color(0xFF9ECDB5),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyOsakaJadeDark,
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

/// The `omarchy-retro-82-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyRetro82Light = ThemeVariables(
  colorCanvas: Color(0xFFEAE6DF),
  colorSurface: Color(0xFFFDF7ED),
  colorSurfaceMuted: Color(0xFFF5EFE7),
  colorSurfaceSunken: Color(0xFFDCD9D4),
  colorSurfaceSubtle: Color(0x0F05182E),
  colorSurfaceInset: Color(0xFFECE7E0),
  colorSurfaceRaised: Color(0xFFFDF7ED),
  colorSurfaceOverlay: Color(0xFFFDF7ED),
  colorSurfaceChrome: Color(0xFFF5EFE7),
  colorSurfaceColumn: Color(0xFFF8F2E9),
  colorContent: Color(0xFF05182E),
  colorContentSecondary: Color(0xFF324050),
  colorContentNav: Color(0xFF4A5663),
  colorContentMuted: Color(0xFF5E6873),
  colorContentSubtle: Color(0xFF81888E),
  colorContentFaint: Color(0xFFA4A7A8),
  colorBorder: Color(0x2105182E),
  colorBorderStrong: Color(0x2B05182E),
  colorBorderMuted: Color(0xFF9FA2A4),
  colorOnAccent: Color(0xFFFDF7ED),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF9B6940),
  progressGradientTo: Color(0xFFE3BC9E),
  colorPrimary: Colors.omarchyRetro82Light,
);

/// The `omarchy-retro-82-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyRetro82Dark = ThemeVariables(
  colorCanvas: Color(0xFF041425),
  colorSurface: Color(0xFF05182E),
  colorSurfaceMuted: Color(0xFF0D1F32),
  colorSurfaceSunken: Color(0xFF1F2E3C),
  colorSurfaceSubtle: Color(0x12F6DCAC),
  colorSurfaceInset: Color(0xFF142536),
  colorSurfaceRaised: Color(0xFF3A444A),
  colorSurfaceOverlay: Color(0xFF0D1F32),
  colorSurfaceChrome: Color(0xFF0D1F32),
  colorSurfaceColumn: Color(0xFF041528),
  colorContent: Color(0xFFF6DCAC),
  colorContentSecondary: Color(0xFFCBB995),
  colorContentNav: Color(0xFFB3A589),
  colorContentMuted: Color(0xFF9F957F),
  colorContentSubtle: Color(0xFF7E7A6D),
  colorContentFaint: Color(0xFF5C5F5B),
  colorBorder: Color(0x29F6DCAC),
  colorBorderStrong: Color(0x33F6DCAC),
  colorBorderMuted: Color(0xFF61625E),
  colorOnAccent: Color(0xFF05182E),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFFFAA968),
  progressGradientTo: Color(0xFFFDD3B3),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyRetro82Dark,
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

/// The `omarchy-ristretto-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyRistrettoLight = ThemeVariables(
  colorCanvas: Color(0xFFE9E5E5),
  colorSurface: Color(0xFFFAF7F7),
  colorSurfaceMuted: Color(0xFFF3EFEF),
  colorSurfaceSunken: Color(0xFFDCD9D9),
  colorSurfaceSubtle: Color(0x102C2525),
  colorSurfaceInset: Color(0xFFEBE7E7),
  colorSurfaceRaised: Color(0xFFFAF7F7),
  colorSurfaceOverlay: Color(0xFFFAF7F7),
  colorSurfaceChrome: Color(0xFFF3EFEF),
  colorSurfaceColumn: Color(0xFFF6F2F2),
  colorContent: Color(0xFF2C2525),
  colorContentSecondary: Color(0xFF514B4B),
  colorContentNav: Color(0xFF666060),
  colorContentMuted: Color(0xFF746F6F),
  colorContentSubtle: Color(0xFF938E8E),
  colorContentFaint: Color(0xFFB0ABAB),
  colorBorder: Color(0x212C2525),
  colorBorderStrong: Color(0x2B2C2525),
  colorBorderMuted: Color(0xFFACA7A7),
  colorOnAccent: Color(0xFFFAF7F7),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF975745),
  progressGradientTo: Color(0xFFE5B3A4),
  colorPrimary: Colors.omarchyRistrettoLight,
);

/// The `omarchy-ristretto-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyRistrettoDark = ThemeVariables(
  colorCanvas: Color(0xFF272121),
  colorSurface: Color(0xFF2C2525),
  colorSurfaceMuted: Color(0xFF332C2C),
  colorSurfaceSunken: Color(0xFF423B3B),
  colorSurfaceSubtle: Color(0x12E6D9DB),
  colorSurfaceInset: Color(0xFF393232),
  colorSurfaceRaised: Color(0xFF5A5252),
  colorSurfaceOverlay: Color(0xFF332C2C),
  colorSurfaceChrome: Color(0xFF332C2C),
  colorSurfaceColumn: Color(0xFF282222),
  colorContent: Color(0xFFE6D9DB),
  colorContentSecondary: Color(0xFFC5B9BA),
  colorContentNav: Color(0xFFB2A7A8),
  colorContentMuted: Color(0xFFA39899),
  colorContentSubtle: Color(0xFF897F80),
  colorContentFaint: Color(0xFF6F6667),
  colorBorder: Color(0x29E6D9DB),
  colorBorderStrong: Color(0x33E6D9DB),
  colorBorderMuted: Color(0xFF73696A),
  colorOnAccent: Color(0xFF2C2525),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFFF38D70),
  progressGradientTo: Color(0xFFFCC5B5),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyRistrettoDark,
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

/// The `omarchy-rose-pine-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyRosePineLight = ThemeVariables(
  colorCanvas: Color(0xFFE8E2E0),
  colorSurface: Color(0xFFFAF4ED),
  colorSurfaceMuted: Color(0xFFF2ECE8),
  colorSurfaceSunken: Color(0xFFDBD5D7),
  colorSurfaceSubtle: Color(0x16575279),
  colorSurfaceInset: Color(0xFFE9E4E1),
  colorSurfaceRaised: Color(0xFFFAF4ED),
  colorSurfaceOverlay: Color(0xFFFAF4ED),
  colorSurfaceChrome: Color(0xFFF2ECE8),
  colorSurfaceColumn: Color(0xFFF5EFEA),
  colorContent: Color(0xFF575279),
  colorContentSecondary: Color(0xFF6F6A8A),
  colorContentNav: Color(0xFF6F6A8A),
  colorContentMuted: Color(0xFF6F6A8A),
  colorContentSubtle: Color(0xFFA9A3B3),
  colorContentFaint: Color(0xFFBFBAC3),
  colorBorder: Color(0x21575279),
  colorBorderStrong: Color(0x2B575279),
  colorBorderMuted: Color(0xFFBCB6C1),
  colorOnAccent: Color(0xFFFAF4ED),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF56949F),
  progressGradientTo: Color(0xFFAAD5DD),
  colorPrimary: Colors.omarchyRosePineLight,
);

/// The `omarchy-rose-pine-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyRosePineDark = ThemeVariables(
  colorCanvas: Color(0xFF232130),
  colorSurface: Color(0xFF272536),
  colorSurfaceMuted: Color(0xFF2E2C3C),
  colorSurfaceSunken: Color(0xFF3D3B4A),
  colorSurfaceSubtle: Color(0x12FAF4ED),
  colorSurfaceInset: Color(0xFF343242),
  colorSurfaceRaised: Color(0xFF55535E),
  colorSurfaceOverlay: Color(0xFF2E2C3C),
  colorSurfaceChrome: Color(0xFF2E2C3C),
  colorSurfaceColumn: Color(0xFF242231),
  colorContent: Color(0xFFFAF4ED),
  colorContentSecondary: Color(0xFFD4CFCC),
  colorContentNav: Color(0xFFBFBABA),
  colorContentMuted: Color(0xFFAEA9AB),
  colorContentSubtle: Color(0xFF918D92),
  colorContentFaint: Color(0xFF737078),
  colorBorder: Color(0x29FAF4ED),
  colorBorderStrong: Color(0x33FAF4ED),
  colorBorderMuted: Color(0xFF77747C),
  colorOnAccent: Color(0xFF272536),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF96BDC3),
  progressGradientTo: Color(0xFFC2DEE2),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyRosePineDark,
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

/// The `omarchy-solitude-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchySolitudeLight = ThemeVariables(
  colorCanvas: Color(0xFFE1E3E3),
  colorSurface: Color(0xFFF3F4F4),
  colorSurfaceMuted: Color(0xFFEBEDED),
  colorSurfaceSunken: Color(0xFFD5D6D7),
  colorSurfaceSubtle: Color(0x0F101315),
  colorSurfaceInset: Color(0xFFE3E4E5),
  colorSurfaceRaised: Color(0xFFF3F4F4),
  colorSurfaceOverlay: Color(0xFFF3F4F4),
  colorSurfaceChrome: Color(0xFFEBEDED),
  colorSurfaceColumn: Color(0xFFEEEFF0),
  colorContent: Color(0xFF101315),
  colorContentSecondary: Color(0xFF393C3D),
  colorContentNav: Color(0xFF505253),
  colorContentMuted: Color(0xFF626465),
  colorContentSubtle: Color(0xFF828485),
  colorContentFaint: Color(0xFFA1A3A4),
  colorBorder: Color(0x21101315),
  colorBorderStrong: Color(0x2B101315),
  colorBorderMuted: Color(0xFF9D9F9F),
  colorOnAccent: Color(0xFFF3F4F4),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF4B5053),
  progressGradientTo: Color(0xFFB1B5B7),
  colorPrimary: Colors.omarchySolitudeLight,
);

/// The `omarchy-solitude-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchySolitudeDark = ThemeVariables(
  colorCanvas: Color(0xFF0B0D0F),
  colorSurface: Color(0xFF101315),
  colorSurfaceMuted: Color(0xFF171A1B),
  colorSurfaceSunken: Color(0xFF252829),
  colorSurfaceSubtle: Color(0x12CACCCC),
  colorSurfaceInset: Color(0xFF1D2021),
  colorSurfaceRaised: Color(0xFF3B3E3F),
  colorSurfaceOverlay: Color(0xFF171A1B),
  colorSurfaceChrome: Color(0xFF171A1B),
  colorSurfaceColumn: Color(0xFF0C0F10),
  colorContent: Color(0xFFCACCCC),
  colorContentSecondary: Color(0xFFA9ABAB),
  colorContentNav: Color(0xFF969899),
  colorContentMuted: Color(0xFF87898A),
  colorContentSubtle: Color(0xFF6D7071),
  colorContentFaint: Color(0xFF535657),
  colorBorder: Color(0x29CACCCC),
  colorBorderStrong: Color(0x33CACCCC),
  colorBorderMuted: Color(0xFF57595B),
  colorOnAccent: Color(0xFF101315),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF798186),
  progressGradientTo: Color(0xFFB9BFC3),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchySolitudeDark,
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

/// The `omarchy-vantablack-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyVantablackLight = ThemeVariables(
  colorCanvas: Color(0xFFEDEDED),
  colorSurface: Color(0xFFFFFFFF),
  colorSurfaceMuted: Color(0xFFF7F7F7),
  colorSurfaceSunken: Color(0xFFE0E0E0),
  colorSurfaceSubtle: Color(0x0F000000),
  colorSurfaceInset: Color(0xFFEFEFEF),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceOverlay: Color(0xFFFFFFFF),
  colorSurfaceChrome: Color(0xFFF7F7F7),
  colorSurfaceColumn: Color(0xFFFAFAFA),
  colorContent: Color(0xFF000000),
  colorContentSecondary: Color(0xFF2E2E2E),
  colorContentNav: Color(0xFF474747),
  colorContentMuted: Color(0xFF5C5C5C),
  colorContentSubtle: Color(0xFF808080),
  colorContentFaint: Color(0xFFA3A3A3),
  colorBorder: Color(0x21000000),
  colorBorderStrong: Color(0x2B000000),
  colorBorderMuted: Color(0xFF9E9E9E),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF575757),
  progressGradientTo: Color(0xFFB8B8B8),
  colorPrimary: Colors.omarchyVantablackLight,
);

/// The `omarchy-vantablack-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyVantablackDark = ThemeVariables(
  colorCanvas: Color(0xFF080808),
  colorSurface: Color(0xFF000000),
  colorSurfaceMuted: Color(0xFF0B0B0B),
  colorSurfaceSunken: Color(0xFF1C1C1C),
  colorSurfaceSubtle: Color(0x13FFFFFF),
  colorSurfaceInset: Color(0xFF141414),
  colorSurfaceRaised: Color(0xFF313131),
  colorSurfaceOverlay: Color(0xFF0B0B0B),
  colorSurfaceChrome: Color(0xFF0B0B0B),
  colorSurfaceColumn: Color(0xFF060606),
  colorContent: Color(0xFFFFFFFF),
  colorContentSecondary: Color(0xFFD1D1D1),
  colorContentNav: Color(0xFFB8B8B8),
  colorContentMuted: Color(0xFFA3A3A3),
  colorContentSubtle: Color(0xFF808080),
  colorContentFaint: Color(0xFF5C5C5C),
  colorBorder: Color(0x29FFFFFF),
  colorBorderStrong: Color(0x33FFFFFF),
  colorBorderMuted: Color(0xFF616161),
  colorOnAccent: Color(0xFF000000),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF8D8D8D),
  progressGradientTo: Color(0xFFC4C4C4),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyVantablackDark,
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

/// The `omarchy-white-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyWhiteLight = ThemeVariables(
  colorCanvas: Color(0xFFEDEDED),
  colorSurface: Color(0xFFFFFFFF),
  colorSurfaceMuted: Color(0xFFF7F7F7),
  colorSurfaceSunken: Color(0xFFE0E0E0),
  colorSurfaceSubtle: Color(0x0F000000),
  colorSurfaceInset: Color(0xFFEFEFEF),
  colorSurfaceRaised: Color(0xFFFFFFFF),
  colorSurfaceOverlay: Color(0xFFFFFFFF),
  colorSurfaceChrome: Color(0xFFF7F7F7),
  colorSurfaceColumn: Color(0xFFFAFAFA),
  colorContent: Color(0xFF000000),
  colorContentSecondary: Color(0xFF2E2E2E),
  colorContentNav: Color(0xFF474747),
  colorContentMuted: Color(0xFF5C5C5C),
  colorContentSubtle: Color(0xFF808080),
  colorContentFaint: Color(0xFFA3A3A3),
  colorBorder: Color(0x21000000),
  colorBorderStrong: Color(0x2B000000),
  colorBorderMuted: Color(0xFF9E9E9E),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFF6E6E6E),
  progressGradientTo: Color(0xFFC1C1C1),
  colorPrimary: Colors.omarchyWhiteLight,
);

/// The `omarchy-white-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesOmarchyWhiteDark = ThemeVariables(
  colorCanvas: Color(0xFF080808),
  colorSurface: Color(0xFF000000),
  colorSurfaceMuted: Color(0xFF0B0B0B),
  colorSurfaceSunken: Color(0xFF1C1C1C),
  colorSurfaceSubtle: Color(0x13FFFFFF),
  colorSurfaceInset: Color(0xFF141414),
  colorSurfaceRaised: Color(0xFF313131),
  colorSurfaceOverlay: Color(0xFF0B0B0B),
  colorSurfaceChrome: Color(0xFF0B0B0B),
  colorSurfaceColumn: Color(0xFF060606),
  colorContent: Color(0xFFFFFFFF),
  colorContentSecondary: Color(0xFFD1D1D1),
  colorContentNav: Color(0xFFB8B8B8),
  colorContentMuted: Color(0xFFA3A3A3),
  colorContentSubtle: Color(0xFF808080),
  colorContentFaint: Color(0xFF5C5C5C),
  colorBorder: Color(0x29FFFFFF),
  colorBorderStrong: Color(0x33FFFFFF),
  colorBorderMuted: Color(0xFF616161),
  colorOnAccent: Color(0xFF000000),
  controlFieldRadius: 0,
  controlContainerRadius: 0,
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
  frameWindowRadius: 0,
  framePopoverRadius: 0,
  radiusTiny: 0,
  radiusSmall: 0,
  radiusMedium: 0,
  radiusLarge: 0,
  radiusBig: 0,
  checkboxRadius: 0,
  progressGradientFrom: Color(0xFFA5A5A5),
  progressGradientTo: Color(0xFFD0D0D0),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.omarchyWhiteDark,
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

/// The `macos27-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesMacos27Light = ThemeVariables(
  colorCanvas: Color(0xFFE3E3E5),
  colorSurface: Color(0xFFF5F5F7),
  colorSurfaceMuted: Color(0xFFEDEDEF),
  colorSurfaceSunken: Color(0xFFD7D7D9),
  colorSurfaceSubtle: Color(0x10252525),
  colorSurfaceInset: Color(0xFFE5E5E7),
  colorSurfaceRaised: Color(0xFFF5F5F7),
  colorSurfaceOverlay: Color(0xFFF5F5F7),
  colorSurfaceChrome: Color(0xFFEDEDEF),
  colorSurfaceColumn: Color(0xFFF0F0F2),
  colorContent: Color(0xFF252525),
  colorContentSecondary: Color(0xFF4A4A4B),
  colorContentNav: Color(0xFF5F5F60),
  colorContentMuted: Color(0xFF6D6D6E),
  colorContentSubtle: Color(0xFF8D8D8E),
  colorContentFaint: Color(0xFFAAAAAB),
  colorBorder: Color(0x12252525),
  colorBorderStrong: Color(0x1A252525),
  colorBorderMuted: Color(0xFFA6A6A7),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 8,
  controlContainerRadius: 10,
  controlTinySize: 20,
  controlSmallSize: 24,
  controlMediumPaddingInline: 18,
  controlMediumSize: 28,
  controlLargeSize: 32,
  frameWindowRadius: 16,
  framePopoverRadius: 16,
  radiusTiny: 6,
  radiusSmall: 9999,
  radiusMedium: 9999,
  radiusLarge: 10,
  radiusBig: 16,
  titleSmallFontSize: 13,
  titleSmallLineHeight: 16,
  titleMediumFontSize: 15,
  titleMediumLineHeight: 20,
  titleLargeFontSize: 17,
  titleLargeLineHeight: 22,
  bodySmallFontSize: 11,
  bodySmallLineHeight: 14,
  bodyMediumFontSize: 13,
  bodyMediumLineHeight: 16,
  bodyLargeFontSize: 15,
  bodyLargeLineHeight: 20,
  labelQuietFontSize: 13,
  labelQuietLineHeight: 13,
  labelStrongFontSize: 13,
  labelStrongLineHeight: 13,
  labelSmallFontSize: 10,
  labelSmallLineHeight: 10,
  labelMediumFontSize: 13,
  labelMediumLineHeight: 13,
  labelLargeFontSize: 13,
  labelLargeLineHeight: 13,
  captionSmallFontSize: 10,
  captionSmallLineHeight: 13,
  captionMediumFontSize: 11,
  captionMediumLineHeight: 14,
  captionLargeFontSize: 13,
  captionLargeLineHeight: 16,
  checkboxRadius: 4,
  progressGradientFrom: Color(0xFF0088FF),
  progressGradientTo: Color(0xFFABD0FE),
  colorPrimary: Colors.macos27Light,
);

/// The `macos27-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesMacos27Dark = ThemeVariables(
  colorCanvas: Color(0xFF1E1E21),
  colorSurface: Color(0xFF232326),
  colorSurfaceMuted: Color(0xFF2A2A2C),
  colorSurfaceSunken: Color(0xFF39393B),
  colorSurfaceSubtle: Color(0x12DEDEDF),
  colorSurfaceInset: Color(0xFF303032),
  colorSurfaceRaised: Color(0xFF505052),
  colorSurfaceOverlay: Color(0xFF2A2A2C),
  colorSurfaceChrome: Color(0xFF2A2A2C),
  colorSurfaceColumn: Color(0xFF202022),
  colorContent: Color(0xFFDEDEDF),
  colorContentSecondary: Color(0xFFBDBDBD),
  colorContentNav: Color(0xFFAAAAAB),
  colorContentMuted: Color(0xFF9B9B9C),
  colorContentSubtle: Color(0xFF818182),
  colorContentFaint: Color(0xFF666668),
  colorBorder: Color(0x14DEDEDF),
  colorBorderStrong: Color(0x1CDEDEDF),
  colorBorderMuted: Color(0xFF6A6A6C),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 8,
  controlContainerRadius: 10,
  controlTinySize: 20,
  controlSmallSize: 24,
  controlMediumPaddingInline: 18,
  controlMediumSize: 28,
  controlLargeSize: 32,
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
  framePopoverRadius: 16,
  radiusTiny: 6,
  radiusSmall: 9999,
  radiusMedium: 9999,
  radiusLarge: 10,
  radiusBig: 16,
  titleSmallFontSize: 13,
  titleSmallLineHeight: 16,
  titleMediumFontSize: 15,
  titleMediumLineHeight: 20,
  titleLargeFontSize: 17,
  titleLargeLineHeight: 22,
  bodySmallFontSize: 11,
  bodySmallLineHeight: 14,
  bodyMediumFontSize: 13,
  bodyMediumLineHeight: 16,
  bodyLargeFontSize: 15,
  bodyLargeLineHeight: 20,
  labelQuietFontSize: 13,
  labelQuietLineHeight: 13,
  labelStrongFontSize: 13,
  labelStrongLineHeight: 13,
  labelSmallFontSize: 10,
  labelSmallLineHeight: 10,
  labelMediumFontSize: 13,
  labelMediumLineHeight: 13,
  labelLargeFontSize: 13,
  labelLargeLineHeight: 13,
  captionSmallFontSize: 10,
  captionSmallLineHeight: 13,
  captionMediumFontSize: 11,
  captionMediumLineHeight: 14,
  captionLargeFontSize: 13,
  captionLargeLineHeight: 16,
  checkboxRadius: 4,
  progressGradientFrom: Color(0xFF0091FF),
  progressGradientTo: Color(0xFF9CCAFE),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.macos27Dark,
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

/// The `macos15-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesMacos15Light = ThemeVariables(
  colorCanvas: Color(0xFFDADADA),
  colorSurface: Color(0xFFECECEC),
  colorSurfaceMuted: Color(0xFFE4E4E4),
  colorSurfaceSunken: Color(0xFFCECECE),
  colorSurfaceSubtle: Color(0x10232323),
  colorSurfaceInset: Color(0xFFDCDCDC),
  colorSurfaceRaised: Color(0xFFECECEC),
  colorSurfaceOverlay: Color(0xFFECECEC),
  colorSurfaceChrome: Color(0xFFE4E4E4),
  colorSurfaceColumn: Color(0xFFE7E7E7),
  colorContent: Color(0xFF232323),
  colorContentSecondary: Color(0xFF474747),
  colorContentNav: Color(0xFF5B5B5B),
  colorContentMuted: Color(0xFF696969),
  colorContentSubtle: Color(0xFF888888),
  colorContentFaint: Color(0xFFA4A4A4),
  colorBorder: Color(0x1A232323),
  colorBorderStrong: Color(0x21232323),
  colorBorderMuted: Color(0xFFA0A0A0),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 6,
  controlContainerRadius: 6,
  controlTinySize: 16,
  controlSmallSize: 19,
  controlMediumPaddingInline: 12,
  controlMediumSize: 22,
  controlLargeSize: 28,
  frameWindowRadius: 10,
  framePopoverRadius: 10,
  radiusTiny: 4,
  radiusSmall: 6,
  radiusMedium: 6,
  radiusLarge: 6,
  radiusBig: 10,
  titleSmallFontSize: 13,
  titleSmallLineHeight: 16,
  titleMediumFontSize: 15,
  titleMediumLineHeight: 20,
  titleLargeFontSize: 17,
  titleLargeLineHeight: 22,
  bodySmallFontSize: 11,
  bodySmallLineHeight: 14,
  bodyMediumFontSize: 13,
  bodyMediumLineHeight: 16,
  bodyLargeFontSize: 15,
  bodyLargeLineHeight: 20,
  labelQuietFontSize: 13,
  labelQuietLineHeight: 13,
  labelStrongFontSize: 13,
  labelStrongLineHeight: 13,
  labelSmallFontSize: 10,
  labelSmallLineHeight: 10,
  labelMediumFontSize: 13,
  labelMediumLineHeight: 13,
  labelLargeFontSize: 13,
  labelLargeLineHeight: 13,
  captionSmallFontSize: 10,
  captionSmallLineHeight: 13,
  captionMediumFontSize: 11,
  captionMediumLineHeight: 14,
  captionLargeFontSize: 13,
  captionLargeLineHeight: 16,
  checkboxRadius: 3,
  progressGradientFrom: Color(0xFF007AFF),
  progressGradientTo: Color(0xFFA8CCFE),
  colorPrimary: Colors.macos15Light,
);

/// The `macos15-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesMacos15Dark = ThemeVariables(
  colorCanvas: Color(0xFF2D2D2D),
  colorSurface: Color(0xFF323232),
  colorSurfaceMuted: Color(0xFF393939),
  colorSurfaceSunken: Color(0xFF494949),
  colorSurfaceSubtle: Color(0x13E0E0E0),
  colorSurfaceInset: Color(0xFF404040),
  colorSurfaceRaised: Color(0xFF616161),
  colorSurfaceOverlay: Color(0xFF393939),
  colorSurfaceChrome: Color(0xFF393939),
  colorSurfaceColumn: Color(0xFF2E2E2E),
  colorContent: Color(0xFFE0E0E0),
  colorContentSecondary: Color(0xFFC1C1C1),
  colorContentNav: Color(0xFFB0B0B0),
  colorContentMuted: Color(0xFFA2A2A2),
  colorContentSubtle: Color(0xFF898989),
  colorContentFaint: Color(0xFF717171),
  colorBorder: Color(0x1AE0E0E0),
  colorBorderStrong: Color(0x21E0E0E0),
  colorBorderMuted: Color(0xFF747474),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 6,
  controlContainerRadius: 6,
  controlTinySize: 16,
  controlSmallSize: 19,
  controlMediumPaddingInline: 12,
  controlMediumSize: 22,
  controlLargeSize: 28,
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
  frameWindowRadius: 10,
  framePopoverRadius: 10,
  radiusTiny: 4,
  radiusSmall: 6,
  radiusMedium: 6,
  radiusLarge: 6,
  radiusBig: 10,
  titleSmallFontSize: 13,
  titleSmallLineHeight: 16,
  titleMediumFontSize: 15,
  titleMediumLineHeight: 20,
  titleLargeFontSize: 17,
  titleLargeLineHeight: 22,
  bodySmallFontSize: 11,
  bodySmallLineHeight: 14,
  bodyMediumFontSize: 13,
  bodyMediumLineHeight: 16,
  bodyLargeFontSize: 15,
  bodyLargeLineHeight: 20,
  labelQuietFontSize: 13,
  labelQuietLineHeight: 13,
  labelStrongFontSize: 13,
  labelStrongLineHeight: 13,
  labelSmallFontSize: 10,
  labelSmallLineHeight: 10,
  labelMediumFontSize: 13,
  labelMediumLineHeight: 13,
  labelLargeFontSize: 13,
  labelLargeLineHeight: 13,
  captionSmallFontSize: 10,
  captionSmallLineHeight: 13,
  captionMediumFontSize: 11,
  captionMediumLineHeight: 14,
  captionLargeFontSize: 13,
  captionLargeLineHeight: 16,
  checkboxRadius: 3,
  progressGradientFrom: Color(0xFF0A84FF),
  progressGradientTo: Color(0xFF99C5FE),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.macos15Dark,
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

/// The `windows11-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesWindows11Light = ThemeVariables(
  colorCanvas: Color(0xFFE1E1E1),
  colorSurface: Color(0xFFF3F3F3),
  colorSurfaceMuted: Color(0xFFEBEBEB),
  colorSurfaceSunken: Color(0xFFD5D5D5),
  colorSurfaceSubtle: Color(0x0F181818),
  colorSurfaceInset: Color(0xFFE3E3E3),
  colorSurfaceRaised: Color(0xFFF3F3F3),
  colorSurfaceOverlay: Color(0xFFF3F3F3),
  colorSurfaceChrome: Color(0xFFEBEBEB),
  colorSurfaceColumn: Color(0xFFEEEEEE),
  colorContent: Color(0xFF181818),
  colorContentSecondary: Color(0xFF3F3F3F),
  colorContentNav: Color(0xFF555555),
  colorContentMuted: Color(0xFF676767),
  colorContentSubtle: Color(0xFF858585),
  colorContentFaint: Color(0xFFA4A4A4),
  colorBorder: Color(0x14181818),
  colorBorderStrong: Color(0x1C181818),
  colorBorderMuted: Color(0xFFA0A0A0),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 4,
  controlContainerRadius: 4,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 11,
  controlMediumSize: 32,
  controlLargeSize: 40,
  frameWindowRadius: 8,
  framePopoverRadius: 8,
  radiusTiny: 4,
  radiusSmall: 4,
  radiusMedium: 4,
  radiusLarge: 8,
  radiusBig: 8,
  titleSmallFontSize: 14,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 18,
  titleMediumLineHeight: 24,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 28,
  bodySmallFontSize: 12,
  bodySmallLineHeight: 16,
  bodyMediumFontSize: 14,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 18,
  bodyLargeLineHeight: 24,
  labelQuietFontSize: 14,
  labelQuietLineHeight: 14,
  labelStrongFontSize: 14,
  labelStrongLineHeight: 14,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14,
  labelMediumLineHeight: 14,
  labelLargeFontSize: 14,
  labelLargeLineHeight: 14,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 16,
  captionMediumFontSize: 12,
  captionMediumLineHeight: 16,
  captionLargeFontSize: 14,
  captionLargeLineHeight: 20,
  checkboxRadius: 4,
  progressGradientFrom: Color(0xFF005FB8),
  progressGradientTo: Color(0xFF8FBFFC),
  colorPrimary: Colors.windows11Light,
);

/// The `windows11-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesWindows11Dark = ThemeVariables(
  colorCanvas: Color(0xFF1B1B1B),
  colorSurface: Color(0xFF202020),
  colorSurfaceMuted: Color(0xFF272727),
  colorSurfaceSunken: Color(0xFF363636),
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF2D2D2D),
  colorSurfaceRaised: Color(0xFF4C4C4C),
  colorSurfaceOverlay: Color(0xFF272727),
  colorSurfaceChrome: Color(0xFF272727),
  colorSurfaceColumn: Color(0xFF1C1C1C),
  colorContent: Color(0xFFFFFFFF),
  colorContentSecondary: Color(0xFFD7D7D7),
  colorContentNav: Color(0xFFC1C1C1),
  colorContentMuted: Color(0xFFAFAFAF),
  colorContentSubtle: Color(0xFF909090),
  colorContentFaint: Color(0xFF707070),
  colorBorder: Color(0x14FFFFFF),
  colorBorderStrong: Color(0x1CFFFFFF),
  colorBorderMuted: Color(0xFF757575),
  colorOnAccent: Color(0xFF000000),
  controlFieldRadius: 4,
  controlContainerRadius: 4,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 11,
  controlMediumSize: 32,
  controlLargeSize: 40,
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
  frameWindowRadius: 8,
  framePopoverRadius: 8,
  radiusTiny: 4,
  radiusSmall: 4,
  radiusMedium: 4,
  radiusLarge: 8,
  radiusBig: 8,
  titleSmallFontSize: 14,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 18,
  titleMediumLineHeight: 24,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 28,
  bodySmallFontSize: 12,
  bodySmallLineHeight: 16,
  bodyMediumFontSize: 14,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 18,
  bodyLargeLineHeight: 24,
  labelQuietFontSize: 14,
  labelQuietLineHeight: 14,
  labelStrongFontSize: 14,
  labelStrongLineHeight: 14,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14,
  labelMediumLineHeight: 14,
  labelLargeFontSize: 14,
  labelLargeLineHeight: 14,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 16,
  captionMediumFontSize: 12,
  captionMediumLineHeight: 16,
  captionLargeFontSize: 14,
  captionLargeLineHeight: 20,
  checkboxRadius: 4,
  progressGradientFrom: Color(0xFF60CDFF),
  progressGradientTo: Color(0xFFB3E5FF),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.windows11Dark,
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

/// The `ubuntu-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesUbuntuLight = ThemeVariables(
  colorCanvas: Color(0xFFE8E8E8),
  colorSurface: Color(0xFFFAFAFA),
  colorSurfaceMuted: Color(0xFFF2F2F2),
  colorSurfaceSunken: Color(0xFFDCDCDC),
  colorSurfaceSubtle: Color(0x113D3D3D),
  colorSurfaceInset: Color(0xFFEAEAEA),
  colorSurfaceRaised: Color(0xFFFAFAFA),
  colorSurfaceOverlay: Color(0xFFFAFAFA),
  colorSurfaceChrome: Color(0xFFF2F2F2),
  colorSurfaceColumn: Color(0xFFF5F5F5),
  colorContent: Color(0xFF3D3D3D),
  colorContentSecondary: Color(0xFF5F5F5F),
  colorContentNav: Color(0xFF727272),
  colorContentMuted: Color(0xFF727272),
  colorContentSubtle: Color(0xFF9C9C9C),
  colorContentFaint: Color(0xFFB6B6B6),
  colorBorder: Color(0x1A3D3D3D),
  colorBorderStrong: Color(0x213D3D3D),
  colorBorderMuted: Color(0xFFB2B2B2),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 9,
  controlContainerRadius: 12,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 12,
  controlMediumSize: 34,
  controlLargeSize: 40,
  frameWindowRadius: 15,
  framePopoverRadius: 12,
  radiusTiny: 6,
  radiusSmall: 9,
  radiusMedium: 9,
  radiusLarge: 12,
  radiusBig: 12,
  titleSmallFontSize: 14.5,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 16.5,
  titleMediumLineHeight: 22,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 26,
  bodySmallFontSize: 12.5,
  bodySmallLineHeight: 17,
  bodyMediumFontSize: 14.5,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 16.5,
  bodyLargeLineHeight: 22,
  labelQuietFontSize: 14.5,
  labelQuietLineHeight: 14.5,
  labelStrongFontSize: 14.5,
  labelStrongLineHeight: 14.5,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14.5,
  labelMediumLineHeight: 14.5,
  labelLargeFontSize: 14.5,
  labelLargeLineHeight: 14.5,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 15,
  captionMediumFontSize: 12.5,
  captionMediumLineHeight: 17,
  captionLargeFontSize: 14.5,
  captionLargeLineHeight: 20,
  checkboxRadius: 6,
  progressGradientFrom: Color(0xFFE95420),
  progressGradientTo: Color(0xFFFDBCA8),
  colorPrimary: Colors.ubuntuLight,
);

/// The `ubuntu-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesUbuntuDark = ThemeVariables(
  colorCanvas: Color(0xFF272727),
  colorSurface: Color(0xFF2C2C2C),
  colorSurfaceMuted: Color(0xFF333333),
  colorSurfaceSunken: Color(0xFF434343),
  colorSurfaceSubtle: Color(0x12F7F7F7),
  colorSurfaceInset: Color(0xFF3A3A3A),
  colorSurfaceRaised: Color(0xFF5A5A5A),
  colorSurfaceOverlay: Color(0xFF333333),
  colorSurfaceChrome: Color(0xFF333333),
  colorSurfaceColumn: Color(0xFF282828),
  colorContent: Color(0xFFF7F7F7),
  colorContentSecondary: Color(0xFFD2D2D2),
  colorContentNav: Color(0xFFBEBEBE),
  colorContentMuted: Color(0xFFAEAEAE),
  colorContentSubtle: Color(0xFF929292),
  colorContentFaint: Color(0xFF757575),
  colorBorder: Color(0x1AF7F7F7),
  colorBorderStrong: Color(0x21F7F7F7),
  colorBorderMuted: Color(0xFF797979),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 9,
  controlContainerRadius: 12,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 12,
  controlMediumSize: 34,
  controlLargeSize: 40,
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
  frameWindowRadius: 15,
  framePopoverRadius: 12,
  radiusTiny: 6,
  radiusSmall: 9,
  radiusMedium: 9,
  radiusLarge: 12,
  radiusBig: 12,
  titleSmallFontSize: 14.5,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 16.5,
  titleMediumLineHeight: 22,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 26,
  bodySmallFontSize: 12.5,
  bodySmallLineHeight: 17,
  bodyMediumFontSize: 14.5,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 16.5,
  bodyLargeLineHeight: 22,
  labelQuietFontSize: 14.5,
  labelQuietLineHeight: 14.5,
  labelStrongFontSize: 14.5,
  labelStrongLineHeight: 14.5,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14.5,
  labelMediumLineHeight: 14.5,
  labelLargeFontSize: 14.5,
  labelLargeLineHeight: 14.5,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 15,
  captionMediumFontSize: 12.5,
  captionMediumLineHeight: 17,
  captionLargeFontSize: 14.5,
  captionLargeLineHeight: 20,
  checkboxRadius: 6,
  progressGradientFrom: Color(0xFFE95420),
  progressGradientTo: Color(0xFFFDAE96),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.ubuntuDark,
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

/// The `debian-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesDebianLight = ThemeVariables(
  colorCanvas: Color(0xFFE8E8EA),
  colorSurface: Color(0xFFFAFAFB),
  colorSurfaceMuted: Color(0xFFF2F2F4),
  colorSurfaceSunken: Color(0xFFDCDCDD),
  colorSurfaceSubtle: Color(0x11323237),
  colorSurfaceInset: Color(0xFFEAEAEC),
  colorSurfaceRaised: Color(0xFFFAFAFB),
  colorSurfaceOverlay: Color(0xFFFAFAFB),
  colorSurfaceChrome: Color(0xFFF2F2F4),
  colorSurfaceColumn: Color(0xFFF5F5F7),
  colorContent: Color(0xFF323237),
  colorContentSecondary: Color(0xFF56565A),
  colorContentNav: Color(0xFF6A6A6E),
  colorContentMuted: Color(0xFF707074),
  colorContentSubtle: Color(0xFF969699),
  colorContentFaint: Color(0xFFB2B2B4),
  colorBorder: Color(0x1A323237),
  colorBorderStrong: Color(0x21323237),
  colorBorderMuted: Color(0xFFAEAEB1),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 9,
  controlContainerRadius: 12,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 12,
  controlMediumSize: 34,
  controlLargeSize: 40,
  frameWindowRadius: 15,
  framePopoverRadius: 12,
  radiusTiny: 6,
  radiusSmall: 9,
  radiusMedium: 9,
  radiusLarge: 12,
  radiusBig: 12,
  titleSmallFontSize: 14.5,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 16.5,
  titleMediumLineHeight: 22,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 26,
  bodySmallFontSize: 12.5,
  bodySmallLineHeight: 17,
  bodyMediumFontSize: 14.5,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 16.5,
  bodyLargeLineHeight: 22,
  labelQuietFontSize: 14.5,
  labelQuietLineHeight: 14.5,
  labelStrongFontSize: 14.5,
  labelStrongLineHeight: 14.5,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14.5,
  labelMediumLineHeight: 14.5,
  labelLargeFontSize: 14.5,
  labelLargeLineHeight: 14.5,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 15,
  captionMediumFontSize: 12.5,
  captionMediumLineHeight: 17,
  captionLargeFontSize: 14.5,
  captionLargeLineHeight: 20,
  checkboxRadius: 6,
  progressGradientFrom: Color(0xFF3584E4),
  progressGradientTo: Color(0xFFAACDFC),
  colorPrimary: Colors.debianLight,
);

/// The `debian-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesDebianDark = ThemeVariables(
  colorCanvas: Color(0xFF1E1E21),
  colorSurface: Color(0xFF222226),
  colorSurfaceMuted: Color(0xFF29292C),
  colorSurfaceSunken: Color(0xFF38383B),
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF2F2F32),
  colorSurfaceRaised: Color(0xFF4F4F52),
  colorSurfaceOverlay: Color(0xFF29292C),
  colorSurfaceChrome: Color(0xFF29292C),
  colorSurfaceColumn: Color(0xFF1F1F22),
  colorContent: Color(0xFFFFFFFF),
  colorContentSecondary: Color(0xFFD7D7D8),
  colorContentNav: Color(0xFFC1C1C2),
  colorContentMuted: Color(0xFFAFAFB1),
  colorContentSubtle: Color(0xFF919193),
  colorContentFaint: Color(0xFF727274),
  colorBorder: Color(0x1AFFFFFF),
  colorBorderStrong: Color(0x21FFFFFF),
  colorBorderMuted: Color(0xFF767678),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 9,
  controlContainerRadius: 12,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 12,
  controlMediumSize: 34,
  controlLargeSize: 40,
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
  frameWindowRadius: 15,
  framePopoverRadius: 12,
  radiusTiny: 6,
  radiusSmall: 9,
  radiusMedium: 9,
  radiusLarge: 12,
  radiusBig: 12,
  titleSmallFontSize: 14.5,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 16.5,
  titleMediumLineHeight: 22,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 26,
  bodySmallFontSize: 12.5,
  bodySmallLineHeight: 17,
  bodyMediumFontSize: 14.5,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 16.5,
  bodyLargeLineHeight: 22,
  labelQuietFontSize: 14.5,
  labelQuietLineHeight: 14.5,
  labelStrongFontSize: 14.5,
  labelStrongLineHeight: 14.5,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14.5,
  labelMediumLineHeight: 14.5,
  labelLargeFontSize: 14.5,
  labelLargeLineHeight: 14.5,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 15,
  captionMediumFontSize: 12.5,
  captionMediumLineHeight: 17,
  captionLargeFontSize: 14.5,
  captionLargeLineHeight: 20,
  checkboxRadius: 6,
  progressGradientFrom: Color(0xFF3584E4),
  progressGradientTo: Color(0xFF98C3FC),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.debianDark,
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

/// The `fedora-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesFedoraLight = ThemeVariables(
  colorCanvas: Color(0xFFE8E8EA),
  colorSurface: Color(0xFFFAFAFB),
  colorSurfaceMuted: Color(0xFFF2F2F4),
  colorSurfaceSunken: Color(0xFFDCDCDD),
  colorSurfaceSubtle: Color(0x11323237),
  colorSurfaceInset: Color(0xFFEAEAEC),
  colorSurfaceRaised: Color(0xFFFAFAFB),
  colorSurfaceOverlay: Color(0xFFFAFAFB),
  colorSurfaceChrome: Color(0xFFF2F2F4),
  colorSurfaceColumn: Color(0xFFF5F5F7),
  colorContent: Color(0xFF323237),
  colorContentSecondary: Color(0xFF56565A),
  colorContentNav: Color(0xFF6A6A6E),
  colorContentMuted: Color(0xFF707074),
  colorContentSubtle: Color(0xFF969699),
  colorContentFaint: Color(0xFFB2B2B4),
  colorBorder: Color(0x1A323237),
  colorBorderStrong: Color(0x21323237),
  colorBorderMuted: Color(0xFFAEAEB1),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 9,
  controlContainerRadius: 12,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 12,
  controlMediumSize: 34,
  controlLargeSize: 40,
  frameWindowRadius: 15,
  framePopoverRadius: 12,
  radiusTiny: 6,
  radiusSmall: 9,
  radiusMedium: 9,
  radiusLarge: 12,
  radiusBig: 12,
  titleSmallFontSize: 14.5,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 16.5,
  titleMediumLineHeight: 22,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 26,
  bodySmallFontSize: 12.5,
  bodySmallLineHeight: 17,
  bodyMediumFontSize: 14.5,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 16.5,
  bodyLargeLineHeight: 22,
  labelQuietFontSize: 14.5,
  labelQuietLineHeight: 14.5,
  labelStrongFontSize: 14.5,
  labelStrongLineHeight: 14.5,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14.5,
  labelMediumLineHeight: 14.5,
  labelLargeFontSize: 14.5,
  labelLargeLineHeight: 14.5,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 15,
  captionMediumFontSize: 12.5,
  captionMediumLineHeight: 17,
  captionLargeFontSize: 14.5,
  captionLargeLineHeight: 20,
  checkboxRadius: 6,
  progressGradientFrom: Color(0xFF3584E4),
  progressGradientTo: Color(0xFFAACDFC),
  colorPrimary: Colors.fedoraLight,
);

/// The `fedora-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesFedoraDark = ThemeVariables(
  colorCanvas: Color(0xFF1E1E21),
  colorSurface: Color(0xFF222226),
  colorSurfaceMuted: Color(0xFF29292C),
  colorSurfaceSunken: Color(0xFF38383B),
  colorSurfaceSubtle: Color(0x12FFFFFF),
  colorSurfaceInset: Color(0xFF2F2F32),
  colorSurfaceRaised: Color(0xFF4F4F52),
  colorSurfaceOverlay: Color(0xFF29292C),
  colorSurfaceChrome: Color(0xFF29292C),
  colorSurfaceColumn: Color(0xFF1F1F22),
  colorContent: Color(0xFFFFFFFF),
  colorContentSecondary: Color(0xFFD7D7D8),
  colorContentNav: Color(0xFFC1C1C2),
  colorContentMuted: Color(0xFFAFAFB1),
  colorContentSubtle: Color(0xFF919193),
  colorContentFaint: Color(0xFF727274),
  colorBorder: Color(0x1AFFFFFF),
  colorBorderStrong: Color(0x21FFFFFF),
  colorBorderMuted: Color(0xFF767678),
  colorOnAccent: Color(0xFFFFFFFF),
  controlFieldRadius: 9,
  controlContainerRadius: 12,
  controlTinySize: 24,
  controlSmallSize: 28,
  controlMediumPaddingInline: 12,
  controlMediumSize: 34,
  controlLargeSize: 40,
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
  frameWindowRadius: 15,
  framePopoverRadius: 12,
  radiusTiny: 6,
  radiusSmall: 9,
  radiusMedium: 9,
  radiusLarge: 12,
  radiusBig: 12,
  titleSmallFontSize: 14.5,
  titleSmallLineHeight: 20,
  titleMediumFontSize: 16.5,
  titleMediumLineHeight: 22,
  titleLargeFontSize: 20,
  titleLargeLineHeight: 26,
  bodySmallFontSize: 12.5,
  bodySmallLineHeight: 17,
  bodyMediumFontSize: 14.5,
  bodyMediumLineHeight: 20,
  bodyLargeFontSize: 16.5,
  bodyLargeLineHeight: 22,
  labelQuietFontSize: 14.5,
  labelQuietLineHeight: 14.5,
  labelStrongFontSize: 14.5,
  labelStrongLineHeight: 14.5,
  labelSmallFontSize: 12,
  labelSmallLineHeight: 12,
  labelMediumFontSize: 14.5,
  labelMediumLineHeight: 14.5,
  labelLargeFontSize: 14.5,
  labelLargeLineHeight: 14.5,
  captionSmallFontSize: 12,
  captionSmallLineHeight: 15,
  captionMediumFontSize: 12.5,
  captionMediumLineHeight: 17,
  captionLargeFontSize: 14.5,
  captionLargeLineHeight: 20,
  checkboxRadius: 6,
  progressGradientFrom: Color(0xFF3584E4),
  progressGradientTo: Color(0xFF98C3FC),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.fedoraDark,
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

/// The `kde-light` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesKdeLight = ThemeVariables(
  colorCanvas: Color(0xFFDDDFE0),
  colorSurface: Color(0xFFEFF0F1),
  colorSurfaceMuted: Color(0xFFE7E9EA),
  colorSurfaceSunken: Color(0xFFD1D2D4),
  colorSurfaceSubtle: Color(0x10232629),
  colorSurfaceInset: Color(0xFFDFE0E2),
  colorSurfaceRaised: Color(0xFFEFF0F1),
  colorSurfaceOverlay: Color(0xFFEFF0F1),
  colorSurfaceChrome: Color(0xFFE7E9EA),
  colorSurfaceColumn: Color(0xFFEAEBED),
  colorContent: Color(0xFF232629),
  colorContentSecondary: Color(0xFF484A4D),
  colorContentNav: Color(0xFF5C5F61),
  colorContentMuted: Color(0xFF686B6D),
  colorContentSubtle: Color(0xFF898B8D),
  colorContentFaint: Color(0xFFA6A7A9),
  colorBorder: Color(0x21232629),
  colorBorderStrong: Color(0x2B232629),
  colorBorderMuted: Color(0xFFA1A3A5),
  colorOnAccent: Color(0xFF232629),
  controlFieldRadius: 5,
  controlContainerRadius: 5,
  controlTinySize: 22,
  controlSmallSize: 26,
  controlMediumPaddingInline: 6,
  controlMediumSize: 30,
  controlLargeSize: 36,
  frameWindowRadius: 5,
  framePopoverRadius: 5,
  radiusTiny: 3,
  radiusSmall: 5,
  radiusMedium: 5,
  radiusLarge: 5,
  radiusBig: 5,
  titleSmallFontSize: 13.33,
  titleSmallLineHeight: 18,
  titleMediumFontSize: 16,
  titleMediumLineHeight: 21,
  titleLargeFontSize: 18.67,
  titleLargeLineHeight: 24,
  bodySmallFontSize: 11.5,
  bodySmallLineHeight: 15,
  bodyMediumFontSize: 13.33,
  bodyMediumLineHeight: 18,
  bodyLargeFontSize: 16,
  bodyLargeLineHeight: 21,
  labelQuietFontSize: 13.33,
  labelQuietLineHeight: 13.33,
  labelStrongFontSize: 13.33,
  labelStrongLineHeight: 13.33,
  labelSmallFontSize: 10.67,
  labelSmallLineHeight: 10.67,
  labelMediumFontSize: 13.33,
  labelMediumLineHeight: 13.33,
  labelLargeFontSize: 13.33,
  labelLargeLineHeight: 13.33,
  captionSmallFontSize: 10.67,
  captionSmallLineHeight: 14,
  captionMediumFontSize: 11.5,
  captionMediumLineHeight: 15,
  captionLargeFontSize: 13.33,
  captionLargeLineHeight: 18,
  checkboxRadius: 3,
  progressGradientFrom: Color(0xFF3DAEE9),
  progressGradientTo: Color(0xFFADDEFD),
  colorPrimary: Colors.kdeLight,
);

/// The `kde-dark` counterpart of [themeVariables].
///
/// Every token that moves under this theme is named here; the rest fall
/// through to the default, and the derived getters follow this instance.
/// DO NOT EDIT - This file is auto-generated
const themeVariablesKdeDark = ThemeVariables(
  colorCanvas: Color(0xFF1C1E21),
  colorSurface: Color(0xFF202326),
  colorSurfaceMuted: Color(0xFF272A2C),
  colorSurfaceSunken: Color(0xFF36393B),
  colorSurfaceSubtle: Color(0x12FCFCFC),
  colorSurfaceInset: Color(0xFF2D3032),
  colorSurfaceRaised: Color(0xFF4D5052),
  colorSurfaceOverlay: Color(0xFF272A2C),
  colorSurfaceChrome: Color(0xFF272A2C),
  colorSurfaceColumn: Color(0xFF1D2022),
  colorContent: Color(0xFFFCFCFC),
  colorContentSecondary: Color(0xFFD4D5D5),
  colorContentNav: Color(0xFFBEBFC0),
  colorContentMuted: Color(0xFFADAEAF),
  colorContentSubtle: Color(0xFF8E9091),
  colorContentFaint: Color(0xFF6F7173),
  colorBorder: Color(0x29FCFCFC),
  colorBorderStrong: Color(0x33FCFCFC),
  colorBorderMuted: Color(0xFF747577),
  colorOnAccent: Color(0xFF202326),
  controlFieldRadius: 5,
  controlContainerRadius: 5,
  controlTinySize: 22,
  controlSmallSize: 26,
  controlMediumPaddingInline: 6,
  controlMediumSize: 30,
  controlLargeSize: 36,
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
  frameWindowRadius: 5,
  framePopoverRadius: 5,
  radiusTiny: 3,
  radiusSmall: 5,
  radiusMedium: 5,
  radiusLarge: 5,
  radiusBig: 5,
  titleSmallFontSize: 13.33,
  titleSmallLineHeight: 18,
  titleMediumFontSize: 16,
  titleMediumLineHeight: 21,
  titleLargeFontSize: 18.67,
  titleLargeLineHeight: 24,
  bodySmallFontSize: 11.5,
  bodySmallLineHeight: 15,
  bodyMediumFontSize: 13.33,
  bodyMediumLineHeight: 18,
  bodyLargeFontSize: 16,
  bodyLargeLineHeight: 21,
  labelQuietFontSize: 13.33,
  labelQuietLineHeight: 13.33,
  labelStrongFontSize: 13.33,
  labelStrongLineHeight: 13.33,
  labelSmallFontSize: 10.67,
  labelSmallLineHeight: 10.67,
  labelMediumFontSize: 13.33,
  labelMediumLineHeight: 13.33,
  labelLargeFontSize: 13.33,
  labelLargeLineHeight: 13.33,
  captionSmallFontSize: 10.67,
  captionSmallLineHeight: 14,
  captionMediumFontSize: 11.5,
  captionMediumLineHeight: 15,
  captionLargeFontSize: 13.33,
  captionLargeLineHeight: 18,
  checkboxRadius: 3,
  progressGradientFrom: Color(0xFF3DAEE9),
  progressGradientTo: Color(0xFF9AD8FE),
  colorDanger: Colors.redDark,
  colorPrimary: Colors.kdeDark,
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
