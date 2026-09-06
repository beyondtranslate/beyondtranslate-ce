import 'package:flutter/material.dart';

import '../../models/ext_translation_engine_config.dart';
import '../../models/translation_engine_config.dart';
import '../ui.dart' show ThemeDataBuildContextProps;

class TranslationEngineName extends StatelessWidget {
  const TranslationEngineName(this.translationEngineConfig, {super.key});

  final TranslationEngineConfig translationEngineConfig;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: translationEngineConfig.typeName,
        children: [
          TextSpan(
            text: ' (${translationEngineConfig.identifier})',
            style:
                TextStyle(fontSize: 12, color: context.vars.colorContentSubtle),
          ),
        ],
      ),
    );
  }
}
