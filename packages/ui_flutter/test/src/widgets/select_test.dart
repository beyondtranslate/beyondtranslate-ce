import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../host.dart';

/// `Select` — the field-shaped trigger and the list it drops.
///
/// The geometry the React stylesheet decides is held by the parity suite; what
/// is here is what only this port can get wrong: the trigger reading the
/// field's own box, the list being at least as wide as the trigger, and the
/// options being rows rather than a second drawing.
void main() {
  const List<SelectOption<String>> languages = [
    SelectOption(value: 'zh', label: 'Chinese (Simplified)'),
    SelectOption(value: 'ja', label: 'Japanese'),
    SelectOption(value: 'de', label: 'German'),
  ];

  testWidgets('the trigger shows the chosen label, or the placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 240,
            child: Select<String>(
              options: languages,
              value: 'ja',
              placeholder: 'Choose a language…',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    // One `Japanese` is the value; the other is the hidden label the box
    // measures itself against, and there is one of those per option.
    expect(find.text('Japanese'), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(Visibility),
        matching: find.byType(Text),
      ),
      findsNWidgets(languages.length),
    );

    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 240,
            child: Select<String>(
              options: languages,
              placeholder: 'Choose a language…',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    // No choice, so the value line is the placeholder; the labels are all
    // hidden and only there to hold the width.
    expect(find.text('Choose a language…'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(Visibility),
        matching: find.byType(Text),
      ),
      findsNWidgets(languages.length),
    );
  });

  testWidgets('the trigger is the field box, at the size profile height', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 240,
            child: Select<String>(
              options: languages,
              value: 'zh',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    final ThemeVariables vars = ThemeData.studioLight().vars;
    expect(
      tester.getSize(find.byType(Select<String>)).height,
      vars.controlMediumSize,
    );
  });

  testWidgets('the list is at least as wide as the trigger it dropped from', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 320,
            child: Select<String>(
              options: languages,
              value: 'zh',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Select<String>));
    await tester.pump();

    // The stylesheet's `min-width: var(--anchor-width)`: a list narrower than
    // the trigger reads as a different control.
    expect(tester.getSize(find.byType(MenuPanel)).width, 320);
    // Once in the open list, once in the trigger's hidden measurements.
    expect(find.text('German'), findsNWidgets(2));
  });

  testWidgets('choosing a row reports the value and closes the list', (
    tester,
  ) async {
    String? chosen = 'zh';

    await tester.pumpWidget(
      host(
        Center(
          child: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: 240,
              child: Select<String>(
                options: languages,
                value: chosen,
                onChanged: (value) => setState(() => chosen = value),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Select<String>));
    await tester.pump();
    await tester.tap(
      find.descendant(
        of: find.byType(MenuPanel),
        matching: find.text('German'),
      ),
    );
    await tester.pump();

    expect(chosen, 'de');
    expect(find.byType(MenuPanel), findsNothing);
    // The trigger now reads German, beside the hidden label of the same name.
    expect(find.text('German'), findsNWidgets(2));
  });

  testWidgets('a select with no handler is a disabled one', (tester) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 240,
            child: Select<String>(options: languages, value: 'zh'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Select<String>));
    await tester.pump();

    // No list, because there is nothing to choose with: the two are the same
    // fact about the control rather than a separate `enabled` flag.
    expect(find.byType(MenuPanel), findsNothing);
  });

  testWidgets('a select in a shrink-wrapping row is measured from its labels', (
    tester,
  ) async {
    // A `Row` whose width is unbounded refuses a flex child outright, so this
    // is the case that decides whether the value may be laid over the hidden
    // labels at all. A select here is as wide as its longest option.
    await tester.pumpWidget(
      host(
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Select<String>(
                options: languages,
                value: 'zh',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(Select<String>)).width,
      greaterThan(0),
    );
  });

  testWidgets('groups drop as a heading over their rows', (tester) async {
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 240,
            child: Select<String>(
              groups: const [
                SelectGroup(
                  label: 'Recently used',
                  options: [SelectOption(value: 'zh', label: 'Chinese')],
                ),
                SelectGroup(
                  label: 'All languages',
                  options: [SelectOption(value: 'de', label: 'German')],
                ),
              ],
              value: 'zh',
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Select<String>));
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(MenuPanel),
        matching: find.text('Recently used'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(MenuPanel),
        matching: find.text('All languages'),
      ),
      findsOneWidget,
    );
  });
}
