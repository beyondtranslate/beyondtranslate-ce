import 'dart:async';

import 'package:flutter/widgets.dart' hide FormField;

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import '../../widgets/app_dialog.dart' show AppDialogHeader, DialogFrame;
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        Callout,
        CalloutTint,
        Checkbox,
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
        DialogTone,
        FormField,
        Pressable,
        SectionLabel,
        SectionLabelTone,
        Spinner,
        TextField,
        TextFieldState,
        ThemeDataBuildContextProps,
        WidgetSize;
import 'provider_meta.dart';

/// Where the connection test stands.
enum _ConnectionPhase { idle, testing, passed, failed }

/// 添加提供商 — the deck's two-step sheet: pick a provider type first (LLM
/// types lead, traditional ones sit in a quieter collapsed section below), then
/// configure it. 添加 stays out of reach until the connection has checked out.
///
/// Testing a connection means asking the real provider, and the engine only
/// knows providers that are in settings — so the sheet writes the provider
/// before its first test and takes it back out again if the flow is abandoned.
/// Everything the user sees is therefore a real answer from the endpoint they
/// typed, not a simulation.
class AddProviderDialog extends StatefulWidget {
  const AddProviderDialog({super.key});

  @override
  State<AddProviderDialog> createState() => _AddProviderDialogState();
}

class _AddProviderDialogState extends State<AddProviderDialog> {
  static const _kProbeText = 'Hello';

  /// Which half of the flow is showing.
  bool _configuring = false;

  ProviderType _type = ProviderType.anthropic;

  /// Collapsed unless the flow is already sitting on a traditional type.
  bool _traditionalOpen = false;

  final TextEditingController _idController = TextEditingController();
  Map<String, TextEditingController> _fieldControllers = {};

  _ConnectionPhase _phase = _ConnectionPhase.idle;
  String? _failureMessage;
  String? _passedMessage;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;

  /// Bumped whenever a test starts or is abandoned. A request that was still
  /// in flight when the user hit 取消 — or edited a field — must not land on
  /// the sheet afterwards, and there is no way to call the endpoint back.
  int _testRun = 0;

  /// The provisional provider this sheet wrote so it could be tested. Removed
  /// again unless the flow ends in 添加.
  String? _provisionalId;

  /// Set once 添加 has committed, so teardown leaves the provider alone.
  bool _committed = false;

  List<ProviderType> get _llmTypes =>
      kKnownProviderTypes.where(isLlmProviderType).toList(growable: false);

  List<ProviderType> get _traditionalTypes => kKnownProviderTypes
      .where((type) => !isLlmProviderType(type))
      .toList(growable: false);

  List<String> get _fieldKeys => kProviderFields[_type] ?? const <String>[];

  List<ServiceType> get _capabilities => visibleProviderCapabilities(_type);

  @override
  void dispose() {
    _ticker?.cancel();
    _idController.dispose();
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    // The route is going either way; if the flow never reached 添加, the
    // provisional provider must not outlive it.
    if (!_committed && _provisionalId != null) {
      unawaited(_removeProvisional(_provisionalId!));
    }
    super.dispose();
  }

