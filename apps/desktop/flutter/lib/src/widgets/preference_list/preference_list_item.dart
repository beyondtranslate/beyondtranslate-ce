import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Input,
        Pressable,
        Radio,
        Switch;

class PreferenceListItem extends StatelessWidget {
  const PreferenceListItem({
    Key? key,
    this.padding,
    this.icon,
    this.title,
    this.summary,
    this.detailText,
    this.accessoryView,
    this.bottomView,
    this.disabled = false,
    this.onTap,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Widget? icon;
  final Widget? title;
  final Widget? summary;
  final Widget? detailText;
  final Widget? accessoryView;
  final Widget? bottomView;
  final bool disabled;
  final VoidCallback? onTap;

  _onTap() {
    onTap?.call();
  }

  bool get isInteractive => onTap != null;

  Widget buildDetailText(BuildContext context) {
    if (detailText == null) return const SizedBox.shrink();
    final tokens = context.tokens;
    return DefaultTextStyle(
      style: tokens.typography.sansStyle(
        fontSize: 12,
        height: 1,
        color: tokens.colors.fgTertiary,
      ),
      child: detailText!,
    );
  }

  Widget buildAccessoryView(BuildContext context) {
    if (accessoryView != null) {
      return accessoryView!;
    } else if (onTap != null) {
      return Icon(
        FluentIcons.chevron_right_20_regular,
        size: 16,
        color: context.colors.fgFaint,
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildBottomView(BuildContext context) {
    return bottomView ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final enabled = !disabled && isInteractive;

    // The deck's flat rows: plain-label rows read like its ShortcutRow
    // (secondary, regular), rows with a summary like its privacy toggles
    // (bold title over a subtle sub-line). No card, no hover wash.
    final titleStyle = summary == null
        ? tokens.typography.sansStyle(
            fontSize: 12,
            height: 1,
            color: colors.fgSecondary,
          )
        : tokens.typography.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: colors.fg,
          );

    return Pressable(
      enabled: enabled,
      onPressed: enabled ? _onTap : null,
      isButton: false,
      showFocusRing: false,
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconTheme(
                      data: IconThemeData(color: colors.accent, size: 17),
                      child: icon!,
                    ),
                  ),
                if (title != null || summary != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          DefaultTextStyle(style: titleStyle, child: title!),
                        if (summary != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: DefaultTextStyle(
                              style: tokens.typography.sansStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: colors.fgSubtle,
                              ),
                              child: summary!,
                            ),
                          ),
                      ],
                    ),
                  ),
                buildDetailText(context),
                const SizedBox(width: 10),
                buildAccessoryView(context),
              ],
            ),
          ),
          buildBottomView(context),
        ],
      ),
    );
  }
}

class PreferenceListRadioItem<T> extends PreferenceListItem {
  const PreferenceListRadioItem({
    Key? key,
    EdgeInsets? padding,
    Widget? icon,
    Widget? title,
    Widget? summary,
    Widget? detailText,
    Widget? accessoryView,
    VoidCallback? onTap,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(
          key: key,
          padding: padding,
          icon: icon,
          title: title,
          summary: summary,
          detailText: detailText,
          accessoryView: accessoryView,
          onTap: onTap,
        );
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  @override
  bool get isInteractive => true;

  @override
  void _onTap() {
    onChanged(value);
    super._onTap();
  }

  /// The deck's RadioGroup row: mark on the left, label after it — the whole
  /// row is the design system's [Radio], not a settings row with a trailing
  /// mark.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 5),
      child: Radio(
        checked: value == groupValue,
        onSelect: _onTap,
        child: title ?? const SizedBox.shrink(),
      ),
    );
  }
}

class PreferenceListSwitchItem extends PreferenceListItem {
  const PreferenceListSwitchItem({
    Key? key,
    Widget? icon,
    Widget? title,
    Widget? summary,
    Widget? detailText,
    Widget? accessoryView,
    bool disabled = false,
    VoidCallback? onTap,
    required this.value,
    required this.onChanged,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          summary: summary,
          detailText: detailText,
          accessoryView: accessoryView,
          disabled: disabled,
          onTap: onTap,
        );
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  bool get isInteractive => true;

  @override
  void _onTap() {
    if (onTap == null) {
      onChanged(!value);
    }
    super._onTap();
  }

  @override
  Widget buildAccessoryView(BuildContext context) {
    return Switch(
      checked: value,
      enabled: !disabled,
      onChanged: (next) => onTap == null ? onChanged(next) : _onTap(),
    );
  }
}

class PreferenceListTextFieldItem extends PreferenceListItem {
  const PreferenceListTextFieldItem({
    Key? key,
    Widget? icon,
    Widget? title,
    Widget? summary,
    Widget? accessoryView,
    VoidCallback? onTap,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          summary: summary,
          accessoryView: accessoryView,
          onTap: onTap,
        );
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  @override
  bool get disabled => true;

  @override
  Widget buildDetailText(BuildContext context) {
    return Expanded(
      child: Input(
        controller: controller,
        placeholder: placeholder,
        onChanged: onChanged,
        onSubmitted: (value) {
          onEditingComplete?.call();
          onSubmitted?.call(value);
        },
      ),
    );
  }
}
