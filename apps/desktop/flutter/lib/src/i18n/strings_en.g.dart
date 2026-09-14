///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.en,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
  late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
  late final TranslationsMiniTranslatorEn mini_translator =
      TranslationsMiniTranslatorEn.internal(_root);
  late final TranslationsWorkbenchEn workbench =
      TranslationsWorkbenchEn.internal(_root);
  late final TranslationsSettingsEn settings =
      TranslationsSettingsEn.internal(_root);
}

// Path: common
class TranslationsCommonEn {
  TranslationsCommonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsCommonServiceNameEn service_name =
      TranslationsCommonServiceNameEn.internal(_root);
  late final TranslationsCommonUiEn ui = TranslationsCommonUiEn.internal(_root);
  late final TranslationsCommonLanguageEn language =
      TranslationsCommonLanguageEn.internal(_root);
  late final TranslationsCommonThemeModeEn theme_mode =
      TranslationsCommonThemeModeEn.internal(_root);
  late final TranslationsCommonThemeStyleEn theme_style =
      TranslationsCommonThemeStyleEn.internal(_root);
  late final TranslationsCommonProviderEn provider =
      TranslationsCommonProviderEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
  TranslationsAppEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAppTrayEn tray = TranslationsAppTrayEn.internal(_root);
}

// Path: mini_translator
class TranslationsMiniTranslatorEn {
  TranslationsMiniTranslatorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorLimitedBannerEn limited_banner =
      TranslationsMiniTranslatorLimitedBannerEn.internal(_root);
  late final TranslationsMiniTranslatorInputEn input =
      TranslationsMiniTranslatorInputEn.internal(_root);
  late final TranslationsMiniTranslatorToolbarEn toolbar =
      TranslationsMiniTranslatorToolbarEn.internal(_root);
  late final TranslationsMiniTranslatorButtonEn button =
      TranslationsMiniTranslatorButtonEn.internal(_root);
  late final TranslationsMiniTranslatorLanguageEn language =
      TranslationsMiniTranslatorLanguageEn.internal(_root);
  late final TranslationsMiniTranslatorMessageEn message =
      TranslationsMiniTranslatorMessageEn.internal(_root);
  late final TranslationsMiniTranslatorResultEn result =
      TranslationsMiniTranslatorResultEn.internal(_root);
}

// Path: workbench
class TranslationsWorkbenchEn {
  TranslationsWorkbenchEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Workspace'
  String get workspace => 'Workspace';

  /// en: 'Translate'
  String get translate => 'Translate';

  /// en: 'History'
  String get history => 'History';

  late final TranslationsWorkbenchHistoryPageEn history_page =
      TranslationsWorkbenchHistoryPageEn.internal(_root);

  /// en: 'Glossary'
  String get glossary => 'Glossary';

  /// en: 'Recent Languages'
  String get recent_languages => 'Recent Languages';

  /// en: 'Not configured'
  String get not_configured => 'Not configured';

  late final TranslationsWorkbenchSubtitleEn subtitle =
      TranslationsWorkbenchSubtitleEn.internal(_root);
  late final TranslationsWorkbenchPlaceholderEn placeholder =
      TranslationsWorkbenchPlaceholderEn.internal(_root);
  late final TranslationsWorkbenchGlossaryPageEn glossary_page =
      TranslationsWorkbenchGlossaryPageEn.internal(_root);
  late final TranslationsWorkbenchTranslationEn translation =
      TranslationsWorkbenchTranslationEn.internal(_root);
  late final TranslationsWorkbenchStatusEn status =
      TranslationsWorkbenchStatusEn.internal(_root);

  /// en: 'Up to date'
  String get version_latest => 'Up to date';

  /// en: 'Checking…'
  String get version_checking => 'Checking…';

  /// en: 'Check for updates'
  String get check_updates => 'Check for updates';
}

// Path: settings
class TranslationsSettingsEn {
  TranslationsSettingsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: '{} (Build {})'
  String get version => '{} (Build {})';

  late final TranslationsSettingsGeneralEn general =
      TranslationsSettingsGeneralEn.internal(_root);
  late final TranslationsSettingsAppearanceEn appearance =
      TranslationsSettingsAppearanceEn.internal(_root);
  late final TranslationsSettingsShortcutsEn shortcuts =
      TranslationsSettingsShortcutsEn.internal(_root);
  late final TranslationsSettingsAdvancedEn advanced =
      TranslationsSettingsAdvancedEn.internal(_root);
  late final TranslationsSettingsServicesEn services =
      TranslationsSettingsServicesEn.internal(_root);
  late final TranslationsSettingsProvidersEn providers =
      TranslationsSettingsProvidersEn.internal(_root);
  late final TranslationsSettingsLayoutEn layout =
      TranslationsSettingsLayoutEn.internal(_root);
  late final TranslationsSettingsAboutEn about =
      TranslationsSettingsAboutEn.internal(_root);
}

// Path: common.service_name
class TranslationsCommonServiceNameEn {
  TranslationsCommonServiceNameEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'General Translation API'
  String get baidu_fanyi_api => 'General Translation API';

  /// en: 'Caiyun Xiaoyi API'
  String get caiyun_platform => 'Caiyun Xiaoyi API';

  /// en: 'DeepL API / Translate text'
  String get deepl_api => 'DeepL API / Translate text';

  /// en: 'Cloud Translation - Basic'
  String get google_cloud => 'Cloud Translation - Basic';

  /// en: 'Yandex Translate API'
  String get yandex => 'Yandex Translate API';

  /// en: 'Microsoft Translator'
  String get microsoft_translator => 'Microsoft Translator';

  /// en: 'Alibaba Cloud Machine Translation'
  String get aliyun => 'Alibaba Cloud Machine Translation';

  /// en: 'Volcengine Machine Translation'
  String get volcengine => 'Volcengine Machine Translation';

  /// en: 'NiuTrans Translation API'
  String get niutrans => 'NiuTrans Translation API';

  /// en: 'Tencent Machine Translation (TMT)'
  String get tencent_cloud => 'Tencent Machine Translation (TMT)';

  /// en: 'Text Translation API'
  String get youdao_zhiyun_translation => 'Text Translation API';

  /// en: 'Text Translation API (dictionary results)'
  String get youdao_zhiyun_dictionary =>
      'Text Translation API (dictionary results)';

  /// en: 'General Text Recognition API'
  String get youdao_zhiyun_ocr => 'General Text Recognition API';

  /// en: 'Cloud Vision - Text Detection'
  String get google_cloud_ocr => 'Cloud Vision - Text Detection';

  /// en: 'General Print OCR'
  String get tencent_cloud_ocr => 'General Print OCR';

  /// en: 'Volcengine General OCR'
  String get volcengine_ocr => 'Volcengine General OCR';

  /// en: 'Alibaba Cloud General OCR'
  String get aliyun_ocr => 'Alibaba Cloud General OCR';

  /// en: 'Yandex Vision OCR'
  String get yandex_ocr => 'Yandex Vision OCR';
}

// Path: common.ui
class TranslationsCommonUiEn {
  TranslationsCommonUiEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsCommonUiButtonEn button =
      TranslationsCommonUiButtonEn.internal(_root);
  late final TranslationsCommonUiFeedbackEn feedback =
      TranslationsCommonUiFeedbackEn.internal(_root);
}

// Path: common.language
class TranslationsCommonLanguageEn {
  TranslationsCommonLanguageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Arabic'
  String get ar => 'Arabic';

  /// en: 'Bengali'
  String get bn => 'Bengali';

  /// en: 'German'
  String get de => 'German';

  /// en: 'English'
  String get en => 'English';

  /// en: 'Spanish'
  String get es => 'Spanish';

  /// en: 'Persian'
  String get fa => 'Persian';

  /// en: 'French'
  String get fr => 'French';

  /// en: 'Gujarati'
  String get gu => 'Gujarati';

  /// en: 'Hausa'
  String get ha => 'Hausa';

  /// en: 'Hindi'
  String get hi => 'Hindi';

  /// en: 'Indonesian'
  String get id => 'Indonesian';

  /// en: 'Italian'
  String get it => 'Italian';

  /// en: 'Japanese'
  String get ja => 'Japanese';

  /// en: 'Javanese'
  String get jv => 'Javanese';

  /// en: 'Korean'
  String get ko => 'Korean';

  /// en: 'Malayalam'
  String get ml => 'Malayalam';

  /// en: 'Marathi'
  String get mr => 'Marathi';

  /// en: 'Malay'
  String get ms => 'Malay';

  /// en: 'Dutch'
  String get nl => 'Dutch';

  /// en: 'Punjabi'
  String get pa => 'Punjabi';

  /// en: 'Polish'
  String get pl => 'Polish';

  /// en: 'Portuguese'
  String get pt => 'Portuguese';

  /// en: 'Romanian'
  String get ro => 'Romanian';

  /// en: 'Russian'
  String get ru => 'Russian';

  /// en: 'Swahili'
  String get sw => 'Swahili';

  /// en: 'Tamil'
  String get ta => 'Tamil';

  /// en: 'Telugu'
  String get te => 'Telugu';

  /// en: 'Thai'
  String get th => 'Thai';

  /// en: 'Turkish'
  String get tr => 'Turkish';

  /// en: 'Ukrainian'
  String get uk => 'Ukrainian';

  /// en: 'Urdu'
  String get ur => 'Urdu';

  /// en: 'Vietnamese'
  String get vi => 'Vietnamese';

  /// en: 'Yoruba'
  String get yo => 'Yoruba';

  /// en: 'Chinese (Simplified)'
  String get zh_hans => 'Chinese (Simplified)';

  /// en: 'Chinese (Traditional)'
  String get zh_hant => 'Chinese (Traditional)';
}

// Path: common.theme_mode
class TranslationsCommonThemeModeEn {
  TranslationsCommonThemeModeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Light'
  String get light => 'Light';

  /// en: 'Dark'
  String get dark => 'Dark';

  /// en: 'System'
  String get system => 'System';
}

// Path: common.theme_style
class TranslationsCommonThemeStyleEn {
  TranslationsCommonThemeStyleEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Studio'
  String get studio => 'Studio';

  /// en: 'Bright'
  String get bright => 'Bright';
}

// Path: common.provider
class TranslationsCommonProviderEn {
  TranslationsCommonProviderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Anthropic'
  String get anthropic => 'Anthropic';

  /// en: 'Baidu Translate Open Platform'
  String get baidu_fanyi_api => 'Baidu Translate Open Platform';

  /// en: 'Caiyun Open Platform'
  String get caiyun_platform => 'Caiyun Open Platform';

  /// en: 'DeepL API'
  String get deepl_api => 'DeepL API';

  /// en: 'Google Cloud'
  String get google_cloud => 'Google Cloud';

  /// en: 'Yandex Cloud'
  String get yandex => 'Yandex Cloud';

  /// en: 'Microsoft Azure'
  String get microsoft_translator => 'Microsoft Azure';

  /// en: 'Alibaba Cloud'
  String get aliyun => 'Alibaba Cloud';

  /// en: 'Volcengine'
  String get volcengine => 'Volcengine';

  /// en: 'NiuTrans'
  String get niutrans => 'NiuTrans';

  /// en: 'Ollama'
  String get ollama => 'Ollama';

  /// en: 'OpenAI'
  String get openai => 'OpenAI';

  /// en: 'Sogou'
  String get sogou => 'Sogou';

  /// en: 'xAI'
  String get xai => 'xAI';

  /// en: 'System'
  String get system => 'System';

  /// en: 'Tencent Cloud'
  String get tencent_cloud => 'Tencent Cloud';

  /// en: 'Youdao Zhiyun AI Open Platform'
  String get youdao_zhiyun => 'Youdao Zhiyun AI Open Platform';
}

// Path: app.tray
class TranslationsAppTrayEn {
  TranslationsAppTrayEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAppTrayContextMenuEn context_menu =
      TranslationsAppTrayContextMenuEn.internal(_root);
}

// Path: mini_translator.limited_banner
class TranslationsMiniTranslatorLimitedBannerEn {
  TranslationsMiniTranslatorLimitedBannerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorLimitedBannerPermissionEn permission =
      TranslationsMiniTranslatorLimitedBannerPermissionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerInstructionEn instruction =
      TranslationsMiniTranslatorLimitedBannerInstructionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerActionEn action =
      TranslationsMiniTranslatorLimitedBannerActionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerFeedbackEn feedback =
      TranslationsMiniTranslatorLimitedBannerFeedbackEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerTooltipEn tooltip =
      TranslationsMiniTranslatorLimitedBannerTooltipEn.internal(_root);
}

// Path: mini_translator.input
class TranslationsMiniTranslatorInputEn {
  TranslationsMiniTranslatorInputEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Enter the word or text here'
  String get hint => 'Enter the word or text here';

  /// en: 'Extracting text...'
  String get extracting_text => 'Extracting text...';

  /// en: 'Type a word or text to translate into $language'
  String hint_translate_to({required Object language}) =>
      'Type a word or text to translate into ${language}';
}

// Path: mini_translator.toolbar
class TranslationsMiniTranslatorToolbarEn {
  TranslationsMiniTranslatorToolbarEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorToolbarTooltipEn tooltip =
      TranslationsMiniTranslatorToolbarTooltipEn.internal(_root);
  late final TranslationsMiniTranslatorToolbarMenuEn menu =
      TranslationsMiniTranslatorToolbarMenuEn.internal(_root);
}

// Path: mini_translator.button
class TranslationsMiniTranslatorButtonEn {
  TranslationsMiniTranslatorButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Clear'
  String get clear => 'Clear';

  /// en: 'Translate'
  String get translate => 'Translate';

  /// en: 'Copy'
  String get copy => 'Copy';

  /// en: 'Copied'
  String get copied => 'Copied';

  /// en: 'Save'
  String get bookmark => 'Save';

  /// en: 'Saved'
  String get bookmarked => 'Saved';
}

// Path: mini_translator.language
class TranslationsMiniTranslatorLanguageEn {
  TranslationsMiniTranslatorLanguageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Auto Detect'
  String get auto_detect => 'Auto Detect';

  /// en: 'Auto Match'
  String get auto_match => 'Auto Match';

  /// en: 'Switch Target'
  String get switch_config => 'Switch Target';

  /// en: 'More languages...'
  String get more_languages => 'More languages...';

  /// en: 'Manage Common Languages...'
  String get manage_common_languages => 'Manage Common Languages...';

