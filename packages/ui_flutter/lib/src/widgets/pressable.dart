import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/focus_ring.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Tailwind's `transition-colors` default.
const Duration kTransitionDuration = Duration(milliseconds: 150);

/// The interaction state a [Pressable] hands to its builder.
@immutable
class PressableState {
  const PressableState({
    this.hovered = false,
    this.focused = false,
    this.pressed = false,
    this.enabled = true,
  });

  final bool hovered;
  final bool focused;
  final bool pressed;
  final bool enabled;
}

/// The one interactive primitive every clickable atom is built on.
///
/// It reproduces what the browser gives a `<button>` for free: pointer cursor,
/// hover state, keyboard focus and activation with Space/Enter, and the
/// focus-visible ring — which is drawn only for keyboard focus, matching
/// `:focus-visible`.
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
    this.isLink = false,
    this.cursor,
    this.behavior = HitTestBehavior.opaque,
    required this.builder,
  });

  final VoidCallback? onPressed;
  final bool enabled;

  /// Corner radius the focus ring should follow.
  final BorderRadius borderRadius;
  final bool showFocusRing;
  final String? semanticsLabel;

  /// Set for switches, radios and checkboxes so assistive tech announces the
  /// `aria-checked` equivalent.
  final bool? checked;

  /// The `aria-selected` equivalent, for tabs and list rows.
  final bool? selected;
  final bool isButton;
  final bool isLink;
  final MouseCursor? cursor;
  final HitTestBehavior behavior;
  final Widget Function(BuildContext context, PressableState state) builder;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onPressed != null;

  void _handleActivate() {
    if (!_interactive) return;
    widget.onPressed!.call();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final state = PressableState(
      hovered: _hovered && _interactive,
      focused: _focused,
      pressed: _pressed && _interactive,
      enabled: widget.enabled,
    );

    Widget result = widget.builder(context, state);

    if (widget.showFocusRing) {
      result = FocusRing(
        visible: _focused,
        color: tokens.colors.focusRing,
        borderRadius: widget.borderRadius,
        child: result,
      );
    }

    result = FocusableActionDetector(
      enabled: _interactive,
      mouseCursor: widget.cursor ??
          (widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden),
      onShowHoverHighlight: (value) {
        if (value != _hovered) setState(() => _hovered = value);
      },
      onShowFocusHighlight: (value) {
        if (value != _focused) setState(() => _focused = value);
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _handleActivate();
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
          onTap: _interactive ? _handleActivate : null,
          child: result,
        ),
      ),
    );

    return Semantics(
      container: true,
      enabled: widget.enabled,
      button: widget.isButton && widget.checked == null,
      link: widget.isLink,
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
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) {
          if (widget.enabled) setState(() => _hovered = true);
        },
        onExit: (_) => setState(() => _hovered = false),
        child: widget.builder(context, _hovered && widget.enabled),
      );
}
