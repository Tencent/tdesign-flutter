import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/slider/t_slider_geometry.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets(
    'continuous range retains the legacy gap and valid close callbacks',
    (t) async {
      for (final axis in Axis.values) {
        for (final capsule in [false, true]) {
          var width = 320.0;
          var values = const RangeValues(30, 90);
          RangeValues? started, ended;
          late StateSetter resize;
          await t.pumpWidget(
            MaterialApp(
              theme: TThemeBuilder.light(TThemeData.defaultData()),
              home: Scaffold(
                body: Center(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      resize = setState;
                      return SizedBox(
                        width: axis == Axis.horizontal ? width : 48,
                        height: axis == Axis.horizontal ? 48 : width,
                        child: RotatedBox(
                          quarterTurns: axis == Axis.vertical ? 1 : 0,
                          child: TRangeSlider(
                            min: 10,
                            max: 110,
                            value: values,
                            variant: capsule
                                ? TSliderVariant.capsule
                                : TSliderVariant.normal,
                            onChangeStart: (v) => started = v,
                            onChangeEnd: (v) => ended = v,
                            onChanged: (v) {
                              expect(
                                v.start.isFinite && v.end.isFinite,
                                isTrue,
                              );
                              expect(
                                v.start >= 10 &&
                                    v.start < v.end &&
                                    v.end <= 110,
                                isTrue,
                              );
                              setState(() => values = v);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
          await t.pumpAndSettle();
          final f = find.byType(RangeSlider);
          Rect rect() {
            final box = t.renderObject<RenderBox>(f),
                theme = SliderTheme.of(t.element(f));
            return theme.rangeTrackShape!.getPreferredRect(
              parentBox: box,
              sliderTheme: theme,
            );
          }

          Offset at(double ratio) {
            final r = rect(), box = t.renderObject<RenderBox>(f);
            return box.localToGlobal(
              Offset(r.left + r.width * ratio, r.center.dy),
            );
          }

          final gesture = await t.startGesture(at(.2));
          await gesture.moveTo(at(-.2));
          await t.pumpAndSettle();
          for (final extent in [320.0, 48.0, 24.0, 8.0, 1.0, 320.0]) {
            resize(() => width = extent);
            await t.pumpAndSettle();
            final before = values;
            final theme = SliderTheme.of(t.element(f));
            final gap = theme.minThumbSeparation!;
            if (extent == 320) {
              expect(gap, closeTo(8, 1e-9));
            }
            expect(gap, greaterThan(0));
            expect(
              gap,
              lessThanOrEqualTo(
                (before.end - before.start) / 100 * rect().width + 1e-9,
              ),
            );
            await gesture.moveTo(at(1.2));
            await t.pumpAndSettle();
            expect(values.end, 90);
            expect(
              (values.end - values.start) / 100 * rect().width,
              closeTo(gap, 1e-8),
            );
            await gesture.moveTo(at(-.2));
            await t.pumpAndSettle();
            expect(values.start, 10);
          }
          await gesture.up();
          await t.pumpAndSettle();
          expect(started, const RangeValues(30, 90));
          expect(ended, values);
          expect(t.takeException(), isNull);
        }
      }
    },
  );

  testWidgets(
    'discrete overlap and controlled equal input retain existing support',
    (t) async {
      for (final capsule in [false, true]) {
        var values = const RangeValues(20, 80);
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 320,
                  height: 48,
                  child: StatefulBuilder(
                    builder: (context, setState) => TRangeSlider(
                      value: values,
                      max: 100,
                      divisions: 5,
                      variant: capsule
                          ? TSliderVariant.capsule
                          : TSliderVariant.normal,
                      onChanged: (v) => setState(() => values = v),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final f = find.byType(RangeSlider),
            box = t.renderObject<RenderBox>(find.byType(RangeSlider));
        final theme = SliderTheme.of(t.element(f));
        final r = theme.rangeTrackShape!.getPreferredRect(
          parentBox: box,
          sliderTheme: theme,
        );
        Offset at(double ratio) =>
            box.localToGlobal(Offset(r.left + r.width * ratio, r.center.dy));
        final gesture = await t.startGesture(at(.2));
        await gesture.moveTo(at(0));
        await t.pumpAndSettle();
        await gesture.moveTo(at(.8));
        await t.pumpAndSettle();
        await gesture.up();
        await t.pumpAndSettle();
        expect(values, const RangeValues(80, 80));
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 8,
                  height: 48,
                  child: TRangeSlider(
                    value: const RangeValues(.5, .5),
                    variant: capsule
                        ? TSliderVariant.capsule
                        : TSliderVariant.normal,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        expect(
          t.widget<RangeSlider>(find.byType(RangeSlider)).values,
          const RangeValues(.5, .5),
        );
        expect(t.takeException(), isNull);
      }
    },
  );

  testWidgets('collapse before gesture recognition emits no invalid sequence', (
    t,
  ) async {
    for (final range in [false, true]) {
      for (final capsule in [false, true]) {
        var width = 48.0;
        late StateSetter resize;
        var callbacks = 0;
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    resize = setState;
                    final variant = capsule
                        ? TSliderVariant.capsule
                        : TSliderVariant.normal;
                    return GestureDetector(
                      onHorizontalDragUpdate: (_) {},
                      child: SizedBox(
                        width: width,
                        height: 48,
                        child: range
                            ? TRangeSlider(
                                value: const RangeValues(.2, .8),
                                variant: variant,
                                onChanged: (_) => callbacks++,
                                onChangeStart: (_) => callbacks++,
                                onChangeEnd: (_) => callbacks++,
                              )
                            : TSlider(
                                value: .4,
                                variant: variant,
                                onChanged: (_) => callbacks++,
                                onChangeStart: (_) => callbacks++,
                                onChangeEnd: (_) => callbacks++,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final f = range ? find.byType(RangeSlider) : find.byType(Slider);
        final gesture = await t.startGesture(t.getCenter(f));
        resize(() => width = 0);
        await t.pump();
        await gesture.moveBy(const Offset(-40, 0));
        await t.pumpAndSettle();
        await gesture.up();
        await t.pumpAndSettle();
        expect(callbacks, 0);
        expect(t.takeException(), isNull);
      }
    }
  });
  testWidgets('zero slider viewport preserves an ancestor scroll gesture', (
    t,
  ) async {
    for (final enabled in [false, true]) {
      for (final range in [false, true]) {
        var width = 320.0;
        late StateSetter resize;
        final scroll = ScrollController();
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  resize = setState;
                  return SingleChildScrollView(
                    controller: scroll,
                    child: Column(
                      children: [
                        const SizedBox(height: 200),
                        SizedBox(
                          width: width,
                          height: 48,
                          child: range
                              ? TRangeSlider(
                                  value: const RangeValues(.2, .8),
                                  onChanged: enabled ? (_) {} : null,
                                )
                              : TSlider(
                                  value: .4,
                                  onChanged: enabled ? (_) {} : null,
                                ),
                        ),
                        const SizedBox(height: 2000),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final f = range ? find.byType(RangeSlider) : find.byType(Slider);
        final gesture = await t.startGesture(t.getCenter(f));
        await gesture.moveBy(const Offset(0, -80));
        await t.pump();
        await gesture.moveBy(const Offset(0, -40));
        await t.pump();
        expect(scroll.offset, greaterThan(0));
        resize(() => width = 0);
        await t.pumpAndSettle();
        final before = scroll.offset;
        await gesture.moveBy(const Offset(0, -80));
        await t.pump();
        expect(
          scroll.offset,
          greaterThan(before + 20),
          reason: 'enabled=$enabled range=$range',
        );
        await gesture.up();
        await t.pumpAndSettle();
        await t.pumpWidget(const SizedBox.shrink());
        await t.pumpAndSettle();
        scroll.dispose();
        expect(t.takeException(), isNull);
      }
    }
  });
  testWidgets('large normal track paint stays inside declared bounds', (
    t,
  ) async {
    const boundaryKey = ValueKey('paint-extent');
    for (final range in [false, true]) {
      for (final end in [0.0, .5, 1.0]) {
        await t.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.dark(TThemeData.defaultData()).mergeExtension(
              const TSliderThemeData(
                trackHeight: 192,
                activeTrackColor: Color(0xFFFF0000),
                inactiveTrackColor: Color(0xFFFF0000),
              ),
            ),
            home: Scaffold(
              body: Center(
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: SizedBox(
                    width: 260,
                    height: 100,
                    child: Center(
                      child: SliderGeometryScope(
                        axis: Axis.vertical,
                        child: SizedBox(
                          width: 221,
                          height: 48,
                          child: range
                              ? TRangeSlider(
                                  value: const RangeValues(0, 1),
                                  onChanged: (_) {},
                                )
                              : TSlider(value: end, onChanged: (_) {}),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final native = range ? find.byType(RangeSlider) : find.byType(Slider);
        final offset =
            t.getTopLeft(native) - t.getTopLeft(find.byKey(boundaryKey));
        final boundary = t.renderObject<RenderRepaintBoundary>(
          find.byKey(boundaryKey),
        );
        final bounds = (await t.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = (await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!.buffer.asUint8List();
          final xs = <int>[], ys = <int>[];
          for (var y = 0; y < image.height; y++) {
            for (var x = 0; x < image.width; x++) {
              final i = (y * image.width + x) * 4;
              if (bytes[i] > 220 && bytes[i + 1] < 50 && bytes[i + 2] < 50) {
                xs.add(x);
                ys.add(y);
              }
            }
          }
          xs.sort();
          ys.sort();
          image.dispose();
          return Rect.fromLTRB(
            xs.first / 2,
            ys.first / 2,
            (xs.last + 1) / 2,
            (ys.last + 1) / 2,
          );
        }))!;
        expect(bounds.left - offset.dx, greaterThanOrEqualTo(10));
        expect(bounds.right - offset.dx, lessThanOrEqualTo(211));
        if (!range && end == .5) {
          // At the midpoint neither track cap is hidden by the thumb.
          expect(bounds.left - offset.dx, closeTo(10.5, 1));
          expect(bounds.right - offset.dx, closeTo(210.5, 1));
        }
        expect(bounds.height, lessThanOrEqualTo(48));
        expect(t.takeException(), isNull);
      }
    }
  });
  test('declared track length survives thickness and cross constraints', () {
    for (final capsule in [false, true]) {
      for (final height in [0.0, 4.0, 24.0, 48.0, 192.0, 240.0]) {
        for (final inset in [0.0, 10.5, 16.0, 64.0]) {
          for (final length in [
            0.0,
            1.0,
            8.0,
            24.0,
            40.0,
            46.0,
            200.0,
            320.0,
          ]) {
            for (final cross in [0.0, 8.0, 24.0, 48.0, double.infinity]) {
              final geometry = SliderGeometry(
                capsule: capsule,
                trackHeight: height,
                horizontalInset: inset,
              );
              final metrics = geometry.forTrackLength(
                length,
                crossExtent: cross,
              );
              final rect = metrics.visualRect(
                Size(metrics.width, 48),
                Offset.zero,
              );
              expect(
                rect.width,
                closeTo(length, 1e-9),
                reason: '$capsule $height $inset $length $cross',
              );
              expect(metrics.trackHeight, lessThanOrEqualTo(cross));
              expect(metrics.thumbSize.height, lessThanOrEqualTo(cross));
              expect(metrics.width, greaterThanOrEqualTo(0));
              expect(
                metrics.thumbInset * 2,
                lessThanOrEqualTo(metrics.width + 1e-9),
              );
            }
          }
        }
      }
    }
  });

  for (final axis in Axis.values) {
    for (final capsule in [false, true]) {
      for (final discrete in [false, true]) {
        for (final range in [false, true]) {
          for (final direction in TextDirection.values) {
            testWidgets(
              'continuous resize $axis $capsule $discrete $range $direction',
              (t) async {
                var extent = 320.0;
                var value = 50.0;
                var values = const RangeValues(30, 90);
                final outputs = <Object>[];
                var starts = 0, ends = 0;
                late StateSetter resize;
                final effectiveDirection = axis == Axis.vertical
                    ? TextDirection.ltr
                    : direction;
                await t.pumpWidget(
                  MaterialApp(
                    theme: TThemeBuilder.light(TThemeData.defaultData()),
                    home: Scaffold(
                      body: Center(
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            resize = setState;
                            final variant = capsule
                                ? TSliderVariant.capsule
                                : TSliderVariant.normal;
                            final child = range
                                ? TRangeSlider(
                                    min: 10,
                                    max: 110,
                                    value: values,
                                    divisions: discrete ? 5 : null,
                                    variant: variant,
                                    onChangeStart: (_) => starts++,
                                    onChangeEnd: (v) {
                                      expect(
                                        v.start.isFinite && v.end.isFinite,
                                        isTrue,
                                      );
                                      expect(
                                        v.start >= 10 &&
                                            v.end <= 110 &&
                                            v.start <= v.end,
                                        isTrue,
                                      );
                                      ends++;
                                    },
                                    onChanged: (v) {
                                      expect(
                                        v.start.isFinite && v.end.isFinite,
                                        isTrue,
                                      );
                                      expect(
                                        v.start >= 10 &&
                                            v.end <= 110 &&
                                            v.start <= v.end,
                                        isTrue,
                                      );
                                      outputs.add(v);
                                      setState(() => values = v);
                                    },
                                  )
                                : TSlider(
                                    min: 10,
                                    max: 110,
                                    value: value,
                                    divisions: discrete ? 5 : null,
                                    variant: variant,
                                    onChangeStart: (_) => starts++,
                                    onChangeEnd: (v) {
                                      expect(
                                        v.isFinite && v >= 10 && v <= 110,
                                        isTrue,
                                      );
                                      ends++;
                                    },
                                    onChanged: (v) {
                                      expect(
                                        v.isFinite && v >= 10 && v <= 110,
                                        isTrue,
                                      );
                                      outputs.add(v);
                                      setState(() => value = v);
                                    },
                                  );
                            return SizedBox(
                              width: axis == Axis.vertical ? 48 : extent,
                              height: axis == Axis.vertical ? extent : 48,
                              child: SliderGeometryScope(
                                axis: axis,
                                child: Directionality(
                                  textDirection: effectiveDirection,
                                  child: RotatedBox(
                                    quarterTurns: axis == Axis.vertical ? 1 : 0,
                                    child: child,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
                await t.pumpAndSettle();
                final f = range
                    ? find.byType(RangeSlider)
                    : find.byType(Slider);
                Offset at(double ratio) {
                  final box = t.renderObject<RenderBox>(f),
                      theme = SliderTheme.of(t.element(f));
                  final rect = range
                      ? theme.rangeTrackShape!.getPreferredRect(
                          parentBox: box,
                          sliderTheme: theme,
                        )
                      : theme.trackShape!.getPreferredRect(
                          parentBox: box,
                          sliderTheme: theme,
                        );
                  return box.localToGlobal(
                    Offset(
                      rect.left +
                          (effectiveDirection == TextDirection.rtl
                                  ? 1 - ratio
                                  : ratio) *
                              rect.width,
                      rect.center.dy,
                    ),
                  );
                }

                final gesture = await t.startGesture(at(range ? .2 : .4));
                await gesture.moveTo(at(-.3));
                await t.pumpAndSettle();
                expect(starts, 1);
                for (final width in [48.0, 24.0, 8.0, 1.0, 24.0, 320.0]) {
                  final count = outputs.length;
                  resize(() => extent = width);
                  await t.pumpAndSettle();
                  expect(
                    outputs.length,
                    count,
                    reason: 'layout cannot emit value changes',
                  );
                  expect(starts, 1);
                  expect(ends, 0);
                  final box = t.renderObject<RenderBox>(f),
                      theme = SliderTheme.of(t.element(f));
                  final preferred = range
                      ? theme.rangeThumbShape!.getPreferredSize(true, discrete)
                      : theme.thumbShape!.getPreferredSize(true, discrete);
                  final expected = SliderGeometry(
                    capsule: capsule,
                    trackHeight: capsule ? 24 : 4,
                    horizontalInset: axis == Axis.vertical ? 10.5 : 16,
                  ).forSize(box.size);
                  expect(preferred, expected.thumbSize);
                  if (!capsule && discrete) {
                    final tickSize = range
                        ? theme.rangeTickMarkShape!.getPreferredSize(
                            sliderTheme: theme,
                            isEnabled: true,
                          )
                        : theme.tickMarkShape!.getPreferredSize(
                            sliderTheme: theme,
                            isEnabled: true,
                          );
                    expect(tickSize.width, closeTo(preferred.width * .3, 1e-9));
                  }

                  expect(
                    theme.minThumbSeparation,
                    range
                        ? expected.rangeSeparation(
                            (values.end - values.start) / 100,
                          )
                        : SliderGeometry.minimumRangeSeparation,
                  );
                  await gesture.moveTo(at(-.3));
                  await t.pumpAndSettle();
                  expect(range ? values.start : value, 10);
                  await gesture.moveTo(at(.4));
                  await t.pumpAndSettle();
                  expect(range ? values.start : value, closeTo(50, 1e-7));
                }
                resize(() => extent = 0);
                await t.pumpAndSettle();
                await t.idle();
                await t.pumpAndSettle();
                expect(ends, 1, reason: 'zero extent cancels exactly once');
                final count = outputs.length;
                await gesture.moveBy(const Offset(40, 0));
                await t.pumpAndSettle();
                expect(outputs.length, count);
                await gesture.up();
                await t.pumpAndSettle();
                expect(ends, 1);
                resize(() => extent = 48);
                await t.pumpAndSettle();
                final again = await t.startGesture(at(.4));
                await again.moveTo(at(-.5));
                await t.pumpAndSettle();
                expect(range ? values.start : value, 10);
                await again.moveTo(at(.4));
                await t.pumpAndSettle();
                expect(range ? values.start : value, closeTo(50, 1e-7));
                await again.up();
                await t.pumpAndSettle();
                expect(starts, 2);
                expect(ends, 2);
                expect(t.takeException(), isNull);
              },
            );
          }
        }
      }
    }
  }

  testWidgets('pointer mapping preserves native keyboard input', (t) async {
    var value = .4;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await t.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => Focus(
              autofocus: true,
              focusNode: focus,
              child: TSlider(
                value: value,
                divisions: 5,
                onChanged: (v) => setState(() => value = v),
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    final nativeFocus = t
        .widgetList<Focus>(
          find.descendant(
            of: find.byType(Slider),
            matching: find.byType(Focus),
          ),
        )
        .firstWhere((widget) => widget.focusNode != null);
    nativeFocus.focusNode!.requestFocus();
    await t.pumpAndSettle();
    await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await t.pumpAndSettle();
    expect(value, closeTo(.6, 1e-9));
    final f = find.byType(Slider);
    Offset at(double ratio) {
      final box = t.renderObject<RenderBox>(f);
      final theme = SliderTheme.of(t.element(f));
      final rect = theme.trackShape!.getPreferredRect(
        parentBox: box,
        sliderTheme: theme,
      );
      return box.localToGlobal(
        Offset(rect.left + ratio * rect.width, rect.center.dy),
      );
    }

    final gesture = await t.startGesture(at(.6));
    await gesture.moveTo(at(.4));
    await t.pumpAndSettle();
    expect(value, closeTo(.4, 1e-9));
    await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await t.pumpAndSettle();
    expect(value, closeTo(.6, 1e-9));
    await gesture.moveTo(at(.2));
    await t.pumpAndSettle();
    expect(value, closeTo(.2, 1e-9));
    await gesture.up();
    await t.pumpAndSettle();
  });
}
