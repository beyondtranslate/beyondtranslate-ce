import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'field_box.dart';
import 'menu.dart';
import 'popover.dart';
import 'pressable.dart';
import 'text_field.dart';

/// One choosable option.
@immutable
class SelectOption<T> {
  const SelectOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;

  /// What the trigger shows, and what the row prints.
  final String label;

  final bool enabled;
}

/// A run of options under a heading, the way `<optgroup>` groups.
@immutable
class SelectGroup<T> {
  const SelectGroup({required this.label, required this.options});

  final String label;

  final List<SelectOption<T>> options;
}

/// A choice out of a list too long to lay out.
///
/// It is a [TextField] with a chevron, so it shares the box outright: the same
/// height, the same corner, the same border recipe, the same focus lift. Its
/// list is the [MenuPanel] — the panel a [Menu] and a [Combobox] open — with a
/// tick on the chosen row. It takes its options as data rather than as
/// children, because the rows are drawn here rather than by the host.
///
/// The difference from a [Combobox] is the query: a list of six is a select, a
/// list of six hundred is a combobox. Both end in one of their options, and
/// neither lets a reader enter something that is not on the list, which is
/// what separates them from an [Autocomplete].
class Select<T> extends StatefulWidget {
  const Select({
    super.key,
    this.options = const [],
    this.groups = const [],
    this.value,
    this.onChanged,
    this.placeholder = 'Choose…',
    this.size = WidgetSize.medium,
    this.state = TextFieldState.normal,
    this.tint = TextFieldTint.primary,
  });

  /// The flat list. Leave it empty and pass [groups] instead to group them.
  ///
  /// Grouped or flat, never both: a list read one way would silently lose the
  /// other. It is not asserted in the constructor — `length` is not something
  /// a `const` assert may read, and every story here is const — so the build
  /// reads [groups] first and ignores a flat list beside it.
  final List<SelectOption<T>> options;

  /// The grouped list. When it is not empty it is what is drawn.
  final List<SelectGroup<T>> groups;

  final T? value;

  /// Called with the chosen value. A select with no handler is disabled, the
  /// way a text field that cannot be typed into is.
  final ValueChanged<T?>? onChanged;

  final String placeholder;

  final WidgetSize size;

  final TextFieldState state;

  final TextFieldTint tint;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  final OverlayPortalController _controller = OverlayPortalController();
  final LayerLink _link = LayerLink();
  bool _open = false;
  double _anchorWidth = 0;

  List<SelectOption<T>> get _flat => [
    ...widget.options,
    for (final SelectGroup<T> group in widget.groups) ...group.options,
  ];

  SelectOption<T>? get _chosen {
    for (final SelectOption<T> option in _flat) {
      if (option.value == widget.value) return option;
    }
    return null;
  }

  void _toggle() => _open ? _close() : _openList();

