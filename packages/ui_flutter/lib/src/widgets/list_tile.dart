import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum ListTileTone {
  standard,

  /// The row the view treats as current — the default engine, the active book.
  accent,

  /// The row that needs attention — an expired key, a failed import.
  warn,
}

/// A bordered settings row: leading mark, title with an optional badge, a
/// secondary line, and trailing controls. Settings → 已启用的引擎 is built from
/// these.
class ListTile extends StatelessWidget {
  const ListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.badge,
    this.trailing = const [],
    this.tone = ListTileTone.standard,
  });

  /// Usually an [Avatar]; any widget works.
  final Widget? leading;
  final Widget title;

  /// The de-emphasised second line — claude-sonnet-4-5 · 密钥有效.
  final Widget? subtitle;

  /// Sits right after the title.
  final Widget? badge;

  /// Right-aligned controls — a shortcut hint, a switch.
  final List<Widget> trailing;
  final ListTileTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final (Color background, Color borderColor) = switch (tone) {
      ListTileTone.standard => (colors.card, colors.border),
      ListTileTone.accent => (colors.accentSurface, colors.accentBorder),
      ListTileTone.warn => (colors.warnSurface, colors.warnBorder),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: context.hairlineWidth),
        borderRadius: BorderRadius.circular(tokens.radii.card),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: DefaultTextStyle(
                        style: tokens.typography.sansStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          color: colors.fg,
                        ),
                        child: title,
                      ),
                    ),
                    if (badge != null) ...[const SizedBox(width: 8), badge!],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  DefaultTextStyle(
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      color: tone == ListTileTone.warn
                          ? colors.warnFg
                          : colors.fgSubtle,
                    ),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          for (final item in trailing) ...[const SizedBox(width: 12), item],
        ],
      ),
    );
  }
}
