import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

enum ButtonVariant {
  /// Filled accent — one per view, the action the design points at.
  primary,

  /// Raised neutral on a tinted surface: white card with a hairline.
  secondary,

  /// Recessed neutral chip — 朗读 / 复制 / 收藏 on the mini window.
  ghost,

  /// Accent-tinted chip — 对比 N 个服务: the deck fills this pill with the
  /// accent at low alpha and prints the accent colour on top.
  tint,

  /// Text-only affordance — 设为首选 / 导出配置 / 更改位置.
  quiet,

  /// Text-only, de-emphasised — 测试连接 / 存为默认设置.
  plain,

  /// Text-only warning — 与术语库冲突 · 查看.
  warning,
}

enum ButtonSize { xs, sm, md, lg }

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.onPressed,
    this.variant = ButtonVariant.ghost,
    this.size = ButtonSize.sm,
    this.fullWidth = false,
    this.enabled = true,
    this.child,
    this.shortcut,
    this.semanticsLabel,
  });

  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool fullWidth;
  final bool enabled;
  final Widget? child;

  /// Trailing shortcut glyph, e.g. `⏎` on 翻译.
  final Widget? shortcut;
  final String? semanticsLabel;

  bool get _textOnly =>
      variant == ButtonVariant.quiet ||
      variant == ButtonVariant.plain ||
      variant == ButtonVariant.warning;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final disabled = !enabled || onPressed == null;

    final fontSize = switch (size) {
      ButtonSize.xs => 11.0,
      ButtonSize.sm => 12.0,
      ButtonSize.md => 12.0,
      ButtonSize.lg => 12.0,
    };
    // 24 / 26 / 28 / 32 px tall — the macOS-to-Fluent control range. The height
    // is fixed rather than derived from the padding, so a taller glyph or a CJK
    // label can never push one button out of line with its neighbours.
    final height = switch (size) {
      ButtonSize.xs => 24.0,
      ButtonSize.sm => 26.0,
      ButtonSize.md => 28.0,
      ButtonSize.lg => 32.0,
    };
    // Text-only variants carry no box, so they drop the padding — but they keep
    // the height, which is what lines them up with the chips beside them.
    final padding = _textOnly
        ? EdgeInsets.zero
        : switch (size) {
            ButtonSize.xs => const EdgeInsets.symmetric(horizontal: 10),
            ButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12),
            ButtonSize.md => const EdgeInsets.symmetric(horizontal: 16),
            ButtonSize.lg => const EdgeInsets.symmetric(horizontal: 16),
          };
    final radius = BorderRadius.circular(
      size == ButtonSize.lg ? tokens.radii.control : tokens.radii.controlSm,
    );

    return Pressable(
      onPressed: enabled ? onPressed : null,
      enabled: !disabled,
      borderRadius: radius,
      semanticsLabel: semanticsLabel,
      builder: (context, state) {
        final hovered = state.hovered;

        Color? background;
        Color foreground;
        FontWeight weight;
        Border? border;
        List<BoxShadow>? shadow;

        switch (variant) {
          case ButtonVariant.primary:
            weight = FontWeight.w700;
            if (disabled) {
              background = colors.track;
              foreground = colors.fgFaint;
            } else {
              background = hovered ? colors.accentHover : colors.accent;
              foreground = colors.onAccent;
              shadow = tokens.shadows.accent;
            }
          case ButtonVariant.secondary:
            weight = FontWeight.w600;
            if (disabled) {
              background = colors.track;
              foreground = colors.fgFaint;
            } else {
              background = hovered ? colors.subtle : colors.window;
              foreground = colors.fgControl;
              border = Border.all(
                color: colors.hairlineStrong,
                width: context.hairlineWidth,
              );
            }
          case ButtonVariant.ghost:
            weight = FontWeight.w600;
            if (disabled) {
              background = colors.track;
              foreground = colors.fgFaint;
            } else {
              background = hovered ? colors.controlHover : colors.control;
              foreground = colors.fgControl;
            }
          case ButtonVariant.tint:
            weight = FontWeight.w600;
            if (disabled) {
              background = colors.track;
              foreground = colors.fgFaint;
            } else {
              background = colors.accent.withValues(
                alpha: hovered ? 0.20 : 0.12,
              );
              foreground = colors.accentText;
            }
          // Text-only variants have no fill to grey out, so disabled they fade
          // to the faint ink — and stay there under the pointer.
          case ButtonVariant.quiet:
            weight = FontWeight.w600;
            foreground = disabled
                ? colors.fgFaint
                : (hovered ? colors.accentTextStrong : colors.accentText);
          case ButtonVariant.plain:
            weight = FontWeight.w600;
            foreground = disabled
                ? colors.fgFaint
                : (hovered ? colors.fg : colors.fgTertiary);
          case ButtonVariant.warning:
            weight = FontWeight.w600;
            foreground = disabled
                ? colors.fgFaint
                : (hovered ? colors.warnFg : colors.warnStrong);
        }

        final style = tokens.typography.sansStyle(
          fontSize: fontSize,
          fontWeight: weight,
          height: 1,
          color: foreground,
        );

        return AnimatedContainer(
          duration: kTransitionDuration,
          width: fullWidth ? double.infinity : null,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius,
            boxShadow: shadow,
          ),
          // The hairline rides in the *foreground* decoration rather than the
          // background one: a `BoxDecoration.border` insets the content box by
          // its own width, which would make `secondary` a hairline wider than
          // the `ghost` next to it. React makes the same point by drawing the
          // ring as an inset box-shadow instead of a real border.
          foregroundDecoration: border == null
              ? null
              : BoxDecoration(border: border, borderRadius: radius),
          child: AnimatedDefaultTextStyle(
            duration: kTransitionDuration,
            style: style,
            softWrap: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (child != null) child!,
                if (shortcut != null) ...[
                  const SizedBox(width: 8),
                  Opacity(
                    opacity: 0.7,
                    child: AnimatedDefaultTextStyle(
                      duration: kTransitionDuration,
                      style: tokens.typography.displayStyle(
                        fontSize: fontSize,
                        fontWeight: weight,
                        height: 1,
                        color: foreground,
                      ),
                      child: shortcut!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
