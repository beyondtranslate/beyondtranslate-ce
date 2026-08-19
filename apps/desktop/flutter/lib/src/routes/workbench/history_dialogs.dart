import 'package:flutter/widgets.dart';

import '../../i18n/i18n.dart';
import '../../widgets/ui.dart'
    show
        Button,
        ButtonSize,
        ButtonVariant,
        Checkbox,
        DesignThemeContext,
        DesignTypographyStyles,
        Dialog,
        DialogBody,
        DialogFooter,
        DialogHeader,
        Label,
        LabelTone,
        OptionCard;

/// What a list of translation pairs can become. A document exports as a
/// document; a list of pairs exports as data, so these are the three shapes
/// the data takes.
enum HistoryExportFormat { csv, markdown, tmx }

extension HistoryExportFormatX on HistoryExportFormat {
  String get label => switch (this) {
        HistoryExportFormat.csv => 'CSV',
        HistoryExportFormat.markdown => 'Markdown',
        HistoryExportFormat.tmx => 'TMX',
      };

  String get extension => switch (this) {
        HistoryExportFormat.csv => 'csv',
        HistoryExportFormat.markdown => 'md',
        HistoryExportFormat.tmx => 'tmx',
      };

  String get hint => switch (this) {
        HistoryExportFormat.csv => t.workbench.history_page.format_csv_hint,
        HistoryExportFormat.markdown => t.workbench.history_page.format_md_hint,
        HistoryExportFormat.tmx => t.workbench.history_page.format_tmx_hint,
      };
}

/// What [ExportHistoryDialog] hands back.
class HistoryExportDraft {
  const HistoryExportDraft({
    required this.format,
    required this.withMeta,
    required this.onlyEdited,
  });

  final HistoryExportFormat format;

  /// Carry the service, the time and where the text came from.
  final bool withMeta;

  /// Only the records whose translation is the user's own wording.
  final bool onlyEdited;
}

/// 导出记录 — history's own export sheet. It shares the shape of 导出译文 but
/// not the choices: a document exports as a document, a list of pairs exports
/// as data, so the formats are the three things a list of pairs can become.
///
/// Where the file lands is the platform's save panel, which opens once the
/// sheet closes — the deck draws that as a 存至「下载」 note because a browser
/// has no panel to open.
///
/// Port of `apps/storybook/src/screens/export-history-dialog.tsx`.
class ExportHistoryDialog extends StatefulWidget {
  const ExportHistoryDialog({
    super.key,
    required this.count,
    required this.scope,
  });

  /// How many records go out — the selection, or the whole list.
  final int count;

  /// Whether [count] is a selection (已选) or everything (全部).
  final HistoryExportScope scope;

  @override
  State<ExportHistoryDialog> createState() => _ExportHistoryDialogState();
}

enum HistoryExportScope { selected, all }

class _ExportHistoryDialogState extends State<ExportHistoryDialog> {
  HistoryExportFormat _format = HistoryExportFormat.csv;
  bool _withMeta = true;
  bool _onlyEdited = false;

  @override
  Widget build(BuildContext context) {
    final strings = t.workbench.history_page;

    return Center(
      child: Dialog(
        width: 420,
        children: [
          DialogHeader(
            title: Text(strings.export_title),
            subtitle: Text(
              widget.scope == HistoryExportScope.selected
                  ? strings.export_scope_selected(count: widget.count)
                  : strings.export_scope_all(count: widget.count),
            ),
          ),
          DialogBody(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(child: Text(strings.export_format)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final format in HistoryExportFormat.values) ...[
                        if (format != HistoryExportFormat.values.first)
                          const SizedBox(width: 10),
                        Expanded(
                          child: OptionCard(
                            title: Text(format.label),
                            description: Text(format.hint),
                            selected: format == _format,
                            onSelect: () => setState(() => _format = format),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(child: Text(strings.export_content)),
                  const SizedBox(height: 10),
                  Checkbox(
                    checked: _withMeta,
                    onChanged: (v) => setState(() => _withMeta = v),
                    child: Text(strings.export_with_meta),
                  ),
                  const SizedBox(height: 8),
                  Checkbox(
                    checked: _onlyEdited,
                    onChanged: (v) => setState(() => _onlyEdited = v),
                    child: Text(strings.export_only_edited),
                  ),
                ],
              ),
            ],
          ),
          DialogFooter(
            children: [
              const Spacer(),
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.md,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.common.ui.button.cancel),
              ),
              Button(
                variant: ButtonVariant.primary,
                size: ButtonSize.md,
                shortcut: const Text('⏎'),
                onPressed: () => Navigator.of(context).pop(
                  HistoryExportDraft(
                    format: _format,
                    withMeta: _withMeta,
                    onlyEdited: _onlyEdited,
                  ),
                ),
                child: Text(strings.export),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 管理历史 — the sheet behind the footer's retention note. Two things live
/// here and nowhere else: how long records are kept, and the one button that
/// throws them all away. Clearing hands off to the shared confirm sheet rather
/// than turning this one's footer into the question: a settings sheet should
/// keep looking like a settings sheet until it closes.
///
/// The deck offers 保留时长 as a choice. The runtime has no retention setting
/// to write it to, so this prints the policy it actually applies; the radio
/// group lands when `ShortcutSettings`' neighbour does.
///
/// Port of `apps/storybook/src/screens/manage-history-dialog.tsx`.
class ManageHistoryDialog extends StatelessWidget {
  const ManageHistoryDialog({super.key, required this.count});

  /// How many records there are right now — printed on the 清空 button's row.
  final int count;

  @override
  Widget build(BuildContext context) {
    final strings = t.workbench.history_page;
    final tokens = context.tokens;
    final colors = tokens.colors;
    final note = tokens.typography.sansStyle(
      fontSize: 11,
      height: 1.7,
      color: colors.fgSubtle,
    );

    return Center(
      child: Dialog(
        width: 400,
        children: [
          DialogHeader(
            title: Text(strings.manage_title),
            subtitle: Text(strings.manage_subtitle(count: count)),
          ),
          DialogBody(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(child: Text(strings.retention_section)),
                  const SizedBox(height: 10),
                  Text(strings.retention, style: note),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    tone: LabelTone.danger,
                    child: Text(strings.clear_section),
                  ),
                  const SizedBox(height: 10),
                  Text(strings.clear_description, style: note),
                  const SizedBox(height: 10),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Button(
                      variant: ButtonVariant.warning,
                      enabled: count > 0,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(strings.clear_button),
                    ),
                  ),
                ],
              ),
            ],
          ),
          DialogFooter(
            children: [
              const Spacer(),
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.md,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.workbench.glossary_page.done),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
