//! Local translation history backed by `<data_dir>/history.json`.
//!
//! History is deliberately independent from settings: a damaged history file
//! must never prevent translation from starting. Ordinary entries expire after
//! 90 days while favorites are retained until the user deletes them.

use std::fs;
use std::path::{Path, PathBuf};
use std::time::{SystemTime, UNIX_EPOCH};

use serde::{Deserialize, Serialize};

const HISTORY_FILE: &str = "history.json";
const HISTORY_VERSION: u32 = 1;
const RETENTION_SECS: u64 = 90 * 24 * 60 * 60;

#[derive(Clone, Copy, Debug, PartialEq, Eq, uniffi::Enum)]
pub enum HistoryFilter {
    All,
    Favorites,
    Edited,
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize, uniffi::Record)]
#[serde(rename_all = "camelCase")]
pub struct HistoryEntry {
    pub id: String,
    pub source: String,
    pub translation: String,
    pub source_language: String,
    pub target_language: String,
    pub service_id: String,
    pub service_name: String,
    pub favorite: bool,
    pub edited: bool,
    pub created_at: u64,
    pub updated_at: u64,
}

#[derive(Clone, Debug, PartialEq, Eq, uniffi::Record)]
pub struct HistoryEntryInput {
    pub id: Option<String>,
    pub source: String,
    pub translation: String,
    pub source_language: String,
    pub target_language: String,
    pub service_id: String,
    pub service_name: String,
    pub edited: bool,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, uniffi::Record)]
pub struct HistoryCounts {
    pub all: u32,
    pub favorites: u32,
    pub edited: u32,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
struct HistoryFile {
    version: u32,
    entries: Vec<HistoryEntry>,
}

impl Default for HistoryFile {
    fn default() -> Self {
        Self {
            version: HISTORY_VERSION,
            entries: Vec::new(),
        }
    }
}

pub struct HistoryStore {
    path: PathBuf,
    entries: Vec<HistoryEntry>,
    id_seq: u64,
}

impl HistoryStore {
    pub fn load(data_dir: impl AsRef<Path>) -> Self {
        let path = data_dir.as_ref().join(HISTORY_FILE);
        let mut file = match fs::read_to_string(&path) {
            Ok(content) => match serde_json::from_str::<HistoryFile>(&content) {
                Ok(file) if file.version == HISTORY_VERSION => file,
                Ok(file) => {
                    eprintln!(
                        "[history] unsupported history version {} in `{}`",
                        file.version,
                        path.display()
                    );
                    quarantine(&path);
                    HistoryFile::default()
                }
                Err(error) => {
                    eprintln!("[history] failed to decode `{}`: {error}", path.display());
                    quarantine(&path);
                    HistoryFile::default()
                }
            },
            Err(error) if error.kind() == std::io::ErrorKind::NotFound => HistoryFile::default(),
            Err(error) => {
                eprintln!("[history] failed to read `{}`: {error}", path.display());
                HistoryFile::default()
            }
        };

        let before = file.entries.len();
        prune_entries(&mut file.entries, now_secs());
        let store = Self {
            path,
            entries: file.entries,
            id_seq: 0,
        };
        if store.entries.len() != before {
            if let Err(error) = store.persist() {
                eprintln!("[history] failed to persist retention cleanup: {error}");
            }
        }
        store
    }

    pub fn list_entries(
        &mut self,
        filter: HistoryFilter,
        query: Option<&str>,
    ) -> Result<Vec<HistoryEntry>, String> {
        self.prune()?;
        let needle = query.unwrap_or_default().trim().to_lowercase();
        let mut entries = self
            .entries
            .iter()
            .filter(|entry| match filter {
                HistoryFilter::All => true,
                HistoryFilter::Favorites => entry.favorite,
                HistoryFilter::Edited => entry.edited,
            })
            .filter(|entry| {
                needle.is_empty()
                    || [
                        &entry.source,
                        &entry.translation,
                        &entry.service_name,
                        &entry.service_id,
                        &entry.source_language,
                        &entry.target_language,
                    ]
                    .iter()
                    .any(|value| value.to_lowercase().contains(&needle))
            })
            .cloned()
            .collect::<Vec<_>>();
        entries.sort_by(|a, b| {
            b.created_at
                .cmp(&a.created_at)
                .then_with(|| b.updated_at.cmp(&a.updated_at))
                .then_with(|| b.id.cmp(&a.id))
        });
        Ok(entries)
    }

    pub fn counts(&mut self) -> Result<HistoryCounts, String> {
        self.prune()?;
        Ok(HistoryCounts {
            all: self.entries.len().try_into().unwrap_or(u32::MAX),
            favorites: self
                .entries
                .iter()
                .filter(|entry| entry.favorite)
                .count()
                .try_into()
                .unwrap_or(u32::MAX),
            edited: self
                .entries
                .iter()
                .filter(|entry| entry.edited)
                .count()
                .try_into()
                .unwrap_or(u32::MAX),
        })
    }

