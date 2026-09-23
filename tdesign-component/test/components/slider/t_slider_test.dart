import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  void expectThumbBorders(
    SliderThemeData theme, {
    required Color borderColor,
    required Color disabledBorderColor,
  }) {
    final dynamic thumbShape = theme.thumbShape;
    final dynamic rangeThumbShape = theme.rangeThumbShape;
    expect(thumbShape.borderColor, borderColor);
    expect(thumbShape.disabledBorderColor, disabledBorderColor);
    expect(rangeThumbShape.borderColor, borderColor);
    expect(rangeThumbShape.disabledBorderColor, disabledBorderColor);
  }

  Widget wrap(
    Widget child, {
    TSliderThemeData? sliderTheme,
    SliderThemeData? materialSliderTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (sliderTheme != null) sliderTheme,
        ],
        sliderTheme:
            materialSliderTheme ?? const SliderThemeData(trackHeight: 6),
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
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [TThemeData.defaultData()]),
          home: const Scaffold(
            body: Center(
              child: SizedBox(width: 320, child: TSlider(value: 0.5)),
            ),
          ),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.trackHeight, 4);
      expect(
        theme.trackShape.runtimeType.toString(),
        '_TDesignSliderTrackShape',
      );
      expect(theme.activeTrackColor, TThemeData.defaultData().brandNormalColor);
      expect(
        theme.inactiveTrackColor,
        TThemeData.defaultData().bgColorComponentHover,
      );
      expect(theme.thumbColor, TThemeData.defaultData().textColorAnti);
      expect(
        theme.disabledActiveTrackColor,
        TThemeData.defaultData().brandDisabledColor,
      );
      expect(
        theme.disabledInactiveTrackColor,
        TThemeData.defaultData().bgColorComponentDisabled,
      );
      expectThumbBorders(
        theme,
        borderColor: TThemeData.defaultData().grayColor1,
        disabledBorderColor: TThemeData.defaultData().bgColorComponentDisabled,
      );
    });

    testWidgets('default track uses the design 16px horizontal inset', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [TThemeData.defaultData()]),
          home: const Scaffold(
            body: Center(
              child: SizedBox(width: 320, child: TSlider(value: 0.5)),
            ),
          ),
        ),
      );

      final sliderFinder = find.byType(Slider);
      final theme = SliderTheme.of(tester.element(sliderFinder));
      final renderBox = tester.renderObject<RenderBox>(sliderFinder);
      final dynamic trackShape = theme.trackShape;
      final Rect trackRect = trackShape.getPreferredRect(
        parentBox: renderBox,
        sliderTheme: theme,
        isEnabled: true,
        isDiscrete: false,
      );
      expect(trackRect.left, 16);
      expect(trackRect.right, renderBox.size.width - 16);
      expect(trackRect.height, 4);
    });

    testWidgets('track geometry follows custom spacing tokens', (tester) async {
      final token = TThemeData.defaultData().copyWithTThemeData(
        'custom-slider-spacing',
        marginMap: const {'spacer4': 5, 'spacer16': 18, 'spacer24': 28},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: Column(
                  children: [
                    TSlider(value: 0.5),
                    TSlider(
                      value: 0.5,
                      divisions: 5,
                      variant: TSliderVariant.capsule,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final sliders = find.byType(Slider);
      final normalTheme = SliderTheme.of(tester.element(sliders.at(0)));
      final capsuleTheme = SliderTheme.of(tester.element(sliders.at(1)));
      final normalBox = tester.renderObject<RenderBox>(sliders.at(0));
      final capsuleBox = tester.renderObject<RenderBox>(sliders.at(1));
      final dynamic normalTrackShape = normalTheme.trackShape;
      final dynamic capsuleTrackShape = capsuleTheme.trackShape;
      final dynamic capsuleTickShape = capsuleTheme.tickMarkShape;
      final Rect normalTrackRect = normalTrackShape.getPreferredRect(
        parentBox: normalBox,
        sliderTheme: normalTheme,
        isEnabled: true,
        isDiscrete: false,
      );
      final Rect capsuleTrackRect = capsuleTrackShape.getPreferredRect(
        parentBox: capsuleBox,
        sliderTheme: capsuleTheme,
        isEnabled: true,
        isDiscrete: true,
      );

      expect(normalTheme.trackHeight, 5);
      expect(normalTrackRect.left, 18);
      expect(normalTrackRect.right, normalBox.size.width - 18);
      expect(capsuleTheme.trackHeight, 28);
      // Material's discrete centers are inset by half the track height;
      // the visual capsule still starts 18px from each edge.
      expect(capsuleTrackRect.left, 7);
      expect(capsuleTrackRect.right, capsuleBox.size.width - 7);
      expect(
        capsuleTickShape.getPreferredSize(
          sliderTheme: capsuleTheme,
          isEnabled: true,
        ),
        Size.zero,
      );
    });

    testWidgets('uses dark TDesign token colors without Material pollution', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      final darkToken = token.dark ?? token;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(token),
          home: const Scaffold(body: TSlider(value: 0.5)),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.activeTrackColor, darkToken.brandNormalColor);
      expect(theme.inactiveTrackColor, darkToken.bgColorComponentHover);
      expect(theme.thumbColor, darkToken.textColorAnti);
      expectThumbBorders(
        theme,
        borderColor: darkToken.grayColor1,
        disabledBorderColor: darkToken.bgColorComponentDisabled,
      );
    });

    testWidgets('preserves local SliderTheme color and label overrides', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [TThemeData.defaultData()],
            sliderTheme: const SliderThemeData(
              activeTrackColor: Colors.red,
              valueIndicatorTextStyle: TextStyle(color: Colors.teal),
            ),
          ),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: TSlider(value: 0.5, showThumbValue: true),
              ),
            ),
          ),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.activeTrackColor, Colors.red);
      expect(theme.thumbColor, TThemeData.defaultData().textColorAnti);
      expect(theme.valueIndicatorTextStyle?.color, Colors.teal);
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
      expectThumbBorders(
        theme,
        borderColor: scheme.outline,
        disabledBorderColor: scheme.outlineVariant,
      );
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
      final tickShape = SliderTheme.of(
        tester.element(find.byType(Slider)),
      ).tickMarkShape;
      expect(tickShape, const RoundSliderTickMarkShape(tickMarkRadius: 3));
    });

    testWidgets('capsule variant owns inset track and 20px thumb geometry', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TSlider(
            value: 0.4,
            divisions: 5,
            variant: TSliderVariant.capsule,
          ),
          materialSliderTheme: const SliderThemeData(
            trackHeight: 6,
            activeTickMarkColor: Colors.purple,
          ),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(Slider)));
      expect(theme.trackHeight, 24);
      expect(theme.activeTickMarkColor, Colors.purple);
      expect(
        theme.trackShape.runtimeType.toString(),
        '_CapsuleSliderTrackShape',
      );
      expect(
        theme.thumbShape?.getPreferredSize(true, false),
        const Size.square(20),
      );
      expect(
        theme.tickMarkShape?.getPreferredSize(
          sliderTheme: theme,
          isEnabled: true,
        ),
        Size.zero,
      );
      final sliderFinder = find.byType(Slider);
      final renderBox = tester.renderObject<RenderBox>(sliderFinder);
      final dynamic trackShape = theme.trackShape;
      final Rect trackRect = trackShape.getPreferredRect(
        parentBox: renderBox,
        sliderTheme: theme,
        isEnabled: true,
        isDiscrete: true,
      );
      expect(trackRect.left, 7);
      expect(trackRect.right, renderBox.size.width - 7);
      expect(trackRect.height, 24);
      expect(trackRect.left + trackRect.height / 2, 19);
      expect(trackRect.right - trackRect.height / 2, renderBox.size.width - 19);
    });

    testWidgets('capsule ticks divide only the interior of the track', (
      tester,
    ) async {
      const boundaryKey = ValueKey('capsule-ticks');

      Future<void> expectInteriorTicksOnly(Widget slider) async {
        await tester.pumpWidget(
          wrap(
            RepaintBoundary(
              key: boundaryKey,
              child: SizedBox(width: 320, height: 48, child: slider),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final boundaryFinder = find.byKey(boundaryKey);
        final sliderFinder = find.byWidgetPredicate(
          (widget) => widget is Slider || widget is RangeSlider,
        );
        final theme = SliderTheme.of(tester.element(sliderFinder));
        final sliderBox = tester.renderObject<RenderBox>(sliderFinder);
        final trackRect = slider is TSlider
            ? theme.trackShape!.getPreferredRect(
                parentBox: sliderBox,
                sliderTheme: theme,
                isEnabled: true,
                isDiscrete: true,
              )
            : theme.rangeTrackShape!.getPreferredRect(
                parentBox: sliderBox,
                sliderTheme: theme,
                isEnabled: true,
                isDiscrete: true,
              );
        final sliderOffset =
            tester.getTopLeft(sliderFinder) - tester.getTopLeft(boundaryFinder);
        final first = trackRect.left + trackRect.height / 2;
        final last = trackRect.right - trackRect.height / 2;
        final interior = first + (last - first) * 2 / 5;
        final y = (sliderOffset.dy + trackRect.center.dy).round();

        final boundary = tester.renderObject<RenderRepaintBoundary>(
          boundaryFinder,
        );
        final pixels = await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 1);
          final data = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          final result = (
            width: image.width,
            bytes: data!.buffer.asUint8List(),
          );
          image.dispose();
          return result;
        });
        Color pixel(double x) {
          final index = (y * pixels!.width + (sliderOffset.dx + x).round()) * 4;
          return Color.fromARGB(
            pixels.bytes[index + 3],
            pixels.bytes[index],
            pixels.bytes[index + 1],
            pixels.bytes[index + 2],
          );
        }

        expect(pixel(first), isNot(Colors.white));
        expect(pixel(last), isNot(Colors.white));
        expect(pixel(interior), isNot(pixel(interior + 4)));
        if (slider is TSlider) {
          final visualLeft = trackRect.left + trackRect.height / 2 - 3;
          final visualWidth = trackRect.width - trackRect.height + 6;
          final dividerLeft = visualLeft + 1.5;
          final dividerStep = (visualWidth - 3) / 5;
          final selectedGap = (dividerLeft + 2 * dividerStep).floorToDouble();
          final inactiveGap = (dividerLeft + 4 * dividerStep).floorToDouble();
          final outerColor = TThemeData.defaultData().bgColorComponent;
          expect(pixel(selectedGap), outerColor);
          expect(pixel(inactiveGap), outerColor);
        }
      }

      await expectInteriorTicksOnly(
        TSlider(
          value: 60,
          min: 0,
          max: 100,
          divisions: 5,
          variant: TSliderVariant.capsule,
          onChanged: (_) {},
        ),
      );
      await expectInteriorTicksOnly(
        TRangeSlider(
          value: const RangeValues(20, 80),
          min: 0,
          max: 100,
          divisions: 5,
          variant: TSliderVariant.capsule,
          onChanged: (_) {},
        ),
      );
    });

    testWidgets('dense capsule divisions do not invert painted segments', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TSlider(
                value: 0.5,
                divisions: 400,
                variant: TSliderVariant.capsule,
              ),
              TRangeSlider(
                value: RangeValues(0.25, 0.75),
                divisions: 400,
                variant: TSliderVariant.capsule,
              ),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
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
      final sliderRect = tester.getRect(find.byType(Slider));
      expect(tester.getRect(find.text('0%')).left, sliderRect.left + 16);
      expect(tester.getRect(find.text('100%')).right, sliderRect.right - 16);
      expect(
        tester.getCenter(find.text('50%')).dx,
        closeTo(sliderRect.center.dx, 0.01),
      );
      expect(
        tester.getBottomLeft(find.text('0%')).dy,
        lessThanOrEqualTo(sliderRect.top),
      );
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
      final tickShape = SliderTheme.of(
        tester.element(find.byType(RangeSlider)),
      ).rangeTickMarkShape;
      expect(tickShape, const RoundRangeSliderTickMarkShape(tickMarkRadius: 3));
    });

    testWidgets('range capsule variant uses component-owned geometry', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TRangeSlider(
            value: RangeValues(0.2, 0.8),
            divisions: 5,
            variant: TSliderVariant.capsule,
          ),
        ),
      );

      final theme = SliderTheme.of(tester.element(find.byType(RangeSlider)));
      expect(theme.trackHeight, 24);
      expect(
        theme.rangeTrackShape.runtimeType.toString(),
        '_CapsuleRangeSliderTrackShape',
      );
      expect(
        theme.rangeThumbShape?.getPreferredSize(true, false),
        const Size.square(20),
      );
      expect(
        theme.rangeTickMarkShape?.getPreferredSize(
          sliderTheme: theme,
          isEnabled: true,
        ),
        Size.zero,
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
      expect(
        tester.getBottomLeft(find.text('0%')).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byType(RangeSlider)).dy),
      );
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
