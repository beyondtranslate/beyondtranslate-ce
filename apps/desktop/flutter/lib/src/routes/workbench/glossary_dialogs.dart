import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../utils/language_util.dart';
import '../../widgets/native_select.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        Checkbox,
        DesignThemeContext,
        DesignTypographyStyles,
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
        Field,
        FieldState,
        Input,
        Label,
        OptionCard;

/// Where a new book's first entries come from.
enum GlossarySeed { blank, csv, tbx }

/// What [NewGlossaryDialog] hands back.
class GlossaryBookDraft {
  const GlossaryBookDraft({
    required this.name,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.seed,
  });

  final String name;
  final String sourceLanguage;
  final String targetLanguage;
  final GlossarySeed seed;
}

/// 新建术语库 — opened from the rail's 新建术语库 and the 术语库 titlebar. A book
/// is a name plus a language direction; 初始内容 either leaves it empty or seeds
/// it from a CSV / TBX file.
///
/// Port of `apps/storybook/src/screens/new-glossary-dialog.tsx`.
class NewGlossaryDialog extends StatefulWidget {
  const NewGlossaryDialog({
    super.key,
    this.takenNames = const [],
    this.defaultSource = 'en',
    this.defaultTarget = 'zh-Hans',
    this.languages,
  });

  /// Names already taken — a collision blocks 创建.
  final List<String> takenNames;
  final String defaultSource;
  final String defaultTarget;

  /// The roster the two menus offer. Defaults to everything the runtime
  /// supports; injectable so the sheet can be laid out without one.
  final List<String>? languages;

  @override
  State<NewGlossaryDialog> createState() => _NewGlossaryDialogState();
}

class _NewGlossaryDialogState extends State<NewGlossaryDialog> {
  final TextEditingController _name = TextEditingController();
  late String _source = widget.defaultSource;
  late String _target = widget.defaultTarget;
  GlossarySeed _seed = GlossarySeed.blank;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String get _trimmed => _name.text.trim();
  bool get _taken =>
      _trimmed.isNotEmpty && widget.takenNames.contains(_trimmed);
  bool get _sameLanguage => _source == _target;
  bool get _valid => _trimmed.isNotEmpty && !_taken && !_sameLanguage;

