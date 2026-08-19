import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/label.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// How far the divider may travel. Below the floor the labels stop fitting
/// their rows; above the ceiling the sidebar starts competing with the pane it
/// is meant to serve.
const double kMinSidebarWidth = 150;
const double kMaxSidebarWidth = 320;

/// The rail's travel. It is a narrower column than the sidebar to begin with,
/// so both ends sit lower.
const double kMinRailWidth = 120;
const double kMaxRailWidth = 280;

/// Drag this far past the floor and the sidebar collapses instead of shrinking
/// — AppKit's own divider does this, and it is the only way to close a sidebar
/// without going back to the toolbar button.
const double _kCollapseSlop = 32;

/// Arrow keys walk the divider; shift makes the step a coarse one.
const double _kKeyStep = 8;
const double _kCoarseKeyStep = 32;

/// The grab area. A one-pixel separator is not a target, so the handle is
/// widened to something a pointer can actually find.
const double _kHandleWidth = 7;

/// Left workspace column — the sidebar metric (172px) wide, or whatever the
/// divider has been dragged to when [resizable] is set.
class Sidebar extends StatefulWidget {
  const Sidebar({
    super.key,
    this.header,
    this.footer,
    this.resizable = false,
    this.width,
    this.defaultWidth,
    this.onWidthChange,
    this.minWidth = kMinSidebarWidth,
    this.maxWidth = kMaxSidebarWidth,
    this.onCollapse,
    this.resizeLabel = '调整侧边栏宽度',
    required this.children,
  });

  /// Content for the strip above the nav list, kept at exactly the titlebar
  /// height so it lines up with the toolbar in the pane beside it. Pass the
  /// traffic lights here to get a full-height sidebar — the Finder/Mail
  /// layout, where the sidebar runs the whole height of the window and the
  /// toolbar only spans the content pane.
  final Widget? header;

  /// Pinned to the column's foot, below the scrolling nav — the deck parks
  /// the version/updater card here.
  final Widget? footer;

  /// Let the separator on the right edge be dragged. Off by default: a sidebar
  /// standing on its own in a gallery or a dialog has no pane to trade width
  /// with, and a handle that leads nowhere is worse than no handle.
  final bool resizable;

  /// Controlled width. Leave it out and the sidebar owns its own.
  final double? width;

  /// Starting width for the uncontrolled case; defaults to the sidebar metric.
  final double? defaultWidth;

  final ValueChanged<double>? onWidthChange;
  final double minWidth;
  final double maxWidth;

  /// Called when the divider is dragged past the floor. Left out, the drag
  /// simply stops at [minWidth] — pass it only where collapsing is a state the
  /// window can actually be in.
  final VoidCallback? onCollapse;

  /// Accessible name for the divider.
  final String resizeLabel;

  final List<Widget> children;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  double? _ownWidth;

  /// What the sidebar measured before anyone dragged it — double-click home.
  double? _natural;

  double _resolved(BuildContext context) =>
      widget.width ?? _ownWidth ?? _naturalOf(context);

  double _naturalOf(BuildContext context) =>
      widget.defaultWidth ?? context.metrics.sidebarWidth;

  void _commit(double next) {
    if (widget.width == null) setState(() => _ownWidth = next);
    widget.onWidthChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    _natural ??= _naturalOf(context);

    final column = Container(
      width: _resolved(context),
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
          if (widget.header != null)
            Container(
              height: tokens.metrics.titlebarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AlignmentDirectional.centerStart,
              child: widget.header,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.children.length; i++) ...[
                    if (i > 0) SizedBox(height: tokens.metrics.navGap),
                    widget.children[i],
                  ],
                ],
              ),
            ),
          ),
          if (widget.footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
              child: widget.footer,
            ),
        ],
      ),
    );

    if (!widget.resizable) return column;

    return _ResizableColumn(
      width: _resolved(context),
      natural: _natural!,
      minWidth: widget.minWidth,
      maxWidth: widget.maxWidth,
      onWidthChange: _commit,
      onCollapse: widget.onCollapse,
      label: widget.resizeLabel,
      child: column,
    );
  }
}

/// The draggable separator on a column's right edge, shared by [Sidebar] and
/// [Rail]. It owns nothing but the gesture: the column it wraps decides the
/// width it is at, and hears about the next one through [onWidthChange].
class _ResizableColumn extends StatefulWidget {
  const _ResizableColumn({
    required this.width,
    required this.natural,
    required this.minWidth,
    required this.maxWidth,
    required this.onWidthChange,
    this.onCollapse,
    required this.label,
    required this.child,
  });

  /// The width the column is currently laid out at.
  final double width;

  /// Where a double-click sends the divider.
  final double natural;

  final double minWidth;
  final double maxWidth;
  final ValueChanged<double> onWidthChange;

  /// Called when the divider is dragged well past the floor. Left out, the
  /// drag simply stops at [minWidth].
  final VoidCallback? onCollapse;

  /// Accessible name for the divider.
  final String label;

  final Widget child;

  @override
  State<_ResizableColumn> createState() => _ResizableColumnState();
}

class _ResizableColumnState extends State<_ResizableColumn> {
  bool _dragging = false;
  bool _hovered = false;
  bool _focused = false;

  /// The width the drag started from, plus everything the pointer has moved
  /// since. Tracking the origin rather than the running width keeps a drag
  /// that runs past the floor from losing where it began.
  double _dragOrigin = 0;
  double _dragDelta = 0;

