import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

/// A Flutter widget that displays a dropdown field using a native [Menu].
///
/// When tapped, it opens the operating system's native menu at the widget's
/// position, instead of using Flutter's [DropdownButtonFormField].
///
/// This provides a more native look and feel across platforms and avoids
/// Flutter's multi-window dialog issues with dropdown overlays.
class NativeDropdownField<T> extends StatelessWidget {
  const NativeDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.decoration,
    this.itemLabel,
    this.valueLabel,
    this.disabled = false,
  });

  /// The currently selected value.
  final T? value;

  /// The list of selectable values.
  final List<T> items;

  /// Called when the user selects a value.
  final ValueChanged<T> onChanged;

  /// The decoration for the field (matching [InputDecoration] style).
  final InputDecoration? decoration;

  /// Optional builder for the display label of each item.
  /// If null, the item's [toString] is used.
  final String Function(T item)? itemLabel;

  /// Optional builder for the display label of the selected value.
  /// If null, falls back to [itemLabel] then [toString].
  final String Function(T item)? valueLabel;

  /// Whether the dropdown is disabled.
  final bool disabled;

  String _labelOf(T item) =>
      itemLabel?.call(item) ?? valueLabel?.call(item) ?? item.toString();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveDecoration = (decoration ?? const InputDecoration())
        .copyWith(
          suffixIcon: Icon(
            Icons.arrow_drop_down_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        );

    return InputDecorator(
      decoration: effectiveDecoration,
      child: GestureDetector(
        onTap: disabled ? null : () => _openMenu(context),
        child: Container(
          constraints: const BoxConstraints(minHeight: 28),
          alignment: Alignment.centerLeft,
          child: Text(
            value != null ? _labelOf(value as T) : '',
            style: textTheme.bodyMedium?.copyWith(
              color: disabled
                  ? colorScheme.onSurface.withValues(alpha: 0.38)
                  : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Position the menu below the dropdown field
    final offset = Offset(position.dx, position.dy + size.height);

    final window = nativeapi.WindowManager.instance.getCurrent();
    if (window == null) return;

    final menu = nativeapi.Menu();
    final menuItems = <nativeapi.MenuItem>[];
    final itemIds = <int, T>{};

    // Build native menu items
    for (final item in items) {
      final menuItem = nativeapi.MenuItem(_labelOf(item));
      menuItems.add(menuItem);
      itemIds[menuItem.id] = item;
      menuItem.on<nativeapi.MenuItemClickedEvent>((event) {
        final selected = itemIds[event.menuItemId];
        if (selected != null) {
          onChanged(selected);
        }
      });
      menu.addItem(menuItem);
    }

    // Listen for close event to clean up native resources
    late int closeListenerId;
    closeListenerId = menu.on<nativeapi.MenuClosedEvent>((_) {
      menu.off(closeListenerId);
      for (final mi in menuItems) {
        mi.dispose();
      }
      menu.dispose();
    });

    final opened = menu.open(
      nativeapi.PositioningStrategy.relativeToWindow(window, offset),
      nativeapi.Placement.bottomStart,
    );

    if (!opened) {
      // Menu failed to open, clean up immediately
      menu.off(closeListenerId);
      for (final mi in menuItems) {
        mi.dispose();
      }
      menu.dispose();
    }
  }
}
