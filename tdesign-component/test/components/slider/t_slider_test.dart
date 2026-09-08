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
      home: Scaffold(
        body: Center(child: SizedBox(width: 320, child: child)),
      ),
    );
  }

  group('TSlider v1 behavior', () {
    testWidgets('forwards controlled value, bounds, divisions and callbacks', (
      tester,
    ) async {
      double? changed;
      double? started;
      double? ended;
      await tester.pumpWidget(
        wrap(
          TSlider(
            value: 40,
            min: 0,
            max: 100,
            divisions: 10,
            onChanged: (value) => changed = value,
            onChangeStart: (value) => started = value,
            onChangeEnd: (value) => ended = value,
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 40);
      expect(slider.min, 0);
      expect(slider.max, 100);
      expect(slider.divisions, 10);
      expect(
        SliderTheme.of(tester.element(find.byType(Slider))).trackHeight,
        6,
      );

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

    testWidgets('uses TDesign token colors when SliderTheme is unspecified', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TSlider(value: 0.5)));

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.activeTrackColor, TThemeData.defaultData().brandNormalColor);
      expect(theme.thumbColor, TThemeData.defaultData().textColorAnti);
      expect(
        theme.disabledActiveTrackColor,
        TThemeData.defaultData().brandDisabledColor,
      );
      expect(
        theme.disabledInactiveTrackColor,
        TThemeData.defaultData().bgColorComponentDisabled,
      );
    });

    testWidgets('preserves local SliderTheme color overrides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [TThemeData.defaultData()],
            sliderTheme: const SliderThemeData(activeTrackColor: Colors.red),
          ),
          home: const Scaffold(
            body: Center(
              child: SizedBox(width: 320, child: TSlider(value: 0.5)),
            ),
          ),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.activeTrackColor, Colors.red);
      expect(theme.thumbColor, TThemeData.defaultData().textColorAnti);
    });

    testWidgets('explicit ColorScheme takes priority over TDesign tokens', (
      tester,
    ) async {
      const scheme = ColorScheme.light(
        primary: Colors.purple,
        onSurface: Colors.orange,
        surfaceContainerHighest: Colors.green,
        outline: Colors.brown,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: scheme,
            extensions: [TThemeData.defaultData()],
          ),
          home: const Scaffold(body: TSlider(value: 0.5)),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.activeTrackColor, scheme.primary);
      expect(theme.inactiveTrackColor, scheme.surfaceContainerHighest);
      expect(theme.thumbColor, scheme.primary);
    });

    testWidgets('Theme decoration wraps the slider', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSlider(value: 0.5),
          sliderTheme: const TSliderThemeData(
            decoration: BoxDecoration(color: Colors.red),
          ),
        ),
      );
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    testWidgets('showThumbValue keeps formatted label visible at rest', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TSlider(
            value: 40,
            min: 0,
            max: 100,
            showThumbValue: true,
            thumbFormatter: (value) => '${value.toInt()}%',
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.label, '40%');
      expect(
        SliderTheme.of(tester.element(find.byType(Slider))).showValueIndicator,
        ShowValueIndicator.never,
      );
    });

    testWidgets('discrete slider keeps the Material value indicator hidden', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TSlider(value: 0.4, divisions: 5, showThumbValue: true)),
      );

      expect(
        SliderTheme.of(tester.element(find.byType(Slider))).showValueIndicator,
        ShowValueIndicator.never,
      );
    });

    testWidgets('showScaleValue renders formatted scale labels', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TSlider(
            value: 40,
            min: 0,
            max: 100,
            divisions: 4,
            showScaleValue: true,
            scaleFormatter: (value) => '${value.toInt()}%',
          ),
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('showThumbValue defaults to two decimal places', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TSlider(value: 0.4, showThumbValue: true)),
      );

      expect(tester.widget<Slider>(find.byType(Slider)).label, '0.40');
    });

    test('rejects invalid values and ranges', () {
      expect(() => TSlider(value: 2), throwsAssertionError);
      expect(() => TSlider(value: 0, min: 1, max: 1), throwsAssertionError);
      expect(() => TSlider(value: 0.5, divisions: 0), throwsAssertionError);
      expect(
        () => TSlider(value: 0.5, showScaleValue: true),
        throwsAssertionError,
      );
    });
  });

  group('TRangeSlider v1 behavior', () {
    testWidgets('forwards controlled range and lifecycle callbacks', (
      tester,
    ) async {
      RangeValues? changed;
      RangeValues? started;
      RangeValues? ended;
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            divisions: 10,
            onChanged: (value) => changed = value,
            onChangeStart: (value) => started = value,
            onChangeEnd: (value) => ended = value,
          ),
        ),
      );

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

    testWidgets('onChanged null disables and decoration wraps range slider', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TRangeSlider(value: RangeValues(0.2, 0.8)),
          sliderTheme: const TSliderThemeData(
            decoration: BoxDecoration(color: Colors.blue),
          ),
        ),
      );
      expect(
        tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged,
        isNull,
      );
      expect(find.byType(DecoratedBox), findsOneWidget);
    });

    testWidgets('showThumbValue keeps formatted range labels visible at rest', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            showThumbValue: true,
            thumbFormatter: (value) => '${value.toInt()}%',
          ),
        ),
      );

      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.labels, const RangeLabels('20%', '60%'));
      expect(
        SliderTheme.of(
          tester.element(find.byType(RangeSlider)),
        ).showValueIndicator,
        ShowValueIndicator.never,
      );
    });

    testWidgets('discrete range keeps the Material value indicator hidden', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TRangeSlider(
            value: RangeValues(0.2, 0.6),
            divisions: 5,
            showThumbValue: true,
          ),
        ),
      );

      expect(
        SliderTheme.of(
          tester.element(find.byType(RangeSlider)),
        ).showValueIndicator,
        ShowValueIndicator.never,
      );
    });

    testWidgets('showScaleValue renders formatted range scale labels', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            divisions: 4,
            showScaleValue: true,
            scaleFormatter: (value) => '${value.toInt()}%',
          ),
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('range showThumbValue defaults to two decimal places', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TRangeSlider(
            value: RangeValues(0.2, 0.6),
            showThumbValue: true,
          ),
        ),
      );

      expect(
        tester.widget<RangeSlider>(find.byType(RangeSlider)).labels,
        const RangeLabels('0.20', '0.60'),
      );
    });

    test('rejects invalid bounds and divisions', () {
      expect(
        () => TRangeSlider(value: const RangeValues(0.2, 0.8), min: 1, max: 1),
        throwsAssertionError,
      );
      expect(
        () => TRangeSlider(value: const RangeValues(0.2, 0.8), divisions: 0),
        throwsAssertionError,
      );
    });

    testWidgets('rejects a controlled range outside min and max', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TRangeSlider(value: RangeValues(-0.1, 0.8))),
      );
      expect(tester.takeException(), isAssertionError);
    });
  });

  test('TSliderThemeData copyWith and lerp', () {
    const base = TSliderThemeData(decoration: BoxDecoration(color: Colors.red));
    const other = TSliderThemeData(
      decoration: BoxDecoration(color: Colors.blue),
    );
    expect(base.copyWith().decoration, base.decoration);
    expect(
      base
          .copyWith(decoration: const BoxDecoration(color: Colors.green))
          .decoration,
      const BoxDecoration(color: Colors.green),
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).decoration, isA<BoxDecoration>());
  });
}