    pub fn upsert_entry(&mut self, input: HistoryEntryInput) -> Result<HistoryEntry, String> {
        let source = required("source", input.source)?;
        let translation = required("translation", input.translation)?;
        let now = now_secs();

        let existing_index = input
            .id
            .as_deref()
            .and_then(|id| self.entries.iter().position(|entry| entry.id == id));
        let (id, created_at, favorite) = if let Some(index) = existing_index {
            let entry = &self.entries[index];
            (entry.id.clone(), entry.created_at, entry.favorite)
        } else {
            let id = input
                .id
                .as_deref()
                .map(str::trim)
                .filter(|id| !id.is_empty())
                .map(str::to_owned)
                .unwrap_or_else(|| self.next_id());
            (id, now, false)
        };

        let entry = HistoryEntry {
            id,
            source,
            translation,
            source_language: input.source_language.trim().to_owned(),
            target_language: input.target_language.trim().to_owned(),
            service_id: input.service_id.trim().to_owned(),
            service_name: input.service_name.trim().to_owned(),
            favorite,
            edited: input.edited,
            created_at,
            updated_at: now,
        };

        if let Some(index) = existing_index {
            self.entries[index] = entry.clone();
        } else {
            self.entries.push(entry.clone());
        }
        self.prune_entries_only(now);
        self.persist()?;
        Ok(entry)
    }

    pub fn set_favorite(
        &mut self,
        entry_id: &str,
        favorite: bool,
    ) -> Result<Option<HistoryEntry>, String> {
        let Some(index) = self.entries.iter().position(|entry| entry.id == entry_id) else {
            return Ok(None);
        };
        self.entries[index].favorite = favorite;
        self.entries[index].updated_at = now_secs();
        self.prune_entries_only(now_secs());
        let entry = self
            .entries
            .iter()
            .find(|entry| entry.id == entry_id)
            .cloned();
        self.persist()?;
        Ok(entry)
    }

    pub fn delete_entries(&mut self, entry_ids: &[String]) -> Result<u32, String> {
        let before = self.entries.len();
        self.entries
            .retain(|entry| !entry_ids.iter().any(|id| id == &entry.id));
        let removed = before.saturating_sub(self.entries.len());
        if removed > 0 {
            self.persist()?;
        }
        Ok(removed.try_into().unwrap_or(u32::MAX))
    }

    fn next_id(&mut self) -> String {
        loop {
            self.id_seq += 1;
            let id = format!("{:x}{:03x}", now_millis(), self.id_seq & 0xfff);
            if !self.entries.iter().any(|entry| entry.id == id) {
                return id;
            }
        }
    }

    fn prune(&mut self) -> Result<(), String> {
        let before = self.entries.len();
        self.prune_entries_only(now_secs());
        if self.entries.len() != before {
            self.persist()?;
        }
        Ok(())
    }

    fn prune_entries_only(&mut self, now: u64) {
        prune_entries(&mut self.entries, now);
    }

    fn persist(&self) -> Result<(), String> {
        let parent = self
            .path
            .parent()
            .ok_or_else(|| "history path has no parent".to_owned())?;
        fs::create_dir_all(parent).map_err(|error| {
            format!(
                "failed to create history directory `{}`: {error}",
                parent.display()
            )
        })?;
        let content = serde_json::to_string_pretty(&HistoryFile {
            version: HISTORY_VERSION,
            entries: self.entries.clone(),
        })
        .map_err(|error| format!("failed to encode history: {error}"))?;
        let temporary = self.path.with_extension("json.tmp");
        fs::write(&temporary, content).map_err(|error| {
            format!("failed to write history `{}`: {error}", temporary.display())
        })?;
        if self.path.exists() {
            fs::remove_file(&self.path).map_err(|error| {
                format!(
                    "failed to replace history `{}`: {error}",
                    self.path.display()
                )
            })?;
        }
        fs::rename(&temporary, &self.path).map_err(|error| {
            format!(
                "failed to commit history `{}`: {error}",
                self.path.display()
            )
        })
    }
}

fn required(field: &str, value: String) -> Result<String, String> {
    let value = value.trim().to_owned();
    if value.is_empty() {
        Err(format!("history {field} must not be empty"))
    } else {
        Ok(value)
    }
}

fn prune_entries(entries: &mut Vec<HistoryEntry>, now: u64) {
    entries
        .retain(|entry| entry.favorite || now.saturating_sub(entry.created_at) <= RETENTION_SECS);
}

fn quarantine(path: &Path) {
    if !path.exists() {
        return;
    }
    let quarantine = path.with_file_name(format!("history.json.corrupt-{}", now_secs()));
    if let Err(error) = fs::rename(path, &quarantine) {
        eprintln!(
            "[history] failed to quarantine `{}` as `{}`: {error}",
            path.display(),
            quarantine.display()
        );
    }
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
        std::env::temp_dir().join(format!("beyondtranslate-history-{unique}"))
    }