  /// en: 'Manage Translation Targets...'
  String get manage_targets => 'Manage Translation Targets...';

  /// en: 'Add Translation Target...'
  String get add_target => 'Add Translation Target...';
}

// Path: mini_translator.message
class TranslationsMiniTranslatorMessageEn {
  TranslationsMiniTranslatorMessageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'No text entered or text not extracted'
  String get please_enter_word_or_text =>
      'No text entered or text not extracted';

  /// en: 'Capture screen area has been canceled'
  String get capture_screen_area_canceled =>
      'Capture screen area has been canceled';

  /// en: 'No default text recognition service configured. Please set one in Settings.'
  String get ocr_service_not_configured =>
      'No default text recognition service configured. Please set one in Settings.';

  /// en: 'Text recognition failed'
  String get ocr_recognition_failed => 'Text recognition failed';
}

// Path: mini_translator.result
class TranslationsMiniTranslatorResultEn {
  TranslationsMiniTranslatorResultEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Translating…'
  String get translating => 'Translating…';

  /// en: 'Source changed; the translation below is the earlier one'
  String get stale_notice =>
      'Source changed; the translation below is the earlier one';

  /// en: '$key retranslate'
  String stale_retry({required Object key}) => '${key} retranslate';

  /// en: 'Compare $count services'
  String compare_services({required Object count}) =>
      'Compare ${count} services';

  /// en: 'Collapse'
  String get collapse_compare => 'Collapse';

  /// en: 'Set as preferred'
  String get set_preferred => 'Set as preferred';

  /// en: 'Retry'
  String get retry => 'Retry';

  /// en: 'No service returned a result — check your network or try another service.'
  String get no_result =>
      'No service returned a result — check your network or try another service.';

  /// en: 'Your text is kept; retrying will not duplicate history.'
  String get no_result_note =>
      'Your text is kept; retrying will not duplicate history.';

  /// en: '$count services returned nothing'
  String no_result_meta({required Object count}) =>
      '${count} services returned nothing';

  /// en: 'No translation came back. Check your network and press ⏎ to retry, or expand to see each service's reason.'
  String get no_result_body =>
      'No translation came back. Check your network and press ⏎ to retry, or expand to see each service\'s reason.';

  /// en: 'Check services'
  String get check_services => 'Check services';

  /// en: 'Why $count services failed'
  String show_reasons({required Object count}) =>
      'Why ${count} services failed';

  /// en: 'Hide reasons'
  String get collapse_reasons => 'Hide reasons';

  /// en: 'The service gave no reason.'
  String get unknown_error => 'The service gave no reason.';

  /// en: 'System Translation has not downloaded the language files for “$source → $target”.'
  String language_missing_sentence(
          {required Object source, required Object target}) =>
      'System Translation has not downloaded the language files for “${source} → ${target}”.';

  /// en: 'System Settings › General › Language & Region › Translation Languages'
  String get language_missing_settings_path =>
      'System Settings › General › Language & Region › Translation Languages';

  /// en: 'Download them under “$path”, then retry.'
  String language_missing_body_main({required Object path}) =>
      'Download them under “${path}”, then retry.';

  /// en: 'Download them in '
  String get language_missing_mini_before => 'Download them in ';

  /// en: 'System Settings'
  String get language_missing_mini_link => 'System Settings';

  /// en: ', then press $key to retry.'
  String language_missing_mini_after({required Object key}) =>
      ', then press ${key} to retry.';

  /// en: '“$source → $target” language files not downloaded'
  String language_missing_note(
          {required Object source, required Object target}) =>
      '“${source} → ${target}” language files not downloaded';

  /// en: 'Language files not downloaded'
  String get language_missing_flag => 'Language files not downloaded';

  /// en: 'Your text is kept; retry once the download finishes.'
  String get language_missing_kept =>
      'Your text is kept; retry once the download finishes.';

  /// en: 'Open System Settings'
  String get open_system_settings => 'Open System Settings';
}

// Path: workbench.history_page
class TranslationsWorkbenchHistoryPageEn {
  TranslationsWorkbenchHistoryPageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'All'
  String get all => 'All';

  /// en: 'Favorites'
  String get favorites => 'Favorites';

  /// en: 'Edited by me'
  String get edited => 'Edited by me';

  /// en: 'Search'
  String get search => 'Search';

  /// en: 'Search source, translation, or service'
  String get search_placeholder => 'Search source, translation, or service';

  /// en: 'Search history'
  String get search_label => 'Search history';

  /// en: '$label · $count entries'
  String entry_count({required Object label, required Object count}) =>
      '${label} · ${count} entries';

  /// en: 'By time'
  String get by_time => 'By time';

  /// en: 'Loading history…'
  String get loading => 'Loading history…';

  /// en: 'Failed to load history'
  String get load_failed => 'Failed to load history';

  /// en: 'Retry'
  String get retry => 'Retry';

  /// en: 'No translation history yet'
  String get empty_title => 'No translation history yet';

  /// en: 'Your preferred result is saved here after a successful translation.'
  String get empty_description =>
      'Your preferred result is saved here after a successful translation.';

  /// en: 'No history matches “$query”'
  String no_results({required Object query}) => 'No history matches “${query}”';

  /// en: 'Clear search'
  String get clear_search => 'Clear search';

  /// en: 'Select'
  String get select => 'Select';

  /// en: '$count selected'
  String selected_count({required Object count}) => '${count} selected';

  /// en: 'Exit selection'
  String get exit_select => 'Exit selection';

  /// en: 'Add to glossary'
  String get add_to_glossary => 'Add to glossary';

  /// en: 'Favorite'
  String get favorite => 'Favorite';

  /// en: 'Unfavorite'
  String get unfavorite => 'Unfavorite';

  /// en: 'Delete the selected $count history entries? This cannot be undone.'
  String delete_confirm({required Object count}) =>
      'Delete the selected ${count} history entries? This cannot be undone.';

  /// en: 'Create a glossary first'
  String get no_glossary => 'Create a glossary first';

  /// en: 'Added $count entries to the glossary'
  String added_to_glossary({required Object count}) =>
      'Added ${count} entries to the glossary';

  /// en: 'Favorite'
  String get favorite_flag => 'Favorite';

  /// en: 'Edited'
  String get edited_flag => 'Edited';

  /// en: 'The edited translation will be saved to history'
  String get edit_history_hint =>
      'The edited translation will be saved to history';

  /// en: 'Copy translation'
  String get copy_translation => 'Copy translation';

  /// en: 'More'
  String get more_actions => 'More';

  /// en: 'Delete this record'
  String get delete_title_one => 'Delete this record';

  /// en: 'Delete $count records'
  String delete_title_many({required Object count}) =>
      'Delete ${count} records';

  /// en: 'This cannot be undone. Favourites and your own wording go with it; the glossary is untouched.'
  String get delete_message =>
      'This cannot be undone. Favourites and your own wording go with it; the glossary is untouched.';

  /// en: 'Show full text'
  String get expand => 'Show full text';

  /// en: 'Collapse'
  String get collapse => 'Collapse';
}

// Path: workbench.subtitle
class TranslationsWorkbenchSubtitleEn {
  TranslationsWorkbenchSubtitleEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Workbench · Service comparison'
  String get translate => 'Workbench · Service comparison';

  /// en: 'Settings'
  String get settings => 'Settings';
}

// Path: workbench.placeholder
class TranslationsWorkbenchPlaceholderEn {
  TranslationsWorkbenchPlaceholderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Favorites and history will be available in a future release'
  String get history =>
      'Favorites and history will be available in a future release';

  /// en: 'Glossary management is being built'
  String get glossary => 'Glossary management is being built';
}

// Path: workbench.glossary_page
class TranslationsWorkbenchGlossaryPageEn {
  TranslationsWorkbenchGlossaryPageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'New entry'
  String get add_entry => 'New entry';

  /// en: 'Source'
  String get term => 'Source';

  /// en: 'Required translation'
  String get translation => 'Required translation';

  /// en: 'Forbidden'
  String get forbidden => 'Forbidden';

  /// en: 'Hits'
  String get hits => 'Hits';

  /// en: 'teacher forcing'
  String get term_placeholder => 'teacher forcing';

  /// en: 'forced teaching'
  String get translation_placeholder => 'forced teaching';

  /// en: 'coerced teaching'
  String get forbidden_placeholder => 'coerced teaching';

  /// en: 'Search'
  String get search => 'Search';

  /// en: 'Search terms or required translations'
  String get search_placeholder => 'Search terms or required translations';

  /// en: 'Search the glossary'
  String get search_label => 'Search the glossary';

  /// en: '$name · $count terms'
  String entry_count({required Object name, required Object count}) =>
      '${name} · ${count} terms';

  /// en: 'Glossary terms outrank any service output'
  String get priority_note => 'Glossary terms outrank any service output';

  /// en: 'New glossary'
  String get new_book => 'New glossary';

  /// en: 'Glossary name'
  String get new_book_placeholder => 'Glossary name';

  /// en: 'Rename'
  String get rename_book => 'Rename';

  /// en: 'Delete “$name” and all $count of its terms?'
  String delete_book_confirm({required Object name, required Object count}) =>
      'Delete “${name}” and all ${count} of its terms?';

  /// en: 'Off'
  String get disabled => 'Off';

  /// en: 'Enable'
  String get enable => 'Enable';

  /// en: 'Disable'
  String get disable => 'Disable';

  /// en: 'This glossary is empty'
  String get empty_title => 'This glossary is empty';

  /// en: 'Glossary terms outrank any service output. Add them one at a time, or drop in a CSV to merge.'
  String get empty_description =>
      'Glossary terms outrank any service output. Add them one at a time, or drop in a CSV to merge.';

  /// en: 'No terms match “$query”'
  String no_results_title({required Object query}) =>
      'No terms match “${query}”';

  /// en: 'Try another keyword, or add the term.'
  String get no_results_description => 'Try another keyword, or add the term.';

  /// en: 'No glossaries yet'
  String get no_books_title => 'No glossaries yet';

  /// en: 'A glossary keeps your chosen wording consistent across every service. Create one, then start adding terms.'
  String get no_books_description =>
      'A glossary keeps your chosen wording consistent across every service. Create one, then start adding terms.';

  /// en: 'Loading…'
  String get loading => 'Loading…';

  /// en: 'One book per domain; all of them apply while translating'
  String get new_book_subtitle =>
      'One book per domain; all of them apply while translating';

  /// en: 'Name'
  String get name => 'Name';

  /// en: 'Name · already exists'
  String get name_taken => 'Name · already exists';

  /// en: 'There is already a glossary called “$name”.'
  String name_taken_hint({required Object name}) =>
      'There is already a glossary called “${name}”.';

  /// en: 'Machine learning'
  String get name_placeholder => 'Machine learning';

  /// en: 'Source language'
  String get source_language => 'Source language';

  /// en: 'Target language'
  String get target_language => 'Target language';

  /// en: 'The source and target have to be two different languages.'
  String get same_language =>
      'The source and target have to be two different languages.';

  /// en: 'Initial content'
  String get seed => 'Initial content';

  /// en: 'Blank'
  String get seed_blank => 'Blank';

  /// en: 'Add entries one at a time later'
  String get seed_blank_hint => 'Add entries one at a time later';

  /// en: 'Two columns: term / translation'
  String get seed_csv_hint => 'Two columns: term / translation';

  /// en: 'Industry term exchange format'
  String get seed_tbx_hint => 'Industry term exchange format';

  /// en: 'Once it exists you can add entries one by one, or drop a CSV / TBX onto the list to merge.'
  String get seed_blank_note =>
      'Once it exists you can add entries one by one, or drop a CSV / TBX onto the list to merge.';

  /// en: 'Imports the $format file right after creating · duplicates take the file’s translation'
  String seed_file_note({required Object format}) =>
      'Imports the ${format} file right after creating · duplicates take the file’s translation';

  /// en: 'Choose file…'
  String get choose_file => 'Choose file…';

  /// en: 'Create'
  String get create => 'Create';

  /// en: 'A term outranks anything a service returns'
  String get add_entry_subtitle => 'A term outranks anything a service returns';

  /// en: 'Glossary'
  String get book => 'Glossary';

  /// en: 'Forbidden translations'
  String get forbidden_label => 'Forbidden translations';

  /// en: 'A service offering these is flagged as a conflict; separate several with /, leave empty to forbid none.'
  String get forbidden_hint =>
      'A service offering these is flagged as a conflict; separate several with /, leave empty to forbid none.';

  /// en: 'forced teaching / forcing teacher'
  String get forbidden_placeholder_full => 'forced teaching / forcing teacher';

  /// en: '“$term” is already in $book; saving overwrites the existing translation.'
  String duplicate({required Object term, required Object book}) =>
      '“${term}” is already in ${book}; saving overwrites the existing translation.';

  /// en: 'this glossary'
  String get duplicate_book_fallback => 'this glossary';

  /// en: 'Keep adding after saving'
  String get keep_adding => 'Keep adding after saving';

  /// en: 'Added $count so far'
  String added_count({required Object count}) => 'Added ${count} so far';

  /// en: 'Overwrite'
  String get overwrite => 'Overwrite';

  /// en: 'Done'
  String get done => 'Done';
}

// Path: workbench.translation
class TranslationsWorkbenchTranslationEn {
  TranslationsWorkbenchTranslationEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Source'
  String get source => 'Source';

  /// en: 'Translation'
  String get target => 'Translation';

  /// en: 'Enter or paste text to translate'
  String get input_hint => 'Enter or paste text to translate';

  /// en: 'Translate'
  String get button => 'Translate';

  /// en: 'Auto detected'
  String get auto_detected => 'Auto detected';

  /// en: 'Loading translation services…'
  String get loading_services => 'Loading translation services…';

  /// en: 'Configure a translation service in Settings first'
  String get no_services => 'Configure a translation service in Settings first';

  /// en: 'Translating…'
  String get translating => 'Translating…';

  /// en: 'Translation failed. Check the service configuration and try again.'
  String get failed =>
      'Translation failed. Check the service configuration and try again.';

  /// en: 'The translation will appear here'
  String get empty => 'The translation will appear here';

  /// en: 'Service comparison'
  String get service_compare => 'Service comparison';

  /// en: 'Primary'
  String get main_translation => 'Primary';

  /// en: 'Service unavailable'
  String get service_unavailable => 'Service unavailable';

  /// en: 'Waiting to translate'
  String get waiting => 'Waiting to translate';

  /// en: 'Copy'
  String get copy => 'Copy';

