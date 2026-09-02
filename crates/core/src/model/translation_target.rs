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
    /// Detection is a hint throughout, never a gate. A misdetection (or a
    /// language the user simply has no target configured for) must degrade
    /// to "translate with the configured targets", never to "translate
    /// nothing", so either rule hands back what it was given rather than
    /// nothing at all.
    pub fn filter_active(targets: &[Self], detected_language: Option<&str>) -> Vec<Self> {
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

        let Some(detected) = detected_language else {
            return matched;
        };

        // Text already in one of the targets is asking for one of the
        // others: with 中文 and English both configured, Chinese input wants
        // English. Sources are `auto` in the shipped configuration, so this,
        // not the source match above, is what 自动匹配 routes on — and the
        // main window, which translates into one language at a time, takes
        // the first target left standing here.
        let routed = matched
            .iter()
            .filter(|t| t.target != detected)
            .cloned()
            .collect::<Vec<_>>();

        // Unless there is nowhere else to route to: a lone 中文 target still
        // translates 中文, because refusing to translate is worse.
        if routed.is_empty() {
            matched
        } else {
            routed
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

        let active = TranslationTarget::filter_active(&targets, Some("zh-Hans"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "en");

        let active = TranslationTarget::filter_active(&targets, Some("en"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");

        // A third language claims neither, and gets both.
        let active = TranslationTarget::filter_active(&targets, Some("ja"));
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
        let active = TranslationTarget::filter_active(&targets, Some("zh-Hans"));
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
        let active = TranslationTarget::filter_active(&targets, Some("zh-Hant"));
        assert_eq!(active.len(), 1);
        assert_eq!(active[0].target, "zh-Hans");
    }
}