  void _openList() {
    if (_open) return;
    setState(() => _open = true);
    _controller.show();
  }

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
    _controller.hide();
  }

  void _choose(SelectOption<T> option) {
    widget.onChanged?.call(option.value);
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool enabled = widget.onChanged != null;

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (context) => PopoverOverlay(
          link: _link,
          side: PopoverSide.bottom,
          align: PopoverAlign.start,
          gap: vars.spacing1,
          onDismiss: _close,
          // The list is at least as wide as the trigger it dropped from, so a
          // long label never has to be read in a narrower column than it was
          // chosen in.
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: _anchorWidth),
            child: _SelectList<T>(
              options: widget.options,
              groups: widget.groups,
              selected: widget.value,
              onChoose: _choose,
            ),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool bounded = constraints.maxWidth.isFinite;
            if (bounded) {
              _anchorWidth = constraints.maxWidth;
            }

            return Pressable(
              onPressed: enabled ? _toggle : null,
              enabled: enabled,
              borderRadius: BorderRadius.circular(vars.controlFieldRadius),
              builder: (context, states) =>
                  _box(context, vars, states, bounded: bounded),
            );
          },
        ),
      ),
    );
  }

  /// The value, with every label hidden behind it so the box measures to the
  /// longest one.
  ///
  /// The face wraps the whole stack rather than the value alone.
  /// `Visibility(maintainState:)` keeps a hidden label in the tree, and a
  /// `RichText` with no style of its own is what a reader of the tree — the
  /// canvas, a parity probe — finds first; leaving one at the ambient body
  /// size would say the select is set in a face it never chose.
  Widget _value(ThemeVariables vars, SelectOption<T>? chosen) {
    return DefaultTextStyle.merge(
      style: _valueStyle(vars),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          for (final SelectOption<T> option in _flat)
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Text(option.label, maxLines: 1),
            ),
          Text(
            chosen?.label ?? widget.placeholder,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// The value's own face, the way the drawn text field sets one: the control
  /// profile's face at the light weight a quiet label uses, with the leading
  /// that keeps one line centred in the box. The ink is the content recipe,
  /// re-tinted to the ramp's deep step while the select is erroring — the same
  /// three-way choice a field's own text makes, so a select and the input
  /// beside it never disagree about what a value looks like.
  TextStyle _valueStyle(ThemeVariables vars) {
    final bool enabled = widget.onChanged != null;
    final TextStyle base = _metrics(vars).face.copyWith(
      fontWeight: vars.bodySmall.fontWeight,
    );
    return base.copyWith(
      height: 1,
      color: !enabled
          ? vars.controlColorNormalContent.disabledColor!
          : (_chosen == null
                ? vars.colorContentFaint
                : (widget.state == TextFieldState.error
                      ? vars.colorDanger[800]!
                      : vars.colorContent)),
    );
  }

  FieldMetrics _metrics(ThemeVariables vars) =>
      FieldMetrics.of(vars, widget.size);

  /// The box: the [TextField]'s own decoration, with the value and the chevron
  /// in place of a caret.
  Widget _box(
    BuildContext context,
    ThemeVariables vars,
    Set<WidgetState> states, {
    required bool bounded,
  }) {
    final FieldMetrics metrics = FieldMetrics.of(vars, widget.size);
    final bool enabled = widget.onChanged != null;
    final bool invalid = widget.state == TextFieldState.error;
    final ColorSwatch<int> ramp = switch (tintForState(
      widget.state,
      widget.tint,
    )) {
      TextFieldTint.primary => vars.colorPrimary,
      TextFieldTint.neutral => vars.colorNeutral,
      TextFieldTint.info => vars.colorInfo,
      TextFieldTint.success => vars.colorSuccess,
      TextFieldTint.warning => vars.colorWarning,
      TextFieldTint.danger => vars.colorDanger,
    };
    final SelectOption<T>? chosen = _chosen;

    return AnimatedContainer(
      duration: vars.motionDuration,
      curve: vars.motionEasing,
      height: metrics.height,
      decoration: fieldBoxDecoration(
        context,
        ramp: ramp,
        // The trigger of an open list is not idle, so it lifts while the list
        // is open as well as while it holds the focus.
        focused: states.contains(WidgetState.focused) || _open,
        invalid: invalid,
        enabled: enabled,
      ),
      padding: EdgeInsetsDirectional.fromSTEB(
        vars.spacing3,
        0,
        vars.spacing3,
        0,
      ),
      child: Row(
        spacing: vars.spacing2,
        // Whether the value may be laid over the hidden labels at all depends
        // on the width the select was handed. A `Row` whose incoming width is
        // unbounded refuses a flex child outright, so a select dropped into a
        // row that shrink-wraps is measured from the labels rather than told
        // to fill a space nothing defined; given a width, the value takes what
        // the chevron leaves and the labels never widen the box past it.
        children: [
          if (bounded)
            Flexible(child: _value(vars, chosen))
          else
            _value(vars, chosen),
          Icon(
            FluentIcons.chevron_down_12_regular,
            size: vars.spacing3,
            color: enabled ? vars.colorContentSubtle : vars.colorContentFaint,
          ),
        ],
      ),
    );
  }
}

/// The dropped list: the options, grouped or flat.
class _SelectList<T> extends StatelessWidget {
  const _SelectList({
    required this.options,
    required this.groups,
    required this.selected,
    required this.onChoose,
  });

  final List<SelectOption<T>> options;
  final List<SelectGroup<T>> groups;
  final T? selected;
  final ValueChanged<SelectOption<T>> onChoose;

  @override
  Widget build(BuildContext context) {
    Widget row(SelectOption<T> option) => MenuRow(
      item: MenuItem(
        label: option.label,
        checked: option.value == selected,
        enabled: option.enabled,
      ),
      onSelect: option.enabled ? () => onChoose(option) : null,
    );

    final List<Widget> children = groups.isEmpty
        ? [for (final SelectOption<T> option in options) row(option)]
        : [
            for (final SelectGroup<T> group in groups) ...[
              MenuGroupLabel(child: Text(group.label)),
              ...group.options.map(row),
            ],
          ];

    return MenuPanel(children: children);
  }
}
