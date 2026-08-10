import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum SurfaceTone {
  /// White card on a tinted pane — the default card.
  raised,

  /// Grey card on white — 其他服务 cards, form fields.
  card,

  /// Flat grey, no hairline — mini-window service candidates.
  subtle,

  /// Accent-tinted — the preferred translation, active list rows.
  accent,
  warn,
  danger,

  /// No fill; only the hairline.
  outline,
  none,
}

enum SurfaceRadius {
  card,

  /// Containers that grow with their content. Safe under pill themes.
  box,

  /// Only for boxes shaped like a single control; a theme may pill this.
  control,
  window,
  popover,
  pill,
  none,
}

enum SurfacePadding { none, xs, sm, md, lg }

/// The generic filled/bordered box every panel in the design is built from.
class Surface extends StatelessWidget {
  const Surface({
    super.key,
    this.tone = SurfaceTone.card,
    this.radius = SurfaceRadius.card,
    this.padding = SurfacePadding.md,
    this.width,
    this.height,
    this.clip = false,
    this.child,
  });

  final SurfaceTone tone;
  final SurfaceRadius radius;
  final SurfacePadding padding;
  final double? width;
  final double? height;

  /// Clip the child to the corner radius — the `overflow-hidden` companion.
  final bool clip;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final hairline = context.hairlineWidth;

    final (Color? background, Color? borderColor) = switch (tone) {
      SurfaceTone.raised => (colors.raised, colors.hairline),
      SurfaceTone.card => (colors.card, colors.hairline),
      SurfaceTone.subtle => (colors.subtle, null),
      SurfaceTone.accent => (colors.accentSurface, colors.accentHairline),
      SurfaceTone.warn => (colors.warnSurface, colors.warnHairline),
      SurfaceTone.danger => (colors.dangerSurface, colors.dangerHairline),
      SurfaceTone.outline => (null, colors.hairline),
      SurfaceTone.none => (null, null),
    };

    final borderRadius = BorderRadius.circular(switch (radius) {
      SurfaceRadius.card => tokens.radii.card,
      SurfaceRadius.box => tokens.radii.box,
      SurfaceRadius.control => tokens.radii.control,
      SurfaceRadius.window => tokens.radii.window,
      SurfaceRadius.popover => tokens.radii.popover,
      SurfaceRadius.pill => tokens.radii.pill,
      SurfaceRadius.none => 0,
    });

    final insets = switch (padding) {
      SurfacePadding.none => EdgeInsets.zero,
      SurfacePadding.xs => const EdgeInsets.all(10),
      SurfacePadding.sm => const EdgeInsets.all(12),
      SurfacePadding.md => const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      SurfacePadding.lg => const EdgeInsets.all(16),
    };

    return Container(
      width: width,
      height: height,
      padding: insets,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: background,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: hairline),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

enum DividerTone {
  standard,

  /// Matches the 6% hairline used between list rows.
  soft,
  strong,
}

class Divider extends StatelessWidget {
  const Divider({super.key, this.tone = DividerTone.standard});

  final DividerTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: context.hairlineWidth,
      width: double.infinity,
      color: switch (tone) {
        DividerTone.standard => colors.hairline,
        DividerTone.soft => colors.hairlineSoft,
        DividerTone.strong => colors.hairlineStrong,
      },
    );
  }
}
