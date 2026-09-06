import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart' hide Table, TableCell, TableRow;

import '../../i18n/i18n.dart';
import '../../services/glossary_store.dart';
import '../../services/runtime.dart' show GlossaryBook, GlossaryEntry;
import '../../theme/product_tokens.dart' show ProductPalette, ProductTypography;
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/nav_columns.dart' show Rail, RailAction, RailItem;
import '../../widgets/ui.dart'
    show
        Button,
        ButtonTint,
        ButtonVariant,
        EmptyState,
        SearchField,
        SectionLabel,
        SectionLabelTint,
        Table,
        TableCell,
        TableCellAlign,
        TableHead,
        TableRow,
        TextField,
        ThemeDataBuildContextProps,
        WidgetSize;
import '../../widgets/window_chrome.dart' show WindowFooter;
import '../../widgets/workbench.dart' show WorkbenchToolbar;
import 'glossary_dialogs.dart';

/// Separator between several forbidden translations, in both the input and
/// the table cell.
const _forbiddenSeparator = ' / ';

/// What the book header is currently showing. Only one at a time: the header
/// is a single strip and each mode owns it until dismissed.
enum _HeaderMode { idle, searching, renaming, creating, confirmingDelete }

/// 术语库 — a book rail beside the term table, with an inline editor row on
/// the accent surface for adding and editing terms. Data comes from
/// [glossaryStore], which is backed by the Rust runtime.
class WorkbenchGlossaryPage extends StatefulWidget {
  const WorkbenchGlossaryPage({super.key});

  @override
  State<WorkbenchGlossaryPage> createState() => _WorkbenchGlossaryPageState();
}

class _WorkbenchGlossaryPageState extends State<WorkbenchGlossaryPage> {
  _HeaderMode _header = _HeaderMode.idle;

  /// Whether the inline editor row is open, and which term it is editing.
  /// A null [_editing] while drafting means a new term.
  bool _drafting = false;
  GlossaryEntry? _editing;

  final TextEditingController _termController = TextEditingController();
  final TextEditingController _translationController = TextEditingController();
  final TextEditingController _forbiddenController = TextEditingController();
  final TextEditingController _bookNameController = TextEditingController();

