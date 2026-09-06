import 'package:beyondtranslate_ui/src/foundation/widget_tint.dart';
import 'package:beyondtranslate_ui/src/generated/colors.dart';
import 'package:beyondtranslate_ui/src/painting/widget_property.dart';
import 'package:flutter_test/flutter_test.dart';

enum MockWidgetTint with WidgetTint {
  primary,
  neutral,
  info,
  success,
  warning,
  danger,
}

void main() {
  group('TintedWidgetProperty', () {
    test('should return the correct color for the given WidgetTint', () async {
      const property = TintedWidgetProperty(
        primary: Colors.brand,
        neutral: Colors.neutral,
        info: Colors.sky,
        success: Colors.green,
        warning: Colors.amber,
        danger: Colors.red,
      );
      final primaryColor = property.tinted(MockWidgetTint.primary);
      expect(primaryColor, Colors.brand);
      final secondaryColor = property.tinted(MockWidgetTint.neutral);
      expect(secondaryColor, Colors.neutral);
      final infoColor = property.tinted(MockWidgetTint.info);
      expect(infoColor, Colors.sky);
      final successColor = property.tinted(MockWidgetTint.success);
      expect(successColor, Colors.green);
      final warningColor = property.tinted(MockWidgetTint.warning);
      expect(warningColor, Colors.amber);
      final dangerColor = property.tinted(MockWidgetTint.danger);
      expect(dangerColor, Colors.red);
    });
  });
}
