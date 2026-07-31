import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const GalleryApp());

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
        title: 'BeyondTranslate UI',
        color: const Color(0xFF6B4DFF),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, __) => builder(context),
        ),
        home: const Gallery(),
      );
}

class Gallery extends StatefulWidget {
  const Gallery({
    super.key,
    this.initialTheme = DesignThemeName.studioLight,
    this.typography,
  });

  final DesignThemeName initialTheme;

  /// Swaps the type roles onto other faces. The specimen test uses this to
  /// bind the real macOS faces, which `flutter test` does not load by default.
  final DesignTypography? typography;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late DesignThemeName _theme = widget.initialTheme;

  DesignTokens get _tokens {
    final base = _theme.tokens;
    if (widget.typography == null) return base;
    return DesignTokens(
      brightness: base.brightness,
      colors: base.colors,
      radii: base.radii,
      metrics: base.metrics,
      shadows: base.shadows,
      backdrop: base.backdrop,
      progressGradient: base.progressGradient,
      highlightRule: base.highlightRule,
      highlightGlow: base.highlightGlow,
      typography: widget.typography!,
    );
  }

  @override
  Widget build(BuildContext context) => DesignThemeProvider(
        tokens: _tokens,
        child: Builder(
          builder: (context) => ColoredBox(
            color: context.colors.canvas,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ThemeBar(
                  value: _theme,
                  onChanged: (theme) => setState(() => _theme = theme),
                ),
                const Expanded(child: _Atoms()),
              ],
            ),
          ),
        ),
      );
}

class _ThemeBar extends StatelessWidget {
  const _ThemeBar({required this.value, required this.onChanged});

