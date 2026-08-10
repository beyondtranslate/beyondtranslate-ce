import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/add_provider_dialog.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/provider_meta.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart' as ui
    show Dialog, DialogFooter, DialogHeader;
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show DesignThemeProvider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The type step of 添加提供商 is pure UI — it reads no settings and calls no
/// runtime, so it can be pumped on its own. Everything past 继续 needs the
/// Rust runtime and is exercised in the app.
void main() {
  Widget specimen() {
    return const DesignThemeProvider(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 840, height: 620, child: AddProviderDialog()),
        ),
      ),
    );
  }

  final llmTypes = kKnownProviderTypes.where(isLlmProviderType).toList();
  final traditionalTypes =
      kKnownProviderTypes.where((type) => !isLlmProviderType(type)).toList();

  testWidgets('opens on the type picker with the LLM types listed', (
    tester,
  ) async {
    await tester.pumpWidget(specimen());

    expect(tester.takeException(), isNull);
    expect(find.text(t.settings.providers.button.add), findsOneWidget);
    expect(
      find.text(t.settings.providers.editor.type_picker.prompt),
      findsOneWidget,
    );
    for (final type in llmTypes) {
      expect(
        find.text(providerTypeDisplayName(type)),
        findsOneWidget,
        reason: '${providerTypeValue(type)} should be offered up front',
      );
    }
    expect(find.text(t.settings.providers.editor.step.next), findsOneWidget);
    expect(find.text(t.common.ui.button.cancel), findsOneWidget);
  });

  testWidgets('traditional types stay collapsed until the disclosure opens', (
    tester,
  ) async {
    await tester.pumpWidget(specimen());

    final disclosure = find.textContaining(
      t.settings.providers.editor.type_picker.section_traditional,
    );
    expect(disclosure, findsOneWidget);
    // Nineteen types do not fit the sheet's body, so it scrolls inside itself
    // and the disclosure starts below the fold.
    await tester.scrollUntilVisible(disclosure, 100);
    // The count rides along with the label, the way the deck writes it.
    expect(
      find.text(
        '${t.settings.providers.editor.type_picker.section_traditional}'
        ' · ${traditionalTypes.length}',
      ),
      findsOneWidget,
    );

    final hidden = traditionalTypes.first;
    expect(find.text(providerTypeDisplayName(hidden)), findsNothing);

    await tester.tap(disclosure);
    await tester.pumpAndSettle();

    for (final type in traditionalTypes) {
      expect(
        find.text(providerTypeDisplayName(type)),
        findsOneWidget,
        reason: '${providerTypeValue(type)} should appear once opened',
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('a provider type row carries its capability tags', (
    tester,
  ) async {
    await tester.pumpWidget(specimen());

    // Every LLM type answers translation only, so the tag appears once per row.
    expect(
      find.text(t.settings.providers.capability.translation),
      findsNWidgets(llmTypes.length),
    );
    expect(tester.takeException(), isNull);
  });

  group('the sheet keeps its header and footer while the body scrolls', () {
    testWidgets('the body owns its padding, so it scrolls edge to edge', (
      tester,
    ) async {
      await tester.pumpWidget(specimen());

      final scroller = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(ui.Dialog),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      // Padding inside the scroll view rather than around it: the scrollable
      // region reaches both bands and the content slides under them.
      expect(
        scroller.padding,
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      );
    });

    testWidgets('the sheet never grows past the viewport', (tester) async {
      await tester.pumpWidget(specimen());

      final surface = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(
        tester.getSize(find.byType(ui.Dialog)).height,
        lessThanOrEqualTo(surface.height - 48),
      );
    });

    testWidgets('scrolling the body leaves the header and footer put', (
      tester,
    ) async {
      await tester.pumpWidget(specimen());

      final headerBefore = tester.getRect(find.byType(ui.DialogHeader));
      final footerBefore = tester.getRect(find.byType(ui.DialogFooter));

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byType(ui.DialogHeader)), headerBefore);
      expect(tester.getRect(find.byType(ui.DialogFooter)), footerBefore);
      expect(
        find.text(t.settings.providers.editor.step.next),
        findsOneWidget,
        reason: '继续 must stay reachable however far the list is scrolled',
      );
    });
  });

  group('the field tables match what the engine will accept', () {
    test('every required field is one the type actually takes', () {
      for (final type in kKnownProviderTypes) {
        final offered = kProviderFields[type] ?? const <String>[];
        for (final key in kRequiredProviderFields[type] ?? const <String>[]) {
          expect(
            offered,
            contains(key),
            reason: '${providerTypeValue(type)} requires "$key" but the form '
                'never renders a field for it',
          );
        }
      }
    });

    test('every LLM type requires a default model', () {
      // `configured_default_model` in the engine rejects a blank one outright,
      // so a form that lets it through fails with `config validation failed`
      // the moment the connection is tested.
      for (final type in kKnownProviderTypes.where(isLlmProviderType)) {
        expect(
          kRequiredProviderFields[type],
          contains('defaultModel'),
          reason: '${providerTypeValue(type)} would build without a model',
        );
      }
    });

    test('every known type has both tables filled in', () {
      for (final type in kKnownProviderTypes) {
        expect(kProviderFields, contains(type));
        expect(kRequiredProviderFields, contains(type));
        expect(kProviderCapabilities, contains(type));
      }
    });
  });
}
