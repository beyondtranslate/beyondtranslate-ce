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
import '../../widgets/list_tile.dart' show ListTile, ListTileVariant;
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
        Label,
        LabelTone,
        Spinner,
        SpinnerSize;
import 'add_provider_dialog.dart';
import 'add_service_dialog.dart';
import 'provider_detail.dart';
import 'provider_meta.dart';

/// 设置 · 提供商 — the deck's two-group pane.
///
/// 提供商 lists credentials and endpoints only: a row opens its detail page,
/// and what actually runs lives under 可用服务, grouped by capability the way
/// the macOS page splits 翻译 / 查词 / OCR.
class ProvidersSettingsPage extends StatefulWidget {
  const ProvidersSettingsPage({super.key});

  @override
  State<ProvidersSettingsPage> createState() => _ProvidersSettingsPageState();
}

class _ProvidersSettingsPageState extends State<ProvidersSettingsPage> {
  String? _errorMessage;
  bool _isLoading = false;

  /// The provider whose detail page is open, or null on the list. The deck
  /// pushes the page inside the pane rather than routing to it, so the rail
  /// keeps 提供商 selected the whole time.
  String? _detailProviderId;

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    _reload();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await Future.wait([
        settingsStore.reloadProviders(),
        settingsStore.reloadServices(),
      ]);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addProvider() async {
    // The sheet writes and tests the provider itself — it has to, to ask the
    // real endpoint anything — so it hands back only the id it settled on.
    final providerId = await showDialogInCurrentWindow<String>(
      context: context,
      // Losing a half-filled key to a stray click on the scrim is worse than
      // making the flow ask for 取消.
      barrierDismissible: false,
      builder: (_) => const AddProviderDialog(),
    );
    if (providerId == null || !mounted) return;
    // A new provider opens on its detail page, where its models are waiting.
    setState(() => _detailProviderId = providerId);
  }

  Future<void> _openServiceEditor({ServiceConfigEntry? existing}) async {
    final draft = await showDialogInCurrentWindow<ServiceDraft>(
      context: context,
      builder: (_) => AddServiceDialog(
        providers: settingsStore.providers,
        // The derived services count as taken ids, so a second service of the
        // same kind gets a suffix instead of shadowing the provider's own.
        existing: settingsStore.services,
        service: existing,
      ),
    );
    if (draft == null) return;

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
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _deleteService(ServiceConfigEntry entry) async {
    final confirmed = await showDialogInCurrentWindow<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        tone: DialogTone.danger,
        title: Text(
          formatTranslation(
            t.settings.services.detail.delete_dialog.title,
            args: [entry.name.isEmpty ? entry.id : entry.name],
          ),
        ),
        content: Text(t.settings.services.detail.delete_dialog.message),
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
      await runtime.settings().deleteService(serviceId: entry.id);
      await settingsStore.reloadServices();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = settingsStore.providers;
    final services = settingsStore.services;

    final detail = _detailProviderId == null
        ? null
        : providers
            .where((provider) => provider.id == _detailProviderId)
            .firstOrNull;
    // The provider can vanish under us — deleted here, or from the macOS
    // settings window sharing the same runtime. Fall back to the list.
    if (_detailProviderId != null && detail == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _detailProviderId = null);
      });
    }

    if (detail != null) {
      return ProviderDetailPage(
        provider: detail,
        services: services
            .where((service) => service.providerId == detail.id)
            .toList(growable: false),
        onBack: () => setState(() => _detailProviderId = null),
        onDeleted: () => setState(() => _detailProviderId = null),
      );
    }

    return SettingsPage(
      // The rows bleed their hover wash 8px past the text; the groups push
      // their prose back out by the same amount.
      horizontalPadding: 16,
      children: [
        PreferenceListSection(
          labelInset: 8,
          title: Text(t.settings.providers.title),
          action: Button(
            variant: ButtonVariant.primary,
            onPressed: _addProvider,
            child: Text(t.settings.providers.button.add),
          ),
          description: Text(t.settings.providers.intro.warning),
          children: [
            if (_isLoading)
              const _LoadingRow()
            else if (providers.isEmpty)
              _PlaceholderRow(text: t.settings.providers.item.empty)
            else
              for (final provider in providers)
                _ProviderRow(
                  provider: provider,
                  capabilities: _capabilitiesOf(services, provider.id),
                  isDefault: _isDefaultProvider(provider.id),
                  onOpen: () => setState(() => _detailProviderId = provider.id),
                ),
          ],
        ),
        const SettingsSectionDivider(),
        PreferenceListSection(
          labelInset: 8,
          title: Text(t.settings.providers.section.services),
          action: Button(
            variant: ButtonVariant.quiet,
            onPressed: providers.isEmpty ? null : () => _openServiceEditor(),
            child: Text(t.settings.services.button.add_service),
          ),
          description: Text(t.settings.providers.section.services_description),
          children: [
            if (_isLoading)
              const _LoadingRow()
            else if (services.isEmpty)
              _PlaceholderRow(text: t.settings.providers.item.no_services)
            else
              ..._buildServiceGroups(services, providers),
          ],
        ),
        if (_errorMessage != null) _ErrorBlock(message: _errorMessage!),
      ],
    );
  }

  /// 可用服务, split into the deck's capability groups. Only the groups the
  /// installed providers actually cover appear, and the last one drops its
  /// trailing air so the footnote sits as close to the rows as the label does.
  List<Widget> _buildServiceGroups(
    List<ServiceConfigEntry> services,
    List<ProviderConfigEntry> providers,
  ) {
    final types = [
      for (final type in kServiceTypeOrder)
        if (services.any((service) => service.type == type)) type,
    ];
    return [
      for (final (index, type) in types.indexed)
        _ServiceGroup(
          type: type,
          services:
              services.where((s) => s.type == type).toList(growable: false),
          providers: providers,
          isLast: index == types.length - 1,
          onEdit: (service) => _openServiceEditor(existing: service),
          onDelete: _deleteService,
        ),
    ];
  }

  /// The capability tags a provider row carries — one per service the runtime
  /// derives from it, in the deck's order.
  List<ServiceType> _capabilitiesOf(
    List<ServiceConfigEntry> services,
    String providerId,
  ) {
    final kinds = services
        .where((service) => service.providerId == providerId)
        .map((service) => service.type)
        .toSet();
    return [
      for (final type in kServiceTypeOrder)
        if (kinds.contains(type)) type,
    ];
  }

  /// The provider behind the app's default translation service wears 默认, the
  /// way the deck marks 内置模型.
  bool _isDefaultProvider(String providerId) {
    final defaultService = settingsStore.general.defaultTranslationService;
    if (defaultService.isEmpty) return false;
    return providerIdOfService(defaultService) == providerId;
  }
}

