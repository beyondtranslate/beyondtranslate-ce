import 'package:flutter/widgets.dart';

import 'list_card.dart' show ListCard;

class HistoryRow extends StatelessWidget {
  const HistoryRow({
    super.key,
    required this.term,
    required this.translation,
    required this.timestamp,
    this.onTap,
  });

  final String term;
  final String translation;
  final String timestamp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListCard(
      eyebrow: Text(term),
      meta: Text(timestamp),
      primary: const SizedBox.shrink(),
      secondary: Text(
        translation,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: onTap,
    );
  }
}
