import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// The header row of a disclosure, and the panel under it.
///
/// [Collapsible] is one of them; an [Accordion] is several that know about
/// each other, and it wears this same drawing. So the two parts below are
/// shared the way [MenuPanel] and [MenuRow] are shared by the three menus —
/// one drawing, not two that resemble each other.
class DisclosureHeader extends StatelessWidget {
  const DisclosureHeader({
    super.key,
    required this.title,
    required this.open,
    this.icon,
    this.meta,
    this.onPressed,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  final Widget title;

  final bool open;

  final IconData? icon;

  /// A trailing aside — a count, a duration, a [Badge]. It is what makes a
  /// shut row worth reading, so the reader can decide whether to open it.
  final Widget? meta;

  final VoidCallback? onPressed;

  final bool enabled;

  final FocusNode? focusNode;

  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    // A header row grows with what it holds — a badge, a wrapped title — so it
    // takes the shared corner for a box that grows rather than Bright's pill.
    final BorderRadius radius = BorderRadius.circular(
      vars.controlContainerRadius,
    );
    final bool interactive = enabled && onPressed != null;

    return Pressable(
      onPressed: interactive ? onPressed : null,
      enabled: interactive,
      borderRadius: radius,
      selected: open,
      builder: (context, states) {
        // The row is not on the shared control state machine. `normal` is the
        // right recipe for a row's wash, but its resting surface is opaque
        // paper, and a header that painted itself would cut a card in half; so
        // the wash is read on hover alone and the row rests transparent —
        // exactly what a menu row does.
        final bool washed =
            interactive &&
            (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed));
        final Color content = interactive
            ? vars.colorContent
            : vars.controlColorNormalContent.disabledColor!;

        return AnimatedContainer(
          duration: vars.motionDuration,
          curve: vars.motionEasing,
          padding: EdgeInsets.all(vars.spacing2),
          decoration: BoxDecoration(
            color: washed ? vars.colorSurfaceSubtle : null,
            borderRadius: radius,
          ),
          child: Row(
            spacing: vars.spacing2,
            children: [
              // The chevron points along the row when shut and down the page
              // when open — one glyph rotated rather than two swapped, so the
              // turn is the animation. It is the only moving part.
              SizedBox(
                width: vars.spacing3,
                child: AnimatedRotation(
                  duration: vars.motionDuration,
                  curve: vars.motionEasing,
                  turns: open ? 0.25 : 0,
                  child: Icon(
                    FluentIcons.chevron_right_12_regular,
                    size: vars.labelSmall.fontSize,
                    color: interactive ? vars.colorContentSubtle : content,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: vars.spacing35,
                  color: interactive ? vars.colorContentMuted : content,
                ),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: vars.labelMedium.copyWith(color: content),
                  child: title,
                ),
              ),
              if (meta != null)
                DefaultTextStyle.merge(
                  style: vars.labelQuiet.copyWith(
                    fontSize: vars.labelSmall.fontSize,
                    color: vars.colorContentFaint,
                  ),
                  child: meta!,
                ),
            ],
          ),
        );
      },
    );
  }
}

/// What a disclosure discloses.
///
/// The content is indented to the chevron's far edge, so a nested list lines
/// up under the label rather than under the glyph.
class DisclosurePanel extends StatelessWidget {
  const DisclosurePanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        vars.spacing2 + vars.spacing3 + vars.spacing2,
        vars.spacing1,
        vars.spacing2,
        vars.spacing3,
      ),
      child: DefaultTextStyle.merge(
        style: vars.bodySmall.copyWith(color: vars.colorContentSecondary),
        child: child,
      ),
    );
  }
}

/// One thing that opens.
///
/// The header row is the affordance and the panel is what it discloses. It is
/// the smallest of the three ways this system hides something: a collapsible
/// keeps its subject in place and only folds it, where a [Popover] moves it
/// off the page and a [Dialog] stops the page.
class Collapsible extends StatefulWidget {
  const Collapsible({
    super.key,
    required this.title,
    this.child,
    this.icon,
    this.meta,
    this.open,
    this.initiallyOpen = false,
    this.onOpenChanged,
    this.enabled = true,
  });

  final Widget title;

  final Widget? child;

  final IconData? icon;

  final Widget? meta;

  /// Drive it from outside. Left null the widget holds its own state.
  final bool? open;

  final bool initiallyOpen;

  final ValueChanged<bool>? onOpenChanged;

  final bool enabled;

  @override
  State<Collapsible> createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible> {
  late bool _open = widget.initiallyOpen;

  bool get _isOpen => widget.open ?? _open;

  void _toggle() {
    final bool next = !_isOpen;
    if (widget.open == null) setState(() => _open = next);
    widget.onOpenChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DisclosureHeader(
          title: widget.title,
          icon: widget.icon,
          meta: widget.meta,
          open: _isOpen,
          enabled: widget.enabled,
          onPressed: _toggle,
        ),
        // The panel animates its own height, which is the one thing a
        // disclosure cannot do declaratively: `auto` is not a length to
        // interpolate from in CSS, and here the content has to be laid out
        // before it has one. `AnimatedSize` measures it and animates the box
        // around it, which is the same trick from the other side.
        ClipRect(
          child: AnimatedSize(
            duration: vars.motionDuration,
            curve: vars.motionEasing,
            alignment: Alignment.topCenter,
            child: _isOpen && widget.child != null
                ? DisclosurePanel(child: widget.child!)
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}
