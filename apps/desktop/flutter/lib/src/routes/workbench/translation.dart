import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge, IconButton, TextField;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/app_windows.dart' show workbenchTextHandoff;
import '../../services/history_store.dart';
import '../../services/runtime.dart' show HistoryEntryInput, InputSubmitMode;
import '../../services/settings_store.dart';
import '../../services/system_translation.dart';
import '../../services/workbench_translation_controller.dart';
import '../../theme/product_tokens.dart' show ProductTypographyStyles;
import '../../utils/language_util.dart';
import '../../utils/shortcut_util.dart';
import '../../widgets/avatar.dart' show Avatar, AvatarSize;
import '../../widgets/block_heading.dart';
import '../../widgets/blocks.dart'
    show HighlightBlock, HighlightRule, HighlightTone;
import '../../widgets/candidate_row.dart'
    show CandidateRow, kProviderAvatarColors;
import '../../widgets/data_display.dart' show DetailBlock;
import '../../widgets/language_selector.dart' show LanguageSelector;
import '../../widgets/missing_language.dart';
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
        IconButton,
        Kbd,
        KbdSize,
        Label,
        LabelTone,
        Pressable,
        SidebarCard,
        kTransitionDuration;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import '../settings/provider_meta.dart'
    show isDefaultTranslationService, serviceDisplayName;
