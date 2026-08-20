///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsKo extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsKo(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.ko,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(
            cardinalResolver: cardinalResolver,
            ordinalResolver: ordinalResolver) {
    super.$meta.setFlatMapFunction(
        $meta.getTranslation); // copy base translations to super.$meta
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <ko>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsKo _root = this; // ignore: unused_field

  @override
  TranslationsKo $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsKo(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonKo common = _TranslationsCommonKo._(_root);
  @override
  late final _TranslationsAppKo app = _TranslationsAppKo._(_root);
  @override
  late final _TranslationsMiniTranslatorKo mini_translator =
      _TranslationsMiniTranslatorKo._(_root);
  @override
  late final _TranslationsWorkbenchKo workbench =
      _TranslationsWorkbenchKo._(_root);
  @override
  late final _TranslationsSettingsKo settings =
      _TranslationsSettingsKo._(_root);
}

// Path: common
class _TranslationsCommonKo extends TranslationsCommonEn {
  _TranslationsCommonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiKo ui = _TranslationsCommonUiKo._(_root);
  @override
  late final _TranslationsCommonLanguageKo language =
      _TranslationsCommonLanguageKo._(_root);
  @override
  late final _TranslationsCommonThemeModeKo theme_mode =
      _TranslationsCommonThemeModeKo._(_root);
  @override
  late final _TranslationsCommonThemeStyleKo theme_style =
      _TranslationsCommonThemeStyleKo._(_root);
  @override
  late final _TranslationsCommonProviderKo provider =
      _TranslationsCommonProviderKo._(_root);
}

// Path: app
class _TranslationsAppKo extends TranslationsAppEn {
  _TranslationsAppKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayKo tray = _TranslationsAppTrayKo._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorKo extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerKo limited_banner =
      _TranslationsMiniTranslatorLimitedBannerKo._(_root);
  @override
  late final _TranslationsMiniTranslatorInputKo input =
      _TranslationsMiniTranslatorInputKo._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarKo toolbar =
      _TranslationsMiniTranslatorToolbarKo._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonKo button =
      _TranslationsMiniTranslatorButtonKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageKo language =
      _TranslationsMiniTranslatorLanguageKo._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageKo message =
      _TranslationsMiniTranslatorMessageKo._(_root);
  @override
  late final _TranslationsMiniTranslatorResultKo result =
      _TranslationsMiniTranslatorResultKo._(_root);
}

// Path: workbench
class _TranslationsWorkbenchKo extends TranslationsWorkbenchEn {
  _TranslationsWorkbenchKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get workspace => '작업 공간';
  @override
  String get translate => '번역';
  @override
  String get history => '기록';
  @override
  late final _TranslationsWorkbenchHistoryPageKo history_page =
      _TranslationsWorkbenchHistoryPageKo._(_root);
  @override
  String get glossary => '용어집';
  @override
  String get recent_languages => '최근 언어';
  @override
  String get not_configured => '설정되지 않음';
  @override
  late final _TranslationsWorkbenchSubtitleKo subtitle =
      _TranslationsWorkbenchSubtitleKo._(_root);
  @override
  late final _TranslationsWorkbenchPlaceholderKo placeholder =
      _TranslationsWorkbenchPlaceholderKo._(_root);
  @override
  late final _TranslationsWorkbenchGlossaryPageKo glossary_page =
      _TranslationsWorkbenchGlossaryPageKo._(_root);
  @override
  late final _TranslationsWorkbenchTranslationKo translation =
      _TranslationsWorkbenchTranslationKo._(_root);
  @override
  late final _TranslationsWorkbenchStatusKo status =
      _TranslationsWorkbenchStatusKo._(_root);
  @override
  String get version_latest => '최신 버전입니다';
  @override
  String get version_checking => '확인 중…';
  @override
  String get check_updates => '업데이트 확인';
}

// Path: settings
class _TranslationsSettingsKo extends TranslationsSettingsEn {
  _TranslationsSettingsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'v{} (Build {})';
  @override
  late final _TranslationsSettingsGeneralKo general =
      _TranslationsSettingsGeneralKo._(_root);
  @override
  late final _TranslationsSettingsAppearanceKo appearance =
      _TranslationsSettingsAppearanceKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsKo shortcuts =
      _TranslationsSettingsShortcutsKo._(_root);
  @override
  late final _TranslationsSettingsAdvancedKo advanced =
      _TranslationsSettingsAdvancedKo._(_root);
  @override
  late final _TranslationsSettingsServicesKo services =
      _TranslationsSettingsServicesKo._(_root);
  @override
  late final _TranslationsSettingsProvidersKo providers =
      _TranslationsSettingsProvidersKo._(_root);
  @override
  late final _TranslationsSettingsLayoutKo layout =
      _TranslationsSettingsLayoutKo._(_root);
  @override
  late final _TranslationsSettingsAboutKo about =
      _TranslationsSettingsAboutKo._(_root);
}

// Path: common.ui
class _TranslationsCommonUiKo extends TranslationsCommonUiEn {
  _TranslationsCommonUiKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonKo button =
      _TranslationsCommonUiButtonKo._(_root);
  @override
  late final _TranslationsCommonUiFeedbackKo feedback =
      _TranslationsCommonUiFeedbackKo._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageKo extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get ar => '아랍어';
  @override
  String get bn => '벵골어';
  @override
  String get de => '독일어';
  @override
  String get en => '영어';
  @override
  String get es => '스페인어';
  @override
  String get fa => '페르시아어';
  @override
  String get fr => '프랑스어';
  @override
  String get gu => '구자라트어';
  @override
  String get ha => '하우사어';
  @override
  String get hi => '힌디어';
  @override
  String get id => '인도네시아어';
  @override
  String get it => '이탈리아어';
  @override
  String get ja => '일본어';
  @override
  String get jv => '자바어';
  @override
  String get ko => '한국어';
  @override
  String get ml => '말라얄람어';
  @override
  String get mr => '마라티어';
  @override
  String get ms => '말레이어';
  @override
  String get nl => '네덜란드어';
  @override
  String get pa => '펀자브어';
  @override
  String get pl => '폴란드어';
  @override
  String get pt => '포르투갈어';
  @override
  String get ro => '루마니아어';
  @override
  String get ru => '러시아어';
  @override
  String get sw => '스와힐리어';
  @override
  String get ta => '타밀어';
  @override
  String get te => '텔루구어';
  @override
  String get th => '태국어';
  @override
  String get tr => '터키어';
  @override
  String get uk => '우크라이나어';
  @override
  String get ur => '우르두어';
  @override
  String get vi => '베트남어';
  @override
  String get yo => '요루바어';
  @override
  String get zh_hans => '중국어(간체)';
  @override
  String get zh_hant => '중국어(번체)';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeKo extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get light => '라이트';
  @override
  String get dark => '다크';
  @override
  String get system => '시스템';
}

// Path: common.theme_style
class _TranslationsCommonThemeStyleKo extends TranslationsCommonThemeStyleEn {
  _TranslationsCommonThemeStyleKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get studio => 'Studio';
  @override
  String get bright => 'Bright';
}

// Path: common.provider
class _TranslationsCommonProviderKo extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get anthropic => 'Anthropic';
  @override
  String get baidu => 'Baidu';
  @override
  String get caiyun => 'Caiyun';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => 'Google';
  @override
  String get ollama => 'Ollama';
  @override
  String get openai => 'OpenAI';
  @override
  String get sogou => 'Sogou';
  @override
  String get xai => 'xAI';
  @override
  String get system => '시스템';
  @override
  String get tencent => 'Tencent';
  @override
  String get youdao => 'Youdao';
}

