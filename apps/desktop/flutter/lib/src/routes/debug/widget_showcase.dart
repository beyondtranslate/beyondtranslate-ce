import 'package:flutter/material.dart' hide Divider;
import 'package:go_router/go_router.dart';

import '../../widgets/definition_card.dart';
import '../../widgets/glossary_hit.dart';
import '../../widgets/history_row.dart';
import '../../widgets/icon_action_button.dart';
import '../../widgets/language_pair.dart';
import '../../widgets/navigation_item.dart';
import '../../widgets/section_label.dart';
import '../../widgets/service_selector.dart';
import '../../widgets/translation_pane.dart';
import '../../widgets/translation_text_area.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonVariant,
        DesignThemeContext,
        DesignTypographyStyles,
        Divider,
        Kbd,
        KbdVariant,
        SidebarGroup,
        Spinner,
        SpinnerSize,
        Surface,
        SurfacePadding,
        SurfaceTone;
import '../../widgets/workbench.dart';

List<RouteBase> get $appRoutes => <RouteBase>[
  GoRoute(
    path: '/debug/widgets',
    builder: (BuildContext context, GoRouterState state) =>
        const WidgetShowcasePage(),
  ),
];

class WidgetShowcasePage extends StatefulWidget {
  const WidgetShowcasePage({super.key});

  @override
  State<WidgetShowcasePage> createState() => _WidgetShowcasePageState();
}

class _WidgetShowcasePageState extends State<WidgetShowcasePage> {
  String _serviceId = 'local';
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          const SectionLabel(index: '01', label: '基础控件'),
          const SizedBox(height: 12),
          Surface(
            tone: SurfaceTone.raised,
            padding: SurfacePadding.lg,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Button(
                  variant: ButtonVariant.primary,
                  onPressed: () {},
                  child: const Text('主操作'),
                ),
                Button(
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                  child: const Text('描边操作'),
                ),
                const Button(
                  variant: ButtonVariant.quiet,
                  onPressed: null,
                  child: Text('不可用'),
                ),
                const Button(
                  variant: ButtonVariant.quiet,
                  onPressed: null,
                  child: Spinner(size: SpinnerSize.sm),
                ),
                IconActionButton(
                  icon: Icons.bookmark_border,
                  tooltip: '收藏',
                  onPressed: () {},
                ),
                const Kbd('⌥ Space', variant: KbdVariant.key),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const SectionLabel(index: '02', label: '浮层流 / 1a'),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Surface(
              tone: SurfaceTone.raised,
              padding: SurfacePadding.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LanguagePair(source: '英语', target: '简体中文'),
                  const SizedBox(height: 16),
                  const TranslationTextArea(
                    hintText: '输入或粘贴需要翻译的文本',
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '译文 · 本地服务',
                        style: context.typography.labelStyle(
                          color: context.colors.accentText,
                        ),
                      ),
                      const Spacer(),
                      Button(
                        variant: ButtonVariant.primary,
                        onPressed: () {},
                        child: const Text('翻译'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '循环瓶颈通常出现在序列模型的长距离依赖处理中。',
                    style: TextStyle(fontSize: 14, height: 1.7),
                  ),
                  const SizedBox(height: 12),
                  const DefinitionCard(
                    term: 'recurrence bottleneck',
                    pronunciation: '/rɪˈkʌrəns/',
                    definition: '循环神经网络在序列处理时形成的性能瓶颈。',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const SectionLabel(index: '03', label: '工作台 / 1b'),
          const SizedBox(height: 12),
          SizedBox(
            height: 520,
            child: Workbench(
              sidebar: [
                SidebarGroup(
                  first: true,
                  label: const Text('工作区'),
                  children: [
                    NavigationItem(
                      label: '翻译',
                      icon: Icons.translate,
                      selected: true,
                      onTap: () {},
                    ),
                    NavigationItem(
                      label: '术语库',
                      icon: Icons.menu_book_outlined,
                      onTap: () {},
                    ),
                    NavigationItem(
                      label: '历史',
                      icon: Icons.history,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
              child: Column(
                children: [
                  WorkbenchToolbar(
                    title: '翻译',
                    subtitle: 'attention-is-all-you-need · §3.2',
                    children: [
                      const Spacer(),
                      const LanguagePair(source: '英语', target: '简体中文'),
                      const SizedBox(width: 12),
                      Switch(
                        value: _enabled,
                        onChanged: (value) => setState(() => _enabled = value),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TranslationPane(
                            label: '原文',
                            language: '英语',
                            text: 'The dominant sequence transduction models are based on complex recurrent or convolutional neural networks.',
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
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: GlossaryHit(
                            source: 'token',
                            target: '词元',
                            collection: '机器学习 · 42 条',
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 260,
                          child: ServiceSelector(
                            services: const [
                              ServiceOption(
                                id: 'local',
                                name: '本地服务',
                                preview: '离线可用',
                                tag: '主译文',
                              ),
                              ServiceOption(
                                id: 'cloud',
                                name: '云端服务',
                                preview: '更适合长文',
                                tag: '候选',
                              ),
                            ],
                            selectedId: _serviceId,
                            onSelected: (value) =>
                                setState(() => _serviceId = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const SectionLabel(index: '04', label: '历史'),
          const SizedBox(height: 12),
          Surface(
            child: Column(
              children: [
                HistoryRow(
                  term: 'teacher forcing',
                  translation: '教师强制 · 训练时喂入真实词元',
                  timestamp: '今天 14:20',
                  onTap: () {},
                ),
                const Divider(),
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
    );
  }
}
