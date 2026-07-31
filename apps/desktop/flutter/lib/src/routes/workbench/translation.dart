import 'package:audioplayers/audioplayers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Divider;
import 'package:flutter/services.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show InputSubmitMode;
import '../../services/settings_store.dart';
import '../../services/workbench_translation_controller.dart';
import '../../utils/global_audio_player.dart';
import '../../utils/language_util.dart';
import '../../widgets/definition_card.dart';
import '../../widgets/engine_selector.dart';
import '../../widgets/icon_action_button.dart';
import '../../widgets/language_pair.dart';
import '../../widgets/translation_pane.dart';
import '../../widgets/ui.dart'
    show
        Aside,
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        Label,
        Spinner,
        SpinnerSize;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import 'index.dart' show workbenchTextHandoff;

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
    _focusNode.dispose();
    super.dispose();
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
    _controller.submit();
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
    _controller.submit();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final result = _controller.selectedResult;
    final translatedText = result?.text ?? '';
    final detected = _controller.detectedLanguage;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _Toolbar(
                controller: _controller,
                detectedLanguage:
                    detected == null ? null : getLanguageName(detected),
                onTranslate: _controller.submit,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Focus(
                        onKeyEvent: _handleKeyEvent,
                        child: TranslationPane(
                          label: t.workbench.translation.source,
                          language: detected == null
                              ? getSourceDisplayName(_controller.sourceLanguage)
                              : getLanguageName(detected),
                          text: _controller.text,
                          editable: true,
                          controller: _textController,
                          focusNode: _focusNode,
                          hintText: t.workbench.translation.input_hint,
                          onChanged: _controller.setText,
                          onSubmitted: (_) => _controller.submit(),
                          submitOnEnter: settingsStore.inputSubmitMode ==
                              InputSubmitMode.enter,
                          submitOnMetaEnter: settingsStore.inputSubmitMode ==
                              InputSubmitMode.commandEnter,
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: TranslationPane(
                        label: t.workbench.translation.target,
                        language: getLanguageName(_controller.targetLanguage),
                        text: translatedText.isNotEmpty
                            ? translatedText
                            : _resultPlaceholder(result),
                        highlighted: true,
                        trailing: _ResultActions(
                          text: translatedText,
                          audioUrl: result?.audioUrl,
                        ),
                        footer: _definitionText == null
                            ? null
                            : DefinitionCard(
                                term: _controller.dictionaryResult?.word ??
                                    _controller.text.trim(),
                                definition: _definitionText!,
                                pronunciation: _pronunciation ?? '',
                                outlined: false,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _EngineRail(controller: _controller),
      ],
    );
  }

  String _resultPlaceholder(WorkbenchEngineResult? result) {
    final translation = t.workbench.translation;
    if (_controller.loadingServices) return translation.loading_services;
    if (_controller.translationServices.isEmpty) return translation.no_services;
    if (result?.loading == true) return translation.translating;
    if (result?.error != null) return translation.failed;
    return translation.empty;
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

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.controller,
    required this.detectedLanguage,
    required this.onTranslate,
  });

  final WorkbenchTranslationController controller;
  final String? detectedLanguage;
  final VoidCallback onTranslate;

  @override
  Widget build(BuildContext context) {
    return WorkbenchToolbar(
      title: t.workbench.subtitle.translate,
      children: [
        const SizedBox(width: 4),
        LanguagePair(
          source: detectedLanguage ??
              getSourceDisplayName(controller.sourceLanguage),
          target: getLanguageName(controller.targetLanguage),
          note: detectedLanguage != null
              ? t.workbench.translation.auto_detected
              : t.mini_translator.language.auto_detect,
        ),
        const Spacer(),
        Button(
          variant: ButtonVariant.primary,
          onPressed: controller.submitting || controller.text.trim().isEmpty
              ? null
              : onTranslate,
          child: controller.submitting
              ? const Spinner(size: SpinnerSize.sm, onAccent: true)
              : Text(t.workbench.translation.button),
        ),
      ],
    );
  }
}

class _ResultActions extends StatelessWidget {
  const _ResultActions({
    required this.text,
    required this.audioUrl,
  });

  final String text;
  final String? audioUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconActionButton(
          icon: FluentIcons.speaker_2_20_regular,
          tooltip: t.workbench.translation.read,
          onPressed: audioUrl == null
              ? null
              : () => globalAudioPlayer.play(UrlSource(audioUrl!)),
        ),
        IconActionButton(
          icon: FluentIcons.copy_20_regular,
          tooltip: t.workbench.translation.copy,
          onPressed: text.isEmpty
              ? null
              : () => Clipboard.setData(ClipboardData(text: text)),
        ),
        IconActionButton(
          icon: FluentIcons.bookmark_20_regular,
          tooltip: t.workbench.translation.favorite_unavailable,
          onPressed: null,
        ),
      ],
    );
  }
}

class _EngineRail extends StatelessWidget {
  const _EngineRail({required this.controller});

  final WorkbenchTranslationController controller;

  @override
  Widget build(BuildContext context) {
    final options = controller.results
        .map(
          (result) => EngineOption(
            id: result.service.id,
            name: result.service.name.isEmpty
                ? result.service.id
                : result.service.name,
            tag: result.service.id == controller.selectedEngineId
                ? t.workbench.translation.main_translation
                : null,
            preview: result.loading
                ? t.workbench.translation.translating
                : result.error != null
                    ? t.workbench.translation.service_unavailable
                    : result.text.isEmpty
                        ? t.workbench.translation.waiting
                        : result.text.replaceAll('\n', ' '),
          ),
        )
        .toList(growable: false);

    return Aside(
      children: [
        Label(child: Text(t.workbench.translation.engine_compare)),
        if (controller.loadingServices)
          const Center(child: Spinner())
        else if (options.isEmpty)
          Text(
            t.workbench.translation.no_services,
            textAlign: TextAlign.center,
            style: context.typography.sansStyle(
              fontSize: 11,
              color: context.colors.fgSubtle,
            ),
          )
        else
          EngineSelector(
            engines: options,
            selectedId: controller.selectedEngineId ?? options.first.id,
            onSelected: controller.selectEngine,
          ),
      ],
    );
  }
}
