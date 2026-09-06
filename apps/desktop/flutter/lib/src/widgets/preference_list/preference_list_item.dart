import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart' hide RadioGroup;

import '../../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import '../ui.dart'
    show Pressable, Radio, Switch, TextField, ThemeDataBuildContextProps;

class PreferenceListItem extends StatelessWidget {
  const PreferenceListItem({
    super.key,
    this.padding,
    this.icon,
    this.title,
    this.summary,
    this.detailText,
    this.accessoryView,
    this.bottomView,
    this.disabled = false,
    this.onTap,
  });

  final EdgeInsets? padding;
  final Widget? icon;
  final Widget? title;
  final Widget? summary;
  final Widget? detailText;
  final Widget? accessoryView;
  final Widget? bottomView;
  final bool disabled;
  final VoidCallback? onTap;

  void _onTap() {
    onTap?.call();
  }

  bool get isInteractive => onTap != null;

  Widget buildDetailText(BuildContext context) {
    if (detailText == null) return const SizedBox.shrink();
    final vars = context.vars;
    return DefaultTextStyle(
      style: vars.sansStyle(
        fontSize: 12,
        height: 1,
        color: vars.colorContentMuted,
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
        color: context.vars.colorContentFaint,
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildBottomView(BuildContext context) {
    return bottomView ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final enabled = !disabled && isInteractive;

    // The deck's flat rows: plain-label rows read like its ShortcutRow
    // (secondary, regular), rows with a summary like its privacy toggles
    // (bold title over a subtle sub-line). No card, no hover wash.
    final titleStyle = summary == null
        ? vars.sansStyle(
            fontSize: 12,
            height: 1,
            color: vars.colorContentSecondary,
          )
        : vars.sansStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1,
            color: vars.colorContent,
          );

    return Pressable(
      enabled: enabled,
      onPressed: enabled ? _onTap : null,
      isButton: false,
      showFocusRing: false,
      builder: (context, states) => Column(
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
                      data: IconThemeData(color: vars.accent, size: 17),
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
                              style: vars.sansStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: vars.colorContentSubtle,
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
    super.key,
    super.padding,
    super.icon,
    super.title,
    super.summary,
    super.detailText,
    super.accessoryView,
    super.onTap,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
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
      child: Radio<Object?>(
          value: value,
          groupValue: groupValue,
          onChanged: (_) => _onTap(),
          label: title ?? const SizedBox.shrink()),
    );
  }
}

class PreferenceListSwitchItem extends PreferenceListItem {
  const PreferenceListSwitchItem({
    super.key,
    super.icon,
    super.title,
    super.summary,
    super.detailText,
    super.accessoryView,
    super.disabled,
    super.onTap,
    required this.value,
    required this.onChanged,
  });
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
        value: value,
        onChanged: !disabled
            ? (next) => onTap == null ? onChanged(next) : _onTap()
            : null);
  }
}

class PreferenceListTextFieldItem extends PreferenceListItem {
  const PreferenceListTextFieldItem({
    super.key,
    super.icon,
    super.title,
    super.summary,
    super.accessoryView,
    super.onTap,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  });
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
      child: TextField(
          controller: controller,
          placeholder: placeholder,
          onChanged: onChanged,
          onSubmitted: (value) {
            onEditingComplete?.call();
            onSubmitted?.call(value);
          }),
    );
  }
}
