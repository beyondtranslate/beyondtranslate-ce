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
class TranslationsZhHans extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsZhHans(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.zhHans,
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

  /// Metadata for the translations of <zh-Hans>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsZhHans _root = this; // ignore: unused_field

  @override
  TranslationsZhHans $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsZhHans(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonZhHans common =
      _TranslationsCommonZhHans._(_root);
  @override
  late final _TranslationsAppZhHans app = _TranslationsAppZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorZhHans mini_translator =
      _TranslationsMiniTranslatorZhHans._(_root);
  @override
  late final _TranslationsWorkbenchZhHans workbench =
      _TranslationsWorkbenchZhHans._(_root);
  @override
  late final _TranslationsSettingsZhHans settings =
      _TranslationsSettingsZhHans._(_root);
}

// Path: common
class _TranslationsCommonZhHans extends TranslationsCommonEn {
  _TranslationsCommonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiZhHans ui =
      _TranslationsCommonUiZhHans._(_root);
  @override
  late final _TranslationsCommonLanguageZhHans language =
      _TranslationsCommonLanguageZhHans._(_root);
  @override
  late final _TranslationsCommonThemeModeZhHans theme_mode =
      _TranslationsCommonThemeModeZhHans._(_root);
  @override
  late final _TranslationsCommonThemeStyleZhHans theme_style =
      _TranslationsCommonThemeStyleZhHans._(_root);
  @override
  late final _TranslationsCommonProviderZhHans provider =
      _TranslationsCommonProviderZhHans._(_root);
  @override
  late final _TranslationsCommonWordPronunciationZhHans word_pronunciation =
      _TranslationsCommonWordPronunciationZhHans._(_root);
}

// Path: app
class _TranslationsAppZhHans extends TranslationsAppEn {
  _TranslationsAppZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayZhHans tray =
      _TranslationsAppTrayZhHans._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorZhHans extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerZhHans limited_banner =
      _TranslationsMiniTranslatorLimitedBannerZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorInputZhHans input =
      _TranslationsMiniTranslatorInputZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarZhHans toolbar =
      _TranslationsMiniTranslatorToolbarZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonZhHans button =
      _TranslationsMiniTranslatorButtonZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageZhHans language =
      _TranslationsMiniTranslatorLanguageZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageZhHans message =
      _TranslationsMiniTranslatorMessageZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorResultZhHans result =
      _TranslationsMiniTranslatorResultZhHans._(_root);
}

// Path: workbench
class _TranslationsWorkbenchZhHans extends TranslationsWorkbenchEn {
  _TranslationsWorkbenchZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get workspace => '工作区';
  @override
  String get translate => '翻译';
  @override
  String get history => '历史';
  @override
  String get glossary => '术语库';
  @override
  String get recent_languages => '最近语言';
  @override
  String get not_configured => '尚未配置';
  @override
  late final _TranslationsWorkbenchSubtitleZhHans subtitle =
      _TranslationsWorkbenchSubtitleZhHans._(_root);
  @override
  late final _TranslationsWorkbenchPlaceholderZhHans placeholder =
      _TranslationsWorkbenchPlaceholderZhHans._(_root);
  @override
  late final _TranslationsWorkbenchGlossaryPageZhHans glossary_page =
      _TranslationsWorkbenchGlossaryPageZhHans._(_root);
  @override
  late final _TranslationsWorkbenchTranslationZhHans translation =
      _TranslationsWorkbenchTranslationZhHans._(_root);
  @override
  late final _TranslationsWorkbenchStatusZhHans status =
      _TranslationsWorkbenchStatusZhHans._(_root);
  @override
  String get version_latest => '已是最新';
  @override
  String get version_checking => '正在检查…';
  @override
  String get check_updates => '检查更新';
}

// Path: settings
class _TranslationsSettingsZhHans extends TranslationsSettingsEn {
  _TranslationsSettingsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'v{} (Build {})';
  @override
  late final _TranslationsSettingsGeneralZhHans general =
      _TranslationsSettingsGeneralZhHans._(_root);
  @override
  late final _TranslationsSettingsAppearanceZhHans appearance =
      _TranslationsSettingsAppearanceZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsZhHans shortcuts =
      _TranslationsSettingsShortcutsZhHans._(_root);
  @override
  late final _TranslationsSettingsAdvancedZhHans advanced =
      _TranslationsSettingsAdvancedZhHans._(_root);
  @override
  late final _TranslationsSettingsServicesZhHans services =
      _TranslationsSettingsServicesZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersZhHans providers =
      _TranslationsSettingsProvidersZhHans._(_root);
  @override
  late final _TranslationsSettingsLayoutZhHans layout =
      _TranslationsSettingsLayoutZhHans._(_root);
  @override
  late final _TranslationsSettingsAboutZhHans about =
      _TranslationsSettingsAboutZhHans._(_root);
}

// Path: common.ui
class _TranslationsCommonUiZhHans extends TranslationsCommonUiEn {
  _TranslationsCommonUiZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonZhHans button =
      _TranslationsCommonUiButtonZhHans._(_root);
  @override
  late final _TranslationsCommonUiFeedbackZhHans feedback =
      _TranslationsCommonUiFeedbackZhHans._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageZhHans extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get ar => '阿拉伯语';
  @override
  String get bn => '孟加拉语';
  @override
  String get de => '德语';
  @override
  String get en => '英语';
  @override
  String get es => '西班牙语';
  @override
  String get fa => '波斯语';
  @override
  String get fr => '法语';
  @override
  String get gu => '古吉拉特语';
  @override
  String get ha => '豪萨语';
  @override
  String get hi => '印地语';
  @override
  String get id => '印尼语';
  @override
  String get it => '意大利语';
  @override
  String get ja => '日语';
  @override
  String get jv => '印尼爪哇语';
  @override
  String get ko => '韩语';
  @override
  String get ml => '马拉雅拉姆语';
  @override
  String get mr => '马拉地语';
  @override
  String get ms => '马来语';
  @override
  String get nl => '荷兰语';
  @override
  String get pa => '旁遮普语';
  @override
  String get pl => '波兰语';
  @override
  String get pt => '葡萄牙语';
  @override
  String get ro => '罗马尼亚语';
  @override
  String get ru => '俄语';
  @override
  String get sw => '斯瓦希里语';
  @override
  String get ta => '泰米尔语';
  @override
  String get te => '泰卢固语';
  @override
  String get th => '泰语';
  @override
  String get tr => '土耳其语';
  @override
  String get uk => '乌克兰语';
  @override
  String get ur => '乌尔都语';
  @override
  String get vi => '越南语';
  @override
  String get yo => '约鲁巴语';
  @override
  String get zh_hans => '中文（简体）';
  @override
  String get zh_hant => '中文（繁体）';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeZhHans extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get light => '浅色';
  @override
  String get dark => '深色';
  @override
  String get system => '跟随系统';
}

// Path: common.theme_style
class _TranslationsCommonThemeStyleZhHans
    extends TranslationsCommonThemeStyleEn {
  _TranslationsCommonThemeStyleZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get studio => 'Studio';
  @override
  String get bright => 'Bright';
}

// Path: common.provider
class _TranslationsCommonProviderZhHans extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get anthropic => 'Anthropic';
  @override
  String get baidu => '百度';
  @override
  String get caiyun => '彩云小译';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => '谷歌';
  @override
  String get ollama => 'Ollama';
  @override
  String get openai => 'OpenAI';
  @override
  String get sogou => '搜狗';
  @override
  String get xai => 'xAI';
  @override
  String get system => '系统';
  @override
  String get tencent => '腾讯';
  @override
  String get youdao => '有道';
}

