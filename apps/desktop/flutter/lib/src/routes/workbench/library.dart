import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Checkbox, IconButton;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/glossary_store.dart';
import '../../services/history_store.dart';
import '../../services/runtime.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/list_card.dart' show ListCard;
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Checkbox,
        DesignThemeContext,
        DesignTypographyStyles,
        EmptyState,
        IconButton,
        Kbd,
        Label,
        Menu,
        MenuAlign,
        MenuItem,
        Rail,
        RailItem,
        SearchField,
        WindowFooter;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import 'history_dialogs.dart';

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
  final Set<String> _selected = {};

  HistoryStore get _store => widget.store ?? historyStore;
  List<HistoryEntry> get _rows => _store.entries;

  /// The rows a footer action applies to. Only a selection has them now: a
  /// single record is acted on from the row itself.
  List<HistoryEntry> get _selectedEntries => [
        for (final entry in _rows)
          if (_selected.contains(entry.id)) entry,
      ];

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
    // The list opens with nothing picked: 收藏 and the ⋯ menu ride on the row
    // under the pointer, so there is no longer an action waiting on a
    // pre-selected one, and a highlight nobody asked for only misleads.
    if (_activeId != null && !ids.contains(_activeId)) _activeId = null;
    setState(() {});
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  Future<void> _setFilter(HistoryFilter filter) => _store.setFilter(filter);

  Future<void> _toggleFavorite(HistoryEntry entry) =>
      _store.favorite(entry.id, !entry.favorite);

  void _leaveSelection() {
    setState(() {
      _selecting = false;
      _selected.clear();
    });
  }

  /// Deleting asks in the shared confirm sheet — 收藏 acts on the row itself,
  /// but anything that throws data away goes through a sheet.
  Future<void> _deleteEntries(List<HistoryEntry> entries) async {
    if (entries.isEmpty) return;
    final strings = t.workbench.history_page;
    final confirmed = await showConfirmDialog(
      context,
      danger: true,
      title: entries.length == 1
          ? strings.delete_title_one
          : strings.delete_title_many(count: entries.length),
      message: strings.delete_message,
      confirmLabel: t.common.ui.button.delete,
    );
    if (!confirmed) return;
    await _store.delete(entries.map((entry) => entry.id).toList());
    if (!mounted) return;
    if (_selecting) _leaveSelection();
  }

  /// 管理历史 — the retention note in the footer is the door to it, since the
  /// fact and the place to change it are one thing. 清空 replaces the sheet
  /// rather than stacking on it.
  Future<void> _openManageDialog() async {
    final strings = t.workbench.history_page;
    final count = _rows.length;
    final clear = await showDialogInCurrentWindow<bool>(
      context: context,
      builder: (_) => ManageHistoryDialog(count: count),
    );
    if (clear != true || !mounted) return;
    final confirmed = await showConfirmDialog(
      context,
      danger: true,
      title: strings.clear_confirm_title,
      message: strings.clear_confirm_message(count: count),
      confirmLabel: t.common.ui.button.delete,
    );
    if (!confirmed) return;
    await _store.delete(_rows.map((entry) => entry.id).toList());
    if (!mounted) return;
    if (_selecting) _leaveSelection();
  }

  Future<void> _copyTranslation(HistoryEntry entry) async {
    await Clipboard.setData(ClipboardData(text: entry.translation));
    BotToast.showText(text: t.workbench.translation.copied);
  }

  Future<void> _addToGlossary(List<HistoryEntry> entries) async {
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

  /// 导出记录 — the sheet picks the shape, the platform's save panel picks the
  /// place, then the file is written.
  Future<void> _export(
      List<HistoryEntry> entries, HistoryExportScope scope) async {
    if (entries.isEmpty) return;
    final draft = await showDialogInCurrentWindow<HistoryExportDraft>(
      context: context,
      builder: (_) => ExportHistoryDialog(
        count: entries.length,
        scope: scope,
      ),
    );
    if (draft == null || !mounted) return;
    final rows = draft.onlyEdited
        ? [
            for (final entry in entries)
              if (entry.edited) entry,
          ]
        : entries;
    if (rows.isEmpty) return;

    final stamp = DateFormat('yyyyMMdd-HHmmss').format(DateTime.now());
    final location = await getSaveLocation(
      suggestedName: 'BeyondTranslate-$stamp.${draft.format.extension}',
      acceptedTypeGroups: [
        XTypeGroup(
          label: draft.format.label,
          extensions: [draft.format.extension],
        ),
      ],
    );
    if (location == null) return;
    try {
      final body = switch (draft.format) {
        HistoryExportFormat.csv => _csvOf(rows, withMeta: draft.withMeta),
        HistoryExportFormat.markdown =>
          _markdownOf(rows, withMeta: draft.withMeta),
        HistoryExportFormat.tmx => _tmxOf(rows),
      };
      await File(location.path).writeAsBytes(
        // The BOM is what makes Excel read the CJK as UTF-8; the other two
        // formats declare their encoding themselves.
        utf8.encode(
          draft.format == HistoryExportFormat.csv ? '\ufeff$body' : body,
        ),
        flush: true,
      );
      BotToast.showText(text: t.workbench.history_page.exported);
      if (mounted && _selecting) _leaveSelection();
    } catch (error) {
      BotToast.showText(
        text: t.workbench.history_page.export_failed(error: '$error'),
      );
    }
  }

  static String _timeOf(HistoryEntry entry) =>
      DateTime.fromMillisecondsSinceEpoch(entry.createdAt * 1000)
          .toIso8601String();

  static String _csvOf(List<HistoryEntry> entries, {required bool withMeta}) {
    final rows = <List<String>>[
      [
        if (withMeta) ...['created_at', 'service', 'origin'],
        'source_language',
        'target_language',
        'source',
        'translation',
        'favorite',
        'edited',
      ],
      for (final entry in entries)
        [
          if (withMeta) ...[
            _timeOf(entry),
            entry.serviceName,
            entry.origin.name,
          ],
          entry.sourceLanguage,
          entry.targetLanguage,
          entry.source,
          entry.translation,
          entry.favorite.toString(),
          entry.edited.toString(),
        ],
    ];
    return '${rows.map((row) => row.map(_escapeCsv).join(',')).join('\r\n')}\r\n';
  }

  /// One block per record: the source quoted, the translation under it, and a
  /// rule between — the readable 对照 a CSV is not.
  static String _markdownOf(
    List<HistoryEntry> entries, {
    required bool withMeta,
  }) {
    final buffer = StringBuffer();
    for (final entry in entries) {
      buffer.writeln('> ${entry.source.replaceAll('\n', '\n> ')}');
      buffer.writeln();
      buffer.writeln(entry.translation);
      if (withMeta) {
        buffer.writeln();
        buffer.writeln(
          '*${entry.serviceName} · ${_timeOf(entry)} · '
          '${entry.sourceLanguage} → ${entry.targetLanguage}*',
        );
      }
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }
    return buffer.toString();
  }

  /// TMX 1.4 — one `<tu>` per record, the pair as its two `<tuv>`s. `*all*` as
  /// the header's source language because a history is not one direction.
  static String _tmxOf(List<HistoryEntry> entries) {
    final buffer = StringBuffer()
      ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
      ..writeln('<tmx version="1.4">')
      ..writeln(
        '  <header creationtool="BeyondTranslate" creationtoolversion="1.0" '
        'segtype="sentence" o-tmf="BeyondTranslate" adminlang="en" '
        'srclang="*all*" datatype="plaintext"/>',
      )
      ..writeln('  <body>');
    for (final entry in entries) {
      buffer
        ..writeln('    <tu>')
        ..writeln('      <tuv xml:lang="${_escapeXml(entry.sourceLanguage)}">')
        ..writeln('        <seg>${_escapeXml(entry.source)}</seg>')
        ..writeln('      </tuv>')
        ..writeln('      <tuv xml:lang="${_escapeXml(entry.targetLanguage)}">')
        ..writeln('        <seg>${_escapeXml(entry.translation)}</seg>')
        ..writeln('      </tuv>')
        ..writeln('    </tu>');
    }
    buffer
      ..writeln('  </body>')
      ..writeln('</tmx>');
    return buffer.toString();
  }

  static String _escapeCsv(String value) => '"${value.replaceAll('"', '""')}"';

  static String _escapeXml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

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
                resizable: true,
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
      return EmptyState(title: Text(strings.loading));
    }
    if (_store.error != null && _rows.isEmpty) {
      return EmptyState(
        title: Text(strings.load_failed),
        action: Button(
          onPressed: _store.reload,
          child: Text(strings.retry),
        ),
      );
    }
    if (_rows.isEmpty) {
      final hasQuery = _store.query.trim().isNotEmpty;
      return EmptyState(
        title: Text(
          hasQuery
              ? strings.no_results(query: _store.query.trim())
              : strings.empty_title,
        ),
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

  /// The footer carries what acts on the *list*; what acts on one record now
  /// rides on the row itself. 多选 turns the list into a selection and the
  /// footer with it.
  Widget _buildFooter(BuildContext context) {
    final strings = t.workbench.history_page;
    final tokens = context.tokens;

    if (_selecting) {
      final entries = _selectedEntries;
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
            onPressed: () => _export(entries, HistoryExportScope.selected),
            child: Text(strings.export),
          ),
          if (kGlossaryFeatureEnabled)
            Button(
              variant: ButtonVariant.quiet,
              enabled: entries.isNotEmpty,
              onPressed: () => _addToGlossary(entries),
              child: Text(strings.add_to_glossary),
            ),
          Button(
            variant: ButtonVariant.quiet,
            enabled: entries.isNotEmpty,
            onPressed: () => _deleteEntries(entries),
            child: Text(t.common.ui.button.delete),
          ),
          const Spacer(),
          Button(
            variant: ButtonVariant.plain,
            onPressed: _leaveSelection,
            child: Text(strings.exit_select),
          ),
        ],
      );
    }

    return WindowFooter(
      children: [
        Button(
          variant: ButtonVariant.plain,
          enabled: _rows.isNotEmpty,
          onPressed: () => setState(() => _selecting = true),
          child: Text(strings.select),
        ),
        Button(
          variant: ButtonVariant.plain,
          enabled: _rows.isNotEmpty,
          onPressed: () => _export(_rows, HistoryExportScope.all),
          child: Text(strings.export_all),
        ),
        const Spacer(),
        // The retention note is the door to 管理历史: the fact and the place to
        // change it are one thing.
        Button(
          variant: ButtonVariant.plain,
          onPressed: _openManageDialog,
          child: Text('${strings.retention_short} · ${strings.manage}'),
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
      onPressed: () =>
          _selecting ? _toggle(entry.id) : setState(() => _activeId = entry.id),
      // 收藏 as a word, because it is the one verb used often enough to deserve
      // a direct hit, and a ⋯ menu for the rest. In a selection the row's own
      // actions step aside for the checkbox.
      actions: _selecting
          ? const []
          : [
              Button(
                variant: ButtonVariant.quiet,
                size: ButtonSize.xs,
                onPressed: () => _toggleFavorite(entry),
                child: Text(
                  entry.favorite ? strings.unfavorite : strings.favorite,
                ),
              ),
              const SizedBox(width: 2),
              Menu(
                align: MenuAlign.end,
                items: [
                  MenuItem(
                    label: strings.copy_translation,
                    shortcut: '⌘C',
                    onSelect: () => _copyTranslation(entry),
                  ),
                  if (kGlossaryFeatureEnabled)
                    MenuItem(
                      label: strings.add_to_glossary,
                      onSelect: () => _addToGlossary([entry]),
                    ),
                  MenuItem(
                    label: t.common.ui.button.delete,
                    onSelect: () => _deleteEntries([entry]),
                  ),
                ],
                trigger: (context, open, toggle) => IconButton(
                  label: strings.more_actions,
                  active: open,
                  icon: const Icon(FluentIcons.more_horizontal_20_regular),
                  iconSize: 16,
                  onPressed: toggle,
                ),
              ),
            ],
    );
  }
}