  /// The kit's search field is controller-driven, so the query lives here and
  /// the store is told about it on change.
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    glossaryStore.addListener(_handleStoreChanged);
  }

  @override
  void dispose() {
    glossaryStore.removeListener(_handleStoreChanged);
    _termController.dispose();
    _translationController.dispose();
    _forbiddenController.dispose();
    _bookNameController.dispose();
    super.dispose();
  }

  void _handleStoreChanged() {
    if (!mounted) return;
    // A term being edited can disappear when the change came from elsewhere
    // (the native settings UI, or another window). Close the editor rather
    // than saving into a term that no longer exists.
    if (_editing != null &&
        !glossaryStore.entries.any((entry) => entry.id == _editing!.id)) {
      _closeDraft();
    }
    setState(() {});
  }

  // ── Term editing ───────────────────────────────────────────────────────

  bool get _draftValid =>
      _termController.text.trim().isNotEmpty &&
      _translationController.text.trim().isNotEmpty;

  void _openDraft([GlossaryEntry? entry]) {
    _termController.text = entry?.term ?? '';
    _translationController.text = entry?.translation ?? '';
    _forbiddenController.text =
        entry?.forbidden.join(_forbiddenSeparator) ?? '';
    setState(() {
      _drafting = true;
      _editing = entry;
    });
  }

  void _closeDraft() {
    _termController.clear();
    _translationController.clear();
    _forbiddenController.clear();
    if (!mounted) return;
    setState(() {
      _drafting = false;
      _editing = null;
    });
  }

  Future<void> _submitDraft() async {
    if (!_draftValid) return;
    final entry = _editing;
    await glossaryStore.saveEntry(
      term: _termController.text.trim(),
      translation: _translationController.text.trim(),
      forbidden: _parseForbidden(_forbiddenController.text),
      caseSensitive: entry?.caseSensitive ?? false,
      wholeWord: entry?.wholeWord ?? true,
      entry: entry,
    );
    _closeDraft();
  }

  Future<void> _deleteEditingEntry() async {
    final entry = _editing;
    if (entry == null) return;
    await glossaryStore.deleteEntry(entry.id);
    _closeDraft();
  }

  static List<String> _parseForbidden(String value) => [
        for (final part in value.split('/'))
          if (part.trim().isNotEmpty) part.trim(),
      ];

  // ── Book editing ───────────────────────────────────────────────────────

  void _openHeader(_HeaderMode mode, {String bookName = ''}) {
    _bookNameController.text = bookName;
    setState(() => _header = mode);
  }

  void _closeHeader() {
    _bookNameController.clear();
    if (!mounted) return;
    setState(() => _header = _HeaderMode.idle);
  }

  /// 新建术语库 — the sheet the deck draws, replacing the inline name strip.
  /// A book is a name plus a direction, and neither fits in a header row.
  Future<void> _openNewBookDialog() async {
    final draft = await showDialogInCurrentWindow<GlossaryBookDraft>(
      context: context,
      builder: (_) => NewGlossaryDialog(
        takenNames: [for (final book in glossaryStore.books) book.name],
      ),
    );
    if (draft == null) return;
    _closeDraft();
    await glossaryStore.createBook(
      draft.name,
      sourceLanguage: draft.sourceLanguage,
      targetLanguage: draft.targetLanguage,
    );
  }

  /// 新增条目 — the sheet stays up while 保存后继续添加 is on, so it saves each
  /// entry as it is made rather than handing one back on close.
  Future<void> _openAddTermDialog() async {
    final book = glossaryStore.selectedBook;
    if (book == null) return;
    await showDialogInCurrentWindow<void>(
      context: context,
      builder: (_) => AddTermDialog(
        books: glossaryStore.books,
        defaultBookId: book.id,
        existingTerms: {
          book.id: [for (final entry in glossaryStore.entries) entry.term],
        },
        onSubmit: (draft) async {
          if (draft.bookId != glossaryStore.selectedBook?.id) {
            await glossaryStore.selectBook(draft.bookId);
          }
          await glossaryStore.saveEntry(
            term: draft.term,
            translation: draft.translation,
            forbidden: draft.forbidden,
            caseSensitive: false,
            wholeWord: true,
          );
        },
      ),
    );
  }

  Future<void> _submitBookName() async {
    final name = _bookNameController.text.trim();
    if (name.isEmpty) return;
    if (_header == _HeaderMode.creating) {
      _closeDraft();
      await glossaryStore.createBook(name);
    } else {
      final book = glossaryStore.selectedBook;
      if (book == null) return;
      await glossaryStore.updateBook(book, name: name);
    }
    _closeHeader();
  }

  Future<void> _deleteSelectedBook() async {
    final book = glossaryStore.selectedBook;
    if (book == null) return;
    _closeDraft();
    await glossaryStore.deleteBook(book.id);
    _closeHeader();
  }

  Future<void> _toggleSelectedBook() async {
    final book = glossaryStore.selectedBook;
    if (book == null) return;
    await glossaryStore.updateBook(book, enabled: !book.enabled);
  }

  Future<void> _selectBook(GlossaryBook book) async {
    _closeDraft();
    _closeHeader();
    await glossaryStore.selectBook(book.id);
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final books = glossaryStore.books;
    final book = glossaryStore.selectedBook;
    final entries = glossaryStore.entries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkbenchToolbar(
          title: t.workbench.glossary,
          children: [
            const Spacer(),
            // Both ways into a new book, as the deck draws them: the quiet one
            // here beside 新增条目, and the accent one at the rail's foot.
            Button(
                onPressed: _openNewBookDialog,
                child: Text(t.workbench.glossary_page.new_book)),
            const SizedBox(width: 14),
            Button(
                variant: ButtonVariant.filled,
                onPressed: book != null ? _openAddTermDialog : null,
                child: Text(t.workbench.glossary_page.add_entry)),
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Rail(
                resizable: true,
                children: [
                  for (final entry in books)
                    RailItem(
                      active: entry.id == book?.id,
                      onPressed: () => _selectBook(entry),
                      child: Text(
                        entry.enabled
                            ? '${entry.name} ${entry.entryCount}'
                            : '${entry.name} · '
                                '${t.workbench.glossary_page.disabled}',
                      ),
                    ),
                  RailAction(
                    onPressed: _openNewBookDialog,
                    child: Text('＋ ${t.workbench.glossary_page.new_book}'),
                  ),
                ],
              ),
              Expanded(
                child: book == null && _header != _HeaderMode.creating
                    ? _NoBooks(
                        onCreate: _openNewBookDialog,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(context, book, entries.length),
                          if (_drafting) _buildDraft(context),
                          Expanded(child: _buildBody(context, entries)),
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

  /// 书眉 — the book's name and count, or whichever editing mode has taken
  /// the strip over.
  Widget _buildHeader(BuildContext context, GlossaryBook? book, int count) {
    final vars = context.vars;
    final strings = t.workbench.glossary_page;

    Widget content;
    switch (_header) {
      case _HeaderMode.searching:
        content = Semantics(
          label: strings.search_label,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.escape): () {
                _searchController.clear();
                glossaryStore.setQuery('');
                _closeHeader();
              },
            },
            child: SearchField(
              controller: _searchController,
              onChanged: glossaryStore.setQuery,
              placeholder: strings.search_placeholder,
            ),
          ),
        );
      case _HeaderMode.renaming:
      case _HeaderMode.creating:
        content = Row(
          children: [
            Expanded(
              child: TextField(
                  controller: _bookNameController,
                  placeholder: strings.new_book_placeholder,
                  onSubmitted: (_) => _submitBookName()),
            ),
            const SizedBox(width: 10),
            Button(
                variant: ButtonVariant.filled,
                onPressed: _submitBookName,
                child: Text(t.common.ui.button.save)),
            const SizedBox(width: 10),
            Button(
                onPressed: _closeHeader,
                child: Text(t.common.ui.button.cancel)),
          ],
        );
      case _HeaderMode.confirmingDelete:
        content = Row(
          children: [
            Expanded(
              child: Text(
                strings.delete_book_confirm(
                  name: book?.name ?? '',
                  count: book?.entryCount ?? 0,
                ),
                style: context.vars.sansStyle(
                  fontSize: 12,
                  height: 1.3,
                  color: vars.colorContent,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Button(
                variant: ButtonVariant.tinted,
                tint: ButtonTint.warning,
                onPressed: _deleteSelectedBook,
                child: Text(t.common.ui.button.delete)),
            const SizedBox(width: 10),
            Button(
                onPressed: _closeHeader,
                child: Text(t.common.ui.button.cancel)),
          ],
        );
      case _HeaderMode.idle:
        content = Row(
          children: [
            SectionLabel(
                strings.entry_count(name: book?.name ?? '', count: count)),
            const Spacer(),
            Button(
                variant: ButtonVariant.plain,
                onPressed: _toggleSelectedBook,
                child: Text(
                  (book?.enabled ?? true) ? strings.disable : strings.enable,
                )),
            const SizedBox(width: 12),
            Button(
                variant: ButtonVariant.plain,
                onPressed: () => _openHeader(_HeaderMode.renaming,
                    bookName: book?.name ?? ''),
                child: Text(strings.rename_book)),
            const SizedBox(width: 12),
            Button(
                variant: ButtonVariant.plain,
                onPressed: () => _openHeader(_HeaderMode.confirmingDelete),
                child: Text(t.common.ui.button.delete)),
            const SizedBox(width: 12),
            Button(
                variant: ButtonVariant.plain,
                shortcut: const Text('⌘F'),
                onPressed: () => _openHeader(_HeaderMode.searching),
                child: Text(strings.search)),
          ],
        );
    }

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
      child: content,
    );
  }

  /// The inline add/edit row on the accent surface.
  Widget _buildDraft(BuildContext context) {
    final vars = context.vars;
    final strings = t.workbench.glossary_page;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: vars.accentSurface,
        border: Border(
          bottom: BorderSide(
            color: vars.accentHairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _DraftField(
              label: strings.term,
              placeholder: strings.term_placeholder,
              controller: _termController,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submitDraft(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DraftField(
              label: strings.translation,
              placeholder: strings.translation_placeholder,
              controller: _translationController,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submitDraft(),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 140,
            child: _DraftField(
              label: strings.forbidden,
              placeholder: strings.forbidden_placeholder,
              controller: _forbiddenController,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submitDraft(),
            ),
          ),
          const SizedBox(width: 10),
          Button(
              variant: ButtonVariant.filled,
              onPressed: _draftValid ? _submitDraft : null,
              child: Text(t.common.ui.button.save)),
          if (_editing != null) ...[
            const SizedBox(width: 10),
            Button(
                variant: ButtonVariant.tinted,
                tint: ButtonTint.warning,
                onPressed: _deleteEditingEntry,
                child: Text(t.common.ui.button.delete)),
          ],
          const SizedBox(width: 10),
          Button(
              onPressed: _closeDraft, child: Text(t.common.ui.button.cancel)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<GlossaryEntry> entries) {
    final strings = t.workbench.glossary_page;
    final query = glossaryStore.query.trim();
    final styles = _TableStyles.of(context);

    if (entries.isEmpty) {
      if (glossaryStore.isLoading) {
        return _CenteredNote(text: strings.loading);
      }
      return EmptyState(
          // The titlebar already carries the filled 新增条目; one accent action
          // per view, so this one is the quieter twin.
          actions: [
            Button(
                variant: ButtonVariant.normal,
                size: WidgetSize.medium,
                onPressed: _openAddTermDialog,
                child: Text(strings.add_entry))
          ],
          title: query.isNotEmpty
              ? strings.no_results_title(query: query)
              : strings.empty_title);
    }

    return ListView(
      children: [
        Table(
          children: [
            TableHead(
              children: [
                TableCell(head: true, child: Text(strings.term)),
                TableCell(head: true, child: Text(strings.translation)),
                TableCell(
                  head: true,
                  width: 96,
                  child: Text(strings.forbidden),
                ),
                TableCell(
                  head: true,
                  width: 56,
                  align: TableCellAlign.end,
                  child: Text(strings.hits),
                ),
              ],
            ),
            for (final entry in entries)
              TableRow(
                active: entry.id == _editing?.id,
                onPressed: () => _openDraft(entry),
                children: [
                  TableCell(child: Text(entry.term, style: styles.term)),
                  TableCell(
                    child: Text(entry.translation, style: styles.translation),
                  ),
                  TableCell(
                    width: 96,
                    child: Text(
                      entry.forbidden.isEmpty
                          ? '—'
                          : entry.forbidden.join(_forbiddenSeparator),
                      style: styles.forbidden,
                    ),
                  ),
                  TableCell(
                    width: 56,
                    align: TableCellAlign.end,
                    child: Text(
                      '${entry.hits}',
                      style: entry.id == _editing?.id
                          ? styles.hitsActive
                          : styles.hits,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final vars = context.vars;
    final error = glossaryStore.error;

    return WindowFooter(
      children: [
        Expanded(
          child: Text(
            error ?? t.workbench.glossary_page.priority_note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: vars.sansStyle(
              fontSize: 11,
              height: 1,
              color: error == null ? vars.colorContentSubtle : vars.danger,
            ),
          ),
        ),
      ],
    );
  }
}

/// The four columns of the term table, each with its own face in the deck:
/// the source term in the display face, the mandated translation a step larger
/// in CJK, the forbidden wording receded, and the hit count as a numeral that
/// turns accent on the selected row.
class _TableStyles {
  const _TableStyles({
    required this.term,
    required this.translation,
    required this.forbidden,
    required this.hits,
    required this.hitsActive,
  });

  factory _TableStyles.of(BuildContext context) {
    final vars = context.vars;

    return _TableStyles(
      term: vars.displayStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: vars.colorContent,
      ),
      translation: vars.cjkStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: vars.colorContent,
      ),
      forbidden: vars.cjkStyle(
        fontSize: 12,
        height: 1.4,
        color: vars.colorContentSubtle,
      ),
      hits: vars.displayStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1,
        color: vars.colorContentMuted,
      ),
      hitsActive: vars.displayStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1,
        color: vars.accentText,
      ),
    );
  }

  final TextStyle term;
  final TextStyle translation;
  final TextStyle forbidden;
  final TextStyle hits;
  final TextStyle hitsActive;
}

/// One column of the inline editor row: an accent micro-label over its input.
class _DraftField extends StatelessWidget {
  const _DraftField({
    required this.label,
    required this.placeholder,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final String placeholder;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionLabel(label, tint: SectionLabelTint.primary),
        const SizedBox(height: 6),
        TextField(
            controller: controller,
            placeholder: placeholder,
            onChanged: onChanged,
            onSubmitted: onSubmitted),
      ],
    );
  }
}

/// Shown before the first book exists, when there is nothing to put a term in.
class _NoBooks extends StatelessWidget {
  const _NoBooks({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final strings = t.workbench.glossary_page;
    return EmptyState(title: strings.no_books_title, actions: [
      Button(
          variant: ButtonVariant.normal,
          onPressed: onCreate,
          child: Text(strings.new_book))
    ]);
  }
}

class _CenteredNote extends StatelessWidget {
  const _CenteredNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final vars = context.vars;
    return Center(
      child: Text(
        text,
        style: vars.sansStyle(
          fontSize: 12,
          height: 1,
          color: vars.colorContentSubtle,
        ),
      ),
    );
  }
}
