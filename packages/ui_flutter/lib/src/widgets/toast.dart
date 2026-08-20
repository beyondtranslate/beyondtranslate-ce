import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

enum ToastTone {
  /// Passive notice — 已存至「下载」.
  neutral,

  /// Finished — 已复制译文 · 术语已入库.
  success,

  /// Caveat that resolved itself — 已切换到备用服务.
  warn,

  /// Failure worth keeping on screen — 连接已断开.
  danger,
}

/// 桌面浮层通知 — a transient receipt for something that just happened out of
/// view: 已复制、已存入生词本、连接已断开. One line, no wrapping; anything that
/// needs a second sentence belongs in a [Callout] inside the flow instead.
///
/// Lifetime is the host's job (the kit stays stateless), but the contract the
/// native apps should follow: 4s for a plain notice, 6s when it carries an
/// action, and [ToastTone.danger] stays until dismissed. Hovering pauses the
/// clock.
///
/// Entrance is the toast's own — the React kit's `animate-toast-in`, a 260ms
/// rise-and-fade played once on mount. There is no exit animation: the host
/// just removes the node — a desktop notification should not pull attention
/// back a second time on its way out.
class Toast extends StatefulWidget {
  const Toast({
    super.key,
    this.tone = ToastTone.neutral,
    this.icon,
    this.action,
    this.onDismiss,
    this.child,
  });

  final ToastTone tone;

  /// Leading node — `null` falls back to the tone's glyph; pass a `Spinner`
  /// for in-flight work, or a [SizedBox.shrink] for a bare message.
  final Widget? icon;
  final Widget? child;

  /// Right-aligned action — 撤销 / 重试. Pass a `quiet` Button.
  final Widget? action;

  /// Renders the trailing ✕; wire it to remove the toast.
  final VoidCallback? onDismiss;

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  // `--animate-toast-in`, curve overshoot included.
  static const _curve = Cubic(0.21, 0.9, 0.35, 1.05);

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    final icon = widget.icon ??
        switch (widget.tone) {
          ToastTone.neutral => Icon(
              FluentIcons.info_20_filled,
              size: 16,
              color: colors.fgSubtle,
            ),
          ToastTone.success => Icon(
              FluentIcons.checkmark_circle_20_filled,
              size: 16,
              color: colors.success,
            ),
          ToastTone.warn => Icon(
              FluentIcons.warning_20_filled,
              size: 16,
              color: colors.warnStrong,
            ),
          ToastTone.danger => Icon(
              FluentIcons.dismiss_circle_20_filled,
              size: 16,
              color: colors.danger,
            ),
        };

    // Same elevation language as MiniWindow/Dialog — a bright floating card,
    // not Material's inverse bar.
    final card = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        decoration: BoxDecoration(
          color: colors.raised,
          border: Border.all(
            color: colors.hairlineStrong,
            width: context.hairlineWidth,
          ),
          borderRadius: BorderRadius.circular(tokens.radii.popover),
          boxShadow: tokens.shadows.float,
        ),
        child: ConstrainedBox(
          // min-h-9 less the vertical padding, so short copy still centres.
          constraints: const BoxConstraints(minHeight: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 10),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: DefaultTextStyle(
                    style: tokens.typography.sansStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: colors.fg,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: widget.child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
              if (widget.action != null) ...[
                const SizedBox(width: 14),
                widget.action!,
              ],
              if (widget.onDismiss != null) ...[
                const SizedBox(width: 10),
                _DismissButton(onPressed: widget.onDismiss!),
              ],
            ],
          ),
        ),
      ),
    );

    // role="status" — announced without stealing focus.
    return Semantics(
      container: true,
      liveRegion: true,
      child: AnimatedBuilder(
        animation: _entrance,
        child: card,
        builder: (context, child) {
          final t = _curve.transform(_entrance.value);
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - t)),
              child: Transform.scale(
                scale: 0.98 + 0.02 * t,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The trailing ✕ — the same flat 24px square as [IconButton]'s hover wash.
class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(context.tokens.radii.controlSm);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      semanticsLabel: '关闭',
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: state.hovered ? colors.subtle : null,
          borderRadius: radius,
        ),
        child: TweenAnimationBuilder<Color?>(
          duration: kTransitionDuration,
          tween: ColorTween(end: state.hovered ? colors.fg : colors.fgMuted),
          builder: (context, color, _) => Icon(
            FluentIcons.dismiss_20_regular,
            size: 14,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Which window edge a [ToastViewport]'s stack hangs from.
enum ToastPlacement { bottom, top }

/// Where a window's toasts land: centred on the stage, 16px off the edge,
/// newest nearest the edge. Pin it inside the [Stack] that should own the
/// notifications — usually the window's root, so the stack clears the sidebar
/// the way a sheet does. Transparent to the pointer between toasts.
class ToastViewport extends StatelessWidget {
  const ToastViewport({
    super.key,
    this.placement = ToastPlacement.bottom,
    this.children = const [],
  });

  final ToastPlacement placement;

  /// Append in order shown; the column direction keeps the newest toast
  /// nearest the edge, pushing older ones inward.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ordered =
        placement == ToastPlacement.top ? children.reversed.toList() : children;

    return Positioned(
      left: 0,
      right: 0,
      top: placement == ToastPlacement.top ? 16 : null,
      bottom: placement == ToastPlacement.bottom ? 16 : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < ordered.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              ordered[i],
            ],
          ],
        ),
      ),
    );
  }
}
