import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/progress.dart';
import 'package:flutter/widgets.dart';

enum StepStatus { done, active, idle }

/// One line of the document pipeline: 文本提取 → 版面识别 → 分段翻译 → 校验.
class Step extends StatelessWidget {
  const Step({super.key, required this.status, required this.label, this.meta});

  final StepStatus status;
  final Widget label;

  /// Right-aligned detail — 15 页 / 168 / 392 段.
  final Widget? meta;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final marker = switch (status) {
      StepStatus.done => Container(
          width: 16,
          height: 16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.successSurface,
            shape: BoxShape.circle,
          ),
          child: Text(
            '✓',
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1,
              color: colors.success,
            ),
          ),
        ),
      StepStatus.active => const Spinner(size: SpinnerSize.md),
      StepStatus.idle => Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.controlOutline, width: 1.5),
          ),
        ),
    };

    final labelStyle = switch (status) {
      StepStatus.active => tokens.typography.sansStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors.fg,
        ),
      StepStatus.done => tokens.typography.sansStyle(
          fontSize: 12,
          color: colors.fgTertiary,
        ),
      StepStatus.idle => tokens.typography.sansStyle(
          fontSize: 12,
          color: colors.fgSubtle,
        ),
    };

    return Opacity(
      opacity: status == StepStatus.idle ? 0.6 : 1,
      child: Row(
        children: [
          marker,
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle(style: labelStyle, child: label),
          ),
          if (meta != null)
            DefaultTextStyle(
              style: tokens.typography.sansStyle(
                fontSize: 11,
                color: status == StepStatus.active
                    ? colors.accentText
                    : colors.fgFaint,
              ),
              child: meta!,
            ),
        ],
      ),
    );
  }
}

class StepList extends StatelessWidget {
  const StepList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            children[i],
          ],
        ],
      );
}
