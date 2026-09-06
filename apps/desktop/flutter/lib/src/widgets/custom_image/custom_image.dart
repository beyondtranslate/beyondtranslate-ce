import 'package:flutter/material.dart';

import '../../theme/product_tokens.dart' show ProductPalette;
import '../ui.dart' show Spinner, ThemeDataBuildContextProps, WidgetSize;

class CustomImage extends StatelessWidget {
  const CustomImage(this.url, {super.key, this.width, this.height, this.fit});

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        return progress == null
            ? child
            : const Center(child: Spinner(size: WidgetSize.small));
      },
      errorBuilder: (ctx, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: context.vars.dangerSurface,
        );
      },
    );
  }
}
