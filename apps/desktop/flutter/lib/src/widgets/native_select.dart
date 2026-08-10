import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import 'ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        FieldState,
        Pressable,
        controlDecoration,
        kTransitionDuration;

/// One option of a [NativeSelect].
@immutable
class NativeSelectItem<T> {
  const NativeSelectItem({
    required this.value,
    required this.label,
    this.separatorBefore = false,
  });

  final T value;
  final String label;

  /// Draws a native separator above this item — for a roster that comes in
  /// runs, the way the language picker splits 常用 from the rest.
  final bool separatorBefore;
}

/// A select drawn in the deck's control shape that opens the *platform's* own
/// menu rather than a Flutter overlay.
///
/// A settings dropdown is one of the few controls a user compares directly
/// against the rest of the OS: an in-app popup gets the shadow, the corner and
/// the keyboard behaviour subtly wrong, and on macOS it loses the checkmark
/// column and the menu's own scrolling. The closed control stays ours — it has
/// to line up with the inputs beside it — and only the open state is native.
class NativeSelect<T> extends StatefulWidget {
  const NativeSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.mono = false,
    this.state = FieldState.standard,
    this.placeholder,
    this.semanticsLabel,
  });

  final T value;
  final List<NativeSelectItem<T>> items;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  /// Model ids and endpoints are set in the mono face, as in the kit's Select.
  final bool mono;
  final FieldState state;

  /// Shown when [value] matches no item — a provider whose model roster has
  /// not loaded yet, for instance.
  final String? placeholder;
  final String? semanticsLabel;

  @override
  State<NativeSelect<T>> createState() => _NativeSelectState<T>();
}

class _NativeSelectState<T> extends State<NativeSelect<T>> {
  /// True while the platform menu is up, so the control can hold the focus
  /// ring the way an open dropdown does.
  bool _open = false;

  /// The menu that is up, or the last one that was.
  ///
  /// It is *not* torn down when the menu closes: AppKit closes the menu before
  /// it fires the item's action, and disposing a [nativeapi.MenuItem] drops it
  /// from the table the click callback looks itself up in — so tearing down on
  /// close swallows the selection that caused it. Holding one menu until the
  /// next open costs nothing and removes the race.
  nativeapi.Menu? _menu;
  List<nativeapi.MenuItem> _items = const [];

  void _release() {
    for (final item in _items) {
      item.dispose();
    }
    _items = const [];
    _menu?.dispose();
    _menu = null;
  }

  @override
  void dispose() {
    _release();
    super.dispose();
  }

  bool get _disabled =>
      !widget.enabled || widget.onChanged == null || widget.items.isEmpty;

  String get _label {
    for (final item in widget.items) {
      if (item.value == widget.value) return item.label;
    }
    return widget.placeholder ?? '';
  }

  void _openMenu() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final window = nativeapi.WindowManager.instance.getCurrent();
    if (window == null) return;

    // Whatever is left of the previous menu goes now, not when it closed.
    _release();

    final origin = box.localToGlobal(Offset.zero);
    final menu = nativeapi.Menu();
    final items = <nativeapi.MenuItem>[];
    final values = <int, T>{};

    for (final entry in widget.items) {
      if (entry.separatorBefore && items.isNotEmpty) menu.addSeparator();
      // The mark comes from the item's state, not from a radio type: a plain
      // item is the shape the rest of the app already opens menus with, and
      // the state is what AppKit draws the checkmark from.
      final item = nativeapi.MenuItem(entry.label);
      item.state = entry.value == widget.value
          ? nativeapi.MenuItemState.checked
          : nativeapi.MenuItemState.unchecked;
      values[item.id] = entry.value;
      item.on<nativeapi.MenuItemClickedEvent>((event) {
        final value = values[event.menuItemId];
        if (value != null) widget.onChanged?.call(value);
      });
      items.add(item);
      menu.addItem(item);
    }

    menu.on<nativeapi.MenuClosedEvent>((_) {
      // Only the open state — the menu itself outlives its own close event so
      // the click that follows can still find its item.
      if (mounted) setState(() => _open = false);
    });

    _menu = menu;
    _items = items;
    setState(() => _open = true);
    menu.open(
      nativeapi.PositioningStrategy.relativeToWindow(
        window,
        Offset(origin.dx, origin.dy + box.size.height),
      ),
      nativeapi.Placement.bottomStart,
    );
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
      height: 1,
      color: error ? colors.dangerDeep : colors.fg,
    );

    return Pressable(
      enabled: !_disabled,
      onPressed: _disabled ? null : _openMenu,
      borderRadius: BorderRadius.circular(tokens.radii.control),
      semanticsLabel: widget.semanticsLabel,
      builder: (context, state) => Opacity(
        opacity: _disabled ? 0.6 : 1,
        child: AnimatedContainer(
          duration: kTransitionDuration,
          // The same 28px box the kit's Select and Input draw, so a native
          // dropdown can stand in a form row without moving anything.
          height: 28,
          // `pr-7` with the chevron inset at `right-2.5`.
          padding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
          decoration: controlDecoration(
            tokens,
            state: widget.state,
            focused: _open || state.focused,
            hairline: context.hairlineWidth,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _label,
                  style: _label.isEmpty
                      ? style.copyWith(color: colors.fgFaint)
                      : style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                FluentIcons.chevron_down_20_regular,
                size: 12,
                color: colors.fgSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
