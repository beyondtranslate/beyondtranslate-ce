use serde::{Deserialize, Serialize};

/// A language pair (source -> target).
///
/// `source == "auto"` means the target is always active. A concrete source
/// language only becomes active when it matches the detected language.
///
/// Language detection is a routing *hint*, never a gate: when nothing
/// matches, [`filter_active`] falls back to every enabled target rather
/// than translating nothing. See [`TranslationTarget::filter_active`].
#[derive(Debug, Clone, PartialEq, Eq, Default, Serialize, Deserialize)]
pub struct TranslationTarget {
    pub source: String,
    pub target: String,
    /// Whether this translation target is enabled. Disabled targets are
    /// skipped by [`filter_active`].
    #[serde(default = "default_enabled")]
    pub enabled: bool,
}

fn default_enabled() -> bool {
    true
}

impl TranslationTarget {
    /// Sentinel value for auto-detected source language.
    pub const AUTO_SOURCE: &'static str = "auto";

    /// Returns the translation targets that should be used given the
    /// detected source language. Only enabled targets are returned.
    ///
    /// Two rules, in order. A target claims the text when its source is
    /// `auto` or names the detected language; and of the targets that
    /// claim it, the ones the text is not already written in are the
    /// answer — the rule behind 自动匹配.
    ///
    /// [`text`] is what the user typed, and it only matters when detection
    /// came back empty. Detectors legitimately refuse on short input —
    /// Apple's identifier will not commit to "Hello world" — and with the
    /// shipped `auto` sources claiming every target, "no detection" used to
    /// mean "translate English into English". The script the text is
    /// written in is the weaker signal that covers that gap: it cannot name
    /// a language, but it is enough to say which targets the text is
    /// plainly *not* asking for.
    ///
    /// Detection is a hint throughout, never a gate. A misdetection (or a
    /// language the user simply has no target configured for) must degrade
    /// to "translate with the configured targets", never to "translate
    /// nothing", so every rule hands back what it was given rather than
    /// nothing at all.
    pub fn filter_active(
        targets: &[Self],
        detected_language: Option<&str>,
        text: Option<&str>,
    ) -> Vec<Self> {
        let enabled = || targets.iter().filter(|t| t.enabled).cloned();

        let matched = enabled()
            .filter(|t| {
                t.source == Self::AUTO_SOURCE || detected_language.is_none_or(|dl| t.source == dl)
            })
            .collect::<Vec<_>>();

        let matched = if matched.is_empty() {
            enabled().collect::<Vec<_>>()
        } else {
            matched
        };

        // Text already in one of the targets is asking for one of the
        // others: with 中文 and English both configured, Chinese input wants
        // English. Sources are `auto` in the shipped configuration, so this,
        // not the source match above, is what 自动匹配 routes on — and the
        // main window, which translates into one language at a time, takes
        // the first target left standing here.
        let routed = match (detected_language, text.and_then(Script::of_text)) {
            (Some(detected), _) => matched
                .iter()
                .filter(|t| t.target != detected)
                .cloned()
                .collect::<Vec<_>>(),
            // Nothing was detected: fall back to the script. Latin text
            // routes away from English without anyone having to prove it is
            // English, and 中文 away from 中文.
            (None, Some(script)) => matched
                .iter()
                .filter(|t| Script::of_language(&t.target) != script)
                .cloned()
                .collect::<Vec<_>>(),
            // No name and no letters to read: everything stands.
            (None, None) => return matched,
        };

        // Unless there is nowhere else to route to: a lone 中文 target still
        // translates 中文, because refusing to translate is worse. Latin
        // input against an all-Latin configuration lands here too, and gets
        // the same answer it did before the script rule existed.
        if routed.is_empty() {
            matched
        } else {
            routed
        }
    }
}

/// A writing system — what [`TranslationTarget::filter_active`] routes on
/// when detection declines to name a language.
///
/// Only the scripts the curated language list actually uses are named.
/// Everything else, Latin included, is [`Script::Latin`]: unnamed scripts
/// never equal a target's script, so they leave every target standing.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Script {
    Arabic,
    Bengali,
    Cyrillic,
    Devanagari,
    Gujarati,
    Gurmukhi,
    Han,
    Hangul,
    Kana,
    Latin,
    Malayalam,
    Tamil,
    Telugu,
    Thai,
}

