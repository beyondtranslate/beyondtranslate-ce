import 'package:flutter/widgets.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/provider_icon/provider_icon.dart';
import '../../widgets/selectable_text.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        Button,
        ButtonVariant,
        PreferenceRow,
        PreferenceSection,
        SearchField,
        Spinner,
        ThemeDataBuildContextProps,
        WidgetSize;
import '../../widgets/workbench.dart' show WorkbenchSearchFocus;
import 'add_provider_dialog.dart';
import 'provider_catalog.dart';
import 'provider_detail.dart';
import 'provider_meta.dart';

/// 设置 · 提供商 — the catalogue, and the detail page it pushes.
///
/// Which providers exist is the engine's to say, so this is a flat catalogue
/// rather than a list of the ones already added: an unconfigured row opens the
/// same detail page, and that page is where its key goes. 提供商 lists
/// connections only — what actually runs lives on 服务.
class ProvidersSettingsPage extends StatefulWidget {
  const ProvidersSettingsPage({super.key});

  @override
  State<ProvidersSettingsPage> createState() => _ProvidersSettingsPageState();
}

/// The detail page that is open: the provider type, the stored provider when
/// there is one, and the key the page was opened under.
///
/// The key stays put when an unconfigured provider is saved and gains an id,
/// so the page keeps its receipt and roster rather than starting over.
typedef _OpenDetail = ({ProviderType type, String? id, String key});

class _ProvidersSettingsPageState extends State<ProvidersSettingsPage> {
  String? _errorMessage;
  bool _isLoading = false;

  /// The provider whose detail page is open, or null on the catalogue. The deck
  /// pushes the page inside the pane rather than routing to it, so the rail
  /// keeps 提供商 selected the whole time.
  _OpenDetail? _detail;

