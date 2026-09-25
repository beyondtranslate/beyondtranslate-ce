import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show InputSubmitMode, ProviderType;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../services/system_translation.dart';
import '../../theme/product_tokens.dart'
    show ProductPalette, ProductTokens, ProductTokensContext, ProductTypography;
import '../../utils/language_util.dart';
import '../../utils/shortcut_util.dart';
import '../../widgets/block_heading.dart';
import '../../widgets/blocks.dart' show CompareTray;
import '../../widgets/candidate_row.dart' show CandidateRow;
import '../../widgets/compare_toggle.dart';
import '../../widgets/data_display.dart' show DetailBlock;
import '../../widgets/missing_language.dart';
import '../../widgets/translation_text.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        IconButton,
        IconButtonTint,
        IconButtonVariant,
        SectionLabel,
        Spinner,
        ThemeDataBuildContextProps,
        WidgetSize;

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

/// The translation the preferred block shows: the default service's, and only
/// its own. A default that failed is a failed translation — the block says so
/// rather than quietly promoting whichever other service answered, which would
/// leave 设置 · 服务 naming one service and the window showing another.
///
/// With no default among the enabled services there is nothing to be faithful
/// to, and the first service that answered stands in.
ServiceTranslation? preferredTranslation(
  List<TranslationResult> results,
  String? preferredServiceId,
) {
  final translations = serviceTranslations(results);
  if (translations.isEmpty) return null;
  if (preferredServiceId == null) return translations.first;
  for (final translation in translations) {
    if (translation.record.translationServiceId == preferredServiceId) {
      return translation;
    }
  }
  return null;
}

bool _recordHasText(TranslationResultRecord record) {
  final texts = record.translateResponse?.translations ?? [];
  return texts.isNotEmpty && texts.first.text.isNotEmpty;
}

/// The record a target's block speaks for: the default service's, whatever
/// state it is in — its text, its failure, or its spinner. The other services
/// only ever appear in the compare list, so nothing they do can take this
/// slot.
///
/// With no default among the enabled services the block follows the first
/// service that answered, and before any of them has, the first that was
/// asked.
TranslationResultRecord? blockRecord(
  TranslationResult result,
  String? preferredServiceId,
  Set<String> translationServiceIds,
) {
  final records =
      (result.translationResultRecordList ?? const <TranslationResultRecord>[])
          .where((record) =>
              translationServiceIds.contains(record.translateServiceIdOrEmpty));
  if (preferredServiceId != null) {
    return records
        .where((record) => record.translationServiceId == preferredServiceId)
        .firstOrNull;
  }
  return records.where(_recordHasText).firstOrNull ?? records.firstOrNull;
}

/// The record whose missing language files take [result]'s slot — 系统翻译
/// reporting `languagePairNotInstalled` for this target.
///
/// Only the block's own service can take that slot: what another service made
/// of this target says nothing about whether the one you configured could
/// answer.
TranslationResultRecord? missingLanguageRecord(
  TranslationResult result,
  String? preferredServiceId,
  Set<String> translationServiceIds,
) {
  final own = blockRecord(result, preferredServiceId, translationServiceIds);
  if (own == null || _recordHasText(own)) return null;
  return SystemLanguageNotInstalled.of(own.translateError?.message) != null
      ? own
      : null;
}

