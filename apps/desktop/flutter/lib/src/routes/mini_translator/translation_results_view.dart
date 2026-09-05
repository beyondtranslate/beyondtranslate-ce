import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show InputSubmitMode;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide IconButton;

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../services/system_translation.dart';
import '../../theme/product_tokens.dart'
    show ProductTokens, ProductTokensContext, ProductTypographyStyles;
import '../../utils/language_util.dart';
import '../../utils/shortcut_util.dart';
import '../../widgets/block_heading.dart';
import '../../widgets/blocks.dart' show CompareTray;
import '../../widgets/candidate_row.dart'
    show CandidateRow, kProviderAvatarColors;
import '../../widgets/data_display.dart' show DetailBlock;
import '../../widgets/missing_language.dart';
import '../../widgets/translation_text.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        IconButton,
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

bool _recordHasText(TranslationResultRecord record) {
  final texts = record.translateResponse?.translations ?? [];
  return texts.isNotEmpty && texts.first.text.isNotEmpty;
}

/// The record whose missing language files take [result]'s slot — 系统翻译
/// reporting `languagePairNotInstalled` for this target.
///
/// The preferred service's, when the user promoted it and that is how it
/// failed: they asked for it, so they hear why it has nothing. Otherwise only
/// when no service produced text for the target: a service that answered
/// keeps the slot, and the missing one shows its reason in the compare list.
TranslationResultRecord? missingLanguageRecord(
  TranslationResult result,
  String? preferredServiceId,
  Set<String> translationServiceIds,
) {
  final records =
      result.translationResultRecordList ?? const <TranslationResultRecord>[];
  bool notInstalled(TranslationResultRecord record) =>
      translationServiceIds.contains(record.translationServiceId ?? '') &&
      !_recordHasText(record) &&
      SystemLanguageNotInstalled.of(record.translateError?.message) != null;

  if (preferredServiceId != null) {
    final own = records
        .where((record) => record.translationServiceId == preferredServiceId)
        .firstOrNull;
    if (own != null && notInstalled(own)) return own;
    if (own != null && _recordHasText(own)) return null;
  }
  if (records.any(_recordHasText)) return null;
  return records.where(notInstalled).firstOrNull;
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
    Key? key,
    required this.querySubmitted,
    required this.translationResultList,
    required this.translationServiceIds,
    required this.serviceNameById,
    this.defaultServiceId,
    this.matchedAutomatically = true,
    required this.preferredServiceId,
    required this.inputSubmitMode,
    required this.compareOpenTargets,
    required this.copiedTarget,
    required this.onToggleCompare,
    required this.onCopyTarget,
    required this.onPreferService,
    required this.onRequery,
  }) : super(key: key);

  final bool querySubmitted;
  final List<TranslationResult> translationResultList;

  /// Service ids of type translation — lookup-only records must not keep the
  /// block in the translating phase.
  final Set<String> translationServiceIds;
  final Map<String, String> serviceNameById;

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
  final ValueChanged<String> onPreferService;
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

  /// ⌥n hint by the service's position in the configured list — the same index
  /// the page's ⌥1/2/3 shortcuts promote, and the one hint that stays live when
  /// no service answered.
  String? _shortcutForService(String? serviceId) {
    final index = _serviceIndex(serviceId);
    if (index < 0 || index > 8) return null;
    return '⌥${index + 1}';
  }

  int _serviceIndex(String? serviceId) =>
      translationServiceIds.toList().indexOf(serviceId ?? '');

  _ServiceFailure _failureOf(TranslationResultRecord record) {
    final message = record.translateError?.message.trim() ?? '';
    return _ServiceFailure(
      name: _serviceName(record.translationServiceId),
      reason:
          message.isEmpty ? t.mini_translator.result.unknown_error : message,
      shortcut: _shortcutForService(record.translationServiceId),
      notInstalled: SystemLanguageNotInstalled.of(message),
    );
  }

  /// A translation record that came back with an error and no text.
  bool _isFailedRecord(TranslationResultRecord record) {
    if (!translationServiceIds.contains(record.translationServiceId ?? '')) {
      return false;
    }
    if (record.translateError == null) return false;
    final texts = record.translateResponse?.translations ?? [];
    return texts.isEmpty || texts.first.text.isEmpty;
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
              color: colors.dangerSurface,
              border: Border(
                top: BorderSide(
                  color: colors.dangerHairline,
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
                  style: tokens.typography.miniTranslationStyle(
                    color: colors.fgSubtle,
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
                        color: colors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Label(
                        tone: LabelTone.danger,
                        // A failed query keeps the plain heading — the body
                        // already says the translation did not arrive, and a
                        // status on the label would say it twice.
                        child: BlockHeading(
                          _heading(preferredServiceId, targetList),
                        ),
                      ),
                    ),
                    const Spacer(),
                    _CompareToggle(
                      expanded: open,
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
    final tokens = context.tokens;
    final colors = tokens.colors;
    final targetCode = result.translationTarget?.target ?? '';
    // The resolved target rides on the attribution label, as in the main
    // window's 首选译文 block; the capsule stays on 自动检测 ⇄ 自动匹配.
    final targetName = getLanguageName(targetCode);
    final translations = serviceTranslations([result]);
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
    final translating = missing == null && preferred == null;
    final open = compareOpenTargets.contains(targetCode);
    final copied = copiedTarget == targetCode;
    final candidates = [
      for (final translation in translations)
        if (translation.record != preferred?.record) translation,
    ];
    // A service that failed for this target is listed too — a failure the
    // user can fix (the system translator's missing language files) must
    // not hide behind the service that did answer.
    final failed = [
      for (final record in result.translationResultRecordList ??
          const <TranslationResultRecord>[])
        if (record != missingRecord && _isFailedRecord(record)) record,
    ];
    final rows = [
      for (final candidate in candidates)
        _buildCandidateRow(context, candidate),
      for (final record in failed) _buildFailedRow(context, record),
    ];
    final showList = open && !translating && rows.isNotEmpty;
    // 复制 on the attribution row is a 24px button beside an 18px toggle;
    // the deck pulls it in with negative margins, so the gap above and the
    // inset below give up the difference here to keep the block's rhythm.
    final controls = stacked && !translating && missing == null;

    return Container(
      decoration: BoxDecoration(
        // A missing language pair is a failed translation, so the block
        // takes the danger key the way 未返回结果 does.
        color: missing != null ? colors.dangerSurface : colors.accentSurface,
        // The 2px accent rule marks where the output starts; a further target
        // shares the surface behind a neutral 1px hairline — a second accent
        // line would read as a second output rather than a section of this one.
        border: Border(
          top: first
              ? BorderSide(
                  color: missing != null
                      ? colors.dangerHairline
                      : colors.accentHairline,
                  width: ProductTokens.highlightRule,
                )
              : BorderSide(
                  color: colors.hairline,
                  width: context.hairlineWidth,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              15,
              14,
              15,
              showList
                  ? 0
                  : controls
                      ? 12
                      : 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (translating)
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
                            style: tokens.typography.miniTranslationStyle(),
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
                    style: tokens.typography.miniTranslationStyle(
                      color: colors.fgSubtle,
                    ),
                  )
                else
                  TranslationText(
                    preferred!.text,
                    style: tokens.typography.miniTranslationStyle(
                      color: colors.fg,
                    ),
                  ),
                SizedBox(height: controls ? 9 : 12),
                // 服务署名与对比开关 — under the translation, so the text stays
                // the visual protagonist of the block. 对比按目标各开各的：比的
                // 是其他服务译到这一种语言的结果.
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            missing != null ? colors.danger : colors.accentText,
                        shape: BoxShape.circle,
                        // No glow: the glow marks the one that answered.
                        boxShadow: missing != null
                            ? null
                            : context.product.highlightGlow,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Label(
                        tone: missing != null
                            ? LabelTone.danger
                            : LabelTone.accent,
                        // 语言文件未下载 is already said by the body in the
                        // translation's slot; the heading does not repeat it.
                        child: BlockHeading(
                          _heading(
                            missing != null
                                ? missingRecord!.translationServiceId
                                : preferred?.record.translationServiceId,
                            targetName,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (controls) ...[
                      IconButton(
                        label: copied
                            ? t.mini_translator.button.copied
                            : t.mini_translator.button.copy,
                        active: copied,
                        icon: Icon(
                          copied
                              ? FluentIcons.checkmark_20_regular
                              : FluentIcons.copy_20_regular,
                        ),
                        onPressed: () => onCopyTarget(targetCode),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (!translating && rows.isNotEmpty)
                      _CompareToggle(
                        expanded: open,
                        label: open
                            ? t.mini_translator.result.collapse_compare
                            : t.mini_translator.result.compare_services(
                                count: translations.length + failed.length,
                              ),
                        onPressed: () => onToggleCompare(targetCode),
                      ),
                  ],
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
              color: colors.panel,
              children: rows,
            ),
        ],
      ),
    );
  }

  Widget _buildCandidateRow(
      BuildContext context, ServiceTranslation candidate) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final serviceId = candidate.record.translationServiceId;
    final name = _serviceName(serviceId);
    final index = _serviceIndex(serviceId);

    return CandidateRow(
      name: name,
      avatarLabel: name.isEmpty ? '?' : name.characters.first.toUpperCase(),
      avatarColor: kProviderAvatarColors[
          index < 0 ? 0 : index % kProviderAvatarColors.length],
      shortcut: _shortcutForService(serviceId),
      onPrefer: serviceId == null ? null : () => onPreferService(serviceId),
      child: TranslationText(
        candidate.text,
        style: tokens.typography.cjkStyle(
          fontSize: 13,
          height: 1.7,
          color: colors.fgSecondary,
        ),
      ),
    );
  }

  /// One failed service in the compare list: the same row, its attribution
  /// inert, and where the text would be either the install notice or the
  /// reason the service gave.
  Widget _buildFailedRow(BuildContext context, TranslationResultRecord record) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final failure = _failureOf(record);
    final serviceId = record.translationServiceId;
    final index = _serviceIndex(serviceId);
    final bodyStyle = tokens.typography.cjkStyle(
      fontSize: 13,
      height: 1.7,
      color: colors.fgSecondary,
    );

    return CandidateRow(
      name: failure.name,
      avatarLabel: failure.name.isEmpty
          ? '?'
          : failure.name.characters.first.toUpperCase(),
      avatarColor: kProviderAvatarColors[
          index < 0 ? 0 : index % kProviderAvatarColors.length],
      shortcut: failure.shortcut,
      child: failure.notInstalled != null
          ? MissingLanguageNote(missing: failure.notInstalled!)
          : Text(
              failure.reason,
              style: bodyStyle.copyWith(color: colors.dangerFg),
            ),
    );
  }
}

extension on TranslationResultRecord {
  String get translateServiceIdOrEmpty => translationServiceId ?? '';
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
    this.notInstalled,
  });

  final String name;
  final String reason;
  final String? shortcut;

  /// Set when the system translator lacks the language files for the pair —
  /// the one failure the card can point at a fix for.
  final SystemLanguageNotInstalled? notInstalled;
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
            failure.notInstalled != null
                ? MissingLanguageText.sentence(failure.notInstalled!)
                : failure.reason,
            style: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1.7,
              color: colors.fgSecondary,
            ),
          ),
          const SizedBox(height: 7),
          if (failure.notInstalled != null)
            Button(
              variant: ButtonVariant.quiet,
              onPressed: openTranslationLanguagesSettings,
              child: Text(t.mini_translator.result.open_system_settings),
            )
          else
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
