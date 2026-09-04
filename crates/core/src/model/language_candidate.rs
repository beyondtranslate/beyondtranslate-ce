use serde::{Deserialize, Serialize};

/// One language a detector considered for a piece of text, with how sure it
/// was.
///
/// The confidence is *absolute*: it must be measured against the detector's
/// full candidate set, never renormalized against a narrower one. Narrowing
/// the set before measuring is what turns "Bonjour" into English at 1.00 —
/// see [`TextDetection::resolve_language`](super::TextDetection::resolve_language),
/// which compares these against fixed floors and would be meaningless
/// otherwise.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct LanguageCandidate {
    pub language: String,
    pub confidence: f64,
}
