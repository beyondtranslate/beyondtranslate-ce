//! Glossary storage and term matching.
//!
//! Terms live in `<data_dir>/glossary/<book_id>.json`, one file per book, so
//! deleting a book is deleting a file and a large book never slows down
//! reading settings. The whole set is held in memory; writes go through
//! [`GlossaryStore`], which rewrites only the affected book.
//!
//! Matching compiles the enabled books into an Aho-Corasick automaton cached
//! per language pair. The cache is keyed on a generation counter that every
//! mutation bumps, so callers never have to invalidate it by hand.

use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant, SystemTime, UNIX_EPOCH};

use aho_corasick::{AhoCorasick, MatchKind};
use serde::{Deserialize, Serialize};

/// Directory under `data_dir` holding one JSON file per book.
const GLOSSARY_DIR: &str = "glossary";

/// Hit counters are a soft statistic, so they accumulate in memory and are
/// written at most this often rather than on every translation. Counts
/// recorded since the last write are lost if the process exits, which is an
/// acceptable trade for not rewriting a book file on every keystroke-driven
/// translation.
const HIT_FLUSH_INTERVAL: Duration = Duration::from_secs(5);

// ── Public types ─────────────────────────────────────────────────────────────

/// A term book as presented to the UI. `entry_count` is derived, so the book
/// list can be rendered without carrying every term across the FFI boundary.
#[derive(Clone, Debug, PartialEq, uniffi::Record)]
pub struct GlossaryBook {
    pub id: String,
    pub name: String,
    pub enabled: bool,
    pub source_language: Option<String>,
    pub target_language: Option<String>,
    pub entry_count: u32,
    pub created_at: u64,
    pub updated_at: u64,
}

/// Book metadata as supplied by a caller. Every field is authoritative: read
/// the book, change what you need, send the whole thing back.
#[derive(Clone, Debug, uniffi::Record)]
pub struct GlossaryBookInput {
    /// `None` creates a new book; `Some(id)` updates an existing one.
    pub id: Option<String>,
    pub name: String,
    pub enabled: bool,
    /// `None` means the book applies to any source language.
    pub source_language: Option<String>,
    /// `None` means the book applies to any target language.
    pub target_language: Option<String>,
}

/// One term and the translation it must receive.
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize, uniffi::Record)]
pub struct GlossaryEntry {
    pub id: String,
    pub term: String,
    pub translation: String,
    /// Translations that must never appear for this term.
    #[serde(default)]
    pub forbidden: Vec<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub note: Option<String>,
    #[serde(default, rename = "caseSensitive")]
    pub case_sensitive: bool,
    /// Requires the match to sit on word boundaries. Only meaningful for
    /// terms that start or end with an ASCII alphanumeric; CJK terms have no
    /// word boundaries to check.
    #[serde(default = "default_true", rename = "wholeWord")]
    pub whole_word: bool,
    #[serde(default)]
    pub hits: u64,
    #[serde(default, rename = "createdAt")]
    pub created_at: u64,
    #[serde(default, rename = "updatedAt")]
    pub updated_at: u64,
}

/// Entry fields as supplied by a caller, with the same full-replace semantics
/// as [`GlossaryBookInput`].
#[derive(Clone, Debug, uniffi::Record)]
pub struct GlossaryEntryInput {
    /// `None` creates a new entry; `Some(id)` updates an existing one.
    pub id: Option<String>,
    pub term: String,
    pub translation: String,
    pub forbidden: Vec<String>,
    pub note: Option<String>,
    pub case_sensitive: bool,
    pub whole_word: bool,
}

/// A term found in a source text.
#[derive(Clone, Debug, PartialEq, uniffi::Record)]
pub struct GlossaryMatch {
    pub book_id: String,
    pub entry_id: String,
    pub term: String,
    /// The substring that actually matched, which differs from `term` when
    /// the entry is case-insensitive.
    pub matched_text: String,
    pub translation: String,
    pub forbidden: Vec<String>,
    /// UTF-8 byte offsets into the text that was searched.
    pub start: u32,
    pub end: u32,
}

/// Why a translation failed its glossary check.
#[derive(Clone, Copy, Debug, PartialEq, Eq, uniffi::Enum)]
pub enum GlossaryIssueKind {
    /// The term appeared in the source but its required translation is
    /// missing from the output.
    MissingTranslation,
    /// The output uses a translation the entry forbids.
    ForbiddenUsed,
}

/// One glossary rule the output violated.
#[derive(Clone, Debug, PartialEq, uniffi::Record)]
pub struct GlossaryComplianceIssue {
    pub book_id: String,
    pub entry_id: String,
    pub kind: GlossaryIssueKind,
    pub term: String,
    /// The translation the entry requires.
    pub expected: String,
    /// The forbidden text that was found, for [`GlossaryIssueKind::ForbiddenUsed`].
    pub found: Option<String>,
}

// ── On-disk shape ────────────────────────────────────────────────────────────

