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
class TranslationsJa extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsJa(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.ja,
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

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsJa _root = this; // ignore: unused_field

  @override
  TranslationsJa $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsJa(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
  @override
  late final _TranslationsAppJa app = _TranslationsAppJa._(_root);
  @override
  late final _TranslationsMiniTranslatorJa mini_translator =
      _TranslationsMiniTranslatorJa._(_root);
  @override
  late final _TranslationsWorkbenchJa workbench =
      _TranslationsWorkbenchJa._(_root);
  @override
  late final _TranslationsSettingsJa settings =
      _TranslationsSettingsJa._(_root);
}

// Path: common
class _TranslationsCommonJa extends TranslationsCommonEn {
  _TranslationsCommonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiJa ui = _TranslationsCommonUiJa._(_root);
  @override
  late final _TranslationsCommonLanguageJa language =
      _TranslationsCommonLanguageJa._(_root);
  @override
  late final _TranslationsCommonThemeModeJa theme_mode =
      _TranslationsCommonThemeModeJa._(_root);
  @override
  late final _TranslationsCommonThemeStyleJa theme_style =
      _TranslationsCommonThemeStyleJa._(_root);
  @override
  late final _TranslationsCommonProviderJa provider =
      _TranslationsCommonProviderJa._(_root);
}

// Path: app
class _TranslationsAppJa extends TranslationsAppEn {
  _TranslationsAppJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayJa tray = _TranslationsAppTrayJa._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorJa extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerJa limited_banner =
      _TranslationsMiniTranslatorLimitedBannerJa._(_root);
  @override
  late final _TranslationsMiniTranslatorInputJa input =
      _TranslationsMiniTranslatorInputJa._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarJa toolbar =
      _TranslationsMiniTranslatorToolbarJa._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonJa button =
      _TranslationsMiniTranslatorButtonJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageJa language =
      _TranslationsMiniTranslatorLanguageJa._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageJa message =
      _TranslationsMiniTranslatorMessageJa._(_root);
  @override
  late final _TranslationsMiniTranslatorResultJa result =
      _TranslationsMiniTranslatorResultJa._(_root);
}

// Path: workbench
class _TranslationsWorkbenchJa extends TranslationsWorkbenchEn {
  _TranslationsWorkbenchJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get workspace => 'ワークスペース';
  @override
  String get translate => '翻訳';
  @override
  String get history => '履歴';
  @override
  late final _TranslationsWorkbenchHistoryPageJa history_page =
      _TranslationsWorkbenchHistoryPageJa._(_root);
  @override
  String get glossary => '用語集';
  @override
  String get recent_languages => '最近の言語';
  @override
  String get not_configured => '未設定';
  @override
  late final _TranslationsWorkbenchSubtitleJa subtitle =
      _TranslationsWorkbenchSubtitleJa._(_root);
  @override
  late final _TranslationsWorkbenchPlaceholderJa placeholder =
      _TranslationsWorkbenchPlaceholderJa._(_root);
  @override
  late final _TranslationsWorkbenchGlossaryPageJa glossary_page =
      _TranslationsWorkbenchGlossaryPageJa._(_root);
  @override
  late final _TranslationsWorkbenchTranslationJa translation =
      _TranslationsWorkbenchTranslationJa._(_root);
  @override
  late final _TranslationsWorkbenchStatusJa status =
      _TranslationsWorkbenchStatusJa._(_root);
  @override
  String get version_latest => '最新です';
  @override
  String get version_checking => '確認中…';
  @override
  String get check_updates => 'アップデートを確認';
}

// Path: settings
class _TranslationsSettingsJa extends TranslationsSettingsEn {
  _TranslationsSettingsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'v{} (Build {})';
  @override
  late final _TranslationsSettingsGeneralJa general =
      _TranslationsSettingsGeneralJa._(_root);
  @override
  late final _TranslationsSettingsAppearanceJa appearance =
      _TranslationsSettingsAppearanceJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsJa shortcuts =
      _TranslationsSettingsShortcutsJa._(_root);
  @override
  late final _TranslationsSettingsAdvancedJa advanced =
      _TranslationsSettingsAdvancedJa._(_root);
  @override
  late final _TranslationsSettingsServicesJa services =
      _TranslationsSettingsServicesJa._(_root);
  @override
  late final _TranslationsSettingsProvidersJa providers =
      _TranslationsSettingsProvidersJa._(_root);
  @override
  late final _TranslationsSettingsLayoutJa layout =
      _TranslationsSettingsLayoutJa._(_root);
  @override
  late final _TranslationsSettingsAboutJa about =
      _TranslationsSettingsAboutJa._(_root);
}

// Path: common.ui
class _TranslationsCommonUiJa extends TranslationsCommonUiEn {
  _TranslationsCommonUiJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonJa button =
      _TranslationsCommonUiButtonJa._(_root);
  @override
  late final _TranslationsCommonUiFeedbackJa feedback =
      _TranslationsCommonUiFeedbackJa._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageJa extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get ar => 'アラビア語';
  @override
  String get bn => 'ベンガル語';
  @override
  String get de => 'ドイツ語';
  @override
  String get en => '英語';
  @override
  String get es => 'スペイン語';
  @override
  String get fa => 'ペルシア語';
  @override
  String get fr => 'フランス語';
  @override
  String get gu => 'グジャラート語';
  @override
  String get ha => 'ハウサ語';
  @override
  String get hi => 'ヒンディー語';
  @override
  String get id => 'インドネシア語';
  @override
  String get it => 'イタリア語';
  @override
  String get ja => '日本語';
  @override
  String get jv => 'ジャワ語';
  @override
  String get ko => '韓国語';
  @override
  String get ml => 'マラヤーラム語';
  @override
  String get mr => 'マラーティー語';
  @override
  String get ms => 'マレー語';
  @override
  String get nl => 'オランダ語';
  @override
  String get pa => 'パンジャブ語';
  @override
  String get pl => 'ポーランド語';
  @override
  String get pt => 'ポルトガル語';
  @override
  String get ro => 'ルーマニア語';
  @override
  String get ru => 'ロシア語';
  @override
  String get sw => 'スワヒリ語';
  @override
  String get ta => 'タミル語';
  @override
  String get te => 'テルグ語';
  @override
  String get th => 'タイ語';
  @override
  String get tr => 'トルコ語';
  @override
  String get uk => 'ウクライナ語';
  @override
  String get ur => 'ウルドゥー語';
  @override
  String get vi => 'ベトナム語';
  @override
  String get yo => 'ヨルバ語';
  @override
  String get zh_hans => '簡体字中国語';
  @override
  String get zh_hant => '繁体字中国語';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeJa extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get light => 'ライト';
  @override
  String get dark => 'ダーク';
  @override
  String get system => 'システム';
}

// Path: common.theme_style
class _TranslationsCommonThemeStyleJa extends TranslationsCommonThemeStyleEn {
  _TranslationsCommonThemeStyleJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get studio => 'Studio';
  @override
  String get bright => 'Bright';
}

// Path: common.provider
class _TranslationsCommonProviderJa extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

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
  String get system => 'システム';
  @override
  String get tencent => 'Tencent';
  @override
  String get youdao => 'Youda';
}

// Path: app.tray
class _TranslationsAppTrayJa extends TranslationsAppTrayEn {
  _TranslationsAppTrayJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuJa context_menu =
      _TranslationsAppTrayContextMenuJa._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerJa
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionJa permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionJa instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionJa action =
      _TranslationsMiniTranslatorLimitedBannerActionJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackJa feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipJa tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipJa._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputJa
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'ここに単語またはテキストを入力';
  @override
  String get extracting_text => 'テキストを抽出中...';
  @override
  String hint_translate_to({required Object language}) =>
      '単語またはテキストを入力して${language}に翻訳';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarJa
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipJa tooltip =
      _TranslationsMiniTranslatorToolbarTooltipJa._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarMenuJa menu =
      _TranslationsMiniTranslatorToolbarMenuJa._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonJa
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get clear => 'クリア';
  @override
  String get translate => '翻訳';
  @override
  String get copy => 'コピー';
  @override
  String get copied => 'コピー済み';
  @override
  String get bookmark => '保存';
  @override
  String get bookmarked => '保存済み';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageJa
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => '自動検出';
  @override
  String get auto_match => '自動一致';
  @override
  String get switch_config => 'ターゲット切替';
  @override
  String get more_languages => 'その他の言語...';
  @override
  String get manage_common_languages => 'よく使う言語を管理...';
  @override
  String get manage_targets => '翻訳ターゲットを管理...';
  @override
  String get add_target => '翻訳ターゲットを追加...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageJa
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => 'テキストが入力されていないか、テキストが抽出されていません';
  @override
  String get capture_screen_area_canceled => '画面領域のキャプチャがキャンセルされました';
  @override
  String get ocr_service_not_configured =>
      'デフォルトのテキスト認識サービスが設定されていません。設定で設定してください。';
  @override
  String get ocr_recognition_failed => 'テキスト認識に失敗しました';
}

