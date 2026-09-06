import 'package:flutter/widgets.dart';

import '../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import 'ui.dart' show SectionLabel, ThemeDataBuildContextProps;

/// A numbered section heading — `01  质量信号`.
class NumberedSectionLabel extends StatelessWidget {
  const NumberedSectionLabel(
      {super.key, required this.index, required this.label});

  final String index;
  final String label;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Row(
      children: [
        Text(
          index,
          style: vars.numericStyle(
            fontSize: ProductTypography.caption,
            color: context.vars.accentText,
          ),
        ),
        const SizedBox(width: 8),
        SectionLabel(label),
      ],
    );
  }
}