  double _clamp(double value) =>
      value.clamp(widget.minWidth, widget.maxWidth).roundToDouble();

  void _handleDragStart(DragStartDetails _) {
    _dragOrigin = widget.width;
    _dragDelta = 0;
    setState(() => _dragging = true);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    _dragDelta += details.delta.dx;
    final raw = _dragOrigin + _dragDelta;
    if (widget.onCollapse != null && raw < widget.minWidth - _kCollapseSlop) {
      // Collapsed is not a width. Hand back the one the drag started from, so
      // re-opening the column does not inherit some half-dragged number.
      widget.onWidthChange(_clamp(_dragOrigin));
      setState(() => _dragging = false);
      widget.onCollapse!();
      return;
    }
    widget.onWidthChange(_clamp(raw));
  }

  KeyEventResult _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final left = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final right = event.logicalKey == LogicalKeyboardKey.arrowRight;
    if (!left && !right) return KeyEventResult.ignored;
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    final coarse = pressed.contains(LogicalKeyboardKey.shiftLeft) ||
        pressed.contains(LogicalKeyboardKey.shiftRight);
    final step = coarse ? _kCoarseKeyStep : _kKeyStep;
    widget.onWidthChange(_clamp(widget.width + (right ? step : -step)));
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.tokens.colors;

    // Nothing is drawn in the grab area: the separator itself is what lights
    // up. React lets the handle straddle the edge; here it sits just inside,
    // because Flutter drops any pointer that falls outside a box — a handle
    // hanging over the pane beside it would lose those pixels to that pane.
    final indicatorOpacity =
        _dragging || _focused ? 1.0 : (_hovered ? 0.6 : 0.0);

    return Stack(
      // The column keeps whatever constraints the Stack was handed, so a
      // column in a stretched Row lays out exactly as it did before the
      // handle existed.
      fit: StackFit.passthrough,
      children: [
        widget.child,
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          width: _kHandleWidth,
          child: Semantics(
            label: widget.label,
            slider: true,
            value: widget.width.round().toString(),
            child: Focus(
              onKeyEvent: (node, event) => _handleKey(event),
              onFocusChange: (value) => setState(() => _focused = value),
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // Measure from where the pointer went down, not from where
                  // the recogniser claimed the gesture: the default swallows
                  // the touch slop, and the divider would lag the cursor by
                  // that much on every drag.
                  dragStartBehavior: DragStartBehavior.down,
                  onHorizontalDragStart: _handleDragStart,
                  onHorizontalDragUpdate: _handleDragUpdate,
                  onHorizontalDragEnd: (_) => setState(() => _dragging = false),
                  onHorizontalDragCancel: () =>
                      setState(() => _dragging = false),
                  // Double-clicking a divider puts it back where it started —
                  // the same thing AppKit and every split view does.
                  onDoubleTap: () =>
                      widget.onWidthChange(_clamp(widget.natural)),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: AnimatedOpacity(
                      duration: kTransitionDuration,
                      opacity: indicatorOpacity,
                      child: Container(width: 1, color: colors.accent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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

/// Second column: settings groups, glossary books, document pages — the rail
/// metric (150px) wide, or whatever the divider has been dragged to when
/// [resizable] is set.
class Rail extends StatefulWidget {
  const Rail({
    super.key,
    this.footer,
    this.resizable = false,
    this.width,
    this.defaultWidth,
    this.onWidthChange,
    this.minWidth = kMinRailWidth,
    this.maxWidth = kMaxRailWidth,
    this.resizeLabel = '调整栏宽度',
    required this.children,
  });

  /// Pinned to the column's foot, below the scrolling list — the deck parks
  /// the document's 已完成 counter here (`mt-auto`).
  final Widget? footer;

  /// Let the separator on the right edge be dragged. Off by default, for the
  /// same reason as [Sidebar.resizable].
  final bool resizable;

  /// Controlled width. Leave it out and the rail owns its own.
  final double? width;

  /// Starting width for the uncontrolled case; defaults to the rail metric.
  final double? defaultWidth;

  final ValueChanged<double>? onWidthChange;
  final double minWidth;
  final double maxWidth;

  /// Accessible name for the divider.
  final String resizeLabel;

  final List<Widget> children;

  @override
  State<Rail> createState() => _RailState();
}

class _RailState extends State<Rail> {
  double? _ownWidth;
  double? _natural;

  double _resolved(BuildContext context) =>
      widget.width ?? _ownWidth ?? _naturalOf(context);

  double _naturalOf(BuildContext context) =>
      widget.defaultWidth ?? context.metrics.railWidth;

  void _commit(double next) {
    if (widget.width == null) setState(() => _ownWidth = next);
    widget.onWidthChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final children = widget.children;
    _natural ??= _naturalOf(context);

    final column = Container(
      width: _resolved(context),
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
          if (widget.footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
              child: widget.footer,
            ),
        ],
      ),
    );

    if (!widget.resizable) return column;

    return _ResizableColumn(
      width: _resolved(context),
      natural: _natural!,
      minWidth: widget.minWidth,
      maxWidth: widget.maxWidth,
      onWidthChange: _commit,
      label: widget.resizeLabel,
      child: column,
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
          final minContentHeight =
              constraints.maxHeight > 36 ? constraints.maxHeight - 36 : 0.0;
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
