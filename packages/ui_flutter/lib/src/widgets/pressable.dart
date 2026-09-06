import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'focus_ring.dart';

/// The one interactive primitive every clickable atom is built on.
///
/// It reproduces what the browser gives a `<button>` for free: the pointer
/// cursor, hover and press tracking, keyboard focus with Space/Enter
/// activation, the focus-visible ring, and the semantics an assistive
/// technology reads. A component that rolled its own would drift on one of
/// those the moment it was written.
///
/// The state arrives as the [WidgetState] set the recipes already resolve
/// against, so a component's colours stay one `resolveWith` call rather than a
/// ladder of conditionals. It is also resolved *before* the subtree is built,
/// which is what lets a recipe move its content colour as well as its surface:
/// a refinement applied after a text run's colour is baked would move the
/// surface and leave the label behind.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    this.onPressed,
    this.enabled = true,
    this.borderRadius = BorderRadius.zero,
    this.showFocusRing = true,
    this.semanticsLabel,
    this.checked,
    this.selected,
    this.isButton = true,
    this.cursor,
    this.behavior = HitTestBehavior.opaque,
    this.onHover,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    required this.builder,
  });

  final VoidCallback? onPressed;

  final bool enabled;

  /// The corner the focus ring follows.
  final BorderRadius borderRadius;

  final bool showFocusRing;

  final String? semanticsLabel;

  /// Set for switches, radios and checkboxes, so assistive technology
  /// announces the `aria-checked` equivalent.
  final bool? checked;

  /// The `aria-selected` equivalent, for tabs and list rows.
  final bool? selected;

  final bool isButton;

  final MouseCursor? cursor;

  final HitTestBehavior behavior;

  final ValueChanged<bool>? onHover;

  final FocusNode? focusNode;

  final bool autofocus;

  final ValueChanged<bool>? onFocusChange;

  final Widget Function(BuildContext context, Set<WidgetState> states) builder;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onPressed != null;

  void _activate() {
    if (_interactive) widget.onPressed!.call();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    final Set<WidgetState> states = <WidgetState>{
      if (_hovered && _interactive) WidgetState.hovered,
      if (_focused) WidgetState.focused,
      if (_pressed && _interactive) WidgetState.pressed,
      if (widget.selected ?? false) WidgetState.selected,
      if (!_interactive) WidgetState.disabled,
    };

    Widget result = widget.builder(context, states);

    if (widget.showFocusRing) {
      // The ring is the system accent on every control, macOS-style — a
      // danger button focuses in the same halo as everything else.
      result = FocusRing(
        visible: _focused,
        color: vars.colorPrimary[vars.focusRingShade]!.withValues(
          alpha: vars.focusRingAlpha,
        ),
        borderRadius: widget.borderRadius,
        width: vars.focusWidth,
        offset: vars.focusOffset,
        child: result,
      );
    }

    result = FocusableActionDetector(
      enabled: _interactive,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.onFocusChange,
      mouseCursor:
          widget.cursor ??
          (_interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden),
      onShowHoverHighlight: (value) {
        if (value == _hovered) return;
        setState(() => _hovered = value);
        widget.onHover?.call(value);
      },
      onShowFocusHighlight: (value) {
        if (value != _focused) setState(() => _focused = value);
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _activate();
            return null;
          },
        ),
      },
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: Listener(
        onPointerDown: (_) {
          if (_interactive) setState(() => _pressed = true);
        },
        onPointerUp: (_) {
          if (_pressed) setState(() => _pressed = false);
        },
        onPointerCancel: (_) {
          if (_pressed) setState(() => _pressed = false);
        },
        child: GestureDetector(
          behavior: widget.behavior,
          onTap: _interactive ? _activate : null,
          child: result,
        ),
      ),
    );

    return Semantics(
      container: true,
      enabled: widget.enabled,
      button: widget.isButton && widget.checked == null,
      checked: widget.checked,
      selected: widget.selected,
      label: widget.semanticsLabel,
      child: result,
    );
  }
}

/// Hover tracking without the button semantics — for rows that only change
/// colour under the pointer.
class HoverRegion extends StatefulWidget {
  const HoverRegion({super.key, required this.builder, this.enabled = true});

  final bool enabled;
  final Widget Function(BuildContext context, bool hovered) builder;

  @override
  State<HoverRegion> createState() => _HoverRegionState();
}

class _HoverRegionState extends State<HoverRegion> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.enabled) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (_hovered) setState(() => _hovered = false);
      },
      child: widget.builder(context, _hovered && widget.enabled),
    );
  }
}