// Path: app.tray
class _TranslationsAppTrayKo extends TranslationsAppTrayEn {
  _TranslationsAppTrayKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuKo context_menu =
      _TranslationsAppTrayContextMenuKo._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerKo
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionKo permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionKo instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionKo action =
      _TranslationsMiniTranslatorLimitedBannerActionKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackKo feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipKo tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipKo._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputKo
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '단어나 텍스트를 입력하세요';
  @override
  String get extracting_text => '텍스트 추출 중...';
  @override
  String hint_translate_to({required Object language}) =>
      '단어나 텍스트를 입력해 ${language}(으)로 번역';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarKo
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipKo tooltip =
      _TranslationsMiniTranslatorToolbarTooltipKo._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarMenuKo menu =
      _TranslationsMiniTranslatorToolbarMenuKo._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonKo
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get clear => '지우기';
  @override
  String get translate => '번역';
  @override
  String get copy => '복사';
  @override
  String get copied => '복사됨';
  @override
  String get bookmark => '저장';
  @override
  String get bookmarked => '저장됨';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageKo
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => '자동 감지';
  @override
  String get auto_match => '자동 일치';
  @override
  String get switch_config => '대상 전환';
  @override
  String get more_languages => '더 많은 언어...';
  @override
  String get manage_common_languages => '자주 사용하는 언어 관리...';
  @override
  String get manage_targets => '번역 대상 관리...';
  @override
  String get add_target => '번역 대상 추가...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageKo
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => '입력된 텍스트가 없거나 텍스트를 추출하지 못했습니다';
  @override
  String get capture_screen_area_canceled => '화면 영역 캡처가 취소되었습니다';
  @override
  String get ocr_service_not_configured =>
      '기본 텍스트 인식 서비스가 설정되지 않았습니다. 설정에서 설정해주세요.';
  @override
  String get ocr_recognition_failed => '텍스트 인식 실패';
}

// Path: mini_translator.result
class _TranslationsMiniTranslatorResultKo
    extends TranslationsMiniTranslatorResultEn {
  _TranslationsMiniTranslatorResultKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get translating => '번역 중…';
  @override
  String stale_requery({required Object key}) => '원문이 수정됨 · ${key} 다시 번역';
  @override
  String compare_services({required Object count}) => '서비스 ${count}개 비교';
  @override
  String get collapse_compare => '비교 접기';
  @override
  String get set_preferred => '기본으로 설정';
  @override
  String get retry => '다시 시도';
  @override
  String get no_result =>
      '어떤 서비스도 결과를 반환하지 않았습니다. 네트워크를 확인하거나 다른 서비스을 사용해 보세요.';
  @override
  String get no_result_note => '원문은 유지되며, 다시 시도해도 기록이 중복되지 않습니다.';
}

// Path: workbench.history_page
class _TranslationsWorkbenchHistoryPageKo
    extends TranslationsWorkbenchHistoryPageEn {
  _TranslationsWorkbenchHistoryPageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get all => '전체';
  @override
  String get favorites => '즐겨찾기';
  @override
  String get edited => '내가 수정함';
  @override
  String get search => '검색';
  @override
  String get search_placeholder => '원문, 번역문 또는 서비스 검색';
  @override
  String get search_label => '기록 검색';
  @override
  String entry_count({required Object label, required Object count}) =>
      '${label} · ${count}개';
  @override
  String get by_time => '시간순';
  @override
  String get loading => '기록 불러오는 중…';
  @override
  String get load_failed => '기록을 불러오지 못했습니다';
  @override
  String get retry => '다시 시도';
  @override
  String get empty_title => '번역 기록이 없습니다';
  @override
  String get empty_description => '번역이 완료되면 선호 번역이 여기에 저장됩니다.';
  @override
  String no_results({required Object query}) => '“${query}”와 일치하는 기록이 없습니다';
  @override
  String get clear_search => '검색 지우기';
  @override
  String get select => '다중 선택';
  @override
  String selected_count({required Object count}) => '${count}개 선택됨';
  @override
  String get exit_select => '선택 종료';
  @override
  String get add_to_glossary => '용어집에 추가';
  @override
  String get favorite => '즐겨찾기';
  @override
  String get unfavorite => '즐겨찾기 해제';
  @override
  String delete_confirm({required Object count}) =>
      '선택한 기록 ${count}개를 삭제할까요? 되돌릴 수 없습니다.';
  @override
  String get no_glossary => '먼저 용어집을 만드세요';
  @override
  String added_to_glossary({required Object count}) =>
      '기록 ${count}개를 용어집에 추가했습니다';
  @override
  String get favorite_flag => '즐겨찾기';
  @override
  String get edited_flag => '수정됨';
  @override
  String get edit_history_hint => '수정한 번역은 기록에 저장됩니다';
}

// Path: workbench.subtitle
class _TranslationsWorkbenchSubtitleKo extends TranslationsWorkbenchSubtitleEn {
  _TranslationsWorkbenchSubtitleKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get translate => '워크벤치 · 서비스 비교';
  @override
  String get settings => '설정';
}

// Path: workbench.placeholder
class _TranslationsWorkbenchPlaceholderKo
    extends TranslationsWorkbenchPlaceholderEn {
  _TranslationsWorkbenchPlaceholderKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get history => '즐겨찾기와 기록은 향후 버전에서 제공됩니다';
  @override
  String get glossary => '용어집 관리를 개발 중입니다';
}

// Path: workbench.glossary_page
class _TranslationsWorkbenchGlossaryPageKo
    extends TranslationsWorkbenchGlossaryPageEn {
  _TranslationsWorkbenchGlossaryPageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add_entry => '용어 추가';
  @override
  String get term => '원문';
  @override
  String get translation => '지정 번역';
  @override
  String get forbidden => '금지';
  @override
  String get hits => '적중';
  @override
  String get term_placeholder => 'teacher forcing';
  @override
  String get translation_placeholder => '교사 강요';
  @override
  String get forbidden_placeholder => '강제 교육';
  @override
  String get search => '검색';
  @override
  String get search_placeholder => '용어 또는 지정 번역 검색';
  @override
  String get search_label => '용어집 검색';
  @override
  String entry_count({required Object name, required Object count}) =>
      '${name} · ${count}개';
  @override
  String get priority_note => '용어집은 어떤 서비스 출력보다 우선합니다';
  @override
  String get new_book => '용어집 만들기';
  @override
  String get new_book_placeholder => '용어집 이름';
  @override
  String get rename_book => '이름 바꾸기';
  @override
  String delete_book_confirm({required Object name, required Object count}) =>
      '“${name}”과(와) 그 안의 용어 ${count}개를 삭제할까요?';
  @override
  String get disabled => '사용 안 함';
  @override
  String get enable => '사용';
  @override
  String get disable => '사용 안 함';
  @override
  String get empty_title => '이 용어집은 비어 있습니다';
  @override
  String get empty_description =>
      '용어집은 어떤 서비스 출력보다 우선합니다. 하나씩 추가하거나 CSV를 끌어다 놓아 병합하세요.';
  @override
  String no_results_title({required Object query}) =>
      '“${query}”와(과) 일치하는 용어가 없습니다';
  @override
  String get no_results_description => '다른 키워드를 쓰거나 새로 추가해 보세요.';
  @override
  String get no_books_title => '아직 용어집이 없습니다';
  @override
  String get no_books_description =>
      '용어집은 선택한 번역어를 모든 서비스에서 일관되게 유지합니다. 먼저 하나 만들고 용어를 추가하세요.';
  @override
  String get loading => '불러오는 중…';
}

// Path: workbench.translation
class _TranslationsWorkbenchTranslationKo
    extends TranslationsWorkbenchTranslationEn {
  _TranslationsWorkbenchTranslationKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get source => '원문';
  @override
  String get target => '번역문';
  @override
  String get input_hint => '번역할 텍스트를 입력하거나 붙여넣으세요';
  @override
  String get button => '번역';
  @override
  String get auto_detected => '자동 감지됨';
  @override
  String get loading_services => '번역 서비스를 불러오는 중…';
  @override
  String get no_services => '먼저 설정에서 번역 서비스를 구성하세요';
  @override
  String get translating => '번역 중…';
  @override
  String get failed => '번역에 실패했습니다. 서비스 설정을 확인하세요.';
  @override
  String get empty => '번역문이 여기에 표시됩니다';
  @override
  String get service_compare => '서비스 비교';
  @override
  String get main_translation => '기본 번역';
  @override
  String get service_unavailable => '서비스를 사용할 수 없음';
  @override
  String get waiting => '번역 대기';
  @override
  String get copy => '복사';
  @override
  String get favorite_unavailable => '즐겨찾기는 향후 버전에서 제공됩니다';
  @override
  String get preferred => '기본 번역';
  @override
  String get other_services => '다른 서비스';
  @override
  String get copy_result => '번역 복사';
  @override
  String get copied => '복사됨';
  @override
  String get favorite => '저장';
  @override
  String get terms => '용어 일치';
  @override
  String get terms_hint => '입력하면 용어집과 대조합니다.';
  @override
  String get quality => '품질 신호';
  @override
  String get quality_hint => '번역이 완료되면 계산됩니다.';
  @override
  String get shortcuts => '단축키';
  @override
  String get other_services_disabled => '다른 서비스이 비활성화됨';
  @override
  String input_hint_translate_to({required Object language}) =>
      '번역할 텍스트를 입력하거나 붙여넣어 ${language}(으)로 번역';
}

