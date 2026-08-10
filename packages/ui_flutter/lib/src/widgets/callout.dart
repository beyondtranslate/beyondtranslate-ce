import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum CalloutTone {
  /// Progress / in-flight notice — 正在测试连接 · 已用 1.4s.
  accent,

  /// Neutral aside — 预计 3.6 MB · 存至「下载」.
  neutral,

  /// Caveat — 表格与公式保持原版面.
  warn,
  danger,

  /// Finished — 全部 15 页已完成.
  success,
}

class Callout extends StatelessWidget {
  const Callout({
    super.key,
    this.tone = CalloutTone.neutral,
    this.icon,
    this.child,
    this.action,
  });

  final CalloutTone tone;

  /// Leading node — a spinner or icon.
  final Widget? icon;
  final Widget? child;

  /// Right-aligned action — 取消 / 更改位置.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final hairline = context.hairlineWidth;

    final (
      Color background,
      Color borderColor,
      Color foreground,
    ) = switch (tone) {
      CalloutTone.accent => (
          colors.accentSurface,
          colors.accentHairline,
          colors.accentTextStrong,
        ),
      CalloutTone.neutral => (colors.card, colors.hairline, colors.fgTertiary),
      CalloutTone.warn => (
          colors.warnSurface,
          colors.warnHairline,
          colors.warnFg,
        ),
      CalloutTone.danger => (
          colors.dangerSurface,
          colors.dangerHairline,
          colors.dangerFg,
        ),
      CalloutTone.success => (
          colors.successSurface,
          colors.success.withValues(alpha: 0.3),
          colors.success,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: hairline),
        borderRadius: BorderRadius.circular(tokens.radii.box),
      ),
      child: DefaultTextStyle(
        style: tokens.typography.sansStyle(fontSize: 12, color: foreground),
        child: Row(
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 10)],
            // `min-w-0` + the action's `ml-auto`: the copy takes the free
            // space and the action stays pinned to the right edge.
            Expanded(
              child: DefaultTextStyle(
                style: tokens.typography.sansStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: foreground,
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
            if (action != null) ...[const SizedBox(width: 10), action!],
          ],
        ),
      ),
    );
  }
}
