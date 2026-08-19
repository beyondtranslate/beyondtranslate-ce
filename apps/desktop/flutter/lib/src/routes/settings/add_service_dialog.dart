import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../widgets/native_select.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles,
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
        Field,
        Input,
        TextArea;
import 'provider_meta.dart';

/// What the dialog hands back — the shape `updateService` takes.
class ServiceDraft {
  ServiceDraft({
    required this.id,
    required this.providerId,
    required this.type,
    required this.name,
    required this.fields,
  });

  final String id;
  final String providerId;
  final ServiceType type;
  final String name;
  final Map<String, String> fields;
}

/// 添加服务 — a service is one provider doing one job, so the dialog picks
/// those two first and derives everything else: the kinds on offer come from
/// the provider, the id from the pair, and the model and prompt only appear
/// when the provider has an LLM to run them.
///
/// Editing reuses the same sheet with the pair locked: changing either would
/// make it a different service, which is what deleting and adding is for.
class AddServiceDialog extends StatefulWidget {
  const AddServiceDialog({
    super.key,
    required this.providers,
    required this.existing,
    this.service,
    this.defaultProviderId,
    this.defaultType,
    this.onDelete,
  });

  final List<ProviderConfigEntry> providers;

  /// Every service the runtime currently lists — the ones it derives from a
  /// provider included, since those already hold the `provider+kind` id this
  /// dialog would otherwise generate.
  final List<ServiceConfigEntry> existing;

  /// The service being edited, or null when adding.
  final ServiceConfigEntry? service;

  final String? defaultProviderId;

  /// The capability the sheet was opened from. 服务 raises this dialog from
  /// inside a capability's own group, which already decides the kind.
  final ServiceType? defaultType;

  /// Offered only while editing. Removing a service is destructive, so it sits
  /// at the *left* of the footer, away from 保存 — it acts on what is already
  /// there rather than on what the sheet is about to produce.
  final VoidCallback? onDelete;

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  late String _providerId;
  late ServiceType _type;
  late final TextEditingController _nameController;
  late final TextEditingController _modelController;
  late final TextEditingController _systemPromptController;

  List<String>? _models;
  bool _isLoadingModels = false;
  bool _modelsFailed = false;

  bool get _isEditing => widget.service != null;

  ProviderConfigEntry get _provider => widget.providers.firstWhere(
        (entry) => entry.id == _providerId,
        orElse: () => widget.providers.first,
      );

  bool get _isLlm => isLlmProviderType(_provider.type);

  List<ServiceType> get _kinds {
    final kinds = visibleProviderCapabilities(_provider.type);
    return kinds.isEmpty ? const [ServiceType.translation] : kinds;
  }

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    final preferred = service?.providerId ?? widget.defaultProviderId;
    _providerId = preferred != null &&
            widget.providers.any((entry) => entry.id == preferred)
        ? preferred
        : widget.providers.first.id;
    _type = service?.type ?? widget.defaultType ?? _kinds.first;
    if (!_kinds.contains(_type)) _type = _kinds.first;

    _nameController = TextEditingController(
      text: service == null
          ? _derivedName()
          : (service.name.isEmpty ? _derivedName() : service.name),
    );
    _modelController = TextEditingController(
      text: service?.fields['model'] ?? '',
    );
    _systemPromptController = TextEditingController(
      text: service?.fields['systemPrompt'] ?? '',
    );
    if (_isLlm) _loadModels();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  String _derivedName() =>
      '${providerTypeDisplayName(_provider.type)} · ${serviceTypeLabel(_type)}';

  /// Switching provider re-derives the kind, the name and the model roster.
  void _selectProvider(String next) {
    setState(() {
      _providerId = next;
      if (!_kinds.contains(_type)) _type = _kinds.first;
      _nameController.text = _derivedName();
      _modelController.text = '';
      _models = null;
      _modelsFailed = false;
    });
    if (_isLlm) _loadModels();
  }

  void _selectKind(ServiceType next) {
    setState(() {
      _type = next;
      _nameController.text = _derivedName();
    });
  }

  Future<void> _loadModels() async {
    final providerId = _providerId;
    setState(() {
      _isLoadingModels = true;
      _modelsFailed = false;
    });
    try {
      final models = await runtime.settings().listModels(
            providerId: providerId,
          );
      if (!mounted || providerId != _providerId) return;
      setState(() {
        _models = models;
        // Keep whatever was already set if the roster still offers it, so
        // editing a service never silently moves it to another model.
        if (!models.contains(_modelController.text.trim())) {
          final fallback = _provider.fields['defaultModel'] ?? '';
          _modelController.text = models.contains(fallback)
              ? fallback
              : (models.isEmpty ? '' : models.first);
        }
      });
    } catch (_) {
      // A provider that will not list its models is still usable — the field
      // falls back to a plain input so a model can be typed.
      if (!mounted || providerId != _providerId) return;
      setState(() {
        _modelsFailed = true;
        if (_modelController.text.trim().isEmpty) {
          _modelController.text = _provider.fields['defaultModel'] ?? '';
        }
      });
    } finally {
      if (mounted && providerId == _providerId) {
        setState(() => _isLoadingModels = false);
      }
    }
  }

  /// The runtime names a provider's own service `provider+kind`, so a second
  /// one of the same kind takes a suffix rather than colliding with it.
  String get _serviceId {
    if (_isEditing) return widget.service!.id;
    final base = _baseId;
    if (!widget.existing.any((service) => service.id == base)) return base;
    var n = 2;
    while (widget.existing.any((service) => service.id == '$base-$n')) {
      n += 1;
    }
    return '$base-$n';
  }

