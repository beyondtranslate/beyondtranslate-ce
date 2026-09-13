import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'divider.dart';
import 'pressable.dart';
import 'section_label.dart';

/// The settings column.
///
/// The spacing is the whole design here. Rows sit close together, a heading
/// sits further from the section above it than from its own rows, a group
/// title stands further still, and one group stands furthest from the next —
/// so a heading always reads as belonging to what follows it rather than
/// floating between two blocks. The ladder is decided in ds — one
/// `preferences*Gap` per level, and the pad a row's text wears — and nothing
/// here restates a step.

/// A run of children at one step, with a rule drawn in the run rather than
/// added to it.
///
/// A `Column`'s own `spacing` would put the whole step on each side of a
/// [Divider], and two sections with a rule between them would then stand
/// further apart than two groups. So the run is laid by hand: half the step
/// on either side of a rule, the whole step everywhere else.
List<Widget> _run(List<Widget> children, double step) {
  final List<Widget> out = [];
  for (int i = 0; i < children.length; i++) {
    if (i > 0) {
      final bool rule = children[i - 1] is Divider || children[i] is Divider;
      out.add(SizedBox(height: rule ? step / 2 : step));
    }
    out.add(children[i]);
  }
  return out;
}

/// The settings column, and the root the rest of this file sits in.
///
/// It owns the two things no group or section can: the run between groups,
/// which is the widest step of the spacing ladder this column climbs, and the
/// width. The column is capped rather than filling its pane — a row puts its
/// label on one edge and its control on the other, and past
/// [ThemeVariables.preferencesWidth] the two stop reading as one line.
class Preferences extends StatelessWidget {
  const Preferences({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    // Full width up to the cap, so it fills a narrow pane and stops in a wide
    // one: `width: 100%; max-width` in the stylesheet. The inner box is what
    // makes it the former — under a loose constraint alone a centred column
    // would shrink to its rows.
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: vars.preferencesWidth),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _run(children, vars.preferencesGroupGap),
        ),
      ),
    );
  }
}

/// A group of sections, with a title that outranks them.
class PreferenceGroup extends StatelessWidget {
  const PreferenceGroup({
    super.key,
    required this.title,
    this.description,
    this.action,
    required this.children,
  });

  final String title;
  final String? description;
  final Widget? action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: vars.preferencesTitleGap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: vars.spacing4,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  // Half a step: the title's leading and the description's
                  // already open the pair.
                  spacing: vars.spacing05,
                  children: [
                    // The group outranks its sections typographically, and
                    // it has to outrank the rows by more than a weight: a
                    // row's title is the same 12px, so a title one grade
                    // heavier read as one more row. `titleMedium` — two
                    // sizes up, at the label weight — is the first face that
                    // stands over a row. A section heading stays a
                    // SectionLabel.
                    Text(
                      title,
                      style: vars.titleMedium.copyWith(
                        color: vars.colorContent,
                      ),
                    ),
                    if (description != null)
                      Text(
                        description!,
                        style: vars.captionSmall.copyWith(
                          height: 1.7,
                          color: vars.colorContentSubtle,
                        ),
                      ),
                  ],
                ),
              ),
              if (action != null) _HeadingAction(child: action!),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _run(children, vars.preferencesSectionGap),
        ),
      ],
    );
  }
}

/// A labelled run of rows.
class PreferenceSection extends StatelessWidget {
  const PreferenceSection({
    super.key,
    this.label,
    this.footer,
    this.action,
    required this.children,
  });

  final String? label;
  final String? footer;
  final Widget? action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || action != null)
          Padding(
            padding: EdgeInsets.only(bottom: vars.preferencesHeadingGap),
            child: Row(
              spacing: vars.spacing4,
              children: [
                Expanded(
                  child: label == null
                      ? const SizedBox.shrink()
                      : SectionLabel(label!),
                ),
                if (action != null) _HeadingAction(child: action!),
              ],
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: vars.preferencesRowGap,
          children: children,
        ),
        if (footer != null)
          Padding(
            padding: EdgeInsets.only(top: vars.preferencesFooterGap),
            child: Text(
              footer!,
              style: vars.captionSmall.copyWith(
                height: 1.7,
                color: vars.colorContentSubtle,
              ),
            ),
          ),
      ],
    );
  }
}

