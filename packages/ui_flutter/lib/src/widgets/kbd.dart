import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum KbdVariant {
  /// Ambient hint sitting next to a label — ⌘K, ⌥2.
  hint,

  /// Same, one step more present.
  strong,

  /// Boxed key, as listed in Settings → 快捷键.
  key,
}

enum KbdSize { sm, md, lg }

class Kbd extends StatelessWidget {
  const Kbd(
    this.text, {
    super.key,
    this.variant = KbdVariant.hint,
    this.size = KbdSize.md,
  });

  final String text;
  final KbdVariant variant;
  final KbdSize size;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final fontSize = switch (size) {
      KbdSize.sm => 11.0,
      KbdSize.md => 11.0,
      KbdSize.lg => 12.0,
    };

    final (Color foreground, FontWeight weight) = switch (variant) {
      KbdVariant.hint => (colors.fgFaint, FontWeight.w600),
      KbdVariant.strong => (colors.fgSubtle, FontWeight.w600),
      KbdVariant.key => (colors.fg, FontWeight.w700),
    };

    final label = Text(
      text,
      softWrap: false,
      style: tokens.typography.displayStyle(
        fontSize: fontSize,
        fontWeight: weight,
        height: 1,
        color: foreground,
      ),
    );

    if (variant != KbdVariant.key) return label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.inset,
        borderRadius: BorderRadius.circular(tokens.radii.chip),
      ),
      child: label,
    );
  }
}