// Path: mini_translator.result
class _TranslationsMiniTranslatorResultJa
    extends TranslationsMiniTranslatorResultEn {
  _TranslationsMiniTranslatorResultJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get translating => '翻訳中…';
  @override
  String stale_requery({required Object key}) => '原文が変更されました · ${key} 再翻訳';
  @override
  String compare_services({required Object count}) => '${count} 個のサービスを比較';
  @override
  String get collapse_compare => '比較を閉じる';
  @override
  String get set_preferred => '優先に設定';
  @override
  String get retry => '再試行';
  @override
  String get no_result => 'どのサービスも結果を返しませんでした。ネットワークを確認するか、別のサービスをお試しください。';
  @override
  String get no_result_note => '原文は保持され、再試行しても履歴は重複しません。';
}

// Path: workbench.history_page
class _TranslationsWorkbenchHistoryPageJa
    extends TranslationsWorkbenchHistoryPageEn {
  _TranslationsWorkbenchHistoryPageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'すべて';
  @override
  String get favorites => 'お気に入り';
  @override
  String get edited => '編集済み';
  @override
  String get search => '検索';
  @override
  String get search_placeholder => '原文、訳文、サービスを検索';
  @override
  String get search_label => '履歴を検索';
  @override
  String entry_count({required Object label, required Object count}) =>
      '${label} · ${count} 件';
  @override
  String get by_time => '時間順';
  @override
  String get loading => '履歴を読み込み中…';
  @override
  String get load_failed => '履歴を読み込めませんでした';
  @override
  String get retry => '再試行';
  @override
  String get empty_title => '翻訳履歴はまだありません';
  @override
  String get empty_description => '翻訳が完了すると、優先訳がここに保存されます。';
  @override
  String no_results({required Object query}) => '「${query}」に一致する履歴はありません';
  @override
  String get clear_search => '検索をクリア';
  @override
  String get select => '複数選択';
  @override
  String selected_count({required Object count}) => '${count} 件選択中';
  @override
  String get exit_select => '選択を終了';
  @override
  String get add_to_glossary => '用語集に追加';
  @override
  String get favorite => 'お気に入り';
  @override
  String get unfavorite => 'お気に入り解除';
  @override
  String delete_confirm({required Object count}) =>
      '選択した ${count} 件の履歴を削除しますか？元に戻せません。';
  @override
  String get no_glossary => '先に用語集を作成してください';
  @override
  String added_to_glossary({required Object count}) => '${count} 件を用語集に追加しました';
  @override
  String get favorite_flag => 'お気に入り';
  @override
  String get edited_flag => '編集済み';
  @override
  String get edit_history_hint => '編集した訳文は履歴に保存されます';
}

// Path: workbench.subtitle
class _TranslationsWorkbenchSubtitleJa extends TranslationsWorkbenchSubtitleEn {
  _TranslationsWorkbenchSubtitleJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get translate => 'ワークベンチ · サービス比較';
  @override
  String get settings => '設定';
}

// Path: workbench.placeholder
class _TranslationsWorkbenchPlaceholderJa
    extends TranslationsWorkbenchPlaceholderEn {
  _TranslationsWorkbenchPlaceholderJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get history => 'お気に入りと履歴は今後のリリースで提供します';
  @override
  String get glossary => '用語集管理は開発中です';
}

// Path: workbench.glossary_page
class _TranslationsWorkbenchGlossaryPageJa
    extends TranslationsWorkbenchGlossaryPageEn {
  _TranslationsWorkbenchGlossaryPageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add_entry => '用語を追加';
  @override
  String get term => '原文';
  @override
  String get translation => '指定訳';
  @override
  String get forbidden => '禁止';
  @override
  String get hits => 'ヒット';
  @override
  String get term_placeholder => 'teacher forcing';
  @override
  String get translation_placeholder => '教師強制';
  @override
  String get forbidden_placeholder => '強制教育';
  @override
  String get search => '検索';
  @override
  String get search_placeholder => '用語または指定訳を検索';
  @override
  String get search_label => '用語集を検索';
  @override
  String entry_count({required Object name, required Object count}) =>
      '${name} · ${count} 件';
  @override
  String get priority_note => '用語集はどのサービスの出力よりも優先されます';
  @override
  String get new_book => '用語集を作成';
  @override
  String get new_book_placeholder => '用語集の名前';
  @override
  String get rename_book => '名前を変更';
  @override
  String delete_book_confirm({required Object name, required Object count}) =>
      '「${name}」と、その ${count} 件の用語を削除しますか？';
  @override
  String get disabled => '無効';
  @override
  String get enable => '有効にする';
  @override
  String get disable => '無効にする';
  @override
  String get empty_title => 'この用語集は空です';
  @override
  String get empty_description =>
      '用語集はどのサービスの出力よりも優先されます。1 件ずつ追加するか、CSV をドロップして取り込めます。';
  @override
  String no_results_title({required Object query}) => '「${query}」に一致する用語はありません';
  @override
  String get no_results_description => '別のキーワードを試すか、新しく追加してください。';
  @override
  String get no_books_title => '用語集がまだありません';
  @override
  String get no_books_description =>
      '用語集は、選んだ訳語をすべてのサービスで統一します。まず 1 つ作成して、用語を追加しましょう。';
  @override
  String get loading => '読み込み中…';
}

// Path: workbench.translation
class _TranslationsWorkbenchTranslationJa
    extends TranslationsWorkbenchTranslationEn {
  _TranslationsWorkbenchTranslationJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get source => '原文';
  @override
  String get target => '訳文';
  @override
  String get input_hint => '翻訳するテキストを入力または貼り付け';
  @override
  String get button => '翻訳';
  @override
  String get auto_detected => '自動検出';
  @override
  String get loading_services => '翻訳サービスを読み込み中…';
  @override
  String get no_services => '先に設定で翻訳サービスを構成してください';
  @override
  String get translating => '翻訳中…';
  @override
  String get failed => '翻訳に失敗しました。サービス設定を確認してください。';
  @override
  String get empty => '訳文がここに表示されます';
  @override
  String get service_compare => 'サービス比較';
  @override
  String get main_translation => 'メイン';
  @override
  String get service_unavailable => 'サービスを利用できません';
  @override
  String get waiting => '翻訳待ち';
  @override
  String get copy => 'コピー';
  @override
  String get favorite_unavailable => 'お気に入りは今後のリリースで提供します';
  @override
  String get preferred => '優先訳文';
  @override
  String get other_services => '他のサービス';
  @override
  String get copy_result => '訳文をコピー';
  @override
  String get copied => 'コピー済み';
  @override
  String get favorite => '保存';
  @override
  String get terms => '用語ヒット';
  @override
  String get terms_hint => '入力すると用語集と照合されます。';
  @override
  String get quality => '品質シグナル';
  @override
  String get quality_hint => '訳文の生成後に計算されます。';
  @override
  String get shortcuts => 'ショートカット';
  @override
  String get other_services_disabled => '他のサービスは無効です';
  @override
  String input_hint_translate_to({required Object language}) =>
      '翻訳するテキストを入力または貼り付け、${language}に翻訳';
}