    fn input(source: &str, translation: &str) -> HistoryEntryInput {
        HistoryEntryInput {
            id: None,
            source: source.to_owned(),
            translation: translation.to_owned(),
            source_language: "en".to_owned(),
            target_language: "zh-Hans".to_owned(),
            service_id: "system+translation".to_owned(),
            service_name: "System".to_owned(),
            edited: false,
        }
    }

    #[test]
    fn entries_round_trip_and_are_newest_first() {
        let dir = temp_data_dir();
        let first_id = {
            let mut store = HistoryStore::load(&dir);
            let first = store.upsert_entry(input("one", "一")).expect("first");
            let second = store.upsert_entry(input("two", "二")).expect("second");
            assert_ne!(first.id, second.id);
            first.id
        };
        let mut store = HistoryStore::load(&dir);
        let entries = store.list_entries(HistoryFilter::All, None).expect("list");
        assert_eq!(entries.len(), 2);
        assert_eq!(entries.last().expect("last").id, first_id);
    }

    #[test]
    fn upsert_preserves_identity_creation_time_and_favorite() {
        let mut store = HistoryStore::load(temp_data_dir());
        let first = store.upsert_entry(input("one", "一")).expect("first");
        store
            .set_favorite(&first.id, true)
            .expect("favorite history");
        let mut replacement = input("one", "壹");
        replacement.id = Some(first.id.clone());
        replacement.edited = true;
        let updated = store.upsert_entry(replacement).expect("update");
        assert_eq!(updated.id, first.id);
        assert_eq!(updated.created_at, first.created_at);
        assert!(updated.favorite);
        assert!(updated.edited);
        assert_eq!(updated.translation, "壹");
    }

    #[test]
    fn filters_counts_search_and_delete_agree() {
        let mut store = HistoryStore::load(temp_data_dir());
        let first = store
            .upsert_entry(input("self attention", "自注意力"))
            .expect("first");
        store.set_favorite(&first.id, true).expect("favorite");
        let mut second = input("build failed", "构建失败");
        second.edited = true;
        let second = store.upsert_entry(second).expect("second");
        assert_eq!(
            store.counts().expect("counts"),
            HistoryCounts {
                all: 2,
                favorites: 1,
                edited: 1,
            }
        );
        assert_eq!(
            store
                .list_entries(HistoryFilter::Favorites, Some("attention"))
                .expect("search")
                .len(),
            1
        );
        assert_eq!(
            store
                .delete_entries(&[first.id, second.id])
                .expect("delete"),
            2
        );
    }

    #[test]
    fn retention_removes_old_normal_entries_but_keeps_favorites() {
        let dir = temp_data_dir();
        let old = now_secs().saturating_sub(RETENTION_SECS + 1);
        let file = HistoryFile {
            version: HISTORY_VERSION,
            entries: vec![
                HistoryEntry {
                    id: "normal".to_owned(),
                    source: "old".to_owned(),
                    translation: "旧".to_owned(),
                    source_language: "en".to_owned(),
                    target_language: "zh".to_owned(),
                    service_id: "a".to_owned(),
                    service_name: "A".to_owned(),
                    favorite: false,
                    edited: false,
                    created_at: old,
                    updated_at: old,
                },
                HistoryEntry {
                    id: "favorite".to_owned(),
                    source: "kept".to_owned(),
                    translation: "保留".to_owned(),
                    source_language: "en".to_owned(),
                    target_language: "zh".to_owned(),
                    service_id: "a".to_owned(),
                    service_name: "A".to_owned(),
                    favorite: true,
                    edited: false,
                    created_at: old,
                    updated_at: old,
                },
            ],
        };
        fs::create_dir_all(&dir).expect("create temp dir");
        fs::write(
            dir.join(HISTORY_FILE),
            serde_json::to_string(&file).expect("encode"),
        )
        .expect("write history");
        let mut store = HistoryStore::load(&dir);
        let entries = store.list_entries(HistoryFilter::All, None).expect("list");
        assert_eq!(entries.len(), 1);
        assert_eq!(entries[0].id, "favorite");
        store
            .set_favorite("favorite", false)
            .expect("remove favorite");
        assert!(store
            .list_entries(HistoryFilter::All, None)
            .expect("list after unfavorite")
            .is_empty());
    }

    #[test]
    fn corrupt_file_is_quarantined() {
        let dir = temp_data_dir();
        fs::create_dir_all(&dir).expect("create temp dir");
        fs::write(dir.join(HISTORY_FILE), "not json").expect("write corrupt history");
        let mut store = HistoryStore::load(&dir);
        assert!(store
            .list_entries(HistoryFilter::All, None)
            .expect("list")
            .is_empty());
        assert!(fs::read_dir(&dir).expect("read temp dir").any(|entry| entry
            .expect("dir entry")
            .file_name()
            .to_string_lossy()
            .starts_with("history.json.corrupt-")));
    }
}