  /// Search is a mode of the catalogue, not a standing input: it opens from
  /// the titlebar, the way 历史 and 术语库 do, and the field then stays pinned
  /// above the list while the list scrolls.
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();
  int _searchRequest = 0;

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    providerHealth.addListener(_handleChanged);
    providersSearchRequest.addListener(_openSearch);
    providersCatalogRequest.addListener(_showCatalog);
    _reload();
    _syncSearchable();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    providerHealth.removeListener(_handleChanged);
    providersSearchRequest.removeListener(_openSearch);
    providersCatalogRequest.removeListener(_showCatalog);
    _searchController.dispose();
    // Leaving the pane is leaving the catalogue and any detail page with it.
    providersSearchable.value = false;
    providerDetailDirty.value = false;
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  /// Tells the settings titlebar whether 搜索 belongs to what is on screen.
  /// After the frame: the titlebar is an ancestor, and it is not rebuilt from
  /// inside a descendant's build.
  void _syncSearchable() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) providersSearchable.value = _detail == null;
    });
  }

  void _openSearch() {
    if (!mounted || _detail != null) return;
    setState(() {
      _searching = true;
      _searchRequest++;
    });
  }

  void _closeSearch() {
    setState(() {
      _searching = false;
      _searchController.clear();
    });
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

  void _openDetail(ProviderType type, String? id) {
    setState(() {
      _detail = (type: type, id: id, key: id ?? 'new:${type.name}');
    });
    _syncSearchable();
  }

  /// Every way back to the catalogue that is not a finished clear goes through
  /// the same question, so a half-typed key is not dropped by a stray click.
  Future<void> _leaveDetail() async {
    if (!await confirmLeavingProviderDetail(context)) return;
    if (!mounted) return;
    _closeDetail();
  }

  /// The rail asked for the catalogue; it has already asked about unsaved
  /// edits on the way.
  void _showCatalog() {
    if (mounted && _detail != null) _closeDetail();
  }

  void _closeDetail() {
    providerDetailDirty.value = false;
    setState(() => _detail = null);
    _syncSearchable();
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
    final added = settingsStore.providers
        .where((provider) => provider.id == providerId)
        .firstOrNull;
    if (added == null) return;
    // A new provider opens on its detail page, where its models are waiting.
    _openDetail(added.type, added.id);
  }

  @override
  Widget build(BuildContext context) {
    // The built-in provider is not the user's to configure, so it has no row
    // here — its fixed services show on 服务.
    final providers = configurableProviders(settingsStore.providers);
    final services = settingsStore.services;

    final detail = _detail;
    if (detail != null) {
      final entry = detail.id == null
          ? null
          : providers.where((provider) => provider.id == detail.id).firstOrNull;
      // The provider can vanish under us — cleared here, or from another
      // window sharing the same runtime. Fall back to the catalogue.
      if (detail.id != null && entry == null && !_isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _detail == detail) _closeDetail();
        });
      }
      return ProviderDetailPage(
        key: ValueKey(detail.key),
        type: detail.type,
        entry: entry,
        services: entry == null
            ? const []
            : services
                .where(
                  (service) =>
                      service.providerId == entry.id &&
                      isServiceTypeVisible(service.type),
                )
                .toList(growable: false),
        onBack: _leaveDetail,
        onCleared: _closeDetail,
        onSaved: (id) => setState(
          () => _detail = (type: detail.type, id: id, key: detail.key),
        ),
      );
    }

    final rows = providerCatalogRows(providers);
    final query = _searchController.text;
    final shown = rows
        .where((row) => providerRowMatches(row, query))
        .toList(growable: false);
    final health = providerHealth.value;

    final list = SettingsPage(
      children: [
        PreferenceSection(
            // The count rides on the heading, the way 历史 reports its own —
            // how many rows follow, so it counts what the search left.
            label: formatTranslation(
              t.settings.providers.section.count,
              args: ['${shown.length}'],
            ),
            // The heading keeps one action. Search is not here: it is the
            // window's, in the titlebar beside 历史's and 术语库's.
            action: Button(
                variant: ButtonVariant.filled,
                size: WidgetSize.tiny,
                onPressed: _addProvider,
                child: Text(t.settings.providers.button.add)),
            footer: t.settings.providers.intro.warning,
            children: [
              if (_isLoading && providers.isEmpty)
                const _LoadingRow()
              else if (shown.isEmpty)
                // The section stays when nothing matches: the way out — 清除搜索
                // — is one of its rows, and dropping the section would leave
                // only the field above to say anything.
                PreferenceRow(
                    title: t.settings.providers.search.no_match_title,
                    subtitle: formatTranslation(
                      t.settings.providers.search.no_match_body,
                      args: [query.trim()],
                    ),
                    trailing: Button(
                        variant: ButtonVariant.plain,
                        onPressed: () => setState(_searchController.clear),
                        child: Text(t.settings.providers.search.clear)))
              else
                for (final row in shown)
                  _ProviderRow(
                    row: row,
                    capabilities: row.entry == null
                        ? const []
                        : _capabilitiesOf(services, row.entry!.id),
                    health: row.entry == null ? null : health[row.entry!.id],
                    isDefault:
                        row.entry != null && _isDefaultProvider(row.entry!.id),
                    // Two providers of one type are told apart by their id.
                    showId: row.entry != null &&
                        rows.where((other) => other.type == row.type).length >
                            1,
                    onOpen: () => _openDetail(row.type, row.entry?.id),
                  ),
            ]),
        if (_errorMessage != null) _ErrorBlock(message: _errorMessage!),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_searching) _buildSearchBar(context),
        Expanded(child: list),
      ],
    );
  }

  /// The field, pinned above the scroll area so the list scrolls under it.
  Widget _buildSearchBar(BuildContext context) {
    final vars = context.vars;
    final search = t.settings.providers.search;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Semantics(
        label: search.label,
        child: WorkbenchSearchFocus(
          request: _searchRequest,
          child: SearchField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            placeholder: search.placeholder,
            clearLabel: search.clear,
            // Escape is the field's own: it clears a query first and only
            // dismisses an empty field.
            onDismiss: _closeSearch,
          ),
        ),
      ),
    );
  }

  /// The capabilities a provider lends the app — what its services serve, in
  /// the deck's order.
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

/// One row of the catalogue. Its second line is live: it says what the
/// provider is like now, not what it once asked for.
class _ProviderRow extends StatelessWidget {
  const _ProviderRow({
    required this.row,
    required this.capabilities,
    required this.health,
    required this.isDefault,
    required this.showId,
    required this.onOpen,
  });

  final ProviderCatalogRow row;
  final List<ServiceType> capabilities;

  /// Null for a provider this session has not asked yet.
  final ProviderHealth? health;
  final bool isDefault;
  final bool showId;
  final VoidCallback onOpen;

  bool get _configured => row.entry != null;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final icon = ProviderIcon(row.type, size: 18);

