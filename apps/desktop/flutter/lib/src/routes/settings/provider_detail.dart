import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart' hide FormField;

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        Button,
        ButtonTint,
        ButtonVariant,
        Callout,
        CalloutTint,
        FormField,
        HoverRegion,
        PreferenceSection,
        Pressable,
        Spinner,
        Switch,
        TextField,
        TextFieldState,
        ThemeDataBuildContextProps,
        WidgetSize;
import 'add_service_dialog.dart';
import 'provider_catalog.dart';
import 'provider_meta.dart';

/// 提供商详情 — a provider's identity, its config, the model roster for an
/// LLM provider, and the services it serves.
///
/// Three things the page does rather than only draws:
///
/// 1. 保存 lands. It writes the config, marks the provider configured — an
///    unconfigured row becomes a provider with an id — and then asks the
///    endpoint for its models, which is also how the catalogue learns whether
///    the key works.
/// 2. The connection has a state. Fetching the roster is the evidence: an
///    answer marks the provider as working, a refusal as needing attention,
///    and a test run on values nobody saved vouches for neither.
/// 3. Leaving with unsaved edits asks first — from 返回 and from the rail
///    alike, through [providerDetailDirty].
class ProviderDetailPage extends StatefulWidget {
  const ProviderDetailPage({
    super.key,
    required this.type,
    required this.entry,
    required this.services,
    required this.onBack,
    required this.onCleared,
    required this.onSaved,
  });

  final ProviderType type;

  /// The stored provider, or null for a catalogue row nobody configured.
  final ProviderConfigEntry? entry;

  /// The services the runtime derives from — or the user attached to — this
  /// provider.
  final List<ServiceConfigEntry> services;

  final VoidCallback onBack;

  /// The key was cleared and the provider is gone.
  final VoidCallback onCleared;

  /// A save went through, under this id.
  final ValueChanged<String> onSaved;

  @override
  State<ProviderDetailPage> createState() => _ProviderDetailPageState();
}

/// One thing standing between the form and 保存: which field, and what is
/// wrong with it.
class _FieldProblem {
  const _FieldProblem(this.key, this.message);

  final String key;
  final String message;
}

/// Where asking the endpoint for models got to. An endpoint that answered with
/// nothing is not the same as one that would not answer.
enum _Roster { locked, loading, error, empty, ready }

class _ProviderDetailPageState extends State<ProviderDetailPage> {
  late final Map<String, TextEditingController> _fieldControllers;
  final TextEditingController _manualModelController = TextEditingController();

  /// Which secret fields have their eye open. Per field, and forgotten when
  /// the page closes — a key left readable is not something to come back to.
  final Map<String, bool> _revealed = {};

  List<String> _models = const [];
  _Roster _roster = _Roster.locked;

  /// Whether the roster on screen came from values nobody saved — and so says
  /// nothing about whether the stored key works.
  bool _testedDraft = false;

  /// Bumped per fetch, so an answer that arrives after a newer question was
  /// asked is dropped rather than drawn over it.
  int _fetchRun = 0;

  /// The model an unconfigured provider will be saved with. A stored provider
  /// writes 设为默认 at once; one with nothing stored has nowhere to write it
  /// until 保存.
  String? _draftDefaultModel;

  bool _isSaving = false;

  /// Set by a save that went through; the receipt it shows hides again as
  /// soon as the form differs from what was written.
  bool _saved = false;

  /// Set by pressing 保存 while the form still has problems. Until then a
  /// half-typed key is not an error — nobody asked to save it yet.
  bool _showProblems = false;

  /// Set by a save that found no model to use.
  bool _needsModel = false;

  String? _saveError;
  String? _actionError;

  ProviderConfigEntry? get _entry => widget.entry;
  bool get _configured => _entry != null;
  String get _providerId => _entry?.id ?? providerTypeValue(widget.type);
  bool get _hasModelRoster => isLlmProviderType(widget.type);

  String _stored(String key) => _entry?.fields[key]?.trim() ?? '';

