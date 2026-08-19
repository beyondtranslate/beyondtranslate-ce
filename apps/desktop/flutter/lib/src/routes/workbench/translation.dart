import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge, TextField;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/history_store.dart';
import '../../services/runtime.dart'
    show HistoryEntryInput, HistoryOrigin, InputSubmitMode;
import '../../services/settings_store.dart';
import '../../services/workbench_translation_controller.dart';
import '../../theme/product_tokens.dart'
    show ProductTokens, ProductTypographyStyles;
import '../../utils/global_audio_player.dart';
import '../../utils/language_util.dart';
import '../../utils/shortcut_util.dart';
import '../../widgets/avatar.dart' show Avatar, AvatarSize;
import '../../widgets/blocks.dart'
    show HighlightBlock, HighlightRule, HighlightTone;
import '../../widgets/data_display.dart' show DetailBlock;
import '../../widgets/language_selector.dart' show LanguageSelector;
import '../../widgets/negative_vertical_margin.dart'
    show NegativeVerticalMargin;
import '../../widgets/text_field.dart' show TextField;
import '../../widgets/translation_text.dart';
import '../../widgets/ui.dart'
    show
        Aside,
        Badge,
        BadgeSize,
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        Kbd,
        KbdSize,
        Label,
        LabelTone,
        Pressable,
        SidebarCard,
        kTransitionDuration;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import '../settings/services.dart' show ServicesSettingsPage;
import 'index.dart' show workbenchTextHandoff;

/// 翻译 — the deck's TranslateView: the source block over the preferred
/// translation, the other services behind a 对比 toggle, and the information
/// aside on the right.
class WorkbenchTranslationPage extends StatefulWidget {
  const WorkbenchTranslationPage({super.key});

  @override
  State<WorkbenchTranslationPage> createState() =>
      _WorkbenchTranslationPageState();
}

class _WorkbenchTranslationPageState extends State<WorkbenchTranslationPage> {
  final WorkbenchTranslationController _controller =
      WorkbenchTranslationController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// 其他服务 — collapsed by default, like the mini translator's 对比 list.
  bool _expanded = false;
  bool _copied = false;
  bool _starred = false;
  final TranslationHistorySession _historySession = TranslationHistorySession(
    origin: HistoryOrigin.workbench,
  );
  Timer? _copiedTimer;

  /// In-place editing of the preferred translation.
  bool _editing = false;
  final TextEditingController _draftController = TextEditingController();

  /// The saved manual edit; shown with a 我改过 badge until the next query.
  String? _override;