// Path: workbench.status
class _TranslationsWorkbenchStatusKo extends TranslationsWorkbenchStatusEn {
  _TranslationsWorkbenchStatusKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get runtime_ready => '번역 런타임 준비 완료';
  @override
  String get settings_synced => '설정 동기화됨';
  @override
  String get shortcuts => '⌥Space 빠른 창 · ⌥⇧2 캡처';
}

// Path: settings.general
class _TranslationsSettingsGeneralKo extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '일반';
  @override
  late final _TranslationsSettingsGeneralSectionKo section =
      _TranslationsSettingsGeneralSectionKo._(_root);
  @override
  late final _TranslationsSettingsGeneralRowKo row =
      _TranslationsSettingsGeneralRowKo._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonKo button =
      _TranslationsSettingsGeneralButtonKo._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionKo option =
      _TranslationsSettingsGeneralOptionKo._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorKo editor =
      _TranslationsSettingsGeneralEditorKo._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceKo
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '외관';
  @override
  late final _TranslationsSettingsAppearanceSectionKo section =
      _TranslationsSettingsAppearanceSectionKo._(_root);
  @override
  String get footer => '변경 사항은 창 전체에 즉시 적용됩니다.';
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsKo extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '단축키';
  @override
  late final _TranslationsSettingsShortcutsSectionKo section =
      _TranslationsSettingsShortcutsSectionKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowKo row =
      _TranslationsSettingsShortcutsRowKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogKo reset_dialog =
      _TranslationsSettingsShortcutsResetDialogKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsGroupKo group =
      _TranslationsSettingsShortcutsGroupKo._(_root);
  @override
  String get reset => '기본값 복원...';
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedKo extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '고급';
  @override
  String get api_server => '로컬 API 서버';
  @override
  String get api_server_description => '로컬 통합을 위해 127.0.0.1에서 번역 API를 노출합니다.';
  @override
  String get enable => '활성화';
  @override
  String get port => '포트';
  @override
  String get running_at => '{url}에서 실행 중';
  @override
  String get disabled => '비활성화됨';
}

// Path: settings.services
class _TranslationsSettingsServicesKo extends TranslationsSettingsServicesEn {
  _TranslationsSettingsServicesKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '서비스';
  @override
  late final _TranslationsSettingsServicesButtonKo button =
      _TranslationsSettingsServicesButtonKo._(_root);
  @override
  late final _TranslationsSettingsServicesSectionKo section =
      _TranslationsSettingsServicesSectionKo._(_root);
  @override
  late final _TranslationsSettingsServicesEditorKo editor =
      _TranslationsSettingsServicesEditorKo._(_root);
  @override
  late final _TranslationsSettingsServicesDetailKo detail =
      _TranslationsSettingsServicesDetailKo._(_root);
  @override
  String get make_default => '기본으로 설정';
  @override
  late final _TranslationsSettingsServicesItemKo item =
      _TranslationsSettingsServicesItemKo._(_root);
}

// Path: settings.providers
class _TranslationsSettingsProvidersKo extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '제공자';
  @override
  late final _TranslationsSettingsProvidersSectionKo section =
      _TranslationsSettingsProvidersSectionKo._(_root);
  @override
  late final _TranslationsSettingsProvidersItemKo item =
      _TranslationsSettingsProvidersItemKo._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonKo button =
      _TranslationsSettingsProvidersButtonKo._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertKo alert =
      _TranslationsSettingsProvidersAlertKo._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroKo intro =
      _TranslationsSettingsProvidersIntroKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorKo editor =
      _TranslationsSettingsProvidersEditorKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailKo detail =
      _TranslationsSettingsProvidersDetailKo._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityKo capability =
      _TranslationsSettingsProvidersCapabilityKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionKo description =
      _TranslationsSettingsProvidersDescriptionKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogKo delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogKo._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutKo extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '설정';
  @override
  late final _TranslationsSettingsLayoutEmptyKo empty =
      _TranslationsSettingsLayoutEmptyKo._(_root);
  @override
  String get groups => '설정 그룹';
  @override
  String get effect_hint => '변경 사항 즉시 적용';
  @override
  String get footer_note => '번역과 키는 이 기기에만 저장됩니다';
  @override
  String get support => '지원';
}

// Path: settings.about
class _TranslationsSettingsAboutKo extends TranslationsSettingsAboutEn {
  _TranslationsSettingsAboutKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '정보';
  @override
  String get copy_version_info => '버전 정보 복사';
  @override
  String get up_to_date => '최신 버전입니다.';
  @override
  String get check_again => '다시 확인';
  @override
  String get links => '링크';
  @override
  String get website => '웹사이트';
  @override
  String get github => 'GitHub';
  @override
  String get report_issue => '문제 보고';
  @override
  String get license => '라이선스';
  @override
  String get open_changelog => '변경 내역 열기';
  @override
  String get update => '업데이트';
}

// Path: common.ui.button
class _TranslationsCommonUiButtonKo extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get ok => '확인';
  @override
  String get cancel => '취소';
  @override
  String get add => '추가';
  @override
  String get delete => '삭제';
  @override
  String get edit => '편집';
  @override
  String get save => '저장';
  @override
  String get manage => '관리';
  @override
  String get kContinue => '계속';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackKo extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get copied => '복사됨';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuKo
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => '창 보기';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsKo dev_tools =
      _TranslationsAppTrayContextMenuDevToolsKo._(_root);
  @override
  String get check_for_updates => '업데이트 확인';
  @override
  String get settings => '설정';
  @override
  String get quit => '종료';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionKo
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => '모든 기능을 사용하려면 화면 녹화 및 손쉬운 사용 권한을 부여하세요.';
  @override
  String get missing_screen_capture => '모든 기능을 사용하려면 화면 녹화 권한을 부여하세요.';
  @override
  String get missing_accessibility => '모든 기능을 사용하려면 손쉬운 사용 권한을 부여하세요.';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionKo
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => '';
  @override
  String get follow_guide_prefix => '로 이동하여 안내를 따라 ';
  @override
  String get suffix => '을(를) 클릭하세요.';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionKo
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => '앱 설정';
  @override
  String get recheck => '재확인';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackKo
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '화면 텍스트 추출이 활성화되었습니다.';
  @override
  String get still_missing => '필요한 권한이 아직 부여되지 않았습니다.\n설정을 확인한 후 다시 시도해 주세요.';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipKo
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get help => '도움말 보기';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipKo
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture => '화면 영역을 캡처하여 텍스트 인식';
  @override
  String get extract_text_from_clipboard => '클립보드 내용 읽기';
  @override
  String get pin => '창 고정';
  @override
  String get more_actions => '더 보기';
}

