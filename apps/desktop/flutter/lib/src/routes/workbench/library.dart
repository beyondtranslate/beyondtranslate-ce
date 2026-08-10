import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
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

/// One saved translation — the deck's sample data, until the runtime keeps
/// real history.
class _HistoryEntry {
  const _HistoryEntry({
    required this.id,
    required this.service,
    required this.meta,
    required this.edited,
    required this.source,
    required this.translation,
  });

  final String id;
  final String service;
  final String meta;
  final bool edited;
  final String source;
  final String translation;
}

const _history = <_HistoryEntry>[
  _HistoryEntry(
    id: 'h1',
    service: '内置模型',
    meta: '今天 14:22 · arxiv.org',
    edited: true,
    source: 'Self-attention weighs every token against every other token.',
    translation: '自注意力会衡量每个词元与其他所有词元的关系。',
  ),
  _HistoryEntry(
    id: 'h2',
    service: 'Claude',
    meta: '今天 11:04 · Xcode',
    edited: false,
    source: 'The build phase failed because the signing certificate expired.',
    translation: '构建阶段失败，原因是签名证书已过期。',
  ),
  _HistoryEntry(
    id: 'h3',
    service: 'DeepL',
    meta: '昨天 20:47 · Mail',
    edited: false,
    source: 'Please find the revised contract attached for your review.',
    translation: '随附修订后的合同，请查阅。',
  ),
];

enum _Filter { all, favorites, edited }

/// 历史 — the deck's LibraryView: a rail of filters beside a feed of
/// [ListCard] rows, with a footer that flips into batch mode. UI only; the
/// rows are the deck's sample data and the actions are inert.
class WorkbenchLibraryPage extends StatefulWidget {
  const WorkbenchLibraryPage({super.key});

  @override
  State<WorkbenchLibraryPage> createState() => _WorkbenchLibraryPageState();
}

class _WorkbenchLibraryPageState extends State<WorkbenchLibraryPage> {
  _Filter _filter = _Filter.all;
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
              '${entry.source} ${entry.translation} ${entry.service}'
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
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The deck files 历史 by a rail, not by pills: the filter is a
              // place you are in, the same as a glossary book.
              Rail(
                children: [
                  for (final entry in const [
                    (_Filter.all, '全部'),
                    (_Filter.favorites, '收藏 64'),
                    (_Filter.edited, '我改过的 18'),
                  ])
                    RailItem(
                      active: entry.$1 == _filter,
                      onPressed: () => setState(() => _filter = entry.$1),
                      child: Text(entry.$2),
                    ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStrip(context, rows.length),
                    Expanded(child: _buildFeed(context, rows)),
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

  /// The strip over the feed: which filter you are in and how it is sorted —
  /// or the ⌘F search field, which takes the whole strip.
  Widget _buildStrip(BuildContext context, int count) {
    final colors = context.colors;
    final label = switch (_filter) {
      _Filter.all => '全部',
      _Filter.favorites => '收藏',
      _Filter.edited => '我改过的',
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
              value: _query,
              onChanged: (value) => setState(() => _query = value),
              placeholder: '搜索原文、译文或服务',
              onDismiss: () => setState(() {
                _searching = false;
                _query = '';
              }),
              semanticsLabel: '搜索历史',
            )
          : Row(
              children: [
                Label(child: Text('$label · $count 条')),
                const Spacer(),
                const Kbd('按时间'),
              ],
            ),
    );
  }

  Widget _buildFeed(BuildContext context, List<_HistoryEntry> rows) {
    final colors = context.colors;

    return rows.isEmpty
        ? EmptyState(
            label: Text(t.workbench.history),
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

  /// The batch bar. Every action is text-level, so multi-select mode keeps the
  /// normal mode's height.
  Widget _buildFooter(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return WindowFooter(
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
                variant: ButtonVariant.quiet,
                enabled: _selected.isNotEmpty,
                onPressed: () {},
                child: const Text('批量导出'),
              ),
              Button(
                variant: ButtonVariant.quiet,
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
    );
  }

  Widget _buildRow(_HistoryEntry entry) {
    final active =
        _selecting ? _selected.contains(entry.id) : entry.id == _active;
    return ListCard(
      eyebrow: Text(entry.service),
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