/// 语言文件未下载 on every target is a failed query like 未返回结果: nothing to
/// read, copy or star, and ⏎ is a retry. The window shell asks so its footer
/// can grey 复制/收藏 and relabel ⏎.
bool allTargetsMissingLanguage(
  List<TranslationResult> results,
  String? preferredServiceId,
  Set<String> translationServiceIds,
) {
  return results.isNotEmpty &&
      results.every(
        (result) =>
            missingLanguageRecord(
              result,
              preferredServiceId,
              translationServiceIds,
            ) !=
            null,
      );
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
///
/// 自动匹配 can resolve to more than one target — a specific rule and the
/// 自动检测 fallback both apply — and the core translates into each, so the
/// blocks stack one per target: the first behind the 2px accent rule, a
/// further one behind a neutral hairline. Each target's 对比 opens its own
/// list, and 复制 rides on each block's attribution row.
class MiniTranslatorTranslation extends StatelessWidget {
  const MiniTranslatorTranslation({
    super.key,
    required this.querySubmitted,
    required this.translationResultList,
    required this.translationServiceIds,
    required this.serviceNameById,
    required this.providerTypeByServiceId,
    this.defaultServiceId,
    this.matchedAutomatically = true,
    required this.preferredServiceId,
    required this.inputSubmitMode,
    required this.compareOpenTargets,
    required this.copiedTarget,
    required this.onToggleCompare,
    required this.onCopyTarget,
    required this.onRequery,
  });

  final bool querySubmitted;
  final List<TranslationResult> translationResultList;

  /// Service ids of type translation — lookup-only records must not keep the
  /// block in the translating phase.
  final Set<String> translationServiceIds;
  final Map<String, String> serviceNameById;

  /// The provider each service runs on, so a compare row carries the same
  /// mark 服务 shows it under rather than a lettered disc.
  final Map<String, ProviderType> providerTypeByServiceId;

  /// The translation service 设置 marks 默认. Its output is attributed as plain
  /// 译文; only a promoted service is named, so you know what you switched to.
  final String? defaultServiceId;

  /// Whether the capsule is on 自动匹配. Only then does the heading name the
  /// target: a language the user picked is already in the capsule.
  final bool matchedAutomatically;
  final String? preferredServiceId;

  /// Only so 原文已修改 names the key that actually re-runs the query —
  /// 提交方式 decides which one that is.
  final InputSubmitMode inputSubmitMode;

  /// The source was edited after this result came back — offer 重新翻译.

  /// Targets whose 对比 list is open — or, with no result, whether the
  /// 失效清单 is (keyed by [kFailureListKey]).
  final Set<String> compareOpenTargets;

  /// Which target's 复制 just fired — its icon reads 已复制 for a beat.
  final String? copiedTarget;
  final ValueChanged<String> onToggleCompare;
  final ValueChanged<String> onCopyTarget;
  final VoidCallback onRequery;

  /// What the 失效清单 toggle is keyed under in [compareOpenTargets].
  static const String kFailureListKey = '';

  String _serviceName(String? serviceId) =>
      serviceNameById[serviceId] ?? serviceId ?? '';

  /// The heading over a translation block. The default service is never
  /// named — the language alone is enough when the answer came from the one
  /// you would expect; a promoted service trails as a qualifier.
  BlockHeadingParts _heading(String? serviceId, String target) {
    return translationHeading(
      target: target,
      serviceName: serviceId != null && serviceId == defaultServiceId
          ? null
          : _serviceName(serviceId),
      matched: matchedAutomatically,
    );
  }

  _ServiceFailure _failureOf(TranslationResultRecord record) {
    final message = record.translateError?.message.trim() ?? '';
    return _ServiceFailure(
      name: _serviceName(record.translationServiceId),
      reason:
          message.isEmpty ? t.mini_translator.result.unknown_error : message,
      notInstalled: SystemLanguageNotInstalled.of(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final results = translationResultList;

    if (!querySubmitted || results.isEmpty) {
      return const SizedBox.shrink();
    }

    final translations = serviceTranslations(results);

    // Translation records that errored / are still in flight, ignoring
    // dictionary lookups. The failures are kept, not just counted: 服务全部失效
    // prints one card per service with the reason it gave.
    var pendingCount = 0;
    final failures = <_ServiceFailure>[];
    final seenFailed = <String>{};
    for (final result in results) {
      for (final record in result.translationResultRecordList ??
          const <TranslationResultRecord>[]) {
        if (!translationServiceIds.contains(record.translateServiceIdOrEmpty)) {
          continue;
        }
        if (record.translateError != null) {
          // A service that failed for every target is one failure, not one
          // per target: the card names the service, not the language.
          if (!seenFailed.add(record.translateServiceIdOrEmpty)) continue;
          failures.add(_failureOf(record));
        } else {
          final texts = record.translateResponse?.translations ?? [];
          if (texts.isEmpty || texts.first.text.isEmpty) {
            pendingCount++;
          }
        }
      }
    }

    // 服务全部失效 — unless one of the failures is 系统翻译 lacking the
    // language files, which the target's own block reports, with the fix.
    final noResult = translations.isEmpty &&
        pendingCount == 0 &&
        failures.isNotEmpty &&
        !failures.any((failure) => failure.notInstalled != null);

    if (noResult) {
      final open = compareOpenTargets.contains(kFailureListKey);
      final targetList = results
          .map((result) =>
              getLanguageName(result.translationTarget?.target ?? ''))
          .join(t.workbench.translation.target_separator);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 服务全部失效 keeps the result block's shape — body, then the
          // attribution row with the compare toggle — in the danger key,
          // the way the main window's 翻译 pane does.
          Container(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
            decoration: BoxDecoration(
              color: vars.dangerSurface,
              border: Border(
                top: BorderSide(
                  color: vars.dangerHairline,
                  width: ProductTokens.highlightRule,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.mini_translator.result.no_result_body,
                  style: vars.miniTranslationStyle(
                    color: vars.colorContentSubtle,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // No glow: the glow marks the one that answered.
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: vars.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    // The heading takes the rest of the row, so the toggle
                    // sits at the right edge and the label is cut only when
                    // there is genuinely no room left.
                    Expanded(
                      child: DefaultTextStyle(
                        style: vars.labelStyle(color: vars.dangerFg),
                        // A failed query keeps the plain heading — the body
                        // already says the translation did not arrive, and a
                        // status on the label would say it twice.
                        child: BlockHeading(
                          _heading(preferredServiceId, targetList),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CompareToggle(
                      expanded: open,
                      count: failures.length,
                      label: open
                          ? t.mini_translator.result.collapse_reasons
                          : t.mini_translator.result.show_reasons(
                              count: failures.length,
                            ),
                      onPressed: () => onToggleCompare(kFailureListKey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 失效清单 — the same cards as the compare list, folded away by the
          // same toggle, so a service looks the same whether it answered or
          // not: name where it always is, the ⌥n hint still live, the body a
          // reason instead of a translation, and the foot the fix instead of
          // 设为首选.
          if (open)
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: vars.colorSurfaceRaised,
                border: Border(
                  top: BorderSide(
                    color: vars.colorBorder,
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
        ],
      );
    }

    final stacked = results.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < results.length; i++)
          _buildTargetBlock(
            context,
            results[i],
            first: i == 0,
            last: i == results.length - 1,
            stacked: stacked,
          ),
      ],
    );
  }

  /// One target's block: the preferred service's text, then the attribution
  /// row with the per-target controls, then — folded out — the other
  /// services' renderings into this language.
  Widget _buildTargetBlock(
    BuildContext context,
    TranslationResult result, {
    required bool first,
    required bool last,
    required bool stacked,
  }) {
    final vars = context.vars;
    final targetCode = result.translationTarget?.target ?? '';
    // The resolved target rides on the attribution label, as in the main
    // window's 首选译文 block; the capsule stays on 自动检测 ⇄ 自动匹配.
    final targetName = getLanguageName(targetCode);
    // The block belongs to one service — the default — and shows whatever
    // that service did with this target.
    final own = blockRecord(result, preferredServiceId, translationServiceIds);
    // 系统翻译 without this pair's language files: reason + fix, no text.
    final missingRecord = missingLanguageRecord(
      result,
      preferredServiceId,
      translationServiceIds,
    );
    final missing = missingRecord == null
        ? null
        : SystemLanguageNotInstalled.of(missingRecord.translateError?.message);
    final preferred = missing != null
        ? null
        : preferredTranslation([result], preferredServiceId);
    // The default came back with a reason instead of a translation. It takes
    // the block the way the missing-language notice does: another service
    // answering is not this service answering.
    final failureRecord = missing == null &&
            preferred == null &&
            own != null &&
            own.translateError != null
        ? own
        : null;
    final failed = missing != null || failureRecord != null;
    final translating = !failed && preferred == null;
    final open = compareOpenTargets.contains(targetCode);
    final copied = copiedTarget == targetCode;
    // The list is keyed by service, not by what came back: opening it is what
    // asks the other services, so one with no record yet is a row too — it
    // just holds a spinner until it answers.
    final ownServiceId = own?.translateServiceIdOrEmpty;
    final recordByService = {
      for (final record in result.translationResultRecordList ??
          const <TranslationResultRecord>[])
        record.translateServiceIdOrEmpty: record,
    };
    final rows = [
      for (final serviceId in translationServiceIds)
        if (serviceId != ownServiceId)
          _buildCompareRow(context, serviceId, recordByService[serviceId]),
    ];
    // 对比 counts the services being compared, this block's own included —
    // it is the size of the comparison, not of the list that folds out.
    final compareCount = rows.length + (own == null ? 0 : 1);
    final showList = open && rows.isNotEmpty;
    // 复制 on the attribution row is a 24px button beside an 18px toggle;
    // the deck pulls it in with negative margins, so the gap above and the
    // inset below give up the difference here to keep the block's rhythm.
    final controls = stacked && !translating && !failed;

    return Container(
      decoration: BoxDecoration(
        // A default service that could not answer — no language files, or any
        // other reason — is a failed translation, so the block takes the
        // danger key the way 未返回结果 does.
        color: failed ? vars.dangerSurface : vars.accentSurface,
        // The 2px accent rule marks where the output starts; a further target
        // shares the surface behind a neutral 1px hairline — a second accent
        // line would read as a second output rather than a section of this one.
        border: Border(
          top: first
              ? BorderSide(
                  color: failed ? vars.dangerHairline : vars.accentHairline,
                  width: ProductTokens.highlightRule,
                )
              : BorderSide(
                  color: vars.colorBorder,
                  width: context.hairlineWidth,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (translating)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Spinner(size: WidgetSize.small),
                        const SizedBox(width: 10),
                        Text(
                          t.mini_translator.result.translating,
                          style: vars.sansStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1,
                            color: vars.accentText,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (missing != null)
                  // The block keeps the result shape — body, then the
                  // attribution row — in the danger key, at the same type
                  // scale as 未返回结果: the failure sits in the translation's
                  // slot, so it is set like one. The fix rides inside the
                  // sentence as a short link; the full settings path stays
                  // on the main window.
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${MissingLanguageText.sentence(missing)}'
                              '${t.mini_translator.result.language_missing_mini_before}',
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: SystemSettingsLink(
                            label: t.mini_translator.result
                                .language_missing_mini_link,
                            bold: false,
                            style: vars.miniTranslationStyle(),
                          ),
                        ),
                        TextSpan(
                          text: t.mini_translator.result
                              .language_missing_mini_after(
                            key: inputSubmitShortcutGlyphs(inputSubmitMode),
                          ),
                        ),
                      ],
                    ),
                    style: vars.miniTranslationStyle(
                      color: vars.colorContentSubtle,
                    ),
                  )
                else if (failureRecord != null)
                  // The reason sits where the translation would have been, at
                  // the same type scale: the block reports what the service
                  // you configured said, and 对比 is there to ask the others.
                  Text(
                    _failureOf(failureRecord).reason,
                    style: vars.miniTranslationStyle(color: vars.dangerFg),
                  )
                else
                  TranslationText(
                    preferred!.text,
                    style: vars.miniTranslationStyle(
                      color: vars.colorContent,
                    ),
                  ),
              ],
            ),
          ),
          // 服务署名与对比开关 — under the translation, so the text stays the
          // visual protagonist of the block. 对比按目标各开各的：比的是其他服务
          // 译到这一种语言的结果.
          //
          // The row hangs 6px past the text column on the right: its trailing
          // control is a filled chip, and at the text's own 15px inset it
          // reads as drifting away from the card's edge. 9px is the compare
          // tray's inset, so the chip lines up with the rows it opens.
          Padding(
            padding: EdgeInsets.fromLTRB(
              15,
              controls ? 9 : 12,
              9,
              showList
                  ? 0
                  : controls
                      ? 12
                      : 15,
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: failed ? vars.danger : vars.accentText,
                    shape: BoxShape.circle,
                    // No glow: the glow marks the one that answered.
                    boxShadow: failed ? null : context.product.highlightGlow,
                  ),
                ),
                const SizedBox(width: 7),
                // The heading takes the rest of the row: 复制 and 对比
                // ride at the right edge, and 译文 语言 服务名 gets every
                // pixel between them and the dot.
                Expanded(
                  child: DefaultTextStyle(
                    style: vars.labelStyle(
                      color: failed ? vars.dangerFg : vars.accentText,
                    ),
                    // 语言文件未下载 is already said by the body in the
                    // translation's slot; the heading does not repeat it.
                    child: BlockHeading(
                      _heading(
                        (missingRecord ?? failureRecord)
                                ?.translationServiceId ??
                            preferred?.record.translationServiceId,
                        targetName,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (controls) ...[
                  IconButton(
                      semanticsLabel: copied
                          ? t.mini_translator.button.copied
                          : t.mini_translator.button.copy,
                      // Copied is a confirmation that clears itself,
                      // not a state the button is held in, so it takes the
                      // success recipe rather than a toggle's latch.
                      tint: copied ? IconButtonTint.success : null,
                      variant: copied ? IconButtonVariant.plain : null,
                      icon: Icon(
                        copied
                            ? FluentIcons.checkmark_20_regular
                            : FluentIcons.copy_20_regular,
                      ),
                      onPressed: () => onCopyTarget(targetCode)),
                  const SizedBox(width: 8),
                ],
                if (rows.isNotEmpty)
                  CompareToggle(
                    expanded: open,
                    // The badge counts the rows the list would open; the name
                    // it answers to counts the comparison, this block's own
                    // service included.
                    count: rows.length,
                    label: open
                        ? t.mini_translator.result.collapse_compare
                        : t.mini_translator.result.compare_services(
                            count: compareCount,
                          ),
                    onPressed: () => onToggleCompare(targetCode),
                  ),
              ],
            ),
          ),
          // 展开对比 — the other services, listed in this target's own block
          // on the same tinted surface; a separate grey band would cut the
          // result area into strips.
          if (showList)
            CompareTray(
              margin: const EdgeInsets.only(top: 2),
              // 6px short of the block's 15px inset: each row's attribution
              // chip hangs that far past the text column.
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
              color: vars.colorSurfaceRaised,
              children: rows,
            ),
        ],
      ),
    );
  }

  /// One other service's row. Opening the list is what asks these services, so
  /// a row starts as a spinner and settles into the translation that came
  /// back, or the reason it did not.
  Widget _buildCompareRow(
    BuildContext context,
    String serviceId,
    TranslationResultRecord? record,
  ) {
    final vars = context.vars;
    final bodyStyle = vars.cjkStyle(
      fontSize: 13,
      height: 1.7,
      color: vars.colorContentSecondary,
    );
    final texts = record?.translateResponse?.translations ?? [];
    final text = texts.isEmpty ? '' : texts.first.text;
    final failure = record?.translateError == null ? null : _failureOf(record!);

    final Widget child;
    if (text.isNotEmpty) {
      child = TranslationText(text, style: bodyStyle);
    } else if (failure != null) {
      // The install notice or the reason the service gave, where its
      // translation would have been.
      child = failure.notInstalled != null
          ? MissingLanguageNote(missing: failure.notInstalled!)
          : Text(
              failure.reason,
              style: bodyStyle.copyWith(color: vars.dangerFg),
            );
    } else {
      child = const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Spinner(size: WidgetSize.small),
        ),
      );
    }

    return CandidateRow(
      name: _serviceName(serviceId),
      providerType: providerTypeByServiceId[serviceId],
      child: child,
    );
  }
}

extension on TranslationResultRecord {
  String get translateServiceIdOrEmpty => translationServiceId ?? '';
}

/// Why one service came back empty — a blanket "failed" gives the user nothing
/// to act on, and the block's job in this state is to point at the fix.
class _ServiceFailure {
  const _ServiceFailure({
    required this.name,
    required this.reason,
    this.notInstalled,
  });

  final String name;
  final String reason;

  /// Set when the system translator lacks the language files for the pair —
  /// the one failure the card can point at a fix for.
  final SystemLanguageNotInstalled? notInstalled;
}

/// One failed service: the same card the compare list draws, with the reason
/// where the translation would be and 重试 under it.
class _FailureCard extends StatelessWidget {
  const _FailureCard({required this.failure, required this.onRetry});

  final _ServiceFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: vars.colorSurfaceSubtle,
        borderRadius: BorderRadius.circular(vars.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionLabel(failure.name),
          const SizedBox(height: 5),
          Text(
            failure.notInstalled != null
                ? MissingLanguageText.sentence(failure.notInstalled!)
                : failure.reason,
            style: vars.sansStyle(
              fontSize: 12,
              height: 1.7,
              color: vars.colorContentSecondary,
            ),
          ),
          const SizedBox(height: 7),
          if (failure.notInstalled != null)
            Button(
                variant: ButtonVariant.plain,
                onPressed: openTranslationLanguagesSettings,
                child: Text(t.mini_translator.result.open_system_settings))
          else
            Button(
                variant: ButtonVariant.plain,
                onPressed: onRetry,
                child: Text(t.mini_translator.result.retry)),
        ],
      ),
    );
  }
}

class MiniTranslatorWordDefinition extends StatelessWidget {
  const MiniTranslatorWordDefinition({
    super.key,
    required this.translationResultList,
  });

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
