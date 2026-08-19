import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:beyondtranslate_desktop/src/routes/workbench/glossary_dialogs.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show DesignThemeProvider, OptionCard;
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// These sheets live inside a scrolling [DialogBody], which hands its children
/// an unbounded height — the one constraint a `CrossAxisAlignment.stretch` row
/// cannot survive. Laying them out is the only way to catch that; the analyzer
/// sees nothing wrong with it.
void main() {
  setUpAll(() {
    LocaleSettings.setLocaleRaw('zh-Hans');
  });

  Widget specimen(Widget child) => DesignThemeProvider(
        child: TranslationProvider(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(900, 700)),
              child: Overlay(
                initialEntries: [OverlayEntry(builder: (_) => child)],
              ),
            ),
          ),
        ),
      );

  testWidgets('the 新建术语库 sheet lays out inside a scrolling body', (
    tester,
  ) async {
    await tester.pumpWidget(
      specimen(const NewGlossaryDialog(
        takenNames: ['机器学习'],
        languages: ['en', 'zh-Hans', 'ja'],
      )),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // All three 初始内容 cards, squared up to the tallest.
    final cards = tester.widgetList<OptionCard>(find.byType(OptionCard));
    expect(cards.length, 3);
    final heights = find.byType(OptionCard).evaluate().map(
          (element) => (element.renderObject! as RenderBox).size.height,
        );
    expect(heights.toSet().length, 1, reason: 'cards should be equal height');
  });

  testWidgets('the 新增条目 sheet lays out and counts a run of saves', (
    tester,
  ) async {
    final saved = <GlossaryEntryDraft>[];
    await tester.pumpWidget(
      specimen(
        AddTermDialog(
          books: [
            GlossaryBook(
              id: 'b1',
              name: '机器学习',
              enabled: true,
              entryCount: 0,
              createdAt: 0,
              updatedAt: 0,
            ),
          ],
          existingTerms: const {
            'b1': ['teacher forcing'],
          },
          onSubmit: (draft) async => saved.add(draft),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // A single book is not a choice, so the sheet does not ask.
    expect(find.text(t.workbench.glossary_page.book), findsNothing);

    // A term already in the book turns 保存 into 覆盖.
    await tester.enterText(find.byType(EditableText).first, 'teacher forcing');
    await tester.pumpAndSettle();
    expect(find.text(t.workbench.glossary_page.overwrite), findsOneWidget);
  });
}
