import 'dart:io';

import 'package:beyondtranslate_desktop/src/i18n/i18n.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/provider_catalog.dart';
import 'package:beyondtranslate_desktop/src/routes/settings/providers.dart';
import 'package:beyondtranslate_desktop/src/services/runtime.dart';
import 'package:beyondtranslate_desktop/src/services/settings_store.dart';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    show Runtime;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// The 提供商 catalogue and detail page against a real runtime in a scratch
/// data directory. Endpoints point at port 1, which refuses at once, so every
/// fetch fails without touching the network.
void main() {
  late Directory dataDir;

  setUpAll(() async {
    LocaleSettings.setLocale(AppLocale.zhHans);
    dataDir = Directory.systemTemp.createTempSync('beyondtranslate-providers-');
    runtime = Runtime(dataDir: dataDir.path);
    await settingsStore.init();
  });

  tearDownAll(() => dataDir.deleteSync(recursive: true));

  /// Lets the runtime's futures land, then draws what they changed.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(720, 1600);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      appHarness(const ProvidersSettingsPage(), size: const Size(720, 1600)),
    );
    await settle(tester);
  }

  testWidgets('lists every LLM provider, unconfigured ones included', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('提供商 · 12 家'), findsOneWidget);
    expect(find.text('Ollama'), findsOneWidget);
    expect(find.text('本机推理 · 无需 API Key'), findsOneWidget);
    expect(find.text('未配置'), findsNWidgets(12));
  });

  testWidgets('search filters by name and offers a way out of no match', (
    tester,
  ) async {
    await pumpPage(tester);

    providersSearchRequest.value++;
    await tester.pumpAndSettle();
    expect(find.text('搜索提供商名字或 id'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'olla');
    await tester.pumpAndSettle();
    expect(find.text('提供商 · 1 家'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('没有匹配的提供商'), findsOneWidget);

    await tester.tap(find.text('清除搜索'));
    await tester.pumpAndSettle();
    expect(find.text('提供商 · 12 家'), findsOneWidget);
  });

  testWidgets('an unconfigured provider is configured, verified and cleared', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('Ollama'));
    await settle(tester);
    expect(find.text('ollama'), findsOneWidget);
    expect(find.text('填入密钥并保存后，「刷新列表」会拉取这家可用的模型。'), findsOneWidget);

    // An edit makes the roster test the draft, and leaving asks first.
    await tester.enterText(
        find.byType(EditableText).first, 'http://127.0.0.1:1');
    await tester.pumpAndSettle();
    expect(providerDetailDirty.value, isTrue);
    await tester.tap(find.text('用新配置测试'));
    await settle(tester);
    expect(find.text('拉取失败'), findsOneWidget);

    await tester.tap(find.text('提供商').first);
    await tester.pumpAndSettle();
    expect(find.text('放弃未保存的改动？'), findsOneWidget);
    await tester.tap(find.text('继续编辑'));
    await tester.pumpAndSettle();
    expect(find.text('ollama'), findsOneWidget);

    // The endpoint lists nothing, so the model is named by hand.
    await tester.enterText(find.byType(EditableText).last, 'qwen3:8b');
    await tester.pumpAndSettle();
    await tester.tap(find.text('设为默认'));
    await tester.pumpAndSettle();
    expect(find.text('qwen3:8b'), findsOneWidget);

    await tester.tap(find.text('保存'));
    await settle(tester);
    final saved = settingsStore.providers
        .where((provider) => provider.type == ProviderType.ollama)
        .single;
    expect(saved.fields['defaultModel'], 'qwen3:8b');
    expect(saved.fields['baseUrl'], 'http://127.0.0.1:1');
    // Saved, then refused: the receipt says both.
    expect(find.text('已保存，但端点没有接受它'), findsOneWidget);
    expect(providerHealth.value[saved.id], ProviderHealth.invalid);

    await tester.tap(find.text('提供商').first);
    await settle(tester);
    expect(find.text('需重新验证'), findsOneWidget);
    expect(find.text('未配置'), findsNWidgets(11));

    await tester.tap(find.text('Ollama'));
    await settle(tester);
    await tester.tap(find.text('清除密钥'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('清除'));
    await settle(tester);
    expect(
      settingsStore.providers.where((p) => p.type == ProviderType.ollama),
      isEmpty,
    );
    expect(find.text('未配置'), findsNWidgets(12));
  });
}
