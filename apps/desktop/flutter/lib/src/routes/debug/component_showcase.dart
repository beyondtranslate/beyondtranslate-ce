import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/definition_card.dart';
import '../../widgets/engine_selector.dart';
import '../../widgets/glossary_hit.dart';
import '../../widgets/history_row.dart';
import '../../widgets/language_pair.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/translation_pane.dart';
import '../../widgets/translation_text_area.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/icon_action_button.dart';
import '../../widgets/ui/keycap.dart';
import '../../widgets/ui/panel.dart';
import '../../widgets/ui/section_divider.dart';
import '../../widgets/ui/section_label.dart';
import '../../widgets/ui/themes/design_theme.dart';
import '../../widgets/workbench.dart';

List<RouteBase> get $appRoutes => <RouteBase>[
      GoRoute(
        path: '/debug/components',
        builder: (BuildContext context, GoRouterState state) =>
            const ComponentShowcasePage(),
      ),
    ];

class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  String _engineId = 'local';
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: designTheme(Theme.of(context)),
      child: Scaffold(
        appBar: AppBar(title: const Text('UI Components')),
        body: ListView(
          padding: const EdgeInsets.all(UiSpace.xl),
          children: [
            const SectionLabel(index: '01', label: '基础组件'),
            const SizedBox(height: UiSpace.sm),
            Panel(
              showCorners: true,
              elevated: true,
              child: Wrap(
                spacing: UiSpace.sm,
                runSpacing: UiSpace.sm,
                children: [
                  Button.filled(
                    minSize: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    borderRadius: BorderRadius.zero,
                    onPressed: () {},
                    child: const Text('主操作'),
                  ),
                  Button.outlined(
                    minSize: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    borderRadius: BorderRadius.zero,
                    onPressed: () {},
                    child: const Text('描边操作'),
                  ),
                  const Button(
                    minSize: 32,
                    onPressed: null,
                    child: Text('不可用'),
                  ),
                  const Button(
                    processing: true,
                    minSize: 32,
                    onPressed: null,
                    child: Text('加载中'),
                  ),
                  IconActionButton(
                    icon: Icons.bookmark_border,
                    tooltip: '收藏',
                    onPressed: () {},
                  ),
                  const Keycap('⌥ Space'),
                ],
              ),
            ),
            const SizedBox(height: UiSpace.xl),
            const SectionLabel(index: '02', label: '浮层流 / 1a'),
            const SizedBox(height: UiSpace.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Panel(
                elevated: true,
                showCorners: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LanguagePair(source: '英语', target: '简体中文'),
                    const SizedBox(height: UiSpace.md),
                    const TranslationTextArea(
                      hintText: '输入或粘贴需要翻译的文本',
                      minLines: 3,
                      maxLines: 5,
                    ),
                    const SizedBox(height: UiSpace.md),
                    Row(
                      children: [
                        Text(
                          '译文 · 本地引擎',
                          style: context.eyebrowTextStyle,
                        ),
                        const Spacer(),
                        Button.filled(
                          minSize: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          borderRadius: BorderRadius.zero,
                          onPressed: () {},
                          child: const Text('翻译'),
                        ),
                      ],
                    ),
                    const SizedBox(height: UiSpace.sm),
                    const Text(
                      '循环瓶颈通常出现在序列模型的长距离依赖处理中。',
                      style: TextStyle(fontSize: 14, height: 1.7),
                    ),
                    const SizedBox(height: UiSpace.sm),
                    const DefinitionCard(
                      term: 'recurrence bottleneck',
                      pronunciation: '/rɪˈkʌrəns/',
                      definition: '循环神经网络在序列处理时形成的性能瓶颈。',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UiSpace.xl),
            const SectionLabel(index: '03', label: '工作台 / 1b'),
            const SizedBox(height: UiSpace.sm),
            SizedBox(
              height: 520,
              child: Workbench(
                subtitle: 'attention-is-all-you-need · §3.2',
                sidebar: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiSpace.sm,
                    ),
                    child: Text(
                      '工作区',
                      style: context.eyebrowTextStyle.copyWith(fontSize: 9),
                    ),
                  ),
                  NavigationItem(
                    label: '翻译',
                    icon: Icons.translate,
                    selected: true,
                    onTap: () {},
                  ),
                  NavigationItem(
                    label: '文档翻译',
                    icon: Icons.article_outlined,
                    onTap: () {},
                  ),
                  NavigationItem(
                    label: '收藏与历史',
                    icon: Icons.bookmark_outline,
                    onTap: () {},
                  ),
                  NavigationItem(
                    label: '术语表',
                    icon: Icons.menu_book_outlined,
                    onTap: () {},
                  ),
                ],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(UiSpace.md),
                      child: Row(
                        children: [
                          const LanguagePair(
                            source: '英语',
                            target: '简体中文',
                          ),
                          const Spacer(),
                          Switch(
                            value: _enabled,
                            onChanged: (value) =>
                                setState(() => _enabled = value),
                          ),
                        ],
                      ),
                    ),
                    const SectionDivider(),
                    const Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TranslationPane(
                              label: '原文',
                              language: '英语',
                              text:
                                  'The dominant sequence transduction models are based on complex recurrent or convolutional neural networks.',
                            ),
                          ),
                          VerticalDivider(width: 1),
                          Expanded(
                            child: TranslationPane(
                              label: '译文',
                              language: '简体中文',
                              highlighted: true,
                              text: '主流的序列转换模型通常建立在复杂的循环神经网络或卷积神经网络之上。',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionDivider(),
                    Padding(
                      padding: const EdgeInsets.all(UiSpace.sm),
                      child: Row(
                        children: [
                          const Expanded(
                            child: GlossaryHit(
                              source: 'token',
                              target: '词元',
                              collection: '机器学习 · 42 条',
                            ),
                          ),
                          const SizedBox(width: UiSpace.sm),
                          SizedBox(
                            width: 260,
                            child: EngineSelector(
                              engines: const [
                                EngineOption(
                                  id: 'local',
                                  name: '本地引擎',
                                  preview: '离线可用',
                                  tag: '主译文',
                                ),
                                EngineOption(
                                  id: 'cloud',
                                  name: '云端引擎',
                                  preview: '更适合长文',
                                  tag: '候选',
                                ),
                              ],
                              selectedId: _engineId,
                              onSelected: (value) =>
                                  setState(() => _engineId = value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UiSpace.xl),
            const SectionLabel(index: '04', label: '收藏与历史'),
            const SizedBox(height: UiSpace.sm),
            Panel(
              child: Column(
                children: [
                  HistoryRow(
                    term: 'teacher forcing',
                    translation: '教师强制 · 训练时喂入真实词元',
                    timestamp: '今天 14:20',
                    onTap: () {},
                  ),
                  const SectionDivider(),
                  HistoryRow(
                    term: 'ablation study',
                    translation: '消融实验 · 逐一去掉组件看效果变化',
                    timestamp: '今天 11:06',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
