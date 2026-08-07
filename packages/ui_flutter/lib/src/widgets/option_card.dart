import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// Selectable format card — PDF / DOCX / Markdown in the export dialog.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    this.description,
    this.selected = false,
    this.onSelect,
  });

  final Widget title;
  final Widget? description;
  final bool selected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(13);

    return Pressable(
      onPressed: onSelect,
      borderRadius: radius,
      checked: selected,
      isButton: false,
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? colors.accentSurface
              : (state.hovered ? colors.subtle : colors.card),
          borderRadius: radius,
          border: Border.all(
            color: selected ? colors.highlight : colors.hairline,
            width: selected ? 1.5 : context.hairlineWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: tokens.typography.displayStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
                color: colors.fg,
              ),
              child: title,
            ),
            if (description != null) ...[
              const SizedBox(height: 5),
              DefaultTextStyle(
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: selected ? colors.fgTertiary : colors.fgSubtle,
                ),
                child: description!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