  /// en: 'Favorites will be available in a future release'
  String get favorite_unavailable =>
      'Favorites will be available in a future release';

  /// en: 'Preferred translation'
  String get preferred => 'Preferred translation';

  /// en: 'Other services'
  String get other_services => 'Other services';

  /// en: 'Copy translation'
  String get copy_result => 'Copy translation';

  /// en: 'Copied'
  String get copied => 'Copied';

  /// en: 'Save'
  String get favorite => 'Save';

  /// en: 'Glossary hits'
  String get terms => 'Glossary hits';

  /// en: 'Terms are matched once you type.'
  String get terms_hint => 'Terms are matched once you type.';

  /// en: 'Quality signals'
  String get quality => 'Quality signals';

  /// en: 'Computed once a translation lands.'
  String get quality_hint => 'Computed once a translation lands.';

  /// en: 'Shortcuts'
  String get shortcuts => 'Shortcuts';

  /// en: 'Other services are disabled'
  String get other_services_disabled => 'Other services are disabled';

  /// en: 'Type or paste text to translate into $language'
  String input_hint_translate_to({required Object language}) =>
      'Type or paste text to translate into ${language}';

  /// en: ', '
  String get target_separator => ', ';

  /// en: '$key for a new line'
  String newline_hint({required Object key}) => '${key} for a new line';

  /// en: 'This passage did not get a translation. Check your connection and retry, or expand to work through each service's reason.'
  String get failed_body =>
      'This passage did not get a translation. Check your connection and retry, or expand to work through each service\'s reason.';
}

// Path: workbench.status
class TranslationsWorkbenchStatusEn {
  TranslationsWorkbenchStatusEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Translation runtime ready'
  String get runtime_ready => 'Translation runtime ready';

  /// en: 'Settings synced'
  String get settings_synced => 'Settings synced';

  /// en: '⌥Space Quick window · ⌥⇧2 Capture'
  String get shortcuts => '⌥Space Quick window · ⌥⇧2 Capture';
}

// Path: settings.general
class TranslationsSettingsGeneralEn {
  TranslationsSettingsGeneralEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'General'
  String get title => 'General';

  late final TranslationsSettingsGeneralSectionEn section =
      TranslationsSettingsGeneralSectionEn.internal(_root);
  late final TranslationsSettingsGeneralRowEn row =
      TranslationsSettingsGeneralRowEn.internal(_root);
  late final TranslationsSettingsGeneralButtonEn button =
      TranslationsSettingsGeneralButtonEn.internal(_root);
  late final TranslationsSettingsGeneralOptionEn option =
      TranslationsSettingsGeneralOptionEn.internal(_root);
  late final TranslationsSettingsGeneralEditorEn editor =
      TranslationsSettingsGeneralEditorEn.internal(_root);
  late final TranslationsSettingsGeneralLanguagesEditorEn languages_editor =
      TranslationsSettingsGeneralLanguagesEditorEn.internal(_root);
}

// Path: settings.appearance
class TranslationsSettingsAppearanceEn {
  TranslationsSettingsAppearanceEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Appearance'
  String get title => 'Appearance';

  late final TranslationsSettingsAppearanceSectionEn section =
      TranslationsSettingsAppearanceSectionEn.internal(_root);

  /// en: 'Changes apply to the whole window immediately.'
  String get footer => 'Changes apply to the whole window immediately.';
}

// Path: settings.shortcuts
class TranslationsSettingsShortcutsEn {
  TranslationsSettingsShortcutsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Shortcuts'
  String get title => 'Shortcuts';

  late final TranslationsSettingsShortcutsSectionEn section =
      TranslationsSettingsShortcutsSectionEn.internal(_root);
  late final TranslationsSettingsShortcutsRowEn row =
      TranslationsSettingsShortcutsRowEn.internal(_root);
  late final TranslationsSettingsShortcutsResetDialogEn reset_dialog =
      TranslationsSettingsShortcutsResetDialogEn.internal(_root);
  late final TranslationsSettingsShortcutsGroupEn group =
      TranslationsSettingsShortcutsGroupEn.internal(_root);

  /// en: 'Restore Defaults...'
  String get reset => 'Restore Defaults...';

  /// en: 'Record shortcut'
  String get record_placeholder => 'Record shortcut';

  /// en: 'Press keys…'
  String get recording => 'Press keys…';

  /// en: 'Clear'
  String get clear => 'Clear';

  /// en: 'Conflicts with “$label”'
  String conflict({required Object label}) => 'Conflicts with “${label}”';
}

// Path: settings.advanced
class TranslationsSettingsAdvancedEn {
  TranslationsSettingsAdvancedEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Advanced'
  String get title => 'Advanced';

  /// en: 'Local API server'
  String get api_server => 'Local API server';

  /// en: 'Expose the translation API on 127.0.0.1 for local integrations.'
  String get api_server_description =>
      'Expose the translation API on 127.0.0.1 for local integrations.';

  /// en: 'Enable'
  String get enable => 'Enable';

  /// en: 'Port'
  String get port => 'Port';

  /// en: 'Running at {url}'
  String get running_at => 'Running at {url}';

  /// en: 'Disabled'
  String get disabled => 'Disabled';
}

// Path: settings.services
class TranslationsSettingsServicesEn {
  TranslationsSettingsServicesEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Services'
  String get title => 'Services';

  late final TranslationsSettingsServicesButtonEn button =
      TranslationsSettingsServicesButtonEn.internal(_root);
  late final TranslationsSettingsServicesSectionEn section =
      TranslationsSettingsServicesSectionEn.internal(_root);
  late final TranslationsSettingsServicesEditorEn editor =
      TranslationsSettingsServicesEditorEn.internal(_root);
  late final TranslationsSettingsServicesDetailEn detail =
      TranslationsSettingsServicesDetailEn.internal(_root);

  /// en: 'Make Default'
  String get make_default => 'Make Default';

  late final TranslationsSettingsServicesItemEn item =
      TranslationsSettingsServicesItemEn.internal(_root);

  /// en: 'Go to Providers'
  String get go_to_providers => 'Go to Providers';

  /// en: 'Services come from providers — set one up on the Providers page first.'
  String get go_to_providers_hint =>
      'Services come from providers — set one up on the Providers page first.';

  late final TranslationsSettingsServicesCapabilityEn capability =
      TranslationsSettingsServicesCapabilityEn.internal(_root);
  late final TranslationsSettingsServicesPermissionsMissingEn
      permissions_missing =
      TranslationsSettingsServicesPermissionsMissingEn.internal(_root);
}

// Path: settings.providers
class TranslationsSettingsProvidersEn {
  TranslationsSettingsProvidersEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Providers'
  String get title => 'Providers';

  late final TranslationsSettingsProvidersSectionEn section =
      TranslationsSettingsProvidersSectionEn.internal(_root);
  late final TranslationsSettingsProvidersItemEn item =
      TranslationsSettingsProvidersItemEn.internal(_root);
  late final TranslationsSettingsProvidersButtonEn button =
      TranslationsSettingsProvidersButtonEn.internal(_root);
  late final TranslationsSettingsProvidersAlertEn alert =
      TranslationsSettingsProvidersAlertEn.internal(_root);
  late final TranslationsSettingsProvidersIntroEn intro =
      TranslationsSettingsProvidersIntroEn.internal(_root);
  late final TranslationsSettingsProvidersEditorEn editor =
      TranslationsSettingsProvidersEditorEn.internal(_root);
  late final TranslationsSettingsProvidersDetailEn detail =
      TranslationsSettingsProvidersDetailEn.internal(_root);
  late final TranslationsSettingsProvidersCapabilityEn capability =
      TranslationsSettingsProvidersCapabilityEn.internal(_root);
  late final TranslationsSettingsProvidersDescriptionEn description =
      TranslationsSettingsProvidersDescriptionEn.internal(_root);
  late final TranslationsSettingsProvidersNeedEn need =
      TranslationsSettingsProvidersNeedEn.internal(_root);
  late final TranslationsSettingsProvidersStatusEn status =
      TranslationsSettingsProvidersStatusEn.internal(_root);
  late final TranslationsSettingsProvidersMetaEn meta =
      TranslationsSettingsProvidersMetaEn.internal(_root);
  late final TranslationsSettingsProvidersSearchEn search =
      TranslationsSettingsProvidersSearchEn.internal(_root);
  late final TranslationsSettingsProvidersDiscardDialogEn discard_dialog =
      TranslationsSettingsProvidersDiscardDialogEn.internal(_root);
  late final TranslationsSettingsProvidersClearDialogEn clear_dialog =
      TranslationsSettingsProvidersClearDialogEn.internal(_root);
}

// Path: settings.layout
class TranslationsSettingsLayoutEn {
  TranslationsSettingsLayoutEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get title => 'Settings';

  late final TranslationsSettingsLayoutEmptyEn empty =
      TranslationsSettingsLayoutEmptyEn.internal(_root);

  /// en: 'Groups'
  String get groups => 'Groups';

  /// en: 'Translations and keys stay on this Mac'
  String get footer_note => 'Translations and keys stay on this Mac';

  /// en: 'Support'
  String get support => 'Support';
}

// Path: settings.about
class TranslationsSettingsAboutEn {
  TranslationsSettingsAboutEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'About'
  String get title => 'About';

  /// en: 'Copy Version Info'
  String get copy_version_info => 'Copy Version Info';

  /// en: 'You're up to date'
  String get up_to_date => 'You\'re up to date';

  /// en: 'Links'
  String get links => 'Links';

  /// en: 'Website'
  String get website => 'Website';

  /// en: 'Help Center'
  String get help_center => 'Help Center';

  /// en: 'Changelog'
  String get open_changelog => 'Changelog';

  /// en: 'Update'
  String get update => 'Update';

  /// en: 'Software Update'
  String get software_update => 'Software Update';
}

// Path: common.ui.button
class TranslationsCommonUiButtonEn {
  TranslationsCommonUiButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'OK'
  String get ok => 'OK';

  /// en: 'Cancel'
  String get cancel => 'Cancel';

  /// en: 'Add'
  String get add => 'Add';

  /// en: 'Delete'
  String get delete => 'Delete';

  /// en: 'Edit'
  String get edit => 'Edit';

  /// en: 'Save'
  String get save => 'Save';

  /// en: 'Manage'
  String get manage => 'Manage';

  /// en: 'Continue'
  String get kContinue => 'Continue';

  /// en: 'Copy'
  String get copy => 'Copy';

  /// en: 'Select all'
  String get select_all => 'Select all';
}

// Path: common.ui.feedback
class TranslationsCommonUiFeedbackEn {
  TranslationsCommonUiFeedbackEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Copied'
  String get copied => 'Copied';
}

// Path: app.tray.context_menu
class TranslationsAppTrayContextMenuEn {
  TranslationsAppTrayContextMenuEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Show Window'
  String get show_window => 'Show Window';

  late final TranslationsAppTrayContextMenuDevToolsEn dev_tools =
      TranslationsAppTrayContextMenuDevToolsEn.internal(_root);

  /// en: 'Check for Updates'
  String get check_for_updates => 'Check for Updates';

  /// en: 'Settings'
  String get settings => 'Settings';

  /// en: 'Quit'
  String get quit => 'Quit';
}

// Path: mini_translator.limited_banner.permission
class TranslationsMiniTranslatorLimitedBannerPermissionEn {
  TranslationsMiniTranslatorLimitedBannerPermissionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Grant Screen Recording and Accessibility permissions to enable all features.'
  String get missing_both =>
      'Grant Screen Recording and Accessibility permissions to enable all features.';

  /// en: 'Grant Screen Recording permission to enable all features.'
  String get missing_screen_capture =>
      'Grant Screen Recording permission to enable all features.';

  /// en: 'Grant Accessibility permission to enable all features.'
  String get missing_accessibility =>
      'Grant Accessibility permission to enable all features.';
}

// Path: mini_translator.limited_banner.instruction
class TranslationsMiniTranslatorLimitedBannerInstructionEn {
  TranslationsMiniTranslatorLimitedBannerInstructionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Go to '
  String get app_settings_prefix => 'Go to ';

  /// en: ', follow the guide, then click '
  String get follow_guide_prefix => ', follow the guide, then click ';

  /// en: '.'
  String get suffix => '.';
}

// Path: mini_translator.limited_banner.action
class TranslationsMiniTranslatorLimitedBannerActionEn {
  TranslationsMiniTranslatorLimitedBannerActionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'App Settings'
  String get app_settings => 'App Settings';

  /// en: 'Recheck'
  String get recheck => 'Recheck';
}

// Path: mini_translator.limited_banner.feedback
class TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  TranslationsMiniTranslatorLimitedBannerFeedbackEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Screen text extraction is enabled.'
  String get enabled => 'Screen text extraction is enabled.';

  /// en: 'Required permissions are still missing. Please check your settings and try again.'
  String get still_missing =>
      'Required permissions are still missing.\nPlease check your settings and try again.';

  /// en: 'Screen Recording is still missing. If you just granted it, restart the app for it to take effect.'
  String get still_missing_screen_capture =>
      'Screen Recording is still missing.\nIf you just granted it, restart the app for it to take effect.';
}

// Path: mini_translator.limited_banner.tooltip
class TranslationsMiniTranslatorLimitedBannerTooltipEn {
  TranslationsMiniTranslatorLimitedBannerTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'View help'
  String get help => 'View help';
}

// Path: mini_translator.toolbar.tooltip
class TranslationsMiniTranslatorToolbarTooltipEn {
  TranslationsMiniTranslatorToolbarTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Capture screen area and recognize text'
  String get extract_text_from_screen_capture =>
      'Capture screen area and recognize text';

  /// en: 'Read clipboard content'
  String get extract_text_from_clipboard => 'Read clipboard content';

  /// en: 'Pin window'
  String get pin => 'Pin window';

  /// en: 'More actions'
  String get more_actions => 'More actions';
}

// Path: mini_translator.toolbar.menu
class TranslationsMiniTranslatorToolbarMenuEn {
  TranslationsMiniTranslatorToolbarMenuEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Capture from screen'
  String get extract_from_screen_capture => 'Capture from screen';

  /// en: 'From clipboard'
  String get extract_from_clipboard => 'From clipboard';

  /// en: 'Open main window'
  String get open_main_window => 'Open main window';

  /// en: 'Settings…'
  String get open_settings => 'Settings…';
}

// Path: settings.general.section
class TranslationsSettingsGeneralSectionEn {
  TranslationsSettingsGeneralSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'System Permissions'
  String get permissions => 'System Permissions';