#[derive(Clone, Debug, Serialize, Deserialize)]
struct BookFile {
    id: String,
    name: String,
    #[serde(default = "default_true")]
    enabled: bool,
    #[serde(
        default,
        rename = "sourceLanguage",
        skip_serializing_if = "Option::is_none"
    )]
    source_language: Option<String>,
    #[serde(
        default,
        rename = "targetLanguage",
        skip_serializing_if = "Option::is_none"
    )]
    target_language: Option<String>,
    #[serde(default, rename = "createdAt")]
    created_at: u64,
    #[serde(default, rename = "updatedAt")]
    updated_at: u64,
    #[serde(default)]
    entries: Vec<GlossaryEntry>,
}

impl BookFile {
    fn to_book(&self) -> GlossaryBook {
        GlossaryBook {
            id: self.id.clone(),
            name: self.name.clone(),
            enabled: self.enabled,
            source_language: self.source_language.clone(),
            target_language: self.target_language.clone(),
            entry_count: self.entries.len() as u32,
            created_at: self.created_at,
            updated_at: self.updated_at,
        }
    }
}

fn default_true() -> bool {
    true
}

// ── Store ────────────────────────────────────────────────────────────────────

/// In-memory glossary backed by one JSON file per book.
pub struct GlossaryStore {
    dir: PathBuf,
    books: BTreeMap<String, BookFile>,
    /// Bumped by every mutation that can change matching, so compiled
    /// automatons can be invalidated without diffing the term set.
    generation: u64,
    /// Books whose hit counts have changed but not yet been written.
    pending_hits: BTreeSet<String>,
    last_hit_flush: Instant,
    matchers: Mutex<MatcherCache>,
    id_seq: u64,
}

impl GlossaryStore {
    /// Loads every book under `<data_dir>/glossary`. A missing directory is
    /// an empty glossary, not an error; it is created on first write.
    pub fn load(data_dir: impl AsRef<Path>) -> Result<Self, String> {
        let dir = data_dir.as_ref().join(GLOSSARY_DIR);
        let mut books = BTreeMap::new();

        if dir.is_dir() {
            let listing = fs::read_dir(&dir).map_err(|error| {
                format!("failed to read glossary directory `{}`: {error}", dir.display())
            })?;
            for entry in listing {
                let entry = entry.map_err(|error| {
                    format!("failed to read glossary directory `{}`: {error}", dir.display())
                })?;
                let path = entry.path();
                if path.extension().and_then(|ext| ext.to_str()) != Some("json") {
                    continue;
                }
                match load_book_file(&path) {
                    Ok(book) => {
                        books.insert(book.id.clone(), book);
                    }
                    // One corrupt book must not take the whole glossary — and
                    // with it the app's translation path — down with it.
                    Err(error) => eprintln!("[glossary] skipping `{}`: {error}", path.display()),
                }
            }
        }

        Ok(Self {
            dir,
            books,
            generation: 0,
            pending_hits: BTreeSet::new(),
            last_hit_flush: Instant::now(),
            matchers: Mutex::new(MatcherCache::default()),
            id_seq: 0,
        })
    }

    // ── Books ────────────────────────────────────────────────────────────

    pub fn list_books(&self) -> Vec<GlossaryBook> {
        let mut books: Vec<GlossaryBook> = self.books.values().map(BookFile::to_book).collect();
        books.sort_by(|a, b| a.created_at.cmp(&b.created_at).then(a.id.cmp(&b.id)));
        books
    }

    pub fn get_book(&self, book_id: &str) -> Option<GlossaryBook> {
        self.books.get(book_id).map(BookFile::to_book)
    }

    pub fn upsert_book(&mut self, input: GlossaryBookInput) -> Result<GlossaryBook, String> {
        let name = require_non_empty("name", &input.name)?;
        let source_language = normalize_optional(input.source_language);
        let target_language = normalize_optional(input.target_language);
        let now = now_secs();

        let book_id = match input.id.as_deref().map(str::trim).filter(|id| !id.is_empty()) {
            Some(id) => {
                validate_book_id(id)?;
                let book = self
                    .books
                    .get_mut(id)
                    .ok_or_else(|| format!("glossary book `{id}` does not exist"))?;
                book.name = name;
                book.enabled = input.enabled;
                book.source_language = source_language;
                book.target_language = target_language;
                book.updated_at = now;
                id.to_owned()
            }
            None => {
                let taken: HashSet<String> = self.books.keys().cloned().collect();
                let id = next_id(&mut self.id_seq, |id| taken.contains(id));
                self.books.insert(
                    id.clone(),
                    BookFile {
                        id: id.clone(),
                        name,
                        enabled: input.enabled,
                        source_language,
                        target_language,
                        created_at: now,
                        updated_at: now,
                        entries: Vec::new(),
                    },
                );
                id
            }
        };

        self.commit(&book_id)?;
        Ok(self.books[&book_id].to_book())
    }

    /// Removes a book and its file. Returns `false` if it did not exist.
    pub fn delete_book(&mut self, book_id: &str) -> Result<bool, String> {
        validate_book_id(book_id)?;
        if self.books.remove(book_id).is_none() {
            return Ok(false);
        }
        self.pending_hits.remove(book_id);
        self.generation += 1;

        let path = self.book_path(book_id);
        if path.exists() {
            fs::remove_file(&path).map_err(|error| {
                format!("failed to delete glossary book `{}`: {error}", path.display())
            })?;
        }
        Ok(true)
    }

    // ── Entries ──────────────────────────────────────────────────────────

