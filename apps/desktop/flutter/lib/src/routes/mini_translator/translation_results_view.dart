import 'package:flutter/material.dart';

import '../../models/translation_result.dart';
import '../../utils/language_util.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/themes/design_theme.dart';

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
    final design = context.design;
    return SizedBox(
      height: 22,
      child: Button(
        borderRadius: BorderRadius.zero,
        minSize: 0,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        onPressed: onToggleCompare,
        child: Text(
          '${showCompare ? '收起' : '对比'} $engineCount 个引擎',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: design.accent,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCompareEngines(
      BuildContext context, List<TranslationResult> results) {
    final design = context.design;
    final widgets = <Widget>[];

    widgets.add(const SizedBox(height: 8));
    widgets.add(
      Container(
        height: 1,
        color: design.border,
      ),
    );

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
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: design.paper,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: design.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    engineLabel,
                    style: TextStyle(
                      fontFamily: 'Barlow Condensed',
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      letterSpacing: 0.12,
                      color: design.mutedText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '精准',
                    style: TextStyle(
                      fontFamily: 'Barlow Condensed',
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      letterSpacing: 0.1,
                      color: design.quietText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              SelectableText(
                altText,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.7,
                  color: design.text.withValues(alpha: 0.72),
                  fontFamily: 'Noto Sans SC',
                ),
              ),
            ],
          ),
        ),
      );
    }

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          '点选任一条即设为主译文 · ⌥1/2/3 直接切换',
          style: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontWeight: FontWeight.w600,
            fontSize: 10,
            letterSpacing: 0.12,
            color: design.quietText,
          ),
        ),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = context.design;
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

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: design.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Translation header
          Row(
            children: [
              Text(
                '译文 · $engineLabel',
                style: TextStyle(
                  fontFamily: 'Barlow Condensed',
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 0.14,
                  color: design.accent,
                ),
              ),
              const Spacer(),
              if (engineCount > 1)
                _buildCompareToggle(context, engineCount),
            ],
          ),
          const SizedBox(height: 6),
          // Translation text
          SelectableText(
            primaryText,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.8,
              fontFamily: 'Noto Sans SC',
              color: design.text,
            ),
          ),
          // Comparison engines (collapsible)
          if (showCompare && results.length > 1)
            ..._buildCompareEngines(context, results),
        ],
      ),
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
    final theme = Theme.of(context);
    final design = context.design;
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
          if (lookup.definitions != null &&
              lookup.definitions!.isNotEmpty) {
            final firstDef = lookup.definitions!.first;
            if (firstDef.values != null && firstDef.values!.isNotEmpty) {
              definition ??= firstDef.values!.first;
            }
          }
        }
      }
    }

    if (word == null && definition == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: design.panel,
        border: Border(
          top: BorderSide(color: design.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (word != null)
            Row(
              children: [
                Text(
                  word,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: design.text,
                  ),
                ),
                if (phonetic != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    phonetic,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: design.mutedText,
                      fontFamily: 'Barlow',
                    ),
                  ),
                ],
              ],
            ),
          if (word != null && definition != null)
            const SizedBox(height: 4),
          if (definition != null)
            Text(
              definition,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.7,
                color: design.text.withValues(alpha: 0.7),
                fontFamily: 'Noto Sans SC',
              ),
            ),
        ],
      ),
    );
  }
}
