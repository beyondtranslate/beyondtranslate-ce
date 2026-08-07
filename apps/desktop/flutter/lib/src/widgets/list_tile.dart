import 'package:flutter/widgets.dart';

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Pressable,
        PressableState,
        kTransitionDuration;

enum ListTileTone {
  standard,

  /// The row the view treats as current — the default provider, the active
  /// book.
  accent,

  /// The row that needs attention — an expired key, a failed import.
  warn,
}

enum ListTileVariant {
  /// The boxed row an onboarding step picks from.
  card,

  /// The settings list, where the row sits flush with the rows below it and
  /// carries no box of its own — only a hover wash, so a run of them reads as
  /// one list.
  ///
  /// The deck pulls this variant 8px into the gutter (`-mx-2 px-2`) so the wash
  /// is wider than the content column; reproduce that by dropping 8px of the
  /// container's own horizontal padding.
  row,
}

/// A settings row: leading mark, name, an optional badge, a de-emphasised meta
/// line beside it, and trailing controls.
///
/// One line, deliberately: the deck's list rows are 34px and the detail page
/// carries everything that does not fit — the same split the macOS list makes.
class ListTile extends StatelessWidget {
  const ListTile({
    super.key,
    this.leading,
    required this.title,
    this.meta,
    this.badge,
    this.trailing = const [],
    this.variant = ListTileVariant.card,
    this.tone = ListTileTone.standard,
    this.onPressed,
  });

  /// Usually an [Avatar]; any widget works.
  final Widget? leading;
  final Widget title;

  /// The de-emphasised detail beside the name — claude-sonnet-4-5 · 密钥有效.
  final Widget? meta;

  /// Sits right after the title.
  final Widget? badge;

  /// Right-aligned controls — capability tags, a shortcut hint, a switch.
  final List<Widget> trailing;

  final ListTileVariant variant;
  final ListTileTone tone;

  /// Makes the row open its detail page — hover wash, pointer cursor.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final card = variant == ListTileVariant.card;
    final radius = BorderRadius.circular(
      card ? tokens.radii.control : tokens.radii.controlSm,
    );

    final (Color background, Color borderColor) = switch (tone) {
      ListTileTone.standard => (colors.card, colors.hairline),
      ListTileTone.accent => (colors.accentSurface, colors.accentHairline),
      ListTileTone.warn => (colors.warnSurface, colors.warnHairline),
    };

    Widget row(BuildContext context, PressableState state) {
      return AnimatedContainer(
        duration: kTransitionDuration,
        padding: card
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: card
              ? background
              : (onPressed != null && state.hovered
                  ? colors.accent.withValues(alpha: 0.08)
                  : null),
          border: card
              ? Border.all(
                  color: onPressed != null && state.hovered
                      ? colors.accentHairline
                      : borderColor,
                  width: context.hairlineWidth,
                )
              : null,
          borderRadius: radius,
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            DefaultTextStyle(
              style: tokens.typography.sansStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
                color: colors.fg,
              ),
              child: title,
            ),
            if (badge != null) ...[const SizedBox(width: 8), badge!],
            if (meta != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: DefaultTextStyle(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      height: 1,
                      color: tone == ListTileTone.warn
                          ? colors.warnFg
                          : colors.fgSubtle,
                    ),
                    child: meta!,
                  ),
                ),
              )
            else
              const Spacer(),
            for (var i = 0; i < trailing.length; i++) ...[
              SizedBox(width: i == 0 ? 8 : 10),
              trailing[i],
            ],
          ],
        ),
      );
    }

    if (onPressed == null) {
      return row(context, const PressableState());
    }

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      isButton: false,
      builder: row,
    );
  }
}