  /// en: 'Text Recognition'
  String get ocr => 'Text Recognition';

  /// en: 'Directory'
  String get directory => 'Directory';

  /// en: 'Translation'
  String get translation => 'Translation';

  /// en: 'Translation Target'
  String get translation_target => 'Translation Target';

  /// en: 'Languages'
  String get languages => 'Languages';

  /// en: 'Input Settings'
  String get input => 'Input Settings';

  /// en: 'Startup & Integration'
  String get startup => 'Startup & Integration';

  /// en: 'Capture Behaviour'
  String get ocr_behaviour => 'Capture Behaviour';

  /// en: 'Translation Behaviour'
  String get translation_behaviour => 'Translation Behaviour';
}

// Path: settings.general.row
class TranslationsSettingsGeneralRowEn {
  TranslationsSettingsGeneralRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Launch when you log in'
  String get launch_at_login => 'Launch when you log in';

  /// en: 'Show in menu bar'
  String get show_in_menu_bar => 'Show in menu bar';

  /// en: 'Grant screen recording access'
  String get screen_capture_access => 'Grant screen recording access';

  /// en: 'Grant accessibility access'
  String get screen_selection_access => 'Grant accessibility access';

  /// en: 'Default text recognition service'
  String get default_ocr_service => 'Default text recognition service';

  /// en: 'Auto copy detected text'
  String get auto_copy_detected_text => 'Auto copy detected text';

  /// en: 'Default directory service'
  String get default_directory_service => 'Default directory service';

  /// en: 'Default translation service'
  String get default_translation_service => 'Default translation service';

  /// en: 'Configure language pairs used by the translator.'
  String get translation_target_hint =>
      'Configure language pairs used by the translator.';

  /// en: 'Common Languages'
  String get common_languages => 'Common Languages';

  /// en: 'Listed at the top of language menus in this order; the rest fold into “More languages”.'
  String get common_languages_hint =>
      'Listed at the top of language menus in this order; the rest fold into “More languages”.';

  /// en: 'Not set · language menus list all $count languages flat'
  String common_languages_empty({required Object count}) =>
      'Not set · language menus list all ${count} languages flat';

  /// en: 'Double click to copy translation result'
  String get double_click_copy_result =>
      'Double click to copy translation result';

  /// en: 'Submit with Enter'
  String get submit_with_enter => 'Submit with Enter';

  /// en: 'Submit with ⌘ + Enter'
  String get submit_with_meta_enter_mac => 'Submit with ⌘ + Enter';

  /// en: 'Capturing text from the screen needs to read screen contents.'
  String get screen_capture_access_hint =>
      'Capturing text from the screen needs to read screen contents.';

  /// en: 'Capturing selected text needs to read selections in other apps.'
  String get screen_selection_access_hint =>
      'Capturing selected text needs to read selections in other apps.';

  /// en: 'No translation targets yet — add one to set the default language to translate into.'
  String get no_translation_targets =>
      'No translation targets yet — add one to set the default language to translate into.';
}

// Path: settings.general.button
class TranslationsSettingsGeneralButtonEn {
  TranslationsSettingsGeneralButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add...'
  String get add_provider => 'Add...';

  /// en: 'Add Target...'
  String get add_target => 'Add Target...';

  /// en: 'Manage Translation Targets...'
  String get manage_targets => 'Manage Translation Targets...';

  /// en: 'Manage Common Languages...'
  String get manage_languages => 'Manage Common Languages...';

  /// en: 'Grant'
  String get grant => 'Grant';
}

// Path: settings.general.option
class TranslationsSettingsGeneralOptionEn {
  TranslationsSettingsGeneralOptionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'None'
  String get none => 'None';

  /// en: 'No services available'
  String get no_services_available => 'No services available';

  /// en: 'Granted'
  String get granted => 'Granted';

  /// en: 'Built-in OCR'
  String get built_in_ocr => 'Built-in OCR';

  /// en: 'Tesseract'
  String get tesseract => 'Tesseract';

  /// en: 'Youdao OCR'
  String get youdao_ocr => 'Youdao OCR';
}

// Path: settings.general.editor
class TranslationsSettingsGeneralEditorEn {
  TranslationsSettingsGeneralEditorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Translation Target'
  String get add_target_title => 'Add Translation Target';

  /// en: 'Edit Translation Target'
  String get edit_target_title => 'Edit Translation Target';

  late final TranslationsSettingsGeneralEditorRowEn row =
      TranslationsSettingsGeneralEditorRowEn.internal(_root);

  /// en: 'Edit Translation Target'
  String get title_edit => 'Edit Translation Target';

  /// en: 'Decide which language a source language translates into by default'
  String get subtitle =>
      'Decide which language a source language translates into by default';

  /// en: 'Source and target are the same language — pick another target.'
  String get same_language =>
      'Source and target are the same language — pick another target.';

  /// en: 'There is already a target with this pair.'
  String get duplicate => 'There is already a target with this pair.';

  /// en: 'Translate into {} when no other rule matches.'
  String get hint_auto => 'Translate into {} when no other rule matches.';

  /// en: 'Translate into {} when {} is detected.'
  String get hint_source => 'Translate into {} when {} is detected.';
}

// Path: settings.general.languages_editor
class TranslationsSettingsGeneralLanguagesEditorEn {
  TranslationsSettingsGeneralLanguagesEditorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Ordered as on the left at the top of language menus; the right folds into “More languages”'
  String get subtitle =>
      'Ordered as on the left at the top of language menus; the right folds into “More languages”';

  /// en: 'Common · $count'
  String common_pane({required Object count}) => 'Common · ${count}';

  /// en: 'More languages · $count'
  String more_pane({required Object count}) => 'More languages · ${count}';

  /// en: 'Sort'
  String get sort => 'Sort';

  /// en: 'Reorder to match the language roster'
  String get sort_help => 'Reorder to match the language roster';

  /// en: 'No common languages yet. Add at least one from the right.'
  String get empty_common =>
      'No common languages yet.\nAdd at least one from the right.';

  /// en: 'Search'
  String get search => 'Search';

  /// en: 'Every language is already common.'
  String get all_in_common => 'Every language is already common.';

  /// en: 'Languages matching “$query” are already on the left.'
  String matches_in_common({required Object query}) =>
      'Languages matching “${query}” are already on the left.';

  /// en: 'No languages match “$query”'
  String no_matches({required Object query}) => 'No languages match “${query}”';

  /// en: 'Drag the handle to reorder common languages, or focus it and press ↑↓.'
  String get reorder_hint =>
      'Drag the handle to reorder common languages, or focus it and press ↑↓.';

  /// en: 'Reset to Defaults'
  String get reset => 'Reset to Defaults';

  /// en: 'Add $name to common languages'
  String add_language({required Object name}) =>
      'Add ${name} to common languages';

  /// en: 'Remove $name from common languages'
  String remove_language({required Object name}) =>
      'Remove ${name} from common languages';

  /// en: '$name, position $position, press up or down to reorder'
  String handle_label({required Object name, required Object position}) =>
      '${name}, position ${position}, press up or down to reorder';
}

// Path: settings.appearance.section
class TranslationsSettingsAppearanceSectionEn {
  TranslationsSettingsAppearanceSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Display Language'
  String get app_language => 'Display Language';

  /// en: 'Theme Mode'
  String get theme_mode => 'Theme Mode';

  /// en: 'Theme style'
  String get theme_style => 'Theme style';
}

// Path: settings.shortcuts.section
class TranslationsSettingsShortcutsSectionEn {
  TranslationsSettingsShortcutsSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Text Extraction'
  String get text_extraction => 'Text Extraction';

  /// en: 'Submit With'
  String get submit_mode => 'Submit With';
}

// Path: settings.shortcuts.row
class TranslationsSettingsShortcutsRowEn {
  TranslationsSettingsShortcutsRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Show/Hide Window'
  String get toggle_mini_translator => 'Show/Hide Window';

  /// en: 'Extract text from screen selection'
  String get extract_text_from_screen_selection =>
      'Extract text from screen selection';

  /// en: 'Extract text from screen capture'
  String get extract_text_from_screen_capture =>
      'Extract text from screen capture';

  /// en: 'Extract text from clipboard'
  String get extract_text_from_clipboard => 'Extract text from clipboard';
}

// Path: settings.shortcuts.reset_dialog
class TranslationsSettingsShortcutsResetDialogEn {
  TranslationsSettingsShortcutsResetDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Reset Shortcuts'
  String get title => 'Reset Shortcuts';

  /// en: 'Reset all shortcuts to their defaults? Any bindings you changed will be overwritten.'
  String get message =>
      'Reset all shortcuts to their defaults? Any bindings you changed will be overwritten.';

  /// en: 'Reset'
  String get confirm => 'Reset';

  /// en: 'Cancel'
  String get cancel => 'Cancel';
}

// Path: settings.shortcuts.group
class TranslationsSettingsShortcutsGroupEn {
  TranslationsSettingsShortcutsGroupEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsSettingsShortcutsGroupGlobalEn global =
      TranslationsSettingsShortcutsGroupGlobalEn.internal(_root);
  late final TranslationsSettingsShortcutsGroupInAppEn in_app =
      TranslationsSettingsShortcutsGroupInAppEn.internal(_root);
}

// Path: settings.services.button
class TranslationsSettingsServicesButtonEn {
  TranslationsSettingsServicesButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Service...'
  String get add_service => 'Add Service...';
}

// Path: settings.services.section
class TranslationsSettingsServicesSectionEn {
  TranslationsSettingsServicesSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Available Services'
  String get available_services => 'Available Services';
}

// Path: settings.services.editor
class TranslationsSettingsServicesEditorEn {
  TranslationsSettingsServicesEditorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Service'
  String get title => 'Add Service';

  /// en: 'Add one more service to a configured provider'
  String get subtitle => 'Add one more service to a configured provider';

  late final TranslationsSettingsServicesEditorRowEn row =
      TranslationsSettingsServicesEditorRowEn.internal(_root);

  /// en: 'Leave blank to use the default prompt for this kind'
  String get prompt_placeholder =>
      'Leave blank to use the default prompt for this kind';

  /// en: '{} already has a {} service; this one is added alongside it as a second configuration.'
  String get variant_hint =>
      '{} already has a {} service; this one is added alongside it as a second configuration.';

  /// en: '{} is a traditional endpoint — no model or prompt to tune. Its parameters live on the provider's detail page.'
  String get traditional_note =>
      '{} is a traditional endpoint — no model or prompt to tune. Its parameters live on the provider\'s detail page.';
}

// Path: settings.services.detail
class TranslationsSettingsServicesDetailEn {
  TranslationsSettingsServicesDetailEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsSettingsServicesDetailRowEn row =
      TranslationsSettingsServicesDetailRowEn.internal(_root);
  late final TranslationsSettingsServicesDetailDeleteDialogEn delete_dialog =
      TranslationsSettingsServicesDetailDeleteDialogEn.internal(_root);

  /// en: 'Available variables: {{sourceLanguage}}, {{targetLanguage}}, {{text}}'
  String get prompt_variables =>
      'Available variables: {{sourceLanguage}}, {{targetLanguage}}, {{text}}';
}

// Path: settings.services.item
class TranslationsSettingsServicesItemEn {
  TranslationsSettingsServicesItemEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'No {} service available yet.'
  String get none_of_kind => 'No {} service available yet.';
}

// Path: settings.services.capability
class TranslationsSettingsServicesCapabilityEn {
  TranslationsSettingsServicesCapabilityEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Translation'
  String get translation => 'Translation';

  /// en: 'Dictionary'
  String get dictionary => 'Dictionary';

  /// en: 'Text Recognition'
  String get ocr => 'Text Recognition';
}

// Path: settings.services.permissions_missing
class TranslationsSettingsServicesPermissionsMissingEn {
  TranslationsSettingsServicesPermissionsMissingEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'System permissions not granted'
  String get title => 'System permissions not granted';

  /// en: 'Screenshot and selection capture need screen recording and accessibility access.'
  String get hint =>
      'Screenshot and selection capture need screen recording and accessibility access.';

  /// en: 'Open General'
  String get open_general => 'Open General';
}

// Path: settings.providers.section
class TranslationsSettingsProvidersSectionEn {
  TranslationsSettingsProvidersSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Available Services'
  String get services => 'Available Services';

  /// en: 'View available services from configured providers and switch between service types.'
  String get services_description =>
      'View available services from configured providers and switch between service types.';

  /// en: 'Providers · {}'
  String get count => 'Providers · {}';
}

// Path: settings.providers.item
class TranslationsSettingsProvidersItemEn {
  TranslationsSettingsProvidersItemEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Loading providers...'
  String get loading => 'Loading providers...';
}

// Path: settings.providers.button
class TranslationsSettingsProvidersButtonEn {
  TranslationsSettingsProvidersButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add a Provider...'
  String get add => 'Add a Provider...';
}

// Path: settings.providers.alert
class TranslationsSettingsProvidersAlertEn {
  TranslationsSettingsProvidersAlertEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Error'
  String get error => 'Error';
}

// Path: settings.providers.intro
class TranslationsSettingsProvidersIntroEn {
  TranslationsSettingsProvidersIntroEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Manage the service providers used by the app.'
  String get body => 'Manage the service providers used by the app.';

  /// en: 'Connected providers may process the text or images you send. Only enable services you trust.'
  String get warning =>
      'Connected providers may process the text or images you send. Only enable services you trust.';
}

// Path: settings.providers.editor
class TranslationsSettingsProvidersEditorEn {
  TranslationsSettingsProvidersEditorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsSettingsProvidersEditorRowEn row =
      TranslationsSettingsProvidersEditorRowEn.internal(_root);
  late final TranslationsSettingsProvidersEditorPlaceholderEn placeholder =
      TranslationsSettingsProvidersEditorPlaceholderEn.internal(_root);
  late final TranslationsSettingsProvidersEditorTypePickerEn type_picker =
      TranslationsSettingsProvidersEditorTypePickerEn.internal(_root);
  late final TranslationsSettingsProvidersEditorTooltipEn tooltip =
      TranslationsSettingsProvidersEditorTooltipEn.internal(_root);
  late final TranslationsSettingsProvidersEditorStepEn step =
      TranslationsSettingsProvidersEditorStepEn.internal(_root);

  /// en: 'Add {}'
  String get add_title => 'Add {}';

