import 'package:flutter/material.dart';

import 'themes/design_theme.dart';

class PreferenceListSection extends StatelessWidget {
  const PreferenceListSection({
    Key? key,
    this.leading,
    this.title,
    this.description,
    required this.children,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;
  final Widget? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.design;
    final textTheme = Theme.of(context).textTheme;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: 11),
          children[index],
        ],
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          DefaultTextStyle(
            style: context.eyebrowTextStyle.copyWith(
              color: colors.quietText,
              fontSize: 10,
            ),
            child: title!,
          ),
          const SizedBox(height: 11),
        ],
        if (leading == null)
          content
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading!,
              const SizedBox(width: 11),
              Expanded(child: content),
            ],
          ),
        if (description != null) ...[
          const SizedBox(height: 7),
          DefaultTextStyle(
            style: textTheme.bodySmall!.copyWith(
              color: colors.quietText,
              fontSize: 11.5,
              height: 1.55,
            ),
            child: description!,
          ),
        ],
      ],
    );
  }
}
