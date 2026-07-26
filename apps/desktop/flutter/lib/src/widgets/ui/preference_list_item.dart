import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'themes/design_theme.dart';

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
    if (detailText != null) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: context.design.text.withValues(alpha: 0.60),
              fontSize: 12.5,
            ),
        child: detailText!,
      );
    } else {
      return Container();
    }
  }

  Widget buildAccessoryView(BuildContext context) {
    if (accessoryView != null) {
      return accessoryView!;
    } else if (onTap != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Icon(
          FluentIcons.chevron_right_20_regular,
          size: 18,
          color: Theme.of(context).textTheme.bodySmall!.color,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildBottomView(BuildContext context) {
    return bottomView ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: colors.accent.withValues(alpha: 0.08),
        highlightColor: colors.accent.withValues(alpha: 0.12),
        onTap: disabled || !isInteractive ? null : _onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: summary == null ? 24 : 38,
              ),
              padding: padding ?? EdgeInsets.zero,
              child: Row(
                children: [
                  if (icon != null)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: IconTheme(
                        data: IconThemeData(color: colors.accent, size: 18),
                        child: icon!,
                      ),
                    ),
                  if (title != null || summary != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (title != null)
                            DefaultTextStyle(
                              style: textTheme.bodyMedium!.copyWith(
                                color: colors.text,
                                fontSize: 13,
                              ),
                              child: title!,
                            ),
                          if (summary != null)
                            DefaultTextStyle(
                              style: textTheme.bodySmall!.copyWith(
                                color: colors.quietText,
                                fontSize: 11.5,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: summary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  buildDetailText(context),
                  buildAccessoryView(context),
                ],
              ),
            ),
            buildBottomView(context),
          ],
        ),
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

  @override
  Widget buildAccessoryView(BuildContext context) {
    final selected = value != null && value == groupValue;
    final colors = context.design;
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.accent : colors.text.withValues(alpha: 0.28),
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
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
    final colors = context.design;
    final trackColor = disabled
        ? colors.text.withValues(alpha: 0.10)
        : value
            ? colors.accent
            : Colors.transparent;
    final borderColor = disabled
        ? colors.text.withValues(alpha: 0.16)
        : value
            ? colors.accent
            : colors.text.withValues(alpha: 0.28);
    final knobColor = disabled
        ? colors.text.withValues(alpha: 0.24)
        : value
            ? colors.paper
            : colors.text.withValues(alpha: 0.40);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 38,
      height: 18,
      decoration: BoxDecoration(
        color: trackColor,
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 160),
            curve: const Cubic(0.32, 0.72, 0, 1),
            top: 2,
            left: value ? 22 : 2,
            child: Container(width: 12, height: 12, color: knobColor),
          ),
        ],
      ),
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
    TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
            height: 1.2,
          ),
        ),
        style: textTheme.bodyMedium?.copyWith(
          height: 1.2,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