// Path: common.word_pronunciation
class _TranslationsCommonWordPronunciationZhHans
    extends TranslationsCommonWordPronunciationEn {
  _TranslationsCommonWordPronunciationZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get us => '美';
  @override
  String get uk => '英';
}

// Path: app.tray
class _TranslationsAppTrayZhHans extends TranslationsAppTrayEn {
  _TranslationsAppTrayZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuZhHans context_menu =
      _TranslationsAppTrayContextMenuZhHans._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerZhHans
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionZhHans
      permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionZhHans
      instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionZhHans action =
      _TranslationsMiniTranslatorLimitedBannerActionZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipZhHans tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipZhHans._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputZhHans
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '在此处输入单词或文本';
  @override
  String get extracting_text => '正在提取文字...';
  @override
  String hint_translate_to({required Object language}) =>
      '输入单词或文本，翻译为${language}';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarZhHans
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipZhHans tooltip =
      _TranslationsMiniTranslatorToolbarTooltipZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarMenuZhHans menu =
      _TranslationsMiniTranslatorToolbarMenuZhHans._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonZhHans
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get clear => '清空';
  @override
  String get translate => '翻译';
  @override
  String get read => '朗读';
  @override
  String get copy => '复制';
  @override
  String get copied => '已复制';
  @override
  String get bookmark => '收藏';
  @override
  String get bookmarked => '已收藏';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageZhHans
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => '自动检测';
  @override
  String get auto_match => '自动匹配';
  @override
  String get switch_config => '切换目标';
  @override
  String get more_languages => '更多语言...';
  @override
  String get manage_common_languages => '管理常用语言...';
  @override
  String get manage_targets => '管理翻译目标...';
  @override
  String get add_target => '添加翻译目标...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageZhHans
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => '未输入或未提取到文本';
  @override
  String get capture_screen_area_canceled => '截取屏幕区域已取消';
  @override
  String get ocr_service_not_configured => '未配置默认文字识别服务，请在设置中配置。';
  @override
  String get ocr_recognition_failed => '文字识别失败';
}

// Path: mini_translator.result
class _TranslationsMiniTranslatorResultZhHans
    extends TranslationsMiniTranslatorResultEn {
  _TranslationsMiniTranslatorResultZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get translating => '正在翻译…';
  @override
  String get stale_requery => '原文已修改 · ⏎ 重新翻译';
  @override
  String compare_services({required Object count}) => '对比 ${count} 个服务';
  @override
  String get collapse_compare => '收起对比';
  @override
  String get set_preferred => '设为首选';
  @override
  String get retry => '重试';
  @override
  String get no_result => '所有服务都没有返回结果 —— 检查网络，或换一个服务再试。';
  @override
  String get no_result_note => '原文已保留，重试不会重复计入历史。';
}

// Path: workbench.subtitle
class _TranslationsWorkbenchSubtitleZhHans
    extends TranslationsWorkbenchSubtitleEn {
  _TranslationsWorkbenchSubtitleZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get translate => '工作台 · 多服务对照';
  @override
  String get settings => '设置';
}

// Path: workbench.placeholder
class _TranslationsWorkbenchPlaceholderZhHans
    extends TranslationsWorkbenchPlaceholderEn {
  _TranslationsWorkbenchPlaceholderZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get history => '收藏与历史将在后续版本中提供';
  @override
  String get glossary => '术语库管理正在建设中';
}

// Path: workbench.glossary_page
class _TranslationsWorkbenchGlossaryPageZhHans
    extends TranslationsWorkbenchGlossaryPageEn {
  _TranslationsWorkbenchGlossaryPageZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add_entry => '新增条目';
  @override
  String get term => '原文';
  @override
  String get translation => '指定译法';
  @override
  String get forbidden => '禁用';
  @override
  String get hits => '命中';
  @override
  String get term_placeholder => 'teacher forcing';
  @override
  String get translation_placeholder => '教师强制';
  @override
  String get forbidden_placeholder => '强制教学';
  @override
  String get search => '搜索';
  @override
  String get search_placeholder => '搜索术语或指定译法';
  @override
  String get search_label => '搜索术语库';
  @override
  String entry_count({required Object name, required Object count}) =>
      '${name} · ${count} 条';
  @override
  String get priority_note => '术语优先级高于任何服务输出';
  @override
  String get new_book => '新建术语库';
  @override
  String get new_book_placeholder => '术语库名称';
  @override
  String get rename_book => '重命名';
  @override
  String delete_book_confirm({required Object name, required Object count}) =>
      '删除「${name}」及其中的 ${count} 条术语？';
  @override
  String get disabled => '已停用';
  @override
  String get enable => '启用';
  @override
  String get disable => '停用';
  @override
  String get empty_title => '这个术语库还是空的';
  @override
  String get empty_description => '术语优先级高于任何服务输出。可以逐条新增，也可以把 CSV 拖进来合并。';
  @override
  String no_results_title({required Object query}) => '没有匹配「${query}」的术语';
  @override
  String get no_results_description => '换个关键词，或直接新增一条。';
  @override
  String get no_books_title => '还没有术语库';
  @override
  String get no_books_description => '术语库让指定译法在所有服务里保持一致。先建一个，再往里加词。';
  @override
  String get loading => '正在载入…';
}

// Path: workbench.translation
class _TranslationsWorkbenchTranslationZhHans
    extends TranslationsWorkbenchTranslationEn {
  _TranslationsWorkbenchTranslationZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get source => '原文';
  @override
  String get target => '译文';
  @override
  String get input_hint => '输入或粘贴需要翻译的文本';
  @override
  String get button => '翻译';
  @override
  String get auto_detected => '已自动检测';
  @override
  String get loading_services => '正在读取翻译服务…';
  @override
  String get no_services => '请先在设置中配置翻译服务';
  @override
  String get translating => '正在翻译…';
  @override
  String get failed => '翻译失败，请检查服务配置后重试';
  @override
  String get empty => '译文将在这里显示';
  @override
  String get service_compare => '服务对比';
  @override
  String get main_translation => '主译文';
  @override
  String get service_unavailable => '服务暂不可用';
  @override
  String get waiting => '等待翻译';
  @override
  String get read => '朗读';
  @override
  String get copy => '复制';
  @override
  String get favorite_unavailable => '收藏功能将在后续版本中提供';
  @override
  String get preferred => '首选译文';
  @override
  String get other_services => '其他服务';
  @override
  String get copy_result => '复制译文';
  @override
  String get copied => '已复制';
  @override
  String get favorite => '收藏';
  @override
  String get terms => '命中术语';
  @override
  String get terms_hint => '输入后自动比对术语库。';
  @override
  String get quality => '质量信号';
  @override
  String get quality_hint => '译文生成后计算。';
  @override
  String get shortcuts => '快捷键';
  @override
  String get other_services_disabled => '其他服务已停用';
  @override
  String input_hint_translate_to({required Object language}) =>
      '输入或粘贴要翻译的文本，翻译为${language}';
}

