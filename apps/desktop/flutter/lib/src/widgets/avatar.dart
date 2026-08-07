import 'package:flutter/widgets.dart';

import 'ui.dart' show DesignThemeContext, DesignTypographyStyles;

/// xs 16px · sm 18px · md 24px · lg 26px, matching the deck.
enum AvatarSize { xs, sm, md, lg }

/// The rounded-square identity mark used in cards, lists and the extension.
///
/// It carries no product knowledge: the caller supplies the glyph and the
/// brand colour. The palette ships the shipped providers' brand colours as
/// `context.colors.providerClaude` and friends.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.label,
    required this.color,
    this.foregroundColor = const Color(0xFFFFFFFF),
    this.size = AvatarSize.sm,
  });

  /// The glyph — an initial, or a single ideograph.
  final String label;
  final Color color;
  final Color foregroundColor;
  final AvatarSize size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (double box, double fontSize) = switch (size) {
      AvatarSize.xs => (16, 10),
      AvatarSize.sm => (18, 11),
      AvatarSize.md => (24, 12),
      AvatarSize.lg => (26, 13),
    };

    return ExcludeSemantics(
      child: Container(
        width: box,
        height: box,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(tokens.radii.avatar),
        ),
        child: Text(
          label,
          style: tokens.typography.displayStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 1,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
