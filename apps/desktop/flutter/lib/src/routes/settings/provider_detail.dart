import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// An error is worth copying out of, and a selectable run of text is the one
// thing the design system has no equivalent for.
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        BadgeSize,
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        DialogTone,
        Field,
        Input,
        Spinner,
        SpinnerSize;
import 'provider_meta.dart';

/// 提供商详情 — the macOS `ProviderDetailView`: the read-only id, the config
/// fields, the model roster for LLM providers, and the services this provider
/// serves. 删除 / 保存 sit in the page header, as they do in its toolbar.
class ProviderDetailPage extends StatefulWidget {
  const ProviderDetailPage({
    super.key,
    required this.provider,
    required this.services,
    required this.onBack,
    required this.onDeleted,
  });

  final ProviderConfigEntry provider;

  /// The services the runtime derives from — or the user attached to — this
  /// provider.
  final List<ServiceConfigEntry> services;

  final VoidCallback onBack;
  final VoidCallback onDeleted;

  @override
  State<ProviderDetailPage> createState() => _ProviderDetailPageState();
}

class _ProviderDetailPageState extends State<ProviderDetailPage> {
  late Map<String, TextEditingController> _fieldControllers;

  List<String>? _models;
  bool _isLoadingModels = false;
  String? _modelsError;
  String? _errorMessage;
  bool _isSaving = false;
  bool _isDirty = false;

  List<String> get _fieldKeys =>
      kProviderFields[widget.provider.type] ?? const <String>[];

  bool get _hasModelRoster => isLlmProviderType(widget.provider.type);

  /// The model the provider answers with unless a service overrides it. It is
  /// an ordinary field with an ordinary input: the roster below only fills it
  /// in, and a provider whose endpoint will not answer `listModels` still has
  /// to be configurable by hand.
  TextEditingController? get _defaultModelController =>
      _fieldControllers['defaultModel'];

  String get _defaultModel => _defaultModelController?.text.trim() ?? '';

  @override
  void initState() {
    super.initState();
    _fieldControllers = {
      for (final key in _fieldKeys)
        key: TextEditingController(text: widget.provider.fields[key] ?? ''),
    };
    if (_hasModelRoster) _loadModels();
  }

  @override
  void dispose() {
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadModels() async {
    setState(() {
      _isLoadingModels = true;
      _modelsError = null;
    });
    try {
      final models = await runtime.settings().listModels(
        providerId: widget.provider.id,
      );
      if (!mounted) return;
      setState(() => _models = models);
    } catch (_) {
      // The roster is a convenience — a provider with no key yet, or one
      // offline, still has to be configurable.
      if (!mounted) return;
      setState(
        () => _modelsError = t.settings.providers.detail.models.fetch_error,
      );
    } finally {
      if (mounted) setState(() => _isLoadingModels = false);
    }
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    try {
      await runtime.settings().updateProvider(
        providerId: widget.provider.id,
        providerType: providerTypeValue(widget.provider.type),
        fields: {
          for (final entry in _fieldControllers.entries)
            entry.key: entry.value.text.trim(),
        },
      );
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
      if (!mounted) return;
      setState(() => _isDirty = false);
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialogInCurrentWindow<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        tone: DialogTone.danger,
        title: Text(
          formatTranslation(
            t.settings.providers.delete_dialog.title,
            args: [widget.provider.id],
          ),
        ),
        content: Text(t.settings.providers.delete_dialog.message),
        actions: [
          Button(
            variant: ButtonVariant.secondary,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.ui.button.cancel),
          ),
          Button(
            variant: ButtonVariant.warning,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.common.ui.button.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await runtime.settings().deleteProvider(providerId: widget.provider.id);
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
      widget.onDeleted();
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final detail = t.settings.providers.detail;

    return SettingsPage(
      horizontalPadding: 16,
      children: [
        _Header(
          onBack: widget.onBack,
          onDelete: _delete,
          onSave: _isDirty && !_isSaving ? _save : null,
          isSaving: _isSaving,
        ),

        // The provider's identity, at the size the deck gives a page header.
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              ProviderIcon(providerTypeValue(widget.provider.type), size: 26),
              const SizedBox(width: 10),
              Text(
                providerTypeDisplayName(widget.provider.type),
                style: tokens.typography.displayStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.fg,
                ),
              ),
            ],
          ),
        ),

        PreferenceListSection(
          labelInset: 8,
          title: Text(t.settings.providers.editor.row.id),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text(
                    widget.provider.id,
                    style: tokens.typography.monoStyle(
                      fontSize: 12,
                      height: 1,
                      color: colors.fg,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    detail.row.id_hint,
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      height: 1,
                      color: colors.fgFaint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SettingsSectionDivider(),

        PreferenceListSection(
          labelInset: 8,
          title: Text(detail.section.configuration),
          children: [
            if (_fieldControllers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  t.settings.providers.description.fallback,
                  style: tokens.typography.sansStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: colors.fgFaint,
                  ),
                ),
              )
            else
              for (final entry in _fieldControllers.entries)
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                  child: Field(
                    label: Text(_fieldLabel(entry.key)),
                    child: Input(
                      controller: entry.value,
                      obscureText: isSecretField(entry.key),
                      mono: !isSecretField(entry.key),
                      onChanged: (_) => _markDirty(),
                    ),
                  ),
                ),
          ],
        ),

        if (_hasModelRoster) ...[
          const SettingsSectionDivider(),
          PreferenceListSection(
            labelInset: 8,
            title: Text(detail.section.models),
            action: Button(
              variant: ButtonVariant.quiet,
              onPressed: _isLoadingModels ? null : _loadModels,
              child: Text(detail.models.refresh),
            ),
            children: [_buildModels()],
          ),
        ],

        const SettingsSectionDivider(),

        PreferenceListSection(
          labelInset: 8,
          title: Text(t.settings.providers.section.services),
          children: [
            if (widget.services.isEmpty)
              _Note(text: t.settings.providers.item.no_services)
            else
              for (final service in widget.services)
                _ServiceLine(service: service),
          ],
        ),

        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SelectableText(
              _errorMessage!,
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 1.6,
                color: colors.dangerFg,
              ),
            ),
          ),
      ],
    );
  }

  void _markDirty() {
    if (_isDirty) return;
    setState(() => _isDirty = true);
  }

  /// Config keys are shown as the runtime spells them — they are what the
  /// provider's own documentation calls them — except the two the deck names
  /// in prose.
  String _fieldLabel(String key) {
    switch (key) {
      case 'baseUrl':
        return 'Base URL';
      case 'defaultModel':
        return t.settings.providers.editor.row.default_model;
      default:
        return key;
    }
  }

  Widget _buildModels() {
    if (_isLoadingModels && _models == null) {
      return _Note(
        text: t.settings.providers.detail.models.loading,
        leading: const Spinner(size: SpinnerSize.sm),
      );
    }
    if (_modelsError != null && _models == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(child: _Note(text: _modelsError!, padded: false)),
            const SizedBox(width: 10),
            Button(
              variant: ButtonVariant.quiet,
              onPressed: _loadModels,
              child: Text(t.settings.providers.detail.models.retry),
            ),
          ],
        ),
      );
    }

    final models = _models ?? const <String>[];
    if (models.isEmpty) {
      return _Note(text: t.settings.providers.detail.models.empty);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final model in models)
          _ModelRow(
            model: model,
            isDefault: model == _defaultModel,
            // 设为默认 writes into the 默认模型 field rather than a state of its
            // own, so the roster and the input can never disagree.
            onSetDefault: () {
              _defaultModelController?.text = model;
              setState(() => _isDirty = true);
            },
          ),
      ],
    );
  }
}