  static Future<void> _removeProvisional(String providerId) async {
    try {
      await runtime.settings().deleteProvider(providerId: providerId);
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
    } catch (_) {
      // Nothing useful to say once the sheet is gone.
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Step 1 → step 2
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _enterConfig() async {
    // A generated id keeps two providers of the same type apart without
    // making the user invent a name before they have configured anything.
    var suggestion = '';
    try {
      suggestion = await runtime.settings().generateProviderId(
            providerType: providerTypeValue(_type),
          );
    } catch (_) {
      suggestion = providerTypeValue(_type);
    }
    if (!mounted) return;

    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    setState(() {
      _idController.text = suggestion;
      _fieldControllers = {
        for (final key in _fieldKeys) key: TextEditingController(),
      };
      _resetPhase();
      _configuring = true;
    });
  }

  Future<void> _back() async {
    final provisional = _provisionalId;
    _provisionalId = null;
    setState(() {
      _configuring = false;
      _resetPhase();
    });
    // Changing type mid-flow would strand whatever was written for the last
    // one, so it goes as soon as the config step is left.
    if (provisional != null) await _removeProvisional(provisional);
  }

  void _resetPhase() {
    _ticker?.cancel();
    _ticker = null;
    _testRun++;
    _phase = _ConnectionPhase.idle;
    _failureMessage = null;
    _passedMessage = null;
    _elapsed = Duration.zero;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // The connection test
  // ───────────────────────────────────────────────────────────────────────────

  String get _providerId => _idController.text.trim();

  Map<String, String> get _fields => {
        for (final entry in _fieldControllers.entries)
          entry.key: entry.value.text.trim(),
      };

  bool get _isComplete {
    if (_providerId.isEmpty) return false;
    final required = kRequiredProviderFields[_type] ?? const <String>[];
    return required.every(
      (key) => (_fieldControllers[key]?.text.trim() ?? '').isNotEmpty,
    );
  }

  /// Writes the provider so the engine can reach it, replacing any provisional
  /// one left under a different id.
  Future<void> _writeProvider() async {
    final previous = _provisionalId;
    if (previous != null && previous != _providerId) {
      await _removeProvisional(previous);
      _provisionalId = null;
    }
    await runtime.settings().updateProvider(
          providerId: _providerId,
          providerType: providerTypeValue(_type),
          fields: _fields,
        );
    _provisionalId = _providerId;
    await Future.wait([
      settingsStore.reloadProviders(),
      settingsStore.reloadServices(),
    ]);
  }

  Future<void> _test() async {
    setState(() {
      _resetPhase();
      _phase = _ConnectionPhase.testing;
    });
    final run = _testRun;
    final startedAt = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() => _elapsed = DateTime.now().difference(startedAt));
    });

    try {
      await _writeProvider();
      final message = isLlmProviderType(_type)
          // Listing models exercises the key and the endpoint without
          // spending any vars.
          ? formatTranslation(
              t.settings.providers.editor.test.passed_models,
              args: [
                '${(await runtime.settings().listModels(providerId: _providerId)).length}',
              ],
            )
          // Nothing to list on a traditional provider, so the probe is the
          // shortest translation the service will accept.
          : await _probeTranslation();
      if (!mounted || run != _testRun) return;
      setState(() {
        _phase = _ConnectionPhase.passed;
        _passedMessage = message;
      });
    } catch (error) {
      if (!mounted || run != _testRun) return;
      setState(() {
        _phase = _ConnectionPhase.failed;
        _failureMessage = error.toString();
      });
    } finally {
      if (run == _testRun) {
        _ticker?.cancel();
        _ticker = null;
      }
    }
  }

  Future<String> _probeTranslation() async {
    // `translation()` resolves a bare provider id straight to the provider, so
    // this reaches the endpoint without a service having to exist yet.
    await runtime.translation(providerId: _providerId).translate(
          request: TranslateRequest(
            sourceLanguage: 'en',
            targetLanguage: 'zh-Hans',
            text: _kProbeText,
          ),
        );
    return t.settings.providers.editor.test.passed_service;
  }

  void _cancelTest() {
    // The request itself keeps running — there is no way to call it back — so
    // the sheet bumps the run and ignores whatever it eventually answers.
    setState(_resetPhase);
  }

