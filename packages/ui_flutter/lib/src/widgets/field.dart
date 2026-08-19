import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/theme/tokens.dart';
import 'package:beyondtranslate_ui/src/widgets/label.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/widgets.dart';

enum FieldState { standard, error }

/// The shared box every form control is drawn in: filled, hairline-bordered,
/// and lit with a 3px accent ring while focused.
BoxDecoration controlDecoration(
  DesignTokens tokens, {
  required FieldState state,
  required bool focused,
  required double hairline,
  double? radius,
}) {
  final colors = tokens.colors;
  final error = state == FieldState.error;

  return BoxDecoration(
    color:
        error ? colors.dangerSurface : (focused ? colors.window : colors.card),
    // Focus and error change the border's *colour* only — React sets both with
    // `border-accent` / `border-danger` over the same `border` utility, so the
    // width stays on the hairline in every state. Thickening it here would
    // shift the text by half a pixel the moment the field takes focus.
    border: Border.all(
      color: error
          ? colors.danger
          : (focused ? colors.accent : colors.hairlineStrong),
      width: hairline,
    ),
    borderRadius: BorderRadius.circular(radius ?? tokens.radii.control),
    boxShadow: focused
        ? [
            BoxShadow(
              color: error ? colors.dangerSurface : colors.accentRing,
              spreadRadius: 3,
            ),
          ]
        : null,
  );
}

/// `px-3 py-[7px]`: 7px over a 12px line lands the control on 28px, level with
/// an md Button — desktop dialogs keep buttons and fields the same height.
const EdgeInsets _kControlPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 7,
);

/// The height that padding is pinned to, so a control never drifts off the
/// button line because of a font's metrics.
const double _kControlHeight = 28;

/// A textarea is not a single-line control: it keeps the wider `py-2.5` inset
/// and grows from `min-h-20`.
const EdgeInsets _kTextAreaPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 10,
);

