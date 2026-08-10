import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/label.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:beyondtranslate_ui/src/widgets/surface.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The space a heading keeps from the rows it names, and the space a group
/// keeps from its first section — the two are the same on purpose: a heading
/// belongs to what follows it, at either level.
const double _kHeadingGap = 12;

/// Between two rows of one section. A run of rows has to read as one block
/// before the space above it can mean anything.
const double _kRowGap = 4;

/// Between two sections of a group.
const double _kSectionGap = 18;

/// How far a [PreferenceDivider] is pulled up out of the section gap above it.
const double _kDividerPull = 14;

/// The slot a heading's control sits in.
///
/// A button is 26px tall and a section heading is 11, so letting the control
/// size the line makes a labelled-plus-button heading 15px taller than a plain
/// one — two sections on the same page then start at different heights and the
/// column loses its rhythm. The slot is a zero-height line centred in the
/// heading, which the control overhangs on both sides into space that is empty
/// anyway. Zero rather than a negative offset so it holds for any control
/// height and any heading size: the heading is exactly as tall as its text
/// whatever it carries.
class _HeadingAction extends SingleChildRenderObjectWidget {
  const _HeadingAction({required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderHeadingAction();
}

/// Reports no height, paints the control centred on the line, and — unlike a
/// zero-height [Align] — still hit-tests it.
///
/// Flutter rejects any pointer that falls outside a box's own `size`, so a
/// control overhanging a zero-height slot is invisible to taps however plainly
/// it is drawn. CSS hit-tests painted geometry and needs no such help, which is
/// why the React source gets away with a bare `h-0`.
class _RenderHeadingAction extends RenderShiftedBox {
  _RenderHeadingAction() : super(null);

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(Size.zero);
      return;
    }
    child.layout(constraints.loosen(), parentUsesSize: true);
    size = constraints.constrain(Size(child.size.width, 0));
    (child.parentData! as BoxParentData).offset = Offset(
      0,
      -child.size.height / 2,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      child?.getMinIntrinsicWidth(height) ?? 0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      child?.getMaxIntrinsicWidth(height) ?? 0;

  @override
  double computeMinIntrinsicHeight(double width) => 0;

  @override
  double computeMaxIntrinsicHeight(double width) => 0;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: (child.parentData! as BoxParentData).offset,
      position: position,
      hitTest: (BoxHitTestResult inner, Offset transformed) =>
          child.hitTest(inner, position: transformed),
    );
  }
}

/// A labelled run of preference rows — the counterpart of the app's
/// `PreferenceListSection`, minus the `List`: that one sits inside a list
/// widget, and here a section sits directly in the page's own column.
///
/// The rows sit closer to their heading than to the section below, which is
/// what makes a heading read as belonging to the rows under it rather than
/// floating between two groups.
class PreferenceSection extends StatelessWidget {
  const PreferenceSection({
    super.key,
    this.label,
    this.action,
    this.footer,
    required this.children,
  });

  /// The heading over the rows. Omit for an unlabelled run.
  final Widget? label;

  /// A control on the heading line, right-aligned — 添加服务..., 恢复默认...
  final Widget? action;

  /// The muted note under the rows, for what the section does not fit.
  final Widget? footer;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The heading stands 12px off its rows while the rows sit 4px apart.
        // Every level up widens by the same logic — 4 between rows, 12 under a
        // heading, 18 between sections in a group.
        if (label != null || action != null) ...[
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: label == null
                      ? const SizedBox.shrink()
                      : Label(child: label!),
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 16),
                _HeadingAction(child: action!),
              ],
            ],
          ),
          const SizedBox(height: _kHeadingGap),
        ],
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: _kRowGap),
          children[i],
        ],
        // The note hangs off the run rather than reading as one more row.
        if (footer != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyle(
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 1.7,
                color: tokens.colors.fgSubtle,
              ),
              child: footer!,
            ),
          ),
        ],
      ],
    );
  }
}

/// A titled run of [PreferenceSection]s, for a page whose sections come in
/// bunches — 服务, where each capability owns a roster, its options and its
/// targets, and those three are one subject.
///
/// Sections stay one size everywhere; the level above them is a title that
/// outranks them, not a section shrunk to fit underneath one. That way a
/// heading always means the same thing wherever you meet it, and a page with
/// groups reads as one more layer rather than as two competing scales.
class PreferenceGroup extends StatelessWidget {
  const PreferenceGroup({
    super.key,
    required this.title,
    this.description,
    this.action,
    required this.children,
  });

  final Widget title;

  /// The line under the title, for what the group is for.
  final Widget? description;