/// One row of 提供商: the mark, the name, what it is set to, and the
/// capabilities it lends the app. Everything that does not fit goes to the
/// detail page the chevron opens — the same split the macOS list makes.
class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    required this.provider,
    required this.capabilities,
    required this.isDefault,
    required this.onOpen,
  });

  final ProviderConfigEntry provider;
  final List<ServiceType> capabilities;
  final bool isDefault;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        variant: ListTileVariant.row,
        leading: ProviderIcon(providerTypeValue(provider.type), size: 18),
        title: Text(providerTypeDisplayName(provider.type)),
        badge: isDefault
            ? Badge(
                size: BadgeSize.xs,
                child: Text(t.settings.providers.detail.models.default_badge),
              )
            : null,
        meta: Text(_meta()),
        trailing: [
          for (final capability in capabilities)
            _CapabilityTag(label: serviceTypeLabel(capability)),
          Icon(
            FluentIcons.chevron_right_20_regular,
            size: 13,
            color: context.colors.fgFaint,
          ),
        ],
        onPressed: onOpen,
      ),
    );
  }

  /// The deck prints the model and the key's health here. We can vouch for the
  /// model but not the key, so the id stands in — it is what tells two
  /// providers of the same type apart anyway.
  String _meta() {
    final model = provider.fields['defaultModel']?.trim() ?? '';
    return model.isEmpty ? provider.id : '$model · ${provider.id}';
  }
}

/// One capability of 可用服务, with its rows.
class _ServiceGroup extends StatelessWidget {
  const _ServiceGroup({
    required this.type,
    required this.services,
    required this.providers,
    required this.isLast,
    required this.onEdit,
    required this.onDelete,
  });

  final ServiceType type;
  final List<ServiceConfigEntry> services;
  final List<ProviderConfigEntry> providers;
  final bool isLast;
  final ValueChanged<ServiceConfigEntry> onEdit;
  final ValueChanged<ServiceConfigEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Label(
              tone: LabelTone.faint,
              child: Text(serviceTypeLabel(type)),
            ),
          ),
          for (final service in services)
            _ServiceRow(
              service: service,
              provider: providers
                  .where((entry) => entry.id == service.providerId)
                  .firstOrNull,
              onEdit: () => onEdit(service),
              onDelete: () => onDelete(service),
            ),
        ],
      ),
    );
  }
}

/// One row of 可用服务 — the thing that actually runs.
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.provider,
    required this.onEdit,
    required this.onDelete,
  });

  final ServiceConfigEntry service;
  final ProviderConfigEntry? provider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final name = service.name.isEmpty ? service.id : service.name;
    // A synthesised service is the provider's own capability: it has nothing
    // of its own to edit, and it goes when the provider does.
    final owned = !isImplicitService(service);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          ProviderIcon(
            providerTypeValue(provider?.type ?? ProviderType.system),
            size: 16,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.sansStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1,
                color: colors.fg,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              service.providerId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.monoStyle(
                fontSize: 11,
                height: 1,
                color: colors.fgSubtle,
              ),
            ),
          ),
          const Spacer(),
          if (owned) ...[
            Button(
              variant: ButtonVariant.quiet,
              onPressed: onEdit,
              child: Text(t.common.ui.button.edit),
            ),
            Button(
              variant: ButtonVariant.warning,
              onPressed: onDelete,
              child: Text(t.common.ui.button.delete),
            ),
          ],
        ],
      ),
    );
  }
}

/// The capability capsule on a provider row — 翻译 / 查词 / OCR.
class _CapabilityTag extends StatelessWidget {
  const _CapabilityTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: tokens.colors.control,
        borderRadius: BorderRadius.circular(tokens.radii.pill),
      ),
      child: Text(
        label,
        style: tokens.typography.sansStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 1,
          color: tokens.colors.fgSubtle,
        ),
      ),
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          const Spinner(size: SpinnerSize.sm),
          const SizedBox(width: 10),
          Text(
            t.settings.providers.item.loading,
            style: tokens.typography.sansStyle(
              fontSize: 12,
              height: 1,
              color: tokens.colors.fgSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

/// What a group shows before it has anything — the deck's 暂无可用服务.
class _PlaceholderRow extends StatelessWidget {
  const _PlaceholderRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        text,
        style: tokens.typography.sansStyle(
          fontSize: 12,
          height: 1.4,
          color: tokens.colors.fgFaint,
        ),
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SelectableText(
        message,
        style: tokens.typography.sansStyle(
          fontSize: 11,
          height: 1.6,
          color: tokens.colors.dangerFg,
        ),
      ),
    );
  }
}
