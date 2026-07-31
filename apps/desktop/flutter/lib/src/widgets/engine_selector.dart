import 'package:flutter/widgets.dart';

import 'ui.dart' show Badge, BadgeTone, OptionCard;

class EngineSelector extends StatelessWidget {
  const EngineSelector({
    super.key,
    required this.engines,
    required this.selectedId,
    required this.onSelected,
  });

  final List<EngineOption> engines;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < engines.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final engine = engines[index];
              return OptionCard(
                selected: engine.id == selectedId,
                onSelect: () => onSelected(engine.id),
                title: Row(
                  children: [
                    Expanded(child: Text(engine.name)),
                    if (engine.tag != null)
                      Badge(
                        tone: BadgeTone.accent,
                        child: Text(engine.tag!),
                      ),
                  ],
                ),
                description: Text(
                  engine.preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class EngineOption {
  const EngineOption({
    required this.id,
    required this.name,
    required this.preview,
    this.tag,
  });

  final String id;
  final String name;
  final String preview;
  final String? tag;
}
