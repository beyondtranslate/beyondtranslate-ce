import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../utils/language_util.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles,
        DetailBlock,
        Kbd,
        KbdSize,
        Label,
        LabelTone,
        Pressable,
        Spinner,
        SpinnerSize,
        kTransitionDuration;

/// One engine's translated text, paired with the target it belongs to.
typedef EngineTranslation = ({
  TranslationResult result,
  TranslationResultRecord record,
  String text,
});

/// Every engine translation with text, in engine order — the first target's
/// records first, then any additional configured targets.
List<EngineTranslation> engineTranslations(
  List<TranslationResult> results,
) {
  final translations = <EngineTranslation>[];
  for (final result in results) {
    for (final record in result.translationResultRecordList ??
        const <TranslationResultRecord>[]) {
      final texts = record.translateResponse?.translations ?? [];
      if (texts.isEmpty || texts.first.text.isEmpty) continue;
      translations.add(
        (result: result, record: record, text: texts.first.text),
      );
    }
  }
  return translations;
}

/// The translation the preferred block shows: the engine the user promoted
/// (⌥n / 设为首选) when it has text, else the first engine that answered.
EngineTranslation? preferredTranslation(
  List<TranslationResult> results,
  String? preferredEngineId,
) {
  final translations = engineTranslations(results);
  if (translations.isEmpty) return null;
  for (final translation in translations) {
    if (translation.record.translationEngineId == preferredEngineId) {
      return translation;
    }
  }
  return translations.first;
}

/// The preferred block plus the on-demand engine comparison, mirroring the
/// deck's MiniTranslator: one preferred translation as the visual protagonist,
/// its engine attribution below, candidates behind a 对比 N 个引擎 toggle.
class MiniTranslatorTranslation extends StatelessWidget {
  const MiniTranslatorTranslation({
    Key? key,
    required this.querySubmitted,
    required this.translationResultList,
    required this.translationServiceIds,
    required this.engineNameById,
    required this.preferredEngineId,
    required this.stale,
    required this.showCompare,
    required this.onToggleCompare,
    required this.onPreferEngine,
    required this.onRequery,
  }) : super(key: key);

  final bool querySubmitted;
  final List<TranslationResult> translationResultList;

  /// Service ids of type translation — lookup-only records must not keep the
  /// block in the translating phase.
  final Set<String> translationServiceIds;
  final Map<String, String> engineNameById;
  final String? preferredEngineId;

  /// The source was edited after this result came back — offer ⏎ 重新翻译.
  final bool stale;
  final bool showCompare;
  final VoidCallback onToggleCompare;
  final ValueChanged<String> onPreferEngine;
  final VoidCallback onRequery;

  String _engineName(String? engineId) =>
      engineNameById[engineId] ?? engineId ?? '';

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final results = translationResultList;

    if (!querySubmitted || results.isEmpty) {
      return const SizedBox.shrink();
    }

    final translations = engineTranslations(results);
    final preferred = preferredTranslation(results, preferredEngineId);

    // Translation records that errored / are still in flight, ignoring
    // dictionary lookups.
    var pendingCount = 0;
    var failedCount = 0;
    for (final result in results) {
      for (final record in result.translationResultRecordList ??
          const <TranslationResultRecord>[]) {
        if (!translationServiceIds.contains(record.translationEngineId)) {
          continue;
        }
        if (record.translateError != null) {
          failedCount++;
        } else {
          final texts = record.translateResponse?.translations ?? [];
          if (texts.isEmpty || texts.first.text.isEmpty) {
            pendingCount++;
          }
        }
      }
    }

    final noResult =
        translations.isEmpty && pendingCount == 0 && failedCount > 0;
    final translating = translations.isEmpty && !noResult;