/// Back on the left, the destructive and the primary action on the right —
/// the provider's toolbar, restated as a page header.
class _Header extends StatelessWidget {
  const _Header({
    required this.onBack,
    required this.onDelete,
    required this.onSave,
    required this.isSaving,
  });

  final VoidCallback onBack;
  final VoidCallback onDelete;
  final VoidCallback? onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Button(
          variant: ButtonVariant.plain,
          onPressed: onBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FluentIcons.chevron_left_20_regular, size: 12),
              const SizedBox(width: 4),
              Text(t.settings.providers.title),
            ],
          ),
        ),
        const Spacer(),
        Button(
          variant: ButtonVariant.warning,
          onPressed: onDelete,
          child: Text(t.common.ui.button.delete),
        ),
        const SizedBox(width: 8),
        Button(
          variant: ButtonVariant.primary,
          onPressed: onSave,
          child: isSaving
              ? const Spinner(size: SpinnerSize.sm, onAccent: true)
              : Text(t.common.ui.button.save),
        ),
      ],
    );
  }
}

/// One model of the roster: the id, whether it is the provider's default, and
/// the way to make it one.
class _ModelRow extends StatelessWidget {
  const _ModelRow({
    required this.model,
    required this.isDefault,
    required this.onSetDefault,
  });

  final String model;
  final bool isDefault;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          Flexible(
            child: Text(
              model,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.monoStyle(
                fontSize: 12,
                height: 1,
                color: isDefault ? tokens.colors.fg : tokens.colors.fgSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isDefault)
            Badge(
              size: BadgeSize.xs,
              child: Text(t.settings.providers.detail.models.default_badge),
            )
          else
            Button(
              variant: ButtonVariant.quiet,
              onPressed: onSetDefault,
              child: Text(t.settings.providers.detail.models.set_default),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// One service this provider serves — the name and what it does. Editing it
/// belongs to 可用服务 on the list page, which owns every service at once.
class _ServiceLine extends StatelessWidget {
  const _ServiceLine({required this.service});

  final ServiceConfigEntry service;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Row(
        children: [
          Flexible(
            child: Text(
              service.name.isEmpty ? service.id : service.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.sansStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1,
                color: tokens.colors.fg,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: tokens.colors.control,
              borderRadius: BorderRadius.circular(tokens.radii.pill),
            ),
            child: Text(
              serviceTypeLabel(service.type),
              style: tokens.typography.sansStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1,
                color: tokens.colors.fgSubtle,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// A de-emphasised line where a group has nothing to show.
class _Note extends StatelessWidget {
  const _Note({required this.text, this.leading, this.padded = true});

  final String text;
  final Widget? leading;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: padded
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : EdgeInsets.zero,
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Flexible(
            child: Text(
              text,
              style: tokens.typography.sansStyle(
                fontSize: 12,
                height: 1.4,
                color: tokens.colors.fgFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
