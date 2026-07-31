import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum DialogTone {
  standard,

  /// Draws the danger border used by the failed-key state.
  danger,
}

/// Sheet shell for 添加翻译引擎 and 导出译文.
class Dialog extends StatelessWidget {
  const Dialog({
    super.key,
    this.width = 440,
    this.tone = DialogTone.standard,
    required this.children,
  });

  final double width;
  final DialogTone tone;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.window,
          borderRadius: BorderRadius.circular(tokens.radii.window),
          border: Border.all(
            color: tone == DialogTone.standard
                ? colors.borderStrong
                : colors.dangerBorder,
            width: context.hairlineWidth,
          ),
          boxShadow: tokens.shadows.popover,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.child,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: tokens.typography.displayStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.15,
              color: colors.fg,
            ),
            child: title,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            DefaultTextStyle(
              style: tokens.typography
                  .sansStyle(fontSize: 12, color: colors.fgSubtle),
              child: subtitle!,
            ),
          ],
          if (child != null) ...[const SizedBox(height: 5), child!],
        ],
      ),
    );
  }
}

class DialogBody extends StatelessWidget {
  const DialogBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              children[i],
            ],
          ],
        ),
      );
}

class DialogFooter extends StatelessWidget {
  const DialogFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: colors.chrome,
        border: Border(
          top: BorderSide(color: colors.border, width: context.hairlineWidth),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            children[i],
          ],
        ],
      ),
    );
  }
}
