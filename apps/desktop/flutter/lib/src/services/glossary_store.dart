import 'dart:async';

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/foundation.dart';

import 'runtime.dart' as runtime_service;

/// Glossary cache backed by the Rust runtime.
///
/// Mirrors [SettingsStore]: the runtime owns the data, this store keeps a
/// Flutter-friendly snapshot of the currently selected book so `build`
/// methods can read it synchronously, and reloads whenever the runtime
/// reports a change — including changes made from the native macOS UI.
///
/// Only the selected book's terms are held. Books are listed with their
/// counts only, so opening the page never pays for terms it will not show.
class GlossaryStore extends ChangeNotifier {
  GlossaryStore._();

  static final GlossaryStore instance = GlossaryStore._();

  SettingsSubscription? _subscription;
  bool _disposed = false;

  List<GlossaryBook> _books = const [];
  List<GlossaryEntry> _entries = const [];
  String? _selectedBookId;
  String _query = '';
  bool _loading = false;
  String? _error;

  List<GlossaryBook> get books => List.unmodifiable(_books);

  /// Terms of [selectedBook] matching [query], newest first.
  List<GlossaryEntry> get entries => List.unmodifiable(_entries);

  String get query => _query;
  bool get isLoading => _loading;

  /// Message from the last failed operation, cleared by the next success.
  String? get error => _error;