    /// Entries newest-first, optionally filtered by a case-insensitive
    /// substring of the term, translation, forbidden list or note.
    pub fn list_entries(
        &self,
        book_id: &str,
        query: Option<&str>,
        offset: u32,
        limit: u32,
    ) -> Result<Vec<GlossaryEntry>, String> {
        let book = self.require_book(book_id)?;
        let mut entries: Vec<&GlossaryEntry> = book
            .entries
            .iter()
            .filter(|entry| entry_matches_query(entry, query))
            .collect();
        entries.sort_by(|a, b| {
            b.created_at
                .cmp(&a.created_at)
                .then_with(|| a.term.cmp(&b.term))
        });

        let offset = offset as usize;
        if offset >= entries.len() {
            return Ok(Vec::new());
        }
        let end = if limit == 0 {
            entries.len()
        } else {
            entries.len().min(offset + limit as usize)
        };
        Ok(entries[offset..end].iter().map(|e| (*e).clone()).collect())
    }

    pub fn count_entries(&self, book_id: &str, query: Option<&str>) -> Result<u32, String> {
        let book = self.require_book(book_id)?;
        Ok(book
            .entries
            .iter()
            .filter(|entry| entry_matches_query(entry, query))
            .count() as u32)
    }

    pub fn upsert_entry(
        &mut self,
        book_id: &str,
        input: GlossaryEntryInput,
    ) -> Result<GlossaryEntry, String> {
        validate_book_id(book_id)?;
        let entry = self.apply_entry(book_id, input, now_secs())?;
        self.commit(book_id)?;
        Ok(entry)
    }

    /// Removes an entry. Returns `false` if it did not exist.
    pub fn delete_entry(&mut self, book_id: &str, entry_id: &str) -> Result<bool, String> {
        validate_book_id(book_id)?;
        let book = self
            .books
            .get_mut(book_id)
            .ok_or_else(|| format!("glossary book `{book_id}` does not exist"))?;
        let before = book.entries.len();
        book.entries.retain(|entry| entry.id != entry_id);
        if book.entries.len() == before {
            return Ok(false);
        }
        book.updated_at = now_secs();
        self.commit(book_id)?;
        Ok(true)
    }

    /// Inserts or updates one entry without writing to disk. Shared by
    /// [`Self::upsert_entry`] and bulk import so a multi-row import pays for
    /// a single file write.
    fn apply_entry(
        &mut self,
        book_id: &str,
        input: GlossaryEntryInput,
        now: u64,
    ) -> Result<GlossaryEntry, String> {
        let term = require_non_empty("term", &input.term)?;
        let translation = require_non_empty("translation", &input.translation)?;
        let forbidden: Vec<String> = input
            .forbidden
            .into_iter()
            .map(|value| value.trim().to_owned())
            .filter(|value| !value.is_empty())
            .collect();
        let note = normalize_optional(input.note);

        // A book keys terms case-insensitively: two entries for the same term
        // would give the matcher no way to choose between them.
        let existing_by_term = self
            .books
            .get(book_id)
            .ok_or_else(|| format!("glossary book `{book_id}` does not exist"))?
            .entries
            .iter()
            .find(|entry| entry.term.eq_ignore_ascii_case(&term))
            .map(|entry| entry.id.clone());

        let entry_id = match input.id.as_deref().map(str::trim).filter(|id| !id.is_empty()) {
            Some(id) => {
                if existing_by_term.as_deref().is_some_and(|other| other != id) {
                    return Err(format!("term `{term}` already exists in this book"));
                }
                id.to_owned()
            }
            None => match existing_by_term {
                Some(id) => id,
                None => {
                    let taken: HashSet<String> = self.books[book_id]
                        .entries
                        .iter()
                        .map(|entry| entry.id.clone())
                        .collect();
                    next_id(&mut self.id_seq, |id| taken.contains(id))
                }
            },
        };

        let book = self
            .books
            .get_mut(book_id)
            .ok_or_else(|| format!("glossary book `{book_id}` does not exist"))?;

        let entry = match book.entries.iter_mut().find(|entry| entry.id == entry_id) {
            Some(existing) => {
                existing.term = term;
                existing.translation = translation;
                existing.forbidden = forbidden;
                existing.note = note;
                existing.case_sensitive = input.case_sensitive;
                existing.whole_word = input.whole_word;
                existing.updated_at = now;
                existing.clone()
            }
            None => {
                let entry = GlossaryEntry {
                    id: entry_id,
                    term,
                    translation,
                    forbidden,
                    note,
                    case_sensitive: input.case_sensitive,
                    whole_word: input.whole_word,
                    hits: 0,
                    created_at: now,
                    updated_at: now,
                };
                book.entries.push(entry.clone());
                entry
            }
        };
        book.updated_at = now;
        Ok(entry)
    }

    // ── Matching ─────────────────────────────────────────────────────────

    /// Finds every glossary term present in `text`, longest match wins and
    /// overlaps are dropped left to right.
    pub fn match_text(
        &self,
        text: &str,
        source_language: Option<&str>,
        target_language: Option<&str>,
    ) -> Vec<GlossaryMatch> {
        if text.trim().is_empty() {
            return Vec::new();
        }
        let matcher = self.matcher(source_language, target_language);
        matcher.find(text)
    }

