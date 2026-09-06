import 'package:flutter/widgets.dart';

import 'ui.dart' show OptionCard;

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
              // The kit's card prints its own title and description, so the
              // variant tag joins the name rather than riding as a chip.
              final tag = service.tag;
              return OptionCard(
                  selected: service.id == selectedId,
                  onPressed: () => onSelected(service.id),
                  title: tag == null ? service.name : '${service.name} · $tag',
                  description: service.preview);
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