class Input extends StatefulWidget {
  const Input({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.state = FieldState.standard,
    this.mono = false,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.semanticsLabel,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final FieldState state;

  /// Base URLs, API keys and model IDs are set in the mono face.
  final bool mono;
  final bool obscureText;
  final bool enabled;

  /// Takes the caret on mount — React's `autoFocus`, which the sheets use on
  /// their first field so a dialog can be typed into as soon as it opens.
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? semanticsLabel;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  FocusNode? _ownedNode;
  bool _focused = false;

  FocusNode get _node => widget.focusNode ?? (_ownedNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _node.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(Input oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _node.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _ownedNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _focused) setState(() => _focused = _node.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final error = widget.state == FieldState.error;

    final style = widget.mono
        ? tokens.typography.monoStyle(
            fontSize: 12,
            height: 1,
            color: error ? colors.dangerDeep : colors.fg,
          )
        : tokens.typography.sansStyle(
            fontSize: 12,
            height: 1,
            color: error ? colors.dangerDeep : colors.fg,
          );

    return Semantics(
      textField: true,
      label: widget.semanticsLabel,
      child: AnimatedContainer(
        duration: kTransitionDuration,
        height: _kControlHeight,
        decoration: controlDecoration(
          tokens,
          state: widget.state,
          focused: _focused,
          hairline: context.hairlineWidth,
        ),
        child: CupertinoTextField.borderless(
          controller: widget.controller,
          focusNode: _node,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          textAlignVertical: TextAlignVertical.center,
          padding: _kControlPadding,
          placeholder: widget.placeholder,
          placeholderStyle: style.copyWith(color: colors.fgFaint),
          style: style,
          cursorColor: colors.accent,
          cursorWidth: 1,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }
}

class TextArea extends StatefulWidget {
  const TextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.state = FieldState.standard,
    this.mono = false,
    this.enabled = true,
    this.minHeight = 80,
    this.minLines = 3,
    this.maxLines,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final FieldState state;
  final bool mono;
  final bool enabled;

  /// `min-h-20` in the React source.
  final double minHeight;
  final int minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  FocusNode? _ownedNode;
  bool _focused = false;

  FocusNode get _node => widget.focusNode ?? (_ownedNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _node.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _ownedNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _focused) setState(() => _focused = _node.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final error = widget.state == FieldState.error;

    final style = (widget.mono
            ? tokens.typography.monoStyle(fontSize: 12)
            : tokens.typography.sansStyle(fontSize: 12))
        .copyWith(
      height: 1.6,
      color: error ? colors.dangerDeep : colors.fg,
    );

    return AnimatedContainer(
      duration: kTransitionDuration,
      constraints: BoxConstraints(minHeight: widget.minHeight),
      // A textarea grows, so it takes the container corner rather than the
      // control corner — otherwise a pill theme turns it into a lozenge.
      decoration: controlDecoration(
        tokens,
        state: widget.state,
        focused: _focused,
        hairline: context.hairlineWidth,
        radius: tokens.radii.box,
      ),
      child: CupertinoTextField.borderless(
        controller: widget.controller,
        focusNode: _node,
        enabled: widget.enabled,
        padding: _kTextAreaPadding,
        placeholder: widget.placeholder,
        placeholderStyle: style.copyWith(color: colors.fgFaint),
        style: style,
        cursorColor: colors.accent,
        cursorWidth: 1,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
      ),
    );
  }
}

@immutable
class SelectItem<T> {
  const SelectItem({required this.value, required this.label});

  final T value;
  final String label;
}

/// A closed dropdown drawn in the shape of an input. Opening it presents the
/// options in a popover styled from the same tokens.
class Select<T> extends StatefulWidget {
  const Select({
    super.key,
    required this.items,
    required this.value,
    this.onChanged,
    this.state = FieldState.standard,
    this.mono = false,
    this.enabled = true,
    this.semanticsLabel,
  });

  final List<SelectItem<T>> items;
  final T value;
  final ValueChanged<T>? onChanged;
  final FieldState state;
  final bool mono;
  final bool enabled;
  final String? semanticsLabel;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }

  void _open() {
    if (_entry != null) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final box = context.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 200;
    final tokens = context.tokens;
    final colors = tokens.colors;

    _entry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(_removeOverlay),
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(0, 4),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: DesignTheme(
                tokens: tokens,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.panel,
                    border: Border.all(
                      color: colors.hairlineStrong,
                      width: overlayContext.hairlineWidth,
                    ),
                    borderRadius: BorderRadius.circular(tokens.radii.popover),
                    boxShadow: tokens.shadows.popover,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final item in widget.items)
                        _SelectRow(
                          label: item.label,
                          mono: widget.mono,
                          selected: item.value == widget.value,
                          onPressed: () {
                            setState(_removeOverlay);
                            widget.onChanged?.call(item.value);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_entry!);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final error = widget.state == FieldState.error;
    final disabled = !widget.enabled || widget.onChanged == null;

    final selected = widget.items
        .where((item) => item.value == widget.value)
        .map((item) => item.label)
        .firstOrNull;

    final style = (widget.mono
            ? tokens.typography.monoStyle(fontSize: 12)
            : tokens.typography.sansStyle(fontSize: 12))
        .copyWith(height: 1, color: error ? colors.dangerDeep : colors.fg);

    return CompositedTransformTarget(
      link: _link,
      child: Pressable(
        enabled: !disabled,
        onPressed: disabled ? null : () => setState(_open),
        borderRadius: BorderRadius.circular(tokens.radii.control),
        semanticsLabel: widget.semanticsLabel,
        builder: (context, state) => Opacity(
          opacity: disabled ? 0.6 : 1,
          child: Container(
            height: _kControlHeight,
            // `pr-7` on the control with the chevron inset at `right-2.5`:
            // 12 + 6 + 12 + 10 back from the right edge is the same 28px the
            // native arrow reserves.
            padding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
            decoration: controlDecoration(
              tokens,
              state: widget.state,
              focused: _entry != null || state.focused,
              hairline: context.hairlineWidth,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected ?? '',
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                // The native arrow ignores padding, so the control draws the
                // same Fluent chevron every other trailing glyph uses.
                Icon(
                  FluentIcons.chevron_down_20_regular,
                  size: 12,
                  color: colors.fgSubtle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.selected,
    required this.mono,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final bool mono;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Pressable(
      onPressed: onPressed,
      selected: selected,
      isButton: false,
      showFocusRing: false,
      builder: (context, state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: selected
            ? tokens.selection
            : (state.hovered ? colors.subtle : null),
        child: Text(
          label,
          style: (mono
                  ? tokens.typography.monoStyle(fontSize: 12)
                  : tokens.typography.sansStyle(fontSize: 12))
              .copyWith(
            height: 1,
            color: selected ? tokens.selectionFg : colors.fg,
          ),
        ),
      ),
    );
  }
}

/// Label + control + hint, the layout every form row in the deck uses.
class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.label,
    this.hint,
    this.state = FieldState.standard,
    required this.child,
  });

  final Widget label;

  /// Help text below the control; rendered in the danger tone when erroring.
  final Widget? hint;
  final FieldState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Label(
            tone:
                state == FieldState.error ? LabelTone.danger : LabelTone.subtle,
            child: label,
          ),
        ),
        const SizedBox(height: 6),
        child,
        if (hint != null) ...[
          const SizedBox(height: 6),
          DefaultTextStyle(
            style: tokens.typography.sansStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.6,
              color:
                  state == FieldState.error ? colors.dangerFg : colors.fgSubtle,
            ),
            child: hint!,
          ),
        ],
      ],
    );
  }
}

/// A read-only value rendered in the shape of an input. The design deck shows
/// several of these, and settings screens genuinely need non-editable value
/// rows.
class FieldValue extends StatelessWidget {
  const FieldValue({super.key, this.mono = false, required this.child});

  final bool mono;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: _kControlPadding,
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(
          color: colors.hairlineStrong,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.control),
      ),
      child: DefaultTextStyle(
        style: (mono
                ? tokens.typography.monoStyle(fontSize: 12)
                : tokens.typography.sansStyle(fontSize: 12))
            .copyWith(height: 1, color: colors.fg),
        child: child,
      ),
    );
  }
}
