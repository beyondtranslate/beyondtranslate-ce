use serde::{Deserialize, Serialize};

use super::LanguageCandidate;

/// What one detector made of one piece of text.
///
/// [`detected_language`](Self::detected_language) is the committed answer and
/// may be absent: a detector that will not commit says so rather than
/// guessing. [`candidates`](Self::candidates) is the ranked reading
/// underneath it, which detectors that can produce one fill in — it is what
/// [`resolve_language`](Self::resolve_language) reads to decide the answer
/// with the user's own languages in hand.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct TextDetection {
    pub detected_language: Option<String>,
    pub text: String,
    /// Ranked most-confident first. Empty from detectors that only ever
    /// return a single answer, which is then taken at face value.
    #[serde(default)]
    pub candidates: Vec<LanguageCandidate>,
}

impl TextDetection {
    /// A candidate this confident is the answer, whoever the user is.
    pub const CONFIDENT: f64 = 0.5;

    /// The least a candidate may score and still be picked out of the ranked
    /// list because the user works in that language.
    pub const PLAUSIBLE: f64 = 0.15;

    /// The language this detection should be read as, given the languages the
    /// user actually translates between.
    ///
    /// Three rules, in order, and the order is the whole design:
    ///
    /// 1. A candidate at or above [`CONFIDENT`](Self::CONFIDENT) is taken as
    ///    it stands, *whether or not the user works in it*. Without this the
    ///    user's own languages would swallow every other one — German text
    ///    would come back as English simply because English is configured.
    /// 2. Otherwise the ranked list is walked for the first candidate the
    ///    user works in that still clears [`PLAUSIBLE`](Self::PLAUSIBLE).
    ///    Short input is where detectors spread their confidence thin
    ///    ("hi" reads as de 0.42 / en 0.30), and the user's languages are the
    ///    tiebreak that costs nothing when it is wrong — the text was going
    ///    to be routed by script anyway.
    /// 3. Otherwise nothing. "Unknown" is a real answer and downstream knows
    ///    what to do with it; a fabricated language silently routes the
    ///    translation somewhere the user did not ask for.
    ///
    /// A detector that gave no candidates is taken at its word — there is
    /// nothing here to decide between.
    pub fn resolve_language(&self, user_languages: &[String]) -> Option<String> {
        if self.candidates.is_empty() {
            return self.detected_language.clone();
        }

        let ranked = {
            let mut ranked = self.candidates.iter().collect::<Vec<_>>();
            ranked.sort_by(|a, b| b.confidence.total_cmp(&a.confidence));
            ranked
        };

        if let Some(top) = ranked.first().filter(|c| c.confidence >= Self::CONFIDENT) {
            return Some(top.language.clone());
        }

        ranked
            .into_iter()
            .find(|candidate| {
                candidate.confidence >= Self::PLAUSIBLE
                    && user_languages
                        .iter()
                        .any(|language| same_language(language, &candidate.language))
            })
            .map(|candidate| candidate.language.clone())
    }
}