// Path: workbench.status
class _TranslationsWorkbenchStatusZhHans extends TranslationsWorkbenchStatusEn {
  _TranslationsWorkbenchStatusZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get runtime_ready => '翻译运行时已就绪';
  @override
  String get settings_synced => '设置已同步';
  @override
  String get shortcuts => '⌥Space 小窗 · ⌥⇧2 截图';
}

// Path: settings.general
class _TranslationsSettingsGeneralZhHans extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '常规';
  @override
  late final _TranslationsSettingsGeneralSectionZhHans section =
      _TranslationsSettingsGeneralSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralRowZhHans row =
      _TranslationsSettingsGeneralRowZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonZhHans button =
      _TranslationsSettingsGeneralButtonZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionZhHans option =
      _TranslationsSettingsGeneralOptionZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorZhHans editor =
      _TranslationsSettingsGeneralEditorZhHans._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceZhHans
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '外观';
  @override
  late final _TranslationsSettingsAppearanceSectionZhHans section =
      _TranslationsSettingsAppearanceSectionZhHans._(_root);
  @override
  String get footer => '更改立即应用到整个窗口。';
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsZhHans
    extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '快捷键';
  @override
  late final _TranslationsSettingsShortcutsSectionZhHans section =
      _TranslationsSettingsShortcutsSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowZhHans row =
      _TranslationsSettingsShortcutsRowZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogZhHans reset_dialog =
      _TranslationsSettingsShortcutsResetDialogZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsGroupZhHans group =
      _TranslationsSettingsShortcutsGroupZhHans._(_root);
  @override
  String get reset => '恢复默认...';
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedZhHans
    extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '高级';
  @override
  String get api_server => '本地 API 服务';
  @override
  String get api_server_description => '在 127.0.0.1 上开放翻译 API，供本机集成使用。';
  @override
  String get enable => '启用';
  @override
  String get port => '端口';
  @override
  String get running_at => '运行于 {url}';
  @override
  String get disabled => '已关闭';
}

// Path: settings.services
class _TranslationsSettingsServicesZhHans
    extends TranslationsSettingsServicesEn {
  _TranslationsSettingsServicesZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '服务';
  @override
  late final _TranslationsSettingsServicesButtonZhHans button =
      _TranslationsSettingsServicesButtonZhHans._(_root);
  @override
  late final _TranslationsSettingsServicesSectionZhHans section =
      _TranslationsSettingsServicesSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsServicesEditorZhHans editor =
      _TranslationsSettingsServicesEditorZhHans._(_root);
  @override
  late final _TranslationsSettingsServicesDetailZhHans detail =
      _TranslationsSettingsServicesDetailZhHans._(_root);
  @override
  String get make_default => '设为默认';
  @override
  late final _TranslationsSettingsServicesItemZhHans item =
      _TranslationsSettingsServicesItemZhHans._(_root);
}

// Path: settings.providers
class _TranslationsSettingsProvidersZhHans
    extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '提供商';
  @override
  late final _TranslationsSettingsProvidersSectionZhHans section =
      _TranslationsSettingsProvidersSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersItemZhHans item =
      _TranslationsSettingsProvidersItemZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonZhHans button =
      _TranslationsSettingsProvidersButtonZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertZhHans alert =
      _TranslationsSettingsProvidersAlertZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroZhHans intro =
      _TranslationsSettingsProvidersIntroZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorZhHans editor =
      _TranslationsSettingsProvidersEditorZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailZhHans detail =
      _TranslationsSettingsProvidersDetailZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityZhHans capability =
      _TranslationsSettingsProvidersCapabilityZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionZhHans description =
      _TranslationsSettingsProvidersDescriptionZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogZhHans delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogZhHans._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutZhHans extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设置';
  @override
  late final _TranslationsSettingsLayoutEmptyZhHans empty =
      _TranslationsSettingsLayoutEmptyZhHans._(_root);
  @override
  String get groups => '设置分组';
  @override
  String get effect_hint => '更改即时生效';
  @override
  String get footer_note => '译文与密钥仅保存在本机';
  @override
  String get support => '支持';
}

// Path: settings.about
class _TranslationsSettingsAboutZhHans extends TranslationsSettingsAboutEn {
  _TranslationsSettingsAboutZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '关于';
  @override
  String get copy_version_info => '复制版本信息';
  @override
  String get up_to_date => '已是最新版本。';
  @override
  String get check_again => '重新检查';
  @override
  String get links => '链接';
  @override
  String get website => '网站';
  @override
  String get github => 'GitHub';
  @override
  String get report_issue => '提交问题';
  @override
  String get license => '许可证';
  @override
  String get open_changelog => '查看更新日志';
  @override
  String get update => '更新';
}

// Path: common.ui.button
class _TranslationsCommonUiButtonZhHans extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get ok => '确定';
  @override
  String get cancel => '取消';
  @override
  String get add => '添加';
  @override
  String get delete => '删除';
  @override
  String get edit => '编辑';
  @override
  String get save => '保存';
  @override
  String get manage => '管理';
  @override
  String get kContinue => '继续';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackZhHans
    extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get copied => '已复制';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuZhHans
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => '显示窗口';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsZhHans dev_tools =
      _TranslationsAppTrayContextMenuDevToolsZhHans._(_root);
  @override
  String get check_for_updates => '检查更新';
  @override
  String get settings => '设置';
  @override
  String get quit => '退出';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionZhHans
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => '请授予屏幕录制和辅助功能权限以启用完整功能。';
  @override
  String get missing_screen_capture => '请授予屏幕录制权限以启用完整功能。';
  @override
  String get missing_accessibility => '请授予辅助功能权限以启用完整功能。';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionZhHans
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => '请前往';
  @override
  String get follow_guide_prefix => '，按指引授权后点击';
  @override
  String get suffix => '。';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionZhHans
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => '应用设置';
  @override
  String get recheck => '重新检查';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '屏幕取词功能已启用';
  @override
  String get still_missing => '仍缺少所需权限，\n请检查设置后重试。';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipZhHans
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get help => '查看帮助文档';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipZhHans
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture => '截取屏幕区域并识别文字';
  @override
  String get extract_text_from_clipboard => '读取剪切板内容';
  @override
  String get pin => '固定窗口';
  @override
  String get more_actions => '更多操作';
}

