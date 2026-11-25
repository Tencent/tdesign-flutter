import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/slider/t_slider_geometry.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('effective values share native discrete normalization', () {
    expect(SliderGeometry.effectiveValue(23, 0, 100, 5), 20);
    expect(SliderGeometry.effectiveValue(77, 0, 100, 5), 80);
    expect(SliderGeometry.effectiveValue(33, 10, 110, 5), 30);
    expect(SliderGeometry.effectiveValue(10, 10, 110, 5), 10);
    expect(SliderGeometry.effectiveValue(110, 10, 110, 5), 110);
    expect(SliderGeometry.effectiveValue(33, 10, 110, null), 33);
    expect(SliderGeometry.effectiveValue(33, 10, 110, 0), 33);
  });

  test('adaptive metrics keep the thumb border within all finite widths', () {
    for (final capsule in [false, true]) {
      for (final width in [0.0, 1.0, 8.0, 24.0, 48.0, 320.0]) {
        final metrics = SliderGeometry(
          capsule: capsule,
          trackHeight: capsule ? 24 : 4,
          horizontalInset: 0,
        ).forWidth(width);
        final outerRadius = metrics.thumbRadius * 1.05;
        expect(
          metrics.thumbInset - outerRadius,
          greaterThanOrEqualTo(-.000001),
        );
        expect(
          width - metrics.thumbInset + outerRadius,
          lessThanOrEqualTo(width + .000001),
        );
      }
    }
  });

  const boundaryKey = ValueKey('geometry-audit');
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    double width = 320,
    double spacer3 = 24,
    double spacer2 = 16,
    double? height,
    Axis axis = Axis.horizontal,
    TextDirection direction = TextDirection.ltr,
    Color? borderColor,
  }) async {
    final token = TThemeData.defaultData().copyWith(
      spacerMap: {'spacer2': spacer2, 'spacer3': spacer3},
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.dark(token).mergeExtension(
          TSliderThemeData(
            trackHeight: height,
            thumbColor: Colors.white,
            disabledThumbColor: Colors.white,
            thumbBorderColor: borderColor,
          ),
        ),
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: boundaryKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: width,
                  height: 120,
                  child: SliderGeometryScope(
                    axis: axis,
                    child: Directionality(
                      textDirection: direction,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  Future<List<(double, double)>> thumbRuns(WidgetTester tester) async {
    final native = find
        .byWidgetPredicate((w) => w is Slider || w is RangeSlider)
        .first;
    final box = tester.renderObject<RenderBox>(native);
    if (box.size.width == 0) {
      return [];
    }
    final offset =
        tester.getTopLeft(native) - tester.getTopLeft(find.byKey(boundaryKey));
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(boundaryKey),
    );
    return (await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final bytes = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!.buffer.asUint8List();
      final y = (offset.dy + box.size.height / 2).floor();
      final groups = <List<int>>[];
      for (var x = -12; x < box.size.width + 12; x++) {
        final i = (y * image.width + (offset.dx + x).floor()) * 4;
        if (bytes[i] > 245 && bytes[i + 1] > 245 && bytes[i + 2] > 245) {
          if (groups.isEmpty || x > groups.last.last + 1) {
            groups.add([x]);
          } else {
            groups.last.add(x);
          }
        }
      }
      image.dispose();
      return groups.map((g) => (g.first.toDouble(), g.last + 1.0)).toList();
    }))!;
  }

  testWidgets('custom normal track height preserves linear continuous travel', (
    tester,
  ) async {
    final centers = <double>[];
    for (final value in [0.0, .02, .08, .2, 1.0]) {
      await pump(tester, TSlider(value: value, onChanged: (_) {}), height: 24);
      final run = (await thumbRuns(tester)).single;
      final center = (run.$1 + run.$2) / 2;
      expect(center, closeTo(16 + value * 288, .75));
      centers.add(center);
    }
    expect(centers[1], greaterThan(centers[0]));
  });

  testWidgets('20px thumb includes its border rather than extending it', (
    tester,
  ) async {
    for (final variant in TSliderVariant.values) {
      await pump(
        tester,
        TSlider(value: 0, variant: variant, onChanged: (_) {}),
        borderColor: Colors.red,
      );
      final native = find.byType(Slider);
      final offset =
          tester.getTopLeft(native) -
          tester.getTopLeft(find.byKey(boundaryKey));
      final box = tester.renderObject<RenderBox>(native);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(boundaryKey),
      );
      final bounds = (await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 4);
        final data = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!.buffer.asUint8List();
        final y = ((offset.dy + box.size.height / 2) * 4).floor();
        final red = <int>[];
        for (var x = 0; x < image.width; x++) {
          final i = (y * image.width + x) * 4;
          if (data[i] > 240 && data[i + 1] < 180 && data[i + 2] < 180) {
            red.add(x);
          }
        }
        image.dispose();
        return (red.first / 4 - offset.dx, (red.last + 1) / 4 - offset.dx);
      }))!;
      final center = variant == TSliderVariant.capsule ? 29.0 : 16.0;
      expect(bounds.$1, closeTo(center - 10, .25));
      expect(bounds.$2, closeTo(center + 10, .25));
    }
  });

  testWidgets('small capsule tokens retain room for the thumb in both modes', (
    tester,
  ) async {
    for (final height in [8.0, 16.0, 20.0, 24.0, 28.0]) {
      for (final divisions in [null, 5]) {
        for (final end in [0.0, 1.0]) {
          await pump(
            tester,
            TSlider(
              value: end,
              onChanged: (_) {},
              variant: TSliderVariant.capsule,
              divisions: divisions,
            ),
            spacer3: height,
          );
          final actualHeight = SliderTheme.of(
            tester.element(find.byType(Slider)),
          ).trackHeight!;
          expect(actualHeight, height < 24 ? 24 : height);
          final run = (await thumbRuns(tester)).single;
          final center = (run.$1 + run.$2) / 2;
          const inset = 29.0;
          expect(center, closeTo(end == 0 ? inset : 320 - inset, .75));
          expect(run.$1, greaterThanOrEqualTo(16));
          expect(run.$2, lessThanOrEqualTo(304));
        }
      }
    }
  });

  testWidgets('narrow and zero constraints have safe bounded geometry', (
    tester,
  ) async {
    for (final width in [48.0, 24.0, 8.0, 0.0]) {
      for (final discrete in [false, true]) {
        for (final range in [false, true]) {
          final child = range
              ? TRangeSlider(
                  value: const RangeValues(0, 1),
                  onChanged: (_) {},
                  variant: TSliderVariant.capsule,
                  divisions: discrete ? 5 : null,
                )
              : TSlider(
                  value: 0,
                  onChanged: (_) {},
                  variant: TSliderVariant.capsule,
                  divisions: discrete ? 5 : null,
                );
          await pump(tester, child, width: width);
          for (final run in await thumbRuns(tester)) {
            expect(run.$1, greaterThanOrEqualTo(0));
            expect(run.$2, lessThanOrEqualTo(width));
          }
        }
      }
    }
  });

  testWidgets(
    'small and invalid spacing cannot move the thumb outside the box',
    (tester) async {
      for (final inset in [0.0, 4.0, -4.0, double.nan, double.infinity]) {
        await pump(
          tester,
          TSlider(value: 0, onChanged: (_) {}),
          spacer2: inset,
        );
        final run = (await thumbRuns(tester)).single;
        expect(run.$1, greaterThanOrEqualTo(0));
      }
      for (final height in [-1.0, double.nan, double.infinity]) {
        await pump(tester, const TSlider(value: .5), height: height);
        expect(
          SliderTheme.of(tester.element(find.byType(Slider))).trackHeight,
          0,
        );
      }
    },
  );

  testWidgets('off-grid values keep formatter inputs while positions snap', (
    tester,
  ) async {
    final formatted = <double>[];
    await pump(
      tester,
      TSlider(
        value: 23,
        min: 0,
        max: 100,
        divisions: 5,
        showThumbValue: true,
        thumbFormatter: (v) {
          formatted.add(v);
          return '$v';
        },
      ),
    );
    expect(tester.widget<Slider>(find.byType(Slider)).value, 20);
    expect(formatted, [23]);
    final dynamic singleShape = SliderTheme.of(
      tester.element(find.byType(Slider)),
    ).thumbShape;
    expect(singleShape.label, '23.0');
    await pump(
      tester,
      const TRangeSlider(
        value: RangeValues(23, 77),
        min: 0,
        max: 100,
        divisions: 5,
        showThumbValue: true,
      ),
    );
    expect(
      tester.widget<RangeSlider>(find.byType(RangeSlider)).values,
      const RangeValues(20, 80),
    );
    final dynamic rangeShape = SliderTheme.of(
      tester.element(find.byType(RangeSlider)),
    ).rangeThumbShape;
    expect(rangeShape.labels.start, '23.00');
    expect(rangeShape.labels.end, '77.00');
    formatted.clear();
    await pump(
      tester,
      TRangeSlider(
        value: const RangeValues(23, 77),
        min: 0,
        max: 100,
        divisions: 5,
        showThumbValue: true,
        thumbFormatter: (v) {
          formatted.add(v);
          return '$v';
        },
      ),
    );
    expect(formatted, isNotEmpty);
    expect(formatted.toSet(), {23, 77});
  });

  testWidgets('normal-sized narrow controlled range retains native gap', (
    tester,
  ) async {
    for (final variant in TSliderVariant.values) {
      var values = const RangeValues(.40, .41);
      final changes = <RangeValues>[];
      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => TRangeSlider(
            value: values,
            variant: variant,
            onChanged: (next) {
              changes.add(next);
              setState(() => values = next);
            },
          ),
        ),
      );
      final range = find.byType(RangeSlider);
      final theme = SliderTheme.of(tester.element(range));
      expect(theme.minThumbSeparation, 8);
      final box = tester.renderObject<RenderBox>(range);
      final track = theme.rangeTrackShape!.getPreferredRect(
        parentBox: box,
        offset: Offset.zero,
        sliderTheme: theme,
        isEnabled: true,
        isDiscrete: false,
      );
      final start =
          tester.getTopLeft(range) +
          Offset(track.left + track.width * .40, box.size.height / 2);
      final gesture = await tester.startGesture(start);
      await gesture.moveBy(const Offset(-20, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(changes, isNotEmpty);
      expect(changes.last.start, greaterThanOrEqualTo(0));
      expect(changes.last.end, lessThanOrEqualTo(1));
      expect(
        (changes.last.end - changes.last.start) * track.width,
        closeTo(8, .00001),
      );
    }
  });

  test('gap is bounded by domain edges rather than current interval', () {
    final metrics = const SliderGeometry(
      capsule: false,
      trackHeight: 4,
      horizontalInset: 0,
    ).forWidth(320);
    expect(metrics.rangeSeparation(.4, .41), 8);
    expect(metrics.rangeSeparation(.5, .5), 8);
    expect(metrics.rangeSeparation(0, .001), lessThan(8));
    expect(metrics.rangeSeparation(.999, 1), lessThan(8));
  });
  testWidgets('intrinsic and unbounded compositions retain native sizing', (
    tester,
  ) async {
    for (final range in [false, true]) {
      for (final labels in [false, true]) {
        final child = range
            ? TRangeSlider(
                value: const RangeValues(.2, .8),
                divisions: labels ? 5 : null,
                showScaleValue: labels,
              )
            : TSlider(
                value: .2,
                divisions: labels ? 5 : null,
                showScaleValue: labels,
              );
        await pump(
          tester,
          Center(
            child: IntrinsicWidth(child: IntrinsicHeight(child: child)),
          ),
        );
        final native = find
            .byWidgetPredicate((w) => w is Slider || w is RangeSlider)
            .first;
        final box = tester.renderObject<RenderBox>(native);
        expect(box.size.width, greaterThan(0));
        expect(box.getMaxIntrinsicWidth(double.infinity), greaterThan(0));
        expect(box.getMinIntrinsicWidth(double.infinity), greaterThan(0));
        final host = tester.renderObject<RenderBox>(find.byWidget(child));
        expect(host.getMaxIntrinsicWidth(double.infinity), greaterThan(0));
        expect(host.getMinIntrinsicHeight(double.infinity), greaterThan(0));
        if (!labels) {
          expect(
            host.getDryBaseline(
              BoxConstraints.tight(host.size),
              TextBaseline.alphabetic,
            ),
            isNull,
          );
        }
      }
    }
  });
  testWidgets('default endpoint scale text is complete and centered', (
    tester,
  ) async {
    await pump(
      tester,
      const TSlider(value: 1, divisions: 5, showScaleValue: true),
    );
    final label = find.text('1.0');
    expect(
      tester.renderObject<RenderParagraph>(label).didExceedMaxLines,
      isFalse,
    );
    final native = find.byType(Slider);
    expect(
      tester.getCenter(label).dx - tester.getTopLeft(native).dx,
      closeTo(304, .01),
    );
    await pump(
      tester,
      const TSlider(value: 100, max: 100, divisions: 5, showScaleValue: true),
    );
    expect(
      tester
          .renderObject<RenderParagraph>(find.text('100.0'))
          .didExceedMaxLines,
      isFalse,
    );
  });
  for (final axis in Axis.values) {
    for (final capsule in [false, true]) {
      testWidgets('measured MiniProgram endpoints $axis capsule=$capsule', (
        tester,
      ) async {
        for (final height in [4.0, 8.0, 24.0]) {
          for (final divisions in [null, 5]) {
            for (final range in [false, true]) {
              for (final direction in TextDirection.values) {
                for (final enabled in [false, true]) {
                  for (final end in [0.0, 1.0]) {
                    final variant = capsule
                        ? TSliderVariant.capsule
                        : TSliderVariant.normal;
                    final child = range
                        ? TRangeSlider(
                            value: const RangeValues(0, 1),
                            divisions: divisions,
                            variant: variant,
                            onChanged: enabled ? (_) {} : null,
                          )
                        : TSlider(
                            value: end,
                            divisions: divisions,
                            variant: variant,
                            onChanged: enabled ? (_) {} : null,
                          );
                    await pump(
                      tester,
                      child,
                      axis: axis,
                      direction: direction,
                      height: height,
                    );
                    final native = find.byWidgetPredicate(
                      (w) => w is Slider || w is RangeSlider,
                    );
                    final box = tester.renderObject<RenderBox>(native);
                    final theme = SliderTheme.of(tester.element(native));
                    final rect = range
                        ? theme.rangeTrackShape!.getPreferredRect(
                            parentBox: box,
                            sliderTheme: theme,
                          )
                        : theme.trackShape!.getPreferredRect(
                            parentBox: box,
                            sliderTheme: theme,
                          );
                    // Independent measured contract: MP capsule center = 10 + 3;
                    // horizontal layout margin = 16, vertical thumb hit margin = 10.5.
                    final start =
                        (axis == Axis.horizontal ? 16.0 : 10.5) +
                        (capsule ? 13 : 0);
                    expect(rect.left, start);
                    expect(rect.right, 320 - start);
                    final expected = range
                        ? [start, 320 - start]
                        : [
                            (end == 0) == (direction == TextDirection.ltr)
                                ? start
                                : 320 - start,
                          ];
                    final runs = await thumbRuns(tester);
                    expect(runs, hasLength(expected.length));
                    for (var i = 0; i < runs.length; i++) {
                      expect(
                        (runs[i].$1 + runs[i].$2) / 2,
                        closeTo(expected[i], .75),
                        reason:
                            '$axis $capsule $height $divisions $range $direction $enabled $end',
                      );
                    }
                  }
                }
              }
            }
          }
        }
      });
    }
  }
  testWidgets('48px controls still respond to real endpoint drags', (
    tester,
  ) async {
    var value = .5;
    var values = const RangeValues(.2, .8);
    for (final range in [false, true]) {
      await pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => range
              ? TRangeSlider(
                  value: values,
                  onChanged: (v) => setState(() => values = v),
                  variant: TSliderVariant.capsule,
                )
              : TSlider(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                  variant: TSliderVariant.capsule,
                ),
        ),
        width: 48,
      );
      final finder = range ? find.byType(RangeSlider) : find.byType(Slider);
      final box = tester.renderObject<RenderBox>(finder);
      final theme = SliderTheme.of(tester.element(finder));
      final rect = range
          ? theme.rangeTrackShape!.getPreferredRect(
              parentBox: box,
              sliderTheme: theme,
            )
          : theme.trackShape!.getPreferredRect(
              parentBox: box,
              sliderTheme: theme,
            );
      Offset at(double ratio) => box.localToGlobal(
        Offset(rect.left + ratio * rect.width, rect.center.dy),
      );
      var from = at(range ? .2 : .5);
      await tester.dragFrom(from, at(0) - from - const Offset(30, 0));
      await tester.pumpAndSettle();
      if (range) {
        expect(values.start, 0);
      } else {
        expect(value, 0);
      }
      from = at(range ? .8 : 0);
      await tester.dragFrom(from, at(1) - from + const Offset(30, 0));
      await tester.pumpAndSettle();
      if (range) {
        expect(values.end, 1);
      } else {
        expect(value, 1);
      }
    }
  });

  testWidgets('rotated and horizontal drags reach nonzero range endpoints', (
    tester,
  ) async {
    for (final axis in Axis.values) {
      for (final capsule in [false, true]) {
        for (final divisions in [null, 5]) {
          for (final range in [false, true]) {
            for (final direction in TextDirection.values) {
              var value = 50.0;
              var values = const RangeValues(30, 90);
              final effectiveDirection = axis == Axis.vertical
                  ? TextDirection.ltr
                  : direction;
              await tester.pumpWidget(
                MaterialApp(
                  theme: TThemeBuilder.light(TThemeData.defaultData()),
                  home: Directionality(
                    textDirection: direction,
                    child: Scaffold(
                      body: Center(
                        child: SizedBox(
                          width: axis == Axis.vertical ? 48 : 320,
                          height: axis == Axis.vertical ? 200 : 48,
                          child: SliderGeometryScope(
                            axis: axis,
                            child: Directionality(
                              textDirection: effectiveDirection,
                              child: RotatedBox(
                                quarterTurns: axis == Axis.vertical ? 1 : 0,
                                child: StatefulBuilder(
                                  builder: (context, setState) => range
                                      ? TRangeSlider(
                                          min: 10,
                                          max: 110,
                                          value: values,
                                          divisions: divisions,
                                          variant: capsule
                                              ? TSliderVariant.capsule
                                              : TSliderVariant.normal,
                                          onChanged: (v) =>
                                              setState(() => values = v),
                                        )
                                      : TSlider(
                                          min: 10,
                                          max: 110,
                                          value: value,
                                          divisions: divisions,
                                          variant: capsule
                                              ? TSliderVariant.capsule
                                              : TSliderVariant.normal,
                                          onChanged: (v) =>
                                              setState(() => value = v),
                                        ),
                                ),
                              ),
                            ),
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
              final theme = SliderTheme.of(tester.element(native));
              final rect = range
                  ? theme.rangeTrackShape!.getPreferredRect(
                      parentBox: box,
                      sliderTheme: theme,
                    )
                  : theme.trackShape!.getPreferredRect(
                      parentBox: box,
                      sliderTheme: theme,
                    );
              Offset at(double ratio) => box.localToGlobal(
                Offset(
                  rect.left +
                      (effectiveDirection == TextDirection.rtl
                              ? 1 - ratio
                              : ratio) *
                          rect.width,
                  rect.center.dy,
                ),
              );
              var from = at(range ? .2 : .4);
              await tester.dragFrom(from, at(-.25) - from);
              await tester.pumpAndSettle();
              expect(range ? values.start : value, 10);
              from = at(range ? .8 : 0);
              await tester.dragFrom(from, at(1.25) - from);
              await tester.pumpAndSettle();
              expect(
                range ? values.end : value,
                110,
                reason:
                    '$axis capsule=$capsule divisions=$divisions range=$range $direction',
              );
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    }
  });
}
