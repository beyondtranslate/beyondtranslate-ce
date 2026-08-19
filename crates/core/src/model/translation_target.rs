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
    /// Detection is treated as a hint. A misdetection (or a language the
    /// user simply has no target configured for) must degrade to "translate
    /// with the configured targets", never to "translate nothing" — so when
    /// the detected language matches no target at all, every enabled target
    /// is returned.
    pub fn filter_active(targets: &[Self], detected_language: Option<&str>) -> Vec<Self> {
        let enabled = || targets.iter().filter(|t| t.enabled).cloned();

        let matched = enabled()
            .filter(|t| {
                t.source == Self::AUTO_SOURCE || detected_language.is_none_or(|dl| t.source == dl)
            })
            .collect::<Vec<_>>();

        if matched.is_empty() {
            enabled().collect()
        } else {
            matched
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

        let active = TranslationTarget::filter_active(&targets, Some("ja"));
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

        let active = TranslationTarget::filter_active(&targets, Some("en"));
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
        let active = TranslationTarget::filter_active(&targets, Some("ja"));
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

        let active = TranslationTarget::filter_active(&targets, Some("ca"));
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
        let active = TranslationTarget::filter_active(&targets, Some("ca"));
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

        let active = TranslationTarget::filter_active(&targets, None);
        assert_eq!(active.len(), 1);
    }

    #[test]
    fn filter_disabled_target_skipped() {
        let targets = vec![TranslationTarget {
            source: TranslationTarget::AUTO_SOURCE.into(),
            target: "zh-Hans".into(),
            enabled: false,
        }];

        let active = TranslationTarget::filter_active(&targets, Some("en"));
        assert_eq!(active.len(), 0);
    }

    #[test]
    fn filter_empty_targets() {
        let active = TranslationTarget::filter_active(&[], Some("en"));
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
        let active = TranslationTarget::filter_active(&targets, Some("en"));
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
        let active = TranslationTarget::filter_active(&targets, Some("en"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }
}