// Path: mini_translator.toolbar.menu
class _TranslationsMiniTranslatorToolbarMenuZhHans
    extends TranslationsMiniTranslatorToolbarMenuEn {
  _TranslationsMiniTranslatorToolbarMenuZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get extract_from_screen_capture => '屏幕取词';
  @override
  String get extract_from_clipboard => '剪贴板取词';
  @override
  String get open_main_window => '打开主窗口';
  @override
  String get open_settings => '设置…';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionZhHans
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => '系统权限';
  @override
  String get ocr => '文字识别';
  @override
  String get directory => '词典';
  @override
  String get translation => '翻译';
  @override
  String get translation_target => '翻译目标';
  @override
  String get languages => '语言';
  @override
  String get input => '输入设置';
  @override
  String get startup => '启动与集成';
  @override
  String get ocr_behaviour => '取词行为';
  @override
  String get translation_behaviour => '翻译行为';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowZhHans
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_login => '登录时启动';
  @override
  String get show_in_menu_bar => '在菜单栏中显示';
  @override
  String get screen_capture_access => '授予屏幕录制权限';
  @override
  String get screen_selection_access => '授予辅助功能权限';
  @override
  String get default_ocr_service => '默认文字识别服务';
  @override
  String get auto_copy_detected_text => '自动复制检测到的文本';
  @override
  String get default_directory_service => '默认词典服务';
  @override
  String get default_translation_service => '默认翻译服务';
  @override
  String get translation_target_hint => '配置翻译器使用的语言目标。';
  @override
  String get common_languages => '常用语言';
  @override
  String get common_languages_description => '显示在语言选择列表顶部。';
  @override
  String get common_languages_hint => '选择你常用的语言：';
  @override
  String get common_languages_sort => '按代码排序';
  @override
  String get common_languages_reset => '恢复默认';
  @override
  String get common_languages_reset_help => '恢复为默认的常用语言集合';
  @override
  String get common_languages_search => '搜索语言...';
  @override
  String get common_languages_all => '所有语言';
  @override
  String get double_click_copy_result => '双击复制翻译结果';
  @override
  String get submit_with_enter => '按 Enter 提交';
  @override
  String get submit_with_meta_enter_mac => '按 ⌘ + Enter 提交';
  @override
  String get screen_capture_access_hint => '截图取词需要读取屏幕内容。';
  @override
  String get screen_selection_access_hint => '划词取词需要读取其他应用中选中的文本。';
  @override
  String get no_translation_targets => '还没有翻译目标，添加一条来决定默认译入哪种语言。';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonZhHans
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '添加...';
  @override
  String get add_target => '添加目标...';
  @override
  String get manage_targets => '管理翻译目标...';
  @override
  String get manage_languages => '管理常用语言...';
  @override
  String get grant => '授权';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionZhHans
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get none => '无';
  @override
  String get no_services_available => '暂无可用服务';
  @override
  String get granted => '已授权';
  @override
  String get built_in_ocr => '内置 OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => '有道 OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorZhHans
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add_target_title => '添加翻译目标：';
  @override
  String get edit_target_title => '修改翻译目标：';
  @override
  late final _TranslationsSettingsGeneralEditorRowZhHans row =
      _TranslationsSettingsGeneralEditorRowZhHans._(_root);
  @override
  String get title_edit => '编辑翻译目标';
  @override
  String get subtitle => '决定某种源语言默认翻译成哪种语言';
  @override
  String get same_language => '源语言与目标语言相同，换一个目标语言。';
  @override
  String get duplicate => '已经有一条同样的翻译目标了。';
  @override
  String get hint_auto => '未匹配到其他规则时，一律译成{}。';
  @override
  String get hint_source => '检测到{}时，译成{}。';
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionZhHans
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '显示语言';
  @override
  String get theme_mode => '主题模式';
  @override
  String get theme_style => '主题风格';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionZhHans
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => '文字提取';
  @override
  String get input_assist => '输入辅助功能';
  @override
  String get submit_mode => '提交方式';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowZhHans
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => '显示/隐藏窗口';
  @override
  String get extract_text_from_screen_selection => '从屏幕选区提取文字';
  @override
  String get extract_text_from_screen_capture => '从屏幕截图提取文字';
  @override
  String get extract_text_from_clipboard => '从剪贴板提取文字';
  @override
  String get translate_input => '翻译输入内容';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogZhHans
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '重置快捷键';
  @override
  String get message => '确定要重置所有快捷键为默认值吗？';
  @override
  String get confirm => '重置';
  @override
  String get cancel => '取消';
}

// Path: settings.shortcuts.group
class _TranslationsSettingsShortcutsGroupZhHans
    extends TranslationsSettingsShortcutsGroupEn {
  _TranslationsSettingsShortcutsGroupZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsShortcutsGroupGlobalZhHans global =
      _TranslationsSettingsShortcutsGroupGlobalZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsGroupInAppZhHans in_app =
      _TranslationsSettingsShortcutsGroupInAppZhHans._(_root);
}

// Path: settings.services.button
class _TranslationsSettingsServicesButtonZhHans
    extends TranslationsSettingsServicesButtonEn {
  _TranslationsSettingsServicesButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add_service => '添加服务...';
}

// Path: settings.services.section
class _TranslationsSettingsServicesSectionZhHans
    extends TranslationsSettingsServicesSectionEn {
  _TranslationsSettingsServicesSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get available_services => '可用服务';
}

// Path: settings.services.editor
class _TranslationsSettingsServicesEditorZhHans
    extends TranslationsSettingsServicesEditorEn {
  _TranslationsSettingsServicesEditorZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '添加服务';
  @override
  String get subtitle => '为已配置的提供商新增一项服务';
  @override
  late final _TranslationsSettingsServicesEditorRowZhHans row =
      _TranslationsSettingsServicesEditorRowZhHans._(_root);
  @override
  String get prompt_placeholder => '留空则使用该类型的默认提示词';
  @override
  String get variant_hint => '{} 已有一项{}服务，这条会作为并列的另一份配置。';
  @override
  String get traditional_note => '{} 是传统接口，没有模型与提示词可调；服务参数在提供商详情里配置。';
}

// Path: settings.services.detail
class _TranslationsSettingsServicesDetailZhHans
    extends TranslationsSettingsServicesDetailEn {
  _TranslationsSettingsServicesDetailZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsServicesDetailRowZhHans row =
      _TranslationsSettingsServicesDetailRowZhHans._(_root);
  @override
  late final _TranslationsSettingsServicesDetailDeleteDialogZhHans
      delete_dialog =
      _TranslationsSettingsServicesDetailDeleteDialogZhHans._(_root);
  @override
  String get prompt_variables =>
      '可用变量：{{sourceLanguage}}、{{targetLanguage}}、{{text}}';
}

// Path: settings.services.item
class _TranslationsSettingsServicesItemZhHans
    extends TranslationsSettingsServicesItemEn {
  _TranslationsSettingsServicesItemZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get none_of_kind => '还没有可用的{}服务。';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionZhHans
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get services => '可用服务';
  @override
  String get services_description => '查看已配置提供商的可用服务，并按服务类型切换。';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemZhHans
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '暂无已配置的提供商。添加一个提供商以启用翻译服务。';
  @override
  String get loading => '正在加载提供商...';
  @override
  String get no_services => '暂无可用服务。';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonZhHans
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add => '添加提供商...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertZhHans
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get error => '错误';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroZhHans
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get body => '管理应用使用的服务提供商。';
  @override
  String get warning => '已连接的提供商可能会处理你发送的文本或图片，请只启用你信任的服务。';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorZhHans
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowZhHans row =
      _TranslationsSettingsProvidersEditorRowZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderZhHans placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerZhHans type_picker =
      _TranslationsSettingsProvidersEditorTypePickerZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipZhHans tooltip =
      _TranslationsSettingsProvidersEditorTooltipZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorStepZhHans step =
      _TranslationsSettingsProvidersEditorStepZhHans._(_root);
  @override
  String get add_title => '添加 {}';
  @override
  late final _TranslationsSettingsProvidersEditorCapabilityNoteZhHans
      capability_note =
      _TranslationsSettingsProvidersEditorCapabilityNoteZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTestZhHans test =
      _TranslationsSettingsProvidersEditorTestZhHans._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailZhHans
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipZhHans tooltip =
      _TranslationsSettingsProvidersDetailTooltipZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailRowZhHans row =
      _TranslationsSettingsProvidersDetailRowZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailSectionZhHans section =
      _TranslationsSettingsProvidersDetailSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailModelsZhHans models =
      _TranslationsSettingsProvidersDetailModelsZhHans._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityZhHans
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻译';
  @override
  String get dictionary => '词典';
  @override
  String get ocr => 'OCR';
  @override
  String get llm => 'AI';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionZhHans
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get all => '提供词典查询和文本翻译';
  @override
  String get translation => '提供语言间文本翻译';
  @override
  String get dictionary => '提供词典查询和单词释义';
  @override
  String get fallback => '提供翻译服务';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogZhHans
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '删除「{}」？';
  @override
  String get message => '此操作无法撤销。';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyZhHans
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '选择一个分类';
  @override
  String get message => '从侧边栏选择一个设置分类。';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsZhHans
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '开发工具';
  @override
  String get open_data_directory => '打开数据目录';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowZhHans
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => '源语言';
  @override
  String get target_language => '目标语言';
}

