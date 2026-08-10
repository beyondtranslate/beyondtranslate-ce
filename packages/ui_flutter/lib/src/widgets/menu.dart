import 'package:beyondtranslate_ui/src/theme/text_styles.dart';
import 'package:beyondtranslate_ui/src/theme/theme.dart';
import 'package:beyondtranslate_ui/src/widgets/kbd.dart';
import 'package:beyondtranslate_ui/src/widgets/pressable.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One row of a [Menu].
@immutable
class MenuItem {
  const MenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.checked,
    this.onSelect,
  });

  final String label;
  final Widget? icon;
  final String? shortcut;

  /// Radio-style check state. Pass a boolean (on every item of the menu, so
  /// the leading gutter stays aligned) to get the AppKit checkmark column.
  final bool? checked;
  final VoidCallback? onSelect;
}

enum MenuAlign { start, end }

/// An AppKit-style popover menu — the desktop app opens these as native menus
/// from its toolbars; the kit re-creates the panel. Closes on outside tap and
/// Escape, which keeps it keyboard- and pointer-friendly in the gallery.
class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.trigger,
    required this.items,
    this.align = MenuAlign.end,
  });

  /// Renders the trigger; receives the open state and a toggle callback.
  final Widget Function(BuildContext context, bool open, VoidCallback toggle)
      trigger;
  final List<MenuItem> items;
  final MenuAlign align;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final OverlayPortalController _controller = OverlayPortalController();
  final LayerLink _link = LayerLink();

  void _toggle() {
    setState(() {
      _controller.isShowing ? _controller.hide() : _controller.show();
    });
  }

  void _close() {
    if (!_controller.isShowing) return;
    setState(_controller.hide);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final end = widget.align == MenuAlign.end;

    return TapRegion(
      groupId: this,
      child: CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _controller,
          overlayChildBuilder: (context) => Align(
            alignment: Alignment.topLeft,
            child: CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: end ? Alignment.bottomRight : Alignment.bottomLeft,
              followerAnchor: end ? Alignment.topRight : Alignment.topLeft,
              offset: const Offset(0, 4),
              child: TapRegion(
                groupId: this,
                onTapOutside: (_) => _close(),
                // The theme is re-read here because the overlay child is built
                // under the app's overlay, not under this provider's subtree.
                child: DesignTheme(
                  tokens: tokens,
                  child: Focus(
                    autofocus: true,
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.escape) {
                        _close();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: _MenuPanel(
                      items: widget.items,
                      onSelected: (item) {
                        item.onSelect?.call();
                        _close();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: widget.trigger(context, _controller.isShowing, _toggle),
        ),
      ),
    );
  }
}

class _MenuPanel extends StatelessWidget {
  const _MenuPanel({required this.items, required this.onSelected});

  final List<MenuItem> items;
  final ValueChanged<MenuItem> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final rowRadius = BorderRadius.circular(tokens.radii.box);

    return Container(
      constraints: const BoxConstraints(minWidth: 176),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.window,
        border: Border.all(
          color: colors.hairlineStrong,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(tokens.radii.box),
        boxShadow: tokens.shadows.popover,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            Pressable(
              onPressed: () => onSelected(item),
              borderRadius: rowRadius,
              showFocusRing: false,
              checked: item.checked,
              builder: (context, state) => AnimatedContainer(
                duration: kTransitionDuration,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: state.hovered ? colors.subtle : null,
                  borderRadius: rowRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.checked != null) ...[
                      SizedBox(
                        width: 12,
                        child: item.checked!
                            ? IconTheme(
                                data: IconThemeData(color: colors.fg, size: 12),
                                child: const Icon(
                                  FluentIcons.checkmark_20_regular,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (item.icon != null) ...[
                      IconTheme(
                        data: IconThemeData(color: colors.fgTertiary, size: 14),
                        child: item.icon!,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        softWrap: false,
                        style: tokens.typography.sansStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color: colors.fg,
                        ),
                      ),
                    ),
                    if (item.shortcut != null) ...[
                      const SizedBox(width: 8),
                      Kbd(item.shortcut!, size: KbdSize.sm),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