    /// Returns the compiled automaton for a language pair, building it on
    /// first use and reusing it until the term set changes.
    fn matcher(
        &self,
        source_language: Option<&str>,
        target_language: Option<&str>,
    ) -> Arc<CompiledMatcher> {
        let key = MatcherKey::new(source_language, target_language);
        let mut cache = match self.matchers.lock() {
            Ok(cache) => cache,
            // A poisoned cache is only ever stale derived data; rebuild it
            // rather than propagating the panic into the translation path.
            Err(poisoned) => poisoned.into_inner(),
        };
        if cache.generation != self.generation {
            cache.entries.clear();
            cache.generation = self.generation;
        }
        if let Some(matcher) = cache.entries.get(&key) {
            return matcher.clone();
        }
        let matcher = Arc::new(self.compile(source_language, target_language));
        cache.entries.insert(key, matcher.clone());
        matcher
    }

    fn compile(
        &self,
        source_language: Option<&str>,
        target_language: Option<&str>,
    ) -> CompiledMatcher {
        let mut sensitive = PatternSet::default();
        let mut insensitive = PatternSet::default();

        for book in self.books.values() {
            if !book.enabled
                || !language_applies(book.source_language.as_deref(), source_language)
                || !language_applies(book.target_language.as_deref(), target_language)
            {
                continue;
            }
            for entry in &book.entries {
                if entry.term.is_empty() {
                    continue;
                }
                let target = if entry.case_sensitive {
                    &mut sensitive
                } else {
                    &mut insensitive
                };
                target.push(book.id.clone(), entry);
            }
        }

        CompiledMatcher {
            sensitive: sensitive.build(false),
            insensitive: insensitive.build(true),
        }
    }

    // ── Hits ─────────────────────────────────────────────────────────────

    /// Increments the hit counter for every matched entry. Counts accumulate
    /// in memory and reach disk on the next flush interval; see
    /// [`HIT_FLUSH_INTERVAL`].
    pub fn record_hits(&mut self, matches: &[GlossaryMatch]) {
        if matches.is_empty() {
            return;
        }
        for hit in matches {
            let Some(book) = self.books.get_mut(&hit.book_id) else {
                continue;
            };
            let Some(entry) = book.entries.iter_mut().find(|entry| entry.id == hit.entry_id) else {
                continue;
            };
            entry.hits = entry.hits.saturating_add(1);
            self.pending_hits.insert(hit.book_id.clone());
        }

        if self.last_hit_flush.elapsed() >= HIT_FLUSH_INTERVAL {
            if let Err(error) = self.flush_hits() {
                eprintln!("[glossary] failed to persist hit counts: {error}");
            }
        }
    }

    /// Writes any books with unsaved hit counts.
    pub fn flush_hits(&mut self) -> Result<(), String> {
        self.last_hit_flush = Instant::now();
        let pending = std::mem::take(&mut self.pending_hits);
        for book_id in pending {
            let Some(book) = self.books.get(&book_id) else {
                continue;
            };
            self.write_book(book)?;
        }
        Ok(())
    }

    // ── Persistence helpers ──────────────────────────────────────────────

    /// Persists one book and invalidates compiled automatons.
    fn commit(&mut self, book_id: &str) -> Result<(), String> {
        self.generation += 1;
        // The book is about to be written in full, so any hits it was
        // holding go out with it.
        self.pending_hits.remove(book_id);
        let book = self
            .books
            .get(book_id)
            .ok_or_else(|| format!("glossary book `{book_id}` does not exist"))?;
        self.write_book(book)
    }

    fn write_book(&self, book: &BookFile) -> Result<(), String> {
        fs::create_dir_all(&self.dir).map_err(|error| {
            format!(
                "failed to create glossary directory `{}`: {error}",
                self.dir.display()
            )
        })?;
        let path = self.book_path(&book.id);
        let content = serde_json::to_string_pretty(book)
            .map_err(|error| format!("failed to encode glossary book `{}`: {error}", book.id))?;
        fs::write(&path, content).map_err(|error| {
            format!("failed to write glossary book `{}`: {error}", path.display())
        })
    }

    fn book_path(&self, book_id: &str) -> PathBuf {
        self.dir.join(format!("{book_id}.json"))
    }

    fn require_book(&self, book_id: &str) -> Result<&BookFile, String> {
        self.books
            .get(book_id)
            .ok_or_else(|| format!("glossary book `{book_id}` does not exist"))
    }
}

/// Time-ordered id, retried until `taken` reports it free. Ids restart their
/// sequence each launch, so the collision check is what actually guarantees
/// uniqueness.
fn next_id(id_seq: &mut u64, taken: impl Fn(&str) -> bool) -> String {
    loop {
        *id_seq += 1;
        let id = format!("{:x}{:03x}", now_millis(), *id_seq & 0xfff);
        if !taken(&id) {
            return id;
        }
    }
}