  /// The model the provider answers with.
  String get _defaultModel => _draftDefaultModel ?? _stored('defaultModel');

  /// What a save would write, and what the checks read: the stored fields
  /// with the form over them.
  ///
  /// A secret left blank keeps the stored one. The box never shows a stored
  /// key — echoing `sk-…` back into it would have the next save write the
  /// echo — so blank is how "leave it as it is" reads, and changing only the
  /// Base URL does not mean typing the key again.
  Map<String, String> get _effectiveFields {
    final fields = Map<String, String>.of(_entry?.fields ?? const {});
    for (final entry in _fieldControllers.entries) {
      final typed = entry.value.text.trim();
      if (isSecretField(entry.key) && typed.isEmpty) continue;
      fields[entry.key] = typed;
    }
    if (_hasModelRoster && _defaultModel.isNotEmpty) {
      fields['defaultModel'] = _defaultModel;
    }
    return fields;
  }

  /// Whether the form differs from what is stored. A secret counts once
  /// something is typed into it; typed and deleted again, it has not moved.
  bool get _isDirty =>
      _draftDefaultModel != null ||
      _fieldControllers.entries.any((entry) {
        final typed = entry.value.text.trim();
        if (isSecretField(entry.key)) return typed.isNotEmpty;
        return typed != _stored(entry.key);
      });

  /// What would stop a save: a required field that is blank once the stored
  /// values are merged in — a saved key is not echoed, so the bare form would
  /// count it missing — and a Base URL that is not an http(s) address.
  List<_FieldProblem> get _problems {
    final problem = t.settings.providers.detail.problem;
    final fields = _effectiveFields;
    final problems = <_FieldProblem>[
      for (final key in providerFormRequiredFields(widget.type))
        if ((fields[key] ?? '').trim().isEmpty)
          _FieldProblem(key, problem.required),
    ];
    final urlProblem = _urlProblem(fields['baseUrl'] ?? '');
    if (urlProblem != null) problems.add(_FieldProblem('baseUrl', urlProblem));
    return problems;
  }

