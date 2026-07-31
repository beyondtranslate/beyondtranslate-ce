import 'package:flutter/widgets.dart';

import '../ui.dart'
    show
        DesignThemeContext,
        DesignTypographyStyles,
        Divider,
        DividerTone,
        Label,
        Surface,
        SurfaceRadius,
        SurfacePadding;

/// A titled group of preference rows, drawn as one bordered card with hairline
/// separators — the shape macOS System Settings gives a settings group.
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
    final tokens = context.tokens;

    final card = Surface(
      radius: SurfaceRadius.box,
      padding: SurfacePadding.none,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const Divider(tone: DividerTone.soft),
            children[index],
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Label(child: title!),
          const SizedBox(height: 8),
        ],
        if (leading == null)
          card
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading!,
              const SizedBox(width: 12),
              Expanded(child: card),
            ],
          ),
        if (description != null) ...[
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1.6,
              color: tokens.colors.fgSubtle,
            ),
            child: description!,
          ),
        ],
      ],
    );
  }
}