  /// 命中术语 — open by default; the aside's one foldable section.
  bool _termsOpen = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
    workbenchTextHandoff.addListener(_handleHandoff);
    // 提交方式 is edited in the settings window; the runtime broadcasts the
    // change to every handle, so the box picks up its new key without a
    // reopen.
    settingsStore.addListener(_refresh);
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize();
    if (!mounted) return;
    _handleHandoff();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    workbenchTextHandoff.removeListener(_handleHandoff);
    settingsStore.removeListener(_refresh);
    _controller
      ..removeListener(_refresh)
      ..dispose();
    _textController.dispose();
    _draftController.dispose();
    _focusNode.dispose();
    _copiedTimer?.cancel();
    super.dispose();
  }

  /// A manual edit belongs to one query; requerying drops it.
  Future<void> _submit() async {
    final source = _controller.text.trim();
    if (_historySession.beginSource(source)) _starred = false;
    setState(() {
      _editing = false;
      _override = null;
    });
    await _controller.submit();
    await _saveHistory(edited: false);
  }

  Future<void> _saveHistory({required bool edited}) async {
    final result = _controller.selectedResult;
    final translation = _override ?? result?.text ?? '';
    final source = _controller.text.trim();
    if (source.isEmpty || translation.trim().isEmpty || result == null) return;
    final serviceName = result.service.name.trim().isEmpty
        ? result.service.id
        : result.service.name.trim();
    final entry = await _historySession.save(
      HistoryEntryInput(
        source: source,
        translation: translation,
        sourceLanguage:
            _controller.detectedLanguage ?? _controller.sourceLanguage,
        targetLanguage: _controller.effectiveTargetLanguage,
        serviceId: result.service.id,
        serviceName: serviceName,
        origin: HistoryOrigin.workbench,
        edited: edited,
      ),
    );
    if (!mounted || entry == null) return;
    setState(() {
      _starred = entry.favorite;
    });
  }

  Future<void> _selectService(String serviceId) async {
    setState(() {
      _editing = false;
      _override = null;
    });
    _controller.selectService(serviceId);
    await _saveHistory(edited: false);
  }

  Future<void> _toggleFavorite() async {
    if (_historySession.entryId == null) {
      await _saveHistory(edited: _override != null);
    }
    final entry = await _historySession.toggleFavorite();
    if (mounted && entry != null) setState(() => _starred = entry.favorite);
  }

  Future<void> _saveManualEdit() async {
    final draft = _draftController.text.trim();
    setState(() {
      _override = draft.isEmpty ? null : draft;
      _editing = false;
    });
    await _saveHistory(edited: _override != null);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  /// Picking a language re-runs the standing query, as it does in the mini
  /// translator — the result on screen belongs to the pair you just left.
  void _handleSourceChanged(String value) {
    _controller.setSourceLanguage(value);
    if (_controller.text.trim().isNotEmpty) _submit();
  }

  void _handleTargetChanged(String? value) {
    _controller.setTargetLanguage(value);
    if (_controller.text.trim().isNotEmpty) _submit();
  }

  void _handleManageCommonLanguages() {
    ServicesSettingsPage.pendingOpenCommonLanguages = true;
    context.go('/settings/services');
  }

  void _handleHandoff() {
    final value = workbenchTextHandoff.value;
    if (value == null || value.trim().isEmpty) return;
    _textController
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
    _controller.setText(value);
    workbenchTextHandoff.value = null;
    _submit();
  }

  void _copyResult(String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  /// What the detector says the source is in — the capsule's own 自动检测
  /// until a translation comes back and names it.
  String get _detectedLanguage =>
      _controller.detectedLanguage ?? _controller.sourceLanguage;

  /// Why a service came back empty, as it put it — a blanket "failed" gives
  /// the user nothing to act on, and the pane's job in this state is to point
  /// at the fix.
  static String _reasonOf(WorkbenchServiceResult result) {
    final reason = result.error?.toString().trim() ?? '';
    return reason.isEmpty ? t.mini_translator.result.unknown_error : reason;
  }

  /// Whether the selected service came back with nothing but an error.
  static bool _isFailed(WorkbenchServiceResult? result) =>
      result != null &&
      result.error != null &&
      result.text.isEmpty &&
      !result.loading;

  @override
  Widget build(BuildContext context) {
    final result = _controller.selectedResult;
    final others = [
      for (final entry in _controller.results)
        if (entry.service.id != result?.service.id) entry,
    ];

    // Collapsed, the preferred block runs to the pane's foot like an output
    // area; expanded (or with a dictionary card below), it takes its natural
    // height and hands the space over.
    final stretchPreferred = !_expanded && _definitionText == null;

    return CallbackShortcuts(
      bindings: {
        // ⌥⏎ 重译, as the source block's meta hint advertises.
        const SingleActivator(LogicalKeyboardKey.enter, alt: true): () {
          if (_controller.text.trim().isNotEmpty && !_controller.submitting) {
            _submit();
          }
        },
        // ⌥1…⌥9 promote the matching service, as hinted on the cards.
        for (var digit = 1; digit <= 9; digit++)
          SingleActivator(
            LogicalKeyboardKey(LogicalKeyboardKey.digit1.keyId + digit - 1),
            alt: true,
          ): () {
            final results = _controller.results;
            if (digit <= results.length) {
              _selectService(results[digit - 1].service.id);
            }
          },
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkbenchToolbar(
            title: t.workbench.translate,
            children: [
              // The mini translator's capsule, drawn at the same size: both
              // ends open the same native language menus, so the two windows
              // pick languages alike and look alike doing it.
              LanguageSelector(
                sourceLanguage: _controller.sourceLanguage,
                targetLanguage: _controller.targetLanguage,
                allowAutoTarget: true,
                commonLanguageCodes:
                    settingsStore.general.commonLanguages.isNotEmpty
                        ? settingsStore.general.commonLanguages
                        : defaultCommonLanguages(),
                onSourceChanged: _handleSourceChanged,
                onTargetChanged: _handleTargetChanged,
                onManageCommonLanguages: _handleManageCommonLanguages,
              ),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSourceBlock(context),
                              if (stretchPreferred)
                                Expanded(
                                  child: _buildPreferredBlock(
                                    context,
                                    result,
                                    stretch: true,
                                  ),
                                )
                              else
                                _buildPreferredBlock(context, result),
                              if (_definitionText != null)
                                DetailBlock(
                                  title: Text(
                                    _controller.dictionaryResult?.word ??
                                        _controller.text.trim(),
                                  ),
                                  subtitle: _pronunciation == null
                                      ? null
                                      : Text(_pronunciation!),
                                  child: Text(_definitionText!),
                                ),
                              _buildOthersSection(context, result, others),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (kTranslationAsideEnabled) _buildAside(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 原文 — the editable source block at the top of the pane: the label row
  /// with the ⌥⏎ 重译 hint, the input, and the deck's idle footer (⇧⏎ 换行
  /// beside the 翻译 button).
  Widget _buildSourceBlock(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final hasResult = (_controller.selectedResult?.text ?? '').isNotEmpty;
    // Read once: the field, the hint under it and the button's key chip all
    // have to name the same key.
    final submitMode = settingsStore.inputSubmitMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // The detected language rides on the heading, the target on the
              // translation's — the pair reads off the two blocks themselves,
              // and the capsule can stay on 自动检测 ⇄ 自动匹配.
              Label(
                child: Text(
                  '${t.workbench.translation.source} · ${getSourceDisplayName(_detectedLanguage)}',
                ),
              ),
              const Spacer(),
              // The deck draws this as a static hint; here it is a real
              // control, so it gets a padded hit target. `-my-1.5` keeps that
              // padding outside the label's line box instead of growing the
              // row, so the block's header stays 11px tall.
              if (hasResult) _buildRetryHint(context),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            focusNode: _focusNode,
            controller: _textController,
            // The block's own 22px inset is the text column; the field adds
            // none of its own, so what you type starts under 原文 and lines
            // up with the translation below.
            padding: EdgeInsets.zero,
            placeholder: t.workbench.translation.input_hint_translate_to(
              language: getLanguageName(_controller.effectiveTargetLanguage),
            ),
            placeholderStyle: tokens.typography.sourceStyle(
              color: colors.fgFaint,
            ),
            style: tokens.typography.sourceStyle(color: colors.fgMuted),
            minLines: 3,
            maxLines: 8,
            // 提交方式 decides which key sends the box; the field takes Enter
            // into its own hands only because it was told which one.
            submitOnEnter: submitMode == InputSubmitMode.enter,
            submitOnMetaEnter: submitMode == InputSubmitMode.commandEnter,
            onChanged: _controller.setText,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 10),
          // 翻译 belongs to the box you type in, not to the empty result
          // block below it.
          Row(
            children: [
              Text(
                t.workbench.translation.newline_hint(
                  key: inputNewlineShortcutGlyphs(submitMode),
                ),
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  height: 1,
                  color: colors.fgFaint,
                ),
              ),
              const Spacer(),
              Button(
                variant: ButtonVariant.primary,
                shortcut: Text(inputSubmitShortcutGlyphs(submitMode)),
                enabled: !_controller.submitting &&
                    _controller.text.trim().isNotEmpty,
                onPressed: _submit,
                child: Text(t.workbench.translation.button),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ⌥⏎ 重译 — the source block's trailing hint, drawn as a real control.
  Widget _buildRetryHint(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.chip);
    const padding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);

    return NegativeVerticalMargin(
      // Exactly the padding the hit target added, taken back out of the row.
      shrink: padding.vertical / 2,
      child: Pressable(
        onPressed: _controller.submitting ? null : _submit,
        borderRadius: radius,
        builder: (context, state) => Container(
          padding: padding,
          decoration: BoxDecoration(
            color: state.hovered ? colors.inset : null,
            borderRadius: radius,
          ),
          child: Text(
            '⌥⏎ ${t.mini_translator.result.retry}',
            style: tokens.typography.displayStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1,
              color: state.hovered ? colors.fgSubtle : colors.fgFaint,
            ),
          ),
        ),
      ),
    );
  }

  /// 首选译文 — the one accent block, in the deck's HighlightBlock shape.
  Widget _buildPreferredBlock(
    BuildContext context,
    WorkbenchServiceResult? result, {
    bool stretch = false,
  }) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final text = result?.text ?? '';
    final serviceName = result == null
        ? translation.main_translation
        : (result.service.name.isEmpty
            ? result.service.id
            : result.service.name);

    final targetName = getLanguageName(_controller.effectiveTargetLanguage);

    // 服务全部失效 keeps the result view's geometry: the preferred slot stays
    // where it is with its label, body and action row, and only its colour key
    // flips to danger. The compare toggle stays too, reworded: what it opens is
    // one card per service with its reason and the one thing that would fix it.
    if (_isFailed(result)) {
      final count = _controller.results.length;
      return HighlightBlock(
        rule: HighlightRule.top,
        tone: HighlightTone.danger,
        stretch: stretch,
        label: Text('$serviceName · ${translation.preferred} · $targetName'),
        meta: Text(t.mini_translator.result.no_result_meta(count: count)),
        actions: Row(
          children: [
            Button(
              variant: ButtonVariant.primary,
              onPressed: _submit,
              shortcut: const Text('⌥⏎'),
              child: Text(t.mini_translator.result.retry),
            ),
            const SizedBox(width: 7),
            Button(
              variant: ButtonVariant.secondary,
              onPressed: () => context.go('/settings/services'),
              child: Text(t.mini_translator.result.check_services),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                t.mini_translator.result.no_result_note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  height: 1,
                  color: colors.fgSubtle,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _CompareToggle(
              label: _expanded
                  ? t.mini_translator.result.collapse_reasons
                  : t.mini_translator.result.show_reasons(count: count),
              expanded: _expanded,
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
        child: Text(
          translation.failed_body,
          style: tokens.typography.translationStyle(color: colors.fgSubtle),
        ),
      );
    }

    final translating = result?.loading == true;
    final idle = text.isEmpty && !translating;

    final others = [
      for (final entry in _controller.results)
        if (entry.service.id != result?.service.id) entry,
    ];
    // 对比开关 — lives in the preferred block's action row, the mini's
    // placement. With every other service disabled it degrades to a note.
    final compareToggle = others.isNotEmpty
        ? _CompareToggle(
            expanded: _expanded,
            label: _expanded
                ? t.mini_translator.result.collapse_compare
                : t.mini_translator.result.compare_services(
                    count: others.length + 1,
                  ),
            onPressed: () => setState(() => _expanded = !_expanded),
          )
        : Text(
            translation.other_services_disabled,
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1,
              color: colors.fgFaint,
            ),
          );

    final shownText = _override ?? text;

    return HighlightBlock(
      // The accent rule fences the block from the 原文 above it — it is the
      // pane's divider, which is why 原文 draws no hairline of its own.
      rule: HighlightRule.top,
      stretch: stretch,
      label: Text('$serviceName · ${translation.preferred} · $targetName'),
      meta: translating
          ? Text(translation.translating)
          : _override != null
              ? Text(t.workbench.history_page.edited_flag)
              : idle
                  ? const Text('⌥Space 唤起迷你翻译器')
                  : null,
      // 翻译中不给动作行 —— 复制/朗读和对比开关都等结果落地再出现.
      actions: idle || translating
          ? null
          : _editing
              ? Row(
                  children: [
                    Button(
                      variant: ButtonVariant.primary,
                      onPressed: _saveManualEdit,
                      child: Text(t.common.ui.button.save),
                    ),
                    const SizedBox(width: 7),
                    Button(
                      variant: ButtonVariant.secondary,
                      onPressed: () => setState(() => _editing = false),
                      child: const Text('取消'),
                    ),
                    const Spacer(),
                    Text(
                      t.workbench.history_page.edit_history_hint,
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        height: 1,
                        color: colors.fgSubtle,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Button(
                      variant: ButtonVariant.primary,
                      enabled: shownText.isNotEmpty,
                      onPressed: () => _copyResult(shownText),
                      child: Text(
                        _copied ? translation.copied : translation.copy_result,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Button(
                      variant: ButtonVariant.secondary,
                      enabled: result?.audioUrl != null,
                      onPressed: () {
                        final url = result?.audioUrl;
                        if (url != null) {
                          globalAudioPlayer.play(UrlSource(url));
                        }
                      },
                      child: Text(translation.read),
                    ),
                    const SizedBox(width: 7),
                    Button(
                      variant: ButtonVariant.secondary,
                      onPressed: _toggleFavorite,
                      child: Text(
                        _starred
                            ? t.workbench.history_page.favorite_flag
                            : translation.favorite,
                      ),
                    ),
                    const Spacer(),
                    Button(
                      variant: ButtonVariant.plain,
                      onPressed: () {
                        _draftController.text = shownText;
                        setState(() => _editing = true);
                      },
                      child: Text(t.common.ui.button.edit),
                    ),
                    const SizedBox(width: 7),
                    compareToggle,
                  ],
                ),
      child: idle
          ? Text(
              translation.empty,
              style: tokens.typography.translationStyle(color: colors.fgFaint),
            )
          : translating
              ? const _TranslationSkeleton()
              : _editing
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.window,
                        border: Border.all(color: colors.accent),
                        borderRadius: BorderRadius.circular(tokens.radii.box),
                        boxShadow: [
                          BoxShadow(color: colors.accentRing, spreadRadius: 3),
                        ],
                      ),
                      child: TextField(
                        controller: _draftController,
                        // The box around it already carries the inset.
                        padding: EdgeInsets.zero,
                        style: tokens.typography
                            .translationStyle(color: colors.fg),
                        // `rows={3}` in the deck.
                        minLines: 3,
                        maxLines: 8,
                      ),
                    )
                  : _override != null
                      ? Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '$_override '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Badge(
                                  size: BadgeSize.xs,
                                  child: Text(
                                    t.workbench.history_page.edited_flag,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          style: tokens.typography
                              .translationStyle(color: colors.fg),
                        )
                      : TranslationText(
                          text,
                          style: tokens.typography
                              .translationStyle(color: colors.fg),
                        ),
    );
  }

  /// 展开对比 — candidate service cards stacked under the preferred block,
  /// the mini translator's compare list.
  ///
  /// 服务全部失效 folds its 失效清单 away behind the same toggle, so a service
  /// looks the same whether it answered or not: avatar and name where they
  /// always are, the ⌥n hint still live, and the body a reason instead of a
  /// translation.
  Widget _buildOthersSection(
    BuildContext context,
    WorkbenchServiceResult? preferred,
    List<WorkbenchServiceResult> others,
  ) {
    if (!_expanded) return const SizedBox.shrink();
    final failed = _isFailed(preferred);
    final entries = failed ? _controller.results : others;
    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _buildServiceCard(context, entries[i], failed: failed),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    WorkbenchServiceResult result, {
    bool failed = false,
  }) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final name =
        result.service.name.isEmpty ? result.service.id : result.service.name;
    // ⌥n hint and avatar colour follow the service's position in the full
    // list — the same order the deck numbers its cards.
    final index = _controller.results.indexWhere(
      (entry) => entry.service.id == result.service.id,
    );
    final avatarColors = [
      ProductTokens.providerBuiltin,
      ProductTokens.providerClaude,
      ProductTokens.providerDeepl,
      ProductTokens.providerDict,
    ];

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
              Avatar(
                size: AvatarSize.xs,
                label: name.characters.first.toUpperCase(),
                color:
                    avatarColors[index < 0 ? 0 : index % avatarColors.length],
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Label(tone: LabelTone.subtle, child: Text(name)),
              ),
              if (index >= 0 && index < 9)
                Kbd('⌥${index + 1}', size: KbdSize.sm),
            ],
          ),
          const SizedBox(height: 5),
          if (failed)
            Text(
              _reasonOf(result),
              style: tokens.typography.sansStyle(
                fontSize: 12,
                height: 1.7,
                color: colors.fgSecondary,
              ),
            )
          else if (result.loading)
            Text(
              translation.translating,
              style: tokens.typography.cjkStyle(
                fontSize: 13,
                height: 1.75,
                color: colors.fgFaint,
              ),
            )
          else if (result.error != null)
            Text(
              translation.service_unavailable,
              style: tokens.typography.cjkStyle(
                fontSize: 13,
                height: 1.75,
                color: colors.dangerFg,
              ),
            )
          else
            TranslationText(
              result.text.isEmpty ? translation.waiting : result.text,
              style: tokens.typography.cjkStyle(
                fontSize: 13,
                height: 1.75,
                color: colors.fgSecondary,
              ),
            ),
          if (failed) ...[
            const SizedBox(height: 7),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Button(
                variant: ButtonVariant.quiet,
                onPressed: () => context.go('/settings/services'),
                child: Text(t.mini_translator.result.check_services),
              ),
            ),
          ] else if (result.text.isNotEmpty) ...[
            const SizedBox(height: 7),
            Button(
              variant: ButtonVariant.quiet,
              onPressed: () => _selectService(result.service.id),
              child: Text(t.mini_translator.result.set_preferred),
            ),
          ],
        ],
      ),
    );
  }

  /// 右栏 — 命中术语 / 质量信号 / 快捷键, mirroring the deck's Aside.
  Widget _buildAside(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final hint = tokens.typography.sansStyle(
      fontSize: 12,
      height: 1.7,
      color: colors.fgFaint,
    );

    return Aside(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 命中术语 folds away, as in the deck — the aside's one
            // foldable section.
            Pressable(
              onPressed: () => setState(() => _termsOpen = !_termsOpen),
              isButton: false,
              builder: (context, state) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: tokens.typography.labelStyle(
                      color: state.hovered ? colors.fgTertiary : colors.fgFaint,
                    ),
                    child: Text(translation.terms),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _termsOpen ? 0 : -0.25,
                    duration: kTransitionDuration,
                    child: Icon(
                      FluentIcons.chevron_down_20_regular,
                      size: 14,
                      color: state.hovered ? colors.fgTertiary : colors.fgFaint,
                    ),
                  ),
                ],
              ),
            ),
            if (_termsOpen) ...[
              const SizedBox(height: 10),
              Text(translation.terms_hint, style: hint),
            ],
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(tone: LabelTone.faint, child: Text(translation.quality)),
            const SizedBox(height: 10),
            Text(translation.quality_hint, style: hint),
          ],
        ),
        SidebarCard(
          label: Text(translation.shortcuts),
          children: [
            Text(
              '${t.workbench.status.shortcuts}\n'
              '⌥⏎ ${t.mini_translator.result.retry} · '
              '⌥1-9 ${t.mini_translator.result.set_preferred}',
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 1.8,
                color: colors.fgTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? get _definitionText {
    final response = _controller.dictionaryResult;
    if (response == null) return null;
    if (response.translations.isNotEmpty) {
      return response.translations.map((item) => item.text).join('；');
    }
    final definitions = response.definitions;
    if (definitions == null || definitions.isEmpty) return response.tip;
    return definitions
        .expand((definition) => definition.values ?? const <String>[])
        .join('；');
  }

  String? get _pronunciation {
    final pronunciations = _controller.dictionaryResult?.pronunciations;
    if (pronunciations == null || pronunciations.isEmpty) return null;
    return pronunciations.first.phoneticSymbol;
  }
}

/// The 对比 N 个服务 / 收起对比 pill — same control as the mini translator's.
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
        height: 18,
        padding: const EdgeInsets.symmetric(horizontal: 9),
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

/// Three shimmering lines standing in for the translation being fetched.
class _TranslationSkeleton extends StatefulWidget {
  const _TranslationSkeleton();

  @override
  State<_TranslationSkeleton> createState() => _TranslationSkeletonState();
}

class _TranslationSkeletonState extends State<_TranslationSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    lowerBound: 0.5,
    upperBound: 1,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final line = colors.accent.withValues(alpha: 0.2);

    Widget bar(double widthFactor) => FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: widthFactor,
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              color: line,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );

    return FadeTransition(
      opacity: _controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            bar(1),
            const SizedBox(height: 10),
            bar(0.92),
            const SizedBox(height: 10),
            bar(0.64),
          ],
        ),
      ),
    );
  }
}