// Path: mini_translator.toolbar.menu
class _TranslationsMiniTranslatorToolbarMenuKo
    extends TranslationsMiniTranslatorToolbarMenuEn {
  _TranslationsMiniTranslatorToolbarMenuKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get extract_from_screen_capture => '화면에서 추출';
  @override
  String get extract_from_clipboard => '클립보드에서 추출';
  @override
  String get open_main_window => '메인 창 열기';
  @override
  String get open_settings => '설정…';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionKo
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => '시스템 권한';
  @override
  String get ocr => '텍스트 인식';
  @override
  String get directory => '사전';
  @override
  String get translation => '번역';
  @override
  String get translation_target => '번역 대상';
  @override
  String get languages => '언어';
  @override
  String get input => '입력 설정';
  @override
  String get startup => '시작 및 통합';
  @override
  String get ocr_behaviour => '가져오기 동작';
  @override
  String get translation_behaviour => '번역 동작';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowKo
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_login => '로그인할 때 시작';
  @override
  String get show_in_menu_bar => '메뉴 막대에 표시';
  @override
  String get screen_capture_access => '화면 기록 접근 권한 부여';
  @override
  String get screen_selection_access => '손쉬운 사용 접근 권한 부여';
  @override
  String get default_ocr_service => '기본 텍스트 인식 서비스';
  @override
  String get auto_copy_detected_text => '감지된 텍스트 자동 복사';
  @override
  String get default_directory_service => '기본 사전 서비스';
  @override
  String get default_translation_service => '기본 번역 서비스';
  @override
  String get translation_target_hint => '번역기에 사용할 언어 쌍을 설정합니다.';
  @override
  String get common_languages => '자주 사용하는 언어';
  @override
  String get common_languages_description => '자주 사용하는 언어는 언어 선택기 상단에 표시됩니다.';
  @override
  String get common_languages_hint => '자주 사용하는 언어를 선택하세요:';
  @override
  String get common_languages_sort => '코드로 정렬';
  @override
  String get common_languages_reset => '기본값으로 재설정';
  @override
  String get common_languages_reset_help => '기본 공용 언어 세트로 재설정';
  @override
  String get common_languages_search => '언어 검색...';
  @override
  String get common_languages_all => '모든 언어';
  @override
  String get double_click_copy_result => '더블 클릭으로 번역 결과 복사';
  @override
  String get submit_with_enter => 'Enter로 제출';
  @override
  String get submit_with_meta_enter_mac => '⌘ + Enter로 제출';
  @override
  String get screen_capture_access_hint => '화면에서 텍스트를 가져오려면 화면 내용을 읽어야 합니다.';
  @override
  String get screen_selection_access_hint =>
      '선택한 텍스트를 가져오려면 다른 앱의 선택 항목을 읽어야 합니다.';
  @override
  String get no_translation_targets => '번역 대상이 없습니다. 기본 번역 언어를 정하려면 하나 추가하세요.';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonKo
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '추가...';
  @override
  String get add_target => '대상 추가...';
  @override
  String get manage_targets => '번역 대상 관리...';
  @override
  String get manage_languages => '자주 사용하는 언어 관리...';
  @override
  String get grant => '허용';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionKo
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get none => '없음';
  @override
  String get no_services_available => '사용 가능한 서비스가 없습니다';
  @override
  String get granted => '허용됨';
  @override
  String get built_in_ocr => '내장 OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => 'Youdao OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorKo
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add_target_title => '번역 대상 추가';
  @override
  String get edit_target_title => '번역 대상 수정';
  @override
  late final _TranslationsSettingsGeneralEditorRowKo row =
      _TranslationsSettingsGeneralEditorRowKo._(_root);
  @override
  String get title_edit => '번역 대상 편집';
  @override
  String get subtitle => '특정 원본 언어를 기본으로 어떤 언어로 번역할지 정합니다';
  @override
  String get same_language => '원본 언어와 대상 언어가 같습니다. 다른 대상을 선택하세요.';
  @override
  String get duplicate => '같은 조합의 대상이 이미 있습니다.';
  @override
  String get hint_auto => '다른 규칙과 일치하지 않으면 {}(으)로 번역합니다.';
  @override
  String get hint_source => '{}이(가) 감지되면 {}(으)로 번역합니다.';
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionKo
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '표시 언어';
  @override
  String get theme_mode => '테마 모드';
  @override
  String get theme_style => '테마 스타일';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionKo
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => '텍스트 추출';
  @override
  String get input_assist => '입력 보조 기능';
  @override
  String get submit_mode => '전송 방식';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowKo
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => '창 보이기/숨기기';
  @override
  String get extract_text_from_screen_selection => '화면 선택 영역에서 텍스트 추출';
  @override
  String get extract_text_from_screen_capture => '화면 캡처에서 텍스트 추출';
  @override
  String get extract_text_from_clipboard => '클립보드에서 텍스트 추출';
  @override
  String get translate_input => '입력 내용 번역';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogKo
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '단축키 초기화';
  @override
  String get message => '모든 단축키를 기본값으로 초기화하시겠습니까?';
  @override
  String get confirm => '초기화';
  @override
  String get cancel => '취소';
}

// Path: settings.shortcuts.group
class _TranslationsSettingsShortcutsGroupKo
    extends TranslationsSettingsShortcutsGroupEn {
  _TranslationsSettingsShortcutsGroupKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsShortcutsGroupGlobalKo global =
      _TranslationsSettingsShortcutsGroupGlobalKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsGroupInAppKo in_app =
      _TranslationsSettingsShortcutsGroupInAppKo._(_root);
}

// Path: settings.services.button
class _TranslationsSettingsServicesButtonKo
    extends TranslationsSettingsServicesButtonEn {
  _TranslationsSettingsServicesButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add_service => '서비스 추가...';
}

// Path: settings.services.section
class _TranslationsSettingsServicesSectionKo
    extends TranslationsSettingsServicesSectionEn {
  _TranslationsSettingsServicesSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get available_services => '사용 가능한 서비스';
}

// Path: settings.services.editor
class _TranslationsSettingsServicesEditorKo
    extends TranslationsSettingsServicesEditorEn {
  _TranslationsSettingsServicesEditorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '서비스 추가';
  @override
  String get subtitle => '구성된 제공자에 서비스를 하나 더 추가합니다';
  @override
  late final _TranslationsSettingsServicesEditorRowKo row =
      _TranslationsSettingsServicesEditorRowKo._(_root);
  @override
  String get prompt_placeholder => '비워 두면 이 유형의 기본 프롬프트를 사용합니다';
  @override
  String get variant_hint => '{}에 이미 {} 서비스가 있습니다. 이 서비스는 별도의 구성으로 나란히 추가됩니다.';
  @override
  String get traditional_note =>
      '{}은(는) 전통적인 인터페이스라 조정할 모델이나 프롬프트가 없습니다. 매개변수는 제공자 상세 페이지에서 설정합니다.';
}

// Path: settings.services.detail
class _TranslationsSettingsServicesDetailKo
    extends TranslationsSettingsServicesDetailEn {
  _TranslationsSettingsServicesDetailKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsServicesDetailRowKo row =
      _TranslationsSettingsServicesDetailRowKo._(_root);
  @override
  late final _TranslationsSettingsServicesDetailDeleteDialogKo delete_dialog =
      _TranslationsSettingsServicesDetailDeleteDialogKo._(_root);
  @override
  String get prompt_variables =>
      '사용 가능한 변수: {{sourceLanguage}}, {{targetLanguage}}, {{text}}';
}

// Path: settings.services.item
class _TranslationsSettingsServicesItemKo
    extends TranslationsSettingsServicesItemEn {
  _TranslationsSettingsServicesItemKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get none_of_kind => '사용할 수 있는 {} 서비스가 아직 없습니다.';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionKo
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get services => '사용 가능한 서비스';
  @override
  String get services_description =>
      '구성된 제공업체의 사용 가능한 서비스를 확인하고 서비스 유형별로 전환합니다.';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemKo
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '구성된 제공자가 없습니다. 추가하여 번역 서비스를 활성화하세요.';
  @override
  String get loading => '제공자 로딩 중...';
  @override
  String get no_services => '사용 가능한 서비스가 없습니다.';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonKo
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add => '제공자 추가...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertKo
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get error => '오류';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroKo
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get body => '앱에서 사용하는 서비스 제공업체를 관리합니다.';
  @override
  String get warning =>
      '연결된 제공업체는 사용자가 보낸 텍스트나 이미지를 처리할 수 있습니다. 신뢰할 수 있는 서비스만 활성화하세요.';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorKo
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowKo row =
      _TranslationsSettingsProvidersEditorRowKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderKo placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerKo type_picker =
      _TranslationsSettingsProvidersEditorTypePickerKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipKo tooltip =
      _TranslationsSettingsProvidersEditorTooltipKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorStepKo step =
      _TranslationsSettingsProvidersEditorStepKo._(_root);
  @override
  String get add_title => '{} 추가';
  @override
  late final _TranslationsSettingsProvidersEditorCapabilityNoteKo
      capability_note =
      _TranslationsSettingsProvidersEditorCapabilityNoteKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTestKo test =
      _TranslationsSettingsProvidersEditorTestKo._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailKo
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipKo tooltip =
      _TranslationsSettingsProvidersDetailTooltipKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailRowKo row =
      _TranslationsSettingsProvidersDetailRowKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailSectionKo section =
      _TranslationsSettingsProvidersDetailSectionKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailModelsKo models =
      _TranslationsSettingsProvidersDetailModelsKo._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityKo
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '번역';
  @override
  String get dictionary => '사전';
  @override
  String get ocr => 'OCR';
  @override
  String get llm => 'AI';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionKo
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get all => '사전 검색 및 텍스트 번역을 제공합니다';
  @override
  String get dictionary => '사전 검색 및 단어 정의를 제공합니다';
  @override
  String get translation => '언어 간 텍스트 번역을 제공합니다';
  @override
  String get fallback => '번역 서비스를 제공합니다';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogKo
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '"{}"을(를) 삭제하시겠습니까?';
  @override
  String get message => '이 작업은 되돌릴 수 없습니다.';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyKo
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '카테고리 선택';
  @override
  String get message => '사이드바에서 설정 섹션을 선택하세요.';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsKo
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '개발자 도구';
  @override
  String get open_data_directory => '데이터 디렉터리 열기';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowKo
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => '소스 언어';
  @override
  String get target_language => '대상 언어';
}

