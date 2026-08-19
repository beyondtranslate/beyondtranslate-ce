import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show InputSubmitMode;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../theme/product_tokens.dart'
    show ProductTokens, ProductTokensContext;
import '../../utils/language_util.dart';
import '../../utils/shortcut_util.dart';
import '../../widgets/data_display.dart' show DetailBlock;
import '../../widgets/translation_text.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        Kbd,
        KbdSize,
        Label,
        LabelTone,
        Pressable,
        Spinner,
        SpinnerSize,
        kTransitionDuration;

/// One service's translated text, paired with the target it belongs to.
typedef ServiceTranslation = ({
  TranslationResult result,
  TranslationResultRecord record,
  String text,
});

/// Every service translation with text, in service order — the first target's
/// records first, then any additional configured targets.
List<ServiceTranslation> serviceTranslations(List<TranslationResult> results) {
  final translations = <ServiceTranslation>[];
  for (final result in results) {
    for (final record in result.translationResultRecordList ??
        const <TranslationResultRecord>[]) {
      final texts = record.translateResponse?.translations ?? [];
      if (texts.isEmpty || texts.first.text.isEmpty) continue;
      translations.add((
        result: result,
        record: record,
        text: texts.first.text,
      ));
    }
  }
  return translations;
}

/// The translation the preferred block shows: the service the user promoted
/// (⌥n / 设为首选) when it has text, else the first service that answered.
ServiceTranslation? preferredTranslation(
  List<TranslationResult> results,
  String? preferredServiceId,
) {
  final translations = serviceTranslations(results);
  if (translations.isEmpty) return null;
  for (final translation in translations) {
    if (translation.record.translationServiceId == preferredServiceId) {
      return translation;
    }
  }
  return translations.first;
}

/// True when every configured service came back with an error and none is
/// still in flight — the 服务全部失效 state. The window shell asks so its ⏎
/// button can read 重试.
bool allServicesFailed(
  List<TranslationResult> results,
  Set<String> translationServiceIds,
) {
  var pending = 0;
  var failed = 0;
  for (final result in results) {
    for (final record in result.translationResultRecordList ??
        const <TranslationResultRecord>[]) {
      if (!translationServiceIds.contains(record.translationServiceId)) {
        continue;
      }
      if (record.translateError != null) {
        failed++;
      } else {
        final texts = record.translateResponse?.translations ?? [];
        if (texts.isEmpty || texts.first.text.isEmpty) pending++;
      }
    }
  }
  return failed > 0 && pending == 0 && serviceTranslations(results).isEmpty;
}

/// The preferred block plus the on-demand service comparison, mirroring the
/// deck's MiniTranslator: one preferred translation as the visual protagonist,
/// its service attribution below, candidates behind a 对比 N 个服务 toggle.
class MiniTranslatorTranslation extends StatelessWidget {
  const MiniTranslatorTranslation({
    Key? key,
    required this.querySubmitted,
    required this.translationResultList,
    required this.translationServiceIds,
    required this.serviceNameById,
    required this.preferredServiceId,
    required this.inputSubmitMode,
    required this.stale,
    required this.showCompare,
    required this.onToggleCompare,
    required this.onPreferService,
    required this.onRequery,
  }) : super(key: key);

  final bool querySubmitted;
  final List<TranslationResult> translationResultList;

  /// Service ids of type translation — lookup-only records must not keep the
  /// block in the translating phase.
  final Set<String> translationServiceIds;
  final Map<String, String> serviceNameById;
  final String? preferredServiceId;

  /// Only so 原文已修改 names the key that actually re-runs the query —
  /// 提交方式 decides which one that is.
  final InputSubmitMode inputSubmitMode;

  /// The source was edited after this result came back — offer 重新翻译.
  final bool stale;
  final bool showCompare;
  final VoidCallback onToggleCompare;
  final ValueChanged<String> onPreferService;
  final VoidCallback onRequery;

  String _serviceName(String? serviceId) =>
      serviceNameById[serviceId] ?? serviceId ?? '';