impl Script {
    /// Every variant, in declaration order, so `script as usize` indexes it.
    const ALL: [Self; 14] = [
        Self::Arabic,
        Self::Bengali,
        Self::Cyrillic,
        Self::Devanagari,
        Self::Gujarati,
        Self::Gurmukhi,
        Self::Han,
        Self::Hangul,
        Self::Kana,
        Self::Latin,
        Self::Malayalam,
        Self::Tamil,
        Self::Telugu,
        Self::Thai,
    ];

    /// The script `text` is written in: the one most of its letters belong
    /// to. Any kana at all settles it as Japanese, which writes kanji and
    /// kana together and would otherwise read as Han. `None` when the text
    /// holds no letter this can place — digits, punctuation, emoji.
    fn of_text(text: &str) -> Option<Self> {
        let mut counts = [0usize; Self::ALL.len()];
        for ch in text.chars() {
            if let Some(script) = Self::of_char(ch) {
                counts[script as usize] += 1;
            }
        }

        if counts[Self::Kana as usize] > 0 {
            return Some(Self::Kana);
        }

        Self::ALL
            .into_iter()
            .zip(counts)
            .filter(|(_, count)| *count > 0)
            // A tie goes to the other script: Latin fragments turn up inside
            // every other writing system — brand names, code, units — and
            // "这是 Rust 写的" is Chinese with a Latin word in it.
            .max_by_key(|(script, count)| (*count, *script != Self::Latin))
            .map(|(script, _)| script)
    }

    /// The script a single character belongs to, or `None` for anything
    /// that carries no script signal.
    fn of_char(ch: char) -> Option<Self> {
        if !ch.is_alphabetic() {
            return None;
        }
        Some(match ch as u32 {
            0x0041..=0x005A | 0x0061..=0x007A | 0x00C0..=0x024F => Self::Latin,
            0x0400..=0x052F => Self::Cyrillic,
            0x0600..=0x06FF | 0x0750..=0x077F | 0xFB50..=0xFDFF | 0xFE70..=0xFEFF => Self::Arabic,
            0x0900..=0x097F => Self::Devanagari,
            0x0980..=0x09FF => Self::Bengali,
            0x0A00..=0x0A7F => Self::Gurmukhi,
            0x0A80..=0x0AFF => Self::Gujarati,
            0x0B80..=0x0BFF => Self::Tamil,
            0x0C00..=0x0C7F => Self::Telugu,
            0x0D00..=0x0D7F => Self::Malayalam,
            0x0E00..=0x0E7F => Self::Thai,
            0x1100..=0x11FF | 0x3130..=0x318F | 0xAC00..=0xD7AF => Self::Hangul,
            0x3040..=0x30FF | 0x31F0..=0x31FF | 0xFF66..=0xFF9D => Self::Kana,
            0x3400..=0x4DBF | 0x4E00..=0x9FFF | 0xF900..=0xFAFF | 0x20000..=0x2FA1F => Self::Han,
            _ => return None,
        })
    }