// Path: settings.shortcuts.group.global
class _TranslationsSettingsShortcutsGroupGlobalKo
    extends TranslationsSettingsShortcutsGroupGlobalEn {
  _TranslationsSettingsShortcutsGroupGlobalKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '전역 단축키';
  @override
  String get description => '모든 앱에서 작동합니다.';
}

// Path: settings.shortcuts.group.in_app
class _TranslationsSettingsShortcutsGroupInAppKo
    extends TranslationsSettingsShortcutsGroupInAppEn {
  _TranslationsSettingsShortcutsGroupInAppKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '앱 내 키';
  @override
  String get description => '이 앱의 입력란에서만 적용됩니다.';
}

// Path: settings.services.editor.row
class _TranslationsSettingsServicesEditorRowKo
    extends TranslationsSettingsServicesEditorRowEn {
  _TranslationsSettingsServicesEditorRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get model => '모델';
  @override
  String get system_prompt => '시스템 프롬프트';
}

// Path: settings.services.detail.row
class _TranslationsSettingsServicesDetailRowKo
    extends TranslationsSettingsServicesDetailRowEn {
  _TranslationsSettingsServicesDetailRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get id => '서비스 ID';
  @override
  String get name => '이름';
  @override
  String get provider => '제공자';
  @override
  String get type => '유형';
}

// Path: settings.services.detail.delete_dialog
class _TranslationsSettingsServicesDetailDeleteDialogKo
    extends TranslationsSettingsServicesDetailDeleteDialogEn {
  _TranslationsSettingsServicesDetailDeleteDialogKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '"{}"을(를) 삭제할까요?';
  @override
  String get message => '이 서비스가 제공자에서 제거됩니다.';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowKo
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get id => '제공자 ID';
  @override
  String get type => '제공자 유형';
  @override
  String get default_model => '기본 모델';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderKo
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get id => '예: deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerKo
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '추가할 제공자 유형을 선택하세요:';
  @override
  String get section_llm => 'LLM';
  @override
  String get section_traditional => '전통';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipKo
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get help => '도움말';
}

// Path: settings.providers.editor.step
class _TranslationsSettingsProvidersEditorStepKo
    extends TranslationsSettingsProvidersEditorStepEn {
  _TranslationsSettingsProvidersEditorStepKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get next => '계속';
  @override
  String get back => '이전';
}

// Path: settings.providers.editor.capability_note
class _TranslationsSettingsProvidersEditorCapabilityNoteKo
    extends TranslationsSettingsProvidersEditorCapabilityNoteEn {
  _TranslationsSettingsProvidersEditorCapabilityNoteKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '번역 후보에 참여합니다';
  @override
  String get dictionary => '사전 뜻풀이를 제공합니다';
  @override
  String get ocr => '이미지 속 문자를 인식합니다';
}

// Path: settings.providers.editor.test
class _TranslationsSettingsProvidersEditorTestKo
    extends TranslationsSettingsProvidersEditorTestEn {
  _TranslationsSettingsProvidersEditorTestKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get run => '연결 테스트';
  @override
  String get running => '연결 테스트 중 · {}s 경과';
  @override
  String get passed_models => '연결 정상 · 모델 {}개 사용 가능';
  @override
  String get passed_service => '연결 정상 · 서비스 사용 가능';
  @override
  String get passed_footer => '연결 테스트를 통과했습니다';
  @override
  String get retest => '다시 테스트';
  @override
  String get tips_title => '이렇게 해보세요';
  @override
  String get tips_llm =>
      '· 키가 선택한 제공자 유형과 맞는지 확인하세요\n· Base URL에 /v1이 필요한지 확인하세요\n· 제공자 콘솔에서 해당 모델이 활성화되어 있는지 확인하세요';
  @override
  String get tips_traditional =>
      '· 자격 증명이 선택한 제공자 유형과 맞는지 확인하세요\n· 제공자 콘솔에서 서비스가 활성화되어 있는지 확인하세요';
  @override
  String get failed_suffix => '검증 실패';
  @override
  String get passed_suffix => '검증됨';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipKo
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get edit => '제공자 편집';
}

// Path: settings.providers.detail.row
class _TranslationsSettingsProvidersDetailRowKo
    extends TranslationsSettingsProvidersDetailRowEn {
  _TranslationsSettingsProvidersDetailRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get id_hint => '생성 후에는 변경할 수 없습니다';
}

// Path: settings.providers.detail.section
class _TranslationsSettingsProvidersDetailSectionKo
    extends TranslationsSettingsProvidersDetailSectionEn {
  _TranslationsSettingsProvidersDetailSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get configuration => '구성';
  @override
  String get models => '모델';
}

// Path: settings.providers.detail.models
class _TranslationsSettingsProvidersDetailModelsKo
    extends TranslationsSettingsProvidersDetailModelsEn {
  _TranslationsSettingsProvidersDetailModelsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get loading => '모델 로딩 중...';
  @override
  String get empty => '모델을 찾을 수 없습니다.';
  @override
  String get retry => '재시도';
  @override
  String get refresh => '목록 새로 고침';
  @override
  String get default_badge => '기본값';
  @override
  String get set_default => '기본값으로 설정';
  @override
  String get fetch_error => '제공자 API에서 모델을 가져올 수 없습니다.';
}

