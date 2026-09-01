import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'slider_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(sliderDemoPageTestSpec);

  testWidgets('Slider Demo keeps official scenarios in order', (tester) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    final keys = [
      'single',
      'range',
      'labeled',
      'non-zero',
      'scale',
      'disabled',
      'capsule',
      'vertical',
    ];
    final tops = keys
        .map((id) => tester.getTopLeft(find.byKey(ValueKey('slider-$id'))).dy)
        .toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('controlled values and disabled callback stay explicit', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    expect(
      tester
          .widget<TSlider>(find.byKey(const ValueKey('slider-single')))
          .onChanged,
      isNotNull,
    );
    expect(
      tester
          .widget<TSlider>(find.byKey(const ValueKey('slider-disabled')))
          .onChanged,
      isNull,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('vertical and capsule styles stay composition-owned', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    expect(
      find.ancestor(
        of: find.byKey(const ValueKey('slider-vertical')),
        matching: find.byType(RotatedBox),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.byKey(const ValueKey('slider-capsule')),
        matching: find.byType(SliderTheme),
      ),
      findsWidgets,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