// Path: workbench.status
class _TranslationsWorkbenchStatusJa extends TranslationsWorkbenchStatusEn {
  _TranslationsWorkbenchStatusJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get runtime_ready => '翻訳ランタイム準備完了';
  @override
  String get settings_synced => '設定を同期済み';
  @override
  String get shortcuts => '⌥Space クイックウィンドウ · ⌥⇧2 キャプチャ';
}

// Path: settings.general
class _TranslationsSettingsGeneralJa extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '一般';
  @override
  late final _TranslationsSettingsGeneralSectionJa section =
      _TranslationsSettingsGeneralSectionJa._(_root);
  @override
  late final _TranslationsSettingsGeneralRowJa row =
      _TranslationsSettingsGeneralRowJa._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonJa button =
      _TranslationsSettingsGeneralButtonJa._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionJa option =
      _TranslationsSettingsGeneralOptionJa._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorJa editor =
      _TranslationsSettingsGeneralEditorJa._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceJa
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '外観';
  @override
  late final _TranslationsSettingsAppearanceSectionJa section =
      _TranslationsSettingsAppearanceSectionJa._(_root);
  @override
  String get footer => '変更はウインドウ全体にすぐ適用されます。';
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsJa extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ショートカット';
  @override
  late final _TranslationsSettingsShortcutsSectionJa section =
      _TranslationsSettingsShortcutsSectionJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowJa row =
      _TranslationsSettingsShortcutsRowJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogJa reset_dialog =
      _TranslationsSettingsShortcutsResetDialogJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsGroupJa group =
      _TranslationsSettingsShortcutsGroupJa._(_root);
  @override
  String get reset => 'デフォルトに戻す...';
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedJa extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '詳細設定';
  @override
  String get api_server => 'ローカルAPIサーバー';
  @override
  String get api_server_description =>
      'ローカルインテグレーションのために127.0.0.1で翻訳APIを公開します。';
  @override
  String get enable => '有効';
  @override
  String get port => 'ポート';
  @override
  String get running_at => '{url} で実行中';
  @override
  String get disabled => '無効';
}

// Path: settings.services
class _TranslationsSettingsServicesJa extends TranslationsSettingsServicesEn {
  _TranslationsSettingsServicesJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'サービス';
  @override
  late final _TranslationsSettingsServicesButtonJa button =
      _TranslationsSettingsServicesButtonJa._(_root);
  @override
  late final _TranslationsSettingsServicesSectionJa section =
      _TranslationsSettingsServicesSectionJa._(_root);
  @override
  late final _TranslationsSettingsServicesEditorJa editor =
      _TranslationsSettingsServicesEditorJa._(_root);
  @override
  late final _TranslationsSettingsServicesDetailJa detail =
      _TranslationsSettingsServicesDetailJa._(_root);
  @override
  String get make_default => 'デフォルトにする';
  @override
  late final _TranslationsSettingsServicesItemJa item =
      _TranslationsSettingsServicesItemJa._(_root);
}

// Path: settings.providers
class _TranslationsSettingsProvidersJa extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'プロバイダー';
  @override
  late final _TranslationsSettingsProvidersSectionJa section =
      _TranslationsSettingsProvidersSectionJa._(_root);
  @override
  late final _TranslationsSettingsProvidersItemJa item =
      _TranslationsSettingsProvidersItemJa._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonJa button =
      _TranslationsSettingsProvidersButtonJa._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertJa alert =
      _TranslationsSettingsProvidersAlertJa._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroJa intro =
      _TranslationsSettingsProvidersIntroJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorJa editor =
      _TranslationsSettingsProvidersEditorJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailJa detail =
      _TranslationsSettingsProvidersDetailJa._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityJa capability =
      _TranslationsSettingsProvidersCapabilityJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionJa description =
      _TranslationsSettingsProvidersDescriptionJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogJa delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogJa._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutJa extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '設定';
  @override
  late final _TranslationsSettingsLayoutEmptyJa empty =
      _TranslationsSettingsLayoutEmptyJa._(_root);
  @override
  String get groups => '設定グループ';
  @override
  String get effect_hint => '変更は即時反映';
  @override
  String get footer_note => '訳文とキーはこのMacにのみ保存されます';
  @override
  String get support => 'サポート';
}

// Path: settings.about
class _TranslationsSettingsAboutJa extends TranslationsSettingsAboutEn {
  _TranslationsSettingsAboutJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '情報';
  @override
  String get copy_version_info => 'バージョン情報をコピー';
  @override
  String get up_to_date => '最新の状態です。';
  @override
  String get check_again => '再確認';
  @override
  String get links => 'リンク';
  @override
  String get website => 'ウェブサイト';
  @override
  String get github => 'GitHub';
  @override
  String get report_issue => '問題を報告';
  @override
  String get license => 'ライセンス';
  @override
  String get open_changelog => '更新履歴を開く';
  @override
  String get update => 'アップデート';
}

// Path: common.ui.button
class _TranslationsCommonUiButtonJa extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'キャンセル';
  @override
  String get add => '追加';
  @override
  String get delete => '削除';
  @override
  String get edit => '編集';
  @override
  String get save => '保存';
  @override
  String get manage => '管理';
  @override
  String get kContinue => '続行';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackJa extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get copied => 'コピーしました';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuJa
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => 'ウィンドウを表示';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsJa dev_tools =
      _TranslationsAppTrayContextMenuDevToolsJa._(_root);
  @override
  String get check_for_updates => 'アップデートを確認';
  @override
  String get settings => '設定';
  @override
  String get quit => '終了';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionJa
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => 'すべての機能を有効にするには、画面収録とアクセシビリティの許可を付与してください。';
  @override
  String get missing_screen_capture => 'すべての機能を有効にするには、画面収録の許可を付与してください。';
  @override
  String get missing_accessibility => 'すべての機能を有効にするには、アクセシビリティの許可を付与してください。';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionJa
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => 'アプリ設定に移動';
  @override
  String get follow_guide_prefix => 'し、ガイドに従って';
  @override
  String get suffix => 'をクリックしてください。';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionJa
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => 'アプリ設定';
  @override
  String get recheck => '再確認';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackJa
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '画面テキスト抽出が有効です。';
  @override
  String get still_missing => '必要な権限がまだ不足しています。\n設定を確認して、もう一度お試しください。';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipJa
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'ヘルプを表示';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipJa
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture => '画面領域をキャプチャしてテキストを認識';
  @override
  String get extract_text_from_clipboard => 'クリップボードの内容を読み取る';
  @override
  String get pin => 'ウィンドウを固定';
  @override
  String get more_actions => 'その他の操作';
}

