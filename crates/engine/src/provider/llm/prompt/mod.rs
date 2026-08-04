// ── Prompt Templates ─────────────────────────────────────────────────────────
//
// Centralised prompt templates for LLM-based translation and dictionary
// operations.

/// Build a system prompt for word-level translation.
pub fn translate_word_system_prompt(source_lang: &str, target_lang: &str) -> String {
    format!(
        "You are a professional translator and lexicographer. \
         Translate the following word from {source} to {target}. \
         Provide the translation in JSON format with the following fields:\n\
         - \"translations\": array of {{ \"text\": string, \"part_of_speech\": string or null, \"explanation\": string or null }}\n\
         - \"pronunciation\": string or null\n\n\
         Only return valid JSON, no other text.",
        source = source_lang,
        target = target_lang,
    )
}

/// Build a user prompt for word translation.
pub fn translate_word_user_prompt(word: &str) -> String {
    format!("Translate the word: \"{word}\"")
}

/// One glossary rule the model must honour, flattened from whatever the
/// caller stores so this crate stays independent of glossary storage.
pub struct GlossaryTerm {
    pub term: String,
    pub translation: String,
    pub forbidden: Vec<String>,
}

/// Render glossary rules as a prompt section, or `None` when there is
/// nothing to constrain.
///
/// Terms are deduplicated because a term occurring five times in the source
/// still only needs stating once.
pub fn glossary_constraints(terms: &[GlossaryTerm]) -> Option<String> {
    let mut seen = std::collections::HashSet::new();
    let mut lines = Vec::new();
    for term in terms {
        if !seen.insert(term.term.as_str()) {
            continue;
        }
        let mut line = format!(
            "- \"{}\" MUST be translated as \"{}\"",
            term.term, term.translation
        );
        if !term.forbidden.is_empty() {
            line.push_str(&format!(". Never use: {}", term.forbidden.join(", ")));
        }
        lines.push(line);
    }
    if lines.is_empty() {
        return None;
    }
    Some(format!(
        "Terminology constraints — these take priority over your own word choice \
         and over any style instruction above:\n{}",
        lines.join("\n")
    ))
}

/// Build a system prompt for sentence/paragraph translation.
pub fn translate_text_system_prompt(
    source_lang: &str,
    target_lang: &str,
    style: Option<&str>,
    glossary: &[GlossaryTerm],
) -> String {
    let style_hint = match style {
        Some(s) => format!(
            " Use a {s} style. The output should feel natural and native in {target}.",
            s = s,
            target = target_lang
        ),
        None => format!(
            " The output should feel natural and native in {target}.",
            target = target_lang
        ),
    };
    let glossary_hint = glossary_constraints(glossary)
        .map(|block| format!("\n\n{block}"))
        .unwrap_or_default();

    format!(
        "You are a professional translator. Translate the following text from {source} to {target}. \
         Preserve the original formatting, tone, and meaning. \
         For proper nouns, technical terms, and brand names, keep them in their original form unless \
         a well-established translation exists.{style_hint}{glossary_hint}\n\n\
         Return the translation in JSON format: \
         {{ \"translations\": [{{ \"text\": string }}] }}\n\
         Only return valid JSON, no other text.",
        source = source_lang,
        target = target_lang,
        style_hint = style_hint,
        glossary_hint = glossary_hint,
    )
}

/// Build a user prompt for text translation.
pub fn translate_text_user_prompt(text: &str) -> String {
    format!("Translate the following text:\n\n{text}")
}

