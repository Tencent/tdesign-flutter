import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TSliderThemeData? sliderTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (sliderTheme != null) sliderTheme,
        ],
        sliderTheme: const SliderThemeData(trackHeight: 6),
      ),
      home: Scaffold(body: Center(child: SizedBox(width: 320, child: child))),
    );
  }

  group('TSlider v1 behavior', () {
    testWidgets('forwards controlled value, bounds, divisions and callbacks',
        (tester) async {
      double? changed;
      double? started;
      double? ended;
      await tester.pumpWidget(wrap(TSlider(
        value: 40,
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (value) => changed = value,
        onChangeStart: (value) => started = value,
        onChangeEnd: (value) => ended = value,
      )));

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 40);
      expect(slider.min, 0);
      expect(slider.max, 100);
      expect(slider.divisions, 10);
      expect(
          SliderTheme.of(tester.element(find.byType(Slider))).trackHeight, 6);

      await tester.drag(find.byType(Slider), const Offset(80, 0));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(started, isNotNull);
      expect(ended, isNotNull);
    });

    testWidgets('onChanged null disables Material Slider', (tester) async {
      await tester.pumpWidget(wrap(const TSlider(value: 0.5)));
      expect(tester.widget<Slider>(find.byType(Slider)).onChanged, isNull);
    });

    testWidgets('Theme decoration wraps the slider', (tester) async {
      await tester.pumpWidget(wrap(
        const TSlider(value: 0.5),
        sliderTheme: const TSliderThemeData(
          decoration: BoxDecoration(color: Colors.red),
        ),
      ));
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    test('rejects invalid values and ranges', () {
      expect(() => TSlider(value: 2), throwsAssertionError);
      expect(() => TSlider(value: 0, min: 1, max: 1), throwsAssertionError);
      expect(() => TSlider(value: 0.5, divisions: 0), throwsAssertionError);
    });
  });

  group('TRangeSlider v1 behavior', () {
    testWidgets('forwards controlled range and lifecycle callbacks',
        (tester) async {
      RangeValues? changed;
      RangeValues? started;
      RangeValues? ended;
      await tester.pumpWidget(wrap(TRangeSlider(
        value: const RangeValues(20, 60),
        min: 0,
        max: 100,
        divisions: 10,
        onChanged: (value) => changed = value,
        onChangeStart: (value) => started = value,
        onChangeEnd: (value) => ended = value,
      )));

      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.values, const RangeValues(20, 60));
      expect(slider.min, 0);
      expect(slider.max, 100);
      expect(slider.divisions, 10);

      const next = RangeValues(30, 70);
      slider.onChangeStart!(slider.values);
      slider.onChanged!(next);
      slider.onChangeEnd!(next);
      expect(changed, isNotNull);
      expect(started, isNotNull);
      expect(ended, isNotNull);
    });

    testWidgets('onChanged null disables and decoration wraps range slider',
        (tester) async {
      await tester.pumpWidget(wrap(
        const TRangeSlider(value: RangeValues(0.2, 0.8)),
        sliderTheme: const TSliderThemeData(
          decoration: BoxDecoration(color: Colors.blue),
        ),
      ));
      expect(
        tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged,
        isNull,
      );
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    test('rejects invalid bounds and divisions', () {
      expect(
        () => TRangeSlider(
          value: const RangeValues(0.2, 0.8),
          min: 1,
          max: 1,
        ),
        throwsAssertionError,
      );
      expect(
        () => TRangeSlider(
          value: const RangeValues(0.2, 0.8),
          divisions: 0,
        ),
        throwsAssertionError,
      );
    });
  });

  test('TSliderThemeData copyWith and lerp', () {
    const base = TSliderThemeData(
      decoration: BoxDecoration(color: Colors.red),
    );
    const other = TSliderThemeData(
      decoration: BoxDecoration(color: Colors.blue),
    );
    expect(base.copyWith().decoration, base.decoration);
    expect(
      base
          .copyWith(
            decoration: const BoxDecoration(color: Colors.green),
          )
          .decoration,
      const BoxDecoration(color: Colors.green),
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).decoration, isA<BoxDecoration>());
  });
}