/// Whether two codes name the same language, ignoring the script or region
/// tag. `zh-Hans` and `zh-Hant` are one language to a user who configured
/// either, and the candidate's own spelling is the more precise of the two.
fn same_language(a: &str, b: &str) -> bool {
    fn base(code: &str) -> &str {
        code.split(['-', '_']).next().unwrap_or(code)
    }
    base(a).eq_ignore_ascii_case(base(b))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn detection(candidates: &[(&str, f64)]) -> TextDetection {
        TextDetection {
            // What the provider would have said on its own — every rule here
            // is free to overrule it.
            detected_language: candidates.first().map(|(code, _)| (*code).to_owned()),
            text: "…".to_owned(),
            candidates: candidates
                .iter()
                .map(|(language, confidence)| LanguageCandidate {
                    language: (*language).to_owned(),
                    confidence: *confidence,
                })
                .collect(),
        }
    }

    fn user(languages: &[&str]) -> Vec<String> {
        languages.iter().map(|l| (*l).to_owned()).collect()
    }

    #[test]
    fn a_confident_candidate_wins_even_outside_the_users_languages() {
        // Measured with NLLanguageRecognizer over the translatable set.
        let cases = [
            ("Bonjour", &[("fr", 0.85), ("en", 0.05)][..], "fr"),
            ("Guten Tag", &[("de", 0.99), ("en", 0.00)][..], "de"),
            ("Hola", &[("es", 0.94), ("en", 0.02)][..], "es"),
            ("Hello world", &[("en", 0.72), ("pt", 0.08)][..], "en"),
            ("Привет", &[("ru", 1.00)][..], "ru"),
        ];

        for (text, candidates, expected) in cases {
            let resolved = detection(candidates).resolve_language(&user(&["en", "zh-Hans"]));
            assert_eq!(resolved.as_deref(), Some(expected), "{text}");
        }
    }

    #[test]
    fn an_unsure_reading_falls_to_the_users_languages() {
        // Short input spreads the model thin and its top pick is noise; the
        // languages the user works in are the tiebreak.
        let cases = [
            ("hi", &[("de", 0.42), ("en", 0.30), ("es", 0.14)][..]),
            ("bye", &[("fr", 0.32), ("en", 0.29), ("it", 0.19)][..]),
            ("apple", &[("en", 0.44), ("fr", 0.20)][..]),
            ("ok", &[("en", 0.31), ("it", 0.23)][..]),
        ];

        for (text, candidates) in cases {
            let resolved = detection(candidates).resolve_language(&user(&["en", "zh-Hans"]));
            assert_eq!(resolved.as_deref(), Some("en"), "{text}");
        }
    }

    #[test]
    fn nothing_plausible_is_answered_with_nothing() {
        // "Guten Tag" against a user who translates only 中文 ⇄ 日本語: the
        // top candidate is not confident enough to stand on its own and no
        // candidate is one of theirs. Saying "Japanese" here would route the
        // translation somewhere they never asked for.
        let resolved = detection(&[("de", 0.42), ("en", 0.30), ("es", 0.14)])
            .resolve_language(&user(&["zh-Hans", "ja"]));
        assert_eq!(resolved, None);
    }

    #[test]
    fn a_users_language_still_has_to_clear_the_floor() {
        // en at 0.00 is the model saying "certainly not English".
        let resolved =
            detection(&[("de", 0.49), ("en", 0.00)]).resolve_language(&user(&["en", "zh-Hans"]));
        assert_eq!(resolved, None);
    }

    #[test]
    fn han_variants_count_as_the_users_language() {
        // The user configured 简体; the reading says 繁體. Same language, and
        // the candidate's own spelling is the precise one.
        let resolved =
            detection(&[("zh-Hant", 0.31), ("ja", 0.20)]).resolve_language(&user(&["zh-Hans"]));
        assert_eq!(resolved.as_deref(), Some("zh-Hant"));
    }

    #[test]
    fn a_detector_without_candidates_is_taken_at_its_word() {
        // Baidu, Tencent and Youdao answer with a language and nothing else.
        let detection = TextDetection {
            detected_language: Some("en".to_owned()),
            text: "hi".to_owned(),
            candidates: Vec::new(),
        };
        assert_eq!(
            detection
                .resolve_language(&user(&["zh-Hans", "ja"]))
                .as_deref(),
            Some("en")
        );
    }

    #[test]
    fn ranking_is_by_confidence_not_by_arrival() {
        let resolved = detection(&[("en", 0.30), ("de", 0.42)]).resolve_language(&user(&["en"]));
        assert_eq!(resolved.as_deref(), Some("en"));

        let resolved = detection(&[("en", 0.30), ("de", 0.62)]).resolve_language(&user(&["en"]));
        assert_eq!(resolved.as_deref(), Some("de"));
    }

    #[test]
    fn no_candidates_and_no_answer_stays_unknown() {
        let detection = TextDetection {
            detected_language: None,
            text: "🙂".to_owned(),
            candidates: Vec::new(),
        };
        assert_eq!(detection.resolve_language(&user(&["en"])), None);
    }

    #[test]
    fn the_bridge_wire_shape_round_trips() {
        // Exactly what SystemTranslationServiceBridge posts back: a
        // committed reading, and one that only left candidates behind.
        let json = r#"[
            {
              "detected_language": "en",
              "text": "Hello world",
              "candidates": [
                {"language": "en", "confidence": 0.72},
                {"language": "pt", "confidence": 0.08}
              ]
            },
            {
              "text": "hi",
              "candidates": [
                {"language": "de", "confidence": 0.42},
                {"language": "en", "confidence": 0.30}
              ]
            }
        ]"#;

        let detections: Vec<TextDetection> =
            serde_json::from_str(json).expect("bridge payload should parse");

        assert_eq!(detections[0].detected_language.as_deref(), Some("en"));
        assert_eq!(detections[1].detected_language, None);
        assert_eq!(detections[1].candidates.len(), 2);
        assert_eq!(
            detections[1]
                .resolve_language(&user(&["en", "zh-Hans"]))
                .as_deref(),
            Some("en")
        );
    }

    #[test]
    fn a_provider_that_never_learned_about_candidates_still_parses() {
        // The field is new; a payload written before it existed must not
        // fail to decode.
        let detection: TextDetection =
            serde_json::from_str(r#"{"detected_language": "ja", "text": "こんにちは"}"#)
                .expect("legacy payload should parse");
        assert!(detection.candidates.is_empty());
        assert_eq!(detection.detected_language.as_deref(), Some("ja"));
    }
}
