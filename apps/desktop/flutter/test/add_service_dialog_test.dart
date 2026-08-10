import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/add_service_dialog.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/provider_meta.dart';
import 'package:beyondtranslate_desktop/src/services/runtime.dart';
import 'package:beyondtranslate_desktop/src/widgets/ui.dart'
    show DesignThemeProvider;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A traditional provider keeps the sheet off the runtime: only an LLM one
/// fetches a model roster, and there is no Rust engine in a widget test.
final _deepl = ProviderConfigEntry(
  id: 'deepl',
  type: ProviderType.deepL,
  fields: const {'authKey': 'k'},
);

ServiceConfigEntry _derivedTranslation(String providerId) {
  return ServiceConfigEntry(
    id: '$providerId+translation',
    providerId: providerId,
    type: ServiceType.translation,
    name: providerId,
    fields: const {},
  );
}

void main() {
  Widget specimen({List<ServiceConfigEntry> existing = const []}) {
    return DesignThemeProvider(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 840,
            height: 620,
            child: AddServiceDialog(providers: [_deepl], existing: existing),
          ),
        ),
      ),
    );
  }

  final deeplName = providerTypeDisplayName(ProviderType.deepL);
  final translationLabel = serviceTypeLabel(ServiceType.translation);

  testWidgets('derives the display name from the provider and the kind', (
    tester,
  ) async {
    await tester.pumpWidget(specimen());

    expect(tester.takeException(), isNull);
    expect(find.text(t.settings.services.editor.title), findsOneWidget);
    expect(find.text(t.settings.services.editor.subtitle), findsOneWidget);
    expect(find.text('$deeplName · $translationLabel'), findsOneWidget);
  });

  testWidgets('shows the derived id in the footer', (tester) async {
    await tester.pumpWidget(specimen());

    expect(find.text('deepl+translation'), findsOneWidget);
  });

  testWidgets('a traditional provider offers no model or prompt', (
    tester,
  ) async {
    await tester.pumpWidget(specimen());

    // The engine reads neither on a traditional endpoint, so the sheet says so
    // instead of collecting them.
    expect(find.text(t.settings.services.editor.row.model), findsNothing);
    expect(
      find.text(t.settings.services.editor.row.system_prompt),
      findsNothing,
    );
    expect(
      find.textContaining(deeplName, findRichText: true),
      findsWidgets,
      reason: 'the traditional-endpoint note names the provider',
    );
  });

  testWidgets('a kind the provider already serves gets a suffixed id', (
    tester,
  ) async {
    // `list_services` synthesises `deepl+translation` from the provider, so the
    // first service the user adds by hand is already the second of its kind.
    await tester.pumpWidget(specimen(existing: [_derivedTranslation('deepl')]));

    expect(find.text('deepl+translation'), findsNothing);
    expect(find.text('deepl+translation-2'), findsOneWidget);
    expect(
      find.text(
        formatTranslation(
          t.settings.services.editor.variant_hint,
          args: [deeplName, translationLabel],
        ),
      ),
      findsOneWidget,
      reason: 'a parallel configuration is stated, not warned about',
    );
  });

  testWidgets('the suffix keeps counting past the second', (tester) async {
    await tester.pumpWidget(
      specimen(
        existing: [
          _derivedTranslation('deepl'),
          ServiceConfigEntry(
            id: 'deepl+translation-2',
            providerId: 'deepl',
            type: ServiceType.translation,
            name: 'second',
            fields: const {},
          ),
        ],
      ),
    );

    expect(find.text('deepl+translation-3'), findsOneWidget);
  });

  test('a provider only offers the kinds its engine implements', () {
    // A dictionary service on an LLM provider resolves, then fails at look-up
    // with `does not support dictionary` — so it must never be offered.
    for (final type in kKnownProviderTypes.where(isLlmProviderType)) {
      expect(
        kProviderCapabilities[type],
        equals(const [ServiceType.translation]),
        reason: '${providerTypeValue(type)} implements llm() only',
      );
    }
  });
}
