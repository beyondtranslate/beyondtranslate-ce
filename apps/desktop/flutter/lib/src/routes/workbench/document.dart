import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../widgets/icon_action_button.dart';
import '../../widgets/ui.dart'
    show
        Badge,
        BadgeTone,
        Button,
        ButtonVariant,
        Callout,
        CalloutTone,
        DesignThemeContext,
        DesignTypographyStyles,
        Label,
        LabelTone,
        Pressable,
        ProgressBar,
        ProgressTone,
        Rail,
        SegmentedControl,
        SegmentedItem,
        Step,
        StepList,
        StepStatus,
        Thumbnail,
        WindowFooter;
import '../../widgets/workbench.dart' show WorkbenchToolbar;

/// The deck's sample document, until the runtime translates real files.
class _Document {
  static const name = 'attention-is-all-you-need.pdf';
  static const meta = 'attention-is-all-you-need.pdf · 15 页 · 2.4 MB';
  static const pages = 15;
  static const segments = 392;
  static const eta = '预计还需 2 分 10 秒';
}

class _Sheet {
  const _Sheet({
    required this.page,
    required this.label,
    required this.paragraphs,
  });

  final int page;
  final String label;
  final List<({String source, String translation})> paragraphs;
}

const _sheets = <_Sheet>[
  _Sheet(
    page: 1,
    label: '摘要',
    paragraphs: [
      (
        source:
            'The dominant sequence transduction models are based on complex recurrent or convolutional neural networks that include an encoder and a decoder.',
        translation: '目前主流的序列转换模型建立在复杂的循环或卷积神经网络之上，其中同时包含编码器与解码器。',
      ),
      (
        source:
            'We propose a new simple network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely.',
        translation: '我们提出一种更简单的新架构 —— Transformer，它完全建立在注意力机制之上，彻底摒弃了循环与卷积。',
      ),
    ],
  ),
  _Sheet(
    page: 2,
    label: '模型结构',
    paragraphs: [
      (
        source:
            'The Transformer follows this overall architecture using stacked self-attention and point-wise, fully connected layers for both the encoder and decoder.',
        translation: 'Transformer 沿用了这一整体架构，在编码器与解码器两侧都堆叠自注意力层与逐位置的全连接层。',
      ),
      (
        source:
            'The encoder is composed of a stack of N = 6 identical layers. Each layer has two sub-layers: a multi-head self-attention mechanism, and a position-wise fully connected feed-forward network.',
        translation: '编码器由 N = 6 个相同的层堆叠而成。每层包含两个子层：多头自注意力机制，以及逐位置的全连接前馈网络。',
      ),
    ],
  ),
  _Sheet(
    page: 3,
    label: '注意力机制',
    paragraphs: [
      (
        source:
            'An attention function can be described as mapping a query and a set of key-value pairs to an output, where the query, keys, values, and output are all vectors.',
        translation: '注意力函数可以描述为把一个查询和一组键值对映射到输出，其中查询、键、值与输出均为向量。',
      ),
      (
        source:
            "We call our particular attention 'Scaled Dot-Product Attention'. The input consists of queries and keys of dimension dk, and values of dimension dv.",
        translation: '我们把所用的注意力称为「缩放点积注意力」。其输入由维度为 dk 的查询与键、维度为 dv 的值组成。',
      ),
    ],
  ),
];

const _history = <({String name, String meta, String langs, String status})>[
  (
    name: 'attention-is-all-you-need.pdf',
    meta: '15 页 · 392 段 · 今天 14:02',
    langs: '英语 → 简体中文',
    status: '已导出',
  ),
  (
    name: 'gpt-4-technical-report.pdf',
    meta: '98 页 · 2,410 段 · 昨天',
    langs: '英语 → 简体中文',
    status: '已完成',
  ),
  (
    name: 'Q3-产品需求说明.docx',
    meta: '12 页 · 186 段 · 7 月 28 日',
    langs: '简体中文 → 英语',
    status: '已完成',
  ),
];

enum _Phase { idle, processing, done }

enum _ReadingMode { compare, alternate, translated }

/// 文档翻译 — the deck's DocumentView: a drop-zone idle state with the
/// translation history, then the PDF-reader layout — page rail, reading
/// canvas, and the Xcode-style pipeline footer whose detail folds out above
/// it. UI only; the pipeline is simulated.
class WorkbenchDocumentPage extends StatefulWidget {
  const WorkbenchDocumentPage({super.key});

  @override
  State<WorkbenchDocumentPage> createState() => _WorkbenchDocumentPageState();
}

class _WorkbenchDocumentPageState extends State<WorkbenchDocumentPage> {
  _Phase _phase = _Phase.idle;
  double _progress = 0;
  _ReadingMode _readingMode = _ReadingMode.compare;
  int _page = 1;
  int _zoom = 100;