// Path: mini_translator.toolbar.menu
class _TranslationsMiniTranslatorToolbarMenuJa
    extends TranslationsMiniTranslatorToolbarMenuEn {
  _TranslationsMiniTranslatorToolbarMenuJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get extract_from_screen_capture => '画面から取得';
  @override
  String get extract_from_clipboard => 'クリップボードから取得';
  @override
  String get open_main_window => 'メインウィンドウを開く';
  @override
  String get open_settings => '設定…';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionJa
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => 'システム権限';
  @override
  String get ocr => 'テキスト認識';
  @override
  String get directory => '辞書';
  @override
  String get translation => '翻訳';
  @override
  String get translation_target => '翻訳先';
  @override
  String get languages => '言語';
  @override
  String get input => '入力設定';
  @override
  String get startup => '起動と連携';
  @override
  String get ocr_behaviour => '取得の動作';
  @override
  String get translation_behaviour => '翻訳の動作';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowJa
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_login => 'ログイン時に起動';
  @override
  String get show_in_menu_bar => 'メニューバーに表示';
  @override
  String get screen_capture_access => '画面収録へのアクセスを許可';
  @override
  String get screen_selection_access => 'アクセシビリティへのアクセスを許可';
  @override
  String get default_ocr_service => 'デフォルトのテキスト認識サービス';
  @override
  String get auto_copy_detected_text => '検出したテキストを自動コピー';
  @override
  String get default_directory_service => 'デフォルトの辞書サービス';
  @override
  String get default_translation_service => 'デフォルトの翻訳サービス';
  @override
  String get translation_target_hint => '翻訳で使用する言語ペアを設定します。';
  @override
  String get common_languages => 'よく使う言語';
  @override
  String get common_languages_description => 'よく使う言語は言語選択リストの先頭に表示されます。';
  @override
  String get common_languages_hint => 'よく使う言語を選択してください：';
  @override
  String get common_languages_sort => 'コードで並べ替え';
  @override
  String get common_languages_reset => 'デフォルトにリセット';
  @override
  String get common_languages_reset_help => 'デフォルトのよく使う言語セットにリセット';
  @override
  String get common_languages_search => '言語を検索...';
  @override
  String get common_languages_all => 'すべての言語';
  @override
  String get double_click_copy_result => 'ダブルクリックで翻訳結果をコピー';
  @override
  String get submit_with_enter => 'Enterで送信';
  @override
  String get submit_with_meta_enter_mac => '⌘ + Enterで送信';
  @override
  String get screen_capture_access_hint => '画面からの文字取得には画面内容の読み取りが必要です。';
  @override
  String get screen_selection_access_hint => '選択テキストの取得には他アプリの選択内容の読み取りが必要です。';
  @override
  String get no_translation_targets => '翻訳ターゲットがありません。既定の翻訳先を決めるには追加してください。';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonJa
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '追加...';
  @override
  String get add_target => '対象を追加...';
  @override
  String get manage_targets => '翻訳ターゲットを管理...';
  @override
  String get manage_languages => 'よく使う言語を管理...';
  @override
  String get grant => '許可';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionJa
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get none => 'なし';
  @override
  String get no_services_available => '利用可能なサービスがありません';
  @override
  String get granted => '許可済み';
  @override
  String get built_in_ocr => '内蔵OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => 'Youdao OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorJa
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add_target_title => '翻訳ターゲットを追加';
  @override
  String get edit_target_title => '翻訳ターゲットを編集';
  @override
  late final _TranslationsSettingsGeneralEditorRowJa row =
      _TranslationsSettingsGeneralEditorRowJa._(_root);
  @override
  String get title_edit => '翻訳ターゲットを編集';
  @override
  String get subtitle => 'ある元言語を既定でどの言語に翻訳するかを決めます';
  @override
  String get same_language => '元言語と翻訳先が同じです。別の翻訳先を選んでください。';
  @override
  String get duplicate => '同じ組み合わせのターゲットがすでにあります。';
  @override
  String get hint_auto => '他のルールに一致しない場合は{}に翻訳します。';
  @override
  String get hint_source => '{}を検出したら{}に翻訳します。';
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionJa
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '表示言語';
  @override
  String get theme_mode => 'テーマモード';
  @override
  String get theme_style => 'テーマスタイル';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionJa
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => 'テキスト抽出';
  @override
  String get input_assist => '入力補助機能';
  @override
  String get submit_mode => '送信方法';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowJa
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => 'ウィンドウの表示/非表示';
  @override
  String get extract_text_from_screen_selection => '画面選択からテキストを抽出';
  @override
  String get extract_text_from_screen_capture => '画面キャプチャからテキストを抽出';
  @override
  String get extract_text_from_clipboard => 'クリップボードからテキストを抽出';
  @override
  String get translate_input => '入力内容を翻訳';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogJa
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ショートカットをリセット';
  @override
  String get message => 'すべてのショートカットをデフォルト値にリセットしますか？';
  @override
  String get confirm => 'リセット';
  @override
  String get cancel => 'キャンセル';
}

// Path: settings.shortcuts.group
class _TranslationsSettingsShortcutsGroupJa
    extends TranslationsSettingsShortcutsGroupEn {
  _TranslationsSettingsShortcutsGroupJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsShortcutsGroupGlobalJa global =
      _TranslationsSettingsShortcutsGroupGlobalJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsGroupInAppJa in_app =
      _TranslationsSettingsShortcutsGroupInAppJa._(_root);
}

// Path: settings.services.button
class _TranslationsSettingsServicesButtonJa
    extends TranslationsSettingsServicesButtonEn {
  _TranslationsSettingsServicesButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add_service => 'サービスを追加...';
}

// Path: settings.services.section
class _TranslationsSettingsServicesSectionJa
    extends TranslationsSettingsServicesSectionEn {
  _TranslationsSettingsServicesSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get available_services => '利用可能なサービス';
}

// Path: settings.services.editor
class _TranslationsSettingsServicesEditorJa
    extends TranslationsSettingsServicesEditorEn {
  _TranslationsSettingsServicesEditorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'サービスを追加';
  @override
  String get subtitle => '設定済みのプロバイダーにサービスを追加します';
  @override
  late final _TranslationsSettingsServicesEditorRowJa row =
      _TranslationsSettingsServicesEditorRowJa._(_root);
  @override
  String get prompt_placeholder => '空欄にすると、この種類の既定プロンプトを使います';
  @override
  String get variant_hint => '{} にはすでに{}サービスがあります。これは並列の別設定として追加されます。';
  @override
  String get traditional_note =>
      '{} は従来型のインターフェースで、調整できるモデルやプロンプトはありません。パラメーターはプロバイダー詳細で設定します。';
}

// Path: settings.services.detail
class _TranslationsSettingsServicesDetailJa
    extends TranslationsSettingsServicesDetailEn {
  _TranslationsSettingsServicesDetailJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsServicesDetailRowJa row =
      _TranslationsSettingsServicesDetailRowJa._(_root);
  @override
  late final _TranslationsSettingsServicesDetailDeleteDialogJa delete_dialog =
      _TranslationsSettingsServicesDetailDeleteDialogJa._(_root);
  @override
  String get prompt_variables =>
      '利用可能な変数: {{sourceLanguage}}, {{targetLanguage}}, {{text}}';
}

// Path: settings.services.item
class _TranslationsSettingsServicesItemJa
    extends TranslationsSettingsServicesItemEn {
  _TranslationsSettingsServicesItemJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get none_of_kind => '利用できる{}サービスがまだありません。';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionJa
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get services => '利用可能なサービス';
  @override
  String get services_description => '設定済みプロバイダーで利用できるサービスを確認し、種類ごとに切り替えます。';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemJa
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'プロバイダーが設定されていません。追加して翻訳サービスを有効にしてください。';
  @override
  String get loading => 'プロバイダーを読み込み中...';
  @override
  String get no_services => '利用可能なサービスがありません。';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonJa
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add => 'プロバイダーを追加...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertJa
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get error => 'エラー';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroJa
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get body => 'アプリで使用するサービスプロバイダーを管理します。';
  @override
  String get warning =>
      '接続したプロバイダーは送信したテキストや画像を処理する場合があります。信頼できるサービスのみ有効にしてください。';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorJa
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowJa row =
      _TranslationsSettingsProvidersEditorRowJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderJa placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerJa type_picker =
      _TranslationsSettingsProvidersEditorTypePickerJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipJa tooltip =
      _TranslationsSettingsProvidersEditorTooltipJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorStepJa step =
      _TranslationsSettingsProvidersEditorStepJa._(_root);
  @override
  String get add_title => '{} を追加';
  @override
  late final _TranslationsSettingsProvidersEditorCapabilityNoteJa
      capability_note =
      _TranslationsSettingsProvidersEditorCapabilityNoteJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTestJa test =
      _TranslationsSettingsProvidersEditorTestJa._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailJa
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipJa tooltip =
      _TranslationsSettingsProvidersDetailTooltipJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailRowJa row =
      _TranslationsSettingsProvidersDetailRowJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailSectionJa section =
      _TranslationsSettingsProvidersDetailSectionJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailModelsJa models =
      _TranslationsSettingsProvidersDetailModelsJa._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityJa
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻訳';
  @override
  String get dictionary => '辞書';
  @override
  String get ocr => 'OCR';
  @override
  String get llm => 'AI';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionJa
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get all => '辞書検索とテキスト翻訳を提供';
  @override
  String get dictionary => '辞書検索と単語定義を提供';
  @override
  String get translation => '言語間のテキスト翻訳を提供';
  @override
  String get fallback => '翻訳サービスを提供';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogJa
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '"{}" を削除しますか？';
  @override
  String get message => 'この操作は元に戻せません。';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyJa
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'カテゴリを選択';
  @override
  String get message => 'サイドバーから設定セクションを選択してください。';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsJa
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '開発ツール';
  @override
  String get open_data_directory => 'データディレクトリを開く';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowJa
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => 'ソース言語';
  @override
  String get target_language => 'ターゲット言語';
}

