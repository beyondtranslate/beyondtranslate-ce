import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum DialogTone {
  standard,

  /// Draws the danger border used by the failed-key state.
  danger,
}

/// Sheet shell for 添加提供商 and 导出译文.
///
/// It never grows past the viewport: the header and the footer keep their
/// height and [DialogBody] absorbs whatever is left, scrolling inside itself
/// when the content is taller than that. A short dialog still sizes to its
/// content — the cap only bites once there is more than the screen can hold.
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

  /// Air left between the sheet and the edges of the screen.
  static const _kViewportMargin = 48.0;

  /// Used when nothing upstream knows how big the window is. The sheet has to
  /// be given *some* finite height or [DialogBody] cannot flex inside it.
  static const _kFallbackMaxHeight = 720.0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final viewport = MediaQuery.maybeSizeOf(context)?.height;
    final maxHeight = viewport == null
        ? _kFallbackMaxHeight
        : (viewport - _kViewportMargin).clamp(0.0, double.infinity);

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.window,
            borderRadius: BorderRadius.circular(tokens.radii.window),
            border: Border.all(
              color: tone == DialogTone.standard
                  ? colors.hairlineStrong
                  : colors.dangerHairline,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      // `min-h-11`: the band is content-driven, which collapses it to 37
      // without a subtitle — too short over a 52px footer. 44 is the floor the
      // content centres in.
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.hairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Same scale as the window titlebar — a sheet's title should not
          // outrank the window it sits over.
          DefaultTextStyle(
            style: tokens.typography.displayStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: -0.13,
              color: colors.fg,
            ),
            child: title,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            DefaultTextStyle(
              // A flat 15px line box, not 1.4: 11 × 1.4 = 15.4 leaves the band
              // on a fractional height and its hairline between device pixels.
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 15 / 11,
                color: colors.fgSubtle,
              ),
              child: subtitle!,
            ),
          ],
          if (child != null) ...[const SizedBox(height: 3), child!],
        ],
      ),
    );
  }
}

/// The sheet's content, and the only part of it that scrolls.
///
/// It takes whatever height the header and the footer leave and scrolls inside
/// that, so those two never move. The padding belongs to the scroll view
/// rather than sitting around it: the scrollable region reaches all the way to
/// both bands, and content slides under them instead of stopping short.
///
/// Being a [Flexible] makes it the [Dialog] column's stretchy child, so it must
/// be used inside one.
class DialogBody extends StatelessWidget {
  const DialogBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Flexible(
        child: SingleChildScrollView(
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
      // 12 puts an md Button's band on 52, matching the titlebar metric — a
      // sheet should not out-measure the window it sits over. Chrome pads 12,
      // content pads 18.
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colors.chrome,
        border: Border(
          top: BorderSide(color: colors.hairline, width: context.hairlineWidth),
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
