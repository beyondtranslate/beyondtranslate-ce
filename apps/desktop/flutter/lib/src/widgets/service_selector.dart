import 'package:flutter/widgets.dart';

import 'ui.dart' show Badge, BadgeTone, OptionCard;

class ServiceSelector extends StatelessWidget {
  const ServiceSelector({
    super.key,
    required this.services,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ServiceOption> services;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < services.length; index++) ...[
          if (index > 0) const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final service = services[index];
              return OptionCard(
                selected: service.id == selectedId,
                onSelect: () => onSelected(service.id),
                title: Row(
                  children: [
                    Expanded(child: Text(service.name)),
                    if (service.tag != null)
                      Badge(tone: BadgeTone.accent, child: Text(service.tag!)),
                  ],
                ),
                description: Text(
                  service.preview,
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

class ServiceOption {
  const ServiceOption({
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