  /// Blank is not a URL problem — whether blank is allowed is the required
  /// check's business.
  String? _urlProblem(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final problem = t.settings.providers.detail.problem;
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme) return problem.url_scheme;
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return problem.url_protocol;
    }
    if (uri.host.isEmpty) return problem.url_host;
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fieldControllers = {
      for (final key in providerFormFields(widget.type))
        key: TextEditingController(
          text: isSecretField(key) ? '' : widget.entry?.fields[key] ?? '',
        ),
    };
    providerHealth.addListener(_handleChanged);
    // A connected provider is asked at once: the roster and the list's state
    // should not wait for someone to press 刷新列表.
    if (_hasModelRoster && _configured) _fetchModels();
  }

  @override
  void dispose() {
    providerHealth.removeListener(_handleChanged);
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    _manualModelController.dispose();
    providerDetailDirty.value = false;
    super.dispose();
  }

  void _handleChanged() {
    if (!mounted) return;
    setState(() {});
    providerDetailDirty.value = _isDirty;
  }

  /// Asks the endpoint for its models.
  ///
  /// With [draft] the question is put with the form's values, unsaved — the
  /// runtime builds the provider without writing it — and the answer is not
  /// taken as the stored key's health. An unconfigured provider has nothing
  /// stored to ask with, so it always tests the draft.
  Future<void> _fetchModels({bool? draft, String? providerId}) async {
    final useDraft = draft ?? (!_configured || _isDirty);
    final id = providerId ?? _providerId;
    final run = ++_fetchRun;
    setState(() {
      _roster = _Roster.loading;
      _testedDraft = useDraft;
    });
    try {
      final models = useDraft
          ? await runtime.settings().listDraftModels(
                providerId: id,
                providerType: providerTypeValue(widget.type),
                fields: _effectiveFields,
              )
          : await runtime.settings().listModels(providerId: id);
      if (!mounted || run != _fetchRun) return;
      setState(() {
        _models = models;
        _roster = models.isEmpty ? _Roster.empty : _Roster.ready;
        // A provider with no model yet takes the first one the endpoint
        // names — the roster fills the choice in, which is what it is for.
        if (!_configured && _draftDefaultModel == null && models.isNotEmpty) {
          _draftDefaultModel = models.first;
        }
      });
      if (!useDraft) setProviderHealth(id, ProviderHealth.ok);
    } catch (_) {
      if (!mounted || run != _fetchRun) return;
      setState(() => _roster = _Roster.error);
      // Not answering is all the evidence an LLM provider gives about its key,
      // so a failed fetch reads as needing attention rather than as offline.
      if (!useDraft) setProviderHealth(id, ProviderHealth.invalid);
    } finally {
      if (mounted) providerDetailDirty.value = _isDirty;
    }
  }

  Future<void> _save() async {
    // A button that can never be pressed explains nothing. While the form has
    // problems 保存 stays live, and pressing it names each one instead.
    if (_problems.isNotEmpty) {
      setState(() {
        _showProblems = true;
        _saved = false;
      });
      return;
    }
    setState(() {
      _showProblems = false;
      _needsModel = false;
      _isSaving = true;
      _saved = false;
      _saveError = null;
    });
    try {
      // The engine will not build an LLM provider without a model, and a
      // provider saved for the first time has not picked one: ask the endpoint
      // with the values about to be written, and take the first it names.
      if (_hasModelRoster && _defaultModel.isEmpty) {
        await _fetchModels(draft: true);
        if (!mounted) return;
        if (_defaultModel.isEmpty) {
          setState(() => _needsModel = true);
          return;
        }
      }

      final fields = _effectiveFields;
      var id = _entry?.id;
      if (id == null) {
        try {
          id = await runtime.settings().generateProviderId(
                providerType: providerTypeValue(widget.type),
              );
        } catch (_) {
          id = providerTypeValue(widget.type);
        }
      }
      await runtime.settings().updateProvider(
            providerId: id,
            providerType: providerTypeValue(widget.type),
            fields: fields,
          );
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
      if (!mounted) return;

      // What was written is the form now: the secret boxes empty again and
      // the rest trimmed, so nothing still reads as edited.
      for (final entry in _fieldControllers.entries) {
        entry.value.text =
            isSecretField(entry.key) ? '' : fields[entry.key] ?? '';
      }
      setState(() {
        _draftDefaultModel = null;
        _saved = true;
      });
      providerDetailDirty.value = false;
      // Written is not working: until an answer comes back it is unverified.
      setProviderHealth(
        id,
        _hasModelRoster ? ProviderHealth.unverified : null,
      );
      if (!_configured) widget.onSaved(id);
      // The new key is tried at once rather than inheriting the old verdict.
      if (_hasModelRoster) await _fetchModels(draft: false, providerId: id);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saveError = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// 设为默认. A stored provider switches at once — a model choice is a switch,
  /// not a draft; one nobody saved keeps it for its first 保存.
  Future<void> _setDefaultModel(String model) async {
    final entry = _entry;
    if (entry == null) {
      setState(() {
        _draftDefaultModel = model;
        _needsModel = false;
      });
      providerDetailDirty.value = _isDirty;
      return;
    }
    setState(() => _actionError = null);
    try {
      await runtime.settings().updateProvider(
        providerId: entry.id,
        providerType: providerTypeValue(entry.type),
        fields: {...entry.fields, 'defaultModel': model},
      );
      await settingsStore.reloadProviders();
    } catch (error) {
      if (mounted) setState(() => _actionError = error.toString());
    }
  }

  /// 清除密钥 takes the provider back to 未配置. The services it provided go
  /// with it — they are derived from the connection — and so does the key.
  Future<void> _clear() async {
    final entry = _entry;
    if (entry == null) return;
    final copy = t.settings.providers.clear_dialog;
    final confirmed = await showConfirmDialog(
      context,
      title: copy.title,
      message: formatTranslation(
        copy.message,
        args: [providerTypeDisplayName(widget.type)],
      ),
      confirmLabel: copy.confirm,
      danger: true,
    );
    if (!confirmed || !mounted) return;

    try {
      await runtime.settings().deleteProvider(providerId: entry.id);
      setProviderHealth(entry.id, null);
      // Cleared on purpose, so there is nothing left to warn about losing.
      providerDetailDirty.value = false;
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
      widget.onCleared();
    } catch (error) {
      if (mounted) setState(() => _actionError = error.toString());
    }
  }

  /// 添加服务 from here is the same sheet 服务 raises, with this provider
  /// already picked — the page is about this provider, so that is the one
  /// question it can answer for the user.
  Future<void> _addService() async {
    final draft = await showDialogInCurrentWindow<ServiceDraft>(
      context: context,
      builder: (_) => AddServiceDialog(
        providers: configurableProviders(settingsStore.providers),
        // The derived services count as taken ids, so a second service of the
        // same kind gets a suffix instead of shadowing the provider's own.
        existing: settingsStore.services,
        defaultProviderId: _providerId,
      ),
    );
    if (draft == null || !mounted) return;

    setState(() => _actionError = null);
    try {
      await runtime.settings().updateService(
            serviceId: draft.id,
            providerId: draft.providerId,
            serviceType: draft.type,
            name: draft.name,
            fields: draft.fields,
          );
      await settingsStore.reloadServices();
    } catch (error) {
      if (mounted) setState(() => _actionError = error.toString());
    }
  }

  Future<void> _runServiceAction(Future<void> Function() action) async {
    setState(() => _actionError = null);
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _actionError = error.toString());
    }
  }

  /// The page's blocks sit 8 inside its back bar.
  ///
  /// 返回 is a plain button and its label is already pushed in by the button's
  /// own padding; the blocks below make up the same difference so the two
  /// columns line up, and the page as a whole then matches the 24 the other
  /// settings panes start at.
  Widget _inset(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final detail = t.settings.providers.detail;
    final problems = _problems;
    final isDirty = _isDirty;
    final health = providerHealth.value[_providerId];

    return SettingsPage(
      horizontalPadding: 16,
      children: [
        _Header(
          // Nothing to clear on a provider nobody configured, or on one with
          // no field to have filled in.
          onClear: _configured && _fieldControllers.isNotEmpty ? _clear : null,
          onBack: widget.onBack,
        ),

        // The provider's identity: the mark, the name, and under it the id.
        _inset(Row(
          children: [
            ProviderIcon(widget.type, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          providerTypeDisplayName(widget.type),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: vars.displayStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: vars.colorContent,
                          ),
                        ),
                      ),
                      if (!_configured) ...[
                        const SizedBox(width: 8),
                        _UnconfiguredMark(),
                      ],
                    ],
                  ),
                  Text(
                    _providerId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vars.monoStyle(
                      fontSize: 11,
                      height: 1,
                      color: vars.colorContentFaint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),

        if (_actionError != null)
          _inset(Callout(
            tint: CalloutTint.danger,
            message: Text(_actionError!),
          )),

        _inset(PreferenceSection(
          label: detail.section.configuration,
          // Sized like 刷新列表 and 添加服务... in the same slot: a heading's
          // action takes the heading's own 11px.
          action: Button(
              variant: ButtonVariant.filled,
              size: WidgetSize.tiny,
              // Dead only when there is truly nothing to do: a stored provider
              // with no edits and nothing wrong. With problems it stays live so
              // pressing it can name them.
              onPressed:
                  _isSaving || (_configured && !isDirty && problems.isEmpty)
                      ? null
                      : _save,
              child: _isSaving
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spinner(size: WidgetSize.small),
                        const SizedBox(width: 8),
                        Text(detail.button.saving),
                      ],
                    )
                  : Text(t.common.ui.button.save)),
          children: [
            // The receipt sits right under the heading: the button pressed is
            // in the heading, so the answer is read just below it.
            ..._buildReceipt(problems, isDirty, health),
            if (_fieldControllers.isEmpty)
              // Nothing to fill in means nothing to save — say so, rather than
              // leave a permanently grey 保存 to be puzzled over.
              _Note(text: detail.no_fields)
            else
              for (final entry in _fieldControllers.entries)
                _buildField(entry.key, entry.value, problems),
          ],
        )),

        if (_hasModelRoster) ...[
          const SettingsSectionDivider(),
          _inset(PreferenceSection(
            label: detail.section.models,
            action: Button(
                variant: ButtonVariant.plain,
                size: WidgetSize.tiny,
                // A form with a known problem would fail the question for a
                // reason that is in the form, not in the provider.
                onPressed: _roster == _Roster.loading || problems.isNotEmpty
                    ? null
                    : () => _fetchModels(),
                // With unsaved values in the form the question is put with
                // them — the button says so, or fetching models would read as
                // having saved.
                child: Text(
                  isDirty ? detail.models.test_draft : detail.models.refresh,
                )),
            children: _buildModels(),
          )),
        ],

        const SettingsSectionDivider(),

        // A local view, not the catalogue: where this connection is in use
        // right now. The switches and 默认 follow 服务's rules, on the same
        // settings.
        _inset(PreferenceSection(
          label: detail.section.services,
          action: Button(
              variant: ButtonVariant.filled,
              size: WidgetSize.tiny,
              onPressed: _configured ? _addService : null,
              child: Text(detail.button.add_service)),
          children: [
            if (widget.services.isEmpty)
              _Note(
                text: _configured
                    ? detail.services_empty
                    : detail.services_locked,
              )
            else
              for (final service in widget.services)
                _ServiceRow(
                  service: service,
                  isDefault: isDefaultService(service),
                  enabled: isServiceEnabled(service),
                  onMakeDefault: () =>
                      _runServiceAction(() => makeDefaultService(service)),
                  onEnabledChange: (value) => _runServiceAction(
                    () => setServiceEnabled(service, value),
                  ),
                ),
          ],
        )),
      ],
    );
  }

  List<Widget> _buildReceipt(
    List<_FieldProblem> problems,
    bool isDirty,
    ProviderHealth? health,
  ) {
    final detail = t.settings.providers.detail;
    if (_showProblems && problems.isNotEmpty) {
      return [
        _Receipt(
          tint: CalloutTint.danger,
          title: detail.receipt.problems_title,
          message: problems
              .map(
                (problem) => formatTranslation(
                  detail.problem.item,
                  args: [providerFieldLabel(problem.key), problem.message],
                ),
              )
              .join(detail.problem.separator),
        ),
      ];
    }
    if (_needsModel) {
      return [
        _Receipt(
          tint: CalloutTint.danger,
          title: detail.receipt.problems_title,
          message: detail.problem.no_model,
        ),
      ];
    }
    if (_saveError != null) {
      return [
        _Receipt(
          tint: CalloutTint.danger,
          title: detail.receipt.save_failed_title,
          message: _saveError!,
        ),
      ];
    }
    if (_saved && !isDirty) {
      // Saved and refused are two facts, said apart — otherwise 已保存 reads as
      // the problem having gone away.
      if (health == ProviderHealth.invalid) {
        return [
          _Receipt(
            tint: CalloutTint.danger,
            title: detail.receipt.saved_rejected_title,
            message: detail.receipt.saved_rejected_body,
          ),
        ];
      }
      return [
        _Receipt(
          tint: CalloutTint.success,
          title: detail.receipt.saved_title,
          message: health == ProviderHealth.unverified
              ? detail.receipt.saved_verifying
              : detail.receipt.saved_body,
        ),
      ];
    }
    return const [];
  }

  /// One config field: its label, a mono input — every value here is a key,
  /// an id or an address, never prose — and a hint.
  ///
  /// An optional field with a fallback prints the fallback twice: in the
  /// placeholder, and in the hint as 留空则用 …. An empty box with only "leave
  /// blank for the default" still leaves the user guessing where it connects.
  Widget _buildField(
    String key,
    TextEditingController controller,
    List<_FieldProblem> problems,
  ) {
    final detail = t.settings.providers.detail;
    final problem = _showProblems
        ? problems.where((entry) => entry.key == key).firstOrNull
        : null;
    final required = providerFormRequiredFields(widget.type).contains(key);
    final fallback =
        required || key != 'baseUrl' ? '' : defaultBaseUrl(widget.type);
    final label = providerFieldLabel(key);
    final secret = isSecretField(key);
    final revealed = _revealed[key] ?? false;

    return FormField(
        label: label,
        invalid: problem != null,
        hint: problem?.message ??
            (fallback.isEmpty
                ? null
                : formatTranslation(
                    detail.field.fallback_hint,
                    args: [fallback],
                  )),
        child: TextField(
            controller: controller,
            mono: true,
            state:
                problem != null ? TextFieldState.error : TextFieldState.normal,
            // A stored key is not echoed: the box says there is one and that
            // blank keeps it, which is truer than a row of dots a save would
            // write back as the key.
            placeholder: secret
                ? (_stored(key).isNotEmpty
                    ? detail.field.secret_stored
                    : detail.field.secret_empty)
                : (fallback.isEmpty ? null : fallback),
            obscureText: secret && !revealed,
            suffix: secret
                ? _RevealToggle(
                    revealed: revealed,
                    label: label,
                    onPressed: () => setState(() => _revealed[key] = !revealed),
                  )
                : null,
            onChanged: (_) => _handleChanged()));
  }

  List<Widget> _buildModels() {
    final vars = context.vars;
    final models = t.settings.providers.detail.models;

    final Widget state = switch (_roster) {
      _Roster.locked => _Note(text: models.locked),
      _Roster.loading => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Spinner(size: WidgetSize.small),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  models.fetching,
                  style: vars.sansStyle(
                    fontSize: 12,
                    height: 1,
                    color: vars.colorContentSubtle,
                  ),
                ),
              ),
            ],
          ),
        ),
      _Roster.error => Callout(
          tint: CalloutTint.danger,
          title: Text(models.fetch_failed_title),
          message: Text(models.fetch_failed_body),
          actions: [
            Button(
                variant: ButtonVariant.plain,
                onPressed: () => _fetchModels(),
                child: Text(models.retry)),
          ],
        ),
      _Roster.empty => _Note(text: models.empty_answer),
      _Roster.ready => const SizedBox.shrink(),
    };

    // The model in use keeps its row whatever the endpoint says — including
    // one typed by hand, or one the endpoint no longer lists.
    final current = _defaultModel;
    final rows = [
      if (current.isNotEmpty && !_models.contains(current)) current,
      if (_roster == _Roster.ready) ..._models,
    ];

    return [
      if (_testedDraft && _roster == _Roster.ready)
        // Fetched is not saved: this roster came from the form's values.
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            models.draft_note,
            style: vars.sansStyle(
              fontSize: 11,
              height: 1.6,
              color: vars.warnFg,
            ),
          ),
        ),
      if (_roster != _Roster.ready) state,
      for (final model in rows)
        ProviderSettingsRow(
          title: Text(
            model,
            style: vars.monoStyle(
              fontSize: 12,
              height: 1,
              color: vars.colorContent,
            ),
          ),
          // 默认 is the state of the row, 设为默认 the way to get it — the two
          // share the slot, so the right edge always says where the row stands.
          trailing: model == current
              ? Badge(size: WidgetSize.small, child: Text(models.default_badge))
              : Button(
                  variant: ButtonVariant.plain,
                  size: WidgetSize.tiny,
                  onPressed: () => _setDefaultModel(model),
                  child: Text(models.set_default)),
        ),
      // An endpoint that lists nothing — or will not answer — can still be
      // used with a model named by hand, which is what the empty state says.
      if (_roster == _Roster.empty || _roster == _Roster.error)
        _ManualModelRow(
          controller: _manualModelController,
          onSubmit: (model) {
            _manualModelController.clear();
            _setDefaultModel(model);
          },
        ),
    ];
  }
}

