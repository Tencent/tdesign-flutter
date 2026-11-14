import 'dart:ui' as ui;

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
        4,
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
      expect(theme.activeTrackColor, TThemeData.defaultData().brandColor);
      expect(
        theme.inactiveTrackColor,
        TThemeData.defaultData().componentBorder,
      );
      expect(
        theme.inactiveTickMarkColor,
        TThemeData.defaultData().componentBorder,
      );
      expect(theme.thumbColor, TThemeData.defaultData().textColorAnti);
      expect(
        theme.disabledActiveTrackColor,
        TThemeData.defaultData().brandColorDisabled,
      );
      expect(
        theme.disabledInactiveTrackColor,
        TThemeData.defaultData().bgColorComponentDisabled,
      );
      expectThumbBorders(
        theme,
        borderColor: TThemeData.defaultData().grayColor1,
        disabledBorderColor: TThemeData.defaultData().componentBorder,
      );
    });

    testWidgets(
      'inactive track follows componentBorder, then TSliderThemeData',
      (tester) async {
        final token = TThemeData.defaultData().copyWith(
          name: 'custom-slider-border',
          colorMap: {
            'componentBorder': Colors.purple,
            'bgColorComponent': Colors.green,
          },
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [token]),
            home: const Scaffold(body: TSlider(value: 0.5)),
          ),
        );
        var theme = SliderTheme.of(tester.element(find.byType(Slider)));
        expect(theme.inactiveTrackColor, Colors.purple);
        expect(theme.inactiveTickMarkColor, Colors.purple);
        expectThumbBorders(
          theme,
          borderColor: token.grayColor1,
          disabledBorderColor: Colors.purple,
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              sliderTheme: const SliderThemeData(
                inactiveTrackColor: Colors.red,
              ),
              extensions: [
                token,
                const TSliderThemeData(inactiveTrackColor: Colors.red),
              ],
            ),
            home: const Scaffold(body: TSlider(value: 0.5)),
          ),
        );
        theme = SliderTheme.of(tester.element(find.byType(Slider)));
        expect(theme.inactiveTrackColor, Colors.red);
        expect(theme.inactiveTickMarkColor, Colors.red);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              sliderTheme: const SliderThemeData(
                inactiveTrackColor: Colors.red,
              ),
              extensions: [
                token,
                const TSliderThemeData(inactiveTrackColor: Colors.red),
              ],
            ),
            home: const Scaffold(
              body: TSlider(value: 0.5, variant: TSliderVariant.capsule),
            ),
          ),
        );
        theme = SliderTheme.of(tester.element(find.byType(Slider)));
        final dynamic capsuleTrack = theme.trackShape;
        expect(capsuleTrack.outerColor, Colors.red);
        expect(capsuleTrack.disabledOuterColor, Colors.green);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              sliderTheme: const SliderThemeData(
                inactiveTrackColor: Colors.red,
              ),
              extensions: [
                token,
                const TSliderThemeData(inactiveTrackColor: Colors.red),
              ],
            ),
            home: const Scaffold(
              body: TRangeSlider(
                value: RangeValues(0.2, 0.8),
                variant: TSliderVariant.capsule,
              ),
            ),
          ),
        );
        theme = SliderTheme.of(tester.element(find.byType(RangeSlider)));
        final dynamic capsuleRangeTrack = theme.rangeTrackShape;
        expect(capsuleRangeTrack.outerColor, Colors.red);
        expect(capsuleRangeTrack.disabledOuterColor, Colors.green);
      },
    );

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
      expect(trackRect.height, 0);
      expect(theme.trackHeight, 4);
    });

    testWidgets('track geometry follows custom spacing tokens', (tester) async {
      final token = TThemeData.defaultData().copyWith(
        name: 'custom-slider-spacing',
        spacerMap: const {'spacer2': 18, 'spacer3': 28},
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

      expect(normalTheme.trackHeight, 4);
      expect(normalTrackRect.left, 18);
      expect(normalTrackRect.right, normalBox.size.width - 18);
      expect(capsuleTheme.trackHeight, 28);
      // Coordinate tracks directly describe the actual thumb travel.
      expect(capsuleTrackRect.left, 31);
      expect(capsuleTrackRect.right, capsuleBox.size.width - 31);
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
      expect(theme.activeTrackColor, darkToken.brandColor);
      expect(theme.inactiveTrackColor, darkToken.componentBorder);
      expect(theme.inactiveTickMarkColor, darkToken.componentBorder);
      expect(theme.thumbColor, darkToken.textColorAnti);
      expectThumbBorders(
        theme,
        borderColor: darkToken.grayColor1,
        disabledBorderColor: darkToken.bgColorComponentDisabled,
      );
    });

    testWidgets('uses TSliderThemeData color and label overrides', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            sliderTheme: const SliderThemeData(
              activeTrackColor: Colors.red,
              valueIndicatorTextStyle: TextStyle(color: Colors.teal),
            ),
            extensions: [
              TThemeData.defaultData(),
              const TSliderThemeData(
                activeTrackColor: Colors.red,
                valueIndicatorTextColor: Colors.teal,
              ),
            ],
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

    testWidgets('explicit ColorScheme cannot override TDesign tokens', (
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
      expect(theme.activeTrackColor, TThemeData.defaultData().brandColor);
      expect(
        theme.inactiveTrackColor,
        TThemeData.defaultData().componentBorder,
      );
      expect(theme.thumbColor, TThemeData.defaultData().textColorAnti);
      expectThumbBorders(
        theme,
        borderColor: TThemeData.defaultData().grayColor1,
        disabledBorderColor: TThemeData.defaultData().componentBorder,
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
      expect(tickShape, isA<RoundSliderTickMarkShape>());
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
      expect(theme.activeTickMarkColor, TThemeData.defaultData().brandColor);
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
      // No native padding is applied to the coordinate track.
      expect(trackRect.left, 29);
      expect(trackRect.right, renderBox.size.width - 29);
      expect(trackRect.height, 0);
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
        // Coordinate endpoints already define the complete thumb travel.
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
          // Dividers follow the thumb travel: the first thumb center, then one
          // step of the usable travel per division.
          final dividerLeft = first;
          final dividerStep = (last - first) / 5;
          final selectedGap = (dividerLeft + 2 * dividerStep).floorToDouble();
          final inactiveGap = (dividerLeft + 4 * dividerStep).floorToDouble();
          final outerColor = TThemeData.defaultData().componentBorder;
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

    testWidgets('capsule thumbs stay inside the visible capsule', (
      tester,
    ) async {
      const boundaryKey = ValueKey('capsule-thumb-bounds');

      Future<void> expectThumbsInsideCapsule(Widget slider) async {
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
        final sliderBox = tester.renderObject<RenderBox>(sliderFinder);
        // 可见胶囊的两端就是水平内缩 token，与实现的坐标轨道换算无关。
        final inset = TThemeData.defaultData().spacer2;
        final sliderOffset =
            tester.getTopLeft(sliderFinder) - tester.getTopLeft(boundaryFinder);
        final y = (sliderOffset.dy + sliderBox.size.height / 2).round();

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
        double? firstPainted;
        double? lastPainted;
        for (var x = 0; x < pixels!.width; x++) {
          // 阈值 64 忽略 thumb 投影的极淡外缘，只统计轨道与 thumb 本体。
          if (pixels.bytes[(y * pixels.width + x) * 4 + 3] > 64) {
            firstPainted ??= x.toDouble();
            lastPainted = x.toDouble();
          }
        }

        expect(firstPainted, isNotNull, reason: 'capsule track is painted');
        // 允许 1px 抗锯齿：thumb 不应越过可见胶囊的左右边界。
        expect(
          firstPainted! + 1,
          greaterThanOrEqualTo(inset + sliderOffset.dx),
        );
        expect(
          lastPainted! - 1,
          lessThanOrEqualTo(sliderBox.size.width - inset + sliderOffset.dx),
        );

        // 小程序实测沿行程两端各留 3px，默认横截面各留 2px。
        final theme = SliderTheme.of(tester.element(sliderFinder));
        final isRange = slider is TRangeSlider;
        final thumbSize = isRange
            ? theme.rangeThumbShape!.getPreferredSize(true, false)
            : theme.thumbShape!.getPreferredSize(true, false);
        final trackRect = isRange
            ? theme.rangeTrackShape!.getPreferredRect(
                parentBox: sliderBox,
                sliderTheme: theme,
                isEnabled: true,
                isDiscrete: false,
              )
            : theme.trackShape!.getPreferredRect(
                parentBox: sliderBox,
                sliderTheme: theme,
                isEnabled: true,
                isDiscrete: false,
              );
        // 坐标轨道就是 thumb 行程，两端即 0 / 最大值时的 thumb 中心。
        final firstCenter = trackRect.left;
        final lastCenter = trackRect.right;
        final verticalMargin = (theme.trackHeight! - thumbSize.height) / 2;
        expect(verticalMargin, 2);
        expect(firstCenter - thumbSize.width / 2 - inset, 3);
        expect(
          sliderBox.size.width - inset - (lastCenter + thumbSize.width / 2),
          3,
        );
      }

      await expectThumbsInsideCapsule(
        TSlider(value: 0, variant: TSliderVariant.capsule, onChanged: (_) {}),
      );
      await expectThumbsInsideCapsule(
        TSlider(value: 1, variant: TSliderVariant.capsule, onChanged: (_) {}),
      );
      await expectThumbsInsideCapsule(
        TRangeSlider(
          value: const RangeValues(0, 1),
          variant: TSliderVariant.capsule,
          onChanged: (_) {},
        ),
      );
    });

    testWidgets(
      'capsule endpoint pixels and scale centers agree in LTR and RTL',
      (tester) async {
        const boundaryKey = ValueKey('endpoint-pixels');
        for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
          for (final discrete in [false, true]) {
            for (final range in [false, true]) {
              for (final end in range ? [0] : [0, 1]) {
                final child = range
                    ? TRangeSlider(
                        value: const RangeValues(0, 1),
                        onChanged: (_) {},
                        variant: TSliderVariant.capsule,
                        divisions: discrete ? 5 : null,
                        showScaleValue: discrete,
                        scaleFormatter: (v) => (v * 100).round().toString(),
                      )
                    : TSlider(
                        value: end.toDouble(),
                        onChanged: (_) {},
                        variant: TSliderVariant.capsule,
                        divisions: discrete ? 5 : null,
                        showScaleValue: discrete,
                        scaleFormatter: (v) => (v * 100).round().toString(),
                      );
                await tester.pumpWidget(
                  MaterialApp(
                    theme: TThemeBuilder.dark(TThemeData.defaultData()),
                    home: Directionality(
                      textDirection: direction,
                      child: Scaffold(
                        body: Center(
                          child: RepaintBoundary(
                            key: boundaryKey,
                            child: SizedBox(
                              width: 320,
                              height: 100,
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                await tester.pumpAndSettle();
                final native = range
                    ? find.byType(RangeSlider)
                    : find.byType(Slider);
                final box = tester.renderObject<RenderBox>(native);
                final origin = tester.getTopLeft(find.byKey(boundaryKey));
                final offset = tester.getTopLeft(native) - origin;
                final boundary = tester.renderObject<RenderRepaintBoundary>(
                  find.byKey(boundaryKey),
                );
                final pixels = await tester.runAsync(() async {
                  final image = await boundary.toImage(pixelRatio: 1);
                  final data = (await image.toByteData(
                    format: ui.ImageByteFormat.rawRgba,
                  ))!.buffer.asUint8List();
                  final result = (width: image.width, bytes: data);
                  image.dispose();
                  return result;
                });
                final y = (offset.dy + box.size.height / 2).floor();
                final runs = <List<int>>[];
                for (var x = 0; x < box.size.width; x++) {
                  final i = (y * pixels!.width + (offset.dx + x).floor()) * 4;
                  if (pixels.bytes[i] > 180 &&
                      pixels.bytes[i + 1] > 180 &&
                      pixels.bytes[i + 2] > 180) {
                    if (runs.isEmpty || x > runs.last.last + 1) {
                      runs.add([x]);
                    } else {
                      runs.last.add(x);
                    }
                  }
                }
                final centers = runs
                    .where((r) => r.length >= 8)
                    .map((r) => (r.first + r.last + 1) / 2)
                    .toList();
                final token = TThemeData.defaultData();
                final start = token.spacer2 + 13;
                final finish = box.size.width - start;
                final expected = range
                    ? [start, finish]
                    : [
                        (end == 0) == (direction == TextDirection.ltr)
                            ? start
                            : finish,
                      ];
                expect(
                  centers,
                  hasLength(expected.length),
                  reason: '$direction discrete=$discrete range=$range end=$end',
                );
                for (var i = 0; i < centers.length; i++) {
                  expect(centers[i], closeTo(expected[i], 0.5));
                }
                if (discrete) {
                  for (var index = 0; index <= 5; index++) {
                    final label = find.text('${index * 20}');
                    final ratio = direction == TextDirection.ltr
                        ? index / 5
                        : 1 - index / 5;
                    final target = start + ratio * (finish - start);
                    expect(
                      tester.getCenter(label).dx - tester.getTopLeft(native).dx,
                      closeTo(target, .01),
                    );
                  }
                }
              }
            }
          }
        }
      },
    );

    testWidgets('capsule thumb maps the value linearly across the travel', (
      tester,
    ) async {
      const boundaryKey = ValueKey('capsule-thumb-linear');
      const width = 320.0;
      const value = 0.08;

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(TThemeData.defaultData()),
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: boundaryKey,
                child: SizedBox(
                  width: width,
                  height: 48,
                  child: TSlider(
                    value: value,
                    variant: TSliderVariant.capsule,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      const boundaryFinder = boundaryKey;
      final sliderFinder = find.byType(Slider);
      final sliderOffset =
          tester.getTopLeft(sliderFinder) -
          tester.getTopLeft(find.byKey(boundaryFinder));
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(boundaryFinder),
      );
      final y =
          tester.getTopLeft(sliderFinder).dy -
          tester.getTopLeft(find.byKey(boundaryFinder)).dy +
          24;
      final pixels = await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1);
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final result = (width: image.width, bytes: data!.buffer.asUint8List());
        image.dispose();
        return result;
      });

      // 深色主题下轨道是灰、thumb 是白，用亮度区分 thumb 本体。
      double? thumbLeft;
      double? thumbRight;
      for (var x = 0; x < pixels!.width; x++) {
        final index = (y.round() * pixels.width + x) * 4;
        final alpha = pixels.bytes[index + 3];
        final brightness =
            (pixels.bytes[index] +
                pixels.bytes[index + 1] +
                pixels.bytes[index + 2]) /
            3;
        if (alpha > 200 && brightness > 200) {
          thumbLeft ??= x.toDouble();
          thumbRight = x.toDouble();
        }
      }
      expect(thumbLeft, isNotNull, reason: 'thumb is painted');

      final token = TThemeData.defaultData();
      const thumbRadius = 10.0;
      const margin = 3.0;
      final travelLeft = token.spacer2 + margin + thumbRadius;
      final travelRight = width - travelLeft;
      expect(
        (thumbLeft! + thumbRight!) / 2,
        closeTo(
          travelLeft + value * (travelRight - travelLeft) + sliderOffset.dx,
          1,
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
      expect(tester.getCenter(find.text('0%')).dx, sliderRect.left + 16);
      expect(tester.getCenter(find.text('100%')).dx, sliderRect.right - 16);
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

    testWidgets('click preserves thumb focus after pointer up', (tester) async {
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            onChanged: (value) {},
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // Newer SDKs focus the thumb on pointer down; older SDKs may not.
      bool focusInsideSlider() {
        final focus = FocusManager.instance.primaryFocus;
        final focusContext = focus?.context;
        if (focusContext == null) {
          return false;
        }
        var inside = false;
        focusContext.visitAncestorElements((element) {
          if (identical(element, tester.element(find.byType(RangeSlider)))) {
            inside = true;
            return false;
          }
          return true;
        });
        return inside;
      }

      final center = tester.getCenter(find.byType(RangeSlider));
      await gesture.down(center + const Offset(100, 0));
      await tester.pump();
      final hadSliderFocus = focusInsideSlider();
      final focusedThumb = FocusManager.instance.primaryFocus;
      await gesture.up();
      await tester.pumpAndSettle();
      expect(focusInsideSlider(), hadSliderFocus);
      expect(FocusManager.instance.primaryFocus, same(focusedThumb));

      // Moving the pointer away must not discard the focus.
      await gesture.moveTo(center - const Offset(320, 0));
      await tester.pumpAndSettle();
      expect(focusInsideSlider(), hadSliderFocus);
    });

    for (final kind in [
      ui.PointerDeviceKind.mouse,
      ui.PointerDeviceKind.touch,
    ]) {
      testWidgets('pointer drag retains thumb focus: $kind', (tester) async {
        RangeValues? changed;
        await tester.pumpWidget(
          wrap(
            TRangeSlider(
              value: const RangeValues(20, 60),
              min: 0,
              max: 100,
              onChanged: (value) => changed = value,
            ),
          ),
        );
        final slider = find.byType(RangeSlider);
        final gesture = await tester.createGesture(kind: kind);
        final center = tester.getCenter(slider);
        await gesture.addPointer(location: center - const Offset(80, 0));
        await gesture.down(center - const Offset(80, 0));
        await tester.pump();
        await gesture.moveBy(const Offset(35, 0));
        await tester.pump();
        expect(changed, isNotNull);
        final focusedThumb = FocusManager.instance.primaryFocus;
        await gesture.up();
        await tester.pumpAndSettle();
        expect(FocusManager.instance.primaryFocus, same(focusedThumb));
        await gesture.removePointer();
      });
    }

    testWidgets('touch release restores the idle slider rendering', (
      tester,
    ) async {
      tester.binding.focusManager.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      addTearDown(
        () => tester.binding.focusManager.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: wrap(
            TRangeSlider(
              value: const RangeValues(20, 60),
              min: 0,
              max: 100,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<List<int>> capture() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(boundaryKey),
        );
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        image.dispose();
        return data!.buffer.asUint8List();
      }

      final idle = (await tester.runAsync(capture))!;
      final touch = await tester.createGesture(
        kind: ui.PointerDeviceKind.touch,
      );
      await touch.down(
        tester.getCenter(find.byType(RangeSlider)) - const Offset(80, 0),
      );
      await touch.up();
      await tester.pumpAndSettle();
      final after = (await tester.runAsync(capture))!;
      var changedPixels = 0;
      for (var index = 0; index < idle.length; index += 4) {
        if (idle[index] != after[index] ||
            idle[index + 1] != after[index + 1] ||
            idle[index + 2] != after[index + 2] ||
            idle[index + 3] != after[index + 3]) {
          changedPixels++;
        }
      }
      expect(
        changedPixels,
        0,
        reason: 'touch must not leave an overlay at rest',
      );
    });

    testWidgets('Android automatic mode hides touch focus overlay', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      tester.binding.focusManager.highlightStrategy =
          FocusHighlightStrategy.automatic;
      addTearDown(() {
        debugDefaultTargetPlatformOverride = null;
        tester.binding.focusManager.highlightStrategy =
            FocusHighlightStrategy.automatic;
      });
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: wrap(
            TRangeSlider(
              value: const RangeValues(20, 60),
              min: 0,
              max: 100,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<List<int>> capture() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        image.dispose();
        return data!.buffer.asUint8List();
      }

      final idle = (await tester.runAsync(capture))!;
      final touch = await tester.createGesture(
        kind: ui.PointerDeviceKind.touch,
      );
      await touch.down(
        tester.getCenter(find.byType(RangeSlider)) - const Offset(80, 0),
      );
      await tester.pump();
      final focusedThumb = FocusManager.instance.primaryFocus;
      await touch.up();
      await tester.pumpAndSettle();
      expect(
        tester.binding.focusManager.highlightMode,
        FocusHighlightMode.touch,
      );
      expect(FocusManager.instance.primaryFocus, same(focusedThumb));
      final after = (await tester.runAsync(capture))!;
      expect(
        after,
        orderedEquals(idle),
        reason: 'touch must not leave a focus overlay',
      );
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('touch drag keeps pressed feedback outside the slider', (
      tester,
    ) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: wrap(
            TRangeSlider(
              value: const RangeValues(20, 60),
              min: 0,
              max: 100,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<List<int>> capture() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final image = await boundary.toImage();
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        image.dispose();
        return bytes!.buffer.asUint8List();
      }

      final idle = (await tester.runAsync(capture))!;
      final touch = await tester.createGesture(
        kind: ui.PointerDeviceKind.touch,
      );
      await touch.down(
        tester.getCenter(find.byType(RangeSlider)) - const Offset(80, 0),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await touch.moveBy(const Offset(400, 0));
      await tester.pump(const Duration(milliseconds: 200));
      final active = (await tester.runAsync(capture))!;
      var changed = 0;
      for (var i = 0; i < idle.length; i += 4) {
        if (idle[i] != active[i] ||
            idle[i + 1] != active[i + 1] ||
            idle[i + 2] != active[i + 2] ||
            idle[i + 3] != active[i + 3]) {
          changed++;
        }
      }
      // Flutter 3.32's native RangeSlider already loses this overlay when
      // the pointer leaves. Newer SDKs must keep active drag feedback.
      final legacyHover = find
          .descendant(
            of: find.byType(RangeSlider),
            matching: find.byType(FocusableActionDetector),
          )
          .evaluate()
          .isNotEmpty;
      if (!legacyHover) {
        expect(changed, greaterThan(0));
      }
      await touch.up();
      await tester.pumpAndSettle();
    });

    testWidgets('drag outside retains focus and finishes interaction', (
      tester,
    ) async {
      var ended = 0;
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            onChanged: (_) {},
            onChangeEnd: (_) => ended++,
          ),
        ),
      );
      final slider = find.byType(RangeSlider);
      final mouse = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      final center = tester.getCenter(slider);
      await mouse.addPointer(location: center - const Offset(80, 0));
      await mouse.down(center - const Offset(80, 0));
      await tester.pump();
      final focusedThumb = FocusManager.instance.primaryFocus;
      await mouse.moveBy(const Offset(400, 0));
      await tester.pump();
      await mouse.up();
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, same(focusedThumb));
      expect(ended, 1);
      await mouse.removePointer();
    });

    testWidgets('cancelled pointer retains slider focus', (tester) async {
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            onChanged: (_) {},
          ),
        ),
      );
      final slider = find.byType(RangeSlider);
      final gesture = await tester.createGesture(
        kind: ui.PointerDeviceKind.touch,
      );
      await gesture.down(tester.getCenter(slider) - const Offset(80, 0));
      await tester.pump();
      final focusedThumb = FocusManager.instance.primaryFocus;
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, same(focusedThumb));
    });

    testWidgets('mouse click keeps the native Tab traversal position', (
      tester,
    ) async {
      Future<List<bool>> observe({required bool native}) async {
        final slider = native
            ? RangeSlider(values: const RangeValues(.2, .6), onChanged: (_) {})
            : TRangeSlider(value: const RangeValues(.2, .6), onChanged: (_) {});
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextButton(onPressed: () {}, child: const Text('before')),
                  SizedBox(width: 320, child: slider),
                  TextButton(onPressed: () {}, child: const Text('after')),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final finder = find.byType(RangeSlider);
        final point = tester.getCenter(finder) - const Offset(80, 0);
        final mouse = await tester.createGesture(
          kind: ui.PointerDeviceKind.mouse,
        );
        await mouse.addPointer(location: point);
        await mouse.down(point);
        await tester.pump();
        await mouse.up();
        await tester.pumpAndSettle();
        bool focusInside() {
          var inside = false;
          FocusManager.instance.primaryFocus?.context?.visitAncestorElements((
            element,
          ) {
            if (identical(element, tester.element(finder))) {
              inside = true;
            }
            return true;
          });
          return inside;
        }

        final afterClick = focusInside();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final afterTab = focusInside();
        await mouse.removePointer();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        return [afterClick, afterTab];
      }

      final expected = await observe(native: true);
      final actual = await observe(native: false);
      expect(actual, expected);
    });

    for (final strategy in [
      FocusHighlightStrategy.alwaysTouch,
      FocusHighlightStrategy.alwaysTraditional,
    ]) {
      testWidgets('focus highlight obeys $strategy after touch and Tab', (
        tester,
      ) async {
        tester.binding.focusManager.highlightStrategy = strategy;
        addTearDown(
          () => tester.binding.focusManager.highlightStrategy =
              FocusHighlightStrategy.automatic,
        );
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: wrap(
              TRangeSlider(
                value: const RangeValues(20, 60),
                min: 0,
                max: 100,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        Future<List<int>> capture() async {
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(key),
          );
          final image = await boundary.toImage();
          final data = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          image.dispose();
          return data!.buffer.asUint8List();
        }

        int difference(List<int> a, List<int> b) {
          var changed = 0;
          for (var i = 0; i < a.length; i += 4) {
            if (a[i] != b[i] ||
                a[i + 1] != b[i + 1] ||
                a[i + 2] != b[i + 2] ||
                a[i + 3] != b[i + 3]) {
              changed++;
            }
          }
          return changed;
        }

        final idle = (await tester.runAsync(capture))!;
        final slider = find.byType(RangeSlider);
        final touch = await tester.createGesture(
          kind: ui.PointerDeviceKind.touch,
        );
        await touch.down(tester.getCenter(slider) - const Offset(80, 0));
        await tester.pump();
        final focusedThumb = FocusManager.instance.primaryFocus;
        await touch.up();
        await tester.pumpAndSettle();
        expect(FocusManager.instance.primaryFocus, same(focusedThumb));
        final touchPixels = difference(idle, (await tester.runAsync(capture))!);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final tabPixels = difference(idle, (await tester.runAsync(capture))!);
        final legacyFocus = find
            .descendant(
              of: slider,
              matching: find.byType(FocusableActionDetector),
            )
            .evaluate()
            .isNotEmpty;
        if (strategy == FocusHighlightStrategy.alwaysTouch) {
          expect(touchPixels, 0);
          expect(tabPixels, 0);
          tester.binding.focusManager.highlightStrategy =
              FocusHighlightStrategy.alwaysTraditional;
          await tester.pumpAndSettle();
          if (!legacyFocus) {
            expect(
              difference(idle, (await tester.runAsync(capture))!),
              greaterThan(0),
            );
          }
          tester.binding.focusManager.highlightStrategy =
              FocusHighlightStrategy.alwaysTouch;
          await tester.pumpAndSettle();
          expect(difference(idle, (await tester.runAsync(capture))!), 0);
        } else if (!legacyFocus) {
          expect(touchPixels, greaterThan(0));
          expect(tabPixels, greaterThan(0));
        }
      });
    }

    testWidgets('keyboard focus restores its visual highlight', (tester) async {
      Future<int> focusPixels({required bool native}) async {
        final key = GlobalKey();
        final slider = native
            ? RangeSlider(values: const RangeValues(.2, .6), onChanged: (_) {})
            : TRangeSlider(value: const RangeValues(.2, .6), onChanged: (_) {});
        await tester.pumpWidget(RepaintBoundary(key: key, child: wrap(slider)));
        await tester.pumpAndSettle();
        Future<List<int>> capture() async {
          final boundary = tester.renderObject<RenderRepaintBoundary>(
            find.byKey(key),
          );
          final image = await boundary.toImage();
          final bytes = await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          image.dispose();
          return bytes!.buffer.asUint8List();
        }

        final before = (await tester.runAsync(capture))!;
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final after = (await tester.runAsync(capture))!;
        var changed = 0;
        for (var i = 0; i < before.length; i += 4) {
          if (before[i] != after[i] ||
              before[i + 1] != after[i + 1] ||
              before[i + 2] != after[i + 2] ||
              before[i + 3] != after[i + 3]) {
            changed++;
          }
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        return changed;
      }

      final native = await focusPixels(native: true);
      final tdesign = await focusPixels(native: false);
      if (native > 0) {
        expect(tdesign, greaterThan(0));
      }
    });

    testWidgets('mouse hover and focus follow traditional highlight policy', (
      tester,
    ) async {
      tester.binding.focusManager.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => tester.binding.focusManager.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: wrap(
            TRangeSlider(
              value: const RangeValues(20, 60),
              min: 0,
              max: 100,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<List<int>> capture() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final image = await boundary.toImage();
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        image.dispose();
        return bytes!.buffer.asUint8List();
      }

      int diff(List<int> a, List<int> b) {
        var count = 0;
        for (var i = 0; i < a.length; i += 4) {
          if (a[i] != b[i] ||
              a[i + 1] != b[i + 1] ||
              a[i + 2] != b[i + 2] ||
              a[i + 3] != b[i + 3]) {
            count++;
          }
        }
        return count;
      }

      final idle = (await tester.runAsync(capture))!;
      final slider = find.byType(RangeSlider);
      final center = tester.getCenter(slider);
      final thumb = center - const Offset(80, 0);
      final mouse = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(thumb);
      await tester.pumpAndSettle();
      final hovered = (await tester.runAsync(capture))!;
      // The older native slider uses a different hover path and does not
      // paint this position in the baseline.
      final legacyHover = find
          .descendant(
            of: slider,
            matching: find.byType(FocusableActionDetector),
          )
          .evaluate()
          .isNotEmpty;
      if (!legacyHover) {
        expect(diff(idle, hovered), greaterThan(0));
      }
      await mouse.down(thumb);
      await tester.pump();
      await mouse.up();
      await tester.pumpAndSettle();
      await mouse.moveTo(center + const Offset(135, 0));
      await tester.pumpAndSettle();
      final away = (await tester.runAsync(capture))!;
      if (!legacyHover) {
        expect(
          diff(idle, away),
          greaterThan(0),
          reason: 'traditional focus remains visible when the mouse leaves',
        );
      }
      await mouse.removePointer();
    });

    testWidgets('Tab after touch shows keyboard focus feedback', (
      tester,
    ) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: wrap(
            TRangeSlider(
              value: const RangeValues(20, 60),
              min: 0,
              max: 100,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<List<int>> capture() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        image.dispose();
        return data!.buffer.asUint8List();
      }

      final touch = await tester.createGesture(
        kind: ui.PointerDeviceKind.touch,
      );
      await touch.down(
        tester.getCenter(find.byType(RangeSlider)) - const Offset(80, 0),
      );
      await tester.pump();
      await touch.up();
      await tester.pumpAndSettle();
      final pointerView = (await tester.runAsync(capture))!;
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final keyboardView = (await tester.runAsync(capture))!;
      var changed = 0;
      for (var i = 0; i < pointerView.length; i += 4) {
        if (pointerView[i] != keyboardView[i] ||
            pointerView[i + 1] != keyboardView[i + 1] ||
            pointerView[i + 2] != keyboardView[i + 2] ||
            pointerView[i + 3] != keyboardView[i + 3]) {
          changed++;
        }
      }
      final legacyFocus = find
          .descendant(
            of: find.byType(RangeSlider),
            matching: find.byType(FocusableActionDetector),
          )
          .evaluate()
          .isNotEmpty;
      if (!legacyFocus) {
        expect(changed, greaterThan(0));
      }
    });

    testWidgets('hover exit preserves keyboard focus', (tester) async {
      await tester.pumpWidget(
        wrap(
          TRangeSlider(
            value: const RangeValues(20, 60),
            min: 0,
            max: 100,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      final focused = FocusManager.instance.primaryFocus;
      expect(focused?.context, isNotNull);
      var inside = false;
      focused!.context!.visitAncestorElements((element) {
        if (identical(element, tester.element(find.byType(RangeSlider)))) {
          inside = true;
        }
        return true;
      });
      expect(inside, isTrue);
      final mouse = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      await mouse.addPointer(
        location: tester.getCenter(find.byType(RangeSlider)),
      );
      await tester.pump();
      await mouse.moveTo(Offset.zero);
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, same(focused));
      await mouse.removePointer();
    });

    testWidgets('pointer release does not clear another control focus', (
      tester,
    ) async {
      final outsideFocus = FocusNode();
      addTearDown(outsideFocus.dispose);
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              TextField(focusNode: outsideFocus),
              TRangeSlider(
                value: const RangeValues(20, 60),
                min: 0,
                max: 100,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );
      final gesture = await tester.createGesture(
        kind: ui.PointerDeviceKind.touch,
      );
      await gesture.down(tester.getCenter(find.byType(RangeSlider)));
      await tester.pump();
      outsideFocus.requestFocus();
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(outsideFocus.hasFocus, isTrue);
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
      expect(tickShape, isA<RoundRangeSliderTickMarkShape>());
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
