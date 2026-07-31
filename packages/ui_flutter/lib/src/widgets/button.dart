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

  /// Accent-tinted chip — 对比 N 个引擎: the deck fills this pill with the
  /// accent at low alpha and prints the accent colour on top.
  tint,

  /// Text-only affordance — 设为首选 / 导出配置 / 更改位置.
  quiet,

  /// Text-only, de-emphasised — 测试连接 / 存为默认设置.
  plain,

  /// Text-only warning — 与术语表冲突 · 查看.
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
    final padding = _textOnly
        ? EdgeInsets.zero
        : switch (size) {
            ButtonSize.xs =>
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ButtonSize.sm =>
              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            ButtonSize.md =>
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ButtonSize.lg =>
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                color: colors.borderStrong,
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
              background =
                  colors.accent.withValues(alpha: hovered ? 0.20 : 0.12);
              foreground = colors.accentText;
            }
          case ButtonVariant.quiet:
            weight = FontWeight.w600;
            foreground = hovered ? colors.accentTextStrong : colors.accentText;
          case ButtonVariant.plain:
            weight = FontWeight.w600;
            foreground = hovered ? colors.fg : colors.fgTertiary;
          case ButtonVariant.warning:
            weight = FontWeight.w600;
            foreground = hovered ? colors.warnFg : colors.warnStrong;
        }

        final style = tokens.typography.sansStyle(
          fontSize: fontSize,
          fontWeight: weight,
          height: 1,
          color: foreground,
        );

        return Opacity(
          opacity: disabled && _textOnly ? 0.6 : 1,
          child: AnimatedContainer(
            duration: kTransitionDuration,
            width: fullWidth ? double.infinity : null,
            padding: padding,
            decoration: BoxDecoration(
              color: background,
              border: border,
              borderRadius: radius,
              boxShadow: shadow,
            ),
            child: DefaultTextStyle(
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
                      child: DefaultTextStyle(
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
          ),
        );
      },
    );
  }
}