// Path: settings.shortcuts.group.global
class _TranslationsSettingsShortcutsGroupGlobalJa
    extends TranslationsSettingsShortcutsGroupGlobalEn {
  _TranslationsSettingsShortcutsGroupGlobalJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'グローバルショートカット';
  @override
  String get description => 'どのアプリでも動作します。';
}

// Path: settings.shortcuts.group.in_app
class _TranslationsSettingsShortcutsGroupInAppJa
    extends TranslationsSettingsShortcutsGroupInAppEn {
  _TranslationsSettingsShortcutsGroupInAppJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'アプリ内キー';
  @override
  String get description => 'このアプリの入力欄でのみ有効です。';
}

// Path: settings.services.editor.row
class _TranslationsSettingsServicesEditorRowJa
    extends TranslationsSettingsServicesEditorRowEn {
  _TranslationsSettingsServicesEditorRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get model => 'モデル';
  @override
  String get system_prompt => 'システムプロンプト';
}

// Path: settings.services.detail.row
class _TranslationsSettingsServicesDetailRowJa
    extends TranslationsSettingsServicesDetailRowEn {
  _TranslationsSettingsServicesDetailRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'サービス ID';
  @override
  String get name => '名前';
  @override
  String get provider => 'プロバイダー';
  @override
  String get type => '種類';
}

// Path: settings.services.detail.delete_dialog
class _TranslationsSettingsServicesDetailDeleteDialogJa
    extends TranslationsSettingsServicesDetailDeleteDialogEn {
  _TranslationsSettingsServicesDetailDeleteDialogJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '「{}」を削除しますか？';
  @override
  String get message => 'このサービスはプロバイダーから削除されます。';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowJa
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'プロバイダーID';
  @override
  String get type => 'プロバイダーの種類';
  @override
  String get default_model => 'デフォルトモデル';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderJa
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get id => '例: deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerJa
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '追加するプロバイダーの種類を選択してください：';
  @override
  String get section_llm => 'LLM';
  @override
  String get section_traditional => '従来型';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipJa
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'ヘルプ';
}

// Path: settings.providers.editor.step
class _TranslationsSettingsProvidersEditorStepJa
    extends TranslationsSettingsProvidersEditorStepEn {
  _TranslationsSettingsProvidersEditorStepJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get next => '続ける';
  @override
  String get back => '前へ';
}

// Path: settings.providers.editor.capability_note
class _TranslationsSettingsProvidersEditorCapabilityNoteJa
    extends TranslationsSettingsProvidersEditorCapabilityNoteEn {
  _TranslationsSettingsProvidersEditorCapabilityNoteJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻訳候補に加わります';
  @override
  String get dictionary => '辞書の語義を提供します';
  @override
  String get ocr => '画像内の文字を認識します';
}

// Path: settings.providers.editor.test
class _TranslationsSettingsProvidersEditorTestJa
    extends TranslationsSettingsProvidersEditorTestEn {
  _TranslationsSettingsProvidersEditorTestJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get run => '接続をテスト';
  @override
  String get running => '接続をテスト中 · 経過 {}s';
  @override
  String get passed_models => '接続は正常 · {} 個のモデルが利用可能';
  @override
  String get passed_service => '接続は正常 · サービスを利用できます';
  @override
  String get passed_footer => '接続テストに合格しました';
  @override
  String get retest => '再テスト';
  @override
  String get tips_title => '試せること';
  @override
  String get tips_llm =>
      '· キーが選んだプロバイダーの種類と一致しているか確認\n· Base URL に /v1 が必要か確認\n· プロバイダーのコンソールでそのモデルが有効か確認';
  @override
  String get tips_traditional =>
      '· 認証情報が選んだプロバイダーの種類と一致しているか確認\n· プロバイダーのコンソールでサービスが有効か確認';
  @override
  String get failed_suffix => '検証に失敗';
  @override
  String get passed_suffix => '検証済み';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipJa
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get edit => 'プロバイダーを編集';
}

// Path: settings.providers.detail.row
class _TranslationsSettingsProvidersDetailRowJa
    extends TranslationsSettingsProvidersDetailRowEn {
  _TranslationsSettingsProvidersDetailRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get id_hint => '作成後は変更できません';
}

// Path: settings.providers.detail.section
class _TranslationsSettingsProvidersDetailSectionJa
    extends TranslationsSettingsProvidersDetailSectionEn {
  _TranslationsSettingsProvidersDetailSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get configuration => '設定';
  @override
  String get models => 'モデル';
}