  late final TranslationsSettingsProvidersEditorCapabilityNoteEn
      capability_note =
      TranslationsSettingsProvidersEditorCapabilityNoteEn.internal(_root);
  late final TranslationsSettingsProvidersEditorTestEn test =
      TranslationsSettingsProvidersEditorTestEn.internal(_root);
}

// Path: settings.providers.detail
class TranslationsSettingsProvidersDetailEn {
  TranslationsSettingsProvidersDetailEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsSettingsProvidersDetailTooltipEn tooltip =
      TranslationsSettingsProvidersDetailTooltipEn.internal(_root);
  late final TranslationsSettingsProvidersDetailSectionEn section =
      TranslationsSettingsProvidersDetailSectionEn.internal(_root);
  late final TranslationsSettingsProvidersDetailModelsEn models =
      TranslationsSettingsProvidersDetailModelsEn.internal(_root);
  late final TranslationsSettingsProvidersDetailButtonEn button =
      TranslationsSettingsProvidersDetailButtonEn.internal(_root);
  late final TranslationsSettingsProvidersDetailReceiptEn receipt =
      TranslationsSettingsProvidersDetailReceiptEn.internal(_root);
  late final TranslationsSettingsProvidersDetailProblemEn problem =
      TranslationsSettingsProvidersDetailProblemEn.internal(_root);
  late final TranslationsSettingsProvidersDetailFieldEn field =
      TranslationsSettingsProvidersDetailFieldEn.internal(_root);

  /// en: 'Nothing to fill in — it works as soon as it is installed; the lines above are only a description.'
  String get no_fields =>
      'Nothing to fill in — it works as soon as it is installed; the lines above are only a description.';

  /// en: 'No services yet'
  String get services_empty => 'No services yet';

  /// en: 'Enter a key and save to add services from this provider.'
  String get services_locked =>
      'Enter a key and save to add services from this provider.';
}

// Path: settings.providers.capability
class TranslationsSettingsProvidersCapabilityEn {
  TranslationsSettingsProvidersCapabilityEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Translation'
  String get translation => 'Translation';

  /// en: 'Dictionary'
  String get dictionary => 'Dictionary';

  /// en: 'OCR'
  String get ocr => 'OCR';

  /// en: 'AI'
  String get llm => 'AI';
}

// Path: settings.providers.description
class TranslationsSettingsProvidersDescriptionEn {
  TranslationsSettingsProvidersDescriptionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Provides dictionary lookup and text translation'
  String get all => 'Provides dictionary lookup and text translation';

  /// en: 'Provides dictionary lookup and word definitions'
  String get dictionary => 'Provides dictionary lookup and word definitions';

  /// en: 'Provides text translation between languages'
  String get translation => 'Provides text translation between languages';

  /// en: 'Provides translation services'
  String get fallback => 'Provides translation services';
}

// Path: settings.providers.need
class TranslationsSettingsProvidersNeedEn {
  TranslationsSettingsProvidersNeedEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Needs an API key'
  String get anthropic => 'Needs an API key';

  /// en: 'Needs an API key'
  String get openai => 'Needs an API key';

  /// en: 'Needs an API key'
  String get gemini => 'Needs an API key';

  /// en: 'Needs an API key'
  String get deepseek => 'Needs an API key';

  /// en: 'Needs a Model Studio API key'
  String get qwen => 'Needs a Model Studio API key';

  /// en: 'Needs a Moonshot API key'
  String get moonshot => 'Needs a Moonshot API key';

  /// en: 'Needs a Volcano Ark API key'
  String get doubao => 'Needs a Volcano Ark API key';

  /// en: 'Needs a Zhipu Open Platform API key'
  String get zhipu => 'Needs a Zhipu Open Platform API key';

  /// en: 'Needs an xAI API key'
  String get xai => 'Needs an xAI API key';

  /// en: 'Needs a Groq API key'
  String get groq => 'Needs a Groq API key';

  /// en: 'Runs on this Mac · No API key'
  String get ollama => 'Runs on this Mac · No API key';

  /// en: 'Self-hosted or aggregator endpoint · Bring your own Base URL'
  String get openai_compatible =>
      'Self-hosted or aggregator endpoint · Bring your own Base URL';
}

// Path: settings.providers.status
class TranslationsSettingsProvidersStatusEn {
  TranslationsSettingsProvidersStatusEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Not set up'
  String get unconfigured => 'Not set up';

  /// en: 'Unverified'
  String get unverified => 'Unverified';

  /// en: 'Needs attention'
  String get invalid => 'Needs attention';
}

// Path: settings.providers.meta
class TranslationsSettingsProvidersMetaEn {
  TranslationsSettingsProvidersMetaEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Key valid'
  String get key_valid => 'Key valid';

  /// en: 'Connected'
  String get reachable => 'Connected';

  /// en: 'Key rejected · Needs attention'
  String get invalid => 'Key rejected · Needs attention';
}

// Path: settings.providers.search
class TranslationsSettingsProvidersSearchEn {
  TranslationsSettingsProvidersSearchEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Search'
  String get button => 'Search';

  /// en: 'Search provider name or id'
  String get placeholder => 'Search provider name or id';

  /// en: 'Search providers'
  String get label => 'Search providers';

  /// en: 'Clear Search'
  String get clear => 'Clear Search';

  /// en: 'No matching providers'
  String get no_match_title => 'No matching providers';

  /// en: 'Nothing found for “{}”.'
  String get no_match_body => 'Nothing found for “{}”.';
}

// Path: settings.providers.discard_dialog
class TranslationsSettingsProvidersDiscardDialogEn {
  TranslationsSettingsProvidersDiscardDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Discard unsaved changes?'
  String get title => 'Discard unsaved changes?';

  /// en: 'What you entered on this page hasn’t been saved and will be lost if you leave.'
  String get message =>
      'What you entered on this page hasn’t been saved and will be lost if you leave.';

  /// en: 'Discard'
  String get confirm => 'Discard';

  /// en: 'Keep Editing'
  String get cancel => 'Keep Editing';
}

// Path: settings.providers.clear_dialog
class TranslationsSettingsProvidersClearDialogEn {
  TranslationsSettingsProvidersClearDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Clear Key'
  String get title => 'Clear Key';

  /// en: '{} goes back to “Not set up”, and the services it provides are removed with it. The key you entered is cleared.'
  String get message =>
      '{} goes back to “Not set up”, and the services it provides are removed with it. The key you entered is cleared.';

  /// en: 'Clear'
  String get confirm => 'Clear';
}

// Path: settings.layout.empty
class TranslationsSettingsLayoutEmptyEn {
  TranslationsSettingsLayoutEmptyEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select a Category'
  String get title => 'Select a Category';

  /// en: 'Choose a settings section from the sidebar.'
  String get message => 'Choose a settings section from the sidebar.';
}

// Path: app.tray.context_menu.dev_tools
class TranslationsAppTrayContextMenuDevToolsEn {
  TranslationsAppTrayContextMenuDevToolsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Dev Tools'
  String get title => 'Dev Tools';

  /// en: 'Open Data Directory'
  String get open_data_directory => 'Open Data Directory';
}

// Path: settings.general.editor.row
class TranslationsSettingsGeneralEditorRowEn {
  TranslationsSettingsGeneralEditorRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Source Language'
  String get source_language => 'Source Language';

  /// en: 'Target Language'
  String get target_language => 'Target Language';
}

// Path: settings.shortcuts.group.global
class TranslationsSettingsShortcutsGroupGlobalEn {
  TranslationsSettingsShortcutsGroupGlobalEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Global Shortcuts'
  String get title => 'Global Shortcuts';

  /// en: 'Work in any app.'
  String get description => 'Work in any app.';
}

// Path: settings.shortcuts.group.in_app
class TranslationsSettingsShortcutsGroupInAppEn {
  TranslationsSettingsShortcutsGroupInAppEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'In-App Keys'
  String get title => 'In-App Keys';

  /// en: 'Only apply inside this app’s own text fields.'
  String get description => 'Only apply inside this app’s own text fields.';
}

// Path: settings.services.editor.row
class TranslationsSettingsServicesEditorRowEn {
  TranslationsSettingsServicesEditorRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Model'
  String get model => 'Model';

  /// en: 'System Prompt'
  String get system_prompt => 'System Prompt';
}

// Path: settings.services.detail.row
class TranslationsSettingsServicesDetailRowEn {
  TranslationsSettingsServicesDetailRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Service ID'
  String get id => 'Service ID';

  /// en: 'Name'
  String get name => 'Name';

  /// en: 'Provider'
  String get provider => 'Provider';

  /// en: 'Type'
  String get type => 'Type';
}

// Path: settings.services.detail.delete_dialog
class TranslationsSettingsServicesDetailDeleteDialogEn {
  TranslationsSettingsServicesDetailDeleteDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Delete "{}"?'
  String get title => 'Delete "{}"?';

  /// en: 'This service will be removed from the provider.'
  String get message => 'This service will be removed from the provider.';
}

// Path: settings.providers.editor.row
class TranslationsSettingsProvidersEditorRowEn {
  TranslationsSettingsProvidersEditorRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Provider ID'
  String get id => 'Provider ID';

  /// en: 'Provider Type'
  String get type => 'Provider Type';

  /// en: 'Default Model'
  String get default_model => 'Default Model';
}

// Path: settings.providers.editor.placeholder
class TranslationsSettingsProvidersEditorPlaceholderEn {
  TranslationsSettingsProvidersEditorPlaceholderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'e.g. deepl-main'
  String get id => 'e.g. deepl-main';
}

// Path: settings.providers.editor.type_picker
class TranslationsSettingsProvidersEditorTypePickerEn {
  TranslationsSettingsProvidersEditorTypePickerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select the type of provider you would like to add:'
  String get prompt => 'Select the type of provider you would like to add:';

  /// en: 'LLM'
  String get section_llm => 'LLM';

  /// en: 'Traditional'
  String get section_traditional => 'Traditional';
}

// Path: settings.providers.editor.tooltip
class TranslationsSettingsProvidersEditorTooltipEn {
  TranslationsSettingsProvidersEditorTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Help'
  String get help => 'Help';
}

// Path: settings.providers.editor.step
class TranslationsSettingsProvidersEditorStepEn {
  TranslationsSettingsProvidersEditorStepEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Continue'
  String get next => 'Continue';

  /// en: 'Back'
  String get back => 'Back';
}

// Path: settings.providers.editor.capability_note
class TranslationsSettingsProvidersEditorCapabilityNoteEn {
  TranslationsSettingsProvidersEditorCapabilityNoteEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Joins the translation candidates'
  String get translation => 'Joins the translation candidates';

  /// en: 'Provides dictionary definitions'
  String get dictionary => 'Provides dictionary definitions';

  /// en: 'Recognises text in images'
  String get ocr => 'Recognises text in images';
}

// Path: settings.providers.editor.test
class TranslationsSettingsProvidersEditorTestEn {
  TranslationsSettingsProvidersEditorTestEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Test Connection'
  String get run => 'Test Connection';

  /// en: 'Testing connection · {}s elapsed'
  String get running => 'Testing connection · {}s elapsed';

  /// en: 'Connection OK · {} models available'
  String get passed_models => 'Connection OK · {} models available';

  /// en: 'Connection OK · service available'
  String get passed_service => 'Connection OK · service available';

  /// en: 'Connection test passed'
  String get passed_footer => 'Connection test passed';

  /// en: 'Test Again'
  String get retest => 'Test Again';

  /// en: 'Things to try'
  String get tips_title => 'Things to try';

  /// en: '· Check the key matches the provider type you picked · Check whether the Base URL needs /v1 · Confirm the model is enabled in the provider console'
  String get tips_llm =>
      '· Check the key matches the provider type you picked\n· Check whether the Base URL needs /v1\n· Confirm the model is enabled in the provider console';

  /// en: '· Check the credentials match the provider type you picked · Confirm the service is enabled in the provider console'
  String get tips_traditional =>
      '· Check the credentials match the provider type you picked\n· Confirm the service is enabled in the provider console';

  /// en: 'verification failed'
  String get failed_suffix => 'verification failed';

  /// en: 'verified'
  String get passed_suffix => 'verified';
}

// Path: settings.providers.detail.tooltip
class TranslationsSettingsProvidersDetailTooltipEn {
  TranslationsSettingsProvidersDetailTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Edit provider'
  String get edit => 'Edit provider';
}

// Path: settings.providers.detail.section
class TranslationsSettingsProvidersDetailSectionEn {
  TranslationsSettingsProvidersDetailSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Configuration'
  String get configuration => 'Configuration';

  /// en: 'Models'
  String get models => 'Models';

  /// en: 'Services from This Provider'
  String get services => 'Services from This Provider';
}

// Path: settings.providers.detail.models
class TranslationsSettingsProvidersDetailModelsEn {
  TranslationsSettingsProvidersDetailModelsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Loading models...'
  String get loading => 'Loading models...';

  /// en: 'No models found.'
  String get empty => 'No models found.';

  /// en: 'Retry'
  String get retry => 'Retry';

  /// en: 'Refresh List'
  String get refresh => 'Refresh List';

  /// en: 'Default'
  String get default_badge => 'Default';

  /// en: 'Set as Default'
  String get set_default => 'Set as Default';

  /// en: 'Asking the endpoint for its model list…'
  String get fetching => 'Asking the endpoint for its model list…';

  /// en: 'Couldn't fetch models'
  String get fetch_failed_title => 'Couldn\'t fetch models';

  /// en: 'The endpoint didn't respond, or it doesn't accept this key. Once the address and key are right, you can try again.'
  String get fetch_failed_body =>
      'The endpoint didn\'t respond, or it doesn\'t accept this key. Once the address and key are right, you can try again.';

  /// en: 'The endpoint answered but listed no models — typing a model name by hand works too.'
  String get empty_answer =>
      'The endpoint answered but listed no models — typing a model name by hand works too.';

  /// en: 'Test New Settings'
  String get test_draft => 'Test New Settings';

  /// en: 'These models were fetched with unsaved values — they count once you press Save.'
  String get draft_note =>
      'These models were fetched with unsaved values — they count once you press Save.';

  /// en: 'Enter a key and save, and Refresh List fetches the models this provider offers.'
  String get locked =>
      'Enter a key and save, and Refresh List fetches the models this provider offers.';

  /// en: 'Enter a model name'
  String get manual_placeholder => 'Enter a model name';
}

// Path: settings.providers.detail.button
class TranslationsSettingsProvidersDetailButtonEn {
  TranslationsSettingsProvidersDetailButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Saving'
  String get saving => 'Saving';

