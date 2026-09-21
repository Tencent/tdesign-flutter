import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'slider_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(sliderDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('slider dragged ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, sliderDemoPageTestSpec, mode);
      final slider = find.descendant(
        of: find.byKey(const ValueKey('slider-single')),
        matching: find.byType(Slider),
      );
      await tester.drag(slider, const Offset(80, 0));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TSlider>(find.byKey(const ValueKey('slider-single')))
            .value,
        greaterThan(23),
      );
      await expectLater(
        find.byKey(const ValueKey('slider-demo-page')),
        matchesGoldenFile('goldens/slider_dragged_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
