import 'package:beyondtranslate_ui/beyondtranslate_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../host.dart';

void main() {
  testWidgets('active step tint reaches its spinner and trailing detail', (
    tester,
  ) async {
    final theme = ThemeData.studioLight();
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 320,
          child: Step(
            status: StepStatus.active,
            label: 'Uploading',
            meta: '4 files',
            tint: StepTint.danger,
          ),
        ),
        theme: theme,
      ),
    );
    expect(
      tester.widget<Spinner>(find.byType(Spinner)).tint,
      SpinnerTint.danger,
    );
    expect(
      tester.widget<Text>(find.text('4 files')).style!.color,
      theme.vars.colorDanger[theme.vars.controlColorPlainContent.normalShade!],
    );

    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 320,
          child: Step(
            status: StepStatus.done,
            label: 'Uploaded',
            meta: '4 files',
            tint: StepTint.danger,
          ),
        ),
        theme: theme,
      ),
    );
    expect(find.byType(Spinner), findsNothing);
    expect(
      tester.widget<Text>(find.text('4 files')).style!.color,
      theme.vars.colorContentFaint,
    );
    expect(tester.takeException(), isNull);
  });
}
