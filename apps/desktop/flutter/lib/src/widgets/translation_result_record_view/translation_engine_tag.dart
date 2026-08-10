import 'package:flutter/material.dart';

import '../../models/ext_translation_engine_config.dart';
import '../../models/translation_result_record.dart';
import '../../services/runtime.dart';
import '../provider_icon/provider_icon.dart';
import '../ui.dart' show Button, ButtonVariant;

class TranslationEngineTag extends StatefulWidget {
  const TranslationEngineTag({Key? key, required this.translationResultRecord})
      : super(key: key);

  final TranslationResultRecord translationResultRecord;

  @override
  State<TranslationEngineTag> createState() => _TranslationEngineTagState();
}

class _TranslationEngineTagState extends State<TranslationEngineTag> {
  bool _isHovered = false;
  ProviderConfigEntry? _providerConfigEntry;
  ServiceConfigEntry? _serviceConfigEntry;

  String? get _translationServiceId {
    return widget.translationResultRecord.translationServiceId;
  }

  String get _translationEngineType {
    final type = _providerConfigEntry?.type;
    if (type != null) {
      return _providerTypeValue(type);
    }
    return _translationServiceId ?? '';
  }

  String get _translationEngineName {
    final providerType = _providerConfigEntry?.type;
    if (providerType != null) {
      final serviceName = _serviceConfigEntry?.name;
      if (serviceName != null && serviceName.isNotEmpty) {
        return serviceName;
      }
      return getTranslationEngineTypeName(_providerTypeValue(providerType));
    }
    return _translationServiceId ?? '';
  }

  static String _providerTypeValue(ProviderType type) {
    switch (type) {
      case ProviderType.anthropic:
        return 'anthropic';
      case ProviderType.baidu:
        return 'baidu';
      case ProviderType.caiyun:
        return 'caiyun';
      case ProviderType.deepL:
        return 'deepl';
      case ProviderType.google:
        return 'google';
      case ProviderType.openAi:
        return 'openai';
      case ProviderType.ollama:
        return 'ollama';
      case ProviderType.xAi:
        return 'xai';
      case ProviderType.deepSeek:
        return 'deepseek';
      case ProviderType.qwen:
        return 'qwen';
      case ProviderType.zhipu:
        return 'zhipu';
      case ProviderType.moonshot:
        return 'moonshot';
      case ProviderType.doubao:
        return 'doubao';
      case ProviderType.groq:
        return 'groq';
      case ProviderType.gemini:
        return 'gemini';
      case ProviderType.openAiCompatible:
        return 'openai_compatible';
      case ProviderType.system:
        return 'system';
      case ProviderType.tencent:
        return 'tencent';
      case ProviderType.youdao:
        return 'youdao';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProviderConfigEntry();
  }

  @override
  void didUpdateWidget(covariant TranslationEngineTag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationResultRecord.translationServiceId !=
        widget.translationResultRecord.translationServiceId) {
      _providerConfigEntry = null;
      _serviceConfigEntry = null;
      _loadProviderConfigEntry();
    }
  }

  void _loadProviderConfigEntry() async {
    final translationServiceId = _translationServiceId;
    if (translationServiceId == null) {
      return;
    }

    try {
      final serviceConfigEntry = await runtime.settings().getService(
            serviceId: translationServiceId,
          );
      final providerConfigEntry = serviceConfigEntry == null
          ? await runtime.settings().getProvider(
                providerId: translationServiceId,
              )
          : await runtime.settings().getProvider(
                providerId: serviceConfigEntry.providerId,
              );
      if (!mounted || translationServiceId != _translationServiceId) {
        return;
      }
      setState(() {
        _serviceConfigEntry = serviceConfigEntry;
        _providerConfigEntry = providerConfigEntry;
      });
    } catch (error) {
      // Keep rendering the provider id when runtime metadata is unavailable.
    }
  }

  Widget _buildIcon(String type) => ProviderIcon(type, size: 12);

  @override
  Widget build(BuildContext context) {
    final translationEngineType = _translationEngineType;
    final translationEngineName = _translationEngineName;

    return MouseRegion(
      onEnter: (event) {
        _isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        _isHovered = false;
        setState(() {});
      },
      child: Container(
        height: 40,
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 4, right: 2),
          child: Button(
            variant: ButtonVariant.quiet,
            onPressed: () {},
            child: AnimatedCrossFade(
              crossFadeState: !_isHovered
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.ease,
              secondCurve: Curves.ease,
              sizeCurve: Curves.ease,
              firstChild: Row(children: [_buildIcon(translationEngineType)]),
              secondChild: Row(
                children: [
                  _buildIcon(translationEngineType),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 2),
                    child: Text(
                      translationEngineName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