  String get _baseId => '$_providerId+${_kindSuffix(_type)}';

  /// True when the id had to take a suffix — the provider already serves this
  /// kind, and this service sits beside it rather than replacing it.
  bool get _isVariant => !_isEditing && _serviceId != _baseId;

  static String _kindSuffix(ServiceType type) {
    switch (type) {
      case ServiceType.translation:
      case ServiceType.llm:
        return 'translation';
      case ServiceType.dictionary:
        return 'dictionary';
      case ServiceType.ocr:
        return 'ocr';
    }
  }

  bool get _canSubmit => _nameController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final editor = t.settings.services.editor;
    final rows = t.settings.services.detail.row;

    return Center(
      child: Dialog(
        children: [
          DialogHeader(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProviderIcon(providerTypeValue(_provider.type), size: 18),
                const SizedBox(width: 8),
                Text(_isEditing ? t.common.ui.button.edit : editor.title),
              ],
            ),
            // Editing already has its subject in the title; the strapline only
            // makes sense while the service is being introduced.
            subtitle: _isEditing ? null : Text(editor.subtitle),
          ),
          DialogBody(
            children: [
              // The two choices everything else follows from, side by side.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Field(
                      label: Text(rows.provider),
                      child: NativeSelect<String>(
                        value: _providerId,
                        enabled: !_isEditing,
                        semanticsLabel: rows.provider,
                        items: [
                          for (final provider in widget.providers)
                            NativeSelectItem(
                              value: provider.id,
                              label: providerTypeDisplayName(provider.type),
                            ),
                        ],
                        onChanged: _selectProvider,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Field(
                      label: Text(rows.type),
                      child: NativeSelect<ServiceType>(
                        value: _type,
                        enabled: !_isEditing,
                        semanticsLabel: rows.type,
                        // Only what this provider can actually do: a dictionary
                        // on an LLM provider would fail at look-up time.
                        items: [
                          for (final kind in _kinds)
                            NativeSelectItem(
                              value: kind,
                              label: serviceTypeLabel(kind),
                            ),
                        ],
                        onChanged: _selectKind,
                      ),
                    ),
                  ),
                ],
              ),
              Field(
                label: Text(rows.name),
                hint: _isVariant
                    ? Text(
                        formatTranslation(
                          editor.variant_hint,
                          args: [
                            providerTypeDisplayName(_provider.type),
                            serviceTypeLabel(_type),
                          ],
                        ),
                      )
                    : null,
                child: Input(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (_isLlm) ...[
                Field(
                  label: Text(editor.row.model),
                  child: _buildModelControl(),
                ),
                Field(
                  label: Text(editor.row.system_prompt),
                  hint: Text(t.settings.services.detail.prompt_variables),
                  child: TextArea(
                    controller: _systemPromptController,
                    placeholder: editor.prompt_placeholder,
                    minLines: 3,
                    maxLines: 6,
                  ),
                ),
              ] else
                Callout(
                  tone: CalloutTone.neutral,
                  child: Text(
                    formatTranslation(
                      editor.traditional_note,
                      args: [providerTypeDisplayName(_provider.type)],
                    ),
                  ),
                ),
            ],
          ),
          DialogFooter(
            children: [
              if (_isEditing && widget.onDelete != null) ...[
                Button(
                  variant: ButtonVariant.warning,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onDelete!();
                  },
                  child: Text(t.common.ui.button.delete),
                ),
                const SizedBox(width: 10),
              ],
              // The id the pair derives, so the choices above have a visible
              // consequence before the sheet is committed.
              Flexible(
                child: Text(
                  _serviceId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.monoStyle(
                    fontSize: 11,
                    height: 1,
                    color: tokens.colors.fgFaint,
                  ),
                ),
              ),
              const Spacer(),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.md,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.common.ui.button.cancel),
              ),
              Button(
                variant: ButtonVariant.primary,
                size: ButtonSize.md,
                onPressed: _canSubmit ? _submit : null,
                child: Text(
                  _isEditing ? t.common.ui.button.save : t.common.ui.button.add,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// A roster when the provider will list one, a plain input when it will not.
  Widget _buildModelControl() {
    final models = _models ?? const <String>[];

    if (_isLoadingModels) {
      return NativeSelect<String>(
        value: '',
        enabled: false,
        items: [
          NativeSelectItem(
            value: '',
            label: t.settings.providers.detail.models.loading,
          ),
        ],
        onChanged: (_) {},
      );
    }

    if (_modelsFailed || models.isEmpty) {
      return Input(
        controller: _modelController,
        placeholder: t.settings.providers.detail.models.empty,
        mono: true,
      );
    }

    return NativeSelect<String>(
      value: _modelController.text.trim(),
      mono: true,
      semanticsLabel: t.settings.services.editor.row.model,
      items: [
        for (final model in models)
          NativeSelectItem(value: model, label: model),
      ],
      onChanged: (value) => setState(() => _modelController.text = value),
    );
  }

  void _submit() {
    final model = _modelController.text.trim();
    final prompt = _systemPromptController.text.trim();
    Navigator.of(context).pop(
      ServiceDraft(
        id: _serviceId,
        providerId: _providerId,
        type: _type,
        name: _nameController.text.trim(),
        fields: {
          // A traditional provider ignores both, so storing them would only
          // promise something the engine never reads.
          if (_isLlm && model.isNotEmpty) 'model': model,
          if (_isLlm && prompt.isNotEmpty) 'systemPrompt': prompt,
        },
      ),
    );
  }
}