// Path: settings.providers.detail.models
class _TranslationsSettingsProvidersDetailModelsJa
    extends TranslationsSettingsProvidersDetailModelsEn {
  _TranslationsSettingsProvidersDetailModelsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get loading => 'モデルを読み込み中...';
  @override
  String get empty => 'モデルが見つかりません。';
  @override
  String get retry => '再試行';
  @override
  String get refresh => 'リストを更新';
  @override
  String get default_badge => 'デフォルト';
  @override
  String get set_default => 'デフォルトに設定';
  @override
  String get fetch_error => 'プロバイダーAPIからモデルを取得できませんでした。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => 'OK',
      'common.ui.button.cancel' => 'キャンセル',
      'common.ui.button.add' => '追加',
      'common.ui.button.delete' => '削除',
      'common.ui.button.edit' => '編集',
      'common.ui.button.save' => '保存',
      'common.ui.button.manage' => '管理',
      'common.ui.button.kContinue' => '続行',
      'common.ui.feedback.copied' => 'コピーしました',
      'common.language.ar' => 'アラビア語',
      'common.language.bn' => 'ベンガル語',
      'common.language.de' => 'ドイツ語',
      'common.language.en' => '英語',
      'common.language.es' => 'スペイン語',
      'common.language.fa' => 'ペルシア語',
      'common.language.fr' => 'フランス語',
      'common.language.gu' => 'グジャラート語',
      'common.language.ha' => 'ハウサ語',
      'common.language.hi' => 'ヒンディー語',
      'common.language.id' => 'インドネシア語',
      'common.language.it' => 'イタリア語',
      'common.language.ja' => '日本語',
      'common.language.jv' => 'ジャワ語',
      'common.language.ko' => '韓国語',
      'common.language.ml' => 'マラヤーラム語',
      'common.language.mr' => 'マラーティー語',
      'common.language.ms' => 'マレー語',
      'common.language.nl' => 'オランダ語',
      'common.language.pa' => 'パンジャブ語',
      'common.language.pl' => 'ポーランド語',
      'common.language.pt' => 'ポルトガル語',
      'common.language.ro' => 'ルーマニア語',
      'common.language.ru' => 'ロシア語',
      'common.language.sw' => 'スワヒリ語',
      'common.language.ta' => 'タミル語',
      'common.language.te' => 'テルグ語',
      'common.language.th' => 'タイ語',
      'common.language.tr' => 'トルコ語',
      'common.language.uk' => 'ウクライナ語',
      'common.language.ur' => 'ウルドゥー語',
      'common.language.vi' => 'ベトナム語',
      'common.language.yo' => 'ヨルバ語',
      'common.language.zh_hans' => '簡体字中国語',
      'common.language.zh_hant' => '繁体字中国語',
      'common.theme_mode.light' => 'ライト',
      'common.theme_mode.dark' => 'ダーク',
      'common.theme_mode.system' => 'システム',
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
      'common.provider.system' => 'システム',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youda',
      'app.tray.context_menu.show_window' => 'ウィンドウを表示',
      'app.tray.context_menu.dev_tools.title' => '開発ツール',
      'app.tray.context_menu.dev_tools.open_data_directory' => 'データディレクトリを開く',
      'app.tray.context_menu.check_for_updates' => 'アップデートを確認',
      'app.tray.context_menu.settings' => '設定',
      'app.tray.context_menu.quit' => '終了',
      'mini_translator.limited_banner.permission.missing_both' =>
        'すべての機能を有効にするには、画面収録とアクセシビリティの許可を付与してください。',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        'すべての機能を有効にするには、画面収録の許可を付与してください。',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        'すべての機能を有効にするには、アクセシビリティの許可を付与してください。',
      'mini_translator.limited_banner.instruction.app_settings_prefix' =>
        'アプリ設定に移動',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        'し、ガイドに従って',
      'mini_translator.limited_banner.instruction.suffix' => 'をクリックしてください。',
      'mini_translator.limited_banner.action.app_settings' => 'アプリ設定',
      'mini_translator.limited_banner.action.recheck' => '再確認',
      'mini_translator.limited_banner.feedback.enabled' => '画面テキスト抽出が有効です。',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '必要な権限がまだ不足しています。\n設定を確認して、もう一度お試しください。',
      'mini_translator.limited_banner.tooltip.help' => 'ヘルプを表示',
      'mini_translator.input.hint' => 'ここに単語またはテキストを入力',
      'mini_translator.input.extracting_text' => 'テキストを抽出中...',
      'mini_translator.input.hint_translate_to' =>
        ({required Object language}) => '単語またはテキストを入力して${language}に翻訳',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '画面領域をキャプチャしてテキストを認識',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        'クリップボードの内容を読み取る',
      'mini_translator.toolbar.tooltip.pin' => 'ウィンドウを固定',
      'mini_translator.toolbar.tooltip.more_actions' => 'その他の操作',
      'mini_translator.toolbar.menu.extract_from_screen_capture' => '画面から取得',
      'mini_translator.toolbar.menu.extract_from_clipboard' => 'クリップボードから取得',
      'mini_translator.toolbar.menu.open_main_window' => 'メインウィンドウを開く',
      'mini_translator.toolbar.menu.open_settings' => '設定…',
      'mini_translator.button.clear' => 'クリア',
      'mini_translator.button.translate' => '翻訳',
      'mini_translator.button.copy' => 'コピー',
      'mini_translator.button.copied' => 'コピー済み',
      'mini_translator.button.bookmark' => '保存',
      'mini_translator.button.bookmarked' => '保存済み',
      'mini_translator.language.auto_detect' => '自動検出',
      'mini_translator.language.auto_match' => '自動一致',
      'mini_translator.language.switch_config' => 'ターゲット切替',
      'mini_translator.language.more_languages' => 'その他の言語...',
      'mini_translator.language.manage_common_languages' => 'よく使う言語を管理...',
      'mini_translator.language.manage_targets' => '翻訳ターゲットを管理...',
      'mini_translator.language.add_target' => '翻訳ターゲットを追加...',
      'mini_translator.message.please_enter_word_or_text' =>
        'テキストが入力されていないか、テキストが抽出されていません',
      'mini_translator.message.capture_screen_area_canceled' =>
        '画面領域のキャプチャがキャンセルされました',
      'mini_translator.message.ocr_service_not_configured' =>
        'デフォルトのテキスト認識サービスが設定されていません。設定で設定してください。',
      'mini_translator.message.ocr_recognition_failed' => 'テキスト認識に失敗しました',
      'mini_translator.result.translating' => '翻訳中…',
      'mini_translator.result.stale_requery' => ({required Object key}) =>
          '原文が変更されました · ${key} 再翻訳',
      'mini_translator.result.compare_services' => ({required Object count}) =>
          '${count} 個のサービスを比較',
      'mini_translator.result.collapse_compare' => '比較を閉じる',
      'mini_translator.result.set_preferred' => '優先に設定',
      'mini_translator.result.retry' => '再試行',
      'mini_translator.result.no_result' =>
        'どのサービスも結果を返しませんでした。ネットワークを確認するか、別のサービスをお試しください。',
      'mini_translator.result.no_result_note' => '原文は保持され、再試行しても履歴は重複しません。',
      'workbench.workspace' => 'ワークスペース',
      'workbench.translate' => '翻訳',
      'workbench.history' => '履歴',
      'workbench.history_page.all' => 'すべて',
      'workbench.history_page.favorites' => 'お気に入り',
      'workbench.history_page.edited' => '編集済み',
      'workbench.history_page.search' => '検索',
      'workbench.history_page.search_placeholder' => '原文、訳文、サービスを検索',
      'workbench.history_page.search_label' => '履歴を検索',
      'workbench.history_page.entry_count' => (
              {required Object label, required Object count}) =>
          '${label} · ${count} 件',
      'workbench.history_page.by_time' => '時間順',
      'workbench.history_page.loading' => '履歴を読み込み中…',
      'workbench.history_page.load_failed' => '履歴を読み込めませんでした',
      'workbench.history_page.retry' => '再試行',
      'workbench.history_page.empty_title' => '翻訳履歴はまだありません',
      'workbench.history_page.empty_description' => '翻訳が完了すると、優先訳がここに保存されます。',
      'workbench.history_page.no_results' => ({required Object query}) =>
          '「${query}」に一致する履歴はありません',
      'workbench.history_page.clear_search' => '検索をクリア',
      'workbench.history_page.select' => '複数選択',
      'workbench.history_page.selected_count' => ({required Object count}) =>
          '${count} 件選択中',
      'workbench.history_page.exit_select' => '選択を終了',
      'workbench.history_page.add_to_glossary' => '用語集に追加',
      'workbench.history_page.favorite' => 'お気に入り',
      'workbench.history_page.unfavorite' => 'お気に入り解除',
      'workbench.history_page.delete_confirm' => ({required Object count}) =>
          '選択した ${count} 件の履歴を削除しますか？元に戻せません。',
      'workbench.history_page.no_glossary' => '先に用語集を作成してください',
      'workbench.history_page.added_to_glossary' => ({required Object count}) =>
          '${count} 件を用語集に追加しました',
      'workbench.history_page.favorite_flag' => 'お気に入り',
      'workbench.history_page.edited_flag' => '編集済み',
      'workbench.history_page.edit_history_hint' => '編集した訳文は履歴に保存されます',
      'workbench.glossary' => '用語集',
      'workbench.recent_languages' => '最近の言語',
      'workbench.not_configured' => '未設定',
      'workbench.subtitle.translate' => 'ワークベンチ · サービス比較',
      'workbench.subtitle.settings' => '設定',
      'workbench.placeholder.history' => 'お気に入りと履歴は今後のリリースで提供します',
      'workbench.placeholder.glossary' => '用語集管理は開発中です',
      'workbench.glossary_page.add_entry' => '用語を追加',
      'workbench.glossary_page.term' => '原文',
      'workbench.glossary_page.translation' => '指定訳',
      'workbench.glossary_page.forbidden' => '禁止',
      'workbench.glossary_page.hits' => 'ヒット',
      'workbench.glossary_page.term_placeholder' => 'teacher forcing',
      'workbench.glossary_page.translation_placeholder' => '教師強制',
      'workbench.glossary_page.forbidden_placeholder' => '強制教育',
      'workbench.glossary_page.search' => '検索',
      'workbench.glossary_page.search_placeholder' => '用語または指定訳を検索',
      'workbench.glossary_page.search_label' => '用語集を検索',
      'workbench.glossary_page.entry_count' => (
              {required Object name, required Object count}) =>
          '${name} · ${count} 件',
      'workbench.glossary_page.priority_note' => '用語集はどのサービスの出力よりも優先されます',
      'workbench.glossary_page.new_book' => '用語集を作成',
      'workbench.glossary_page.new_book_placeholder' => '用語集の名前',
      'workbench.glossary_page.rename_book' => '名前を変更',
      'workbench.glossary_page.delete_book_confirm' => (
              {required Object name, required Object count}) =>
          '「${name}」と、その ${count} 件の用語を削除しますか？',
      'workbench.glossary_page.disabled' => '無効',
      'workbench.glossary_page.enable' => '有効にする',
      'workbench.glossary_page.disable' => '無効にする',
      'workbench.glossary_page.empty_title' => 'この用語集は空です',
      'workbench.glossary_page.empty_description' =>
        '用語集はどのサービスの出力よりも優先されます。1 件ずつ追加するか、CSV をドロップして取り込めます。',
      'workbench.glossary_page.no_results_title' => ({required Object query}) =>
          '「${query}」に一致する用語はありません',
      'workbench.glossary_page.no_results_description' =>
        '別のキーワードを試すか、新しく追加してください。',
      'workbench.glossary_page.no_books_title' => '用語集がまだありません',
      'workbench.glossary_page.no_books_description' =>
        '用語集は、選んだ訳語をすべてのサービスで統一します。まず 1 つ作成して、用語を追加しましょう。',
      'workbench.glossary_page.loading' => '読み込み中…',
      'workbench.translation.source' => '原文',
      'workbench.translation.target' => '訳文',
      'workbench.translation.input_hint' => '翻訳するテキストを入力または貼り付け',
      'workbench.translation.button' => '翻訳',
      'workbench.translation.auto_detected' => '自動検出',
      'workbench.translation.loading_services' => '翻訳サービスを読み込み中…',
      'workbench.translation.no_services' => '先に設定で翻訳サービスを構成してください',
      'workbench.translation.translating' => '翻訳中…',
      'workbench.translation.failed' => '翻訳に失敗しました。サービス設定を確認してください。',
      'workbench.translation.empty' => '訳文がここに表示されます',
      'workbench.translation.service_compare' => 'サービス比較',
      'workbench.translation.main_translation' => 'メイン',
      'workbench.translation.service_unavailable' => 'サービスを利用できません',
      'workbench.translation.waiting' => '翻訳待ち',
      'workbench.translation.copy' => 'コピー',
      'workbench.translation.favorite_unavailable' => 'お気に入りは今後のリリースで提供します',
      'workbench.translation.preferred' => '優先訳文',
      'workbench.translation.other_services' => '他のサービス',
      'workbench.translation.copy_result' => '訳文をコピー',
      'workbench.translation.copied' => 'コピー済み',
      'workbench.translation.favorite' => '保存',
      'workbench.translation.terms' => '用語ヒット',
      'workbench.translation.terms_hint' => '入力すると用語集と照合されます。',
      'workbench.translation.quality' => '品質シグナル',
      'workbench.translation.quality_hint' => '訳文の生成後に計算されます。',
      'workbench.translation.shortcuts' => 'ショートカット',
      'workbench.translation.other_services_disabled' => '他のサービスは無効です',
      'workbench.translation.input_hint_translate_to' =>
        ({required Object language}) => '翻訳するテキストを入力または貼り付け、${language}に翻訳',
      'workbench.status.runtime_ready' => '翻訳ランタイム準備完了',
      'workbench.status.settings_synced' => '設定を同期済み',
      'workbench.status.shortcuts' => '⌥Space クイックウィンドウ · ⌥⇧2 キャプチャ',
      'workbench.version_latest' => '最新です',
      'workbench.version_checking' => '確認中…',
      'workbench.check_updates' => 'アップデートを確認',
      'settings.version' => 'v{} (Build {})',
      'settings.general.title' => '一般',
      'settings.general.section.permissions' => 'システム権限',
      'settings.general.section.ocr' => 'テキスト認識',
      'settings.general.section.directory' => '辞書',
      'settings.general.section.translation' => '翻訳',
      'settings.general.section.translation_target' => '翻訳先',
      'settings.general.section.languages' => '言語',
      'settings.general.section.input' => '入力設定',
      'settings.general.section.startup' => '起動と連携',
      'settings.general.section.ocr_behaviour' => '取得の動作',
      'settings.general.section.translation_behaviour' => '翻訳の動作',
      'settings.general.row.launch_at_login' => 'ログイン時に起動',
      'settings.general.row.show_in_menu_bar' => 'メニューバーに表示',
      'settings.general.row.screen_capture_access' => '画面収録へのアクセスを許可',
      'settings.general.row.screen_selection_access' => 'アクセシビリティへのアクセスを許可',
      'settings.general.row.default_ocr_service' => 'デフォルトのテキスト認識サービス',
      'settings.general.row.auto_copy_detected_text' => '検出したテキストを自動コピー',
      'settings.general.row.default_directory_service' => 'デフォルトの辞書サービス',
      'settings.general.row.default_translation_service' => 'デフォルトの翻訳サービス',
      'settings.general.row.translation_target_hint' => '翻訳で使用する言語ペアを設定します。',
      'settings.general.row.common_languages' => 'よく使う言語',
      'settings.general.row.common_languages_description' =>
        'よく使う言語は言語選択リストの先頭に表示されます。',
      'settings.general.row.common_languages_hint' => 'よく使う言語を選択してください：',
      'settings.general.row.common_languages_sort' => 'コードで並べ替え',
      'settings.general.row.common_languages_reset' => 'デフォルトにリセット',
      'settings.general.row.common_languages_reset_help' =>
        'デフォルトのよく使う言語セットにリセット',
      'settings.general.row.common_languages_search' => '言語を検索...',
      'settings.general.row.common_languages_all' => 'すべての言語',
      'settings.general.row.double_click_copy_result' => 'ダブルクリックで翻訳結果をコピー',
      'settings.general.row.submit_with_enter' => 'Enterで送信',
      'settings.general.row.submit_with_meta_enter_mac' => '⌘ + Enterで送信',
      'settings.general.row.screen_capture_access_hint' =>
        '画面からの文字取得には画面内容の読み取りが必要です。',
      'settings.general.row.screen_selection_access_hint' =>
        '選択テキストの取得には他アプリの選択内容の読み取りが必要です。',
      'settings.general.row.no_translation_targets' =>
        '翻訳ターゲットがありません。既定の翻訳先を決めるには追加してください。',
      'settings.general.button.add_provider' => '追加...',
      'settings.general.button.add_target' => '対象を追加...',
      'settings.general.button.manage_targets' => '翻訳ターゲットを管理...',
      'settings.general.button.manage_languages' => 'よく使う言語を管理...',
      'settings.general.button.grant' => '許可',
      'settings.general.option.none' => 'なし',
      'settings.general.option.no_services_available' => '利用可能なサービスがありません',
      'settings.general.option.granted' => '許可済み',
      'settings.general.option.built_in_ocr' => '内蔵OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'Youdao OCR',
      'settings.general.editor.add_target_title' => '翻訳ターゲットを追加',
      'settings.general.editor.edit_target_title' => '翻訳ターゲットを編集',
      'settings.general.editor.row.source_language' => 'ソース言語',
      'settings.general.editor.row.target_language' => 'ターゲット言語',
      'settings.general.editor.title_edit' => '翻訳ターゲットを編集',
      'settings.general.editor.subtitle' => 'ある元言語を既定でどの言語に翻訳するかを決めます',
      'settings.general.editor.same_language' => '元言語と翻訳先が同じです。別の翻訳先を選んでください。',
      'settings.general.editor.duplicate' => '同じ組み合わせのターゲットがすでにあります。',
      'settings.general.editor.hint_auto' => '他のルールに一致しない場合は{}に翻訳します。',
      'settings.general.editor.hint_source' => '{}を検出したら{}に翻訳します。',
      'settings.appearance.title' => '外観',
      'settings.appearance.section.app_language' => '表示言語',
      'settings.appearance.section.theme_mode' => 'テーマモード',
      'settings.appearance.section.theme_style' => 'テーマスタイル',
      'settings.appearance.footer' => '変更はウインドウ全体にすぐ適用されます。',
      'settings.shortcuts.title' => 'ショートカット',
      'settings.shortcuts.section.text_extraction' => 'テキスト抽出',
      'settings.shortcuts.section.input_assist' => '入力補助機能',
      'settings.shortcuts.section.submit_mode' => '送信方法',
      'settings.shortcuts.row.toggle_mini_translator' => 'ウィンドウの表示/非表示',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '画面選択からテキストを抽出',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        '画面キャプチャからテキストを抽出',
      'settings.shortcuts.row.extract_text_from_clipboard' =>
        'クリップボードからテキストを抽出',
      'settings.shortcuts.row.translate_input' => '入力内容を翻訳',
      'settings.shortcuts.reset_dialog.title' => 'ショートカットをリセット',
      'settings.shortcuts.reset_dialog.message' =>
        'すべてのショートカットをデフォルト値にリセットしますか？',
      'settings.shortcuts.reset_dialog.confirm' => 'リセット',
      'settings.shortcuts.reset_dialog.cancel' => 'キャンセル',
      'settings.shortcuts.group.global.title' => 'グローバルショートカット',
      'settings.shortcuts.group.global.description' => 'どのアプリでも動作します。',
      'settings.shortcuts.group.in_app.title' => 'アプリ内キー',
      'settings.shortcuts.group.in_app.description' => 'このアプリの入力欄でのみ有効です。',
      'settings.shortcuts.reset' => 'デフォルトに戻す...',
      'settings.advanced.title' => '詳細設定',
      'settings.advanced.api_server' => 'ローカルAPIサーバー',
      'settings.advanced.api_server_description' =>
        'ローカルインテグレーションのために127.0.0.1で翻訳APIを公開します。',
      'settings.advanced.enable' => '有効',
      'settings.advanced.port' => 'ポート',
      'settings.advanced.running_at' => '{url} で実行中',
      'settings.advanced.disabled' => '無効',
      'settings.services.title' => 'サービス',
      'settings.services.button.add_service' => 'サービスを追加...',
      'settings.services.section.available_services' => '利用可能なサービス',
      'settings.services.editor.title' => 'サービスを追加',
      'settings.services.editor.subtitle' => '設定済みのプロバイダーにサービスを追加します',
      'settings.services.editor.row.model' => 'モデル',
      'settings.services.editor.row.system_prompt' => 'システムプロンプト',
      'settings.services.editor.prompt_placeholder' =>
        '空欄にすると、この種類の既定プロンプトを使います',
      'settings.services.editor.variant_hint' =>
        '{} にはすでに{}サービスがあります。これは並列の別設定として追加されます。',
      'settings.services.editor.traditional_note' =>
        '{} は従来型のインターフェースで、調整できるモデルやプロンプトはありません。パラメーターはプロバイダー詳細で設定します。',
      'settings.services.detail.row.id' => 'サービス ID',
      'settings.services.detail.row.name' => '名前',
      'settings.services.detail.row.provider' => 'プロバイダー',
      'settings.services.detail.row.type' => '種類',
      'settings.services.detail.delete_dialog.title' => '「{}」を削除しますか？',
      'settings.services.detail.delete_dialog.message' =>
        'このサービスはプロバイダーから削除されます。',
      'settings.services.detail.prompt_variables' =>
        '利用可能な変数: {{sourceLanguage}}, {{targetLanguage}}, {{text}}',
      'settings.services.make_default' => 'デフォルトにする',
      'settings.services.item.none_of_kind' => '利用できる{}サービスがまだありません。',
      'settings.providers.title' => 'プロバイダー',
      'settings.providers.section.services' => '利用可能なサービス',
      'settings.providers.section.services_description' =>
        '設定済みプロバイダーで利用できるサービスを確認し、種類ごとに切り替えます。',
      'settings.providers.item.empty' =>
        'プロバイダーが設定されていません。追加して翻訳サービスを有効にしてください。',
      'settings.providers.item.loading' => 'プロバイダーを読み込み中...',
      'settings.providers.item.no_services' => '利用可能なサービスがありません。',
      'settings.providers.button.add' => 'プロバイダーを追加...',
      'settings.providers.alert.error' => 'エラー',
      'settings.providers.intro.body' => 'アプリで使用するサービスプロバイダーを管理します。',
      'settings.providers.intro.warning' =>
        '接続したプロバイダーは送信したテキストや画像を処理する場合があります。信頼できるサービスのみ有効にしてください。',
      'settings.providers.editor.row.id' => 'プロバイダーID',
      'settings.providers.editor.row.type' => 'プロバイダーの種類',
      'settings.providers.editor.row.default_model' => 'デフォルトモデル',
      'settings.providers.editor.placeholder.id' => '例: deepl-main',
      'settings.providers.editor.type_picker.prompt' =>
        '追加するプロバイダーの種類を選択してください：',
      'settings.providers.editor.type_picker.section_llm' => 'LLM',
      'settings.providers.editor.type_picker.section_traditional' => '従来型',
      'settings.providers.editor.tooltip.help' => 'ヘルプ',
      'settings.providers.editor.step.next' => '続ける',
      'settings.providers.editor.step.back' => '前へ',
      'settings.providers.editor.add_title' => '{} を追加',
      'settings.providers.editor.capability_note.translation' => '翻訳候補に加わります',
      'settings.providers.editor.capability_note.dictionary' => '辞書の語義を提供します',
      'settings.providers.editor.capability_note.ocr' => '画像内の文字を認識します',
      'settings.providers.editor.test.run' => '接続をテスト',
      'settings.providers.editor.test.running' => '接続をテスト中 · 経過 {}s',
      'settings.providers.editor.test.passed_models' => '接続は正常 · {} 個のモデルが利用可能',
      'settings.providers.editor.test.passed_service' => '接続は正常 · サービスを利用できます',
      'settings.providers.editor.test.passed_footer' => '接続テストに合格しました',
      'settings.providers.editor.test.retest' => '再テスト',
      'settings.providers.editor.test.tips_title' => '試せること',
      'settings.providers.editor.test.tips_llm' =>
        '· キーが選んだプロバイダーの種類と一致しているか確認\n· Base URL に /v1 が必要か確認\n· プロバイダーのコンソールでそのモデルが有効か確認',
      'settings.providers.editor.test.tips_traditional' =>
        '· 認証情報が選んだプロバイダーの種類と一致しているか確認\n· プロバイダーのコンソールでサービスが有効か確認',
      'settings.providers.editor.test.failed_suffix' => '検証に失敗',
      'settings.providers.editor.test.passed_suffix' => '検証済み',
      'settings.providers.detail.tooltip.edit' => 'プロバイダーを編集',
      'settings.providers.detail.row.id_hint' => '作成後は変更できません',
      'settings.providers.detail.section.configuration' => '設定',
      'settings.providers.detail.section.models' => 'モデル',
      'settings.providers.detail.models.loading' => 'モデルを読み込み中...',
      'settings.providers.detail.models.empty' => 'モデルが見つかりません。',
      'settings.providers.detail.models.retry' => '再試行',
      'settings.providers.detail.models.refresh' => 'リストを更新',
      'settings.providers.detail.models.default_badge' => 'デフォルト',
      'settings.providers.detail.models.set_default' => 'デフォルトに設定',
      'settings.providers.detail.models.fetch_error' =>
        'プロバイダーAPIからモデルを取得できませんでした。',
      'settings.providers.capability.translation' => '翻訳',
      'settings.providers.capability.dictionary' => '辞書',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.capability.llm' => 'AI',
      'settings.providers.description.all' => '辞書検索とテキスト翻訳を提供',
      'settings.providers.description.dictionary' => '辞書検索と単語定義を提供',
      'settings.providers.description.translation' => '言語間のテキスト翻訳を提供',
      'settings.providers.description.fallback' => '翻訳サービスを提供',
      'settings.providers.delete_dialog.title' => '"{}" を削除しますか？',
      'settings.providers.delete_dialog.message' => 'この操作は元に戻せません。',
      'settings.layout.title' => '設定',
      'settings.layout.empty.title' => 'カテゴリを選択',
      'settings.layout.empty.message' => 'サイドバーから設定セクションを選択してください。',
      'settings.layout.groups' => '設定グループ',
      'settings.layout.effect_hint' => '変更は即時反映',
      'settings.layout.footer_note' => '訳文とキーはこのMacにのみ保存されます',
      'settings.layout.support' => 'サポート',
      'settings.about.title' => '情報',
      'settings.about.copy_version_info' => 'バージョン情報をコピー',
      'settings.about.up_to_date' => '最新の状態です。',
      'settings.about.check_again' => '再確認',
      'settings.about.links' => 'リンク',
      'settings.about.website' => 'ウェブサイト',
      'settings.about.github' => 'GitHub',
      'settings.about.report_issue' => '問題を報告',
      'settings.about.license' => 'ライセンス',
      'settings.about.open_changelog' => '更新履歴を開く',
      'settings.about.update' => 'アップデート',
      _ => null,
    };
  }
}
