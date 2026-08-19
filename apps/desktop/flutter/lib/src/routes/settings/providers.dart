// An error is worth copying out of, and a selectable run of text is the one
// thing the design system has no equivalent for.
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        BadgeSize,
        PreferenceRow,
        PreferenceSection,
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        Spinner,
        SpinnerSize;
import 'add_provider_dialog.dart';
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
            .where(
              (service) =>
                  service.providerId == detail.id &&
                  isServiceTypeVisible(service.type),
            )
            .toList(growable: false),
        onBack: () => setState(() => _detailProviderId = null),
        onDeleted: () => setState(() => _detailProviderId = null),
      );
    }

    return SettingsPage(
      children: [
        // 提供商 — credentials and endpoints only. A provider is how to reach a
        // service, not the service itself, so the roster of services lives on
        // 服务; this page only opens a provider's detail.
        PreferenceSection(
          label: Text(t.settings.providers.title),
          action: Button(
            variant: ButtonVariant.primary,
            onPressed: _addProvider,
            child: Text(t.settings.providers.button.add),
          ),
          footer: Text(t.settings.providers.intro.warning),
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
        if (_errorMessage != null) _ErrorBlock(message: _errorMessage!),
      ],
    );
  }

  /// 可用服务, split into the deck's capability groups. Only the groups the
  /// installed providers actually cover appear, and the last one drops its
  /// trailing air so the footnote sits as close to the rows as the label does.
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
        if (kinds.contains(type) && isServiceTypeVisible(type)) type,
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
    // A provider is a preference row like any other: the settings column
    // already knows how to draw a named thing with a control on the right, and
    // a bespoke row here would only drift from it.
    return PreferenceRow(
      icon: ProviderIcon(providerTypeValue(provider.type), size: 18),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              providerTypeDisplayName(provider.type),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isDefault) ...[
            const SizedBox(width: 8),
            Badge(
              size: BadgeSize.xs,
              child: Text(t.settings.providers.detail.models.default_badge),
            ),
          ],
        ],
      ),
      subtitle: Text(_meta()),
      onOpen: onOpen,
      // The capability capsules sit tighter to each other than to the chevron:
      // they are one statement about the provider, not a row of controls.
      trailing: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < capabilities.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              _CapabilityTag(label: serviceTypeLabel(capabilities[i])),
            ],
          ],
        ),
      ],
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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
