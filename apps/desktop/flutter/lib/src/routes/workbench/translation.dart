import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge, TextField;
import 'package:flutter/services.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show InputSubmitMode;
import '../../services/settings_store.dart';
import '../../services/workbench_translation_controller.dart';
import '../../utils/global_audio_player.dart';
import '../../utils/language_util.dart';
import '../../widgets/text_field.dart' show TextField;
import '../../widgets/ui.dart'
    show
        Aside,
        Avatar,
        AvatarSize,
        Badge,
        BadgeSize,
        Button,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles,
        DetailBlock,
        HighlightBlock,
        Kbd,
        KbdSize,
        Label,
        LabelTone,
        Pressable,
        SidebarCard,
        SwapPair,
        kTransitionDuration;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import 'index.dart' show workbenchTextHandoff;

/// 翻译 — the deck's TranslateView: the source block over the preferred
/// translation, the other engines behind a 对比 toggle, and the information
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

  /// 其他引擎 — collapsed by default, like the mini translator's 对比 list.
  bool _expanded = false;
  bool _copied = false;
  bool _starred = false;
  Timer? _copiedTimer;

  /// 编辑并记为偏好 — the in-place edit of the preferred translation.
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
  void _submit() {
    setState(() {
      _editing = false;
      _override = null;
      _starred = false;
    });
    _controller.submit();
  }

  void _refresh() {
    if (mounted) setState(() {});
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

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }
    final submitWithEnter =
        settingsStore.inputSubmitMode == InputSubmitMode.enter;
    final submitWithCommand =
        settingsStore.inputSubmitMode == InputSubmitMode.commandEnter &&
            HardwareKeyboard.instance.isMetaPressed;
    if (!submitWithEnter && !submitWithCommand) {
      return KeyEventResult.ignored;
    }
    _submit();
    return KeyEventResult.handled;
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

  @override
  Widget build(BuildContext context) {
    final detected = _controller.detectedLanguage;
    final result = _controller.selectedResult;
    final others = [
      for (final entry in _controller.results)
        if (entry.service.id != result?.service.id) entry,
    ];

    // Collapsed, the preferred block runs to the pane's foot like an output
    // area; expanded (or with a dictionary card below), it takes its natural
    // height and hands the space over.
    final stretchPreferred =
        !_expanded && _definitionText == null && result?.error == null;

    return CallbackShortcuts(
      bindings: {
        // ⌥⏎ 重译, as the source block's meta hint advertises.
        const SingleActivator(LogicalKeyboardKey.enter, alt: true): () {
          if (_controller.text.trim().isNotEmpty && !_controller.submitting) {
            _submit();
          }
        },
        // ⌥1…⌥9 promote the matching engine, as hinted on the cards.
        for (var digit = 1; digit <= 9; digit++)
          SingleActivator(
            LogicalKeyboardKey(LogicalKeyboardKey.digit1.keyId + digit - 1),
            alt: true,
          ): () {
            final results = _controller.results;
            if (digit <= results.length) {
              _controller.selectEngine(results[digit - 1].service.id);
            }
          },
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkbenchToolbar(
            title: t.workbench.translate,
            children: [
              const SizedBox(width: 4),
              SwapPair(
                start: detected == null
                    ? getSourceDisplayName(_controller.sourceLanguage)
                    : getLanguageName(detected),
                end: getLanguageName(_controller.targetLanguage),
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
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
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
                _buildAside(context),
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

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Label(child: Text(t.workbench.translation.source)),
              const Spacer(),
              // The deck draws this as a static hint; here it is a real
              // control, so it gets a padded hit target.
              if (hasResult)
                Pressable(
                  onPressed: _controller.submitting ? null : _submit,
                  borderRadius: BorderRadius.circular(tokens.radii.chip),
                  builder: (context, state) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: state.hovered ? colors.inset : null,
                      borderRadius: BorderRadius.circular(tokens.radii.chip),
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
            ],
          ),
          const SizedBox(height: 10),
          Focus(
            onKeyEvent: _handleKeyEvent,
            child: TextField(
              focusNode: _focusNode,
              controller: _textController,
              placeholder: t.workbench.translation.input_hint_translate_to(
                language: getLanguageName(_controller.targetLanguage),
              ),
              placeholderStyle:
                  tokens.typography.sourceStyle(color: colors.fgFaint),
              style: tokens.typography.sourceStyle(color: colors.fgMuted),
              minLines: 3,
              maxLines: 8,
              textInputAction:
                  settingsStore.inputSubmitMode == InputSubmitMode.enter
                      ? TextInputAction.done
                      : TextInputAction.newline,
              onChanged: _controller.setText,
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(height: 10),
          // 翻译 belongs to the box you type in, not to the empty result
          // block below it.
          Row(
            children: [
              if (settingsStore.inputSubmitMode == InputSubmitMode.enter)
                Text(
                  '⇧⏎ 换行',
                  style: tokens.typography.sansStyle(
                    fontSize: 11,
                    height: 1,
                    color: colors.fgFaint,
                  ),
                ),
              const Spacer(),
              Button(
                variant: ButtonVariant.primary,
                shortcut: const Text('⏎'),
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

  /// 首选译文 — the one accent block, in the deck's HighlightBlock shape.
  Widget _buildPreferredBlock(
    BuildContext context,
    WorkbenchEngineResult? result, {
    bool stretch = false,
  }) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final text = result?.text ?? '';
    final engineName = result == null
        ? translation.main_translation
        : (result.service.name.isEmpty
            ? result.service.id
            : result.service.name);

    // 三个引擎都失败 — the deck's error state: callout with 重试.
    final failed = result != null &&
        result.error != null &&
        text.isEmpty &&
        !result.loading;
    if (failed) {
      return Container(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Callout(
              tone: CalloutTone.danger,
              action: Button(
                variant: ButtonVariant.primary,
                onPressed: _submit,
                child: Text(t.mini_translator.result.retry),
              ),
              child: Text(translation.failed),
            ),
            const SizedBox(height: 10),
            Text(
              t.mini_translator.result.no_result_note,
              style: tokens.typography.sansStyle(
                fontSize: 12,
                height: 1.7,
                color: colors.fgSubtle,
              ),
            ),
          ],
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
    // placement. With every other engine disabled it degrades to a note.
    final compareToggle = others.isNotEmpty
        ? _CompareToggle(
            expanded: _expanded,
            engineCount: others.length + 1,
            onPressed: () => setState(() => _expanded = !_expanded),
          )
        : Text(
            translation.other_engines_disabled,
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1,
              color: colors.fgFaint,
            ),
          );

    final shownText = _override ?? text;

    return HighlightBlock(
      stretch: stretch,
      label: Text('$engineName · ${translation.preferred}'),
      meta: translating
          ? Text(translation.translating)
          : _override != null
              ? const Text('已记为偏好')
              : idle
                  ? const Text('⌥Space 唤起迷你翻译器')
                  : null,
      actions: idle
          ? null
          : translating
              ? Row(children: [compareToggle])
              : _editing
                  ? Row(
                      children: [
                        Button(
                          variant: ButtonVariant.primary,
                          onPressed: () => setState(() {
                            final draft = _draftController.text.trim();
                            _override = draft.isEmpty ? null : draft;
                            _editing = false;
                          }),
                          child: const Text('保存并记为偏好'),
                        ),
                        const SizedBox(width: 7),
                        Button(
                          variant: ButtonVariant.secondary,
                          onPressed: () => setState(() => _editing = false),
                          child: const Text('取消'),
                        ),
                        const Spacer(),
                        Text(
                          '保存后同一术语的后续段落沿用你的写法',
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
                            _copied
                                ? translation.copied
                                : translation.copy_result,
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
                          onPressed: () => setState(() => _starred = !_starred),
                          child: Text(_starred ? '已收藏' : translation.favorite),
                        ),
                        const Spacer(),
                        Button(
                          variant: ButtonVariant.plain,
                          onPressed: () {
                            _draftController.text = shownText;
                            setState(() => _editing = true);
                          },
                          child: const Text('编辑并记为偏好'),
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
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                        style: tokens.typography
                            .translationStyle(color: colors.fg),
                        minLines: 2,
                        maxLines: 8,
                      ),
                    )
                  : _override != null
                      ? Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '$_override '),
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Badge(
                                  size: BadgeSize.xs,
                                  child: Text('我改过'),
                                ),
                              ),
                            ],
                          ),
                          style: tokens.typography
                              .translationStyle(color: colors.fg),
                        )
                      : SelectableText(
                          text,
                          style: tokens.typography
                              .translationStyle(color: colors.fg),
                        ),
    );
  }

  /// 展开对比 — candidate engine cards stacked under the preferred block,
  /// the mini translator's compare list.
  Widget _buildOthersSection(
    BuildContext context,
    WorkbenchEngineResult? preferred,
    List<WorkbenchEngineResult> others,
  ) {
    if (!_expanded || others.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < others.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _buildEngineCard(context, others[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildEngineCard(
    BuildContext context,
    WorkbenchEngineResult result,
  ) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final translation = t.workbench.translation;
    final name =
        result.service.name.isEmpty ? result.service.id : result.service.name;
    // ⌥n hint and avatar colour follow the engine's position in the full
    // list — the same order the deck numbers its cards.
    final index = _controller.results
        .indexWhere((entry) => entry.service.id == result.service.id);
    final avatarColors = [
      colors.engineBuiltin,
      colors.engineClaude,
      colors.engineDeepl,
      colors.engineDict,
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
                child: Label(
                  tone: LabelTone.subtle,
                  child: Text(name),
                ),
              ),
              if (index >= 0 && index < 9)
                Kbd('⌥${index + 1}', size: KbdSize.sm),
            ],
          ),
          const SizedBox(height: 5),
          if (result.loading)
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
            SelectableText(
              result.text.isEmpty ? translation.waiting : result.text,
              style: tokens.typography.cjkStyle(
                fontSize: 13,
                height: 1.75,
                color: colors.fgSecondary,
              ),
            ),
          if (result.text.isNotEmpty) ...[
            const SizedBox(height: 7),
            Button(
              variant: ButtonVariant.quiet,
              onPressed: () => _controller.selectEngine(result.service.id),
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
                  Label(
                    tone: LabelTone.faint,
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

/// The 对比 N 个引擎 / 收起对比 pill — same control as the mini translator's.
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
    final label = expanded
        ? t.mini_translator.result.collapse_compare
        : t.mini_translator.result.compare_engines(count: engineCount);

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
    lowerBound: 0.4,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5), child: bar(1)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: bar(0.92)),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: bar(0.64)),
        ],
      ),
    );
  }
}
