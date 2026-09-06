import 'package:flutter/widgets.dart';

import 'swap_pair.dart' show SwapPair;
import 'ui.dart' show Badge, BadgeTint, WidgetSize;

/// The language capsule that anchors a translation view, with a badge naming
/// how the source was chosen.
class LanguagePair extends StatelessWidget {
  const LanguagePair({
    super.key,
    required this.source,
    required this.target,
    this.onSwap,
    this.note = '自动检测',
  });

  final String source;
  final String target;
  final VoidCallback? onSwap;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Badge(
            tint: BadgeTint.primary, size: WidgetSize.tiny, child: Text(note)),
        const SizedBox(width: 12),
        SwapPair(start: source, end: target, onSwap: onSwap),
      ],
    );
  }
}