  GlossaryBook? get selectedBook {
    final id = _selectedBookId;
    if (id == null) return null;
    for (final book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }

  RuntimeGlossary get _glossary => runtime_service.runtime.glossary();

  Future<void> init() async {
    await reloadBooks();
    _startListeningForChanges();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription = null;
    super.dispose();
  }

  /// Subscribes to runtime change events. Idempotent.
  void _startListeningForChanges() {
    if (_subscription != null) return;
    final subscription = runtime_service.runtime.settings().subscribe();
    _subscription = subscription;
    unawaited(_consumeChanges(subscription));
  }

  Future<void> _consumeChanges(SettingsSubscription subscription) async {
    while (!_disposed && identical(_subscription, subscription)) {
      SettingsChange? change;
      try {
        change = await subscription.next();
      } catch (error, stackTrace) {
        debugPrint('GlossaryStore subscription error: $error\n$stackTrace');
        break;
      }
      if (change == null) break;
      if (change == SettingsChange.glossary) {
        await reloadBooks();
      }
    }
  }

  /// Reloads the book list and the selected book's terms. Keeps the current
  /// selection when it still exists, otherwise falls back to the first book.
  Future<void> reloadBooks() async {
    try {
      final books = await _glossary.listBooks();
      if (_disposed) return;
      _books = books;

      final stillExists = books.any((book) => book.id == _selectedBookId);
      if (!stillExists) {
        _selectedBookId = books.isEmpty ? null : books.first.id;
      }
      _error = null;
    } catch (error, stackTrace) {
      debugPrint('GlossaryStore failed to list books: $error\n$stackTrace');
      _error = '$error';
    }
    await _reloadEntries();
  }

  Future<void> _reloadEntries() async {
    final bookId = _selectedBookId;
    if (bookId == null) {
      _entries = const [];
      _loading = false;
      _safeNotify();
      return;
    }

    _loading = true;
    _safeNotify();
    try {
      final entries = await _glossary.listEntries(
        bookId: bookId,
        query: _query.trim().isEmpty ? null : _query.trim(),
        offset: 0,
        limit: 0,
      );
      if (_disposed) return;
      _entries = entries;
      _error = null;
    } catch (error, stackTrace) {
      debugPrint('GlossaryStore failed to list entries: $error\n$stackTrace');
      _entries = const [];
      _error = '$error';
    } finally {
      _loading = false;
      _safeNotify();
    }
  }

  Future<void> selectBook(String bookId) async {
    if (_selectedBookId == bookId) return;
    _selectedBookId = bookId;
    _query = '';
    await _reloadEntries();
  }

  Future<void> setQuery(String query) async {
    if (_query == query) return;
    _query = query;
    await _reloadEntries();
  }

  /// Creates a book and selects it.
  Future<GlossaryBook?> createBook(
    String name, {
    String? sourceLanguage,
    String? targetLanguage,
  }) async {
    return _run(() async {
      final book = await _glossary.upsertBook(
        input: GlossaryBookInput(
          name: name,
          enabled: true,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        ),
      );
      _selectedBookId = book.id;
      _query = '';
      return book;
    });
  }

  /// Replaces a book's metadata. Every field is authoritative, so callers
  /// pass the current value for anything they are not changing.
  Future<GlossaryBook?> updateBook(
    GlossaryBook book, {
    String? name,
    bool? enabled,
    String? sourceLanguage,
    String? targetLanguage,
    bool clearSourceLanguage = false,
    bool clearTargetLanguage = false,
  }) async {
    return _run(
      () => _glossary.upsertBook(
        input: GlossaryBookInput(
          id: book.id,
          name: name ?? book.name,
          enabled: enabled ?? book.enabled,
          sourceLanguage: clearSourceLanguage
              ? null
              : (sourceLanguage ?? book.sourceLanguage),
          targetLanguage: clearTargetLanguage
              ? null
              : (targetLanguage ?? book.targetLanguage),
        ),
      ),
    );
  }

  Future<bool> deleteBook(String bookId) async {
    final removed = await _run(() => _glossary.deleteBook(bookId: bookId));
    return removed ?? false;
  }

  /// Adds a term, or updates the existing one when [entry] is given.
  Future<GlossaryEntry?> saveEntry({
    required String term,
    required String translation,
    List<String> forbidden = const [],
    String? note,
    bool caseSensitive = false,
    bool wholeWord = true,
    GlossaryEntry? entry,
  }) async {
    final bookId = _selectedBookId;
    if (bookId == null) return null;
    return _run(
      () => _glossary.upsertEntry(
        bookId: bookId,
        input: GlossaryEntryInput(
          id: entry?.id,
          term: term,
          translation: translation,
          forbidden: forbidden,
          note: note,
          caseSensitive: caseSensitive,
          wholeWord: wholeWord,
        ),
      ),
    );
  }

  Future<bool> deleteEntry(String entryId) async {
    final bookId = _selectedBookId;
    if (bookId == null) return false;
    final removed = await _run(
      () => _glossary.deleteEntry(bookId: bookId, entryId: entryId),
    );
    return removed ?? false;
  }

  /// Which glossary rules a translation breaks, for flagging results the
  /// service produced without honouring the terms.
  Future<List<GlossaryComplianceIssue>> check({
    required String source,
    required String translated,
    String? sourceLanguage,
    String? targetLanguage,
  }) async {
    try {
      return await _glossary.check(
        source: source,
        translated: translated,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'GlossaryStore failed to check translation: '
        '$error\n$stackTrace',
      );
      return const [];
    }
  }

  /// Terms occurring in [text], for highlighting the source.
  Future<List<GlossaryMatch>> match(
    String text, {
    String? sourceLanguage,
    String? targetLanguage,
  }) async {
    try {
      return await _glossary.matchText(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } catch (error, stackTrace) {
      debugPrint('GlossaryStore failed to match text: $error\n$stackTrace');
      return const [];
    }
  }

  /// Runs a write and surfaces its failure through [error] instead of
  /// throwing into a button callback. The runtime broadcasts the change, so
  /// the resulting reload is what refreshes the UI.
  Future<T?> _run<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      _error = null;
      return result;
    } catch (error, stackTrace) {
      debugPrint('GlossaryStore write failed: $error\n$stackTrace');
      _error = '$error';
      _safeNotify();
      return null;
    }
  }

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }
}

/// App-wide glossary store.
final glossaryStore = GlossaryStore.instance;
