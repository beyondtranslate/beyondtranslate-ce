import 'dart:async';

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/foundation.dart';

import 'runtime.dart' as runtime_service;

abstract interface class HistoryGateway {
  Future<List<HistoryEntry>> listEntries(HistoryFilter filter, String? query);

  Future<HistoryCounts> counts();

  Future<HistoryEntry> upsert(HistoryEntryInput input);

  Future<HistoryEntry?> setFavorite(String entryId, bool favorite);

  Future<int> deleteEntries(List<String> entryIds);

  SettingsSubscription? subscribe();
}

class RuntimeHistoryGateway implements HistoryGateway {
  RuntimeHistory get _history => runtime_service.runtime.history();

  @override
  Future<HistoryCounts> counts() => _history.counts();

  @override
  Future<int> deleteEntries(List<String> entryIds) =>
      _history.deleteEntries(entryIds: entryIds);

  @override
  Future<List<HistoryEntry>> listEntries(
    HistoryFilter filter,
    String? query,
  ) =>
      _history.listEntries(filter: filter, query: query);

  @override
  Future<HistoryEntry?> setFavorite(String entryId, bool favorite) =>
      _history.setFavorite(entryId: entryId, favorite: favorite);

  @override
  SettingsSubscription subscribe() =>
      runtime_service.runtime.settings().subscribe();

  @override
  Future<HistoryEntry> upsert(HistoryEntryInput input) =>
      _history.upsertEntry(input: input);
}

/// Flutter-facing snapshot of the Rust history store.
class HistoryStore extends ChangeNotifier {
  HistoryStore({HistoryGateway? gateway})
      : _gateway = gateway ?? RuntimeHistoryGateway();

  static final HistoryStore instance = HistoryStore();

  final HistoryGateway _gateway;
  SettingsSubscription? _subscription;
  bool _disposed = false;
  int _reloadGeneration = 0;

  List<HistoryEntry> _entries = const [];
  HistoryCounts _counts = HistoryCounts(all: 0, favorites: 0, edited: 0);
  HistoryFilter _filter = HistoryFilter.all;
  String _query = '';
  bool _loading = false;
  String? _error;

  List<HistoryEntry> get entries => List.unmodifiable(_entries);
  HistoryCounts get counts => _counts;
  HistoryFilter get filter => _filter;
  String get query => _query;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> init() async {
    await reload();
    _startListening();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription = null;
    super.dispose();
  }

  Future<void> setFilter(HistoryFilter filter) async {
    if (_filter == filter) return;
    _filter = filter;
    await reload();
  }

  Future<void> setQuery(String query) async {
    if (_query == query) return;
    _query = query;
    await reload();
  }

  Future<void> reload() async {
    final generation = ++_reloadGeneration;
    _loading = true;
    _notify();
    try {
      final query = _query.trim();
      final results = await Future.wait<Object>([
        _gateway.listEntries(_filter, query.isEmpty ? null : query),
        _gateway.counts(),
      ]);
      if (_disposed || generation != _reloadGeneration) return;
      _entries = results[0] as List<HistoryEntry>;
      _counts = results[1] as HistoryCounts;
      _error = null;
    } catch (error, stackTrace) {
      if (_disposed || generation != _reloadGeneration) return;
      debugPrint('HistoryStore reload failed: $error\n$stackTrace');
      _error = '$error';
    } finally {
      if (!_disposed && generation == _reloadGeneration) {
        _loading = false;
        _notify();
      }
    }
  }

  Future<HistoryEntry?> save(HistoryEntryInput input) async {
    try {
      final entry = await _gateway.upsert(input);
      _error = null;
      await reload();
      return entry;
    } catch (error, stackTrace) {
      debugPrint('HistoryStore save failed: $error\n$stackTrace');
      _error = '$error';
      _notify();
      return null;
    }
  }

  Future<HistoryEntry?> favorite(String entryId, bool favorite) async {
    try {
      final entry = await _gateway.setFavorite(entryId, favorite);
      _error = null;
      await reload();
      return entry;
    } catch (error, stackTrace) {
      debugPrint('HistoryStore favorite failed: $error\n$stackTrace');
      _error = '$error';
      _notify();
      return null;
    }
  }

  Future<int> delete(List<String> entryIds) async {
    if (entryIds.isEmpty) return 0;
    try {
      final removed = await _gateway.deleteEntries(entryIds);
      _error = null;
      await reload();
      return removed;
    } catch (error, stackTrace) {
      debugPrint('HistoryStore delete failed: $error\n$stackTrace');
      _error = '$error';
      _notify();
      return 0;
    }
  }

  void _startListening() {
    if (_subscription != null) return;
    final subscription = _gateway.subscribe();
    if (subscription == null) return;
    _subscription = subscription;
    unawaited(_consume(subscription));
  }

  Future<void> _consume(SettingsSubscription subscription) async {
    while (!_disposed && identical(_subscription, subscription)) {
      try {
        final change = await subscription.next();
        if (change == null) break;
        if (change == SettingsChange.history) await reload();
      } catch (error, stackTrace) {
        debugPrint('HistoryStore subscription error: $error\n$stackTrace');
        break;
      }
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }
}

final historyStore = HistoryStore.instance;

/// Tracks one visible translation result across retries and service switches.
/// A changed source starts a new history entry; all other saves upsert the
/// current entry and preserve its favorite state.
class TranslationHistorySession {
  TranslationHistorySession({HistoryStore? store})
      : _store = store ?? historyStore;

  final HistoryStore _store;
  String? _source;

  String? entryId;
  bool favorite = false;

  bool beginSource(String source) {
    final changed = _source != null && _source != source;
    if (changed) {
      entryId = null;
      favorite = false;
    }
    _source = source;
    return changed;
  }

  void reset() {
    _source = null;
    entryId = null;
    favorite = false;
  }

  Future<HistoryEntry?> save(HistoryEntryInput input) async {
    final entry = await _store.save(
      HistoryEntryInput(
        id: entryId,
        source: input.source,
        translation: input.translation,
        sourceLanguage: input.sourceLanguage,
        targetLanguage: input.targetLanguage,
        serviceId: input.serviceId,
        serviceName: input.serviceName,
        edited: input.edited,
      ),
    );
    if (entry != null) {
      entryId = entry.id;
      favorite = entry.favorite;
      _source = entry.source;
    }
    return entry;
  }

  Future<HistoryEntry?> toggleFavorite() async {
    final id = entryId;
    if (id == null) return null;
    final entry = await _store.favorite(id, !favorite);
    if (entry != null) favorite = entry.favorite;
    return entry;
  }
}