  final DesignThemeName value;
  final ValueChanged<DesignThemeName> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: tokens.colors.chrome,
        border: Border(
          bottom: BorderSide(
            color: tokens.colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'BeyondTranslate UI · Flutter',
            style: tokens.typography.displayStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1,
              color: tokens.colors.fg,
            ),
          ),
          const Spacer(),
          SegmentedControl<DesignThemeName>(
            value: value,
            onChanged: onChanged,
            items: [
              for (final theme in DesignThemeName.values)
                SegmentedItem(
                  value: theme,
                  label: Text(designThemeMeta[theme]!.title),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Atoms extends StatefulWidget {
  const _Atoms();

  @override
  State<_Atoms> createState() => _AtomsState();
}

class _AtomsState extends State<_Atoms> {
  bool _toggle = true;
  bool _checkbox = true;
  String _radio = 'follow';
  String _segment = 'formal';
  String _pill = 'starred';
  String _format = 'pdf';
  String _search = '';
  String _model = 'sonnet';
  int _page = 2;
  bool _unfocused = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Button',
              children: [
                _Row([
                  Button(
                    variant: ButtonVariant.primary,
                    size: ButtonSize.lg,
                    onPressed: () {},
                    shortcut: const Text('⏎'),
                    child: const Text('打开窗口'),
                  ),
                  Button(
                    variant: ButtonVariant.secondary,
                    onPressed: () {},
                    child: const Text('导入术语'),
                  ),
                  Button(onPressed: () {}, child: const Text('复制')),
                  Button(
                    variant: ButtonVariant.quiet,
                    onPressed: () {},
                    child: const Text('设为首选'),
                  ),
                  Button(
                    variant: ButtonVariant.plain,
                    onPressed: () {},
                    child: const Text('测试连接'),
                  ),
                  Button(
                    variant: ButtonVariant.warning,
                    onPressed: () {},
                    child: const Text('与术语表冲突 · 查看'),
                  ),
                  const Button(
                    variant: ButtonVariant.primary,
                    child: Text('已禁用'),
                  ),
                ]),
                _Row([
                  Button(
                    size: ButtonSize.xs,
                    onPressed: () {},
                    child: const Text('xs'),
                  ),
                  Button(
                    size: ButtonSize.sm,
                    onPressed: () {},
                    child: const Text('sm'),
                  ),
                  Button(
                    size: ButtonSize.md,
                    onPressed: () {},
                    child: const Text('md'),
                  ),
                  Button(
                    size: ButtonSize.lg,
                    onPressed: () {},
                    child: const Text('lg'),
                  ),
                ]),
              ],
            ),
            _Section(
              title: 'Badge · Kbd · Label · Avatar',
              children: const [
                _Row([
                  Badge(child: Text('默认')),
                  Badge(tone: BadgeTone.neutral, child: Text('术语表')),
                  Badge(
                    tone: BadgeTone.solid,
                    size: BadgeSize.sm,
                    child: Text('3 ENGINES'),
                  ),
                  Badge(tone: BadgeTone.success, child: Text('已完成')),
                  Badge(tone: BadgeTone.warn, child: Text('需验证')),
                  Badge(tone: BadgeTone.danger, child: Text('已过期')),
                ]),
                _Row([
                  Kbd('⌘K'),
                  Kbd('⌥2', variant: KbdVariant.strong),
                  Kbd('⌘⇧T', variant: KbdVariant.key),
                ]),
                _Row([
                  Label(child: Text('质量信号')),
                  Label(
                    tone: LabelTone.accent,
                    child: Text('内置模型 · 首选译文'),
                  ),
                  Label(
                    tone: LabelTone.warn,
                    child: Text('需要复核'),
                  ),
                  Label(
                    tone: LabelTone.danger,
                    child: Text('密钥无效'),
                  ),
                ]),
                _AvatarRow(),
              ],
            ),
            _Section(
              title: 'Choice controls',
              children: [
                _Row([
                  Switch(
                    checked: _toggle,
                    onChanged: (value) => setState(() => _toggle = value),
                  ),
                  Switch(
                    checked: !_toggle,
                    size: SwitchSize.sm,
                    onChanged: (value) => setState(() => _toggle = !value),
                  ),
                  const Switch(checked: true, enabled: false),
                  Checkbox(
                    checked: _checkbox,
                    onChanged: (value) => setState(() => _checkbox = value),
                    note: const Text('12 条'),
                    child: const Text('包含术语表'),
                  ),
                ]),
                RadioList<String>(
                  value: _radio,
                  onChanged: (value) => setState(() => _radio = value),
                  options: const [
                    RadioItem(value: 'follow', label: Text('气泡跟随光标')),
                    RadioItem(value: 'corner', label: Text('固定在右上角')),
                    RadioItem(value: 'below', label: Text('显示在原文下方')),
                  ],
                ),
                _Row([
                  SegmentedControl<String>(
                    value: _segment,
                    onChanged: (value) => setState(() => _segment = value),
                    items: const [
                      SegmentedItem(value: 'formal', label: Text('正式')),
                      SegmentedItem(value: 'casual', label: Text('口语')),
                      SegmentedItem(value: 'tech', label: Text('技术')),
                    ],
                  ),
                  SegmentedControl<String>(
                    value: _segment,
                    size: SegmentedSize.sm,
                    activeStyle: SegmentedActiveStyle.accent,
                    onChanged: (value) => setState(() => _segment = value),
                    items: const [
                      SegmentedItem(value: 'formal', label: Text('对照')),
                      SegmentedItem(value: 'casual', label: Text('替换')),
                    ],
                  ),
                ]),
                Tabs<String>(
                  value: _pill,
                  onChanged: (value) => setState(() => _pill = value),
                  items: const [
                    TabItem(
                      value: 'starred',
                      label: Text('收藏'),
                      count: 64,
                    ),
                    TabItem(value: 'all', label: Text('全部历史')),
                    TabItem(
                      value: 'mine',
                      label: Text('我改过的'),
                      count: 18,
                    ),
                  ],
                ),
                _Row([
                  SizedBox(
                    width: 190,
                    child: OptionCard(
                      title: const Text('PDF'),
                      description: const Text('保留版面与页码'),
                      selected: _format == 'pdf',
                      onSelect: () => setState(() => _format = 'pdf'),
                    ),
                  ),
                  SizedBox(
                    width: 190,
                    child: OptionCard(
                      title: const Text('Markdown'),
                      description: const Text('纯文本，便于二次编辑'),
                      selected: _format == 'md',
                      onSelect: () => setState(() => _format = 'md'),
                    ),
                  ),
                ]),
              ],
            ),
            _Section(
              title: 'Field',
              children: [
                SizedBox(
                  width: 380,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Field(
                        label: Text('接口地址'),
                        hint: Text('留空则使用官方端点'),
                        child: Input(
                          mono: true,
                          placeholder: 'https://api.anthropic.com',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Field(
                        label: Text('API 密钥'),
                        state: FieldState.error,
                        hint: Text('密钥已过期 · 需重新验证'),
                        child: Input(
                          mono: true,
                          state: FieldState.error,
                          placeholder: 'sk-ant-…',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Field(
                        label: const Text('模型'),
                        child: Select<String>(
                          value: _model,
                          onChanged: (value) => setState(() => _model = value),
                          items: const [
                            SelectItem(
                              value: 'sonnet',
                              label: 'claude-sonnet-4-5',
                            ),
                            SelectItem(
                              value: 'opus',
                              label: 'claude-opus-4-1',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Field(
                        label: Text('提示词'),
                        child: TextArea(placeholder: '保持术语一致…'),
                      ),
                      const SizedBox(height: 16),
                      const FieldValue(mono: true, child: Text('~/Downloads')),
                      const SizedBox(height: 16),
                      SearchField(
                        value: _search,
                        onChanged: (value) => setState(() => _search = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _Section(
              title: 'Surface · Callout · Progress',
              children: [
                const _Row([
                  Surface(child: Text('card')),
                  Surface(tone: SurfaceTone.raised, child: Text('raised')),
                  Surface(tone: SurfaceTone.accent, child: Text('accent')),
                  Surface(tone: SurfaceTone.warn, child: Text('warn')),
                  Surface(tone: SurfaceTone.danger, child: Text('danger')),
                  Surface(
                    tone: SurfaceTone.outline,
                    child: Text('outline'),
                  ),
                ]),
                SizedBox(
                  width: 420,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Callout(
                        tone: CalloutTone.accent,
                        icon: const Spinner(size: SpinnerSize.sm),
                        action: Button(
                          variant: ButtonVariant.quiet,
                          onPressed: () {},
                          child: const Text('取消'),
                        ),
                        child: const Text('正在测试连接 · 已用 1.4s'),
                      ),
                      const SizedBox(height: 10),
                      const Callout(child: Text('预计 3.6 MB · 存至「下载」')),
                      const SizedBox(height: 10),
                      const Callout(
                        tone: CalloutTone.warn,
                        child: Text('表格与公式保持原版面'),
                      ),
                      const SizedBox(height: 10),
                      const Callout(
                        tone: CalloutTone.success,
                        child: Text('全部 15 页已完成'),
                      ),
                      const SizedBox(height: 20),
                      const ProgressBar(value: 64),
                      const SizedBox(height: 10),
                      const ProgressBar(
                        value: 42,
                        tone: ProgressTone.gradient,
                        thickness: ProgressThickness.thick,
                      ),
                      const SizedBox(height: 16),
                      const Meter(label: Text('术语一致性'), value: 92),
                      const SizedBox(height: 16),
                      const StepList(
                        children: [
                          Step(
                            status: StepStatus.done,
                            label: Text('文本提取'),
                            meta: Text('15 页'),
                          ),
                          Step(
                            status: StepStatus.active,
                            label: Text('分段翻译'),
                            meta: Text('168 / 392 段'),
                          ),
                          Step(status: StepStatus.idle, label: Text('校验')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _Section(
              title: 'InfoCard · Stat · SettingRow · DetailBlock',
              children: const [
                _Row([
                  SizedBox(
                    width: 210,
                    child: InfoCard(
                      title: Text('token'),
                      subtitle: Text('词元'),
                      note: Text('（非「标记」）'),
                    ),
                  ),
                  SizedBox(
                    width: 210,
                    child: Surface(
                      tone: SurfaceTone.raised,
                      child: Stat(
                        label: Text('今日'),
                        value: Text('148'),
                        unit: Text('段'),
                        child: SegmentGauge(filled: 2, partial: true),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: SettingRow(
                      label: Text('划词翻译'),
                      trailing: Kbd('⌥Space', variant: KbdVariant.key),
                    ),
                  ),
                ]),
                SizedBox(
                  width: 420,
                  child: Surface(
                    tone: SurfaceTone.none,
                    padding: SurfacePadding.none,
                    clip: true,
                    child: DetailBlock(
                      title: Text('inference'),
                      subtitle: Text('/ˈɪnf(ə)rəns/'),
                      trailing: Badge(child: Text('术语表')),
                      child: Text('名词 · 推理；模型据输入生成输出的过程。'),
                    ),
                  ),
                ),
              ],
            ),
            _Section(
              title: 'DataTable',
              children: [
                SizedBox(
                  width: 560,
                  child: Surface(
                    tone: SurfaceTone.raised,
                    padding: SurfacePadding.none,
                    clip: true,
                    child: DataTable(
                      children: [
                        const DataTableHead(
                          children: [
                            DataTableCell(head: true, child: Text('原文')),
                            DataTableCell(head: true, child: Text('译文')),
                            DataTableCell(
                              head: true,
                              width: 96,
                              child: Text('词性'),
                            ),
                            DataTableCell(
                              head: true,
                              width: 56,
                              align: DataTableCellAlign.end,
                              child: Text('命中'),
                            ),
                          ],
                        ),
                        DataTableRow(
                          active: true,
                          onPressed: () {},
                          children: const [
                            DataTableCell(child: Text('token')),
                            DataTableCell(child: Text('词元')),
                            DataTableCell(width: 96, child: Text('名词')),
                            DataTableCell(
                              width: 56,
                              align: DataTableCellAlign.end,
                              child: Text('42'),
                            ),
                          ],
                        ),
                        DataTableRow(
                          onPressed: () {},
                          children: const [
                            DataTableCell(child: Text('inference')),
                            DataTableCell(child: Text('推理')),
                            DataTableCell(width: 96, child: Text('名词')),
                            DataTableCell(
                              width: 56,
                              align: DataTableCellAlign.end,
                              child: Text('18'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _Section(
              title: 'TextBlock · HighlightBlock · TitledCard',
              children: [
                SizedBox(
                  width: 560,
                  child: Surface(
                    tone: SurfaceTone.raised,
                    padding: SurfacePadding.none,
                    clip: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TextBlock(
                          label: Text('原文 · 第 12 / 38 段'),
                          meta: Text('⌥⏎ 重译'),
                          child: Text(
                            'The model emits one token at a time, and each '
                            'inference step conditions on everything before it.',
                          ),
                        ),
                        HighlightBlock(
                          label: const Text('内置模型 · 首选译文'),
                          meta: const Text('2 处术语已对齐'),
                          actions: ActionBar(
                            children: [
                              Button(
                                size: ButtonSize.xs,
                                onPressed: () {},
                                child: const Text('朗读'),
                              ),
                              Button(
                                size: ButtonSize.xs,
                                onPressed: () {},
                                child: const Text('复制'),
                              ),
                            ],
                          ),
                          child: Builder(
                            builder: (context) => Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: '模型每次只产生一个'),
                                  markSpan(context.tokens, '词元'),
                                  const TextSpan(text: '，每一步'),
                                  markSpan(
                                    context.tokens,
                                    '推断',
                                    tone: MarkTone.warn,
                                  ),
                                  const TextSpan(text: '都以此前的全部内容为条件。'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TitledCard(
                                  title: const Text('Claude'),
                                  avatar: Avatar(
                                    label: 'C',
                                    color: context.colors.engineClaude,
                                  ),
                                  shortcut: const Kbd('⌥2'),
                                  footer: Button(
                                    variant: ButtonVariant.quiet,
                                    onPressed: () {},
                                    child: const Text('设为首选'),
                                  ),
                                  child:
                                      const Text('模型逐个生成词元，每步推理都基于之前的全部上下文。'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TitledCard(
                                  title: const Text('DeepL'),
                                  avatar: Avatar(
                                    label: 'D',
                                    color: context.colors.engineDeepl,
                                  ),
                                  shortcut: const Kbd('⌥3'),
                                  child: const Text(
                                    '该模型一次发出一个标记，每个推理步骤都以之前的内容为条件。',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _Section(
              title: 'ListCard · ListTile · EmptyState',
              children: [
                SizedBox(
                  width: 520,
                  child: Surface(
                    tone: SurfaceTone.raised,
                    padding: SurfacePadding.none,
                    clip: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListCard(
                          active: true,
                          onPressed: () {},
                          eyebrow: const Text('内置模型'),
                          meta: const Text('今天 14:22 · arxiv.org'),
                          flag: const Text('我改过'),
                          primary: const Text('Attention is all you need.'),
                          secondary: const Text('注意力就是你所需要的一切。'),
                        ),
                        ListCard(
                          onPressed: () {},
                          eyebrow: const Text('Claude'),
                          meta: const Text('昨天 09:10'),
                          primary: const Text(
                            'Scaling laws for neural language models.',
                          ),
                          secondary: const Text('神经语言模型的缩放定律。'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 520,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: Avatar(
                          label: 'B',
                          color: context.colors.engineBuiltin,
                          size: AvatarSize.lg,
                        ),
                        title: const Text('内置模型'),
                        subtitle: const Text('本地运行 · 无需密钥'),
                        badge: const Badge(child: Text('默认')),
                        tone: ListTileTone.accent,
                        trailing: [
                          const Kbd('⌥1'),
                          Switch(
                            checked: _toggle,
                            semanticsLabel: '启用内置模型',
                            onChanged: (value) =>
                                setState(() => _toggle = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: Avatar(
                          label: 'C',
                          color: context.colors.engineClaude,
                          size: AvatarSize.lg,
                        ),
                        title: const Text('Claude'),
                        subtitle: const Text('密钥已过期 · 需重新验证'),
                        tone: ListTileTone.warn,
                        trailing: [
                          const Kbd('⌥2'),
                          Switch(
                            checked: false,
                            semanticsLabel: '启用 Claude',
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 520,
                  child: Surface(
                    tone: SurfaceTone.raised,
                    padding: SurfacePadding.none,
                    child: EmptyState(
                      label: const Text('收藏与历史'),
                      title: const Text('还没有收藏'),
                      description: const Text(
                        '翻译结果满意时按 ⌘D 收藏，之后可以在这里检索与整理。',
                      ),
                      action: Button(
                        variant: ButtonVariant.primary,
                        onPressed: () {},
                        child: const Text('去翻译'),
                      ),
                      hint: const Text('⌘D 收藏当前译文'),
                    ),
                  ),
                ),
              ],
            ),
            _Section(
              title: 'Dialog · Popover · PopoverCard · Thumbnail',
              children: [
                _Row([
                  Dialog(
                    children: [
                      const DialogHeader(
                        title: Text('导出译文'),
                        subtitle: Text('15 页 · 392 段'),
                      ),
                      DialogBody(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OptionCard(
                                  title: const Text('PDF'),
                                  description: const Text('保留版面'),
                                  selected: _format == 'pdf',
                                  onSelect: () =>
                                      setState(() => _format = 'pdf'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OptionCard(
                                  title: const Text('DOCX'),
                                  description: const Text('可继续编辑'),
                                  selected: _format == 'docx',
                                  onSelect: () =>
                                      setState(() => _format = 'docx'),
                                ),
                              ),
                            ],
                          ),
                          Checkbox(
                            checked: _checkbox,
                            onChanged: (value) =>
                                setState(() => _checkbox = value),
                            note: const Text('+2.1 MB'),
                            child: const Text('包含原文对照'),
                          ),
                          const Callout(child: Text('预计 3.6 MB · 存至「下载」')),
                        ],
                      ),
                      DialogFooter(
                        children: [
                          Button(
                            variant: ButtonVariant.plain,
                            onPressed: () {},
                            child: const Text('更改位置'),
                          ),
                          const Spacer(),
                          Button(onPressed: () {}, child: const Text('取消')),
                          Button(
                            variant: ButtonVariant.primary,
                            onPressed: () {},
                            child: const Text('导出'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  PopoverWindow(
                    child: PopoverPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: SwapPair(
                              start: 'English',
                              end: '简体中文',
                              onSwap: () {},
                            ),
                          ),
                          const DetailBlock(
                            title: Text('inference'),
                            subtitle: Text('/ˈɪnf(ə)rəns/'),
                            trailing: Badge(child: Text('术语表')),
                            child: Text('名词 · 推理。'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                _Row([
                  PopoverCard(
                    title: const Text('inference'),
                    trailing: const Text('名词 · 术语'),
                    body: const Text('推理'),
                    note: const Text('模型据输入生成输出的过程。'),
                    attribution: const Badge(child: Text('术语表 · ML')),
                    secondaryLabel: const Text('整句'),
                    secondary: const Text('每一步推理都以此前的全部内容为条件。'),
                    actions: ActionBar(
                      children: [
                        Button(
                          size: ButtonSize.xs,
                          onPressed: () {},
                          child: const Text('朗读'),
                        ),
                        Button(
                          size: ButtonSize.xs,
                          onPressed: () {},
                          child: const Text('收藏'),
                        ),
                      ],
                    ),
                    hint: const Kbd('⌥Space 展开全文'),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final page in [1, 2, 3, 4])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 56,
                                child: Thumbnail(
                                  page: page,
                                  active: page == _page,
                                  dimmed: page > _page + 1,
                                  onPressed: () => setState(() => _page = page),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _Row([
                        FloatingBall(),
                        FloatingBall(state: FloatingBallState.translating),
                        FloatingBall(
                          state: FloatingBallState.expanded,
                          summary: '已译 392 段',
                        ),
                      ]),
                    ],
                  ),
                ]),
              ],
            ),
            _Section(
              title: 'BrowserFrame',
              children: [
                BrowserFrame(
                  url: 'https://arxiv.org/abs/1706.03762',
                  status: const Badge(
                    tone: BadgeTone.solid,
                    child: Text('B 已翻译'),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AnnotatedParagraph(
                          source: Text(
                            'The dominant sequence transduction models are '
                            'based on complex recurrent networks.',
                          ),
                          annotation: Text('主流的序列转换模型建立在复杂的循环网络之上。'),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FloatingToolbar(
                            children: [
                              Button(
                                variant: ButtonVariant.quiet,
                                onPressed: () {},
                                child: const Text('对照'),
                              ),
                              const ToolbarSeparator(),
                              Button(
                                variant: ButtonVariant.plain,
                                onPressed: () {},
                                child: const Text('仅译文'),
                              ),
                              const ToolbarSeparator(),
                              const Kbd('⌥T'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _Section(
              title: 'WindowFrame · Sidebar · Stage',
              children: [
                _Row([
                  Checkbox(
                    checked: _unfocused,
                    onChanged: (value) => setState(() => _unfocused = value),
                    child: const Text('窗口失去焦点（选中态去饱和）'),
                  ),
                ]),
                Stage(
                  child: WindowFrame(
                    width: 760,
                    height: 380,
                    unfocused: _unfocused,
                    children: [
                      WindowBody(
                        children: [
                          Sidebar(
                            header: const TrafficLights(),
                            children: [
                              SidebarGroup(
                                first: true,
                                label: const Text('工作区'),
                                children: [
                                  NavItem(
                                    active: true,
                                    onPressed: () {},
                                    child: const Text('翻译'),
                                  ),
                                  NavItem(
                                    onPressed: () {},
                                    child: const Text('文档'),
                                  ),
                                  NavItem(
                                    onPressed: () {},
                                    child: const Text('术语表'),
                                  ),
                                ],
                              ),
                              SidebarGroup(
                                label: const Text('资料'),
                                children: [
                                  NavItem(
                                    onPressed: () {},
                                    child: const Text('收藏与历史'),
                                  ),
                                ],
                              ),
                              const SidebarCard(
                                label: Text('今日'),
                                children: [
                                  Stat(
                                    value: Text('148'),
                                    unit: Text('段'),
                                    child: SegmentGauge(
                                      filled: 2,
                                      partial: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          WindowMain(
                            children: [
                              WindowTitlebar(
                                lights: false,
                                title: const Text('翻译'),
                                subtitle: const Text('English → 简体中文'),
                                children: [
                                  const Spacer(),
                                  SwapPair(
                                    start: 'English',
                                    end: '简体中文',
                                    onSwap: () {},
                                  ),
                                ],
                              ),
                              WindowContent(
                                children: [
                                  Rail(
                                    children: [
                                      RailItem(
                                        active: true,
                                        onPressed: () {},
                                        child: const Text('全部段落'),
                                      ),
                                      RailItem(
                                        onPressed: () {},
                                        child: const Text('已复核'),
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          TextBlock(
                                            label: Text('原文 · 第 12 / 38 段'),
                                            child: Text(
                                              'Attention is all you need.',
                                            ),
                                          ),
                                          HighlightBlock(
                                            label: Text('内置模型 · 首选译文'),
                                            child: Text('注意力就是你所需要的一切。'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Aside(
                                    children: [
                                      Label(child: Text('质量信号')),
                                      Meter(
                                        label: Text('术语一致性'),
                                        value: 92,
                                      ),
                                      Meter(
                                        label: Text('风格贴合'),
                                        value: 71,
                                        tone: ProgressTone.warn,
                                      ),
                                      InfoCard(
                                        title: Text('token'),
                                        subtitle: Text('词元'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              WindowFooter(
                                children: [
                                  const Label(
                                    tone: LabelTone.faint,
                                    child: Text('392 段 · 已译 168'),
                                  ),
                                  const Spacer(),
                                  Button(
                                    variant: ButtonVariant.primary,
                                    onPressed: () {},
                                    child: const Text('导出'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tokens.typography.displayStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1,
              color: tokens.colors.fg,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 16),
          for (final child in children)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: child,
            ),
        ],
      ),
    );
  }
}

/// The avatar sizes, in the shipped engine colours.
class _AvatarRow extends StatelessWidget {
  const _AvatarRow();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _Row([
      Avatar(label: 'B', color: colors.engineBuiltin, size: AvatarSize.xs),
      Avatar(label: 'C', color: colors.engineClaude),
      Avatar(label: 'D', color: colors.engineDeepl, size: AvatarSize.md),
      Avatar(label: '词', color: colors.engineDict, size: AvatarSize.lg),
    ]);
  }
}

/// A wrapping row, so a strip of atoms reflows instead of overflowing.
class _Row extends StatelessWidget {
  const _Row(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
}
