import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/add_provider_dialog.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/provider_meta.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show DesignThemeProvider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The type step of 添加提供商 is pure UI — it reads no settings and calls no
/// runtime, so it can be pumped on its own. Everything past 继续 needs the
/// Rust runtime and is exercised in the app.
void main() {
  Widget specimen() {
    return DesignThemeProvider(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 840,
            height: 620,
            child: const AddProviderDialog(),
          ),
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
    expect(find.text(t.settings.providers.editor.type_picker.prompt),
        findsOneWidget);
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
}