/// The flat map containing all translations for locale <ko>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsKo {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => '확인',
      'common.ui.button.cancel' => '취소',
      'common.ui.button.add' => '추가',
      'common.ui.button.delete' => '삭제',
      'common.ui.button.edit' => '편집',
      'common.ui.button.save' => '저장',
      'common.ui.button.manage' => '관리',
      'common.ui.button.kContinue' => '계속',
      'common.ui.feedback.copied' => '복사됨',
      'common.language.ar' => '아랍어',
      'common.language.bn' => '벵골어',
      'common.language.de' => '독일어',
      'common.language.en' => '영어',
      'common.language.es' => '스페인어',
      'common.language.fa' => '페르시아어',
      'common.language.fr' => '프랑스어',
      'common.language.gu' => '구자라트어',
      'common.language.ha' => '하우사어',
      'common.language.hi' => '힌디어',
      'common.language.id' => '인도네시아어',
      'common.language.it' => '이탈리아어',
      'common.language.ja' => '일본어',
      'common.language.jv' => '자바어',
      'common.language.ko' => '한국어',
      'common.language.ml' => '말라얄람어',
      'common.language.mr' => '마라티어',
      'common.language.ms' => '말레이어',
      'common.language.nl' => '네덜란드어',
      'common.language.pa' => '펀자브어',
      'common.language.pl' => '폴란드어',
      'common.language.pt' => '포르투갈어',
      'common.language.ro' => '루마니아어',
      'common.language.ru' => '러시아어',
      'common.language.sw' => '스와힐리어',
      'common.language.ta' => '타밀어',
      'common.language.te' => '텔루구어',
      'common.language.th' => '태국어',
      'common.language.tr' => '터키어',
      'common.language.uk' => '우크라이나어',
      'common.language.ur' => '우르두어',
      'common.language.vi' => '베트남어',
      'common.language.yo' => '요루바어',
      'common.language.zh_hans' => '중국어(간체)',
      'common.language.zh_hant' => '중국어(번체)',
      'common.theme_mode.light' => '라이트',
      'common.theme_mode.dark' => '다크',
      'common.theme_mode.system' => '시스템',
      'common.theme_style.studio' => 'Studio',
      'common.theme_style.bright' => 'Bright',
      'common.provider.anthropic' => 'Anthropic',
      'common.provider.baidu' => 'Baidu',
      'common.provider.caiyun' => 'Caiyun',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => 'Google',
      'common.provider.ollama' => 'Ollama',
      'common.provider.openai' => 'OpenAI',
      'common.provider.sogou' => 'Sogou',
      'common.provider.xai' => 'xAI',
      'common.provider.system' => '시스템',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youdao',
      'app.tray.context_menu.show_window' => '창 보기',
      'app.tray.context_menu.dev_tools.title' => '개발자 도구',
      'app.tray.context_menu.dev_tools.open_data_directory' => '데이터 디렉터리 열기',
      'app.tray.context_menu.check_for_updates' => '업데이트 확인',
      'app.tray.context_menu.settings' => '설정',
      'app.tray.context_menu.quit' => '종료',
      'mini_translator.limited_banner.permission.missing_both' =>
        '모든 기능을 사용하려면 화면 녹화 및 손쉬운 사용 권한을 부여하세요.',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        '모든 기능을 사용하려면 화면 녹화 권한을 부여하세요.',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        '모든 기능을 사용하려면 손쉬운 사용 권한을 부여하세요.',
      'mini_translator.limited_banner.instruction.app_settings_prefix' => '',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        '로 이동하여 안내를 따라 ',
      'mini_translator.limited_banner.instruction.suffix' => '을(를) 클릭하세요.',
      'mini_translator.limited_banner.action.app_settings' => '앱 설정',
      'mini_translator.limited_banner.action.recheck' => '재확인',
      'mini_translator.limited_banner.feedback.enabled' =>
        '화면 텍스트 추출이 활성화되었습니다.',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '필요한 권한이 아직 부여되지 않았습니다.\n설정을 확인한 후 다시 시도해 주세요.',
      'mini_translator.limited_banner.tooltip.help' => '도움말 보기',
      'mini_translator.input.hint' => '단어나 텍스트를 입력하세요',
      'mini_translator.input.extracting_text' => '텍스트 추출 중...',
      'mini_translator.input.hint_translate_to' =>
        ({required Object language}) => '단어나 텍스트를 입력해 ${language}(으)로 번역',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '화면 영역을 캡처하여 텍스트 인식',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        '클립보드 내용 읽기',
      'mini_translator.toolbar.tooltip.pin' => '창 고정',
      'mini_translator.toolbar.tooltip.more_actions' => '더 보기',
      'mini_translator.toolbar.menu.extract_from_screen_capture' => '화면에서 추출',
      'mini_translator.toolbar.menu.extract_from_clipboard' => '클립보드에서 추출',
      'mini_translator.toolbar.menu.open_main_window' => '메인 창 열기',
      'mini_translator.toolbar.menu.open_settings' => '설정…',
      'mini_translator.button.clear' => '지우기',
      'mini_translator.button.translate' => '번역',
      'mini_translator.button.copy' => '복사',
      'mini_translator.button.copied' => '복사됨',
      'mini_translator.button.bookmark' => '저장',
      'mini_translator.button.bookmarked' => '저장됨',
      'mini_translator.language.auto_detect' => '자동 감지',
      'mini_translator.language.auto_match' => '자동 일치',
      'mini_translator.language.switch_config' => '대상 전환',
      'mini_translator.language.more_languages' => '더 많은 언어...',
      'mini_translator.language.manage_common_languages' => '자주 사용하는 언어 관리...',
      'mini_translator.language.manage_targets' => '번역 대상 관리...',
      'mini_translator.language.add_target' => '번역 대상 추가...',
      'mini_translator.message.please_enter_word_or_text' =>
        '입력된 텍스트가 없거나 텍스트를 추출하지 못했습니다',
      'mini_translator.message.capture_screen_area_canceled' =>
        '화면 영역 캡처가 취소되었습니다',
      'mini_translator.message.ocr_service_not_configured' =>
        '기본 텍스트 인식 서비스가 설정되지 않았습니다. 설정에서 설정해주세요.',
      'mini_translator.message.ocr_recognition_failed' => '텍스트 인식 실패',
      'mini_translator.result.translating' => '번역 중…',
      'mini_translator.result.stale_requery' => ({required Object key}) =>
          '원문이 수정됨 · ${key} 다시 번역',
      'mini_translator.result.compare_services' => ({required Object count}) =>
          '서비스 ${count}개 비교',
      'mini_translator.result.collapse_compare' => '비교 접기',
      'mini_translator.result.set_preferred' => '기본으로 설정',
      'mini_translator.result.retry' => '다시 시도',
      'mini_translator.result.no_result' =>
        '어떤 서비스도 결과를 반환하지 않았습니다. 네트워크를 확인하거나 다른 서비스을 사용해 보세요.',
      'mini_translator.result.no_result_note' =>
        '원문은 유지되며, 다시 시도해도 기록이 중복되지 않습니다.',
      'workbench.workspace' => '작업 공간',
      'workbench.translate' => '번역',
      'workbench.history' => '기록',
      'workbench.history_page.all' => '전체',
      'workbench.history_page.favorites' => '즐겨찾기',
      'workbench.history_page.edited' => '내가 수정함',
      'workbench.history_page.search' => '검색',
      'workbench.history_page.search_placeholder' => '원문, 번역문 또는 서비스 검색',
      'workbench.history_page.search_label' => '기록 검색',
      'workbench.history_page.entry_count' => (
              {required Object label, required Object count}) =>
          '${label} · ${count}개',
      'workbench.history_page.by_time' => '시간순',
      'workbench.history_page.loading' => '기록 불러오는 중…',
      'workbench.history_page.load_failed' => '기록을 불러오지 못했습니다',
      'workbench.history_page.retry' => '다시 시도',
      'workbench.history_page.empty_title' => '번역 기록이 없습니다',
      'workbench.history_page.empty_description' =>
        '번역이 완료되면 선호 번역이 여기에 저장됩니다.',
      'workbench.history_page.no_results' => ({required Object query}) =>
          '“${query}”와 일치하는 기록이 없습니다',
      'workbench.history_page.clear_search' => '검색 지우기',
      'workbench.history_page.select' => '다중 선택',
      'workbench.history_page.selected_count' => ({required Object count}) =>
          '${count}개 선택됨',
      'workbench.history_page.exit_select' => '선택 종료',
      'workbench.history_page.add_to_glossary' => '용어집에 추가',
      'workbench.history_page.favorite' => '즐겨찾기',
      'workbench.history_page.unfavorite' => '즐겨찾기 해제',
      'workbench.history_page.delete_confirm' => ({required Object count}) =>
          '선택한 기록 ${count}개를 삭제할까요? 되돌릴 수 없습니다.',
      'workbench.history_page.no_glossary' => '먼저 용어집을 만드세요',
      'workbench.history_page.added_to_glossary' => ({required Object count}) =>
          '기록 ${count}개를 용어집에 추가했습니다',
      'workbench.history_page.favorite_flag' => '즐겨찾기',
      'workbench.history_page.edited_flag' => '수정됨',
      'workbench.history_page.edit_history_hint' => '수정한 번역은 기록에 저장됩니다',
      'workbench.glossary' => '용어집',
      'workbench.recent_languages' => '최근 언어',
      'workbench.not_configured' => '설정되지 않음',
      'workbench.subtitle.translate' => '워크벤치 · 서비스 비교',
      'workbench.subtitle.settings' => '설정',
      'workbench.placeholder.history' => '즐겨찾기와 기록은 향후 버전에서 제공됩니다',
      'workbench.placeholder.glossary' => '용어집 관리를 개발 중입니다',
      'workbench.glossary_page.add_entry' => '용어 추가',
      'workbench.glossary_page.term' => '원문',
      'workbench.glossary_page.translation' => '지정 번역',
      'workbench.glossary_page.forbidden' => '금지',
      'workbench.glossary_page.hits' => '적중',
      'workbench.glossary_page.term_placeholder' => 'teacher forcing',
      'workbench.glossary_page.translation_placeholder' => '교사 강요',
      'workbench.glossary_page.forbidden_placeholder' => '강제 교육',
      'workbench.glossary_page.search' => '검색',
      'workbench.glossary_page.search_placeholder' => '용어 또는 지정 번역 검색',
      'workbench.glossary_page.search_label' => '용어집 검색',
      'workbench.glossary_page.entry_count' => (
              {required Object name, required Object count}) =>
          '${name} · ${count}개',
      'workbench.glossary_page.priority_note' => '용어집은 어떤 서비스 출력보다 우선합니다',
      'workbench.glossary_page.new_book' => '용어집 만들기',
      'workbench.glossary_page.new_book_placeholder' => '용어집 이름',
      'workbench.glossary_page.rename_book' => '이름 바꾸기',
      'workbench.glossary_page.delete_book_confirm' => (
              {required Object name, required Object count}) =>
          '“${name}”과(와) 그 안의 용어 ${count}개를 삭제할까요?',
      'workbench.glossary_page.disabled' => '사용 안 함',
      'workbench.glossary_page.enable' => '사용',
      'workbench.glossary_page.disable' => '사용 안 함',
      'workbench.glossary_page.empty_title' => '이 용어집은 비어 있습니다',
      'workbench.glossary_page.empty_description' =>
        '용어집은 어떤 서비스 출력보다 우선합니다. 하나씩 추가하거나 CSV를 끌어다 놓아 병합하세요.',
      'workbench.glossary_page.no_results_title' => ({required Object query}) =>
          '“${query}”와(과) 일치하는 용어가 없습니다',
      'workbench.glossary_page.no_results_description' =>
        '다른 키워드를 쓰거나 새로 추가해 보세요.',
      'workbench.glossary_page.no_books_title' => '아직 용어집이 없습니다',
      'workbench.glossary_page.no_books_description' =>
        '용어집은 선택한 번역어를 모든 서비스에서 일관되게 유지합니다. 먼저 하나 만들고 용어를 추가하세요.',
      'workbench.glossary_page.loading' => '불러오는 중…',
      'workbench.translation.source' => '원문',
      'workbench.translation.target' => '번역문',
      'workbench.translation.input_hint' => '번역할 텍스트를 입력하거나 붙여넣으세요',
      'workbench.translation.button' => '번역',
      'workbench.translation.auto_detected' => '자동 감지됨',
      'workbench.translation.loading_services' => '번역 서비스를 불러오는 중…',
      'workbench.translation.no_services' => '먼저 설정에서 번역 서비스를 구성하세요',
      'workbench.translation.translating' => '번역 중…',
      'workbench.translation.failed' => '번역에 실패했습니다. 서비스 설정을 확인하세요.',
      'workbench.translation.empty' => '번역문이 여기에 표시됩니다',
      'workbench.translation.service_compare' => '서비스 비교',
      'workbench.translation.main_translation' => '기본 번역',
      'workbench.translation.service_unavailable' => '서비스를 사용할 수 없음',
      'workbench.translation.waiting' => '번역 대기',
      'workbench.translation.copy' => '복사',
      'workbench.translation.favorite_unavailable' => '즐겨찾기는 향후 버전에서 제공됩니다',
      'workbench.translation.preferred' => '기본 번역',
      'workbench.translation.other_services' => '다른 서비스',
      'workbench.translation.copy_result' => '번역 복사',
      'workbench.translation.copied' => '복사됨',
      'workbench.translation.favorite' => '저장',
      'workbench.translation.terms' => '용어 일치',
      'workbench.translation.terms_hint' => '입력하면 용어집과 대조합니다.',
      'workbench.translation.quality' => '품질 신호',
      'workbench.translation.quality_hint' => '번역이 완료되면 계산됩니다.',
      'workbench.translation.shortcuts' => '단축키',
      'workbench.translation.other_services_disabled' => '다른 서비스이 비활성화됨',
      'workbench.translation.input_hint_translate_to' => (
              {required Object language}) =>
          '번역할 텍스트를 입력하거나 붙여넣어 ${language}(으)로 번역',
      'workbench.status.runtime_ready' => '번역 런타임 준비 완료',
      'workbench.status.settings_synced' => '설정 동기화됨',
      'workbench.status.shortcuts' => '⌥Space 빠른 창 · ⌥⇧2 캡처',
      'workbench.version_latest' => '최신 버전입니다',
      'workbench.version_checking' => '확인 중…',
      'workbench.check_updates' => '업데이트 확인',
      'settings.version' => 'v{} (Build {})',
      'settings.general.title' => '일반',
      'settings.general.section.permissions' => '시스템 권한',
      'settings.general.section.ocr' => '텍스트 인식',
      'settings.general.section.directory' => '사전',
      'settings.general.section.translation' => '번역',
      'settings.general.section.translation_target' => '번역 대상',
      'settings.general.section.languages' => '언어',
      'settings.general.section.input' => '입력 설정',
      'settings.general.section.startup' => '시작 및 통합',
      'settings.general.section.ocr_behaviour' => '가져오기 동작',
      'settings.general.section.translation_behaviour' => '번역 동작',
      'settings.general.row.launch_at_login' => '로그인할 때 시작',
      'settings.general.row.show_in_menu_bar' => '메뉴 막대에 표시',
      'settings.general.row.screen_capture_access' => '화면 기록 접근 권한 부여',
      'settings.general.row.screen_selection_access' => '손쉬운 사용 접근 권한 부여',
      'settings.general.row.default_ocr_service' => '기본 텍스트 인식 서비스',
      'settings.general.row.auto_copy_detected_text' => '감지된 텍스트 자동 복사',
      'settings.general.row.default_directory_service' => '기본 사전 서비스',
      'settings.general.row.default_translation_service' => '기본 번역 서비스',
      'settings.general.row.translation_target_hint' => '번역기에 사용할 언어 쌍을 설정합니다.',
      'settings.general.row.common_languages' => '자주 사용하는 언어',
      'settings.general.row.common_languages_description' =>
        '자주 사용하는 언어는 언어 선택기 상단에 표시됩니다.',
      'settings.general.row.common_languages_hint' => '자주 사용하는 언어를 선택하세요:',
      'settings.general.row.common_languages_sort' => '코드로 정렬',
      'settings.general.row.common_languages_reset' => '기본값으로 재설정',
      'settings.general.row.common_languages_reset_help' => '기본 공용 언어 세트로 재설정',
      'settings.general.row.common_languages_search' => '언어 검색...',
      'settings.general.row.common_languages_all' => '모든 언어',
      'settings.general.row.double_click_copy_result' => '더블 클릭으로 번역 결과 복사',
      'settings.general.row.submit_with_enter' => 'Enter로 제출',
      'settings.general.row.submit_with_meta_enter_mac' => '⌘ + Enter로 제출',
      'settings.general.row.screen_capture_access_hint' =>
        '화면에서 텍스트를 가져오려면 화면 내용을 읽어야 합니다.',
      'settings.general.row.screen_selection_access_hint' =>
        '선택한 텍스트를 가져오려면 다른 앱의 선택 항목을 읽어야 합니다.',
      'settings.general.row.no_translation_targets' =>
        '번역 대상이 없습니다. 기본 번역 언어를 정하려면 하나 추가하세요.',
      'settings.general.button.add_provider' => '추가...',
      'settings.general.button.add_target' => '대상 추가...',
      'settings.general.button.manage_targets' => '번역 대상 관리...',
      'settings.general.button.manage_languages' => '자주 사용하는 언어 관리...',
      'settings.general.button.grant' => '허용',
      'settings.general.option.none' => '없음',
      'settings.general.option.no_services_available' => '사용 가능한 서비스가 없습니다',
      'settings.general.option.granted' => '허용됨',
      'settings.general.option.built_in_ocr' => '내장 OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'Youdao OCR',
      'settings.general.editor.add_target_title' => '번역 대상 추가',
      'settings.general.editor.edit_target_title' => '번역 대상 수정',
      'settings.general.editor.row.source_language' => '소스 언어',
      'settings.general.editor.row.target_language' => '대상 언어',
      'settings.general.editor.title_edit' => '번역 대상 편집',
      'settings.general.editor.subtitle' => '특정 원본 언어를 기본으로 어떤 언어로 번역할지 정합니다',
      'settings.general.editor.same_language' =>
        '원본 언어와 대상 언어가 같습니다. 다른 대상을 선택하세요.',
      'settings.general.editor.duplicate' => '같은 조합의 대상이 이미 있습니다.',
      'settings.general.editor.hint_auto' => '다른 규칙과 일치하지 않으면 {}(으)로 번역합니다.',
      'settings.general.editor.hint_source' => '{}이(가) 감지되면 {}(으)로 번역합니다.',
      'settings.appearance.title' => '외관',
      'settings.appearance.section.app_language' => '표시 언어',
      'settings.appearance.section.theme_mode' => '테마 모드',
      'settings.appearance.section.theme_style' => '테마 스타일',
      'settings.appearance.footer' => '변경 사항은 창 전체에 즉시 적용됩니다.',
      'settings.shortcuts.title' => '단축키',
      'settings.shortcuts.section.text_extraction' => '텍스트 추출',
      'settings.shortcuts.section.input_assist' => '입력 보조 기능',
      'settings.shortcuts.section.submit_mode' => '전송 방식',
      'settings.shortcuts.row.toggle_mini_translator' => '창 보이기/숨기기',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '화면 선택 영역에서 텍스트 추출',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        '화면 캡처에서 텍스트 추출',
      'settings.shortcuts.row.extract_text_from_clipboard' => '클립보드에서 텍스트 추출',
      'settings.shortcuts.row.translate_input' => '입력 내용 번역',
      'settings.shortcuts.reset_dialog.title' => '단축키 초기화',
      'settings.shortcuts.reset_dialog.message' => '모든 단축키를 기본값으로 초기화하시겠습니까?',
      'settings.shortcuts.reset_dialog.confirm' => '초기화',
      'settings.shortcuts.reset_dialog.cancel' => '취소',
      'settings.shortcuts.group.global.title' => '전역 단축키',
      'settings.shortcuts.group.global.description' => '모든 앱에서 작동합니다.',
      'settings.shortcuts.group.in_app.title' => '앱 내 키',
      'settings.shortcuts.group.in_app.description' => '이 앱의 입력란에서만 적용됩니다.',
      'settings.shortcuts.reset' => '기본값 복원...',
      'settings.advanced.title' => '고급',
      'settings.advanced.api_server' => '로컬 API 서버',
      'settings.advanced.api_server_description' =>
        '로컬 통합을 위해 127.0.0.1에서 번역 API를 노출합니다.',
      'settings.advanced.enable' => '활성화',
      'settings.advanced.port' => '포트',
      'settings.advanced.running_at' => '{url}에서 실행 중',
      'settings.advanced.disabled' => '비활성화됨',
      'settings.services.title' => '서비스',
      'settings.services.button.add_service' => '서비스 추가...',
      'settings.services.section.available_services' => '사용 가능한 서비스',
      'settings.services.editor.title' => '서비스 추가',
      'settings.services.editor.subtitle' => '구성된 제공자에 서비스를 하나 더 추가합니다',
      'settings.services.editor.row.model' => '모델',
      'settings.services.editor.row.system_prompt' => '시스템 프롬프트',
      'settings.services.editor.prompt_placeholder' =>
        '비워 두면 이 유형의 기본 프롬프트를 사용합니다',
      'settings.services.editor.variant_hint' =>
        '{}에 이미 {} 서비스가 있습니다. 이 서비스는 별도의 구성으로 나란히 추가됩니다.',
      'settings.services.editor.traditional_note' =>
        '{}은(는) 전통적인 인터페이스라 조정할 모델이나 프롬프트가 없습니다. 매개변수는 제공자 상세 페이지에서 설정합니다.',
      'settings.services.detail.row.id' => '서비스 ID',
      'settings.services.detail.row.name' => '이름',
      'settings.services.detail.row.provider' => '제공자',
      'settings.services.detail.row.type' => '유형',
      'settings.services.detail.delete_dialog.title' => '"{}"을(를) 삭제할까요?',
      'settings.services.detail.delete_dialog.message' => '이 서비스가 제공자에서 제거됩니다.',
      'settings.services.detail.prompt_variables' =>
        '사용 가능한 변수: {{sourceLanguage}}, {{targetLanguage}}, {{text}}',
      'settings.services.make_default' => '기본으로 설정',
      'settings.services.item.none_of_kind' => '사용할 수 있는 {} 서비스가 아직 없습니다.',
      'settings.providers.title' => '제공자',
      'settings.providers.section.services' => '사용 가능한 서비스',
      'settings.providers.section.services_description' =>
        '구성된 제공업체의 사용 가능한 서비스를 확인하고 서비스 유형별로 전환합니다.',
      'settings.providers.item.empty' => '구성된 제공자가 없습니다. 추가하여 번역 서비스를 활성화하세요.',
      'settings.providers.item.loading' => '제공자 로딩 중...',
      'settings.providers.item.no_services' => '사용 가능한 서비스가 없습니다.',
      'settings.providers.button.add' => '제공자 추가...',
      'settings.providers.alert.error' => '오류',
      'settings.providers.intro.body' => '앱에서 사용하는 서비스 제공업체를 관리합니다.',
      'settings.providers.intro.warning' =>
        '연결된 제공업체는 사용자가 보낸 텍스트나 이미지를 처리할 수 있습니다. 신뢰할 수 있는 서비스만 활성화하세요.',
      'settings.providers.editor.row.id' => '제공자 ID',
      'settings.providers.editor.row.type' => '제공자 유형',
      'settings.providers.editor.row.default_model' => '기본 모델',
      'settings.providers.editor.placeholder.id' => '예: deepl-main',
      'settings.providers.editor.type_picker.prompt' => '추가할 제공자 유형을 선택하세요:',
      'settings.providers.editor.type_picker.section_llm' => 'LLM',
      'settings.providers.editor.type_picker.section_traditional' => '전통',
      'settings.providers.editor.tooltip.help' => '도움말',
      'settings.providers.editor.step.next' => '계속',
      'settings.providers.editor.step.back' => '이전',
      'settings.providers.editor.add_title' => '{} 추가',
      'settings.providers.editor.capability_note.translation' => '번역 후보에 참여합니다',
      'settings.providers.editor.capability_note.dictionary' => '사전 뜻풀이를 제공합니다',
      'settings.providers.editor.capability_note.ocr' => '이미지 속 문자를 인식합니다',
      'settings.providers.editor.test.run' => '연결 테스트',
      'settings.providers.editor.test.running' => '연결 테스트 중 · {}s 경과',
      'settings.providers.editor.test.passed_models' => '연결 정상 · 모델 {}개 사용 가능',
      'settings.providers.editor.test.passed_service' => '연결 정상 · 서비스 사용 가능',
      'settings.providers.editor.test.passed_footer' => '연결 테스트를 통과했습니다',
      'settings.providers.editor.test.retest' => '다시 테스트',
      'settings.providers.editor.test.tips_title' => '이렇게 해보세요',
      'settings.providers.editor.test.tips_llm' =>
        '· 키가 선택한 제공자 유형과 맞는지 확인하세요\n· Base URL에 /v1이 필요한지 확인하세요\n· 제공자 콘솔에서 해당 모델이 활성화되어 있는지 확인하세요',
      'settings.providers.editor.test.tips_traditional' =>
        '· 자격 증명이 선택한 제공자 유형과 맞는지 확인하세요\n· 제공자 콘솔에서 서비스가 활성화되어 있는지 확인하세요',
      'settings.providers.editor.test.failed_suffix' => '검증 실패',
      'settings.providers.editor.test.passed_suffix' => '검증됨',
      'settings.providers.detail.tooltip.edit' => '제공자 편집',
      'settings.providers.detail.row.id_hint' => '생성 후에는 변경할 수 없습니다',
      'settings.providers.detail.section.configuration' => '구성',
      'settings.providers.detail.section.models' => '모델',
      'settings.providers.detail.models.loading' => '모델 로딩 중...',
      'settings.providers.detail.models.empty' => '모델을 찾을 수 없습니다.',
      'settings.providers.detail.models.retry' => '재시도',
      'settings.providers.detail.models.refresh' => '목록 새로 고침',
      'settings.providers.detail.models.default_badge' => '기본값',
      'settings.providers.detail.models.set_default' => '기본값으로 설정',
      'settings.providers.detail.models.fetch_error' =>
        '제공자 API에서 모델을 가져올 수 없습니다.',
      'settings.providers.capability.translation' => '번역',
      'settings.providers.capability.dictionary' => '사전',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.capability.llm' => 'AI',
      'settings.providers.description.all' => '사전 검색 및 텍스트 번역을 제공합니다',
      'settings.providers.description.dictionary' => '사전 검색 및 단어 정의를 제공합니다',
      'settings.providers.description.translation' => '언어 간 텍스트 번역을 제공합니다',
      'settings.providers.description.fallback' => '번역 서비스를 제공합니다',
      'settings.providers.delete_dialog.title' => '"{}"을(를) 삭제하시겠습니까?',
      'settings.providers.delete_dialog.message' => '이 작업은 되돌릴 수 없습니다.',
      'settings.layout.title' => '설정',
      'settings.layout.empty.title' => '카테고리 선택',
      'settings.layout.empty.message' => '사이드바에서 설정 섹션을 선택하세요.',
      'settings.layout.groups' => '설정 그룹',
      'settings.layout.effect_hint' => '변경 사항 즉시 적용',
      'settings.layout.footer_note' => '번역과 키는 이 기기에만 저장됩니다',
      'settings.layout.support' => '지원',
      'settings.about.title' => '정보',
      'settings.about.copy_version_info' => '버전 정보 복사',
      'settings.about.up_to_date' => '최신 버전입니다.',
      'settings.about.check_again' => '다시 확인',
      'settings.about.links' => '링크',
      'settings.about.website' => '웹사이트',
      'settings.about.github' => 'GitHub',
      'settings.about.report_issue' => '문제 보고',
      'settings.about.license' => '라이선스',
      'settings.about.open_changelog' => '변경 내역 열기',
      'settings.about.update' => '업데이트',
      _ => null,
    };
  }
}
