import 'package:flutter/widgets.dart';

import 'blocks.dart' show Mark;
import 'ui.dart' show Callout, CalloutTone;

/// A term the glossary matched, shown as an accent aside beside the text.
class GlossaryHit extends StatelessWidget {
  const GlossaryHit({
    super.key,
    required this.source,
    required this.target,
    this.collection,
  });

  final String source;
  final String target;
  final String? collection;

  @override
  Widget build(BuildContext context) {
    return Callout(
      tone: CalloutTone.accent,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Mark(text: source),
          const Text('→'),
          Text(target),
          if (collection != null) Text('· $collection'),
        ],
      ),
    );
  }
}