  void _submit() {
    if (!_valid) return;
    Navigator.of(context).pop(
      GlossaryBookDraft(
        name: _trimmed,
        sourceLanguage: _source,
        targetLanguage: _target,
        seed: _seed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = t.workbench.glossary_page;
    final languages = [
      for (final code in widget.languages ?? supportedLanguages)
        NativeSelectItem(value: code, label: getLanguageName(code)),
    ];

    return Center(
      child: Dialog(
        children: [
          DialogHeader(
            title: Text(strings.new_book),
            subtitle: Text(strings.new_book_subtitle),
          ),
          DialogBody(
            children: [
              Field(
                label: Text(_taken ? strings.name_taken : strings.name),
                state: _taken ? FieldState.error : FieldState.standard,
                hint: _taken
                    ? Text(strings.name_taken_hint(name: _trimmed))
                    : null,
                child: Input(
                  controller: _name,
                  autofocus: true,
                  state: _taken ? FieldState.error : FieldState.standard,
                  placeholder: strings.name_placeholder,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              // The pair reads as one setting, so the arrow sits on the
              // controls' own line rather than between the two labels.
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Field(
                      label: Text(strings.source_language),
                      child: NativeSelect<String>(
                        value: _source,
                        items: languages,
                        semanticsLabel: strings.source_language,
                        onChanged: (v) => setState(() => _source = v),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                      '→',
                      style: context.tokens.typography.sansStyle(
                        fontSize: 12,
                        height: 1,
                        color: context.colors.fgFaint,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Field(
                      label: Text(strings.target_language),
                      child: NativeSelect<String>(
                        value: _target,
                        items: languages,
                        semanticsLabel: strings.target_language,
                        onChanged: (v) => setState(() => _target = v),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Label(child: Text(strings.seed)),
                  ),
                  const SizedBox(height: 8),
                  // The cards square up to the tallest of them, the way the
                  // deck's `flex` row does. `stretch` alone cannot say that
                  // here: the sheet's body scrolls, so the row is handed an
                  // unbounded height and a stretched child would be asked to
                  // be infinitely tall. [IntrinsicHeight] measures the tallest
                  // card first and hands that height down instead.
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final entry in const [
                          (GlossarySeed.blank, 0),
                          (GlossarySeed.csv, 1),
                          (GlossarySeed.tbx, 2),
                        ]) ...[
                          if (entry.$2 > 0) const SizedBox(width: 10),
                          Expanded(
                            child: OptionCard(
                              title: Text(_seedTitle(entry.$1)),
                              description: Text(_seedHint(entry.$1)),
                              selected: _seed == entry.$1,
                              onSelect: () => setState(() => _seed = entry.$1),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (_sameLanguage)
                Callout(
                  tone: CalloutTone.warn,
                  child: Text(strings.same_language),
                )
              else if (_seed == GlossarySeed.blank)
                Callout(child: Text(strings.seed_blank_note))
              else
                Callout(
                  tone: CalloutTone.accent,
                  action: Button(
                    variant: ButtonVariant.quiet,
                    onPressed: null,
                    child: Text(strings.choose_file),
                  ),
                  child: Text(
                    strings.seed_file_note(
                      format: _seedTitle(_seed).toUpperCase(),
                    ),
                  ),
                ),
            ],
          ),
          DialogFooter(
            children: [
              const Spacer(),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.md,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.common.ui.button.cancel),
              ),
              Button(
                variant: ButtonVariant.primary,
                size: ButtonSize.md,
                enabled: _valid,
                onPressed: _submit,
                shortcut: const Text('⏎'),
                child: Text(strings.create),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _seedTitle(GlossarySeed seed) => switch (seed) {
        GlossarySeed.blank => t.workbench.glossary_page.seed_blank,
        GlossarySeed.csv => 'CSV',
        GlossarySeed.tbx => 'TBX',
      };

  String _seedHint(GlossarySeed seed) => switch (seed) {
        GlossarySeed.blank => t.workbench.glossary_page.seed_blank_hint,
        GlossarySeed.csv => t.workbench.glossary_page.seed_csv_hint,
        GlossarySeed.tbx => t.workbench.glossary_page.seed_tbx_hint,
      };
}

/// What [AddTermDialog] hands back for one entry.
class GlossaryEntryDraft {
  const GlossaryEntryDraft({
    required this.bookId,
    required this.term,
    required this.translation,
    required this.forbidden,
  });

  final String bookId;
  final String term;
  final String translation;
  final List<String> forbidden;
}

/// 新增条目 — the sheet the 术语库 titlebar and empty state open.
///
/// 保存后继续添加 keeps it up and clears the fields, since terms are usually
/// entered in runs; a term already in the target book turns 保存 into 覆盖.
///
/// Port of `apps/storybook/src/screens/add-term-dialog.tsx`.
class AddTermDialog extends StatefulWidget {
  const AddTermDialog({
    super.key,
    required this.books,
    this.defaultBookId,
    this.existingTerms = const {},
    required this.onSubmit,
  });

  final List<GlossaryBook> books;
  final String? defaultBookId;

  /// Terms already in each book, keyed by book id — drives the 覆盖 warning.
  final Map<String, List<String>> existingTerms;

  /// Saves one entry. The sheet stays up when 保存后继续添加 is on, so it
  /// reports each entry as it is made rather than once at the end.
  final Future<void> Function(GlossaryEntryDraft draft) onSubmit;

  @override
  State<AddTermDialog> createState() => _AddTermDialogState();
}

class _AddTermDialogState extends State<AddTermDialog> {
  late String _bookId = widget.defaultBookId ??
      (widget.books.isEmpty ? '' : widget.books.first.id);
  final TextEditingController _term = TextEditingController();
  final TextEditingController _translation = TextEditingController();
  final TextEditingController _forbidden = TextEditingController();
  final FocusNode _termFocus = FocusNode();
  bool _continuous = false;

  /// Entries saved without closing, so the footer can count them.
  int _saved = 0;

  @override
  void dispose() {
    _term.dispose();
    _translation.dispose();
    _forbidden.dispose();
    _termFocus.dispose();
    super.dispose();
  }

  String get _trimmedTerm => _term.text.trim();
  bool get _valid =>
      _trimmedTerm.isNotEmpty && _translation.text.trim().isNotEmpty;

  String? get _bookLabel {
    for (final book in widget.books) {
      if (book.id == _bookId) return book.name;
    }
    return null;
  }

  bool get _duplicate {
    if (_trimmedTerm.isEmpty) return false;
    final terms = widget.existingTerms[_bookId] ?? const <String>[];
    final lower = _trimmedTerm.toLowerCase();
    return terms.any((entry) => entry.toLowerCase() == lower);
  }

  Future<void> _submit() async {
    if (!_valid) return;
    await widget.onSubmit(
      GlossaryEntryDraft(
        bookId: _bookId,
        term: _trimmedTerm,
        translation: _translation.text.trim(),
        forbidden: _forbidden.text
            .split('/')
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .toList(growable: false),
      ),
    );
    if (!mounted) return;
    if (!_continuous) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _saved += 1;
      _term.clear();
      _translation.clear();
      _forbidden.clear();
    });
    // Terms are entered in runs, so the caret goes back to 原文 rather than
    // leaving the sheet up with nothing focused.
    _termFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final strings = t.workbench.glossary_page;
    final tokens = context.tokens;

    return Center(
      child: Dialog(
        children: [
          DialogHeader(
            title: Text(strings.add_entry),
            subtitle: Text(strings.add_entry_subtitle),
          ),
          DialogBody(
            children: [
              // One book is not a choice; the sheet only asks when it is.
              if (widget.books.length > 1)
                Field(
                  label: Text(strings.book),
                  child: NativeSelect<String>(
                    value: _bookId,
                    semanticsLabel: strings.book,
                    items: [
                      for (final book in widget.books)
                        NativeSelectItem(value: book.id, label: book.name),
                    ],
                    onChanged: (v) => setState(() => _bookId = v),
                  ),
                ),
              Field(
                label: Text(strings.term),
                child: Input(
                  controller: _term,
                  focusNode: _termFocus,
                  autofocus: true,
                  placeholder: strings.term_placeholder,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              Field(
                label: Text(strings.translation),
                child: Input(
                  controller: _translation,
                  placeholder: strings.translation_placeholder,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              Field(
                label: Text(strings.forbidden_label),
                hint: Text(strings.forbidden_hint),
                child: Input(
                  controller: _forbidden,
                  placeholder: strings.forbidden_placeholder_full,
                  onSubmitted: (_) => _submit(),
                ),
              ),
              if (_duplicate)
                Callout(
                  tone: CalloutTone.warn,
                  child: Text(
                    strings.duplicate(
                      term: _trimmedTerm,
                      book: _bookLabel == null
                          ? strings.duplicate_book_fallback
                          : '「$_bookLabel」',
                    ),
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Checkbox(
                  checked: _continuous,
                  onChanged: (v) => setState(() => _continuous = v),
                  child: Text(strings.keep_adding),
                ),
              ),
            ],
          ),
          DialogFooter(
            children: [
              if (_saved > 0)
                Text(
                  strings.added_count(count: _saved),
                  style: tokens.typography.sansStyle(
                    fontSize: 12,
                    height: 1,
                    color: tokens.colors.fgSubtle,
                  ),
                ),
              const Spacer(),
              Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.md,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  _saved > 0 ? strings.done : t.common.ui.button.cancel,
                ),
              ),
              Button(
                variant: ButtonVariant.primary,
                size: ButtonSize.md,
                enabled: _valid,
                onPressed: _submit,
                shortcut: const Text('⏎'),
                child: Text(
                  _duplicate ? strings.overwrite : t.common.ui.button.save,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