/// Back on the left, the destructive action on the right — the provider's
/// toolbar, restated as a page header. 保存 is not here: it is 配置's.
class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onClear});

  final VoidCallback onBack;

  /// Null when there is nothing to clear, which hides the button.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Button(
            variant: ButtonVariant.plain,
            tint: ButtonTint.neutral,
            onPressed: onBack,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FluentIcons.chevron_left_20_regular, size: 12),
                const SizedBox(width: 4),
                Text(t.settings.providers.title),
              ],
            )),
        const Spacer(),
        if (onClear != null)
          Button(
              variant: ButtonVariant.plain,
              tint: ButtonTint.warning,
              onPressed: onClear,
              child: Text(t.settings.providers.detail.button.clear_key)),
      ],
    );
  }
}

/// 未配置 beside the name of a provider nobody set up.
class _UnconfiguredMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: vars.colorBorder,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(vars.radiusFull),
      ),
      child: Text(
        t.settings.providers.status.unconfigured,
        style: vars.sansStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 1,
          color: vars.colorContentFaint,
        ),
      ),
    );
  }
}

/// A model named by hand, for an endpoint that will not list its own.
class _ManualModelRow extends StatefulWidget {
  const _ManualModelRow({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;

  @override
  State<_ManualModelRow> createState() => _ManualModelRowState();
}

class _ManualModelRowState extends State<_ManualModelRow> {
  void _submit() {
    final model = widget.controller.text.trim();
    if (model.isNotEmpty) widget.onSubmit(model);
  }

  @override
  Widget build(BuildContext context) {
    final models = t.settings.providers.detail.models;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            mono: true,
            size: WidgetSize.small,
            placeholder: models.manual_placeholder,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 10),
        Button(
            variant: ButtonVariant.plain,
            size: WidgetSize.tiny,
            onPressed: widget.controller.text.trim().isEmpty ? null : _submit,
            child: Text(models.set_default)),
      ],
    );
  }
}

