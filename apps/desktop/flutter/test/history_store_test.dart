import 'package:beyondtranslate_desktop/src/services/history_store.dart';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads, filters, updates favorites, and deletes history', () async {
    final gateway = _FakeHistoryGateway();
    final store = HistoryStore(gateway: gateway);
    addTearDown(store.dispose);

    await store.init();
    expect(store.entries, isEmpty);

    final created = await store.save(_input(source: 'hello'));
    expect(created, isNotNull);
    expect(store.counts.all, 1);

    final updated = await store.save(
      _input(id: created!.id, source: 'hello', translation: '您好'),
    );
    expect(updated!.id, created.id);
    expect(store.entries.single.translation, '您好');

    await store.favorite(created.id, true);
    expect(store.entries.single.favorite, isTrue);
    expect(store.counts.favorites, 1);

    await store.setFilter(HistoryFilter.edited);
    expect(store.entries, isEmpty);
    await store.setFilter(HistoryFilter.favorites);
    expect(store.entries.single.id, created.id);

    expect(await store.delete([created.id]), 1);
    expect(store.entries, isEmpty);
    expect(store.counts.all, 0);
  });

  test('search is delegated with the active filter', () async {
    final gateway = _FakeHistoryGateway();
    final store = HistoryStore(gateway: gateway);
    addTearDown(store.dispose);
    await store.init();
    await store.save(_input(source: 'self attention'));
    await store.save(_input(source: 'build failed', translation: '构建失败'));

    await store.setQuery('attention');
    expect(store.entries.single.source, 'self attention');
    await store.setQuery('构建');
    expect(store.entries.single.source, 'build failed');
  });

  test('translation session deduplicates retries and resets for new source',
      () async {
    final store = HistoryStore(gateway: _FakeHistoryGateway());
    final session = TranslationHistorySession(store: store);
    addTearDown(store.dispose);
    await store.init();

    expect(session.beginSource('hello'), isFalse);
    final first = (await session.save(_input(source: 'hello')))!;
    expect(store.counts.all, 1);

    expect(session.beginSource('hello'), isFalse);
    final retry = await session.save(
      _input(source: 'hello', translation: '您好'),
    );
    expect(retry!.id, first.id);
    expect(store.counts.all, 1);

    await session.toggleFavorite();
    expect(session.favorite, isTrue);
    expect(session.beginSource('different'), isTrue);
    expect(session.entryId, isNull);
    expect(session.favorite, isFalse);
    final next = await session.save(_input(source: 'different'));
    expect(next!.id, isNot(first.id));
    expect(store.counts.all, 2);
  });
}

HistoryEntryInput _input({
  String? id,
  required String source,
  String translation = '你好',
}) =>
    HistoryEntryInput(
      id: id,
      source: source,
      translation: translation,
      sourceLanguage: 'en',
      targetLanguage: 'zh-Hans',
      serviceId: 'system+translation',
      serviceName: 'System',
      edited: false,
    );

class _FakeHistoryGateway implements HistoryGateway {
  final List<HistoryEntry> _entries = [];
  int _sequence = 0;

  @override
  Future<HistoryCounts> counts() async => HistoryCounts(
        all: _entries.length,
        favorites: _entries.where((entry) => entry.favorite).length,
        edited: _entries.where((entry) => entry.edited).length,
      );

  @override
  Future<int> deleteEntries(List<String> entryIds) async {
    final before = _entries.length;
    _entries.removeWhere((entry) => entryIds.contains(entry.id));
    return before - _entries.length;
  }

  @override
  Future<List<HistoryEntry>> listEntries(
    HistoryFilter filter,
    String? query,
  ) async {
    final needle = query?.toLowerCase() ?? '';
    return [
      for (final entry in _entries)
        if (filter == HistoryFilter.all ||
            (filter == HistoryFilter.favorites && entry.favorite) ||
            (filter == HistoryFilter.edited && entry.edited))
          if (needle.isEmpty ||
              '${entry.source} ${entry.translation} ${entry.serviceName}'
                  .toLowerCase()
                  .contains(needle))
            entry,
    ];
  }

  @override
  Future<HistoryEntry?> setFavorite(String entryId, bool favorite) async {
    final index = _entries.indexWhere((entry) => entry.id == entryId);
    if (index < 0) return null;
    final entry = _copy(_entries[index], favorite: favorite);
    _entries[index] = entry;
    return entry;
  }

  @override
  SettingsSubscription? subscribe() => null;

  @override
  Future<HistoryEntry> upsert(HistoryEntryInput input) async {
    final index = input.id == null
        ? -1
        : _entries.indexWhere((entry) => entry.id == input.id);
    final previous = index < 0 ? null : _entries[index];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final entry = HistoryEntry(
      id: previous?.id ?? 'h${++_sequence}',
      source: input.source,
      translation: input.translation,
      sourceLanguage: input.sourceLanguage,
      targetLanguage: input.targetLanguage,
      serviceId: input.serviceId,
      serviceName: input.serviceName,
      favorite: previous?.favorite ?? false,
      edited: input.edited,
      createdAt: previous?.createdAt ?? now,
      updatedAt: now,
    );
    if (index < 0) {
      _entries.add(entry);
    } else {
      _entries[index] = entry;
    }
    return entry;
  }

  HistoryEntry _copy(HistoryEntry entry, {required bool favorite}) =>
      HistoryEntry(
        id: entry.id,
        source: entry.source,
        translation: entry.translation,
        sourceLanguage: entry.sourceLanguage,
        targetLanguage: entry.targetLanguage,
        serviceId: entry.serviceId,
        serviceName: entry.serviceName,
        favorite: favorite,
        edited: entry.edited,
        createdAt: entry.createdAt,
        updatedAt: entry.updatedAt,
      );
}
