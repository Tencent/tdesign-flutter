import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'slider_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(sliderDemoPageTestSpec);

  testWidgets('Slider Demo keeps official scenarios in order', (tester) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    const keys = [
      'single',
      'range',
      'labeled',
      'labeled-range',
      'non-zero',
      'scale',
      'scale-range',
      'disabled',
      'disabled-labeled-range',
      'disabled-scale-range',
      'capsule',
      'capsule-range',
      'capsule-labeled-range',
      'capsule-scale',
      'capsule-scale-range',
      'vertical',
      'vertical-scale-range',
      'vertical-capsule',
      'vertical-capsule-scale-range',
    ];
    final tops = keys
        .map((id) => tester.getTopLeft(find.byKey(ValueKey('slider-$id'))).dy)
        .toList();
    expect(tops, orderedEquals([...tops]..sort()));
    expect(find.byType(TSlider), findsNWidgets(9));
    expect(find.byType(TRangeSlider), findsNWidgets(10));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('each official scenario keeps its key parameters', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    final single = tester.widget<TSlider>(
      find.byKey(const ValueKey('slider-single')),
    );
    expect(single.value, 23);
    expect(single.onChanged, isNotNull);

    final range = tester.widget<TRangeSlider>(
      find.byKey(const ValueKey('slider-range')),
    );
    expect(range.value, const RangeValues(35, 65));
    expect(range.onChanged, isNotNull);

    final labeled = tester.widget<TSlider>(
      find.byKey(const ValueKey('slider-labeled')),
    );
    expect(labeled.value, 35);
    expect(labeled.showThumbValue, isTrue);
    expect(labeled.thumbFormatter, isNotNull);

    final labeledRange = tester.widget<TRangeSlider>(
      find.byKey(const ValueKey('slider-labeled-range')),
    );
    expect(labeledRange.value, const RangeValues(40, 60));
    expect(labeledRange.showThumbValue, isTrue);
    expect(labeledRange.thumbFormatter, isNotNull);

    final nonZero = tester.widget<TSlider>(
      find.byKey(const ValueKey('slider-non-zero')),
    );
    expect(nonZero.value, 30);
    expect(nonZero.min, 20);
    expect(nonZero.max, 100);
    expect(nonZero.divisions, 4);
    expect(nonZero.showScaleValue, isTrue);

    for (final key in ['slider-scale', 'slider-capsule-scale']) {
      final slider = tester.widget<TSlider>(find.byKey(ValueKey(key)));
      expect(slider.divisions, 5, reason: key);
      expect(slider.showScaleValue, isTrue, reason: key);
    }
    for (final key in [
      'slider-scale-range',
      'slider-disabled-scale-range',
      'slider-capsule-scale-range',
    ]) {
      final slider = tester.widget<TRangeSlider>(find.byKey(ValueKey(key)));
      expect(slider.divisions, 5, reason: key);
      expect(slider.showScaleValue, isTrue, reason: key);
    }

    for (final key in [
      'slider-disabled',
      'slider-disabled-labeled-range',
      'slider-disabled-scale-range',
    ]) {
      final widget = tester.widget(find.byKey(ValueKey(key)));
      final onChanged = switch (widget) {
        TSlider() => widget.onChanged,
        TRangeSlider() => widget.onChanged,
        _ => throw StateError('Unexpected slider type for $key'),
      };
      expect(onChanged, isNull, reason: key);
    }
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('controlled slider updates after a real drag', (tester) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    final slider = find.descendant(
      of: find.byKey(const ValueKey('slider-single')),
      matching: find.byType(Slider),
    );
    await tester.drag(slider, const Offset(80, 0));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TSlider>(find.byKey(const ValueKey('slider-single'))).value,
      greaterThan(23),
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('vertical labels stay upright and capsule styles are explicit', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    for (final key in [
      'slider-vertical',
      'slider-vertical-scale-range',
      'slider-vertical-capsule',
      'slider-vertical-capsule-scale-range',
    ]) {
      final rotated = tester.widget<RotatedBox>(
        find.ancestor(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(RotatedBox),
        ),
      );
      expect(rotated.quarterTurns, 1, reason: key);
    }
    final scaleLabels = tester
        .widgetList<TText>(
          find.descendant(
            of: find.byKey(const ValueKey('slider-vertical-scale-labels')),
            matching: find.byType(TText),
          ),
        )
        .map((text) => text.data)
        .toList();
    expect(scaleLabels, orderedEquals(['0', '20', '40', '60', '80', '100']));
    for (final key in [
      'slider-vertical-label',
      'slider-vertical-scale-labels',
      'slider-vertical-capsule-label',
      'slider-vertical-capsule-scale-labels',
    ]) {
      expect(
        find.ancestor(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(RotatedBox),
        ),
        findsNothing,
        reason: key,
      );
    }
    for (final key in [
      'slider-capsule',
      'slider-capsule-range',
      'slider-capsule-labeled-range',
      'slider-capsule-scale',
      'slider-capsule-scale-range',
      'slider-vertical-capsule',
      'slider-vertical-capsule-scale-range',
    ]) {
      expect(
        find.ancestor(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(SliderTheme),
        ),
        findsWidgets,
        reason: key,
      );
    }
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