    /// The script a language is normally written in. Both Chinese variants
    /// are Han: telling 简 from 繁 needs the characters, not the script, and
    /// that is a job for detection rather than for this fallback.
    fn of_language(language: &str) -> Self {
        let base = language
            .split(['-', '_'])
            .next()
            .unwrap_or(language)
            .to_ascii_lowercase();
        match base.as_str() {
            "ar" | "fa" | "ur" => Self::Arabic,
            "bn" => Self::Bengali,
            "ru" | "uk" => Self::Cyrillic,
            "hi" | "mr" => Self::Devanagari,
            "gu" => Self::Gujarati,
            "pa" => Self::Gurmukhi,
            "zh" => Self::Han,
            "ko" => Self::Hangul,
            "ja" => Self::Kana,
            "ml" => Self::Malayalam,
            "ta" => Self::Tamil,
            "te" => Self::Telugu,
            "th" => Self::Thai,
            _ => Self::Latin,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn filter_auto_source_targets() {
        let targets = vec![TranslationTarget {
            source: TranslationTarget::AUTO_SOURCE.into(),
            target: "zh-Hans".into(),
            enabled: true,
        }];

        let active = TranslationTarget::filter_active(&targets, Some("ja"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    #[test]
    fn filter_auto_detect_matches() {
        let targets = vec![TranslationTarget {
            source: "en".into(),
            target: "zh-Hans".into(),
            enabled: true,
        }];

        let active = TranslationTarget::filter_active(&targets, Some("en"), None);
        assert_eq!(active.len(), 1);
    }

    #[test]
    fn filter_no_match_falls_back_to_enabled_targets() {
        let targets = vec![TranslationTarget {
            source: "en".into(),
            target: "zh-Hans".into(),
            enabled: true,
        }];

        // Nothing matches "ja", but returning nothing would mean the user
        // gets no translation at all. Fall back to the configured targets.
        let active = TranslationTarget::filter_active(&targets, Some("ja"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    #[test]
    fn filter_misdetection_still_translates() {
        // Regression: NLLanguageRecognizer reports "ca" for the text "hi".
        // A bogus detection must not silently disable every target.
        let targets = vec![
            TranslationTarget {
                source: "en".into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: "ja".into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
        ];

        let active = TranslationTarget::filter_active(&targets, Some("ca"), None);
        assert_eq!(active.len(), 2);
    }

    #[test]
    fn filter_no_match_still_excludes_disabled() {
        let targets = vec![
            TranslationTarget {
                source: "en".into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: "en".into(),
                target: "ja".into(),
                enabled: false,
            },
        ];

        // Fallback returns enabled targets only — never disabled ones.
        let active = TranslationTarget::filter_active(&targets, Some("ca"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    #[test]
    fn filter_auto_detect_no_detected_language() {
        let targets = vec![TranslationTarget {
            source: "en".into(),
            target: "zh-Hans".into(),
            enabled: true,
        }];

        let active = TranslationTarget::filter_active(&targets, None, None);
        assert_eq!(active.len(), 1);
    }

    #[test]
    fn filter_disabled_target_skipped() {
        let targets = vec![TranslationTarget {
            source: TranslationTarget::AUTO_SOURCE.into(),
            target: "zh-Hans".into(),
            enabled: false,
        }];

        let active = TranslationTarget::filter_active(&targets, Some("en"), None);
        assert_eq!(active.len(), 0);
    }

    #[test]
    fn filter_empty_targets() {
        let active = TranslationTarget::filter_active(&[], Some("en"), None);
        assert!(active.is_empty());
    }

    #[test]
    fn filter_mixed_strategies() {
        let targets = vec![
            TranslationTarget {
                source: "en".into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: "ja".into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "ja".into(),
                enabled: true,
            },
        ];

        // Only "en" should match concrete sources, plus auto source.
        let active = TranslationTarget::filter_active(&targets, Some("en"), None);
        assert_eq!(active.len(), 2);
        assert!(active.iter().any(|t| t.target == "zh-Hans"));
        assert!(active.iter().any(|t| t.target == "ja"));
    }

    #[test]
    fn filter_mixed_disabled_excluded() {
        let targets = vec![
            TranslationTarget {
                source: "en".into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: "en".into(),
                target: "ja".into(),
                enabled: false,
            },
        ];

        // Only enabled targets should be returned.
        let active = TranslationTarget::filter_active(&targets, Some("en"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    #[test]
    fn filter_routes_away_from_the_detected_language() {
        // The shipped configuration: both targets take anything, so the
        // source match alone claims both and 自动匹配 would translate 中文
        // into 中文. What the text is already in decides.
        let targets = vec![
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "en".into(),
                enabled: true,
            },
        ];

        let active = TranslationTarget::filter_active(&targets, Some("zh-Hans"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "en");

        let active = TranslationTarget::filter_active(&targets, Some("en"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");

        // A third language claims neither, and gets both.
        let active = TranslationTarget::filter_active(&targets, Some("ja"), None);
        assert_eq!(active.len(), 2);
    }

    #[test]
    fn filter_keeps_the_only_target_it_could_route_to() {
        let targets = vec![TranslationTarget {
            source: TranslationTarget::AUTO_SOURCE.into(),
            target: "zh-Hans".into(),
            enabled: true,
        }];

        // Nowhere else to go: 中文 into 中文 beats no translation at all.
        let active = TranslationTarget::filter_active(&targets, Some("zh-Hans"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    #[test]
    fn filter_keeps_the_other_script() {
        let targets = vec![TranslationTarget {
            source: TranslationTarget::AUTO_SOURCE.into(),
            target: "zh-Hans".into(),
            enabled: true,
        }];

        // 繁 into 简 is a translation the user asked for, not a no-op.
        let active = TranslationTarget::filter_active(&targets, Some("zh-Hant"), None);
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }

    /// The shipped configuration, and the case that started this: detection
    /// refuses on "Hello world", and without the script rule 自动匹配 offers
    /// 自动检测 → 英语 for English input.
    #[test]
    fn filter_routes_by_script_when_nothing_was_detected() {
        let targets = vec![
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "en".into(),
                enabled: true,
            },
        ];

        for text in ["Hello world", "hi", "ok"] {
            let active = TranslationTarget::filter_active(&targets, None, Some(text));
            assert_eq!(active.len(), 1, "{text}");
            assert_eq!(active[0].target, "zh-Hans", "{text}");
        }

        let active = TranslationTarget::filter_active(&targets, None, Some("你好"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "en");
    }

    #[test]
    fn filter_script_rule_keeps_a_different_script() {
        let targets = vec![
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "en".into(),
                enabled: true,
            },
        ];

        // Japanese claims neither target, so both stand — the same answer a
        // successful detection of "ja" gives.
        let active = TranslationTarget::filter_active(&targets, None, Some("こんにちは"));
        assert_eq!(active.len(), 2);
    }

    #[test]
    fn filter_script_rule_never_empties_an_all_latin_config() {
        let targets = vec![
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "en".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "fr".into(),
                enabled: true,
            },
        ];

        // Both targets share the text's script: the script cannot choose
        // between them, so it must not drop both.
        let active = TranslationTarget::filter_active(&targets, None, Some("Hello world"));
        assert_eq!(active.len(), 2);
    }

    #[test]
    fn filter_script_rule_yields_to_a_detected_language() {
        let targets = vec![
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "en".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "fr".into(),
                enabled: true,
            },
        ];

        // Detection named the language; the script's coarser reading (drop
        // every Latin target) must not override it.
        let active = TranslationTarget::filter_active(&targets, Some("fr"), Some("Bonjour"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "en");
    }

    #[test]
    fn filter_script_rule_ignores_text_without_letters() {
        let targets = vec![
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "zh-Hans".into(),
                enabled: true,
            },
            TranslationTarget {
                source: TranslationTarget::AUTO_SOURCE.into(),
                target: "en".into(),
                enabled: true,
            },
        ];

        let active = TranslationTarget::filter_active(&targets, None, Some("2026 :) 🙂"));
        assert_eq!(active.len(), 2);
    }

    #[test]
    fn script_of_text_reads_the_dominant_script() {
        assert_eq!(Script::of_text("Hello world"), Some(Script::Latin));
        assert_eq!(Script::of_text("你好"), Some(Script::Han));
        assert_eq!(Script::of_text("Привет"), Some(Script::Cyrillic));
        assert_eq!(Script::of_text("안녕하세요"), Some(Script::Hangul));
        assert_eq!(Script::of_text("สวัสดี"), Some(Script::Thai));
        assert_eq!(Script::of_text("नमस्ते"), Some(Script::Devanagari));
        assert_eq!(Script::of_text("مرحبا"), Some(Script::Arabic));
        assert_eq!(Script::of_text("123 …"), None);

        // Japanese writes kanji and kana together; a single kana settles it.
        assert_eq!(Script::of_text("日本語"), Some(Script::Han));
        assert_eq!(Script::of_text("日本語です"), Some(Script::Kana));

        // A stray Latin word does not make a Chinese sentence English.
        assert_eq!(Script::of_text("这是 Rust 写的"), Some(Script::Han));
    }

    #[test]
    fn script_of_language_covers_the_curated_list() {
        assert_eq!(Script::of_language("zh-Hans"), Script::Han);
        assert_eq!(Script::of_language("zh-Hant"), Script::Han);
        assert_eq!(Script::of_language("ja"), Script::Kana);
        assert_eq!(Script::of_language("ko"), Script::Hangul);
        assert_eq!(Script::of_language("ru"), Script::Cyrillic);
        assert_eq!(Script::of_language("ur"), Script::Arabic);
        assert_eq!(Script::of_language("hi"), Script::Devanagari);
        assert_eq!(Script::of_language("en"), Script::Latin);
        assert_eq!(Script::of_language("vi"), Script::Latin);
        // An unknown code is Latin rather than a panic.
        assert_eq!(Script::of_language("xx-YY"), Script::Latin);
    }
}