    return ProviderSettingsRow(
        // An unconfigured row recedes — a greyed mark, a quieter name — so the
        // connected ones read first down the column.
        icon: _configured ? icon : _MutedMark(child: icon),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                providerTypeDisplayName(row.type),
                style: _configured
                    ? null
                    : TextStyle(color: vars.colorContentMuted),
              ),
            ),
            if (isDefault) ...[
              const SizedBox(width: 8),
              Badge(
                  size: WidgetSize.small,
                  child:
                      Text(t.settings.providers.detail.models.default_badge)),
            ],
          ],
        ),
        subtitle: Text(
          _meta(),
          style: _configured ? null : TextStyle(color: vars.colorContentFaint),
        ),
        // One column of state at the row's end: capabilities when it is
        // running, a dashed 未配置 when it is empty, and a red mark when there
        // is something to fix — which does not take away that it still serves.
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            if (!_configured)
              _StatusTag.unconfigured()
            else ...[
              for (final capability in capabilities)
                _StatusTag(label: serviceTypeLabel(capability)),
              if (health == ProviderHealth.invalid) _StatusTag.invalid(),
              if (health == ProviderHealth.unverified) _StatusTag.unverified(),
            ],
          ],
        ),
        onPressed: onOpen);
  }

  /// A connected provider says what it runs and how the endpoint last
  /// answered; an unconfigured one says what it needs.
  ///
  /// 密钥有效 only follows an answer this session actually got, and a provider
  /// with no key — Ollama — says 连接可用 instead: either phrase before the
  /// endpoint has been asked would be a claim nobody checked.
  String _meta() {
    final entry = row.entry;
    if (entry == null) return providerNeedLine(row.type);
    final meta = t.settings.providers.meta;
    if (health == ProviderHealth.invalid) return meta.invalid;
    final model = entry.fields['defaultModel']?.trim() ?? '';
    final parts = [
      if (model.isNotEmpty) model,
      if (health == ProviderHealth.ok)
        (kProviderFields[row.type] ?? const <String>[]).any(isSecretField)
            ? meta.key_valid
            : meta.reachable,
      if (showId) entry.id,
    ];
    return parts.isEmpty ? entry.id : parts.join(' · ');
  }
}

/// A provider mark with its colour taken out, for a row nobody configured.
class _MutedMark extends StatelessWidget {
  const _MutedMark({required this.child});

  final Widget child;

  static const _greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 0.45, 0, //
  ]);

  @override
  Widget build(BuildContext context) =>
      ColorFiltered(colorFilter: _greyscale, child: child);
}

/// A capsule in a row's state column — 翻译 / 查词 / OCR, 未配置, 待验证 and
/// 需重新验证 share one size, so the column reads as one line of state rather
/// than a heap of buttons.
class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.label}) : _kind = _TagKind.neutral;

  _StatusTag.unconfigured()
      : label = t.settings.providers.status.unconfigured,
        _kind = _TagKind.dashed;

  _StatusTag.unverified()
      : label = t.settings.providers.status.unverified,
        _kind = _TagKind.neutral;

  _StatusTag.invalid()
      : label = t.settings.providers.status.invalid,
        _kind = _TagKind.danger;

  final String label;
  final _TagKind _kind;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    final text = Text(
      label,
      style: vars.sansStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1,
        color: switch (_kind) {
          _TagKind.neutral => vars.colorContentSubtle,
          _TagKind.dashed => vars.colorContentFaint,
          _TagKind.danger => vars.dangerFg,
        },
      ),
    );
    const padding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);

    if (_kind == _TagKind.dashed) {
      // Outlined and unfilled: an empty slot, not a capability switched off.
      return CustomPaint(
        painter: _DashedPillPainter(
          color: vars.colorBorder,
          strokeWidth: context.hairlineWidth,
        ),
        child: Padding(padding: padding, child: text),
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _kind == _TagKind.danger
            ? vars.dangerSurface
            : vars.colorSurfaceInset,
        borderRadius: BorderRadius.circular(vars.radiusFull),
      ),
      child: text,
    );
  }
}

enum _TagKind { neutral, dashed, danger }

/// A hairline dashed outline around a pill.
class _DashedPillPainter extends CustomPainter {
  const _DashedPillPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(size.height)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    const dash = 3.0;
    const gap = 2.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPillPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Spinner(size: WidgetSize.small),
          const SizedBox(width: 10),
          Text(
            t.settings.providers.item.loading,
            style: vars.sansStyle(
              fontSize: 12,
              height: 1,
              color: vars.colorContentSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SelectableTextBlock(
        message,
        style: vars.sansStyle(
          fontSize: 11,
          height: 1.6,
          color: vars.dangerFg,
        ),
      ),
    );
  }
}
