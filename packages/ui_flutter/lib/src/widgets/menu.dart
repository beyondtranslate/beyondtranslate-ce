import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/widget_tint.dart';
import '../generated/theme_variables.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// Which edge of the trigger the panel is aligned to.
enum MenuAlign { start, end }

/// The tint a [Menu] resolves against.
enum MenuTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

/// One row of a menu.
@immutable
class MenuItem {
  const MenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.checked,
    this.enabled = true,
    this.onSelect,
  });

  final String label;

  final IconData? icon;

  /// A faint hint in the display cut — never a boxed key cap; a cap in a menu
  /// row would be furniture.
  final String? shortcut;

  /// Radio-style check state. Set it on every item of a group, including the
  /// unchecked ones, so the leading column stays aligned.
  final bool? checked;

  final bool enabled;

  final VoidCallback? onSelect;
}

/// What the trigger builder is handed.
@immutable
class MenuTriggerState {
  const MenuTriggerState({required this.open, required this.toggle});

  final bool open;
  final VoidCallback toggle;
}

/// A popover menu.
///
/// It closes on an outside pointer press and on Escape, so it stays operable
/// from the keyboard as well as the mouse.
class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.trigger,
    required this.items,
    this.align = MenuAlign.end,
  });

  /// Renders the trigger; receives the open state and a toggle handler.
  final Widget Function(BuildContext context, MenuTriggerState state) trigger;

  final List<MenuItem> items;

  final MenuAlign align;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final OverlayPortalController _controller = OverlayPortalController();
  final LayerLink _link = LayerLink();
  bool _open = false;

  void _toggle() => _open ? _close() : _openMenu();

  void _openMenu() {
    setState(() => _open = true);
    _controller.show();
  }

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (context) => _MenuOverlay(
          link: _link,
          align: widget.align,
          items: widget.items,
          onDismiss: _close,
          gap: vars.spacing1,
        ),
        child: widget.trigger(
          context,
          MenuTriggerState(open: _open, toggle: _toggle),
        ),
      ),
    );
  }
}

class _MenuOverlay extends StatelessWidget {
  const _MenuOverlay({
    required this.link,
    required this.align,
    required this.items,
    required this.onDismiss,
    required this.gap,
  });

  final LayerLink link;
  final MenuAlign align;
  final List<MenuItem> items;
  final VoidCallback onDismiss;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final Alignment target = align == MenuAlign.end
        ? Alignment.bottomRight
        : Alignment.bottomLeft;
    final Alignment follower = align == MenuAlign.end
        ? Alignment.topRight
        : Alignment.topLeft;

    return Stack(
      children: [
        // An outside press dismisses; the sheet below swallows its own.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: link,
          targetAnchor: target,
          followerAnchor: follower,
          offset: Offset(0, gap),
          child: Align(
            alignment: follower,
            child: Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
              },
              child: Actions(
                actions: {
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (_) {
                      onDismiss();
                      return null;
                    },
                  ),
                },
                child: FocusScope(
                  autofocus: true,
                  child: MenuPanel(
                    children: [
                      for (final MenuItem item in items)
                        MenuRow(
                          item: item,
                          onSelect: () {
                            item.onSelect?.call();
                            onDismiss();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The floating panel a menu's rows sit in.
class MenuPanel extends StatelessWidget {
  const MenuPanel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: vars.menuMinWidth),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(vars.spacing1),
        decoration: BoxDecoration(
          color: vars.colorSurface,
          border: Border.all(
            color: vars.colorBorderStrong,
            width: context.hairlineWidth,
          ),
          borderRadius: BorderRadius.circular(vars.radiusLarge),
          boxShadow: vars.shadowLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// One drawn menu row.
///
/// The quiet label on a row `menu.item-padding` deep — the odd 7px that
/// squares a 12px label onto the design's menu-row height. The row's corner is
/// the panel's minus the panel's own padding, so the hover wash stays
/// concentric with the panel edge.
class MenuRow extends StatelessWidget {
  const MenuRow({super.key, required this.item, this.onSelect});

  final MenuItem item;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final ThemeVariables vars = Theme.of(context).vars;
    final bool enabled =
        item.enabled && (item.onSelect != null || onSelect != null);
    final BorderRadius radius = BorderRadius.circular(
      vars.radiusLarge - vars.spacing1,
    );

    return Pressable(
      onPressed: enabled ? onSelect : null,
      enabled: enabled,
      checked: item.checked,
      borderRadius: radius,
      showFocusRing: false,
      builder: (context, states) {
        // The `normal` recipe, not `plain`. Both have no resting fill, but
        // `plain` is the quiet *accent* control — its wash comes off the
        // tinted ramp, which on a row would land heavier than a tinted
        // selection sitting one step lower. A row's wash is neutral, and it
        // holds while pressed: a menu item has no pressed look of its own.
        final bool washed =
            enabled &&
            (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.pressed));
        final Color content = enabled
            ? vars.colorContent
            : vars.controlColorNormalContent.disabledColor!;

        return AnimatedContainer(
          duration: vars.motionDuration,
          curve: vars.motionEasing,
          padding: EdgeInsets.symmetric(
            vertical: vars.menuItemPadding,
            horizontal: vars.spacing2,
          ),
          decoration: BoxDecoration(
            color: washed ? vars.colorSurfaceSubtle : null,
            borderRadius: radius,
          ),
          child: Row(
            spacing: vars.spacing2,
            children: [
              // The column holds its width whether or not the row is checked,
              // so the labels of a radio group stay on one left edge.
              if (item.checked != null)
                SizedBox(
                  width: vars.spacing3,
                  child: Opacity(
                    opacity: item.checked! ? 1 : 0,
                    child: Icon(
                      _kCheck,
                      size: vars.labelSmall.fontSize,
                      color: content,
                    ),
                  ),
                ),
              if (item.icon != null)
                Icon(
                  item.icon,
                  size: vars.spacing35,
                  color: enabled ? vars.colorContentMuted : content,
                ),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: vars.labelQuiet.copyWith(height: 1, color: content),
                ),
              ),
              if (item.shortcut != null)
                Text(
                  item.shortcut!,
                  style: vars.labelStrong.copyWith(
                    fontSize: vars.labelSmall.fontSize,
                    fontWeight: vars.labelSmall.fontWeight,
                    height: 1,
                    color: vars.colorContentFaint,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The check glyph, from the icon library the package already ships.
const IconData _kCheck = IconData(0xe5ca, fontFamily: 'MaterialIcons');
