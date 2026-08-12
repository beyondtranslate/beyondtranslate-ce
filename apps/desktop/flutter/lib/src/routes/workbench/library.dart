import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart' hide Checkbox;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../i18n/i18n.dart';
import '../../services/glossary_store.dart';
import '../../services/history_store.dart';
import '../../services/runtime.dart';
import '../../widgets/list_card.dart' show ListCard;
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        Checkbox,
        DesignThemeContext,
        DesignTypographyStyles,
        EmptyState,
        Kbd,
        Label,
        Rail,
        RailItem,
        SearchField,
        WindowFooter;
import '../../widgets/workbench.dart' show WorkbenchToolbar;

class WorkbenchLibraryPage extends StatefulWidget {
  const WorkbenchLibraryPage({super.key, this.store});

  final HistoryStore? store;

  @override
  State<WorkbenchLibraryPage> createState() => _WorkbenchLibraryPageState();
}

class _WorkbenchLibraryPageState extends State<WorkbenchLibraryPage> {
  String? _activeId;
  bool _searching = false;
  bool _selecting = false;
  bool _confirmingDelete = false;
  final Set<String> _selected = {};

  HistoryStore get _store => widget.store ?? historyStore;
  List<HistoryEntry> get _rows => _store.entries;

  HistoryEntry? get _active {
    final id = _activeId;
    if (id == null) return null;
    for (final entry in _rows) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  List<HistoryEntry> get _actionEntries {
    if (_selecting) {
      return [
        for (final entry in _rows)
          if (_selected.contains(entry.id)) entry,
      ];
    }
    final active = _active;
    return active == null ? const [] : [active];
  }

  @override
  void initState() {
    super.initState();
    _store.addListener(_handleStoreChanged);
    _store.reload();
  }

  @override
  void dispose() {
    _store.removeListener(_handleStoreChanged);
    super.dispose();
  }

  void _handleStoreChanged() {
    if (!mounted) return;
    final ids = _rows.map((entry) => entry.id).toSet();
    _selected.removeWhere((id) => !ids.contains(id));
    if (_activeId == null || !ids.contains(_activeId)) {
      _activeId = _rows.firstOrNull?.id;
    }
    setState(() {});
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
      _confirmingDelete = false;
    });
  }

  Future<void> _setFilter(HistoryFilter filter) async {
    _confirmingDelete = false;
    await _store.setFilter(filter);
  }

  Future<void> _toggleFavorite() async {
    final active = _active;
    if (active == null) return;
    await _store.favorite(active.id, !active.favorite);
  }

  Future<void> _deleteEntries() async {
    final entries = _actionEntries;
    if (entries.isEmpty) return;
    await _store.delete(entries.map((entry) => entry.id).toList());
    if (!mounted) return;
    setState(() {
      _confirmingDelete = false;
      _selected.clear();
      if (_selecting) _selecting = false;
    });
  }

  Future<void> _addToGlossary() async {
    final entries = _actionEntries;
    if (entries.isEmpty) return;
    if (glossaryStore.selectedBook == null) {
      BotToast.showText(text: t.workbench.history_page.no_glossary);
      if (mounted) context.go('/glossary');
      return;
    }
    var saved = 0;
    for (final entry in entries) {
      final result = await glossaryStore.saveEntry(
        term: entry.source,
        translation: entry.translation,
      );
      if (result != null) saved++;
    }
    if (saved > 0) {
      BotToast.showText(
        text: t.workbench.history_page.added_to_glossary(count: saved),
      );
    }
  }

  Future<void> _exportCsv() async {
    final entries = _actionEntries;
    if (entries.isEmpty) return;
    final location = await getSaveLocation(
      suggestedName:
          'BeyondTranslate-${DateFormat('yyyyMMdd-HHmmss').format(DateTime.now())}.csv',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'CSV', extensions: ['csv']),
      ],
    );
    if (location == null) return;
    try {
      final rows = <List<String>>[
        const [
          'created_at',
          'source_language',
          'target_language',
          'service',
          'origin',
          'source',
          'translation',
          'favorite',
          'edited',
        ],
        for (final entry in entries)
          [
            DateTime.fromMillisecondsSinceEpoch(entry.createdAt * 1000)
                .toIso8601String(),
            entry.sourceLanguage,
            entry.targetLanguage,
            entry.serviceName,
            entry.origin.name,
            entry.source,
            entry.translation,
            entry.favorite.toString(),
            entry.edited.toString(),
          ],
      ];
      final csv = rows.map((row) => row.map(_escapeCsv).join(',')).join('\r\n');
      await File(location.path).writeAsBytes(
        utf8.encode('\ufeff$csv\r\n'),
        flush: true,
      );
      BotToast.showText(text: t.workbench.history_page.exported);
    } catch (error) {
      BotToast.showText(
        text: t.workbench.history_page.export_failed(error: '$error'),
      );
    }
  }

  static String _escapeCsv(String value) => '"${value.replaceAll('"', '""')}"';

  @override
  Widget build(BuildContext context) {
    final strings = t.workbench.history_page;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkbenchToolbar(
          title: t.workbench.history,
          children: [
            const Spacer(),
            Button(
              variant: ButtonVariant.ghost,
              shortcut: const Text('⌘F'),
              onPressed: () => setState(() => _searching = true),
              child: Text(strings.search),
            ),
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Rail(
                children: [
                  RailItem(
                    active: _store.filter == HistoryFilter.all,
                    onPressed: () => _setFilter(HistoryFilter.all),
                    child: Text('${strings.all} ${_store.counts.all}'),
                  ),
                  RailItem(
                    active: _store.filter == HistoryFilter.favorites,
                    onPressed: () => _setFilter(HistoryFilter.favorites),
                    child: Text(
                      '${strings.favorites} ${_store.counts.favorites}',
                    ),
                  ),
                  RailItem(
                    active: _store.filter == HistoryFilter.edited,
                    onPressed: () => _setFilter(HistoryFilter.edited),
                    child: Text(
                      '${strings.edited} ${_store.counts.edited}',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStrip(context),
                    Expanded(child: _buildFeed(context)),
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStrip(BuildContext context) {
    final colors = context.colors;
    final strings = t.workbench.history_page;
    final label = switch (_store.filter) {
      HistoryFilter.all => strings.all,
      HistoryFilter.favorites => strings.favorites,
      HistoryFilter.edited => strings.edited,
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.hairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: _searching
          ? SearchField(
              autofocus: true,
              value: _store.query,
              onChanged: _store.setQuery,
              placeholder: strings.search_placeholder,
              onDismiss: () {
                _store.setQuery('');
                setState(() => _searching = false);
              },
              semanticsLabel: strings.search_label,
            )
          : Row(
              children: [
                Label(
                  child: Text(
                    strings.entry_count(label: label, count: _rows.length),
                  ),
                ),
                const Spacer(),
                Kbd(strings.by_time),
              ],
            ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    final strings = t.workbench.history_page;
    if (_store.isLoading && _rows.isEmpty) {
      return EmptyState(
        label: Text(t.workbench.history),
        title: Text(strings.loading),
      );
    }
    if (_store.error != null && _rows.isEmpty) {
      return EmptyState(
        label: Text(t.workbench.history),
        title: Text(strings.load_failed),
        description: Text(_store.error!),
        action: Button(
          onPressed: _store.reload,
          child: Text(strings.retry),
        ),
      );
    }
    if (_rows.isEmpty) {
      final hasQuery = _store.query.trim().isNotEmpty;
      return EmptyState(
        label: Text(t.workbench.history),
        title: Text(
          hasQuery
              ? strings.no_results(query: _store.query.trim())
              : strings.empty_title,
        ),
        description: Text(strings.empty_description),
        action: hasQuery
            ? Button(
                onPressed: () => _store.setQuery(''),
                child: Text(strings.clear_search),
              )
            : null,
      );
    }
    final colors = context.colors;
    return ListView(
      children: [
        for (final entry in _rows)
          _selecting
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, top: 18),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: colors.hairlineSoft,
                              width: context.hairlineWidth,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Checkbox(
                            checked: _selected.contains(entry.id),
                            onChanged: (_) => _toggle(entry.id),
                            child: const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      Expanded(child: _buildRow(entry)),
                    ],
                  ),
                )
              : _buildRow(entry),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final strings = t.workbench.history_page;
    final tokens = context.tokens;
    final entries = _actionEntries;
    if (_confirmingDelete) {
      return WindowFooter(
        children: [
          Expanded(
            child: Text(
              strings.delete_confirm(count: entries.length),
              style: tokens.typography.sansStyle(fontSize: 11, height: 1.2),
            ),
          ),
          Button(
            variant: ButtonVariant.warning,
            onPressed: _deleteEntries,
            child: Text(t.common.ui.button.delete),
          ),
          Button(
            variant: ButtonVariant.plain,
            onPressed: () => setState(() => _confirmingDelete = false),
            child: Text(t.common.ui.button.cancel),
          ),
        ],
      );
    }
    if (_selecting) {
      return WindowFooter(
        children: [
          Text(
            strings.selected_count(count: _selected.length),
            style: tokens.typography.sansStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Button(
            variant: ButtonVariant.quiet,
            enabled: entries.isNotEmpty,
            onPressed: _exportCsv,
            child: Text(strings.export),
          ),
          Button(
            variant: ButtonVariant.quiet,
            enabled: entries.isNotEmpty,
            onPressed: _addToGlossary,
            child: Text(strings.add_to_glossary),
          ),
          Button(
            variant: ButtonVariant.quiet,
            enabled: entries.isNotEmpty,
            onPressed: () => setState(() => _confirmingDelete = true),
            child: Text(t.common.ui.button.delete),
          ),
          const Spacer(),
          Button(
            variant: ButtonVariant.plain,
            onPressed: () => setState(() {
              _selecting = false;
              _selected.clear();
            }),
            child: Text(strings.exit_select),
          ),
        ],
      );
    }
    final active = _active;
    return WindowFooter(
      children: [
        Button(
          variant: ButtonVariant.plain,
          enabled: active != null,
          onPressed: _toggleFavorite,
          child: Text(
            active?.favorite == true ? strings.unfavorite : strings.favorite,
          ),
        ),
        Button(
          variant: ButtonVariant.plain,
          enabled: active != null,
          onPressed: _exportCsv,
          child: Text(strings.export),
        ),
        Button(
          variant: ButtonVariant.plain,
          enabled: active != null,
          onPressed: _addToGlossary,
          child: Text(strings.add_to_glossary),
        ),
        Button(
          variant: ButtonVariant.plain,
          enabled: active != null,
          onPressed: () => setState(() => _confirmingDelete = true),
          child: Text(t.common.ui.button.delete),
        ),
        Button(
          variant: ButtonVariant.plain,
          onPressed: () => setState(() => _selecting = true),
          child: Text(strings.select),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            strings.retention,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.sansStyle(
              fontSize: 11,
              height: 1,
              color: tokens.colors.fgFaint,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(HistoryEntry entry) {
    final strings = t.workbench.history_page;
    final time = DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(entry.createdAt * 1000),
    );
    final origin = entry.origin == HistoryOrigin.workbench
        ? strings.origin_workbench
        : strings.origin_mini;
    final flags = [
      if (entry.favorite) strings.favorite_flag,
      if (entry.edited) strings.edited_flag,
    ];
    final active =
        _selecting ? _selected.contains(entry.id) : entry.id == _activeId;
    return ListCard(
      eyebrow: Text(
        entry.serviceName.isEmpty ? entry.serviceId : entry.serviceName,
      ),
      meta: Text('$time · $origin'),
      flag: flags.isEmpty ? null : Text(flags.join(' · ')),
      primary: Text(entry.source),
      secondary: Text(entry.translation),
      active: active,
      onPressed: () => _selecting
          ? _toggle(entry.id)
          : setState(() {
              _activeId = entry.id;
              _confirmingDelete = false;
            }),
    );
  }
}