/// Reports which glossary rules `translated` breaks, at most one issue per
/// entry per kind however often the term occurs in the source.
pub fn check_compliance(
    matches: &[GlossaryMatch],
    translated: &str,
) -> Vec<GlossaryComplianceIssue> {
    let haystack = translated.to_lowercase();
    let mut issues = Vec::new();
    let mut seen = HashSet::new();

    for hit in matches {
        if !seen.insert((hit.book_id.as_str(), hit.entry_id.as_str())) {
            continue;
        }
        if !haystack.contains(&hit.translation.to_lowercase()) {
            issues.push(GlossaryComplianceIssue {
                book_id: hit.book_id.clone(),
                entry_id: hit.entry_id.clone(),
                kind: GlossaryIssueKind::MissingTranslation,
                term: hit.term.clone(),
                expected: hit.translation.clone(),
                found: None,
            });
        }
        for forbidden in &hit.forbidden {
            if haystack.contains(&forbidden.to_lowercase()) {
                issues.push(GlossaryComplianceIssue {
                    book_id: hit.book_id.clone(),
                    entry_id: hit.entry_id.clone(),
                    kind: GlossaryIssueKind::ForbiddenUsed,
                    term: hit.term.clone(),
                    expected: hit.translation.clone(),
                    found: Some(forbidden.clone()),
                });
            }
        }
    }
    issues
}

// ── Matcher internals ────────────────────────────────────────────────────────

#[derive(Default)]
struct MatcherCache {
    generation: u64,
    entries: HashMap<MatcherKey, Arc<CompiledMatcher>>,
}

#[derive(Clone, PartialEq, Eq, Hash)]
struct MatcherKey {
    source: Option<String>,
    target: Option<String>,
}

impl MatcherKey {
    fn new(source: Option<&str>, target: Option<&str>) -> Self {
        Self {
            source: normalize_language(source),
            target: normalize_language(target),
        }
    }
}

/// One term's identity, parallel to the automaton's pattern list.
#[derive(Clone)]
struct PatternInfo {
    book_id: String,
    entry_id: String,
    term: String,
    translation: String,
    forbidden: Vec<String>,
    whole_word: bool,
}

#[derive(Default)]
struct PatternSet {
    patterns: Vec<String>,
    infos: Vec<PatternInfo>,
}

impl PatternSet {
    fn push(&mut self, book_id: String, entry: &GlossaryEntry) {
        self.patterns.push(entry.term.clone());
        self.infos.push(PatternInfo {
            book_id,
            entry_id: entry.id.clone(),
            term: entry.term.clone(),
            translation: entry.translation.clone(),
            forbidden: entry.forbidden.clone(),
            whole_word: entry.whole_word,
        });
    }

    fn build(self, case_insensitive: bool) -> Option<Automaton> {
        if self.patterns.is_empty() {
            return None;
        }
        // Building can only fail on pathological inputs (e.g. a pattern set
        // too large for the chosen automaton); a glossary that cannot compile
        // is better skipped than fatal to translation.
        let automaton = AhoCorasick::builder()
            .match_kind(MatchKind::LeftmostLongest)
            .ascii_case_insensitive(case_insensitive)
            .build(&self.patterns)
            .map_err(|error| eprintln!("[glossary] failed to build matcher: {error}"))
            .ok()?;
        Some(Automaton {
            automaton,
            infos: self.infos,
        })
    }
}

struct Automaton {
    automaton: AhoCorasick,
    infos: Vec<PatternInfo>,
}

/// Two automatons because Aho-Corasick sets case sensitivity for the whole
/// set, not per pattern. Case-insensitivity is ASCII-only, which covers the
/// Latin terms it matters for; CJK terms are unaffected by casing.
pub struct CompiledMatcher {
    sensitive: Option<Automaton>,
    insensitive: Option<Automaton>,
}

impl CompiledMatcher {
    fn find(&self, text: &str) -> Vec<GlossaryMatch> {
        let mut raw: Vec<(usize, usize, &PatternInfo)> = Vec::new();
        for automaton in [self.sensitive.as_ref(), self.insensitive.as_ref()]
            .into_iter()
            .flatten()
        {
            for found in automaton.automaton.find_iter(text) {
                let info = &automaton.infos[found.pattern().as_usize()];
                if info.whole_word && !is_word_boundary(text, found.start(), found.end(), &info.term)
                {
                    continue;
                }
                raw.push((found.start(), found.end(), info));
            }
        }

        // Longest match wins at a given position, and once a span is taken
        // nothing overlapping it may also match.
        raw.sort_by(|a, b| a.0.cmp(&b.0).then_with(|| b.1.cmp(&a.1)));
        let mut matches = Vec::new();
        let mut consumed_to = 0usize;
        for (start, end, info) in raw {
            if start < consumed_to {
                continue;
            }
            consumed_to = end;
            matches.push(GlossaryMatch {
                book_id: info.book_id.clone(),
                entry_id: info.entry_id.clone(),
                term: info.term.clone(),
                matched_text: text[start..end].to_owned(),
                translation: info.translation.clone(),
                forbidden: info.forbidden.clone(),
                start: start as u32,
                end: end as u32,
            });
        }
        matches
    }
}