/// A receipt at the top of a section — what the action in its heading just
/// did. The kit's callout, with the air a row gap alone does not give it.
class _Receipt extends StatelessWidget {
  const _Receipt({
    required this.tint,
    required this.title,
    required this.message,
  });

  final CalloutTint tint;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Callout(
        tint: tint,
        title: Text(title),
        message: Text(message),
      ),
    );
  }
}

/// The eye inside a secret field.
///
/// It is the field's furniture, not a second control beside it: no fill at
/// rest, a neutral wash under the pointer, the way a combobox's clear button
/// sits in its box. Its name says what pressing it will do, so it carries no
/// pressed state — that would read as "hide … pressed".
class _RevealToggle extends StatelessWidget {
  const _RevealToggle({
    required this.revealed,
    required this.label,
    required this.onPressed,
  });

  final bool revealed;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final field = t.settings.providers.detail.field;
    final radius = BorderRadius.circular(vars.radiusTiny);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Pressable(
        onPressed: onPressed,
        borderRadius: radius,
        semanticsLabel: formatTranslation(
          revealed ? field.hide_secret : field.show_secret,
          args: [label],
        ),
        builder: (context, states) {
          final hovered = states.contains(WidgetState.hovered);
          return AnimatedContainer(
            duration: vars.motionDuration,
            curve: vars.motionEasing,
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hovered ? vars.colorSurfaceInset : null,
              borderRadius: radius,
            ),
            child: Icon(
              revealed
                  ? FluentIcons.eye_off_20_regular
                  : FluentIcons.eye_20_regular,
              size: 14,
              color: hovered ? vars.colorContent : vars.colorContentSubtle,
            ),
          );
        },
      ),
    );
  }
}