import '../settings/services.dart' show ServicesSettingsPage;

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

  /// 失效清单 — the failed services' reasons, folded by default.
  bool _expanded = false;

  /// 对比 — per target: the candidates are other services' renderings into
  /// that language, so each target's block folds out its own list, and
  /// opening one leaves the others alone.
  final Set<String> _compareOpen = {};

  /// Which target's 复制译文 just fired — that button reads 已复制 for a beat.
  String? _copiedTarget;
  bool _starred = false;
  final TranslationHistorySession _historySession = TranslationHistorySession();
  Timer? _copiedTimer;

  /// In-place editing of the preferred translation — one target at a time.
  String? _editingTarget;
  final TextEditingController _draftController = TextEditingController();

  /// The saved manual edit per target; shown with a 我改过 badge until the
  /// next query.
  final Map<String, String> _override = {};

  /// 命中术语 — open by default; the aside's one foldable section.
  bool _termsOpen = true;

  /// Tracks the branch's [TickerMode] so returning to 翻译 from another
  /// sidebar destination puts the caret back in the source box. The page
  /// itself stays mounted offstage in the shell's indexed stack.
  bool _visibleInShell = true;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final visible = TickerMode.valuesOf(context).enabled;
    if (visible && !_visibleInShell) _focusNode.requestFocus();
    _visibleInShell = visible;
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
      _editingTarget = null;
      _override.clear();
    });
    await _controller.submit();
    await _saveHistory(edited: false);
  }

  /// History keeps one translation per query — the first target's, which is
  /// the whole story unless 自动匹配 landed on several.
  Future<void> _saveHistory({required bool edited}) async {
    final result = _controller.selectedResult;
    final target = _controller.effectiveTargetLanguage;
    final translation = _override[target] ?? result?.output(target).text ?? '';
    final source = _controller.text.trim();
    if (source.isEmpty || translation.trim().isEmpty || result == null) return;
    final serviceName = serviceDisplayName(result.service).trim();
    final entry = await _historySession.save(
      HistoryEntryInput(
        source: source,
        translation: translation,
        sourceLanguage:
            _controller.detectedLanguage ?? _controller.sourceLanguage,
        targetLanguage: target,
        serviceId: result.service.id,
        serviceName: serviceName,
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
      _editingTarget = null;
      _override.clear();
    });
    _controller.selectService(serviceId);
    await _saveHistory(edited: false);
  }

  Future<void> _toggleFavorite() async {
    if (_historySession.entryId == null) {
      await _saveHistory(edited: _override.isNotEmpty);
    }
    final entry = await _historySession.toggleFavorite();
    if (mounted && entry != null) setState(() => _starred = entry.favorite);
  }

  Future<void> _saveManualEdit(String target) async {
    final draft = _draftController.text.trim();
    setState(() {
      if (draft.isEmpty) {
        _override.remove(target);
      } else {
        _override[target] = draft;
      }
      _editingTarget = null;
    });
    await _saveHistory(edited: _override.isNotEmpty);
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

  void _copyResult(String target, String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copiedTarget = target);
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _copiedTarget = null);
    });
  }

  void _toggleCompare(String target) {
    setState(() {
      if (!_compareOpen.add(target)) _compareOpen.remove(target);
    });
  }

  /// What the detector says the source is in — the capsule's own 自动检测
  /// until a translation comes back and names it.
  String get _detectedLanguage =>
      _controller.detectedLanguage ?? _controller.sourceLanguage;

  /// 简体中文、日本語 — how the idle placeholder and the failed slot name the
  /// set of targets 自动匹配 resolved to.
  String get _targetList => _controller.effectiveTargetLanguages
      .map(getLanguageName)
      .join(t.workbench.translation.target_separator);

  /// Why a service came back empty, as it put it — a blanket "failed" gives
  /// the user nothing to act on, and the pane's job in this state is to point
  /// at the fix.
  static String _reasonOf(WorkbenchServiceResult result) {
    final reason = result.error?.toString().trim() ?? '';
    return reason.isEmpty ? t.mini_translator.result.unknown_error : reason;
  }

  /// Whether the selected service came back with nothing but errors — for
  /// every target it was asked for.
  static bool _isFailed(WorkbenchServiceResult? result) =>
      result != null &&
      result.outputs.values.isNotEmpty &&
      result.outputs.values.every(
        (output) => output.error != null && !output.hasText && !output.loading,
      );

  @override
  Widget build(BuildContext context) {
    final result = _controller.selectedResult;
    // 服务全部失效 — unless what failed is 系统翻译 lacking the language files,
    // which each target's own block reports, with the fix.
    final failed = _isFailed(result) &&
        SystemLanguageNotInstalled.of(result?.primary.error) == null;
    final targets = _controller.effectiveTargetLanguages;
    final stacked = targets.length > 1;

    // Collapsed, the last block runs to the pane's foot like an output area;
    // expanded (or with a dictionary card below), it takes its natural
    // height and hands the space over.
    final lastOpen = failed ? _expanded : _compareOpen.contains(targets.last);
    final stretchPreferred = !lastOpen && _definitionText == null;

    return CallbackShortcuts(
      bindings: {
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
                              if (failed)
                                if (stretchPreferred)
                                  Expanded(
                                    child: _buildFailedBlock(
                                      context,
                                      result!,
                                      stretch: true,
                                    ),
                                  )
                                else
                                  _buildFailedBlock(context, result!)
                              else
                                // 自动匹配 can resolve to more than one target
                                // — a specific rule and the 自动检测 fallback
                                // both apply — and the core translates into
                                // each. The pane stacks one preferred block
                                // per target instead of hiding the rest
                                // behind a switcher: both were asked for, so
                                // both stay on screen, and each keeps its
                                // own copy and edit state.
                                for (var i = 0; i < targets.length; i++)
                                  if (i == targets.length - 1 &&
                                      stretchPreferred)
                                    Expanded(
                                      child: _buildPreferredBlock(
                                        context,
                                        result,
                                        target: targets[i],
                                        index: i,
                                        last: true,
                                        stacked: stacked,
                                        stretch: true,
                                      ),
                                    )
                                  else
                                    _buildPreferredBlock(
                                      context,
                                      result,
                                      target: targets[i],
                                      index: i,
                                      last: i == targets.length - 1,
                                      stacked: stacked,
                                    ),
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
                              if (failed) _buildFailureList(context),
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

  /// 原文 — the editable source block at the top of the pane: the label row,
  /// the input, and the deck's idle footer (⇧⏎ 换行 beside the 翻译 button).
  Widget _buildSourceBlock(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
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
              // On 自动检测 the heading names the detected language, the
              // translation's the matched target — the resolved pair reads off
              // the blocks while the capsule stays on 自动检测 ⇄ 自动匹配. A
              // language chosen in the capsule is not repeated here.
              Flexible(
                child: Label(
                  child: BlockHeading(
                    sourceHeading(
                      _controller.text.trim().isEmpty
                          ? null
                          : getSourceDisplayName(_detectedLanguage),
                      detectedAutomatically:
                          isAutoSource(_controller.sourceLanguage),
                    ),
                  ),
                ),
              ),
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
              language: _targetList,
            ),
            placeholderStyle: tokens.typography.sourceStyle(
              color: colors.fgFaint,
            ),
            // 原文 is content you read against the translation: at fgMuted it
            // sat one step from its own caption, close enough that heading and
            // paragraph read as one grey.
            style: tokens.typography.sourceStyle(color: colors.fgSecondary),
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

  /// The heading over a translation block. The default service is never
  /// named — the language alone is enough when the answer came from the one
  /// you would expect; a promoted service trails as a qualifier, so you know
  /// what you switched to.
  BlockHeadingParts _heading(
    WorkbenchServiceResult? result,
    String target,
  ) {
    final named = result != null &&
            !isDefaultTranslationService(result.service, settingsStore.general)
        ? serviceDisplayName(result.service)
        : null;
    return translationHeading(
      target: target,
      serviceName: named,
      matched: _controller.targetLanguage == null,
    );
  }

  /// 服务全部失效 keeps the result view's geometry: the preferred slot stays
  /// where it is with its label, body and action row, and only its colour key
  /// flips to danger. The compare toggle stays too, reworded: what it opens is
  /// one card per service with its reason and the one thing that would fix it.
  Widget _buildFailedBlock(
    BuildContext context,
    WorkbenchServiceResult result, {
    bool stretch = false,
  }) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final count = _controller.results.length;

    return HighlightBlock(
      rule: HighlightRule.top,
      tone: HighlightTone.danger,
      stretch: stretch,
      label: BlockHeading(_heading(result, _targetList)),
      meta: Text(t.mini_translator.result.no_result_meta(count: count)),
      actions: Row(
        children: [
          Button(
            variant: ButtonVariant.primary,
            onPressed: _submit,
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

  /// 首选译文 — the accent block, in the deck's HighlightBlock shape, for one
  /// target. With several targets the blocks stack: the first carries the
  /// 2px accent rule, a further one shares the surface behind a neutral
  /// hairline, and 朗读/复制 ride on each block's attribution row while 编辑
  /// and 对比 stay each target's own. 收藏 belongs to the paragraph, so it
  /// sits once, at the foot of the set.
  Widget _buildPreferredBlock(
    BuildContext context,
    WorkbenchServiceResult? result, {
    required String target,
    required int index,
    required bool last,
    required bool stacked,
    bool stretch = false,
  }) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final output = result?.output(target);
    final text = output?.text ?? '';
    final targetName = getLanguageName(target);

    final translating = output?.loading == true;
    // 系统翻译 without this pair's language files: reason + fix, no text.
    final missing = output == null || translating || output.hasText
        ? null
        : SystemLanguageNotInstalled.of(output.error);
    final idle = text.isEmpty && !translating && missing == null;
    final open = _compareOpen.contains(target);
    final editing = _editingTarget == target;
    final copied = _copiedTarget == target;
    final override = _override[target];
    final shownText = override ?? text;

    final others = [
      for (final entry in _controller.results)
        if (entry.service.id != result?.service.id) entry,
    ];
    // 对比开关 — lives in the preferred block's action row, the mini's
    // placement. With every other service disabled it degrades to a note.
    final compareToggle = others.isNotEmpty
        ? _CompareToggle(
            expanded: open,
            label: open
                ? t.mini_translator.result.collapse_compare
                : t.mini_translator.result.compare_services(
                    count: others.length + 1,
                  ),
            onPressed: () => _toggleCompare(target),
          )
        : Text(
            translation.other_services_disabled,
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1,
              color: colors.fgFaint,
            ),
          );

    final editButton = Button(
      variant: ButtonVariant.plain,
      onPressed: () {
        _draftController.text = shownText;
        setState(() => _editingTarget = target);
      },
      child: Text(t.common.ui.button.edit),
    );
    final favoriteButton = Button(
      variant: ButtonVariant.secondary,
      onPressed: _toggleFavorite,
      child: Text(
        _starred
            ? t.workbench.history_page.favorite_flag
            : translation.favorite,
      ),
    );

    // With several blocks, 复制 rides on each block's attribution row as an
    // icon rather than repeating the full action row per target.
    final stackedMeta = stacked && !translating && !idle && missing == null;

    return HighlightBlock(
      // The accent rule fences the first block from the 原文 above it — it is
      // the pane's divider, which is why 原文 draws no hairline of its own.
      rule: index == 0 ? HighlightRule.top : HighlightRule.none,
      hairline: index > 0,
      // A missing language pair is a failed translation, so the slot takes
      // the danger key the way 服务全部失效 does.
      tone: missing != null ? HighlightTone.danger : HighlightTone.accent,
      stretch: stretch,
      metaControls: stackedMeta,
      label: BlockHeading(_heading(result, targetName)),
      meta: translating
          ? Text(translation.translating)
          : missing != null
              ? Text(t.mini_translator.result.language_missing_flag)
              : stackedMeta
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (override != null) ...[
                          Text(t.workbench.history_page.edited_flag),
                          const SizedBox(width: 10),
                        ],
                        IconButton(
                          label: copied
                              ? translation.copied
                              : translation.copy_result,
                          active: copied,
                          enabled: shownText.isNotEmpty,
                          icon: Icon(
                            copied
                                ? FluentIcons.checkmark_20_regular
                                : FluentIcons.copy_20_regular,
                          ),
                          onPressed: () => _copyResult(target, shownText),
                        ),
                      ],
                    )
                  : override != null
                      ? Text(t.workbench.history_page.edited_flag)
                      : null,
      // 翻译中不给动作行 —— 复制和对比开关都等结果落地再出现.
      actions: idle || translating
          ? null
          : missing != null
              // The slot keeps the result view's geometry, as 服务全部失效
              // does: the fix leads, retry follows.
              ? Row(
                  children: [
                    Button(
                      variant: ButtonVariant.primary,
                      onPressed: openTranslationLanguagesSettings,
                      child: Text(
                        t.mini_translator.result.open_system_settings,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Button(
                      variant: ButtonVariant.secondary,
                      shortcut: const Text('⌥⏎'),
                      onPressed: _submit,
                      child: Text(t.mini_translator.result.retry),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        t.mini_translator.result.language_missing_kept,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.typography.sansStyle(
                          fontSize: 11,
                          height: 1,
                          color: colors.fgSubtle,
                        ),
                      ),
                    ),
                    if (!stacked || last) ...[
                      const SizedBox(width: 10),
                      compareToggle,
                    ],
                  ],
                )
              : editing
                  ? Row(
                      children: [
                        Button(
                          variant: ButtonVariant.primary,
                          onPressed: () => _saveManualEdit(target),
                          child: Text(t.common.ui.button.save),
                        ),
                        const SizedBox(width: 7),
                        Button(
                          variant: ButtonVariant.secondary,
                          onPressed: () =>
                              setState(() => _editingTarget = null),
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
                  : stacked
                      // 编辑 and 对比 are this target's: the editing row unfolds
                      // here and the list opens under this block. 收藏 belongs
                      // to the paragraph, so it sits once, at the foot of the set.
                      ? Row(
                          children: [
                            if (last) favoriteButton,
                            const Spacer(),
                            editButton,
                            const SizedBox(width: 7),
                            compareToggle,
                          ],
                        )
                      : Row(
                          children: [
                            Button(
                              variant: ButtonVariant.primary,
                              enabled: shownText.isNotEmpty,
                              onPressed: () => _copyResult(target, shownText),
                              child: Text(
                                copied
                                    ? translation.copied
                                    : translation.copy_result,
                              ),
                            ),
                            const SizedBox(width: 7),
                            favoriteButton,
                            const Spacer(),
                            editButton,
                            const SizedBox(width: 7),
                            compareToggle,
                          ],
                        ),
      // 展开对比 — the other services, each target its own: listed are the
      // other services' renderings into this language. The list stays in
      // the block, on the same tinted surface; a separate grey band would
      // cut the output area into strips.
      expansion: open && !idle && !translating && others.isNotEmpty
          ? [
              for (final entry in others)
                _buildCandidateRow(context, entry, target),
            ]
          : null,
      child: idle
          ? Text(
              translation.empty,
              style: tokens.typography.translationStyle(color: colors.fgFaint),
            )
          : translating
              ? const _TranslationSkeleton()
              : missing != null
                  ? Text(
                      MissingLanguageText.body(missing),
                      style: tokens.typography
                          .translationStyle(color: colors.fgSubtle),
                    )
                  : editing
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colors.window,
                            border: Border.all(color: colors.accent),
                            borderRadius:
                                BorderRadius.circular(tokens.radii.box),
                            boxShadow: [
                              BoxShadow(
                                  color: colors.accentRing, spreadRadius: 3),
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
                      : override != null
                          ? Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: '$override '),
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

  /// ⌥n hint and avatar colour follow the service's position in the full
  /// list — the same order the deck numbers its cards.
  int _serviceIndex(WorkbenchServiceResult result) => _controller.results
      .indexWhere((entry) => entry.service.id == result.service.id);

  static String _serviceName(WorkbenchServiceResult result) =>
      serviceDisplayName(result.service);

  /// One other service's rendering into [target] — its row in that target's
  /// compare list.
  Widget _buildCandidateRow(
    BuildContext context,
    WorkbenchServiceResult result,
    String target,
  ) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final name = _serviceName(result);
    final index = _serviceIndex(result);
    final output = result.output(target);

    return CandidateRow(
      name: name,
      avatarLabel: name.characters.first.toUpperCase(),
      avatarColor: kProviderAvatarColors[
          index < 0 ? 0 : index % kProviderAvatarColors.length],
      shortcut: index >= 0 && index < 9 ? '⌥${index + 1}' : null,
      onPrefer: output.hasText ? () => _selectService(result.service.id) : null,
      child: output.loading
          ? Text(
              translation.translating,
              style: tokens.typography.cjkStyle(
                fontSize: 13,
                height: 1.7,
                color: colors.fgFaint,
              ),
            )
          : output.error != null && !output.hasText
              ? _buildErrorBody(context, output.error)
              : TranslationText(
                  output.hasText ? output.text : translation.waiting,
                  style: tokens.typography.cjkStyle(
                    fontSize: 13,
                    height: 1.7,
                    color: colors.fgSecondary,
                  ),
                ),
    );
  }

  /// What a service's compare row says when it answered with an error: the
  /// missing pair and the fix when the system translator lacks the language
  /// files, otherwise the deck's 服务暂不可用.
  Widget _buildErrorBody(BuildContext context, Object? error) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final missing = SystemLanguageNotInstalled.of(error);
    if (missing != null) return MissingLanguageNote(missing: missing);
    return Text(
      t.workbench.translation.service_unavailable,
      style: tokens.typography.cjkStyle(
        fontSize: 13,
        height: 1.7,
        color: colors.dangerFg,
      ),
    );
  }

  /// 失效清单 — the same cards as the compare list, folded away by the same
  /// toggle, so a service looks the same whether it answered or not: avatar
  /// and name where they always are, the shortcut still live (⌥1–3 still
  /// pick the preferred), the body a reason instead of a translation, and
  /// the foot the fix instead of 设为首选.
  Widget _buildFailureList(BuildContext context) {
    if (!_expanded) return const SizedBox.shrink();
    final entries = _controller.results;
    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            _buildFailureCard(context, entries[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildFailureCard(
      BuildContext context, WorkbenchServiceResult result) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final name = _serviceName(result);
    final index = _serviceIndex(result);
    final missing = SystemLanguageNotInstalled.of(result.error);

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
                color: kProviderAvatarColors[
                    index < 0 ? 0 : index % kProviderAvatarColors.length],
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
          Text(
            missing != null
                ? MissingLanguageText.sentence(missing)
                : _reasonOf(result),
            style: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1.7,
              color: colors.fgSecondary,
            ),
          ),
          const SizedBox(height: 7),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: missing != null
                ? Button(
                    variant: ButtonVariant.quiet,
                    onPressed: openTranslationLanguagesSettings,
                    child: Text(t.mini_translator.result.open_system_settings),
                  )
                : Button(
                    variant: ButtonVariant.quiet,
                    onPressed: () => context.go('/settings/services'),
                    child: Text(t.mini_translator.result.check_services),
                  ),
          ),
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