// Path: settings.shortcuts.group.global
class _TranslationsSettingsShortcutsGroupGlobalZhHans
    extends TranslationsSettingsShortcutsGroupGlobalEn {
  _TranslationsSettingsShortcutsGroupGlobalZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '全局快捷键';
  @override
  String get description => '在任何应用里都能触发。';
}

// Path: settings.shortcuts.group.in_app
class _TranslationsSettingsShortcutsGroupInAppZhHans
    extends TranslationsSettingsShortcutsGroupInAppEn {
  _TranslationsSettingsShortcutsGroupInAppZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '应用内按键';
  @override
  String get description => '仅在应用自己的输入框内生效。';
}

// Path: settings.services.editor.row
class _TranslationsSettingsServicesEditorRowZhHans
    extends TranslationsSettingsServicesEditorRowEn {
  _TranslationsSettingsServicesEditorRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get model => '模型';
  @override
  String get system_prompt => '系统提示词';
}

// Path: settings.services.detail.row
class _TranslationsSettingsServicesDetailRowZhHans
    extends TranslationsSettingsServicesDetailRowEn {
  _TranslationsSettingsServicesDetailRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get id => '服务 ID';
  @override
  String get name => '名称';
  @override
  String get provider => '提供商';
  @override
  String get type => '类型';
}

// Path: settings.services.detail.delete_dialog
class _TranslationsSettingsServicesDetailDeleteDialogZhHans
    extends TranslationsSettingsServicesDetailDeleteDialogEn {
  _TranslationsSettingsServicesDetailDeleteDialogZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '删除「{}」？';
  @override
  String get message => '此服务将从提供商中移除。';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowZhHans
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get id => '提供商 ID';
  @override
  String get type => '提供商类型';
  @override
  String get default_model => '默认模型';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderZhHans
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get id => '例如 deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerZhHans
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '请选择要添加的提供商类型：';
  @override
  String get section_llm => 'LLM';
  @override
  String get section_traditional => '传统';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipZhHans
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get help => '帮助';
}

// Path: settings.providers.editor.step
class _TranslationsSettingsProvidersEditorStepZhHans
    extends TranslationsSettingsProvidersEditorStepEn {
  _TranslationsSettingsProvidersEditorStepZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get next => '继续';
  @override
  String get back => '上一步';
}

// Path: settings.providers.editor.capability_note
class _TranslationsSettingsProvidersEditorCapabilityNoteZhHans
    extends TranslationsSettingsProvidersEditorCapabilityNoteEn {
  _TranslationsSettingsProvidersEditorCapabilityNoteZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '加入翻译候选';
  @override
  String get dictionary => '提供词典释义';
  @override
  String get ocr => '识别图片中的文字';
}

// Path: settings.providers.editor.test
class _TranslationsSettingsProvidersEditorTestZhHans
    extends TranslationsSettingsProvidersEditorTestEn {
  _TranslationsSettingsProvidersEditorTestZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get run => '测试连接';
  @override
  String get running => '正在测试连接 · 已用 {}s';
  @override
  String get passed_models => '连接正常 · {} 个模型可用';
  @override
  String get passed_service => '连接正常 · 服务可用';
  @override
  String get passed_footer => '已通过连接测试';
  @override
  String get retest => '重新测试';
  @override
  String get tips_title => '可以试试';
  @override
  String get tips_llm =>
      '· 确认密钥与所选提供商类型一致\n· 检查 Base URL 是否需要包含 /v1\n· 在提供商控制台确认该模型已开通';
  @override
  String get tips_traditional => '· 确认密钥与所选提供商类型一致\n· 在提供商控制台确认服务已开通';
  @override
  String get failed_suffix => '验证失败';
  @override
  String get passed_suffix => '已验证';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipZhHans
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get edit => '编辑提供商';
}

// Path: settings.providers.detail.row
class _TranslationsSettingsProvidersDetailRowZhHans
    extends TranslationsSettingsProvidersDetailRowEn {
  _TranslationsSettingsProvidersDetailRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get id_hint => '创建后不可更改';
}

// Path: settings.providers.detail.section
class _TranslationsSettingsProvidersDetailSectionZhHans
    extends TranslationsSettingsProvidersDetailSectionEn {
  _TranslationsSettingsProvidersDetailSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get configuration => '配置';
  @override
  String get models => '模型';
}

// Path: settings.providers.detail.models
class _TranslationsSettingsProvidersDetailModelsZhHans
    extends TranslationsSettingsProvidersDetailModelsEn {
  _TranslationsSettingsProvidersDetailModelsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get loading => '正在加载模型...';
  @override
  String get empty => '未找到模型。';
  @override
  String get retry => '重试';
  @override
  String get refresh => '刷新列表';
  @override
  String get default_badge => '默认';
  @override
  String get set_default => '设为默认';
  @override
  String get fetch_error => '无法从提供商 API 获取模型。';
}