  Future<void> _commit() async {
    try {
      await _writeProvider();
      _committed = true;
      if (mounted) Navigator.of(context).pop(_providerId);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _phase = _ConnectionPhase.failed;
        _failureMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _configuring ? _buildConfigStep(context) : _buildTypeStep(),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Step 1 — the type picker
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildTypeStep() {
    final editor = t.settings.providers.editor;
    final traditional = _traditionalTypes;

    return DialogFrame(
        child: Dialog(children: [
      DialogHeader(
          title: t.settings.providers.button.add,
          subtitle: editor.type_picker.prompt),
      DialogBody(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final type in _llmTypes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ProviderTypeRow(
                    type: type,
                    selected: type == _type,
                    onSelect: () => setState(() => _type = type),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _DisclosureButton(
                  open: _traditionalOpen,
                  label: '${editor.type_picker.section_traditional}'
                      ' · ${traditional.length}',
                  onPressed: () =>
                      setState(() => _traditionalOpen = !_traditionalOpen),
                ),
              ),
              if (_traditionalOpen)
                for (final type in traditional)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _ProviderTypeRow(
                      type: type,
                      selected: type == _type,
                      onSelect: () => setState(() => _type = type),
                    ),
                  ),
            ],
          ),
        ],
      ),
      DialogFooter(
        children: [
          const Spacer(),
          Button(
              variant: ButtonVariant.recessed,
              size: WidgetSize.medium,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ui.button.cancel)),
          Button(
              variant: ButtonVariant.filled,
              size: WidgetSize.medium,
              onPressed: _enterConfig,
              child: Text(editor.step.next)),
        ],
      ),
    ]));
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Step 2 — configuration
  // ───────────────────────────────────────────────────────────────────────────

  Widget _buildConfigStep(BuildContext context) {
    final editor = t.settings.providers.editor;
    final failed = _phase == _ConnectionPhase.failed;
    final passed = _phase == _ConnectionPhase.passed;
    final testing = _phase == _ConnectionPhase.testing;
    final llm = isLlmProviderType(_type);
    final credentialKeys = _fieldKeys
        .where((key) => key != 'baseUrl' && key != 'defaultModel')
        .toList(growable: false);

    return DialogFrame(
        child: Dialog(
            tone: failed ? DialogTone.danger : DialogTone.normal,
            children: [
          AppDialogHeader(
              icon: ProviderIcon(providerTypeValue(_type), size: 18),
              title: formatTranslation(
                editor.add_title,
                args: [providerTypeDisplayName(_type)],
              ),
              subtitle: providerTypeDescription(_type)),
          DialogBody(
            children: [
              FormField(
                  label: editor.row.id,
                  child: TextField(
                      controller: _idController,
                      placeholder: editor.placeholder.id,
                      style: context.vars.monoStyle(),
                      onChanged: (_) => setState(_resetPhase))),
              if (_fieldKeys.contains('baseUrl'))
                FormField(
                    label: 'Base URL',
                    child: TextField(
                        // Left blank the engine uses its own endpoint, so the
                        // default belongs in the placeholder, not the value.
                        placeholder: defaultBaseUrl(_type),
                        controller: _fieldControllers['baseUrl'],
                        style: context.vars.monoStyle(),
                        onChanged: (_) => setState(_resetPhase))),
              if (credentialKeys.isNotEmpty || llm)
                _buildCredentialRow(credentialKeys, llm: llm, failed: failed),
              _buildCapabilities(),
              if (testing)
                Callout(
                    tint: CalloutTint.primary,
                    icon: const Spinner(size: WidgetSize.small),
                    actions: [
                      Button(
                          variant: ButtonVariant.plain,
                          onPressed: _cancelTest,
                          child: Text(t.common.ui.button.cancel))
                    ],
                    message: Text(
                      formatTranslation(
                        editor.test.running,
                        args: [
                          (_elapsed.inMilliseconds / 1000).toStringAsFixed(1)
                        ],
                      ),
                    )),
              if (passed)
                Callout(
                    tint: CalloutTint.success,
                    actions: [
                      Button(
                          variant: ButtonVariant.plain,
                          onPressed: _test,
                          child: Text(editor.test.retest))
                    ],
                    message:
                        Text(_passedMessage ?? editor.test.passed_service)),
              if (failed) _TipsCard(reason: _failureMessage, llm: llm),
            ],
          ),
          DialogFooter(
            children: [
              if (passed)
                _PassedNote(text: editor.test.passed_footer)
              else
                Button(
                    variant: ButtonVariant.plain,
                    onPressed: testing || !_isComplete ? null : _test,
                    child: Text(editor.test.run)),
              const Spacer(),
              Button(
                  variant: ButtonVariant.recessed,
                  size: WidgetSize.medium,
                  onPressed: testing ? null : _back,
                  child: Text(editor.step.back)),
              if (failed)
                Button(
                    variant: ButtonVariant.filled,
                    size: WidgetSize.medium,
                    onPressed: _isComplete ? _test : null,
                    child: Text(editor.test.retest))
              else
                // 添加 stays out of reach until the endpoint has answered.
                Button(
                    variant: ButtonVariant.filled,
                    size: WidgetSize.medium,
                    onPressed: passed ? _commit : null,
                    child: Text(t.common.ui.button.add)),
            ],
          ),
        ]));
  }

  /// The credential fields, with 默认模型 beside the last one when the type has
  /// exactly one — the paired row the deck draws.
  Widget _buildCredentialRow(
    List<String> credentialKeys, {
    required bool llm,
    required bool failed,
  }) {
    final model = llm && _fieldKeys.contains('defaultModel')
        ? FormField(
            label: t.settings.providers.editor.row.default_model,
            child: TextField(
                // Required, not a nicety: every LLM provider refuses to build
                // without a model, so a blank one fails the test rather than
                // falling back to anything.
                controller: _fieldControllers['defaultModel'],
                style: context.vars.monoStyle(),
                onChanged: (_) => setState(_resetPhase)))
        : null;

    final credentials = [
      for (final key in credentialKeys)
        FormField(
            label: _credentialLabel(key, failed: failed),
            invalid: failed,
            child: TextField(
                controller: _fieldControllers[key],
                state: failed ? TextFieldState.error : TextFieldState.normal,
                obscureText: isSecretField(key),
                onChanged: (_) => setState(_resetPhase))),
    ];

    if (credentials.length == 1 && model != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: credentials.single),
          const SizedBox(width: 10),
          SizedBox(width: 150, child: model),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < credentials.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          credentials[i],
        ],
        if (model != null) ...[
          if (credentials.isNotEmpty) const SizedBox(height: 16),
          model,
        ],
      ],
    );
  }

  /// The key's label carries the verdict — `API Key · 已验证` once the endpoint
  /// has answered, `· 验证失败` when it turned the credentials down.
  String _credentialLabel(String key, {required bool failed}) {
    final test = t.settings.providers.editor.test;
    if (failed) return '$key · ${test.failed_suffix}';
    if (_phase == _ConnectionPhase.passed) {
      return '$key · ${test.passed_suffix}';
    }
    return key;
  }

  /// 可用服务 — what the engine will derive from this provider. The runtime
  /// decides this from the provider's type, so the rows report it rather than
  /// asking; unchecking one is not something the settings file can express.
  Widget _buildCapabilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SectionLabel(t.settings.providers.section.services),
        ),
        for (final capability in _capabilities)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Checkbox(
                value: true,
                // Every capability a provider declares is offered; the row is
                // a statement of fact, not a choice.
                onChanged: null,
                note: Text(capabilityNote(capability)),
                label: Text(serviceTypeLabel(capability))),
          ),
      ],
    );
  }
}