  /// en: 'Add Service...'
  String get add_service => 'Add Service...';

  /// en: 'Clear Key'
  String get clear_key => 'Clear Key';
}

// Path: settings.providers.detail.receipt
class TranslationsSettingsProvidersDetailReceiptEn {
  TranslationsSettingsProvidersDetailReceiptEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'This configuration can't be saved yet'
  String get problems_title => 'This configuration can\'t be saved yet';

  /// en: 'Saved'
  String get saved_title => 'Saved';

  /// en: 'This provider's configuration has been written.'
  String get saved_body => 'This provider\'s configuration has been written.';

  /// en: 'Couldn't save'
  String get save_failed_title => 'Couldn\'t save';

  /// en: 'Couldn't delete'
  String get delete_failed_title => 'Couldn\'t delete';

  /// en: 'Couldn't add the service'
  String get add_service_failed_title => 'Couldn\'t add the service';

  /// en: 'Saved, but the endpoint didn’t accept it'
  String get saved_rejected_title => 'Saved, but the endpoint didn’t accept it';

  /// en: 'The configuration was written, but fetching the model list with it failed — try another key and save again.'
  String get saved_rejected_body =>
      'The configuration was written, but fetching the model list with it failed — try another key and save again.';

  /// en: 'Saved. Checking the connection…'
  String get saved_verifying => 'Saved. Checking the connection…';
}

// Path: settings.providers.detail.problem
class TranslationsSettingsProvidersDetailProblemEn {
  TranslationsSettingsProvidersDetailProblemEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: '{}: {}'
  String get item => '{}: {}';

  /// en: '; '
  String get separator => '; ';

  /// en: 'Required'
  String get required => 'Required';

  /// en: 'Must start with http:// or https://'
  String get url_scheme => 'Must start with http:// or https://';

  /// en: 'Only http:// and https:// are accepted'
  String get url_protocol => 'Only http:// and https:// are accepted';

  /// en: 'Missing a host name'
  String get url_host => 'Missing a host name';

  /// en: 'No model yet — fetch the list first, or enter a model name.'
  String get no_model =>
      'No model yet — fetch the list first, or enter a model name.';
}

// Path: settings.providers.detail.field
class TranslationsSettingsProvidersDetailFieldEn {
  TranslationsSettingsProvidersDetailFieldEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Leave blank to use {}'
  String get fallback_hint => 'Leave blank to use {}';

  /// en: 'Show {}'
  String get show_secret => 'Show {}';

  /// en: 'Hide {}'
  String get hide_secret => 'Hide {}';

  /// en: 'Saved · Leave blank to keep'
  String get secret_stored => 'Saved · Leave blank to keep';

