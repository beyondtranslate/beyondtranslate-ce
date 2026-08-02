import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/label.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/widgets.dart';

/// Left workspace column — fixed at the sidebar metric (172px by default).
class Sidebar extends StatelessWidget {
  const Sidebar({super.key, this.header, this.footer, required this.children});

  /// Content for the strip above the nav list, kept at exactly the titlebar
  /// height so it lines up with the toolbar in the pane beside it. Pass the
  /// traffic lights here to get a full-height sidebar — the Finder/Mail
  /// layout, where the sidebar runs the whole height of the window and the
  /// toolbar only spans the content pane.
  final Widget? header;

  /// Pinned to the column's foot, below the scrolling nav — the deck parks
  /// the version/updater card here.
  final Widget? footer;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      width: tokens.metrics.sidebarWidth,
      decoration: BoxDecoration(
        color: colors.sidebar,
        border: Border(
          right: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Container(
              height: tokens.metrics.titlebarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AlignmentDirectional.centerStart,
              child: header,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) SizedBox(height: tokens.metrics.navGap),
                    children[i],
                  ],
                ],
              ),
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
              child: footer,
            ),
        ],
      ),
    );
  }
}

/// A labelled run of nav rows. A Mac sidebar breaks its rows into groups
/// rather than stacking them; the gap between groups does most of the work and
/// the label just names it.
class SidebarGroup extends StatelessWidget {
  const SidebarGroup({
    super.key,
    this.label,
    this.first = false,
    required this.children,
  });

  final Widget? label;

  /// The React source uses `first:mt-0`; set this on the first group.
  final bool first;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: EdgeInsets.only(top: first ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Label(
                  tone: LabelTone.faint,
                  child: label!,
                ),
              ),
            ),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: tokens.metrics.navGap),
            children[i],
          ],
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    this.active = false,
    this.onPressed,
    required this.child,
  });

  final bool active;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.controlSm);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      selected: active,
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        alignment: AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
          // AppKit fills the selected row with the accent and prints it in
          // white; the selection pair desaturates when the window is not key.
          color: active
              ? tokens.selection
              : (state.hovered ? colors.accent.withValues(alpha: 0.08) : null),
          borderRadius: radius,
        ),
        child: DefaultTextStyle(
          style: tokens.typography.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1,
            color: active ? tokens.selectionFg : colors.fgNav,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// The card pinned to the bottom of a sidebar — 今日 148 段, 版本 2.4.0,
/// 已收藏 64, 队列, 快捷键.
class SidebarCard extends StatelessWidget {
  const SidebarCard({super.key, this.label, required this.children});

  final Widget? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.raised,
        border: Border.all(
          color: colors.border,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Label(
                tone: LabelTone.faint,
                child: label!,
              ),
            ),
            const SizedBox(height: 7),
          ],
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 7),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Second column: settings groups, glossary books, document pages.
class Rail extends StatelessWidget {
  const Rail({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      width: tokens.metrics.railWidth,
      decoration: BoxDecoration(
        color: colors.rail,
        border: Border(
          right: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(height: tokens.metrics.navGap),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class RailItem extends StatelessWidget {
  const RailItem({
    super.key,
    this.active = false,
    this.onPressed,
    required this.child,
  });

  final bool active;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.controlSm);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      selected: active,
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        alignment: AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
          color: active
              ? tokens.selection
              : (state.hovered ? colors.accent.withValues(alpha: 0.08) : null),
          borderRadius: radius,
        ),
        child: DefaultTextStyle(
          style: tokens.typography.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1,
            color: active ? tokens.selectionFg : colors.fgNav,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Right information column — 命中术语, 质量信号, 快捷键.
class Aside extends StatelessWidget {
  const Aside({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      width: tokens.metrics.asideWidth,
      decoration: BoxDecoration(
        color: colors.sidebar,
        border: Border(
          left: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 20),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
