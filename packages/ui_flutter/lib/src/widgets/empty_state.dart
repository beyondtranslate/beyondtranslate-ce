import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/label.dart';
import 'package:flutter/widgets.dart';

/// What a pane shows before it has content. The deck never draws these, so the
/// treatment is deliberately quiet: no illustration, same type scale as the
/// rest of the pane, one action at most.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.label,
    required this.title,
    this.description,
    this.action,
    this.hint,
  });

  /// Micro-label above the message — 收藏与历史 / 术语库.
  final Widget? label;
  final Widget title;
  final Widget? description;

  /// Primary affordance out of the empty state.
  final Widget? action;

  /// Keyboard route to the same thing — ⌘D 收藏当前译文.
  final Widget? hint;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 56),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Label(tone: LabelTone.faint, child: label!),
              const SizedBox(height: 12),
            ],
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: tokens.typography.sansStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1,
                color: colors.fg,
              ),
              child: title,
            ),
            if (description != null) ...[
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: tokens.typography.sansStyle(
                    fontSize: 12,
                    height: 1.7,
                    color: colors.fgSubtle,
                  ),
                  child: description!,
                ),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
            if (hint != null) ...[
              const SizedBox(height: 12),
              DefaultTextStyle(
                textAlign: TextAlign.center,
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  color: colors.fgFaint,
                ),
                child: hint!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