  /// ⌥n hint by the service's position in the configured list — the same index
  /// the page's ⌥1/2/3 shortcuts promote, and the one hint that stays live when
  /// no service answered.
  String? _shortcutForService(String? serviceId) {
    final index = translationServiceIds.toList().indexOf(serviceId ?? '');
    if (index < 0 || index > 8) return null;
    return '⌥${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final results = translationResultList;

    if (!querySubmitted || results.isEmpty) {
      return const SizedBox.shrink();
    }

    final translations = serviceTranslations(results);
    final preferred = preferredTranslation(results, preferredServiceId);
    // The resolved target rides on the attribution label, as in the main
    // window's 首选译文 block; the capsule stays on 自动检测 ⇄ 自动匹配.
    final targetName = getLanguageName(
      results.first.translationTarget?.target ?? '',
    );

    // Translation records that errored / are still in flight, ignoring
    // dictionary lookups. The failures are kept, not just counted: 服务全部失效
    // prints one card per service with the reason it gave.
    var pendingCount = 0;
    final failures = <_ServiceFailure>[];
    for (final result in results) {
      for (final record in result.translationResultRecordList ??
          const <TranslationResultRecord>[]) {
        if (!translationServiceIds.contains(record.translationServiceId)) {
          continue;
        }
        if (record.translateError != null) {
          failures.add(
            _ServiceFailure(
              name: _serviceName(record.translationServiceId),
              reason: record.translateError!.message.trim().isEmpty
                  ? t.mini_translator.result.unknown_error
                  : record.translateError!.message.trim(),
              shortcut: _shortcutForService(record.translationServiceId),
            ),
          );
        } else {
          final texts = record.translateResponse?.translations ?? [];
          if (texts.isEmpty || texts.first.text.isEmpty) {
            pendingCount++;
          }
        }
      }
    }

    final noResult =
        translations.isEmpty && pendingCount == 0 && failures.isNotEmpty;
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
            // 服务全部失效 keeps the result block's shape — body, then the
            // attribution row with the compare toggle — in the danger key,
            // the way the main window's 翻译 pane does.
            color: noResult ? colors.dangerSurface : colors.accentSurface,
            border: Border(
              top: BorderSide(
                color: noResult ? colors.dangerHairline : colors.accentHairline,
                width: ProductTokens.highlightRule,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (noResult) ...[
                Text(
                  t.mini_translator.result.no_result_body,
                  style: tokens.typography.cjkStyle(
                    fontSize: 15,
                    height: 1.9,
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
                TranslationText(
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
                      child: Text(
                        t.mini_translator.result.stale_requery(
                          key: inputSubmitShortcutGlyphs(inputSubmitMode),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 12),
              // 服务署名与对比开关 — under the translation, so the text stays
              // the visual protagonist of the block.
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: noResult ? colors.danger : colors.accentText,
                      shape: BoxShape.circle,
                      // No glow: the glow marks the one that answered.
                      boxShadow:
                          noResult ? null : context.product.highlightGlow,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Label(
                      tone: noResult ? LabelTone.danger : LabelTone.accent,
                      child: Text(
                        noResult
                            ? '${_serviceName(preferredServiceId)} · $targetName'
                                ' · ${t.mini_translator.result.no_result_tag}'
                            : translating
                                ? targetName
                                : '${_serviceName(preferred!.record.translationServiceId)}'
                                    ' · $targetName',
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (noResult)
                    _CompareToggle(
                      expanded: showCompare,
                      label: showCompare
                          ? t.mini_translator.result.collapse_reasons
                          : t.mini_translator.result.show_reasons(
                              count: failures.length,
                            ),
                      onPressed: onToggleCompare,
                    )
                  else if (translations.length > 1)
                    _CompareToggle(
                      expanded: showCompare,
                      label: showCompare
                          ? t.mini_translator.result.collapse_compare
                          : t.mini_translator.result.compare_services(
                              count: translations.length,
                            ),
                      onPressed: onToggleCompare,
                    ),
                ],
              ),
            ],
          ),
        ),
        // 失效清单 — the same cards as the compare list, folded away by the
        // same toggle, so a service looks the same whether it answered or not:
        // name where it always is, the ⌥n hint still live, the body a reason
        // instead of a translation, and the foot the fix instead of 设为首选.
        if (showCompare && noResult)
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: colors.panel,
              border: Border(
                top: BorderSide(
                  color: colors.hairlineSoft,
                  width: context.hairlineWidth,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < failures.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _FailureCard(failure: failures[i], onRetry: onRequery),
                ],
              ],
            ),
          ),
        // 展开对比 — candidate services as promotable cards.
        if (showCompare && candidates.isNotEmpty && !translating && !noResult)
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: colors.panel,
              border: Border(
                top: BorderSide(
                  color: colors.hairlineSoft,
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
                    onPrefer: candidates[i].record.translationServiceId == null
                        ? null
                        : () => onPreferService(
                              candidates[i].record.translationServiceId!,
                            ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  /// Candidate label: service name, with the target appended when the app is
  /// translating into several targets at once.
  String _candidateName(
    ServiceTranslation candidate,
    List<TranslationResult> results,
  ) {
    final name = _serviceName(candidate.record.translationServiceId);
    if (results.length <= 1) return name;
    final target = candidate.result.translationTarget?.target;
    if (target == null || target.isEmpty) return name;
    return '$name · ${getLanguageName(target)}';
  }

  /// ⌥n hint, numbered by the service's position in the full list — the same
  /// index the page's ⌥1/2/3 shortcuts promote.
  String? _shortcutFor(
    ServiceTranslation candidate,
    List<ServiceTranslation> translations,
  ) {
    final index = translations.indexOf(candidate);
    if (index < 0 || index > 8) return null;
    return '⌥${index + 1}';
  }
}

/// The 对比 N 个服务 / 收起对比 pill — accent-tinted with a rotating chevron.
class _CompareToggle extends StatelessWidget {
  const _CompareToggle({
    required this.expanded,
    required this.label,
    required this.onPressed,
  });

  final bool expanded;

  /// 对比 N 个服务 when the services answered, 查看 N 个服务的原因 when none did.
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.pill);

    return Pressable(
      onPressed: onPressed,
      borderRadius: radius,
      semanticsLabel: label,
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
              label,
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

/// Why one service came back empty — a blanket "failed" gives the user nothing
/// to act on, and the block's job in this state is to point at the fix.
class _ServiceFailure {
  const _ServiceFailure({
    required this.name,
    required this.reason,
    required this.shortcut,
  });

  final String name;
  final String reason;
  final String? shortcut;
}

/// One failed service: the same card the compare list draws, with the reason
/// where the translation would be and 重试 where 设为首选 would.
class _FailureCard extends StatelessWidget {
  const _FailureCard({required this.failure, required this.onRetry});

  final _ServiceFailure failure;
  final VoidCallback onRetry;

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
                  child: Text(failure.name),
                ),
              ),
              if (failure.shortcut != null)
                Kbd(failure.shortcut!, size: KbdSize.sm),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            failure.reason,
            style: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1.7,
              color: colors.fgSecondary,
            ),
          ),
          const SizedBox(height: 7),
          Button(
            variant: ButtonVariant.quiet,
            onPressed: onRetry,
            child: Text(t.mini_translator.result.retry),
          ),
        ],
      ),
    );
  }
}

/// One candidate service: attribution with its ⌥n hint, the text, and 设为首选.
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
                child: Label(tone: LabelTone.subtle, child: Text(name)),
              ),
              if (shortcut != null) Kbd(shortcut!, size: KbdSize.sm),
            ],
          ),
          const SizedBox(height: 5),
          TranslationText(
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

    if (results.isEmpty || !kDictionaryFeatureEnabled) {
      return const SizedBox.shrink();
    }

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