/// A preference row whose title is a widget.
///
/// The kit's `PreferenceRow` prints its title from a String in the sans face,
/// and the provider pages need more than that — a name with 默认 beside it, a
/// model id in mono. So this restates the kit row's metrics rather than
/// approximating them: the minimum height, the gap, the pad on the text, the
/// title and subtitle faces and the hover wash that bleeds past the text. A
/// row drawn here keeps the rhythm of the kit rows on every other pane.
///
/// It also draws the `›` React's row puts on a row that opens something, which
/// the kit's does not.
class ProviderSettingsRow extends StatelessWidget {
  const ProviderSettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onPressed,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final interactive = onPressed != null;

    Widget content(Set<WidgetState> states) {
      final hovered = states.contains(WidgetState.hovered);

      final row = Row(
        spacing: vars.spacing25,
        children: [
          if (icon != null) icon!,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: vars.preferencesRowPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: vars.spacing1,
                children: [
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vars.labelQuiet.copyWith(color: vars.colorContent),
                    child: title,
                  ),
                  if (subtitle != null)
                    DefaultTextStyle.merge(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: vars.captionSmall.copyWith(
                        color: vars.colorContentSubtle,
                      ),
                      child: subtitle!,
                    ),
                ],
              ),
            ),
          ),
          if (trailing != null) trailing!,
          if (interactive)
            Text(
              '›',
              style: vars.labelQuiet.copyWith(color: vars.colorContent),
            ),
        ],
      );

      if (!interactive) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: vars.controlMediumSize),
          child: row,
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: vars.controlMediumSize),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: -vars.spacing2,
              right: -vars.spacing2,
              child: AnimatedContainer(
                duration: vars.motionDuration,
                curve: vars.motionEasing,
                decoration: BoxDecoration(
                  color: hovered
                      ? vars.colorPrimary[
                              vars.controlColorPlainSurface.hoveredShade!]!
                          .withValues(
                          alpha: vars.controlColorPlainSurface.hoveredOpacity,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(
                    vars.controlContainerRadius,
                  ),
                ),
              ),
            ),
            row,
          ],
        ),
      );
    }

    if (!interactive) return content(const {});

    return Pressable(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(vars.controlContainerRadius),
      builder: (context, states) => content(states),
    );
  }
}

