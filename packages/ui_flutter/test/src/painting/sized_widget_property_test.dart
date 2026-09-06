import 'package:beyondtranslate_ui/src/foundation/widget_size.dart';
import 'package:beyondtranslate_ui/src/painting/widget_property.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SizedWidgetProperty', () {
    test('should return the correct value for the given WidgetSize', () async {
      const property = SizedWidgetProperty(
        small: 10,
        medium: 20,
        large: 30,
      );
      final smallValue = property.sized(WidgetSize.small);
      expect(smallValue, 10);
      final mediumValue = property.sized(WidgetSize.medium);
      expect(mediumValue, 20);
      final largeValue = property.sized(WidgetSize.large);
      expect(largeValue, 30);
    });
  });
}