/// Checks that a match is not embedded in a longer word. Only the sides where
/// the term itself ends in an ASCII alphanumeric are checked, so terms
/// wrapped in punctuation and CJK terms are never rejected.
fn is_word_boundary(text: &str, start: usize, end: usize, term: &str) -> bool {
    let is_word_char = |c: char| c.is_ascii_alphanumeric() || c == '_';

    if term.chars().next().is_some_and(|c| c.is_ascii_alphanumeric()) {
        if let Some(prev) = text[..start].chars().next_back() {
            if is_word_char(prev) {
                return false;
            }
        }
    }
    if term
        .chars()
        .next_back()
        .is_some_and(|c| c.is_ascii_alphanumeric())
    {
        if let Some(next) = text[end..].chars().next() {
            if is_word_char(next) {
                return false;
            }
        }
    }
    true
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// A book restricted to a language still applies when the request's language
/// is unknown: dropping the constraint silently is worse than applying it.
fn language_applies(book: Option<&str>, request: Option<&str>) -> bool {
    let Some(book) = book.map(str::trim).filter(|value| !value.is_empty()) else {
        return true;
    };
    let Some(request) = request.map(str::trim).filter(|value| !value.is_empty()) else {
        return true;
    };
    if request.eq_ignore_ascii_case("auto") || book.eq_ignore_ascii_case(request) {
        return true;
    }
    primary_subtag(book).eq_ignore_ascii_case(primary_subtag(request))
}

/// `zh-Hans` and `zh` are the same language for glossary purposes.
fn primary_subtag(language: &str) -> &str {
    language
        .split(['-', '_'])
        .next()
        .unwrap_or(language)
}

fn normalize_language(language: Option<&str>) -> Option<String> {
    language
        .map(|value| value.trim().to_lowercase())
        .filter(|value| !value.is_empty())
}

fn normalize_optional(value: Option<String>) -> Option<String> {
    value
        .map(|value| value.trim().to_owned())
        .filter(|value| !value.is_empty())
}

fn require_non_empty(name: &str, value: &str) -> Result<String, String> {
    let value = value.trim();
    if value.is_empty() {
        return Err(format!("{name} is required"));
    }
    Ok(value.to_owned())
}

fn entry_matches_query(entry: &GlossaryEntry, query: Option<&str>) -> bool {
    let Some(query) = query.map(str::trim).filter(|value| !value.is_empty()) else {
        return true;
    };
    let needle = query.to_lowercase();
    entry.term.to_lowercase().contains(&needle)
        || entry.translation.to_lowercase().contains(&needle)
        || entry
            .forbidden
            .iter()
            .any(|value| value.to_lowercase().contains(&needle))
        || entry
            .note
            .as_deref()
            .is_some_and(|note| note.to_lowercase().contains(&needle))
}

/// Book ids become file names, so they may not carry path separators or
/// anything else that would let a book escape the glossary directory.
fn validate_book_id(book_id: &str) -> Result<(), String> {
    if book_id.is_empty() {
        return Err("book_id is required".to_owned());
    }
    if !book_id
        .chars()
        .all(|c| c.is_ascii_alphanumeric() || c == '-' || c == '_')
    {
        return Err(format!(
            "invalid glossary book id `{book_id}`: only letters, digits, `-` and `_` are allowed"
        ));
    }
    Ok(())
}

fn load_book_file(path: &Path) -> Result<BookFile, String> {
    let content = fs::read_to_string(path).map_err(|error| format!("failed to read: {error}"))?;
    let mut book: BookFile =
        serde_json::from_str(&content).map_err(|error| format!("failed to parse: {error}"))?;
    if book.id.trim().is_empty() {
        book.id = path
            .file_stem()
            .and_then(|stem| stem.to_str())
            .unwrap_or_default()
            .to_owned();
    }
    validate_book_id(&book.id)?;
    Ok(book)
}

fn now_secs() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|duration| duration.as_secs())
        .unwrap_or_default()
}