/// A heading's control sits in a zero-height slot it overhangs on both sides.
///
/// Letting a full-height control size the line would make a heading with a
/// button taller than one without, and two sections on the same page would
/// then start at different heights. Zero rather than a negative margin, so it
/// holds for any control height and any heading size.
///
/// This is `height: 0` on a flex item, and it takes a render object rather
/// than a composition because nothing off the shelf does both halves of it.
/// An `OverflowBox` sizes itself to the constraints it is handed, and a
/// `Row` hands a non-flex child an unbounded main axis — so the slot took an
/// infinite width and every heading with an action crashed. And a zero-height
/// box drops every press on what overhangs it, because `RenderBox.hitTest`
/// checks its own bounds before it reaches the child.
class _HeadingAction extends SingleChildRenderObjectWidget {
  const _HeadingAction({required Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderHeadingAction();
  }
}

class _RenderHeadingAction extends RenderShiftedBox {
  _RenderHeadingAction() : super(null);

  /// The child takes the slot's width constraints and none of its height: it
  /// is the one thing here allowed to be as tall as it likes.
  BoxConstraints _innerConstraints(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      child?.getMinIntrinsicWidth(double.infinity) ?? 0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      child?.getMaxIntrinsicWidth(double.infinity) ?? 0;

  @override
  double computeMinIntrinsicHeight(double width) => 0;

  @override
  double computeMaxIntrinsicHeight(double width) => 0;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final RenderBox? child = this.child;
    if (child == null) return constraints.smallest;
    final Size childSize = child.getDryLayout(_innerConstraints(constraints));
    return constraints.constrain(Size(childSize.width, 0));
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_innerConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(Size(child.size.width, 0));
    (child.parentData! as BoxParentData).offset = Offset(
      0,
      -child.size.height / 2,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Skipping the usual bounds check on purpose: the whole control lies
    // outside a box with no height, so testing this box first would mean a
    // heading's action could never be pressed.
    if (hitTestChildren(result, position: position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}

/// One decision.
///
/// A row's height is a minimum plus a pad on its text, never a fixed height.
/// The minimum keeps the text column in one rhythm whatever control sits on
/// the right; the pad rides on the text so a row grows for content — a
/// subtitle, a wrapped title — and never for a control.
class PreferenceRow extends StatelessWidget {
  const PreferenceRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onPressed,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool interactive = onPressed != null;

    Widget content(Set<WidgetState> states) {
      final bool hovered = states.contains(WidgetState.hovered);

      final Widget row = Row(
        spacing: vars.spacing25,
        children: [
          // Uncoloured on purpose: a Badge or a Switch in these slots keeps
          // its own ink rather than inheriting a wash.
          ?icon,
          Expanded(
            child: Padding(
              // The pad rides on the text, so a row that grows a subtitle
              // keeps air above the title and below it. A single line padded
              // this way is shorter than the control height, and the row's
              // minimum still centres it.
              padding: EdgeInsets.symmetric(
                vertical: vars.preferencesRowPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: vars.spacing1,
                children: [
                  // A row rests at `labelQuiet`, the way a list row does:
                  // every title at the label weight was a column of bold
                  // with nothing left to outrank it.
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vars.labelQuiet.copyWith(
                      color: vars.colorContent,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: vars.captionSmall.copyWith(
                        color: vars.colorContentSubtle,
                      ),
                    ),
                ],
              ),
            ),
          ),
          ?trailing,
        ],
      );

      if (!interactive) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: vars.controlMediumSize),
          child: row,
        );
      }

      // The wash bleeds sideways past the text while the row still starts on
      // the same left edge as the inert rows above it — a Stack rather than a
      // negative margin, which Flutter rejects. It previews selection (the
      // accent's quiet step) because an interactive row here opens something.
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: vars.controlMediumSize),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: -vars.spacing2,
              right: -vars.spacing2,
              child: AnimatedContainer(
                duration: vars.motionDuration,
                curve: vars.motionEasing,
                decoration: BoxDecoration(
                  color: hovered
                      ? vars
                            .colorPrimary[vars
                                .controlColorPlainSurface
                                .hoveredShade!]!
                            .withValues(
                              alpha:
                                  vars.controlColorPlainSurface.hoveredOpacity,
                            )
                      : null,
                  borderRadius: BorderRadius.circular(
                    vars.controlContainerRadius,
                  ),
                ),
              ),
            ),
            row,
          ],
        ),
      );
    }

    if (!interactive) return content(const {});

    return Pressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(vars.controlContainerRadius),
      builder: (context, states) => content(states),
    );
  }
}
