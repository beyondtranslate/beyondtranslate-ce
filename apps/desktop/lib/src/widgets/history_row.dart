import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

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
    final colors = context.design;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UiSpace.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    term,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    translation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              timestamp,
              style: TextStyle(fontSize: 11, color: colors.quietText),
            ),
          ],
        ),
      ),
    );
  }
}
