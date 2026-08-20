import 'package:flutter/widgets.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

/// Opens [menu] just under the widget [anchorKey] is attached to.
///
/// [anchorX] picks the horizontal anchor along that widget: 0.5 centres the
/// menu under it, 1.0 pins it to the trailing edge. [window] defaults to the
/// focused one, which is the window the press came from. Returns whether the
/// platform actually put a menu up — a caller that holds the menu alive can
/// let it go again when it did not.
bool openNativeMenuBelow(
  GlobalKey anchorKey,
  nativeapi.Menu menu, {
  nativeapi.Placement placement = nativeapi.Placement.bottom,
  double anchorX = 0.5,
  nativeapi.Window? window,
}) {
  final renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) return false;

  final target = window ?? nativeapi.WindowManager.instance.getCurrent();
  if (target == null) return false;

  final localPosition = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;
  final anchorPosition = Offset(
    localPosition.dx + size.width * anchorX,
    localPosition.dy + size.height + 4,
  );

  return menu.open(
    nativeapi.PositioningStrategy.relativeToWindow(target, anchorPosition),
    placement,
  );
}

/// One row of a [NativeMenu].
@immutable
class NativeMenuItem {
  const NativeMenuItem({
    required this.label,
    this.onSelect,
    this.enabled = true,
    this.checked,
    this.separatorBefore = false,
  });

  final String label;
  final VoidCallback? onSelect;
  final bool enabled;

  /// Check state. Leave null for a plain row; pass a boolean to get AppKit's
  /// checkmark column, the way the language menus mark the current pick.
  final bool? checked;

  /// Draws a native separator above this item — the rule a menu puts before
  /// its destructive tail.
  final bool separatorBefore;
}

enum NativeMenuAlign { start, end }

/// The kit's [Menu] shape — a trigger that owns a list of items — opening the
/// *platform's* own menu rather than a Flutter overlay.
///
/// A menu is the control a user compares hardest against the rest of the OS:
/// an in-app panel gets the shadow, the corner radius, the open animation and
/// the keyboard behaviour subtly wrong, and it clips at the window edge where
/// AppKit's would flip. The trigger stays ours — it has to sit in a row of the
/// kit's own buttons — and only the open state is native, the same split
/// [NativeSelect] draws.
///
/// The kit's `Menu` stays what the gallery renders, and what a test can drive.
class NativeMenu extends StatefulWidget {
  const NativeMenu({
    super.key,
    required this.trigger,
    required this.items,
    this.align = NativeMenuAlign.end,
    this.window,
  });

  /// Renders the trigger; receives the open state and a toggle callback, so a
  /// call site reads the same as it did against the kit's `Menu`.
  final Widget Function(BuildContext context, bool open, VoidCallback toggle)
      trigger;
  final List<NativeMenuItem> items;

  /// Which edge of the trigger the menu hangs from.
  final NativeMenuAlign align;

  /// The window the menu anchors to; defaults to the focused one.
  final nativeapi.Window? window;

  /// Stands in for AppKit in a widget test, which has no platform menu to open
  /// and no way to click one. Given the items the menu would have shown, it
  /// returns the one to select, or null for a dismissal.
  @visibleForTesting
  static Future<NativeMenuItem?> Function(List<NativeMenuItem> items)?
      debugPresenter;

  @override
  State<NativeMenu> createState() => _NativeMenuState();
}

class _NativeMenuState extends State<NativeMenu> {
  final GlobalKey _anchorKey = GlobalKey();

  /// True while the platform menu is up, so the trigger can hold the on-state
  /// an open menu gives it.
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

  void _toggle() {
    // A press while the menu is up only reaches Flutter when AppKit has
    // already dismissed it, but closing here keeps the two states honest for
    // any other route into this callback.
    if (_open) {
      _menu?.close();
      return;
    }
    final presenter = NativeMenu.debugPresenter;
    if (presenter != null) {
      _presentForTest(presenter);
      return;
    }
    _openMenu();
  }

  Future<void> _presentForTest(
    Future<NativeMenuItem?> Function(List<NativeMenuItem>) presenter,
  ) async {
    setState(() => _open = true);
    final picked = await presenter(widget.items);
    if (mounted) setState(() => _open = false);
    picked?.onSelect?.call();
  }

  void _openMenu() {
    if (widget.items.isEmpty) return;

    // Whatever is left of the previous menu goes now, not when it closed.
    _release();

    final menu = nativeapi.Menu();
    final items = <nativeapi.MenuItem>[];
    final actions = <int, VoidCallback>{};

    for (final entry in widget.items) {
      if (entry.separatorBefore && items.isNotEmpty) menu.addSeparator();
      final item = nativeapi.MenuItem(
        entry.label,
        entry.checked == null
            ? nativeapi.MenuItemType.normal
            : nativeapi.MenuItemType.checkbox,
      );
      item.enabled = entry.enabled;
      if (entry.checked != null) {
        item.state = entry.checked!
            ? nativeapi.MenuItemState.checked
            : nativeapi.MenuItemState.unchecked;
      }
      final onSelect = entry.onSelect;
      if (onSelect != null) {
        actions[item.id] = onSelect;
        item.on<nativeapi.MenuItemClickedEvent>((event) {
          actions[event.menuItemId]?.call();
        });
      }
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

    final opened = openNativeMenuBelow(
      _anchorKey,
      menu,
      placement: widget.align == NativeMenuAlign.end
          ? nativeapi.Placement.bottomEnd
          : nativeapi.Placement.bottomStart,
      anchorX: widget.align == NativeMenuAlign.end ? 1.0 : 0.0,
      window: widget.window,
    );

    // Nothing was shown, so nothing can be clicked — safe to release now.
    if (!opened) {
      _release();
      setState(() => _open = false);
    }
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
        key: _anchorKey,
        child: widget.trigger(context, _open, _toggle),
      );
}
