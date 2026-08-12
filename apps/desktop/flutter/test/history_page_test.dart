import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:beyondtranslate_desktop/src/routes/workbench/library.dart';
import 'package:beyondtranslate_desktop/src/services/history_store.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/material.dart' hide Checkbox;
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async => LocaleSettings.setLocale(AppLocale.zhHans));

  testWidgets('renders real entries and applies favorite filter', (
    tester,
  ) async {
    final gateway = _PageHistoryGateway([
      _entry('h1', 'Self attention', '自注意力', favorite: true),
      _entry('h2', 'Build failed', '构建失败', edited: true),
    ]);
    final store = HistoryStore(gateway: gateway);
    addTearDown(store.dispose);
    await store.init();

    await tester.pumpWidget(_specimen(WorkbenchLibraryPage(store: store)));
    await tester.pumpAndSettle();
    expect(find.text('Self attention'), findsOneWidget);
    expect(find.text('Build failed'), findsOneWidget);
    expect(find.text('收藏 1'), findsOneWidget);

    await tester.tap(find.text('收藏 1'));
    await tester.pumpAndSettle();
    expect(find.text('Self attention'), findsOneWidget);
    expect(find.text('Build failed'), findsNothing);
  });

  testWidgets('normal mode selects one row and multi-select counts checks', (
    tester,
  ) async {
    final store = HistoryStore(
      gateway: _PageHistoryGateway([
        _entry('h1', 'One', '一'),
        _entry('h2', 'Two', '二'),
      ]),
    );
    addTearDown(store.dispose);
    await store.init();
    await tester.pumpWidget(_specimen(WorkbenchLibraryPage(store: store)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Two'));
    await tester.tap(find.text('多选'));
    await tester.pump();
    await tester.tap(find.text('One'));
    await tester.pump();
    expect(find.text('已选 1 条'), findsOneWidget);
  });

  testWidgets('delete requires confirmation and removes the active row', (
    tester,
  ) async {
    final gateway = _PageHistoryGateway([_entry('h1', 'Disposable', '删除')]);
    final store = HistoryStore(gateway: gateway);
    addTearDown(store.dispose);
    await store.init();
    await tester.pumpWidget(_specimen(WorkbenchLibraryPage(store: store)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('删除').last);
    await tester.pump();
    expect(find.textContaining('无法撤销'), findsOneWidget);
    await tester.tap(find.text('删除').last);
    await tester.pumpAndSettle();
    expect(find.text('Disposable'), findsNothing);
  });
}

Widget _specimen(Widget child) => DesignThemeProvider(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 668, height: 560, child: child),
        ),
      ),
    );

HistoryEntry _entry(
  String id,
  String source,
  String translation, {
  bool favorite = false,
  bool edited = false,
}) =>
    HistoryEntry(
      id: id,
      source: source,
      translation: translation,
      sourceLanguage: 'en',
      targetLanguage: 'zh-Hans',
      serviceId: 'system+translation',
      serviceName: 'System',
      origin: HistoryOrigin.workbench,
      favorite: favorite,
      edited: edited,
      createdAt: 1700000000,
      updatedAt: 1700000000,
    );

class _PageHistoryGateway implements HistoryGateway {
  _PageHistoryGateway(this.entries);

  final List<HistoryEntry> entries;

  @override
  Future<HistoryCounts> counts() async => HistoryCounts(
        all: entries.length,
        favorites: entries.where((entry) => entry.favorite).length,
        edited: entries.where((entry) => entry.edited).length,
      );

  @override
  Future<int> deleteEntries(List<String> entryIds) async {
    final before = entries.length;
    entries.removeWhere((entry) => entryIds.contains(entry.id));
    return before - entries.length;
  }

  @override
  Future<List<HistoryEntry>> listEntries(
    HistoryFilter filter,
    String? query,
  ) async =>
      [
        for (final entry in entries)
          if (filter == HistoryFilter.all ||
              (filter == HistoryFilter.favorites && entry.favorite) ||
              (filter == HistoryFilter.edited && entry.edited))
            entry,
      ];

  @override
  Future<HistoryEntry?> setFavorite(String entryId, bool favorite) async =>
      entries.where((entry) => entry.id == entryId).firstOrNull;

  @override
  SettingsSubscription? subscribe() => null;

  @override
  Future<HistoryEntry> upsert(HistoryEntryInput input) =>
      throw UnimplementedError();
}