  /// A control on the title line, right-aligned.
  final Widget? action;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The title binds down onto its first section (12px, the same space a
        // section gives its own rows) while the sections stand further apart
        // from each other (18px) — the same "a heading belongs to what follows
        // it" rule the sections use, one level up.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // One step over the 12px row title, in the display face —
                  // enough to outrank a section label without becoming a page
                  // heading.
                  DefaultTextStyle(
                    style: tokens.typography.displayStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: colors.fg,
                    ),
                    child: title,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 6),
                    DefaultTextStyle(
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        height: 1.7,
                        color: colors.fgSubtle,
                      ),
                      child: description!,
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: 16),
              _HeadingAction(child: action!),
            ],
          ],
        ),
        const SizedBox(height: _kHeadingGap),
        for (var i = 0; i < children.length; i++) ...[
          // A `PreferenceDivider` is pulled up out of the gap above it — the
          // negative top margin the React source spends, which Flutter has to
          // spell as a shorter gap because it has no negative insets.
          if (i > 0)
            SizedBox(
              height: children[i] is PreferenceDivider
                  ? _kSectionGap - _kDividerPull
                  : _kSectionGap,
            ),
          children[i],
        ],
      ],
    );
  }
}

/// One preference row: title (and optional subtitle) left, control right.
/// The control is whatever the row is for — a `Switch`, a `Select`, a button,
/// a group of them.
///
/// The height is a minimum plus a pad on the text, never a fixed height:
///
/// - the minimum (28px, as tall as the tallest control a row carries) keeps the
///   text column in one rhythm whatever sits on the right. Without it a switch
///   row is 18px and a select row 28px, and the space between two titles
///   changes with the controls beside them though the boxes are evenly spaced;
/// - the pad rides on the text block rather than on the row, so a row grows
///   for content — a subtitle, a wrapped title, a badge on the name — and
///   never for a control. A `Select` is 28px on its own; padding the row would
///   push that row to 36 and undo the very rhythm the minimum buys.
class PreferenceRow extends StatelessWidget {
  const PreferenceRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onOpen,
    this.trailing = const [],
  });

  final Widget title;

  /// The second line, for what the title cannot say in three words.
  final Widget? subtitle;

  /// A glyph or avatar before the title, for rows that name a thing.
  final Widget? icon;

  /// Makes the row open something — a detail page, a sheet. It becomes a
  /// button and grows the chevron and the hover wash that say so. Rows that
  /// only carry a control leave this null and stay inert.
  final VoidCallback? onOpen;

  /// The row's controls, right-aligned.
  final List<Widget> trailing;

  static const double _kMinHeight = 28;
  static const double _kGap = 10;

  /// How far the opening row's wash bleeds past the text on each side.
  static const double _kWashBleed = 8;

  Widget _buildBody(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final hasTrailing = trailing.isNotEmpty || onOpen != null;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _kMinHeight),
      child: Row(
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: _kGap)],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.typography.sansStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      color: colors.fg,
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle(
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        color: colors.fgSubtle,
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: _kGap),
            for (var i = 0; i < trailing.length; i++) ...[
              if (i > 0) const SizedBox(width: _kGap),
              trailing[i],
            ],
            if (onOpen != null) ...[
              if (trailing.isNotEmpty) const SizedBox(width: _kGap),
              Icon(
                FluentIcons.chevron_right_20_regular,
                size: 13,
                color: colors.fgFaint,
              ),
            ],
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (onOpen == null) return _buildBody(context);

    final tokens = context.tokens;
    final radius = BorderRadius.circular(tokens.radii.controlSm);

    return Pressable(
      onPressed: onOpen,
      borderRadius: radius,
      builder: (context, state) => Stack(
        // Sideways the wash is allowed to be wider than the text — it is laid
        // out behind the row and bled outward, so an opening row still starts
        // on the same left edge as the inert rows above it. Vertically it needs
        // nothing: the row's minimum height and the pad on the text block
        // already keep the wash clear of the glyphs on both sides.
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -_kWashBleed,
            right: -_kWashBleed,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: kTransitionDuration,
              decoration: BoxDecoration(
                color: state.hovered
                    ? tokens.colors.accent.withValues(alpha: 0.08)
                    : null,
                borderRadius: radius,
              ),
            ),
          ),
          _buildBody(context),
        ],
      ),
    );
  }
}

/// The rule between two sections. The space is deliberately lopsided: the rule
/// sits closer to the section it closes than to the label that opens the next
/// one, so each heading stays attached to its own rows.
///
/// The margins are cut deeper than that difference looks, because the box above
/// the rule ends with a row and a row carries its own slack — up to 8px of it
/// under the last line of text. Measured box to box the split is 8/26; measured
/// ink to ink, which is what the eye reads, it lands near 16/26. Trimming only
/// to the box was what made the rule drift to the middle.
///
/// The pull upward lives in [PreferenceGroup], which owns the gap it comes out
/// of; this widget carries only the space below the rule.
class PreferenceDivider extends StatelessWidget {
  const PreferenceDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.only(bottom: 4), child: Divider());
}