/// Build a system prompt for dictionary lookup with rich details.
pub fn dictionary_lookup_system_prompt(source_lang: &str, target_lang: &str) -> String {
    format!(
        "You are a comprehensive dictionary and thesaurus. \
         For the given word in {source}, provide a detailed entry in {target}. \
         Return the result in JSON format with these fields:\n\
         - \"word\": string (the original word)\n\
         - \"pronunciations\": array of {{ \"type\": string (e.g. \"UK\", \"US\"), \"phonetic\": string, \"audio_url\": string or null }}\n\
         - \"definitions\": array of {{ \"type\": string (e.g. \"noun\", \"verb\"), \"meaning\": string, \"examples\": array of strings }}\n\
         - \"synonyms\": array of strings\n\
         - \"antonyms\": array of strings\n\
         - \"phrases\": array of {{ \"text\": string, \"translation\": string }}\n\
         - \"etymology\": string or null\n\
         - \"usage_notes\": string or null\n\n\
         Only return valid JSON, no other text.",
        source = source_lang,
        target = target_lang,
    )
}

/// Build a user prompt for dictionary lookup.
pub fn dictionary_lookup_user_prompt(word: &str) -> String {
    format!("Define and explain the word: \"{word}\"")
}

/// Build a system prompt for translation polishing/rewriting.
pub fn polish_translation_system_prompt(style: &str) -> String {
    format!(
        "You are a professional editor. Rewrite the following translation to be more {style}. \
         Preserve the original meaning but improve the expression, fluency, and naturalness.\n\n\
         Return the polished text as plain text, no JSON wrapper, no explanations."
    )
}

/// Build a system prompt for explaining why a translation was chosen.
pub fn explain_translation_system_prompt() -> String {
    "You are a translation expert. Explain why the given translation was chosen for the source text. \
     Discuss: word choice, grammatical structure adaptation, cultural/localisation considerations, \
     and any trade-offs made. \
     Keep the explanation concise (2-3 paragraphs) and helpful for language learners."
    .to_string()
}

/// Build a system prompt for providing alternative translations.
pub fn alternative_translations_system_prompt(count: u32, style: Option<&str>) -> String {
    let style_hint = style
        .map(|s| format!(" in a {s} style"))
        .unwrap_or_default();
    format!(
        "You are a professional translator. Provide {count} alternative translations \
         for the given source text{style_hint}. Each alternative should be meaningfully different \
         while preserving the original meaning. Explain briefly why each alternative might be preferred.\n\n\
         Return JSON: {{ \"alternatives\": [{{ \"text\": string, \"why\": string }}] }}"
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn term(term: &str, translation: &str, forbidden: &[&str]) -> GlossaryTerm {
        GlossaryTerm {
            term: term.to_owned(),
            translation: translation.to_owned(),
            forbidden: forbidden.iter().map(|value| (*value).to_owned()).collect(),
        }
    }

    #[test]
    fn no_terms_produce_no_constraint_block() {
        assert!(glossary_constraints(&[]).is_none());
    }

    #[test]
    fn constraints_list_translations_and_forbidden_alternatives() {
        let block = glossary_constraints(&[
            term("token", "词元", &["标记", "令牌"]),
            term("embedding", "嵌入", &[]),
        ])
        .expect("expected a constraint block");

        assert!(block.contains("\"token\" MUST be translated as \"词元\""));
        assert!(block.contains("Never use: 标记, 令牌"));
        assert!(block.contains("\"embedding\" MUST be translated as \"嵌入\""));
        // An entry without forbidden translations should not trail an empty
        // "Never use:" clause.
        assert_eq!(block.matches("Never use").count(), 1);
    }

    #[test]
    fn a_term_matched_repeatedly_is_only_stated_once() {
        let block = glossary_constraints(&[term("token", "词元", &[]), term("token", "词元", &[])])
            .expect("expected a constraint block");

        assert_eq!(block.matches("\"token\"").count(), 1);
    }

    #[test]
    fn system_prompt_carries_the_constraints_and_still_asks_for_json() {
        let prompt = translate_text_system_prompt("en", "zh", None, &[term("token", "词元", &[])]);
        assert!(prompt.contains("\"token\" MUST be translated as \"词元\""));
        assert!(prompt.contains("Only return valid JSON"));
    }

    #[test]
    fn system_prompt_without_glossary_is_unchanged() {
        let prompt = translate_text_system_prompt("en", "zh", None, &[]);
        assert!(!prompt.contains("Terminology constraints"));
    }
}