/// One service this provider serves — its name, what it does, and the same
/// 默认 mark and switch it has on 服务, on the same settings.
///
/// 设为默认 waits for the pointer, as it does there. The default service has
/// no switch: turning it off would first mean handing 默认 to another, so a
/// switch in its place would have one position.
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.isDefault,
    required this.enabled,
    required this.onMakeDefault,
    required this.onEnabledChange,
  });

  final ServiceConfigEntry service;
  final bool isDefault;
  final bool enabled;
  final VoidCallback onMakeDefault;
  final ValueChanged<bool> onEnabledChange;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return HoverRegion(
      builder: (context, hovered) => ProviderSettingsRow(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                serviceDisplayName(service),
                style: TextStyle(
                  color: enabled ? vars.colorContent : vars.colorContentFaint,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: vars.colorSurfaceInset,
                borderRadius: BorderRadius.circular(vars.radiusFull),
              ),
              child: Text(
                serviceTypeLabel(service.type),
                style: vars.sansStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  color: vars.colorContentSubtle,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            if (!isDefault && enabled)
              // Hidden rather than absent, so the row keeps its geometry as
              // the pointer runs down the list.
              AnimatedOpacity(
                duration: vars.motionDuration,
                opacity: hovered ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !hovered,
                  child: Button(
                      variant: ButtonVariant.plain,
                      size: WidgetSize.tiny,
                      onPressed: onMakeDefault,
                      child: Text(t.settings.services.make_default)),
                ),
              ),
            if (isDefault)
              Badge(
                  size: WidgetSize.small,
                  child: Text(t.settings.providers.detail.models.default_badge))
            else
              Switch(value: enabled, onChanged: onEnabledChange),
          ],
        ),
      ),
    );
  }
}

/// A de-emphasised line where a section has nothing to show.
class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Text(
      text,
      style: vars.sansStyle(
        fontSize: 12,
        height: 1.4,
        color: vars.colorContentFaint,
      ),
    );
  }
}
