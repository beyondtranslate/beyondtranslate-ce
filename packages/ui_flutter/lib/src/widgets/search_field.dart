import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/widget_size.dart';
import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';
import 'text_field.dart';

/// A search box.
///
/// The box belongs to the wrapper, not the field, because the glyph and the
/// trailing slot sit inside it — so the focus treatment comes from the row
/// rather than from the field itself.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.value,
    this.controller,
    this.placeholder,
    this.size = WidgetSize.medium,
    this.hint,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onDismiss,
    this.clearLabel = 'Clear search',
    this.enabled = true,
    this.tint = TextFieldTint.primary,
  }) : assert(
         value == null || controller == null,
         'A search field is driven by a value or by a controller, not both.',
       );

  /// The query, when the host holds it. Paired with [onChanged], this is the
  /// controlled field React's is: the caller owns the text and the widget
  /// draws it.
  ///
  /// Leave it null to let the field keep its own [controller].
  final String? value;

  final TextEditingController? controller;
  final String? placeholder;

  /// The ramp the focused border and glow are drawn from.
  final TextFieldTint tint;
  final WidgetSize size;

  /// The trailing hint — a `KeyCap` naming the shortcut that focuses the
  /// field. It gives the slot up to the clear button once there is a query.
  final Widget? hint;

  /// Take the focus on mount, for a field a shortcut has just opened.
  final bool autofocus;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Escape, once there is nothing left to clear.
  ///
  /// Escape clears the query first and dismisses only on an already empty
  /// field, so a stray press never closes a search mid-word.
  final VoidCallback? onDismiss;

  /// The accessible name of the clear button.
  final String clearLabel;

  final bool enabled;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChanged);
  late final TextEditingController _controller =
      widget.controller ??
      (TextEditingController(text: widget.value)..addListener(_onTextChanged));

  void _onFocusChanged() => setState(() {});

  /// The trailing slot swaps between the hint and the clear button, so an
  /// owned controller has to redraw the row as the query changes.
  void _onTextChanged() => setState(() {});

  @override
  void didUpdateWidget(SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final String? value = widget.value;
    if (value != null && value != _controller.text) {
      _controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    if (widget.controller == null) {
      _controller
        ..removeListener(_onTextChanged)
        ..dispose();
    }
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _onEscape() {
    if (_controller.text.isEmpty) {
      widget.onDismiss?.call();
      return;
    }
    _clear();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool focused = _focusNode.hasFocus;
    final Color accent = switch (widget.tint.namedTint) {
      NamedTint.primary => vars.colorPrimary,
      NamedTint.neutral => vars.colorNeutral,
      NamedTint.info => vars.colorInfo,
      NamedTint.success => vars.colorSuccess,
      NamedTint.warning => vars.colorWarning,
      NamedTint.danger => vars.colorDanger,
    }[vars.focusRingShade]!;
    final bool hasQuery = _controller.text.isNotEmpty;

    final double height = switch (widget.size.namedSize) {
      NamedSize.tiny => vars.controlTinySize,
      NamedSize.small => vars.controlSmallSize,
      NamedSize.large => vars.controlLargeSize,
      _ => vars.controlMediumSize,
    };

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _onEscape,
      },
      child: AnimatedContainer(
        duration: vars.motionDuration,
        curve: vars.motionEasing,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: vars.spacing3),
        decoration: BoxDecoration(
          // Focus lifts the card to the paper behind a soft accent wash — the
          // same move every text control makes.
          color: focused ? vars.colorSurface : vars.colorSurfaceMuted,
          border: Border.all(
            color: focused ? accent : vars.colorBorderStrong,
            width: context.hairlineWidth,
          ),
          borderRadius: BorderRadius.circular(vars.radiusMedium),
          boxShadow: focused
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: vars.focusGlowAlpha),
                    spreadRadius: vars.focusWidth,
                  ),
                ]
              : null,
        ),
        child: Row(
          spacing: vars.spacing2,
          children: [
            Icon(
              FluentIcons.search_16_regular,
              size: vars.spacing4,
              color: vars.colorContentFaint,
            ),
            Expanded(
              child: TextField.borderless(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: widget.placeholder,
                size: widget.size,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                padding: EdgeInsets.zero,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
              ),
            ),
            // The clear button takes the trailing slot from the hint: the
            // shortcut that focuses an empty field has nothing to say once
            // there is something in it to throw away.
            if (hasQuery)
              _ClearButton(label: widget.clearLabel, onPressed: _clear)
            else
              ?widget.hint,
          ],
        ),
      ),
    );
  }
}

/// The glyph that empties the field.
///
/// A bare glyph rather than an `IconButton`: the stylesheet gives it no box
/// of its own, only the faint ink and the full ink under the pointer, so a
/// hover wash here would draw a second control inside the field.
class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return Pressable(
      onPressed: onPressed,
      semanticsLabel: label,
      borderRadius: BorderRadius.circular(vars.radiusTiny),
      builder: (context, states) => Icon(
        FluentIcons.dismiss_12_regular,
        size: vars.spacing3,
        color: states.contains(WidgetState.hovered)
            ? vars.colorContent
            : vars.colorContentFaint,
      ),
    );
  }
}
