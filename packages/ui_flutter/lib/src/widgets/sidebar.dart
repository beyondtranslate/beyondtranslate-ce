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
            color: colors.hairline,
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

    // The group's own `gap-[3px]` falls between every pair of rows *and*
    // between the label and the first row — the label is one of the flex
    // children, not a heading pinned to the run below it.
    final rows = <Widget>[
      if (label != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Label(tone: LabelTone.faint, child: label!),
          ),
        ),
      ...children,
    ];

    return Padding(
      padding: EdgeInsets.only(top: first ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: tokens.metrics.navGap),
            rows[i],
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
    this.icon,
    required this.child,
  });

  final bool active;
  final VoidCallback? onPressed;

  /// Leading glyph — tinted by the row, so it follows selection.
  final Widget? icon;

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
      builder: (context, state) {
        final foreground = active ? tokens.selectionFg : colors.fgNav;

        return AnimatedContainer(
          duration: kTransitionDuration,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            // AppKit fills the selected row with the accent and prints it in
            // white; the selection pair desaturates when the window is not key.
            color: active
                ? tokens.selection
                : (state.hovered
                      ? colors.accent.withValues(alpha: 0.08)
                      : null),
            borderRadius: radius,
          ),
          child: DefaultTextStyle(
            style: tokens.typography.sansStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1,
              color: foreground,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  // The glyph is taller than the 12px type, so it is boxed to
                  // the line height and allowed to overflow — the row stays at
                  // 28px.
                  SizedBox(
                    width: 16,
                    height: 12,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      child: IconTheme(
                        data: IconThemeData(size: 15, color: foreground),
                        child: icon!,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The card pinned to the bottom of a sidebar — 今日 148 段, 版本 2.4.0,
/// 已收藏 64, 队列, 快捷键.
class SidebarCard extends StatelessWidget {
  const SidebarCard({
    super.key,
    this.label,
    this.gap = 7,
    required this.children,
  });

  final Widget? label;

  /// Space between the card's lines. The version card tightens it to 6.
  final double gap;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.raised,
        border: Border.all(
          color: colors.hairline,
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
              child: Label(tone: LabelTone.faint, child: label!),
            ),
            SizedBox(height: gap),
          ],
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Second column: settings groups, glossary books, document pages.
class Rail extends StatelessWidget {
  const Rail({super.key, this.footer, required this.children});

  /// Pinned to the column's foot, below the scrolling list — the deck parks
  /// the document's 已完成 counter here (`mt-auto`).
  final Widget? footer;

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
            color: colors.hairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 28 = the column's own vertical padding.
                final minContentHeight = constraints.maxHeight > 28
                    ? constraints.maxHeight - 28
                    : 0.0;
                final pinsLastItem =
                    children.length > 1 && children.last is RailAction;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minContentHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < children.length; i++) ...[
                            // RailAction maps to the React component's
                            // `mt-auto`: the spacer eats the spare height, and
                            // disappears once the list is long enough to
                            // scroll.
                            if (pinsLastItem && i == children.length - 1)
                              const Spacer(),
                            if (i > 0) SizedBox(height: tokens.metrics.navGap),
                            children[i],
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
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

/// A run of rail rows, optionally named — the rail's counterpart to
/// [SidebarGroup]. The first run in a rail usually goes unlabelled: it is what
/// the pane is already called, and naming it twice says nothing. A second run
/// is the one that needs the label, because a gap alone leaves the reader to
/// guess what the rows below it have in common.
///
/// The gaps are tighter than [SidebarGroup]'s — a rail is a narrower column and
/// its runs sit closer together before they read as separate lists.
class RailGroup extends StatelessWidget {
  const RailGroup({
    super.key,
    this.label,
    this.first = false,
    required this.children,
  });

  final Widget? label;

  /// The React source uses `first:mt-0`; set this on the first run.
  final bool first;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final rows = <Widget>[
      if (label != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Label(tone: LabelTone.faint, child: label!),
          ),
        ),
      ...children,
    ];

    return Padding(
      padding: EdgeInsets.only(top: first ? 0 : 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: tokens.metrics.navGap),
            rows[i],
          ],
        ],
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

/// Trailing action pinned to the foot of a [Rail] — ＋ 新建术语库. Shaped like
/// a [RailItem] so the column reads as one list, but printed in the accent to
/// say it adds rather than selects.
class RailAction extends StatelessWidget {
  const RailAction({super.key, this.onPressed, required this.child});

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
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        alignment: AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
          color: state.hovered ? colors.accent.withValues(alpha: 0.08) : null,
          borderRadius: radius,
        ),
        child: DefaultTextStyle(
          style: tokens.typography.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: colors.accentText,
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
            color: colors.hairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minContentHeight = constraints.maxHeight > 36
              ? constraints.maxHeight - 36
              : 0.0;
          final pinsLastCard =
              children.length > 1 && children.last is SidebarCard;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minContentHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      // SidebarCard maps to the React component's `mt-auto`.
                      // The spacer consumes spare height but disappears once
                      // the content is tall enough to scroll.
                      if (pinsLastCard && i == children.length - 1)
                        const Spacer(),
                      if (i > 0) const SizedBox(height: 20),
                      children[i],
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