/// One selectable row of the type picker.
class _ProviderTypeRow extends StatelessWidget {
  const _ProviderTypeRow({
    required this.type,
    required this.selected,
    required this.onSelect,
  });

  final ProviderType type;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final radius = BorderRadius.circular(vars.radiusMedium);
    final capabilities = visibleProviderCapabilities(type);

    return Pressable(
      onPressed: onSelect,
      borderRadius: radius,
      checked: selected,
      isButton: false,
      semanticsLabel: providerTypeDisplayName(type),
      builder: (context, states) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? vars.accent.withValues(alpha: 0.08)
              : (states.contains(WidgetState.hovered)
                  ? vars.colorSurfaceSubtle
                  : vars.colorSurfaceMuted),
          border: Border.all(
            color: selected ? vars.accent : vars.colorBorder,
            width: context.hairlineWidth,
          ),
          borderRadius: radius,
        ),
        child: Row(
          children: [
            ProviderIcon(providerTypeValue(type), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                providerTypeDisplayName(type),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: vars.sansStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  color: selected ? vars.colorContent : vars.colorContentMuted,
                ),
              ),
            ),
            for (final capability in capabilities) ...[
              const SizedBox(width: 4),
              _Tag(label: serviceTypeLabel(capability)),
            ],
          ],
        ),
      ),
    );
  }
}

/// The 传统提供商 · N disclosure.
class _DisclosureButton extends StatelessWidget {
  const _DisclosureButton({
    required this.open,
    required this.label,
    required this.onPressed,
  });

  final bool open;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Pressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(vars.radiusSmall),
      selected: open,
      semanticsLabel: label,
      builder: (context, states) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // A quarter turn, so the triangle points at what it opens.
          AnimatedRotation(
            turns: open ? 0.25 : 0,
            duration: const Duration(milliseconds: 120),
            child: Text(
              '▶',
              style: vars.sansStyle(
                fontSize: 9,
                height: 1,
                color: vars.colorContentFaint,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SectionLabel(label, tone: SectionLabelTone.faint),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: vars.colorSurfaceInset,
        borderRadius: BorderRadius.circular(vars.radiusFull),
      ),
      child: Text(
        label,
        style: vars.sansStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 1,
          color: vars.colorContentSubtle,
        ),
      ),
    );
  }
}

/// The footer's standing in for 测试连接 once the test has passed.
class _PassedNote extends StatelessWidget {
  const _PassedNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Text(
      text,
      style: vars.sansStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1,
        color: vars.success,
      ),
    );
  }
}

/// 可以试试 — what went wrong, then the checks worth making.
class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.reason, required this.llm});

  final String? reason;
  final bool llm;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final test = t.settings.providers.editor.test;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: vars.colorSurfaceMuted,
        border: Border.all(
          color: vars.colorBorder,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(vars.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (reason != null) ...[
            Text(
              reason!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: vars.sansStyle(
                fontSize: 12,
                height: 1.5,
                color: vars.dangerFg,
              ),
            ),
            const SizedBox(height: 9),
          ],
          SectionLabel(test.tips_title),
          const SizedBox(height: 7),
          Text(
            llm ? test.tips_llm : test.tips_traditional,
            style: vars.sansStyle(
              fontSize: 12,
              height: 1.75,
              color: vars.colorContentMuted,
            ),
          ),
        ],
      ),
    );
  }
}
