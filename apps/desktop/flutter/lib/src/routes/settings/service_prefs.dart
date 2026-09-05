import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Checkbox, Dialog;
import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/custom_alert_dialog/show_dialog.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Callout,
        CalloutTone,
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
        DesignThemeContext,
        DesignTypographyStyles,
        Field,
        FieldState,
        HoverRegion,
        Label,
        Pressable,
        SearchField,
        controlDecoration;

/// The sheets and pickers a capability's own settings open — 常用语言,
/// 翻译目标, and the service pickers behind them.
///
/// These moved off 常规 with the rows that raise them: in the deck each
/// capability owns its options end to end, on 服务.

/// 翻译目标 — one source/target pair. The same sheet adds and edits: editing
/// pre-fills the pair and gains 删除, which sits at the *left* of the footer
/// because it acts on what is already there, not on what the sheet is about to
/// produce. 取消 and 保存 stay together on the right.
Future<void> _showTargetDialog(
  BuildContext context, {
  TranslationTarget? target,
}) async {
  final targets = settingsStore.general.translationTargets;
  final index = target == null ? -1 : targets.indexOf(target);
  if (target != null && index < 0) return;

  var source = target?.source ?? kAutoSource;
  var targetLang = target?.target ?? defaultTargetLanguage;
  final editing = target != null;

  final saved = await showDialogInCurrentWindow<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        final tokens = context.tokens;
        final colors = tokens.colors;
        final editor = t.settings.general.editor;

        final sameLanguage = source == targetLang;
        final duplicate = settingsStore.general.translationTargets.indexed.any(
          (entry) =>
              entry.$1 != index &&
              entry.$2.source == source &&
              entry.$2.target == targetLang,
        );
        final canSave = !sameLanguage && !duplicate;

        return Center(
          child: Dialog(
            width: 400,
            children: [
              DialogHeader(
                title: Text(
                  editing
                      ? editor.title_edit
                      : t.settings.general.button.add_target,
                ),
                subtitle: Text(editor.subtitle),
              ),
              DialogBody(
                children: [
                  // The pair reads left to right, with the arrow on the
                  // controls' line rather than the labels'.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _LanguageField(
                          value: source,
                          label: editor.row.source_language,
                          commonLanguageCodes:
                              settingsStore.general.commonLanguages,
                          showAutoDetect: true,
                          showNative: true,
                          onChanged: (v) => setDialogState(() => source = v),
                        ),
                      ),
                      SizedBox(
                        height: 28,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            FluentIcons.arrow_right_20_regular,
                            size: 14,
                            color: colors.fgFaint,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _LanguageField(
                          value: targetLang,
                          label: editor.row.target_language,
                          commonLanguageCodes:
                              settingsStore.general.commonLanguages,
                          showNative: true,
                          onChanged: (v) =>
                              setDialogState(() => targetLang = v),
                        ),
                      ),
                    ],
                  ),
                  if (sameLanguage)
                    Callout(
                      tone: CalloutTone.warn,
                      child: Text(editor.same_language),
                    )
                  else if (duplicate)
                    Callout(
                      tone: CalloutTone.warn,
                      child: Text(editor.duplicate),
                    )
                  else
                    // Not a warning — what the pair will actually do, said
                    // plainly, so the sheet is readable before it is committed.
                    Text(
                      source == kAutoSource
                          ? formatTranslation(
                              editor.hint_auto,
                              args: [getLanguageName(targetLang)],
                            )
                          : formatTranslation(
                              editor.hint_source,
                              args: [
                                getSourceDisplayName(source),
                                getLanguageName(targetLang),
                              ],
                            ),
                      style: tokens.typography.sansStyle(
                        fontSize: 11,
                        height: 1.7,
                        color: colors.fgSubtle,
                      ),
                    ),
                ],
              ),
              DialogFooter(
                children: [
                  if (editing)
                    Button(
                      variant: ButtonVariant.warning,
                      onPressed: () async {
                        final next = [
                          ...settingsStore.general.translationTargets
                        ]..removeAt(index);
                        await settingsStore.updateGeneral(
                          GeneralSettingsPatch(translationTargets: next),
                        );
                        if (context.mounted) Navigator.pop(context, false);
                      },
                      child: Text(t.common.ui.button.delete),
                    ),
                  const Spacer(),
                  Button(
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.md,
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(t.common.ui.button.cancel),
                  ),
                  Button(
                    variant: ButtonVariant.primary,
                    size: ButtonSize.md,
                    enabled: canSave,
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      editing
                          ? t.common.ui.button.save
                          : t.common.ui.button.add,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  if (saved != true) return;

  final next = [...settingsStore.general.translationTargets];
  final entry = TranslationTarget(
    source: source,
    target: targetLang,
    enabled: true,
  );
  if (editing) {
    next[index] = entry;
  } else {
    next.add(entry);
  }
  await settingsStore.updateGeneral(
    GeneralSettingsPatch(translationTargets: next),
  );
}

/// Whether the switch on the target at [index] can be moved.
///
/// 最后一条开着的不给关：一条都不剩时 自动匹配 无处可去，翻译会安静地什么都不
/// 产出。这与 设置 · 服务 不让关掉默认服务是同一条理由 —— 一个只有一个位置的
/// 开关不如不给。要停用最后一条，先添一条别的。
bool canToggleTranslationTarget(List<TranslationTarget> targets, int index) {
  if (index < 0 || index >= targets.length) return false;
  if (!targets[index].enabled) return true;
  return targets.where((target) => target.enabled).length > 1;
}

/// 开关一条翻译目标。关掉的一条留在列表里 —— 它是一条规则，不是一次输入 ——
/// 但不再参与 自动匹配，也不出现在小窗的 切换目标 菜单里。
Future<void> setTranslationTargetEnabled(int index, bool enabled) async {
  final targets = settingsStore.general.translationTargets;
  if (index < 0 || index >= targets.length) return;
  final next = [...targets];
  final target = next[index];
  next[index] = TranslationTarget(
    source: target.source,
    target: target.target,
    enabled: enabled,
  );
  await settingsStore.updateGeneral(
    GeneralSettingsPatch(translationTargets: next),
  );
}

Future<void> showAddTargetDialog(BuildContext context) =>
    _showTargetDialog(context);

Future<void> showEditTargetDialog(
  BuildContext context,
  TranslationTarget target,
) =>
    _showTargetDialog(context, target: target);

Future<void> showCommonLanguagesDialog(BuildContext context) async {
  final result = await showDialogInCurrentWindow<List<String>>(
    context: context,
    builder: (context) => const Center(child: _CommonLanguagesSheet()),
  );

  if (result != null) {
    await settingsStore.updateGeneral(
      GeneralSettingsPatch(commonLanguages: result),
    );
  }
}

/// 常用语言 — the block that sits above the separator in every language menu.
///
/// The setting is an **ordered list**, not a set: the menus print the codes in
/// the order they are stored and drop everything else into 更多语言. So the
/// sheet is the menu, taken apart — 常用 on the left, in menu order and
/// draggable, 更多语言 on the right to pick from. One ticked roster would have
/// hidden the order completely, and re-ticking a language would have silently
/// sent it to the bottom of the menu. The panes hold disjoint sets — a
/// language is in one or the other — so adding and removing read as moves
/// across the divider, which is what they are.
class _CommonLanguagesSheet extends StatefulWidget {
  const _CommonLanguagesSheet();

  @override
  State<_CommonLanguagesSheet> createState() => _CommonLanguagesSheetState();
}

class _CommonLanguagesSheetState extends State<_CommonLanguagesSheet> {
  late final List<String> _selected =
      List<String>.from(settingsStore.general.commonLanguages);
  String _query = '';

  /// Where each code sits in the full roster — what 排序 restores.
  late final Map<String, int> _rosterIndex = {
    for (final (index, code) in supportedLanguages.indexed) code: index,
  };

  final ScrollController _chosenList = ScrollController();

  @override
  void dispose() {
    _chosenList.dispose();
    super.dispose();
  }

  bool _matches(String code) {
    final needle = _query.trim().toLowerCase();
    return '${getLanguageName(code)} ${getLanguageNativeName(code)} $code'
        .toLowerCase()
        .contains(needle);
  }

  bool get _isDefault {
    final defaults = defaultCommonLanguages();
    if (_selected.length != defaults.length) return false;
    for (final (index, code) in _selected.indexed) {
      if (code != defaults[index]) return false;
    }
    return true;
  }

  bool get _isRosterOrder {
    for (var i = 1; i < _selected.length; i++) {
      if ((_rosterIndex[_selected[i - 1]] ?? 0) >
          (_rosterIndex[_selected[i]] ?? 0)) {
        return false;
      }
    }
    return true;
  }

  void _add(String code) {
    setState(() => _selected.add(code));
    // Added to the end, which on a full list is below the fold; without this
    // the left pane looks like it did nothing.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chosenList.hasClients) return;
      _chosenList.jumpTo(_chosenList.position.maxScrollExtent);
    });
  }

  void _remove(String code) => setState(() => _selected.remove(code));

  /// Lifts the row at [from] out of the list and drops it back in at [to].
  void _move(int from, int to) {
    if (from < 0 || to < 0 || to >= _selected.length || to == from) return;
    setState(() {
      final code = _selected.removeAt(from);
      _selected.insert(to, code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final strings = t.settings.general.languages_editor;

    return Dialog(
      width: 620,
      children: [
        DialogHeader(
          title: Text(t.settings.general.row.common_languages),
          subtitle: Text(strings.subtitle),
        ),
        DialogBody(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 296,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radii.box),
                    border: Border.all(
                      color: colors.hairline,
                      width: context.hairlineWidth,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _buildChosenPane(context)),
                      Container(
                        width: context.hairlineWidth,
                        color: colors.hairline,
                      ),
                      Expanded(child: _buildRosterPane(context)),
                    ],
                  ),
                ),
                if (_selected.length > 1) ...[
                  const SizedBox(height: 8),
                  Text(
                    strings.reorder_hint,
                    style: tokens.typography.sansStyle(
                      fontSize: 11,
                      height: 1.7,
                      color: colors.fgSubtle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        DialogFooter(
          children: [
            // Scoped to the whole sheet, so it sits in the footer rather than
            // in either pane's header.
            Button(
              variant: ButtonVariant.plain,
              enabled: !_isDefault,
              onPressed: () => setState(
                () => _selected
                  ..clear()
                  ..addAll(defaultCommonLanguages()),
              ),
              child: Text(strings.reset),
            ),
            const Spacer(),
            Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.md,
              onPressed: () => Navigator.pop(context),
              child: Text(t.common.ui.button.cancel),
            ),
            Button(
              variant: ButtonVariant.primary,
              size: ButtonSize.md,
              onPressed: () =>
                  Navigator.pop(context, List<String>.from(_selected)),
              child: Text(t.common.ui.button.save),
            ),
          ],
        ),
      ],
    );
  }

  /// ── Left: the common block, in menu order ──
  Widget _buildChosenPane(BuildContext context) {
    final strings = t.settings.general.languages_editor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PaneHeader(
          children: [
            Label(
              child: Text(strings.common_pane(count: _selected.length)),
            ),
            const Spacer(),
            Button(
              variant: ButtonVariant.plain,
              size: ButtonSize.xs,
              enabled: _selected.length >= 2 && !_isRosterOrder,
              semanticsLabel: strings.sort_help,
              onPressed: () => setState(
                () => _selected.sort(
                  (a, b) =>
                      (_rosterIndex[a] ?? 0).compareTo(_rosterIndex[b] ?? 0),
                ),
              ),
              child: Text(strings.sort),
            ),
          ],
        ),
        Expanded(
          child: _selected.isEmpty
              ? _PaneEmpty(text: strings.empty_common)
              : ReorderableListView.builder(
                  scrollController: _chosenList,
                  padding: const EdgeInsets.all(4),
                  buildDefaultDragHandles: false,
                  itemCount: _selected.length,
                  onReorderItem: _move,
                  // The list is its own drop indicator; the lifted row keeps
                  // the row look with the accent wash, not a Material shadow.
                  proxyDecorator: (child, index, animation) =>
                      _buildChosenRow(context, index, lifted: true),
                  itemBuilder: (context, index) => KeyedSubtree(
                    key: ValueKey(_selected[index]),
                    child: _buildChosenRow(context, index),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildChosenRow(BuildContext context, int index,
      {bool lifted = false}) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final strings = t.settings.general.languages_editor;
    final code = _selected[index];
    final radius = BorderRadius.circular(tokens.radii.controlSm);

    return HoverRegion(
      builder: (context, hovered) => Container(
        constraints: const BoxConstraints(minHeight: 28),
        padding: const EdgeInsetsDirectional.only(start: 2, end: 4),
        decoration: BoxDecoration(
          borderRadius: radius,
          color: lifted
              ? colors.accent.withValues(alpha: 0.12)
              : hovered
                  ? colors.subtle
                  : null,
        ),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is! KeyDownEvent) return KeyEventResult.ignored;
                  final up = event.logicalKey == LogicalKeyboardKey.arrowUp;
                  final down = event.logicalKey == LogicalKeyboardKey.arrowDown;
                  if (!up && !down) return KeyEventResult.ignored;
                  _move(index, index + (up ? -1 : 1));
                  return KeyEventResult.handled;
                },
                // Rows are keyed by code, so the handle keeps focus across a
                // move and ↑↓ can be pressed repeatedly.
                child: Semantics(
                  label: strings.handle_label(
                    name: getLanguageNativeName(code),
                    position: index + 1,
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: SizedBox.square(
                      dimension: 20,
                      child: Icon(
                        FluentIcons.re_order_dots_vertical_20_regular,
                        size: 14,
                        color: colors.fgFaint,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(child: _LanguageNameText(code: code)),
            const SizedBox(width: 6),
            _LanguageCodeText(code: code),
            const SizedBox(width: 6),
            // Standing, not hover-revealed: the pane opposite carries a + on
            // every row, and side by side an empty column against a full one
            // reads as a missing control.
            Pressable(
              onPressed: () => _remove(code),
              borderRadius: radius,
              semanticsLabel: strings.remove_language(
                name: getLanguageNativeName(code),
              ),
              builder: (context, state) => Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  color: state.hovered ? colors.control : null,
                ),
                child: Icon(
                  FluentIcons.dismiss_12_regular,
                  size: 12,
                  color: hovered ? colors.fgTertiary : colors.fgFaint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ── Right: everything else, to pick from ──
  Widget _buildRosterPane(BuildContext context) {
    final strings = t.settings.general.languages_editor;

    final common = _selected.toSet();
    final rest = [
      for (final code in supportedLanguages)
        if (!common.contains(code)) code,
    ];
    final needle = _query.trim();
    final restRows = needle.isEmpty
        ? rest
        : [
            for (final c in rest)
              if (_matches(c)) c
          ];
    // A search that only turns up languages already common needs saying so.
    final hiddenByCommon = needle.isNotEmpty && _selected.any(_matches);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PaneHeader(
          children: [
            Label(child: Text(strings.more_pane(count: rest.length))),
            const Spacer(),
            // Kept open rather than folded behind a magnifier — over a roster
            // this long, search is the way in, not an extra.
            SizedBox(
              width: 132,
              child: SearchField(
                value: _query,
                onChanged: (value) => setState(() => _query = value),
                placeholder: strings.search,
                shortcut: '',
                semanticsLabel: strings.search,
              ),
            ),
          ],
        ),
        Expanded(
          child: restRows.isEmpty
              ? _PaneEmpty(
                  text: rest.isEmpty
                      ? strings.all_in_common
                      : hiddenByCommon
                          ? strings.matches_in_common(query: needle)
                          : strings.no_matches(query: needle),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: restRows.length,
                  itemBuilder: (context, index) =>
                      _buildRosterRow(context, restRows[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildRosterRow(BuildContext context, String code) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final strings = t.settings.general.languages_editor;

    return Pressable(
      onPressed: () => _add(code),
      borderRadius: BorderRadius.circular(tokens.radii.controlSm),
      semanticsLabel: strings.add_language(
        name: getLanguageNativeName(code),
      ),
      builder: (context, state) => Container(
        constraints: const BoxConstraints(minHeight: 28),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tokens.radii.controlSm),
          color: state.hovered ? colors.subtle : null,
        ),
        child: Row(
          children: [
            Expanded(child: _LanguageNameText(code: code)),
            const SizedBox(width: 6),
            _LanguageCodeText(code: code),
            const SizedBox(width: 6),
            SizedBox.square(
              dimension: 20,
              child: Icon(
                FluentIcons.add_16_regular,
                size: 13,
                color: state.hovered ? colors.accentText : colors.fgFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The band over a pane's list — a label, and whatever that pane acts on.
class _PaneHeader extends StatelessWidget {
  const _PaneHeader({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      // 36 rather than the React 32: the compact SearchField keeps the shared
      // 28px control box, and 32 would leave it 2px of air.
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.hairline,
            width: context.hairlineWidth,
          ),
        ),
      ),
      child: Row(children: children),
    );
  }
}

/// What a pane says when it has no rows to show.
class _PaneEmpty extends StatelessWidget {
  const _PaneEmpty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: tokens.typography.sansStyle(
            fontSize: 11,
            height: 1.7,
            color: tokens.colors.fgSubtle,
          ),
        ),
      ),
    );
  }
}

/// `English 英语`; the native name leads, since that is what the menu prints.
class _LanguageNameText extends StatelessWidget {
  const _LanguageNameText({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final native = getLanguageNativeName(code);
    final label = getLanguageName(code);

    return Text.rich(
      TextSpan(
        text: native,
        style: tokens.typography.sansStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w500,
          color: colors.fg,
        ),
        children: [
          if (label != native)
            TextSpan(
              text: ' $label',
              style: tokens.typography.sansStyle(
                fontSize: 12,
                height: 1,
                color: colors.fgSubtle,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// The machine name, in its own column down the right edge of a pane.
class _LanguageCodeText extends StatelessWidget {
  const _LanguageCodeText({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Text(
      code,
      style: tokens.typography.monoStyle(
        fontSize: 11,
        height: 1,
        color: tokens.colors.fgFaint,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Native dropdown helpers
// ──────────────────────────────────────────────────────────────────────────────

/// The language menu that is up, or the last one that was — released on the
/// next open rather than on close, for the reason [_openLanguageMenu] gives.
nativeapi.Menu? _liveLanguageMenu;
List<nativeapi.MenuItem> _liveLanguageItems = const [];

void _releaseLanguageMenu() {
  for (final item in _liveLanguageItems) {
    item.dispose();
  }
  _liveLanguageItems = const [];
  _liveLanguageMenu?.dispose();
  _liveLanguageMenu = null;
}

/// A language picker field that opens a native menu with grouped languages.
class _LanguageField extends StatelessWidget {
  const _LanguageField({
    required this.value,
    required this.label,
    required this.commonLanguageCodes,
    this.showAutoDetect = false,
    this.showNative = false,
    required this.onChanged,
  });

  final String value;
  final String label;
  final List<String> commonLanguageCodes;
  final bool showAutoDetect;
  final bool showNative;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.colors;
    final radius = BorderRadius.circular(tokens.radii.control);

    return Field(
      label: Text(label),
      child: Pressable(
        onPressed: () => _openLanguageMenu(context),
        borderRadius: radius,
        semanticsLabel: label,
        builder: (context, state) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: controlDecoration(
            tokens,
            state: FieldState.standard,
            focused: state.focused,
            hairline: context.hairlineWidth,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedLabel(),
                  overflow: TextOverflow.ellipsis,
                  style: tokens.typography.sansStyle(
                    fontSize: 12,
                    height: 1,
                    color: colors.fg,
                  ),
                ),
              ),
              Icon(
                FluentIcons.chevron_down_20_regular,
                size: 13,
                color: colors.fgSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _selectedLabel() {
    if (showAutoDetect && value == kAutoSource) {
      return t.mini_translator.language.auto_detect;
    }
    return getLanguageName(value, showNative: showNative);
  }

  void _openLanguageMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final offset = Offset(position.dx, position.dy + renderBox.size.height);

    final window = nativeapi.WindowManager.instance.getCurrent();
    if (window == null) return;

    final menu = nativeapi.Menu.create()!;
    final menuItems = <nativeapi.MenuItem>[];
    final itemIds = <int, String>{};

    void onItemEvent(nativeapi.MenuEvent e) {
      if (e is! nativeapi.MenuItemClickedEvent) return;
      final v = itemIds[e.itemId];
      if (v != null) onChanged(v);
    }

    // Auto detect
    if (showAutoDetect) {
      final item = nativeapi.MenuItem.createWithLabelAndType(
        t.mini_translator.language.auto_detect,
        nativeapi.MenuItemType.normal,
      )!;
      menuItems.add(item);
      itemIds[item.id] = kAutoSource;
      item.addListener(onItemEvent);
      menu.addItem(item);
    }

    // Common languages
    final common = getCommonLanguages(commonLanguageCodes);
    for (final lang in common) {
      final item = nativeapi.MenuItem.createWithLabelAndType(
        getLanguageName(lang, showNative: showNative),
        nativeapi.MenuItemType.normal,
      )!;
      menuItems.add(item);
      itemIds[item.id] = lang;
      item.addListener(onItemEvent);
      menu.addItem(item);
    }

    // Other languages
    final other = getOtherLanguages(commonLanguageCodes);
    if (other.isNotEmpty && common.isNotEmpty) {
      menu.addSeparator();
    }
    for (final lang in other) {
      final item = nativeapi.MenuItem.createWithLabelAndType(
        getLanguageName(lang, showNative: showNative),
        nativeapi.MenuItemType.normal,
      )!;
      menuItems.add(item);
      itemIds[item.id] = lang;
      item.addListener(onItemEvent);
      menu.addItem(item);
    }

    // Deliberately *not* torn down on close: AppKit closes the menu before it
    // fires the item's action, and disposing a MenuItem drops it from the
    // table the click callback looks itself up in — so releasing here would
    // swallow the very selection that closed the menu. The previous menu is
    // released on the next open instead.
    _releaseLanguageMenu();
    _liveLanguageMenu = menu;
    _liveLanguageItems = menuItems;

    final strategy = nativeapi.PositioningStrategy.relativeWithWindowAndOffset(
      window,
      offset,
    );
    if (strategy == null) return;
    menu.open(strategy, nativeapi.Placement.bottomStart);
  }
}

/// Opens a native menu for service selection.