  /// en: 'Enter key'
  String get secret_empty => 'Enter key';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
          'common.service_name.baidu_fanyi_api' => 'General Translation API',
          'common.service_name.caiyun_platform' => 'Caiyun Xiaoyi API',
          'common.service_name.deepl_api' => 'DeepL API / Translate text',
          'common.service_name.google_cloud' => 'Cloud Translation - Basic',
          'common.service_name.yandex' => 'Yandex Translate API',
          'common.service_name.microsoft_translator' => 'Microsoft Translator',
          'common.service_name.aliyun' => 'Alibaba Cloud Machine Translation',
          'common.service_name.volcengine' => 'Volcengine Machine Translation',
          'common.service_name.niutrans' => 'NiuTrans Translation API',
          'common.service_name.tencent_cloud' =>
            'Tencent Machine Translation (TMT)',
          'common.service_name.youdao_zhiyun_translation' =>
            'Text Translation API',
          'common.service_name.youdao_zhiyun_dictionary' =>
            'Text Translation API (dictionary results)',
          'common.service_name.youdao_zhiyun_ocr' =>
            'General Text Recognition API',
          'common.service_name.google_cloud_ocr' =>
            'Cloud Vision - Text Detection',
          'common.service_name.tencent_cloud_ocr' => 'General Print OCR',
          'common.service_name.volcengine_ocr' => 'Volcengine General OCR',
          'common.service_name.aliyun_ocr' => 'Alibaba Cloud General OCR',
          'common.service_name.yandex_ocr' => 'Yandex Vision OCR',
          'common.ui.button.ok' => 'OK',
          'common.ui.button.cancel' => 'Cancel',
          'common.ui.button.add' => 'Add',
          'common.ui.button.delete' => 'Delete',
          'common.ui.button.edit' => 'Edit',
          'common.ui.button.save' => 'Save',
          'common.ui.button.manage' => 'Manage',
          'common.ui.button.kContinue' => 'Continue',
          'common.ui.button.copy' => 'Copy',
          'common.ui.button.select_all' => 'Select all',
          'common.ui.feedback.copied' => 'Copied',
          'common.language.ar' => 'Arabic',
          'common.language.bn' => 'Bengali',
          'common.language.de' => 'German',
          'common.language.en' => 'English',
          'common.language.es' => 'Spanish',
          'common.language.fa' => 'Persian',
          'common.language.fr' => 'French',
          'common.language.gu' => 'Gujarati',
          'common.language.ha' => 'Hausa',
          'common.language.hi' => 'Hindi',
          'common.language.id' => 'Indonesian',
          'common.language.it' => 'Italian',
          'common.language.ja' => 'Japanese',
          'common.language.jv' => 'Javanese',
          'common.language.ko' => 'Korean',
          'common.language.ml' => 'Malayalam',
          'common.language.mr' => 'Marathi',
          'common.language.ms' => 'Malay',
          'common.language.nl' => 'Dutch',
          'common.language.pa' => 'Punjabi',
          'common.language.pl' => 'Polish',
          'common.language.pt' => 'Portuguese',
          'common.language.ro' => 'Romanian',
          'common.language.ru' => 'Russian',
          'common.language.sw' => 'Swahili',
          'common.language.ta' => 'Tamil',
          'common.language.te' => 'Telugu',
          'common.language.th' => 'Thai',
          'common.language.tr' => 'Turkish',
          'common.language.uk' => 'Ukrainian',
          'common.language.ur' => 'Urdu',
          'common.language.vi' => 'Vietnamese',
          'common.language.yo' => 'Yoruba',
          'common.language.zh_hans' => 'Chinese (Simplified)',
          'common.language.zh_hant' => 'Chinese (Traditional)',
          'common.theme_mode.light' => 'Light',
          'common.theme_mode.dark' => 'Dark',
          'common.theme_mode.system' => 'System',
          'common.theme_style.studio' => 'Studio',
          'common.theme_style.bright' => 'Bright',
          'common.provider.anthropic' => 'Anthropic',
          'common.provider.baidu_fanyi_api' => 'Baidu Translate Open Platform',
          'common.provider.caiyun_platform' => 'Caiyun Open Platform',
          'common.provider.deepl_api' => 'DeepL API',
          'common.provider.google_cloud' => 'Google Cloud',
          'common.provider.yandex' => 'Yandex Cloud',
          'common.provider.microsoft_translator' => 'Microsoft Azure',
          'common.provider.aliyun' => 'Alibaba Cloud',
          'common.provider.volcengine' => 'Volcengine',
          'common.provider.niutrans' => 'NiuTrans',
          'common.provider.ollama' => 'Ollama',
          'common.provider.openai' => 'OpenAI',
          'common.provider.sogou' => 'Sogou',
          'common.provider.xai' => 'xAI',
          'common.provider.system' => 'System',
          'common.provider.tencent_cloud' => 'Tencent Cloud',
          'common.provider.youdao_zhiyun' => 'Youdao Zhiyun AI Open Platform',
          'app.tray.context_menu.show_window' => 'Show Window',
          'app.tray.context_menu.dev_tools.title' => 'Dev Tools',
          'app.tray.context_menu.dev_tools.open_data_directory' =>
            'Open Data Directory',
          'app.tray.context_menu.check_for_updates' => 'Check for Updates',
          'app.tray.context_menu.settings' => 'Settings',
          'app.tray.context_menu.quit' => 'Quit',
          'mini_translator.limited_banner.permission.missing_both' =>
            'Grant Screen Recording and Accessibility permissions to enable all features.',
          'mini_translator.limited_banner.permission.missing_screen_capture' =>
            'Grant Screen Recording permission to enable all features.',
          'mini_translator.limited_banner.permission.missing_accessibility' =>
            'Grant Accessibility permission to enable all features.',
          'mini_translator.limited_banner.instruction.app_settings_prefix' =>
            'Go to ',
          'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
            ', follow the guide, then click ',
          'mini_translator.limited_banner.instruction.suffix' => '.',
          'mini_translator.limited_banner.action.app_settings' =>
            'App Settings',
          'mini_translator.limited_banner.action.recheck' => 'Recheck',
          'mini_translator.limited_banner.feedback.enabled' =>
            'Screen text extraction is enabled.',
          'mini_translator.limited_banner.feedback.still_missing' =>
            'Required permissions are still missing.\nPlease check your settings and try again.',
          'mini_translator.limited_banner.feedback.still_missing_screen_capture' =>
            'Screen Recording is still missing.\nIf you just granted it, restart the app for it to take effect.',
          'mini_translator.limited_banner.tooltip.help' => 'View help',
          'mini_translator.input.hint' => 'Enter the word or text here',
          'mini_translator.input.extracting_text' => 'Extracting text...',
          'mini_translator.input.hint_translate_to' => (
                  {required Object language}) =>
              'Type a word or text to translate into ${language}',
          'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
            'Capture screen area and recognize text',
          'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
            'Read clipboard content',
          'mini_translator.toolbar.tooltip.pin' => 'Pin window',
          'mini_translator.toolbar.tooltip.more_actions' => 'More actions',
          'mini_translator.toolbar.menu.extract_from_screen_capture' =>
            'Capture from screen',
          'mini_translator.toolbar.menu.extract_from_clipboard' =>
            'From clipboard',
          'mini_translator.toolbar.menu.open_main_window' => 'Open main window',
          'mini_translator.toolbar.menu.open_settings' => 'Settings…',
          'mini_translator.button.clear' => 'Clear',
          'mini_translator.button.translate' => 'Translate',
          'mini_translator.button.copy' => 'Copy',
          'mini_translator.button.copied' => 'Copied',
          'mini_translator.button.bookmark' => 'Save',
          'mini_translator.button.bookmarked' => 'Saved',
          'mini_translator.language.auto_detect' => 'Auto Detect',
          'mini_translator.language.auto_match' => 'Auto Match',
          'mini_translator.language.switch_config' => 'Switch Target',
          'mini_translator.language.more_languages' => 'More languages...',
          'mini_translator.language.manage_common_languages' =>
            'Manage Common Languages...',
          'mini_translator.language.manage_targets' =>
            'Manage Translation Targets...',
          'mini_translator.language.add_target' => 'Add Translation Target...',
          'mini_translator.message.please_enter_word_or_text' =>
            'No text entered or text not extracted',
          'mini_translator.message.capture_screen_area_canceled' =>
            'Capture screen area has been canceled',
          'mini_translator.message.ocr_service_not_configured' =>
            'No default text recognition service configured. Please set one in Settings.',
          'mini_translator.message.ocr_recognition_failed' =>
            'Text recognition failed',
          'mini_translator.result.translating' => 'Translating…',
          'mini_translator.result.stale_notice' =>
            'Source changed; the translation below is the earlier one',
          'mini_translator.result.stale_retry' => ({required Object key}) =>
              '${key} retranslate',
          'mini_translator.result.compare_services' =>
            ({required Object count}) => 'Compare ${count} services',
          'mini_translator.result.collapse_compare' => 'Collapse',
          'mini_translator.result.set_preferred' => 'Set as preferred',
          'mini_translator.result.retry' => 'Retry',
          'mini_translator.result.no_result' =>
            'No service returned a result — check your network or try another service.',
          'mini_translator.result.no_result_note' =>
            'Your text is kept; retrying will not duplicate history.',
          'mini_translator.result.no_result_meta' =>
            ({required Object count}) => '${count} services returned nothing',
          'mini_translator.result.no_result_body' =>
            'No translation came back. Check your network and press ⏎ to retry, or expand to see each service\'s reason.',
          'mini_translator.result.check_services' => 'Check services',
          'mini_translator.result.show_reasons' => ({required Object count}) =>
              'Why ${count} services failed',
          'mini_translator.result.collapse_reasons' => 'Hide reasons',
          'mini_translator.result.unknown_error' =>
            'The service gave no reason.',
          'mini_translator.result.language_missing_sentence' => (
                  {required Object source, required Object target}) =>
              'System Translation has not downloaded the language files for “${source} → ${target}”.',
          'mini_translator.result.language_missing_settings_path' =>
            'System Settings › General › Language & Region › Translation Languages',
          'mini_translator.result.language_missing_body_main' => (
                  {required Object path}) =>
              'Download them under “${path}”, then retry.',
          'mini_translator.result.language_missing_mini_before' =>
            'Download them in ',
          'mini_translator.result.language_missing_mini_link' =>
            'System Settings',
          'mini_translator.result.language_missing_mini_after' =>
            ({required Object key}) => ', then press ${key} to retry.',
          'mini_translator.result.language_missing_note' => (
                  {required Object source, required Object target}) =>
              '“${source} → ${target}” language files not downloaded',
          'mini_translator.result.language_missing_flag' =>
            'Language files not downloaded',
          'mini_translator.result.language_missing_kept' =>
            'Your text is kept; retry once the download finishes.',
          'mini_translator.result.open_system_settings' =>
            'Open System Settings',
          'workbench.workspace' => 'Workspace',
          'workbench.translate' => 'Translate',
          'workbench.history' => 'History',
          'workbench.history_page.all' => 'All',
          'workbench.history_page.favorites' => 'Favorites',
          'workbench.history_page.edited' => 'Edited by me',
          'workbench.history_page.search' => 'Search',
          'workbench.history_page.search_placeholder' =>
            'Search source, translation, or service',
          'workbench.history_page.search_label' => 'Search history',
          'workbench.history_page.entry_count' => (
                  {required Object label, required Object count}) =>
              '${label} · ${count} entries',
          'workbench.history_page.by_time' => 'By time',
          'workbench.history_page.loading' => 'Loading history…',
          'workbench.history_page.load_failed' => 'Failed to load history',
          'workbench.history_page.retry' => 'Retry',
          'workbench.history_page.empty_title' => 'No translation history yet',
          'workbench.history_page.empty_description' =>
            'Your preferred result is saved here after a successful translation.',
          'workbench.history_page.no_results' => ({required Object query}) =>
              'No history matches “${query}”',
          'workbench.history_page.clear_search' => 'Clear search',
          'workbench.history_page.select' => 'Select',
          'workbench.history_page.selected_count' =>
            ({required Object count}) => '${count} selected',
          'workbench.history_page.exit_select' => 'Exit selection',
          'workbench.history_page.add_to_glossary' => 'Add to glossary',
          'workbench.history_page.favorite' => 'Favorite',
          'workbench.history_page.unfavorite' => 'Unfavorite',
          'workbench.history_page.delete_confirm' => (
                  {required Object count}) =>
              'Delete the selected ${count} history entries? This cannot be undone.',
          'workbench.history_page.no_glossary' => 'Create a glossary first',
          'workbench.history_page.added_to_glossary' => (
                  {required Object count}) =>
              'Added ${count} entries to the glossary',
          'workbench.history_page.favorite_flag' => 'Favorite',
          'workbench.history_page.edited_flag' => 'Edited',
          'workbench.history_page.edit_history_hint' =>
            'The edited translation will be saved to history',
          'workbench.history_page.copy_translation' => 'Copy translation',
          'workbench.history_page.more_actions' => 'More',
          'workbench.history_page.delete_title_one' => 'Delete this record',
          'workbench.history_page.delete_title_many' =>
            ({required Object count}) => 'Delete ${count} records',
          'workbench.history_page.delete_message' =>
            'This cannot be undone. Favourites and your own wording go with it; the glossary is untouched.',
          'workbench.history_page.expand' => 'Show full text',
          'workbench.history_page.collapse' => 'Collapse',
          'workbench.glossary' => 'Glossary',
          'workbench.recent_languages' => 'Recent Languages',
          'workbench.not_configured' => 'Not configured',
          'workbench.subtitle.translate' => 'Workbench · Service comparison',
          'workbench.subtitle.settings' => 'Settings',
          'workbench.placeholder.history' =>
            'Favorites and history will be available in a future release',
          'workbench.placeholder.glossary' =>
            'Glossary management is being built',
          'workbench.glossary_page.add_entry' => 'New entry',
          'workbench.glossary_page.term' => 'Source',
          'workbench.glossary_page.translation' => 'Required translation',
          'workbench.glossary_page.forbidden' => 'Forbidden',
          'workbench.glossary_page.hits' => 'Hits',
          'workbench.glossary_page.term_placeholder' => 'teacher forcing',
          'workbench.glossary_page.translation_placeholder' =>
            'forced teaching',
          'workbench.glossary_page.forbidden_placeholder' => 'coerced teaching',
          'workbench.glossary_page.search' => 'Search',
          'workbench.glossary_page.search_placeholder' =>
            'Search terms or required translations',
          'workbench.glossary_page.search_label' => 'Search the glossary',
          'workbench.glossary_page.entry_count' => (
                  {required Object name, required Object count}) =>
              '${name} · ${count} terms',
          'workbench.glossary_page.priority_note' =>
            'Glossary terms outrank any service output',
          'workbench.glossary_page.new_book' => 'New glossary',
          'workbench.glossary_page.new_book_placeholder' => 'Glossary name',
          'workbench.glossary_page.rename_book' => 'Rename',
          'workbench.glossary_page.delete_book_confirm' => (
                  {required Object name, required Object count}) =>
              'Delete “${name}” and all ${count} of its terms?',
          'workbench.glossary_page.disabled' => 'Off',
          'workbench.glossary_page.enable' => 'Enable',
          'workbench.glossary_page.disable' => 'Disable',
          'workbench.glossary_page.empty_title' => 'This glossary is empty',
          'workbench.glossary_page.empty_description' =>
            'Glossary terms outrank any service output. Add them one at a time, or drop in a CSV to merge.',
          'workbench.glossary_page.no_results_title' =>
            ({required Object query}) => 'No terms match “${query}”',
          'workbench.glossary_page.no_results_description' =>
            'Try another keyword, or add the term.',
          'workbench.glossary_page.no_books_title' => 'No glossaries yet',
          'workbench.glossary_page.no_books_description' =>
            'A glossary keeps your chosen wording consistent across every service. Create one, then start adding terms.',
          'workbench.glossary_page.loading' => 'Loading…',
          'workbench.glossary_page.new_book_subtitle' =>
            'One book per domain; all of them apply while translating',
          'workbench.glossary_page.name' => 'Name',
          'workbench.glossary_page.name_taken' => 'Name · already exists',
          'workbench.glossary_page.name_taken_hint' => (
                  {required Object name}) =>
              'There is already a glossary called “${name}”.',
          'workbench.glossary_page.name_placeholder' => 'Machine learning',
          'workbench.glossary_page.source_language' => 'Source language',
          'workbench.glossary_page.target_language' => 'Target language',
          'workbench.glossary_page.same_language' =>
            'The source and target have to be two different languages.',
          'workbench.glossary_page.seed' => 'Initial content',
          'workbench.glossary_page.seed_blank' => 'Blank',
          'workbench.glossary_page.seed_blank_hint' =>
            'Add entries one at a time later',
          'workbench.glossary_page.seed_csv_hint' =>
            'Two columns: term / translation',
          'workbench.glossary_page.seed_tbx_hint' =>
            'Industry term exchange format',
          'workbench.glossary_page.seed_blank_note' =>
            'Once it exists you can add entries one by one, or drop a CSV / TBX onto the list to merge.',
          'workbench.glossary_page.seed_file_note' => (
                  {required Object format}) =>
              'Imports the ${format} file right after creating · duplicates take the file’s translation',
          'workbench.glossary_page.choose_file' => 'Choose file…',
          'workbench.glossary_page.create' => 'Create',
          'workbench.glossary_page.add_entry_subtitle' =>
            'A term outranks anything a service returns',
          'workbench.glossary_page.book' => 'Glossary',
          'workbench.glossary_page.forbidden_label' => 'Forbidden translations',
          'workbench.glossary_page.forbidden_hint' =>
            'A service offering these is flagged as a conflict; separate several with /, leave empty to forbid none.',
          'workbench.glossary_page.forbidden_placeholder_full' =>
            'forced teaching / forcing teacher',
          'workbench.glossary_page.duplicate' => (
                  {required Object term, required Object book}) =>
              '“${term}” is already in ${book}; saving overwrites the existing translation.',
          'workbench.glossary_page.duplicate_book_fallback' => 'this glossary',
          'workbench.glossary_page.keep_adding' => 'Keep adding after saving',
          'workbench.glossary_page.added_count' => ({required Object count}) =>
              'Added ${count} so far',
          'workbench.glossary_page.overwrite' => 'Overwrite',
          'workbench.glossary_page.done' => 'Done',
          'workbench.translation.source' => 'Source',
          'workbench.translation.target' => 'Translation',
          'workbench.translation.input_hint' =>
            'Enter or paste text to translate',
          'workbench.translation.button' => 'Translate',
          'workbench.translation.auto_detected' => 'Auto detected',
          'workbench.translation.loading_services' =>
            'Loading translation services…',
          'workbench.translation.no_services' =>
            'Configure a translation service in Settings first',
          'workbench.translation.translating' => 'Translating…',
          'workbench.translation.failed' =>
            'Translation failed. Check the service configuration and try again.',
          'workbench.translation.empty' => 'The translation will appear here',
          'workbench.translation.service_compare' => 'Service comparison',
          'workbench.translation.main_translation' => 'Primary',
          'workbench.translation.service_unavailable' => 'Service unavailable',
          'workbench.translation.waiting' => 'Waiting to translate',
          'workbench.translation.copy' => 'Copy',
          'workbench.translation.favorite_unavailable' =>
            'Favorites will be available in a future release',
          'workbench.translation.preferred' => 'Preferred translation',
          'workbench.translation.other_services' => 'Other services',
          'workbench.translation.copy_result' => 'Copy translation',
          'workbench.translation.copied' => 'Copied',
          'workbench.translation.favorite' => 'Save',
          'workbench.translation.terms' => 'Glossary hits',
          'workbench.translation.terms_hint' =>
            'Terms are matched once you type.',
          'workbench.translation.quality' => 'Quality signals',
          'workbench.translation.quality_hint' =>
            'Computed once a translation lands.',
          'workbench.translation.shortcuts' => 'Shortcuts',
          'workbench.translation.other_services_disabled' =>
            'Other services are disabled',
          'workbench.translation.input_hint_translate_to' => (
                  {required Object language}) =>
              'Type or paste text to translate into ${language}',
          'workbench.translation.target_separator' => ', ',
          'workbench.translation.newline_hint' => ({required Object key}) =>
              '${key} for a new line',
          'workbench.translation.failed_body' =>
            'This passage did not get a translation. Check your connection and retry, or expand to work through each service\'s reason.',
          'workbench.status.runtime_ready' => 'Translation runtime ready',
          'workbench.status.settings_synced' => 'Settings synced',
          'workbench.status.shortcuts' => '⌥Space Quick window · ⌥⇧2 Capture',
          'workbench.version_latest' => 'Up to date',
          'workbench.version_checking' => 'Checking…',
          'workbench.check_updates' => 'Check for updates',
          'settings.version' => '{} (Build {})',
          'settings.general.title' => 'General',
          'settings.general.section.permissions' => 'System Permissions',
          'settings.general.section.ocr' => 'Text Recognition',
          'settings.general.section.directory' => 'Directory',
          'settings.general.section.translation' => 'Translation',
          'settings.general.section.translation_target' => 'Translation Target',
          'settings.general.section.languages' => 'Languages',
          'settings.general.section.input' => 'Input Settings',
          'settings.general.section.startup' => 'Startup & Integration',
          'settings.general.section.ocr_behaviour' => 'Capture Behaviour',
          'settings.general.section.translation_behaviour' =>
            'Translation Behaviour',
          'settings.general.row.launch_at_login' => 'Launch when you log in',
          'settings.general.row.show_in_menu_bar' => 'Show in menu bar',
          'settings.general.row.screen_capture_access' =>
            'Grant screen recording access',
          'settings.general.row.screen_selection_access' =>
            'Grant accessibility access',
          'settings.general.row.default_ocr_service' =>
            'Default text recognition service',
          'settings.general.row.auto_copy_detected_text' =>
            'Auto copy detected text',
          'settings.general.row.default_directory_service' =>
            'Default directory service',
          'settings.general.row.default_translation_service' =>
            'Default translation service',
          'settings.general.row.translation_target_hint' =>
            'Configure language pairs used by the translator.',
          'settings.general.row.common_languages' => 'Common Languages',
          'settings.general.row.common_languages_hint' =>
            'Listed at the top of language menus in this order; the rest fold into “More languages”.',
          'settings.general.row.common_languages_empty' => (
                  {required Object count}) =>
              'Not set · language menus list all ${count} languages flat',
          'settings.general.row.double_click_copy_result' =>
            'Double click to copy translation result',
          'settings.general.row.submit_with_enter' => 'Submit with Enter',
          'settings.general.row.submit_with_meta_enter_mac' =>
            'Submit with ⌘ + Enter',
          'settings.general.row.screen_capture_access_hint' =>
            'Capturing text from the screen needs to read screen contents.',
          'settings.general.row.screen_selection_access_hint' =>
            'Capturing selected text needs to read selections in other apps.',
          'settings.general.row.no_translation_targets' =>
            'No translation targets yet — add one to set the default language to translate into.',
          'settings.general.button.add_provider' => 'Add...',
          'settings.general.button.add_target' => 'Add Target...',
          'settings.general.button.manage_targets' =>
            'Manage Translation Targets...',
          'settings.general.button.manage_languages' =>
            'Manage Common Languages...',
          'settings.general.button.grant' => 'Grant',
          'settings.general.option.none' => 'None',
          'settings.general.option.no_services_available' =>
            'No services available',
          'settings.general.option.granted' => 'Granted',
          'settings.general.option.built_in_ocr' => 'Built-in OCR',
          'settings.general.option.tesseract' => 'Tesseract',
          'settings.general.option.youdao_ocr' => 'Youdao OCR',
          'settings.general.editor.add_target_title' =>
            'Add Translation Target',
          'settings.general.editor.edit_target_title' =>
            'Edit Translation Target',
          'settings.general.editor.row.source_language' => 'Source Language',
          'settings.general.editor.row.target_language' => 'Target Language',
          'settings.general.editor.title_edit' => 'Edit Translation Target',
          'settings.general.editor.subtitle' =>
            'Decide which language a source language translates into by default',
          'settings.general.editor.same_language' =>
            'Source and target are the same language — pick another target.',
          'settings.general.editor.duplicate' =>
            'There is already a target with this pair.',
          'settings.general.editor.hint_auto' =>
            'Translate into {} when no other rule matches.',
          'settings.general.editor.hint_source' =>
            'Translate into {} when {} is detected.',
          'settings.general.languages_editor.subtitle' =>
            'Ordered as on the left at the top of language menus; the right folds into “More languages”',
          'settings.general.languages_editor.common_pane' =>
            ({required Object count}) => 'Common · ${count}',
          'settings.general.languages_editor.more_pane' =>
            ({required Object count}) => 'More languages · ${count}',
          'settings.general.languages_editor.sort' => 'Sort',
          'settings.general.languages_editor.sort_help' =>
            'Reorder to match the language roster',
          'settings.general.languages_editor.empty_common' =>
            'No common languages yet.\nAdd at least one from the right.',
          'settings.general.languages_editor.search' => 'Search',
          'settings.general.languages_editor.all_in_common' =>
            'Every language is already common.',
          'settings.general.languages_editor.matches_in_common' => (
                  {required Object query}) =>
              'Languages matching “${query}” are already on the left.',
          'settings.general.languages_editor.no_matches' =>
            ({required Object query}) => 'No languages match “${query}”',
          'settings.general.languages_editor.reorder_hint' =>
            'Drag the handle to reorder common languages, or focus it and press ↑↓.',
          'settings.general.languages_editor.reset' => 'Reset to Defaults',
          'settings.general.languages_editor.add_language' =>
            ({required Object name}) => 'Add ${name} to common languages',
          'settings.general.languages_editor.remove_language' =>
            ({required Object name}) => 'Remove ${name} from common languages',
          'settings.general.languages_editor.handle_label' => (
                  {required Object name, required Object position}) =>
              '${name}, position ${position}, press up or down to reorder',
          'settings.appearance.title' => 'Appearance',
          'settings.appearance.section.app_language' => 'Display Language',
          'settings.appearance.section.theme_mode' => 'Theme Mode',
          'settings.appearance.section.theme_style' => 'Theme style',
          'settings.appearance.footer' =>
            'Changes apply to the whole window immediately.',
          'settings.shortcuts.title' => 'Shortcuts',
          'settings.shortcuts.section.text_extraction' => 'Text Extraction',
          'settings.shortcuts.section.submit_mode' => 'Submit With',
          'settings.shortcuts.row.toggle_mini_translator' => 'Show/Hide Window',
          'settings.shortcuts.row.extract_text_from_screen_selection' =>
            'Extract text from screen selection',
          'settings.shortcuts.row.extract_text_from_screen_capture' =>
            'Extract text from screen capture',
          'settings.shortcuts.row.extract_text_from_clipboard' =>
            'Extract text from clipboard',
          'settings.shortcuts.reset_dialog.title' => 'Reset Shortcuts',
          'settings.shortcuts.reset_dialog.message' =>
            'Reset all shortcuts to their defaults? Any bindings you changed will be overwritten.',
          'settings.shortcuts.reset_dialog.confirm' => 'Reset',
          'settings.shortcuts.reset_dialog.cancel' => 'Cancel',
          'settings.shortcuts.group.global.title' => 'Global Shortcuts',
          'settings.shortcuts.group.global.description' => 'Work in any app.',
          'settings.shortcuts.group.in_app.title' => 'In-App Keys',
          'settings.shortcuts.group.in_app.description' =>
            'Only apply inside this app’s own text fields.',
          'settings.shortcuts.reset' => 'Restore Defaults...',
          'settings.shortcuts.record_placeholder' => 'Record shortcut',
          'settings.shortcuts.recording' => 'Press keys…',
          'settings.shortcuts.clear' => 'Clear',
          'settings.shortcuts.conflict' => ({required Object label}) =>
              'Conflicts with “${label}”',
          'settings.advanced.title' => 'Advanced',
          'settings.advanced.api_server' => 'Local API server',
          'settings.advanced.api_server_description' =>
            'Expose the translation API on 127.0.0.1 for local integrations.',
          'settings.advanced.enable' => 'Enable',
          'settings.advanced.port' => 'Port',
          'settings.advanced.running_at' => 'Running at {url}',
          'settings.advanced.disabled' => 'Disabled',
          'settings.services.title' => 'Services',
          'settings.services.button.add_service' => 'Add Service...',
          'settings.services.section.available_services' =>
            'Available Services',
          'settings.services.editor.title' => 'Add Service',
          'settings.services.editor.subtitle' =>
            'Add one more service to a configured provider',
          'settings.services.editor.row.model' => 'Model',
          'settings.services.editor.row.system_prompt' => 'System Prompt',
          'settings.services.editor.prompt_placeholder' =>
            'Leave blank to use the default prompt for this kind',
          'settings.services.editor.variant_hint' =>
            '{} already has a {} service; this one is added alongside it as a second configuration.',
          'settings.services.editor.traditional_note' =>
            '{} is a traditional endpoint — no model or prompt to tune. Its parameters live on the provider\'s detail page.',
          'settings.services.detail.row.id' => 'Service ID',
          'settings.services.detail.row.name' => 'Name',
          'settings.services.detail.row.provider' => 'Provider',
          'settings.services.detail.row.type' => 'Type',
          'settings.services.detail.delete_dialog.title' => 'Delete "{}"?',
          'settings.services.detail.delete_dialog.message' =>
            'This service will be removed from the provider.',
          'settings.services.detail.prompt_variables' =>
            'Available variables: {{sourceLanguage}}, {{targetLanguage}}, {{text}}',
          'settings.services.make_default' => 'Make Default',
          'settings.services.item.none_of_kind' =>
            'No {} service available yet.',
          'settings.services.go_to_providers' => 'Go to Providers',
          'settings.services.go_to_providers_hint' =>
            'Services come from providers — set one up on the Providers page first.',
          'settings.services.capability.translation' => 'Translation',
          'settings.services.capability.dictionary' => 'Dictionary',
          'settings.services.capability.ocr' => 'Text Recognition',
          'settings.services.permissions_missing.title' =>
            'System permissions not granted',
          'settings.services.permissions_missing.hint' =>
            'Screenshot and selection capture need screen recording and accessibility access.',
          'settings.services.permissions_missing.open_general' =>
            'Open General',
          'settings.providers.title' => 'Providers',
          'settings.providers.section.services' => 'Available Services',
          'settings.providers.section.services_description' =>
            'View available services from configured providers and switch between service types.',
          'settings.providers.section.count' => 'Providers · {}',
          'settings.providers.item.loading' => 'Loading providers...',
          'settings.providers.button.add' => 'Add a Provider...',
          'settings.providers.alert.error' => 'Error',
          'settings.providers.intro.body' =>
            'Manage the service providers used by the app.',
          'settings.providers.intro.warning' =>
            'Connected providers may process the text or images you send. Only enable services you trust.',
          'settings.providers.editor.row.id' => 'Provider ID',
          'settings.providers.editor.row.type' => 'Provider Type',
          'settings.providers.editor.row.default_model' => 'Default Model',
          'settings.providers.editor.placeholder.id' => 'e.g. deepl-main',
          'settings.providers.editor.type_picker.prompt' =>
            'Select the type of provider you would like to add:',
          'settings.providers.editor.type_picker.section_llm' => 'LLM',
          'settings.providers.editor.type_picker.section_traditional' =>
            'Traditional',
          'settings.providers.editor.tooltip.help' => 'Help',
          'settings.providers.editor.step.next' => 'Continue',
          'settings.providers.editor.step.back' => 'Back',
          'settings.providers.editor.add_title' => 'Add {}',
          'settings.providers.editor.capability_note.translation' =>
            'Joins the translation candidates',
          'settings.providers.editor.capability_note.dictionary' =>
            'Provides dictionary definitions',
          'settings.providers.editor.capability_note.ocr' =>
            'Recognises text in images',
          'settings.providers.editor.test.run' => 'Test Connection',
          'settings.providers.editor.test.running' =>
            'Testing connection · {}s elapsed',
          'settings.providers.editor.test.passed_models' =>
            'Connection OK · {} models available',
          'settings.providers.editor.test.passed_service' =>
            'Connection OK · service available',
          'settings.providers.editor.test.passed_footer' =>
            'Connection test passed',
          'settings.providers.editor.test.retest' => 'Test Again',
          'settings.providers.editor.test.tips_title' => 'Things to try',
          'settings.providers.editor.test.tips_llm' =>
            '· Check the key matches the provider type you picked\n· Check whether the Base URL needs /v1\n· Confirm the model is enabled in the provider console',
          'settings.providers.editor.test.tips_traditional' =>
            '· Check the credentials match the provider type you picked\n· Confirm the service is enabled in the provider console',
          'settings.providers.editor.test.failed_suffix' =>
            'verification failed',
          'settings.providers.editor.test.passed_suffix' => 'verified',
          'settings.providers.detail.tooltip.edit' => 'Edit provider',
          'settings.providers.detail.section.configuration' => 'Configuration',
          'settings.providers.detail.section.models' => 'Models',
          'settings.providers.detail.section.services' =>
            'Services from This Provider',
          'settings.providers.detail.models.loading' => 'Loading models...',
          'settings.providers.detail.models.empty' => 'No models found.',
          'settings.providers.detail.models.retry' => 'Retry',
          'settings.providers.detail.models.refresh' => 'Refresh List',
          'settings.providers.detail.models.default_badge' => 'Default',
          'settings.providers.detail.models.set_default' => 'Set as Default',
          'settings.providers.detail.models.fetching' =>
            'Asking the endpoint for its model list…',
          'settings.providers.detail.models.fetch_failed_title' =>
            'Couldn\'t fetch models',
          'settings.providers.detail.models.fetch_failed_body' =>
            'The endpoint didn\'t respond, or it doesn\'t accept this key. Once the address and key are right, you can try again.',
          'settings.providers.detail.models.empty_answer' =>
            'The endpoint answered but listed no models — typing a model name by hand works too.',
          'settings.providers.detail.models.test_draft' => 'Test New Settings',
          'settings.providers.detail.models.draft_note' =>
            'These models were fetched with unsaved values — they count once you press Save.',
          'settings.providers.detail.models.locked' =>
            'Enter a key and save, and Refresh List fetches the models this provider offers.',
          'settings.providers.detail.models.manual_placeholder' =>
            'Enter a model name',
          'settings.providers.detail.button.saving' => 'Saving',
          'settings.providers.detail.button.add_service' => 'Add Service...',
          'settings.providers.detail.button.clear_key' => 'Clear Key',
          'settings.providers.detail.receipt.problems_title' =>
            'This configuration can\'t be saved yet',
          'settings.providers.detail.receipt.saved_title' => 'Saved',
          'settings.providers.detail.receipt.saved_body' =>
            'This provider\'s configuration has been written.',
          'settings.providers.detail.receipt.save_failed_title' =>
            'Couldn\'t save',
          'settings.providers.detail.receipt.delete_failed_title' =>
            'Couldn\'t delete',
          'settings.providers.detail.receipt.add_service_failed_title' =>
            'Couldn\'t add the service',
          'settings.providers.detail.receipt.saved_rejected_title' =>
            'Saved, but the endpoint didn’t accept it',
          'settings.providers.detail.receipt.saved_rejected_body' =>
            'The configuration was written, but fetching the model list with it failed — try another key and save again.',
          'settings.providers.detail.receipt.saved_verifying' =>
            'Saved. Checking the connection…',
          'settings.providers.detail.problem.item' => '{}: {}',
          'settings.providers.detail.problem.separator' => '; ',
          'settings.providers.detail.problem.required' => 'Required',
          'settings.providers.detail.problem.url_scheme' =>
            'Must start with http:// or https://',
          'settings.providers.detail.problem.url_protocol' =>
            'Only http:// and https:// are accepted',
          'settings.providers.detail.problem.url_host' => 'Missing a host name',
          'settings.providers.detail.problem.no_model' =>
            'No model yet — fetch the list first, or enter a model name.',
          'settings.providers.detail.field.fallback_hint' =>
            'Leave blank to use {}',
          'settings.providers.detail.field.show_secret' => 'Show {}',
          'settings.providers.detail.field.hide_secret' => 'Hide {}',
          'settings.providers.detail.field.secret_stored' =>
            'Saved · Leave blank to keep',
          'settings.providers.detail.field.secret_empty' => 'Enter key',
          'settings.providers.detail.no_fields' =>
            'Nothing to fill in — it works as soon as it is installed; the lines above are only a description.',
          'settings.providers.detail.services_empty' => 'No services yet',
          'settings.providers.detail.services_locked' =>
            'Enter a key and save to add services from this provider.',
          'settings.providers.capability.translation' => 'Translation',
          'settings.providers.capability.dictionary' => 'Dictionary',
          'settings.providers.capability.ocr' => 'OCR',
          'settings.providers.capability.llm' => 'AI',
          'settings.providers.description.all' =>
            'Provides dictionary lookup and text translation',
          'settings.providers.description.dictionary' =>
            'Provides dictionary lookup and word definitions',
          'settings.providers.description.translation' =>
            'Provides text translation between languages',
          'settings.providers.description.fallback' =>
            'Provides translation services',
          'settings.providers.need.anthropic' => 'Needs an API key',
          'settings.providers.need.openai' => 'Needs an API key',
          'settings.providers.need.gemini' => 'Needs an API key',
          'settings.providers.need.deepseek' => 'Needs an API key',
          'settings.providers.need.qwen' => 'Needs a Model Studio API key',
          'settings.providers.need.moonshot' => 'Needs a Moonshot API key',
          'settings.providers.need.doubao' => 'Needs a Volcano Ark API key',
          _ => null,
        } ??
        switch (path) {
          'settings.providers.need.zhipu' =>
            'Needs a Zhipu Open Platform API key',
          'settings.providers.need.xai' => 'Needs an xAI API key',
          'settings.providers.need.groq' => 'Needs a Groq API key',
          'settings.providers.need.ollama' => 'Runs on this Mac · No API key',
          'settings.providers.need.openai_compatible' =>
            'Self-hosted or aggregator endpoint · Bring your own Base URL',
          'settings.providers.status.unconfigured' => 'Not set up',
          'settings.providers.status.unverified' => 'Unverified',
          'settings.providers.status.invalid' => 'Needs attention',
          'settings.providers.meta.key_valid' => 'Key valid',
          'settings.providers.meta.reachable' => 'Connected',
          'settings.providers.meta.invalid' => 'Key rejected · Needs attention',
          'settings.providers.search.button' => 'Search',
          'settings.providers.search.placeholder' =>
            'Search provider name or id',
          'settings.providers.search.label' => 'Search providers',
          'settings.providers.search.clear' => 'Clear Search',
          'settings.providers.search.no_match_title' => 'No matching providers',
          'settings.providers.search.no_match_body' =>
            'Nothing found for “{}”.',
          'settings.providers.discard_dialog.title' =>
            'Discard unsaved changes?',
          'settings.providers.discard_dialog.message' =>
            'What you entered on this page hasn’t been saved and will be lost if you leave.',
          'settings.providers.discard_dialog.confirm' => 'Discard',
          'settings.providers.discard_dialog.cancel' => 'Keep Editing',
          'settings.providers.clear_dialog.title' => 'Clear Key',
          'settings.providers.clear_dialog.message' =>
            '{} goes back to “Not set up”, and the services it provides are removed with it. The key you entered is cleared.',
          'settings.providers.clear_dialog.confirm' => 'Clear',
          'settings.layout.title' => 'Settings',
          'settings.layout.empty.title' => 'Select a Category',
          'settings.layout.empty.message' =>
            'Choose a settings section from the sidebar.',
          'settings.layout.groups' => 'Groups',
          'settings.layout.footer_note' =>
            'Translations and keys stay on this Mac',
          'settings.layout.support' => 'Support',
          'settings.about.title' => 'About',
          'settings.about.copy_version_info' => 'Copy Version Info',
          'settings.about.up_to_date' => 'You\'re up to date',
          'settings.about.links' => 'Links',
          'settings.about.website' => 'Website',
          'settings.about.help_center' => 'Help Center',
          'settings.about.open_changelog' => 'Changelog',
          'settings.about.update' => 'Update',
          'settings.about.software_update' => 'Software Update',
          _ => null,
        };
  }
}