/// The flat map containing all translations for locale <zh-Hans>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhHans {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => '确定',
      'common.ui.button.cancel' => '取消',
      'common.ui.button.add' => '添加',
      'common.ui.button.delete' => '删除',
      'common.ui.button.edit' => '编辑',
      'common.ui.button.save' => '保存',
      'common.ui.button.manage' => '管理',
      'common.ui.button.kContinue' => '继续',
      'common.ui.feedback.copied' => '已复制',
      'common.language.ar' => '阿拉伯语',
      'common.language.bn' => '孟加拉语',
      'common.language.de' => '德语',
      'common.language.en' => '英语',
      'common.language.es' => '西班牙语',
      'common.language.fa' => '波斯语',
      'common.language.fr' => '法语',
      'common.language.gu' => '古吉拉特语',
      'common.language.ha' => '豪萨语',
      'common.language.hi' => '印地语',
      'common.language.id' => '印尼语',
      'common.language.it' => '意大利语',
      'common.language.ja' => '日语',
      'common.language.jv' => '印尼爪哇语',
      'common.language.ko' => '韩语',
      'common.language.ml' => '马拉雅拉姆语',
      'common.language.mr' => '马拉地语',
      'common.language.ms' => '马来语',
      'common.language.nl' => '荷兰语',
      'common.language.pa' => '旁遮普语',
      'common.language.pl' => '波兰语',
      'common.language.pt' => '葡萄牙语',
      'common.language.ro' => '罗马尼亚语',
      'common.language.ru' => '俄语',
      'common.language.sw' => '斯瓦希里语',
      'common.language.ta' => '泰米尔语',
      'common.language.te' => '泰卢固语',
      'common.language.th' => '泰语',
      'common.language.tr' => '土耳其语',
      'common.language.uk' => '乌克兰语',
      'common.language.ur' => '乌尔都语',
      'common.language.vi' => '越南语',
      'common.language.yo' => '约鲁巴语',
      'common.language.zh_hans' => '中文（简体）',
      'common.language.zh_hant' => '中文（繁体）',
      'common.theme_mode.light' => '浅色',
      'common.theme_mode.dark' => '深色',
      'common.theme_mode.system' => '跟随系统',
      'common.theme_style.studio' => 'Studio',
      'common.theme_style.bright' => 'Bright',
      'common.provider.anthropic' => 'Anthropic',
      'common.provider.baidu' => '百度',
      'common.provider.caiyun' => '彩云小译',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => '谷歌',
      'common.provider.ollama' => 'Ollama',
      'common.provider.openai' => 'OpenAI',
      'common.provider.sogou' => '搜狗',
      'common.provider.xai' => 'xAI',
      'common.provider.system' => '系统',
      'common.provider.tencent' => '腾讯',
      'common.provider.youdao' => '有道',
      'common.word_pronunciation.us' => '美',
      'common.word_pronunciation.uk' => '英',
      'app.tray.context_menu.show_window' => '显示窗口',
      'app.tray.context_menu.dev_tools.title' => '开发工具',
      'app.tray.context_menu.dev_tools.open_data_directory' => '打开数据目录',
      'app.tray.context_menu.check_for_updates' => '检查更新',
      'app.tray.context_menu.settings' => '设置',
      'app.tray.context_menu.quit' => '退出',
      'mini_translator.limited_banner.permission.missing_both' =>
        '请授予屏幕录制和辅助功能权限以启用完整功能。',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        '请授予屏幕录制权限以启用完整功能。',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        '请授予辅助功能权限以启用完整功能。',
      'mini_translator.limited_banner.instruction.app_settings_prefix' => '请前往',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        '，按指引授权后点击',
      'mini_translator.limited_banner.instruction.suffix' => '。',
      'mini_translator.limited_banner.action.app_settings' => '应用设置',
      'mini_translator.limited_banner.action.recheck' => '重新检查',
      'mini_translator.limited_banner.feedback.enabled' => '屏幕取词功能已启用',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '仍缺少所需权限，\n请检查设置后重试。',
      'mini_translator.limited_banner.tooltip.help' => '查看帮助文档',
      'mini_translator.input.hint' => '在此处输入单词或文本',
      'mini_translator.input.extracting_text' => '正在提取文字...',
      'mini_translator.input.hint_translate_to' =>
        ({required Object language}) => '输入单词或文本，翻译为${language}',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '截取屏幕区域并识别文字',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        '读取剪切板内容',
      'mini_translator.toolbar.tooltip.pin' => '固定窗口',
      'mini_translator.toolbar.tooltip.more_actions' => '更多操作',
      'mini_translator.toolbar.menu.extract_from_screen_capture' => '屏幕取词',
      'mini_translator.toolbar.menu.extract_from_clipboard' => '剪贴板取词',
      'mini_translator.toolbar.menu.open_main_window' => '打开主窗口',
      'mini_translator.toolbar.menu.open_settings' => '设置…',
      'mini_translator.button.clear' => '清空',
      'mini_translator.button.translate' => '翻译',
      'mini_translator.button.read' => '朗读',
      'mini_translator.button.copy' => '复制',
      'mini_translator.button.copied' => '已复制',
      'mini_translator.button.bookmark' => '收藏',
      'mini_translator.button.bookmarked' => '已收藏',
      'mini_translator.language.auto_detect' => '自动检测',
      'mini_translator.language.auto_match' => '自动匹配',
      'mini_translator.language.switch_config' => '切换目标',
      'mini_translator.language.more_languages' => '更多语言...',
      'mini_translator.language.manage_common_languages' => '管理常用语言...',
      'mini_translator.language.manage_targets' => '管理翻译目标...',
      'mini_translator.language.add_target' => '添加翻译目标...',
      'mini_translator.message.please_enter_word_or_text' => '未输入或未提取到文本',
      'mini_translator.message.capture_screen_area_canceled' => '截取屏幕区域已取消',
      'mini_translator.message.ocr_service_not_configured' =>
        '未配置默认文字识别服务，请在设置中配置。',
      'mini_translator.message.ocr_recognition_failed' => '文字识别失败',
      'mini_translator.result.translating' => '正在翻译…',
      'mini_translator.result.stale_requery' => '原文已修改 · ⏎ 重新翻译',
      'mini_translator.result.compare_services' => ({required Object count}) =>
          '对比 ${count} 个服务',
      'mini_translator.result.collapse_compare' => '收起对比',
      'mini_translator.result.set_preferred' => '设为首选',
      'mini_translator.result.retry' => '重试',
      'mini_translator.result.no_result' => '所有服务都没有返回结果 —— 检查网络，或换一个服务再试。',
      'mini_translator.result.no_result_note' => '原文已保留，重试不会重复计入历史。',
      'workbench.workspace' => '工作区',
      'workbench.translate' => '翻译',
      'workbench.history' => '历史',
      'workbench.glossary' => '术语库',
      'workbench.recent_languages' => '最近语言',
      'workbench.not_configured' => '尚未配置',
      'workbench.subtitle.translate' => '工作台 · 多服务对照',
      'workbench.subtitle.settings' => '设置',
      'workbench.placeholder.history' => '收藏与历史将在后续版本中提供',
      'workbench.placeholder.glossary' => '术语库管理正在建设中',
      'workbench.glossary_page.add_entry' => '新增条目',
      'workbench.glossary_page.term' => '原文',
      'workbench.glossary_page.translation' => '指定译法',
      'workbench.glossary_page.forbidden' => '禁用',
      'workbench.glossary_page.hits' => '命中',
      'workbench.glossary_page.term_placeholder' => 'teacher forcing',
      'workbench.glossary_page.translation_placeholder' => '教师强制',
      'workbench.glossary_page.forbidden_placeholder' => '强制教学',
      'workbench.glossary_page.search' => '搜索',
      'workbench.glossary_page.search_placeholder' => '搜索术语或指定译法',
      'workbench.glossary_page.search_label' => '搜索术语库',
      'workbench.glossary_page.entry_count' => (
              {required Object name, required Object count}) =>
          '${name} · ${count} 条',
      'workbench.glossary_page.priority_note' => '术语优先级高于任何服务输出',
      'workbench.glossary_page.new_book' => '新建术语库',
      'workbench.glossary_page.new_book_placeholder' => '术语库名称',
      'workbench.glossary_page.rename_book' => '重命名',
      'workbench.glossary_page.delete_book_confirm' => (
              {required Object name, required Object count}) =>
          '删除「${name}」及其中的 ${count} 条术语？',
      'workbench.glossary_page.disabled' => '已停用',
      'workbench.glossary_page.enable' => '启用',
      'workbench.glossary_page.disable' => '停用',
      'workbench.glossary_page.empty_title' => '这个术语库还是空的',
      'workbench.glossary_page.empty_description' =>
        '术语优先级高于任何服务输出。可以逐条新增，也可以把 CSV 拖进来合并。',
      'workbench.glossary_page.no_results_title' => ({required Object query}) =>
          '没有匹配「${query}」的术语',
      'workbench.glossary_page.no_results_description' => '换个关键词，或直接新增一条。',
      'workbench.glossary_page.no_books_title' => '还没有术语库',
      'workbench.glossary_page.no_books_description' =>
        '术语库让指定译法在所有服务里保持一致。先建一个，再往里加词。',
      'workbench.glossary_page.loading' => '正在载入…',
      'workbench.translation.source' => '原文',
      'workbench.translation.target' => '译文',
      'workbench.translation.input_hint' => '输入或粘贴需要翻译的文本',
      'workbench.translation.button' => '翻译',
      'workbench.translation.auto_detected' => '已自动检测',
      'workbench.translation.loading_services' => '正在读取翻译服务…',
      'workbench.translation.no_services' => '请先在设置中配置翻译服务',
      'workbench.translation.translating' => '正在翻译…',
      'workbench.translation.failed' => '翻译失败，请检查服务配置后重试',
      'workbench.translation.empty' => '译文将在这里显示',
      'workbench.translation.service_compare' => '服务对比',
      'workbench.translation.main_translation' => '主译文',
      'workbench.translation.service_unavailable' => '服务暂不可用',
      'workbench.translation.waiting' => '等待翻译',
      'workbench.translation.read' => '朗读',
      'workbench.translation.copy' => '复制',
      'workbench.translation.favorite_unavailable' => '收藏功能将在后续版本中提供',
      'workbench.translation.preferred' => '首选译文',
      'workbench.translation.other_services' => '其他服务',
      'workbench.translation.copy_result' => '复制译文',
      'workbench.translation.copied' => '已复制',
      'workbench.translation.favorite' => '收藏',
      'workbench.translation.terms' => '命中术语',
      'workbench.translation.terms_hint' => '输入后自动比对术语库。',
      'workbench.translation.quality' => '质量信号',
      'workbench.translation.quality_hint' => '译文生成后计算。',
      'workbench.translation.shortcuts' => '快捷键',
      'workbench.translation.other_services_disabled' => '其他服务已停用',
      'workbench.translation.input_hint_translate_to' =>
        ({required Object language}) => '输入或粘贴要翻译的文本，翻译为${language}',
      'workbench.status.runtime_ready' => '翻译运行时已就绪',
      'workbench.status.settings_synced' => '设置已同步',
      'workbench.status.shortcuts' => '⌥Space 小窗 · ⌥⇧2 截图',
      'workbench.version_latest' => '已是最新',
      'workbench.version_checking' => '正在检查…',
      'workbench.check_updates' => '检查更新',
      'settings.version' => 'v{} (Build {})',
      'settings.general.title' => '常规',
      'settings.general.section.permissions' => '系统权限',
      'settings.general.section.ocr' => '文字识别',
      'settings.general.section.directory' => '词典',
      'settings.general.section.translation' => '翻译',
      'settings.general.section.translation_target' => '翻译目标',
      'settings.general.section.languages' => '语言',
      'settings.general.section.input' => '输入设置',
      'settings.general.section.startup' => '启动与集成',
      'settings.general.section.ocr_behaviour' => '取词行为',
      'settings.general.section.translation_behaviour' => '翻译行为',
      'settings.general.row.launch_at_login' => '登录时启动',
      'settings.general.row.show_in_menu_bar' => '在菜单栏中显示',
      'settings.general.row.screen_capture_access' => '授予屏幕录制权限',
      'settings.general.row.screen_selection_access' => '授予辅助功能权限',
      'settings.general.row.default_ocr_service' => '默认文字识别服务',
      'settings.general.row.auto_copy_detected_text' => '自动复制检测到的文本',
      'settings.general.row.default_directory_service' => '默认词典服务',
      'settings.general.row.default_translation_service' => '默认翻译服务',
      'settings.general.row.translation_target_hint' => '配置翻译器使用的语言目标。',
      'settings.general.row.common_languages' => '常用语言',
      'settings.general.row.common_languages_description' => '显示在语言选择列表顶部。',
      'settings.general.row.common_languages_hint' => '选择你常用的语言：',
      'settings.general.row.common_languages_sort' => '按代码排序',
      'settings.general.row.common_languages_reset' => '恢复默认',
      'settings.general.row.common_languages_reset_help' => '恢复为默认的常用语言集合',
      'settings.general.row.common_languages_search' => '搜索语言...',
      'settings.general.row.common_languages_all' => '所有语言',
      'settings.general.row.double_click_copy_result' => '双击复制翻译结果',
      'settings.general.row.submit_with_enter' => '按 Enter 提交',
      'settings.general.row.submit_with_meta_enter_mac' => '按 ⌘ + Enter 提交',
      'settings.general.row.screen_capture_access_hint' => '截图取词需要读取屏幕内容。',
      'settings.general.row.screen_selection_access_hint' =>
        '划词取词需要读取其他应用中选中的文本。',
      'settings.general.row.no_translation_targets' =>
        '还没有翻译目标，添加一条来决定默认译入哪种语言。',
      'settings.general.button.add_provider' => '添加...',
      'settings.general.button.add_target' => '添加目标...',
      'settings.general.button.manage_targets' => '管理翻译目标...',
      'settings.general.button.manage_languages' => '管理常用语言...',
      'settings.general.button.grant' => '授权',
      'settings.general.option.none' => '无',
      'settings.general.option.no_services_available' => '暂无可用服务',
      'settings.general.option.granted' => '已授权',
      'settings.general.option.built_in_ocr' => '内置 OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => '有道 OCR',
      'settings.general.editor.add_target_title' => '添加翻译目标：',
      'settings.general.editor.edit_target_title' => '修改翻译目标：',
      'settings.general.editor.row.source_language' => '源语言',
      'settings.general.editor.row.target_language' => '目标语言',
      'settings.general.editor.title_edit' => '编辑翻译目标',
      'settings.general.editor.subtitle' => '决定某种源语言默认翻译成哪种语言',
      'settings.general.editor.same_language' => '源语言与目标语言相同，换一个目标语言。',
      'settings.general.editor.duplicate' => '已经有一条同样的翻译目标了。',
      'settings.general.editor.hint_auto' => '未匹配到其他规则时，一律译成{}。',
      'settings.general.editor.hint_source' => '检测到{}时，译成{}。',
      'settings.appearance.title' => '外观',
      'settings.appearance.section.app_language' => '显示语言',
      'settings.appearance.section.theme_mode' => '主题模式',
      'settings.appearance.section.theme_style' => '主题风格',
      'settings.appearance.footer' => '更改立即应用到整个窗口。',
      'settings.shortcuts.title' => '快捷键',
      'settings.shortcuts.section.text_extraction' => '文字提取',
      'settings.shortcuts.section.input_assist' => '输入辅助功能',
      'settings.shortcuts.section.submit_mode' => '提交方式',
      'settings.shortcuts.row.toggle_mini_translator' => '显示/隐藏窗口',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '从屏幕选区提取文字',
      'settings.shortcuts.row.extract_text_from_screen_capture' => '从屏幕截图提取文字',
      'settings.shortcuts.row.extract_text_from_clipboard' => '从剪贴板提取文字',
      'settings.shortcuts.row.translate_input' => '翻译输入内容',
      'settings.shortcuts.reset_dialog.title' => '重置快捷键',
      'settings.shortcuts.reset_dialog.message' => '确定要重置所有快捷键为默认值吗？',
      'settings.shortcuts.reset_dialog.confirm' => '重置',
      'settings.shortcuts.reset_dialog.cancel' => '取消',
      'settings.shortcuts.group.global.title' => '全局快捷键',
      'settings.shortcuts.group.global.description' => '在任何应用里都能触发。',
      'settings.shortcuts.group.in_app.title' => '应用内按键',
      'settings.shortcuts.group.in_app.description' => '仅在应用自己的输入框内生效。',
      'settings.shortcuts.reset' => '恢复默认...',
      'settings.advanced.title' => '高级',
      'settings.advanced.api_server' => '本地 API 服务',
      'settings.advanced.api_server_description' =>
        '在 127.0.0.1 上开放翻译 API，供本机集成使用。',
      'settings.advanced.enable' => '启用',
      'settings.advanced.port' => '端口',
      'settings.advanced.running_at' => '运行于 {url}',
      'settings.advanced.disabled' => '已关闭',
      'settings.services.title' => '服务',
      'settings.services.button.add_service' => '添加服务...',
      'settings.services.section.available_services' => '可用服务',
      'settings.services.editor.title' => '添加服务',
      'settings.services.editor.subtitle' => '为已配置的提供商新增一项服务',
      'settings.services.editor.row.model' => '模型',
      'settings.services.editor.row.system_prompt' => '系统提示词',
      'settings.services.editor.prompt_placeholder' => '留空则使用该类型的默认提示词',
      'settings.services.editor.variant_hint' => '{} 已有一项{}服务，这条会作为并列的另一份配置。',
      'settings.services.editor.traditional_note' =>
        '{} 是传统接口，没有模型与提示词可调；服务参数在提供商详情里配置。',
      'settings.services.detail.row.id' => '服务 ID',
      'settings.services.detail.row.name' => '名称',
      'settings.services.detail.row.provider' => '提供商',
      'settings.services.detail.row.type' => '类型',
      'settings.services.detail.delete_dialog.title' => '删除「{}」？',
      'settings.services.detail.delete_dialog.message' => '此服务将从提供商中移除。',
      'settings.services.detail.prompt_variables' =>
        '可用变量：{{sourceLanguage}}、{{targetLanguage}}、{{text}}',
      'settings.services.make_default' => '设为默认',
      'settings.services.item.none_of_kind' => '还没有可用的{}服务。',
      'settings.providers.title' => '提供商',
      'settings.providers.section.services' => '可用服务',
      'settings.providers.section.services_description' =>
        '查看已配置提供商的可用服务，并按服务类型切换。',
      'settings.providers.item.empty' => '暂无已配置的提供商。添加一个提供商以启用翻译服务。',
      'settings.providers.item.loading' => '正在加载提供商...',
      'settings.providers.item.no_services' => '暂无可用服务。',
      'settings.providers.button.add' => '添加提供商...',
      'settings.providers.alert.error' => '错误',
      'settings.providers.intro.body' => '管理应用使用的服务提供商。',
      'settings.providers.intro.warning' => '已连接的提供商可能会处理你发送的文本或图片，请只启用你信任的服务。',
      'settings.providers.editor.row.id' => '提供商 ID',
      'settings.providers.editor.row.type' => '提供商类型',
      'settings.providers.editor.row.default_model' => '默认模型',
      'settings.providers.editor.placeholder.id' => '例如 deepl-main',
      'settings.providers.editor.type_picker.prompt' => '请选择要添加的提供商类型：',
      'settings.providers.editor.type_picker.section_llm' => 'LLM',
      'settings.providers.editor.type_picker.section_traditional' => '传统',
      'settings.providers.editor.tooltip.help' => '帮助',
      'settings.providers.editor.step.next' => '继续',
      'settings.providers.editor.step.back' => '上一步',
      'settings.providers.editor.add_title' => '添加 {}',
      'settings.providers.editor.capability_note.translation' => '加入翻译候选',
      'settings.providers.editor.capability_note.dictionary' => '提供词典释义',
      'settings.providers.editor.capability_note.ocr' => '识别图片中的文字',
      'settings.providers.editor.test.run' => '测试连接',
      'settings.providers.editor.test.running' => '正在测试连接 · 已用 {}s',
      'settings.providers.editor.test.passed_models' => '连接正常 · {} 个模型可用',
      'settings.providers.editor.test.passed_service' => '连接正常 · 服务可用',
      'settings.providers.editor.test.passed_footer' => '已通过连接测试',
      'settings.providers.editor.test.retest' => '重新测试',
      'settings.providers.editor.test.tips_title' => '可以试试',
      'settings.providers.editor.test.tips_llm' =>
        '· 确认密钥与所选提供商类型一致\n· 检查 Base URL 是否需要包含 /v1\n· 在提供商控制台确认该模型已开通',
      'settings.providers.editor.test.tips_traditional' =>
        '· 确认密钥与所选提供商类型一致\n· 在提供商控制台确认服务已开通',
      'settings.providers.editor.test.failed_suffix' => '验证失败',
      'settings.providers.editor.test.passed_suffix' => '已验证',
      'settings.providers.detail.tooltip.edit' => '编辑提供商',
      'settings.providers.detail.row.id_hint' => '创建后不可更改',
      'settings.providers.detail.section.configuration' => '配置',
      'settings.providers.detail.section.models' => '模型',
      'settings.providers.detail.models.loading' => '正在加载模型...',
      'settings.providers.detail.models.empty' => '未找到模型。',
      'settings.providers.detail.models.retry' => '重试',
      'settings.providers.detail.models.refresh' => '刷新列表',
      'settings.providers.detail.models.default_badge' => '默认',
      'settings.providers.detail.models.set_default' => '设为默认',
      'settings.providers.detail.models.fetch_error' => '无法从提供商 API 获取模型。',
      'settings.providers.capability.translation' => '翻译',
      'settings.providers.capability.dictionary' => '词典',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.capability.llm' => 'AI',
      'settings.providers.description.all' => '提供词典查询和文本翻译',
      'settings.providers.description.translation' => '提供语言间文本翻译',
      'settings.providers.description.dictionary' => '提供词典查询和单词释义',
      'settings.providers.description.fallback' => '提供翻译服务',
      'settings.providers.delete_dialog.title' => '删除「{}」？',
      'settings.providers.delete_dialog.message' => '此操作无法撤销。',
      'settings.layout.title' => '设置',
      'settings.layout.empty.title' => '选择一个分类',
      'settings.layout.empty.message' => '从侧边栏选择一个设置分类。',
      'settings.layout.groups' => '设置分组',
      'settings.layout.effect_hint' => '更改即时生效',
      'settings.layout.footer_note' => '译文与密钥仅保存在本机',
      'settings.layout.support' => '支持',
      'settings.about.title' => '关于',
      'settings.about.copy_version_info' => '复制版本信息',
      'settings.about.up_to_date' => '已是最新版本。',
      'settings.about.check_again' => '重新检查',
      'settings.about.links' => '链接',
      'settings.about.website' => '网站',
      'settings.about.github' => 'GitHub',
      'settings.about.report_issue' => '提交问题',
      'settings.about.license' => '许可证',
      'settings.about.open_changelog' => '查看更新日志',
      'settings.about.update' => '更新',
      _ => null,
    };
  }
}
