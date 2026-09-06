import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Checkbox, IconButton;
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, LogicalKeyboardKey;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../features.dart';
import '../../i18n/i18n.dart';
import '../../services/glossary_store.dart';
import '../../services/history_store.dart';
import '../../services/runtime.dart';
import '../../theme/product_tokens.dart' show ProductTypography;
import '../../widgets/confirm_dialog.dart';
import '../../widgets/list_card.dart' show ListCard;
import '../../widgets/native_menu.dart'
    show NativeMenu, NativeMenuAlign, NativeMenuItem;
import '../../widgets/nav_columns.dart' show Rail, RailItem;
import '../../widgets/toast_host.dart' show showToast;
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        Checkbox,
        EmptyState,
        IconButton,
        KeyCap,
        SearchField,
        SectionLabel,
        ThemeDataBuildContextProps,
        ToastTint,
        WidgetSize;
import '../../widgets/window_chrome.dart' show WindowFooter;
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

  /// The kit's search field is controller-driven, so the query lives here and
  /// the store is told about it on change.
  final TextEditingController _searchController = TextEditingController();
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

  Future<void> _copyTranslation(HistoryEntry entry) async {
    await Clipboard.setData(ClipboardData(text: entry.translation));
    if (!mounted) return;
    showToast(context, t.workbench.translation.copied, tone: ToastTint.success);
  }

  Future<void> _addToGlossary(List<HistoryEntry> entries) async {
    if (entries.isEmpty) return;
    if (glossaryStore.selectedBook == null) {
      showToast(context, t.workbench.history_page.no_glossary);
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
    if (saved > 0 && mounted) {
      showToast(
        context,
        t.workbench.history_page.added_to_glossary(count: saved),
        tone: ToastTint.success,
      );
    }
  }

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
                variant: ButtonVariant.recessed,
                shortcut: const Text('⌘F'),
                onPressed: () => setState(() => _searching = true),
                child: Text(strings.search)),
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
    final vars = context.vars;
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
            color: vars.colorBorder,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: _searching
          ? Semantics(
              label: strings.search_label,
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.escape): () {
                    _searchController.clear();
                    _store.setQuery('');
                    setState(() => _searching = false);
                  },
                },
                child: SearchField(
                  controller: _searchController,
                  onChanged: _store.setQuery,
                  placeholder: strings.search_placeholder,
                ),
              ),
            )
          : Row(
              children: [
                SectionLabel(
                    strings.entry_count(label: label, count: _rows.length)),
                const Spacer(),
                KeyCap(strings.by_time),
              ],
            ),
    );
  }

  Widget _buildFeed(BuildContext context) {
    final strings = t.workbench.history_page;
    if (_store.isLoading && _rows.isEmpty) {
      return EmptyState(title: strings.loading);
    }
    if (_store.error != null && _rows.isEmpty) {
      return EmptyState(title: strings.load_failed, actions: [
        Button(onPressed: _store.reload, child: Text(strings.retry))
      ]);
    }
    if (_rows.isEmpty) {
      final hasQuery = _store.query.trim().isNotEmpty;
      return EmptyState(
          title: hasQuery
              ? strings.no_results(query: _store.query.trim())
              : strings.empty_title,
          actions: [
            if (hasQuery)
              Button(
                  onPressed: () => _store.setQuery(''),
                  child: Text(strings.clear_search))
          ]);
    }
    final vars = context.vars;
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
                              color: vars.colorBorder,
                              width: context.hairlineWidth,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Checkbox(
                              value: _selected.contains(entry.id),
                              onChanged: (_) => _toggle(entry.id),
                              label: const SizedBox.shrink()),
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
    final vars = context.vars;

    if (_selecting) {
      final entries = _selectedEntries;
      return WindowFooter(
        children: [
          Text(
            strings.selected_count(count: _selected.length),
            style: vars.sansStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          if (kGlossaryFeatureEnabled)
            Button(
                variant: ButtonVariant.plain,
                onPressed:
                    entries.isNotEmpty ? () => _addToGlossary(entries) : null,
                child: Text(strings.add_to_glossary)),
          Button(
              variant: ButtonVariant.plain,
              onPressed:
                  entries.isNotEmpty ? () => _deleteEntries(entries) : null,
              child: Text(t.common.ui.button.delete)),
          const Spacer(),
          Button(
              variant: ButtonVariant.plain,
              onPressed: _leaveSelection,
              child: Text(strings.exit_select)),
        ],
      );
    }

    return WindowFooter(
      children: [
        Button(
            variant: ButtonVariant.plain,
            onPressed: _rows.isNotEmpty
                ? () => setState(() => _selecting = true)
                : null,
            child: Text(strings.select)),
      ],
    );
  }

  Widget _buildRow(HistoryEntry entry) {
    final strings = t.workbench.history_page;
    final time = DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(entry.createdAt * 1000),
    );
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
      meta: Text(time),
      flag: flags.isEmpty ? null : Text(flags.join(' · ')),
      primary: entry.source,
      secondary: entry.translation,
      active: active,
      // 一段摘要式的记录在列表里只露原文两行、译文三行；点开才是全文，再点
      // 收起。多选时保持收起 —— 勾选是在挑记录，不是在读记录。
      expanded: !_selecting && entry.id == _activeId,
      expandable: !_selecting,
      onPressed: () => _selecting
          ? _toggle(entry.id)
          : setState(
              () => _activeId = _activeId == entry.id ? null : entry.id,
            ),
      // 收藏 as a word, because it is the one verb used often enough to deserve
      // a direct hit, and a ⋯ menu for the rest. In a selection the row's own
      // actions step aside for the checkbox.
      actions: _selecting
          ? const []
          : [
              Button(
                  variant: ButtonVariant.plain,
                  size: WidgetSize.tiny,
                  onPressed: () => _toggleFavorite(entry),
                  child: Text(
                    entry.favorite ? strings.unfavorite : strings.favorite,
                  )),
              const SizedBox(width: 2),
              NativeMenu(
                align: NativeMenuAlign.end,
                items: [
                  NativeMenuItem(
                    label: strings.copy_translation,
                    onSelect: () => _copyTranslation(entry),
                  ),
                  if (kGlossaryFeatureEnabled)
                    NativeMenuItem(
                      label: strings.add_to_glossary,
                      onSelect: () => _addToGlossary([entry]),
                    ),
                  // The rule AppKit puts before a menu's destructive tail.
                  NativeMenuItem(
                    label: t.common.ui.button.delete,
                    separatorBefore: true,
                    onSelect: () => _deleteEntries([entry]),
                  ),
                ],
                trigger: (context, open, toggle) => IconButton(
                  semanticsLabel: strings.more_actions,
                  active: open,
                  // The 16-grid glyph at 16, as in the mini window's toolbar: a
                  // Fluent icon is drawn for one size, and the 20-grid one at
                  // 16 puts each of the three dots on a different subpixel
                  // phase — they come out visibly unequal.
                  icon: FluentIcons.more_horizontal_16_regular,
                  iconSize: 16,
                  onPressed: toggle,
                ),
              ),
            ],
    );
  }
}
