import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Checkbox,
        DesignThemeContext,
        DesignTypographyStyles,
        EmptyState,
        Kbd,
        ListCard,
        SearchField,
        TabItem,
        Tabs,
        WindowFooter;
import '../../widgets/workbench.dart' show WorkbenchToolbar;

/// One saved translation — the deck's sample data, until the runtime keeps
/// real history.
class _HistoryEntry {
  const _HistoryEntry({
    required this.id,
    required this.engine,
    required this.meta,
    required this.edited,
    required this.source,
    required this.translation,
  });

  final String id;
  final String engine;
  final String meta;
  final bool edited;
  final String source;
  final String translation;
}

const _history = <_HistoryEntry>[
  _HistoryEntry(
    id: 'h1',
    engine: '内置模型',
    meta: '今天 14:22 · arxiv.org',
    edited: true,
    source: 'Self-attention weighs every token against every other token.',
    translation: '自注意力会衡量每个词元与其他所有词元的关系。',
  ),
  _HistoryEntry(
    id: 'h2',
    engine: 'Claude',
    meta: '今天 11:04 · Xcode',
    edited: false,
    source: 'The build phase failed because the signing certificate expired.',
    translation: '构建阶段失败，原因是签名证书已过期。',
  ),
  _HistoryEntry(
    id: 'h3',
    engine: 'DeepL',
    meta: '昨天 20:47 · Mail',
    edited: false,
    source: 'Please find the revised contract attached for your review.',
    translation: '随附修订后的合同，请查阅。',
  ),
];

enum _Filter { favorites, all, edited }

/// 收藏与历史 — the deck's LibraryView: filter pills over a feed of
/// [ListCard] rows, with a footer that flips into batch mode. UI only; the
/// rows are the deck's sample data and the actions are inert.
class WorkbenchLibraryPage extends StatefulWidget {
  const WorkbenchLibraryPage({super.key});

  @override
  State<WorkbenchLibraryPage> createState() => _WorkbenchLibraryPageState();
}

class _WorkbenchLibraryPageState extends State<WorkbenchLibraryPage> {
  _Filter _filter = _Filter.favorites;
  String _active = _history.first.id;
  bool _searching = false;
  String _query = '';
  bool _selecting = false;
  final Set<String> _selected = {};

  List<_HistoryEntry> get _rows {
    final needle = _query.trim().toLowerCase();
    return [
      for (final entry in _history)
        if (_filter != _Filter.edited || entry.edited)
          if (needle.isEmpty ||
              '${entry.source} ${entry.translation} ${entry.engine}'
                  .toLowerCase()
                  .contains(needle))
            entry,
    ];
  }

  void _toggle(String id) {
    setState(() {
      _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final rows = _rows;

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
              child: const Text('搜索'),
            ),
          ],
        ),
        // 筛选带 — pills on the left, the sort note pinned right.
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colors.border,
                width: context.hairlineWidth,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Tabs<_Filter>(
                    value: _filter,
                    onChanged: (value) => setState(() => _filter = value),
                    semanticsLabel: '历史筛选',
                    items: const [
                      TabItem(
                        value: _Filter.favorites,
                        label: Text('收藏'),
                        count: 64,
                      ),
                      TabItem(value: _Filter.all, label: Text('全部历史')),
                      TabItem(
                        value: _Filter.edited,
                        label: Text('我改过的'),
                        count: 18,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Kbd('按时间'),
                ],
              ),
              if (_searching) ...[
                const SizedBox(height: 10),
                SearchField(
                  autofocus: true,
                  value: _query,
                  onChanged: (value) => setState(() => _query = value),
                  placeholder: '搜索原文、译文或引擎',
                  onDismiss: () => setState(() {
                    _searching = false;
                    _query = '';
                  }),
                  semanticsLabel: '搜索收藏与历史',
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: rows.isEmpty
              ? EmptyState(
                  label: const Text('收藏与历史'),
                  title: Text(
                    _query.trim().isNotEmpty
                        ? '没有匹配「${_query.trim()}」的记录'
                        : '这个筛选下还没有记录',
                  ),
                  description: const Text('换个筛选或关键词试试。'),
                  action: _query.trim().isEmpty
                      ? null
                      : Button(
                          onPressed: () => setState(() => _query = ''),
                          child: const Text('清除搜索'),
                        ),
                )
              : ListView(
                  children: [
                    for (final entry in rows)
                      _selecting
                          ? IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 18),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: colors.borderHairline,
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
                ),
        ),
        WindowFooter(
          children: _selecting
              ? [
                  Text(
                    '已选 ${_selected.length} 条',
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: colors.fg,
                    ),
                  ),
                  Button(
                    variant: ButtonVariant.primary,
                    size: ButtonSize.xs,
                    enabled: _selected.isNotEmpty,
                    onPressed: () {},
                    child: const Text('批量导出'),
                  ),
                  Button(
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.xs,
                    enabled: _selected.isNotEmpty,
                    onPressed: () {},
                    child: const Text('加入术语库'),
                  ),
                  const Spacer(),
                  Button(
                    variant: ButtonVariant.plain,
                    onPressed: () => setState(() {
                      _selecting = false;
                      _selected.clear();
                    }),
                    child: const Text('退出多选'),
                  ),
                ]
              : [
                  Button(
                    variant: ButtonVariant.plain,
                    onPressed: () => setState(() => _selecting = true),
                    child: const Text('多选'),
                  ),
                  Button(
                    variant: ButtonVariant.plain,
                    onPressed: () {},
                    child: const Text('批量导出'),
                  ),
                  Button(
                    variant: ButtonVariant.plain,
                    onPressed: () {},
                    child: const Text('加入术语库'),
                  ),
                  const Spacer(),
                  Text(
                    '历史保留 90 天',
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      height: 1,
                      color: colors.fgFaint,
                    ),
                  ),
                ],
        ),
      ],
    );
  }

  Widget _buildRow(_HistoryEntry entry) {
    final active =
        _selecting ? _selected.contains(entry.id) : entry.id == _active;
    return ListCard(
      eyebrow: Text(entry.engine),
      meta: Text(entry.meta),
      flag: entry.edited ? const Text('我改过') : null,
      primary: Text(entry.source),
      secondary: Text(entry.translation),
      active: active,
      onPressed: () =>
          _selecting ? _toggle(entry.id) : setState(() => _active = entry.id),
    );
  }
}
