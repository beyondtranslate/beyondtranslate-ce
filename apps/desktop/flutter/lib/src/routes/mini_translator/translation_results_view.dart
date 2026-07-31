import 'package:flutter/material.dart';

import '../../models/translation_result.dart';
import '../../utils/language_util.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        DetailBlock,
        HighlightBlock,
        Label,
        LabelTone,
        Surface,
        SurfacePadding,
        SurfaceRadius,
        SurfaceTone;

class MiniTranslatorTranslation extends StatelessWidget {
  const MiniTranslatorTranslation({
    Key? key,
    required this.querySubmitted,
    required this.translationResultList,
    required this.showCompare,
    required this.onToggleCompare,
  }) : super(key: key);

  final bool querySubmitted;
  final List<TranslationResult> translationResultList;
  final bool showCompare;
  final VoidCallback onToggleCompare;

  Widget _buildCompareToggle(BuildContext context, int engineCount) {
    return Button(
      variant: ButtonVariant.quiet,
      size: ButtonSize.xs,
      onPressed: onToggleCompare,
      child: Text('${showCompare ? '收起' : '对比'} $engineCount 个引擎'),
    );
  }

  List<Widget> _buildCompareEngines(
    BuildContext context,
    List<TranslationResult> results,
  ) {
    final widgets = <Widget>[];

    for (int i = 1; i < results.length; i++) {
      final result = results[i];
      final records = result.translationResultRecordList ?? [];
      final engineLabel = getLanguageName(
        result.translationTarget?.target ?? '',
      );

      String altText = '';
      for (final record in records) {
        if (record.translateResponse != null &&
            record.translateResponse!.translations.isNotEmpty) {
          altText = record.translateResponse!.translations.first.text;
          break;
        }
      }

      widgets.add(const SizedBox(height: 6));
      widgets.add(
        Surface(
          tone: SurfaceTone.subtle,
          radius: SurfaceRadius.box,
          padding: SurfacePadding.xs,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Label(child: Text('$engineLabel · 精准')),
              const SizedBox(height: 5),
              SelectableText(altText),
            ],
          ),
        ),
      );
    }

    widgets.add(const SizedBox(height: 8));
    widgets.add(
      const Label(
        tone: LabelTone.faint,
        child: Text('点选任一条即设为主译文 · ⌥1/2/3 直接切换'),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final results = translationResultList;

    if (!querySubmitted || results.isEmpty) {
      return const SizedBox.shrink();
    }

    // Primary result (first engine)
    final primaryResult = results.first;
    final primaryRecords = primaryResult.translationResultRecordList ?? [];
    final engineName = primaryResult.translationTarget?.target ?? '';
    final engineLabel = getLanguageName(engineName);

    // Get translation text from primary result
    String primaryText = '';
    for (final record in primaryRecords) {
      if (record.translateResponse != null &&
          record.translateResponse!.translations.isNotEmpty) {
        primaryText = record.translateResponse!.translations.first.text;
        break;
      }
    }

    // Count engines with results
    int engineCount = 0;
    for (final result in results) {
      final records = result.translationResultRecordList ?? [];
      for (final record in records) {
        if (record.translateResponse != null) engineCount++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightBlock(
          label: Text('译文 · $engineLabel'),
          meta: engineCount > 1
              ? _buildCompareToggle(context, engineCount)
              : null,
          child: SelectableText(primaryText),
        ),
        if (showCompare && results.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildCompareEngines(context, results),
            ),
          ),
      ],
    );
  }
}

class MiniTranslatorWordDefinition extends StatelessWidget {
  const MiniTranslatorWordDefinition({
    Key? key,
    required this.translationResultList,
  }) : super(key: key);

  final List<TranslationResult> translationResultList;

  @override
  Widget build(BuildContext context) {
    final results = translationResultList;

    if (results.isEmpty) return const SizedBox.shrink();

    // Look for a lookup result with definitions
    String? word;
    String? phonetic;
    String? definition;

    for (final result in results) {
      final records = result.translationResultRecordList ?? [];
      for (final record in records) {
        if (record.lookUpResponse != null) {
          final lookup = record.lookUpResponse!;
          word ??= lookup.word;
          if (lookup.pronunciations != null &&
              lookup.pronunciations!.isNotEmpty) {
            phonetic ??= lookup.pronunciations!.first.phoneticSymbol;
          }
          if (lookup.definitions != null && lookup.definitions!.isNotEmpty) {
            final firstDef = lookup.definitions!.first;
            if (firstDef.values != null && firstDef.values!.isNotEmpty) {
              definition ??= firstDef.values!.first;
            }
          }
        }
      }
    }

    if (word == null && definition == null) return const SizedBox.shrink();

    return DetailBlock(
      title: Text(word ?? ''),
      subtitle: phonetic == null ? null : Text(phonetic),
      child: Text(definition ?? ''),
    );
  }
}