    final candidates = [
      for (final translation in translations)
        if (translation.record != preferred?.record) translation,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 首选译文块 — the one accent surface on screen, fenced by the
        // highlight rule; the translation itself is the protagonist.
        Container(
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
          decoration: BoxDecoration(
            color: colors.accentSurface,
            border: Border(
              top: BorderSide(
                color: colors.accentBorder,
                width: tokens.highlightRule,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (noResult) ...[
                Callout(
                  tone: CalloutTone.danger,
                  action: Button(
                    variant: ButtonVariant.primary,
                    size: ButtonSize.sm,
                    onPressed: onRequery,
                    child: Text(t.mini_translator.result.retry),
                  ),
                  child: Text(t.mini_translator.result.no_result),
                ),
                const SizedBox(height: 10),
                Text(
                  t.mini_translator.result.no_result_note,
                  style: tokens.typography.sansStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: colors.fgSubtle,
                  ),
                ),
              ] else if (translating) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Spinner(size: SpinnerSize.sm),
                      const SizedBox(width: 10),
                      Text(
                        t.mini_translator.result.translating,
                        style: tokens.typography.sansStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1,
                          color: colors.accentText,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SelectableText(
                  preferred!.text,
                  style: tokens.typography.cjkStyle(
                    fontSize: 15,
                    height: 1.9,
                    color: colors.fg,
                  ),
                ),
                if (stale) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Button(
                      variant: ButtonVariant.quiet,
                      onPressed: onRequery,
                      child: Text(t.mini_translator.result.stale_requery),
                    ),
                  ),
                ],
              ],
              if (!noResult) ...[
                const SizedBox(height: 12),
                // 引擎署名与对比开关 — under the translation, so the text
                // stays the visual protagonist of the block.
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.accentText,
                        shape: BoxShape.circle,
                        boxShadow: tokens.highlightGlow,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Label(
                        tone: LabelTone.accent,
                        child: Text(
                          translating
                              ? getLanguageName(
                                  results.first.translationTarget?.target ?? '',
                                )
                              : _engineName(
                                  preferred!.record.translationEngineId,
                                ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (translations.length > 1)
                      _CompareToggle(
                        expanded: showCompare,
                        engineCount: translations.length,
                        onPressed: onToggleCompare,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // 展开对比 — candidate engines as promotable cards.
        if (showCompare && candidates.isNotEmpty && !translating && !noResult)
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: colors.panel,
              border: Border(
                top: BorderSide(
                  color: colors.borderHairline,
                  width: context.hairlineWidth,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < candidates.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _CandidateCard(
                    name: _candidateName(candidates[i], results),
                    shortcut: _shortcutFor(candidates[i], translations),
                    text: candidates[i].text,
                    onPrefer: candidates[i].record.translationEngineId == null
                        ? null
                        : () => onPreferEngine(
                              candidates[i].record.translationEngineId!,
                            ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  /// Candidate label: engine name, with the target appended when the app is
  /// translating into several targets at once.
  String _candidateName(
    EngineTranslation candidate,
    List<TranslationResult> results,
  ) {
    final name = _engineName(candidate.record.translationEngineId);
    if (results.length <= 1) return name;
    final target = candidate.result.translationTarget?.target;
    if (target == null || target.isEmpty) return name;
    return '$name · ${getLanguageName(target)}';
  }

  /// ⌥n hint, numbered by the engine's position in the full list — the same
  /// index the page's ⌥1/2/3 shortcuts promote.
  String? _shortcutFor(
    EngineTranslation candidate,
    List<EngineTranslation> translations,
  ) {
    final index = translations.indexOf(candidate);
    if (index < 0 || index > 8) return null;
    return '⌥${index + 1}';
  }
}

/// The 对比 N 个引擎 / 收起对比 pill — accent-tinted with a rotating chevron.
class _CompareToggle extends StatelessWidget {
  const _CompareToggle({
    required this.expanded,
    required this.engineCount,
    required this.onPressed,
  });

  final bool expanded;
  final int engineCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.pill);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      semanticsLabel: expanded
          ? t.mini_translator.result.collapse_compare
          : t.mini_translator.result.compare_engines(count: engineCount),
      builder: (context, state) => AnimatedContainer(
        duration: kTransitionDuration,
        padding: const EdgeInsets.fromLTRB(9, 4, 7, 4),
        decoration: BoxDecoration(
          color: colors.accent.withValues(alpha: state.hovered ? 0.20 : 0.12),
          borderRadius: radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              expanded
                  ? t.mini_translator.result.collapse_compare
                  : t.mini_translator.result
                      .compare_engines(count: engineCount),
              style: tokens.typography.sansStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1,
                color: colors.accentText,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: kTransitionDuration,
              child: Icon(
                FluentIcons.chevron_down_20_regular,
                size: 10,
                color: colors.accentText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One candidate engine: attribution with its ⌥n hint, the text, and 设为首选.
class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.name,
    required this.shortcut,
    required this.text,
    required this.onPrefer,
  });

  final String name;
  final String? shortcut;
  final String text;
  final VoidCallback? onPrefer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: colors.subtle,
        borderRadius: BorderRadius.circular(tokens.radii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Label(
                  tone: LabelTone.subtle,
                  child: Text(name),
                ),
              ),
              if (shortcut != null) Kbd(shortcut!, size: KbdSize.sm),
            ],
          ),
          const SizedBox(height: 5),
          SelectableText(
            text,
            style: tokens.typography.cjkStyle(
              fontSize: 13,
              height: 1.75,
              color: colors.fgSecondary,
            ),
          ),
          if (onPrefer != null) ...[
            const SizedBox(height: 7),
            Button(
              variant: ButtonVariant.quiet,
              onPressed: onPrefer,
              child: Text(t.mini_translator.result.set_preferred),
            ),
          ],
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
