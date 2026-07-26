import 'package:flutter/material.dart';

import 'ui/themes/design_theme.dart';

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
    final colors = context.design;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: engines.map((engine) {
        final selected = engine.id == selectedId;
        return InkWell(
          onTap: () => onSelected(engine.id),
          child: Container(
            padding: const EdgeInsets.all(UiSpace.sm),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.border)),
              color: selected ? colors.accent.withValues(alpha: 0.12) : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        engine.name,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        engine.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.quietText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (engine.tag != null)
                  Text(
                    engine.tag!,
                    style: context.eyebrowTextStyle.copyWith(fontSize: 9),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
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