fn now_millis() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|duration| duration.as_millis() as u64)
        .unwrap_or_default()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn temp_data_dir() -> PathBuf {
        let unique = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("time went backwards")
            .as_nanos();
        std::env::temp_dir().join(format!("beyondtranslate-glossary-{unique}"))
    }

    fn book_input(name: &str) -> GlossaryBookInput {
        GlossaryBookInput {
            id: None,
            name: name.to_owned(),
            enabled: true,
            source_language: None,
            target_language: None,
        }
    }

    fn entry_input(term: &str, translation: &str) -> GlossaryEntryInput {
        GlossaryEntryInput {
            id: None,
            term: term.to_owned(),
            translation: translation.to_owned(),
            forbidden: Vec::new(),
            note: None,
            case_sensitive: false,
            whole_word: true,
        }
    }

    fn store_with_terms(terms: &[(&str, &str)]) -> (GlossaryStore, String) {
        let mut store = GlossaryStore::load(temp_data_dir()).expect("failed to load glossary");
        let book = store.upsert_book(book_input("测试")).expect("upsert book");
        for (term, translation) in terms {
            store
                .upsert_entry(&book.id, entry_input(term, translation))
                .expect("upsert entry");
        }
        (store, book.id)
    }

    #[test]
    fn load_missing_directory_returns_empty_glossary() {
        let store = GlossaryStore::load(temp_data_dir()).expect("failed to load glossary");
        assert!(store.list_books().is_empty());
    }

    #[test]
    fn books_and_entries_round_trip_through_disk() {
        let dir = temp_data_dir();
        let book_id = {
            let mut store = GlossaryStore::load(&dir).expect("failed to load glossary");
            let book = store.upsert_book(book_input("机器学习")).expect("upsert book");
            store
                .upsert_entry(&book.id, entry_input("token", "词元"))
                .expect("upsert entry");
            book.id
        };

        let store = GlossaryStore::load(&dir).expect("failed to reload glossary");
        let books = store.list_books();
        assert_eq!(books.len(), 1);
        assert_eq!(books[0].name, "机器学习");
        assert_eq!(books[0].entry_count, 1);

        let entries = store.list_entries(&book_id, None, 0, 0).expect("entries");
        assert_eq!(entries.len(), 1);
        assert_eq!(entries[0].term, "token");
        assert_eq!(entries[0].translation, "词元");
    }

    #[test]
    fn delete_book_removes_its_file() {
        let dir = temp_data_dir();
        let mut store = GlossaryStore::load(&dir).expect("failed to load glossary");
        let book = store.upsert_book(book_input("临时")).expect("upsert book");
        let path = dir.join(GLOSSARY_DIR).join(format!("{}.json", book.id));
        assert!(path.exists());

        assert!(store.delete_book(&book.id).expect("delete book"));
        assert!(!path.exists());
        assert!(!store.delete_book(&book.id).expect("delete missing book"));
    }

    #[test]
    fn upsert_entry_updates_the_existing_term_instead_of_duplicating() {
        let (mut store, book_id) = store_with_terms(&[("token", "词元")]);
        store
            .upsert_entry(&book_id, entry_input("TOKEN", "标记"))
            .expect("upsert entry");

        let entries = store.list_entries(&book_id, None, 0, 0).expect("entries");
        assert_eq!(entries.len(), 1);
        assert_eq!(entries[0].term, "TOKEN");
        assert_eq!(entries[0].translation, "标记");
    }

    #[test]
    fn renaming_an_entry_onto_another_term_is_rejected() {
        let (mut store, book_id) = store_with_terms(&[("token", "词元"), ("embedding", "嵌入")]);
        let entries = store.list_entries(&book_id, None, 0, 0).expect("entries");
        let embedding = entries
            .iter()
            .find(|entry| entry.term == "embedding")
            .expect("embedding entry");

        let mut input = entry_input("token", "词元");
        input.id = Some(embedding.id.clone());
        let error = store.upsert_entry(&book_id, input).unwrap_err();
        assert!(error.contains("already exists"), "unexpected error: {error}");
    }

    #[test]
    fn list_entries_filters_by_query_and_paginates() {
        let (store, book_id) =
            store_with_terms(&[("token", "词元"), ("embedding", "嵌入"), ("prompt", "提示词")]);

        let filtered = store
            .list_entries(&book_id, Some("嵌入"), 0, 0)
            .expect("entries");
        assert_eq!(filtered.len(), 1);
        assert_eq!(filtered[0].term, "embedding");

        assert_eq!(store.count_entries(&book_id, None).expect("count"), 3);
        assert_eq!(
            store.list_entries(&book_id, None, 1, 1).expect("page").len(),
            1
        );
        assert!(store
            .list_entries(&book_id, None, 9, 1)
            .expect("page past end")
            .is_empty());
    }

    #[test]
    fn matching_prefers_the_longest_term() {
        let (store, _) = store_with_terms(&[("fine", "美好"), ("fine-tune", "微调")]);
        let matches = store.match_text("we fine-tune the model", None, None);
        assert_eq!(matches.len(), 1);
        assert_eq!(matches[0].term, "fine-tune");
        assert_eq!(matches[0].translation, "微调");
    }

    #[test]
    fn matching_is_case_insensitive_by_default() {
        let (store, _) = store_with_terms(&[("token", "词元")]);
        let matches = store.match_text("A Token and a TOKEN", None, None);
        assert_eq!(matches.len(), 2);
        assert_eq!(matches[0].matched_text, "Token");
        assert_eq!(matches[1].matched_text, "TOKEN");
    }

    #[test]
    fn case_sensitive_entries_only_match_their_own_casing() {
        let mut store = GlossaryStore::load(temp_data_dir()).expect("failed to load glossary");
        let book = store.upsert_book(book_input("品牌")).expect("upsert book");
        let mut input = entry_input("IT", "信息技术");
        input.case_sensitive = true;
        store.upsert_entry(&book.id, input).expect("upsert entry");

        let matches = store.match_text("IT is what it is", None, None);
        assert_eq!(matches.len(), 1);
        assert_eq!(matches[0].start, 0);
    }

    #[test]
    fn whole_word_matching_rejects_terms_inside_longer_words() {
        let (store, _) = store_with_terms(&[("art", "艺术")]);
        assert!(store.match_text("started", None, None).is_empty());
        assert_eq!(store.match_text("modern art.", None, None).len(), 1);
    }

    #[test]
    fn whole_word_matching_does_not_block_cjk_terms() {
        let (store, _) = store_with_terms(&[("词元", "token")]);
        assert_eq!(store.match_text("这个词元很重要", None, None).len(), 1);
    }

    #[test]
    fn books_only_apply_to_their_language_pair() {
        let mut store = GlossaryStore::load(temp_data_dir()).expect("failed to load glossary");
        let book = store
            .upsert_book(GlossaryBookInput {
                id: None,
                name: "英译中".to_owned(),
                enabled: true,
                source_language: Some("en".to_owned()),
                target_language: Some("zh-Hans".to_owned()),
            })
            .expect("upsert book");
        store
            .upsert_entry(&book.id, entry_input("token", "词元"))
            .expect("upsert entry");

        // Exact pair, primary-subtag match, unknown and `auto` all apply.
        assert_eq!(
            store.match_text("token", Some("en"), Some("zh-Hans")).len(),
            1
        );
        assert_eq!(store.match_text("token", Some("en"), Some("zh")).len(), 1);
        assert_eq!(store.match_text("token", None, None).len(), 1);
        assert_eq!(
            store.match_text("token", Some("auto"), Some("zh-Hans")).len(),
            1
        );
        // A different target language does not.
        assert!(store.match_text("token", Some("en"), Some("ja")).is_empty());
    }

    #[test]
    fn disabled_books_do_not_match() {
        let (mut store, book_id) = store_with_terms(&[("token", "词元")]);
        assert_eq!(store.match_text("token", None, None).len(), 1);

        let book = store.get_book(&book_id).expect("book");
        store
            .upsert_book(GlossaryBookInput {
                id: Some(book.id),
                name: book.name,
                enabled: false,
                source_language: None,
                target_language: None,
            })
            .expect("disable book");
        assert!(store.match_text("token", None, None).is_empty());
    }

    #[test]
    fn edits_invalidate_the_compiled_matcher() {
        let (mut store, book_id) = store_with_terms(&[("token", "词元")]);
        assert_eq!(store.match_text("token", None, None).len(), 1);

        let entries = store.list_entries(&book_id, None, 0, 0).expect("entries");
        store
            .delete_entry(&book_id, &entries[0].id)
            .expect("delete entry");
        assert!(store.match_text("token", None, None).is_empty());
    }

    #[test]
    fn compliance_reports_missing_and_forbidden_translations() {
        let mut store = GlossaryStore::load(temp_data_dir()).expect("failed to load glossary");
        let book = store.upsert_book(book_input("机器学习")).expect("upsert book");
        let mut input = entry_input("token", "词元");
        input.forbidden = vec!["标记".to_owned(), "令牌".to_owned()];
        store.upsert_entry(&book.id, input).expect("upsert entry");

        let matches = store.match_text("a token here", None, None);
        assert!(check_compliance(&matches, "这里有一个词元").is_empty());

        let issues = check_compliance(&matches, "这里有一个标记");
        assert_eq!(issues.len(), 2);
        assert_eq!(issues[0].kind, GlossaryIssueKind::MissingTranslation);
        assert_eq!(issues[1].kind, GlossaryIssueKind::ForbiddenUsed);
        assert_eq!(issues[1].found.as_deref(), Some("标记"));
    }

    #[test]
    fn compliance_reports_each_entry_once_however_often_it_matched() {
        let (store, _) = store_with_terms(&[("token", "词元")]);
        let matches = store.match_text("token token token", None, None);
        assert_eq!(matches.len(), 3);
        assert_eq!(check_compliance(&matches, "空译文").len(), 1);
    }

    #[test]
    fn record_hits_counts_every_occurrence() {
        let (mut store, book_id) = store_with_terms(&[("token", "词元")]);
        let matches = store.match_text("token and token", None, None);
        store.record_hits(&matches);
        store.flush_hits().expect("flush hits");

        let entries = store.list_entries(&book_id, None, 0, 0).expect("entries");
        assert_eq!(entries[0].hits, 2);
    }

    #[test]
    fn hit_counts_survive_a_reload() {
        let dir = temp_data_dir();
        let book_id = {
            let mut store = GlossaryStore::load(&dir).expect("failed to load glossary");
            let book = store.upsert_book(book_input("机器学习")).expect("upsert book");
            store
                .upsert_entry(&book.id, entry_input("token", "词元"))
                .expect("upsert entry");
            let matches = store.match_text("token", None, None);
            store.record_hits(&matches);
            store.flush_hits().expect("flush hits");
            book.id
        };

        let store = GlossaryStore::load(&dir).expect("failed to reload glossary");
        let entries = store.list_entries(&book_id, None, 0, 0).expect("entries");
        assert_eq!(entries[0].hits, 1);
    }

    #[test]
    fn book_ids_that_could_escape_the_directory_are_rejected() {
        let mut store = GlossaryStore::load(temp_data_dir()).expect("failed to load glossary");
        assert!(store.delete_book("../settings").is_err());
        assert!(store
            .upsert_entry("../settings", entry_input("token", "词元"))
            .is_err());
    }

    #[test]
    fn a_corrupt_book_does_not_break_the_rest_of_the_glossary() {
        let dir = temp_data_dir();
        let mut store = GlossaryStore::load(&dir).expect("failed to load glossary");
        store.upsert_book(book_input("好的")).expect("upsert book");
        fs::write(dir.join(GLOSSARY_DIR).join("broken.json"), "{not json")
            .expect("failed to write corrupt book");

        let store = GlossaryStore::load(&dir).expect("failed to reload glossary");
        assert_eq!(store.list_books().len(), 1);
    }
}