  /// The pipeline detail is collapsed by default — reading owns the pane.
  bool _detailsOpen = false;
  Timer? _ticker;
  final ScrollController _canvasController = ScrollController();
  final List<GlobalKey> _sheetKeys = [
    for (final _ in _sheets) GlobalKey(),
  ];

  @override
  void dispose() {
    _ticker?.cancel();
    _canvasController.dispose();
    super.dispose();
  }

  /// 选择文件 → 处理中 → 已完成, visible without a real pipeline.
  void _startPipeline() {
    _ticker?.cancel();
    setState(() {
      _phase = _Phase.processing;
      _progress = 0;
      _page = 1;
      _detailsOpen = false;
    });
    _ticker = Timer.periodic(const Duration(milliseconds: 240), (timer) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + 4).clamp(0, 100);
        if (_progress >= 100) {
          _phase = _Phase.done;
          timer.cancel();
        }
      });
    });
  }

  void _openFinished() {
    _ticker?.cancel();
    setState(() {
      _phase = _Phase.done;
      _progress = 100;
      _page = 1;
    });
  }

  void _close() {
    _ticker?.cancel();
    setState(() {
      _phase = _Phase.idle;
      _progress = 0;
      _detailsOpen = false;
    });
  }

  /// PDF-reader jump: the thumbnails and the toolbar arrows land here.
  void _scrollToPage(int value) {
    final clamped = value.clamp(1, _sheets.length);
    setState(() => _page = clamped);
    final context = _sheetKeys[clamped - 1].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 240),
        alignment: 0,
      );
    }
  }

  bool get _done => _phase == _Phase.done;

  int get _donePages => _done
      ? _Document.pages
      : (_progress / 100 * _Document.pages).round().clamp(1, _Document.pages);

  int get _doneSegments => _done
      ? _Document.segments
      : (_progress / 100 * _Document.segments).round();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WorkbenchToolbar(
          title: t.workbench.document,
          children: _phase == _Phase.idle
              ? [
                  const SizedBox(width: 4),
                  Text(
                    '支持 PDF · Word · Markdown',
                    style: context.typography.sansStyle(
                      fontSize: 12,
                      color: colors.fgSubtle,
                    ),
                  ),
                  const Spacer(),
                  Button(
                    onPressed: _startPipeline,
                    child: const Text('打开文件…'),
                  ),
                ]
              : [
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _Document.meta,
                      overflow: TextOverflow.ellipsis,
                      style: context.typography.sansStyle(
                        fontSize: 12,
                        color: colors.fgSubtle,
                      ),
                    ),
                  ),
                  Button(
                    variant: ButtonVariant.plain,
                    onPressed: _close,
                    child: const Text('关闭文档'),
                  ),
                  const SizedBox(width: 12),
                  Button(
                    enabled: _done,
                    shortcut: const Text('⌘⇧E'),
                    child: const Text('导出'),
                  ),
                ],
        ),
        Expanded(
          child: _phase == _Phase.idle
              ? _buildIdle(context)
              : _buildReader(context),
        ),
      ],
    );
  }

  /// 空态 — the drop zone over the translation history.
  Widget _buildIdle(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: colors.inset,
            border: Border.all(color: colors.borderStrong),
            borderRadius: BorderRadius.circular(tokens.radii.card),
          ),
          child: Column(
            children: [
              Text(
                '拖入文档开始翻译',
                style: tokens.typography.sansStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: colors.fg,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Text(
                  '支持 PDF / Word / Markdown —— 表格与公式保持原版面，逐段翻译。',
                  textAlign: TextAlign.center,
                  style: tokens.typography.sansStyle(
                    fontSize: 12,
                    height: 1.7,
                    color: colors.fgSubtle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Button(
                variant: ButtonVariant.primary,
                onPressed: _startPipeline,
                child: const Text('选择文件…'),
              ),
              const SizedBox(height: 12),
              Text(
                '也可以把文件拖到 Dock 图标上',
                style: tokens.typography.sansStyle(
                  fontSize: 11,
                  height: 1,
                  color: colors.fgFaint,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Label(child: Text('翻译历史')),
            const Spacer(),
            Text(
              '点击重新打开',
              style: tokens.typography.sansStyle(
                fontSize: 11,
                height: 1,
                color: colors.fgFaint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.border,
              width: context.hairlineWidth,
            ),
            borderRadius: BorderRadius.circular(tokens.radii.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _history.length; i++)
                Pressable(
                  onPressed: _openFinished,
                  isButton: false,
                  showFocusRing: false,
                  builder: (context, state) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: state.hovered ? colors.subtle : null,
                      border: i == 0
                          ? null
                          : Border(
                              top: BorderSide(
                                color: colors.borderHairline,
                                width: context.hairlineWidth,
                              ),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _history[i].name,
                                overflow: TextOverflow.ellipsis,
                                style: tokens.typography.sansStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: colors.fg,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Badge(
                              tone: _history[i].status == '已导出'
                                  ? BadgeTone.success
                                  : BadgeTone.neutral,
                              child: Text(_history[i].status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${_history[i].langs} · ${_history[i].meta}',
                          style: tokens.typography.sansStyle(
                            fontSize: 11,
                            height: 1.5,
                            color: colors.fgSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// 阅读器 — page rail, reading toolbar, canvas and the pipeline footer.
  Widget _buildReader(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Rail(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 6, 10, 8),
              child: Label(
                tone: LabelTone.faint,
                child: Text('页面 · ${_Document.pages}'),
              ),
            ),
            for (final sheet in _sheets) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Thumbnail(
                  page: sheet.page,
                  active: sheet.page == _page,
                  dimmed: !_done && sheet.page > _donePages / 2,
                  onPressed: () => _scrollToPage(sheet.page),
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Label(tone: LabelTone.faint, child: Text('已完成')),
            const SizedBox(height: 5),
            Text.rich(
              TextSpan(
                text: '$_donePages ',
                children: [
                  TextSpan(
                    text: '/ ${_Document.pages} 页',
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.fgSubtle,
                    ),
                  ),
                ],
              ),
              style: tokens.typography.numericStyle(
                fontSize: 17,
                height: 1,
                color: colors.fg,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReaderToolbar(context),
              Expanded(child: _buildCanvas(context)),
              if (_detailsOpen) _buildDetails(context),
              _buildPipelineFooter(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReaderToolbar(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final reading = _sheets[(_page - 1).clamp(0, _sheets.length - 1)];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          IconActionButton(
            icon: FluentIcons.chevron_up_20_regular,
            tooltip: '上一页',
            onPressed: _page <= 1 ? null : () => _scrollToPage(_page - 1),
          ),
          IconActionButton(
            icon: FluentIcons.chevron_down_20_regular,
            tooltip: '下一页',
            onPressed:
                _page >= _sheets.length ? null : () => _scrollToPage(_page + 1),
          ),
          const SizedBox(width: 6),
          Text.rich(
            TextSpan(
              text: '$_page ',
              children: [
                TextSpan(
                  text: '/ ${_Document.pages} 页',
                  style: tokens.typography.sansStyle(
                    fontSize: 11,
                    color: colors.fgSubtle,
                  ),
                ),
              ],
            ),
            style: tokens.typography.numericStyle(
              fontSize: 12,
              height: 1,
              color: colors.fg,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '· ${reading.label}',
            style: tokens.typography.sansStyle(
              fontSize: 11,
              color: colors.fgFaint,
            ),
          ),
          const Spacer(),
          IconActionButton(
            icon: FluentIcons.subtract_20_regular,
            tooltip: '缩小',
            onPressed:
                _zoom <= 70 ? null : () => setState(() => _zoom = _zoom - 10),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$_zoom%',
              textAlign: TextAlign.center,
              style: tokens.typography.numericStyle(
                fontSize: 11,
                height: 1,
                color: colors.fgSubtle,
              ),
            ),
          ),
          IconActionButton(
            icon: FluentIcons.add_20_regular,
            tooltip: '放大',
            onPressed:
                _zoom >= 150 ? null : () => setState(() => _zoom = _zoom + 10),
          ),
          const SizedBox(width: 10),
          SegmentedControl<_ReadingMode>(
            value: _readingMode,
            onChanged: (value) => setState(() => _readingMode = value),
            semanticsLabel: '阅读模式',
            items: const [
              SegmentedItem(value: _ReadingMode.compare, label: Text('对照')),
              SegmentedItem(value: _ReadingMode.alternate, label: Text('交替')),
              SegmentedItem(
                value: _ReadingMode.translated,
                label: Text('仅译文'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(BuildContext context) {
    final colors = context.colors;
    final scale = _zoom / 100;

    return ColoredBox(
      color: colors.inset,
      child: ListView(
        controller: _canvasController,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          for (var i = 0; i < _sheets.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            Center(child: _buildSheet(context, _sheets[i], i, scale)),
          ],
          const SizedBox(height: 12),
          Center(
            child: Text(
              '其余 12 页略',
              style: context.typography.sansStyle(
                fontSize: 11,
                color: colors.fgFaint,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSheet(
    BuildContext context,
    _Sheet sheet,
    int index,
    double scale,
  ) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final ready = _done || sheet.page <= _donePages / 2;

    return Container(
      key: _sheetKeys[index],
      constraints: BoxConstraints(
        maxWidth: (560 * scale).roundToDouble(),
        minHeight: (380 * scale).roundToDouble(),
      ),
      padding: EdgeInsets.fromLTRB(
        38 * scale,
        30 * scale,
        38 * scale,
        14 * scale,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(
          color: colors.border,
          width: context.hairlineWidth,
        ),
        borderRadius: BorderRadius.circular(3),
        boxShadow: tokens.shadows.lift,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < sheet.paragraphs.length; i++) ...[
            if (i > 0) SizedBox(height: 16 * scale),
            _buildParagraph(context, sheet.paragraphs[i], ready, scale),
          ],
          if (!ready) ...[
            SizedBox(height: 16 * scale),
            const Callout(
              tone: CalloutTone.warn,
              child: Text('本页还排在队列中 —— 译好后会自动填充，无需刷新。'),
            ),
          ],
          SizedBox(height: 8 * scale),
          Text(
            '${sheet.page}',
            textAlign: TextAlign.center,
            style: tokens.typography.sansStyle(
              fontSize: 10 * scale,
              height: 1,
              color: colors.fgFaint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(
    BuildContext context,
    ({String source, String translation}) entry,
    bool ready,
    double scale,
  ) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final sourceStyle = tokens.typography.sansStyle(
      fontSize: 11.5 * scale,
      height: 1.75,
      color: ready ? colors.fgMuted : colors.fgFaint,
    );
    final translationStyle = tokens.typography.cjkStyle(
      fontSize: 13 * scale,
      height: 1.85,
      color: colors.fg,
    );

    if (!ready) return Text(entry.source, style: sourceStyle);

    return switch (_readingMode) {
      _ReadingMode.compare => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(entry.source, style: sourceStyle)),
            SizedBox(width: 18 * scale),
            Expanded(child: Text(entry.translation, style: translationStyle)),
          ],
        ),
      _ReadingMode.alternate => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              entry.source,
              style: tokens.typography.sansStyle(
                fontSize: 11 * scale,
                height: 1.7,
                color: colors.fgFaint,
              ),
            ),
            SizedBox(height: 6 * scale),
            Text(entry.translation, style: translationStyle),
          ],
        ),
      _ReadingMode.translated =>
        Text(entry.translation, style: translationStyle),
    };
  }

  /// The pipeline detail, folded out above the footer.
  Widget _buildDetails(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.border,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepList(
            children: [
              const Step(
                status: StepStatus.done,
                label: Text('文本提取'),
                meta: Text('${_Document.pages} 页'),
              ),
              const Step(
                status: StepStatus.done,
                label: Text('版面识别'),
                meta: Text('3 张表格 · 4 个公式'),
              ),
              Step(
                status: _done ? StepStatus.done : StepStatus.active,
                label: const Text('分段翻译'),
                meta: Text('$_doneSegments / ${_Document.segments} 段'),
              ),
              Step(
                status: _done ? StepStatus.done : StepStatus.idle,
                label: const Text('术语一致性校验'),
                meta: _done ? const Text('12 条术语全部命中') : null,
              ),
            ],
          ),
          if (_done) ...[
            const SizedBox(height: 12),
            const Callout(
              tone: CalloutTone.success,
              action: Button(
                variant: ButtonVariant.primary,
                shortcut: Text('⌘⇧E'),
                child: Text('导出'),
              ),
              child: Text('全部 ${_Document.pages} 页已完成 —— 表格与公式保持原版面。'),
            ),
          ],
        ],
      ),
    );
  }

  /// The pipeline lives in the footer, Xcode-style: a slim status bar under
  /// the reading canvas, its detail folding out above.
  Widget _buildPipelineFooter(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;

    return WindowFooter(
      children: [
        Label(
          tone: _done ? LabelTone.subtle : LabelTone.accent,
          child: Text(_done ? '已完成' : '正在处理'),
        ),
        Expanded(
          child: ProgressBar(
            value: _progress,
            tone: _done ? ProgressTone.success : ProgressTone.gradient,
          ),
        ),
        Text(
          '${_progress.round()}%',
          style: tokens.typography.numericStyle(
            fontSize: 12,
            height: 1,
            color: colors.fg,
          ),
        ),
        Text(
          _done ? '${_Document.segments} 段 · 用时 3 分 44 秒' : _Document.eta,
          style: tokens.typography.sansStyle(
            fontSize: 11,
            color: colors.fgSubtle,
          ),
        ),
        IconActionButton(
          icon: FluentIcons.chevron_up_20_regular,
          tooltip: _detailsOpen ? '收起处理详情' : '展开处理详情',
          selected: _detailsOpen,
          iconTurns: _detailsOpen ? 0.5 : 0,
          onPressed: () => setState(() => _detailsOpen = !_detailsOpen),
        ),
      ],
    );
  }
}
