import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/slider/slider_capsule_example.dart';
import 'package:tdesign_flutter_example/page/slider/slider_disabled_example.dart';

import '../demo_page_test_utils.dart';
import '../support/review_golden.dart';
import 'slider_constraints_fixture.dart';
import 'slider_demo_test_spec.dart';
import 'slider_endpoint_test_utils.dart';

void main() {
  for (final endpoint in [0, 100]) {
    testWidgets('constraint fixture real gestures endpoint $endpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: withDemoGoldenFonts(
            TThemeBuilder.light(TThemeData.defaultData()),
            sliderDemoPageTestSpec,
          ),
          home: const Scaffold(body: SliderConstraintsFixture()),
        ),
      );
      await tester.pumpAndSettle();
      await exerciseSliderConstraintsFixture(tester, endpoint);
      if (const bool.fromEnvironment('BOUNDARY_REVIEW_CAPTURE')) {
        const label = String.fromEnvironment('BOUNDARY_CAPTURE_LABEL');
        await captureGoldenEvidence(
          tester,
          find.byType(Scaffold),
          'boundary_runtime_${label}_$endpoint.png',
        );
      }

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }, tags: 'demo');
  }

  registerDemoStructureTests(sliderDemoPageTestSpec);

  testWidgets('Slider Demo keeps official scenarios in order', (tester) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    final compactSurface = find.byWidgetPredicate(
      (widget) =>
          widget is ColoredBox &&
          widget.color == TThemeData.defaultData().bgColorContainer,
    );
    const keys = [
      'single',
      'range',
      'labeled',
      'labeled-range',
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
    expect(find.byType(TSlider), findsNWidgets(8));
    expect(find.byType(TRangeSlider), findsNWidgets(10));
    expect(
      find.descendant(
        of: find.byType(SliderCapsuleExample),
        matching: find.byType(ColoredBox),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(SliderDisabledExample),
        matching: find.byType(ColoredBox),
      ),
      findsNothing,
    );
    expect(
      find.ancestor(
        of: find.byType(SliderCapsuleExample),
        matching: compactSurface,
      ),
      findsNWidgets(5),
    );
    expect(
      find.ancestor(
        of: find.byType(SliderDisabledExample),
        matching: compactSurface,
      ),
      findsNWidgets(3),
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('each official scenario keeps its key parameters', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.light);
    final single = tester.widget<TSlider>(
      find.byKey(const ValueKey('slider-single')),
    );
    expect(single.value, 25);
    expect(single.onChanged, isNotNull);

    final range = tester.widget<TRangeSlider>(
      find.byKey(const ValueKey('slider-range')),
    );
    expect(range.value, const RangeValues(40, 60));
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

    final capsule = tester.widget<TSlider>(
      find.byKey(const ValueKey('slider-capsule')),
    );
    expect(capsule.value, 25);

    for (final key in [
      'slider-labeled-range',
      'slider-disabled-labeled-range',
      'slider-capsule-labeled-range',
    ]) {
      final row = find
          .ancestor(of: find.byKey(ValueKey(key)), matching: find.byType(Row))
          .first;
      final endpointLabels = find.descendant(
        of: row,
        matching: find.byType(TText),
      );
      expect(
        tester.widgetList<TText>(endpointLabels).map((text) => text.data),
        orderedEquals(['0', '100']),
        reason: key,
      );
      expect(tester.getTopLeft(endpointLabels.first).dx, 16, reason: key);
      expect(tester.getTopRight(endpointLabels.last).dx, 359, reason: key);
    }

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
      greaterThan(25),
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
    final scaleLabelFinder = find.descendant(
      of: find.byKey(const ValueKey('slider-vertical-scale-labels')),
      matching: find.byType(TText),
    );
    final scaleLabels = tester
        .widgetList<TText>(scaleLabelFinder)
        .map((text) => text.data)
        .toList();
    expect(scaleLabels, orderedEquals(['0', '20', '40', '60', '80', '100']));
    final verticalSectionTitle = find.text('单游标垂直滑块');
    final surfaceColor = tester
        .element(verticalSectionTitle)
        .tTheme
        .bgColorContainer;
    final verticalSectionSurface = find.ancestor(
      of: find.byKey(const ValueKey('slider-vertical')),
      matching: find.byWidgetPredicate(
        (widget) => widget is ColoredBox && widget.color == surfaceColor,
      ),
    );
    expect(verticalSectionSurface, findsOneWidget);
    // 区块标题由页面统一渲染，位于示例内容（surface）上方。
    expect(
      tester.getBottomLeft(verticalSectionTitle).dy,
      lessThanOrEqualTo(tester.getTopLeft(verticalSectionSurface).dy),
    );
    final verticalTrackRect = tester.getRect(
      find.ancestor(
        of: find.byKey(const ValueKey('slider-vertical-scale-range')),
        matching: find.byType(RotatedBox),
      ),
    );
    // 普通轨道的刻度覆盖完整垂直行程，端点不随 divisions 内缩。
    const labelInset = 10.5;
    expect(
      tester.getCenter(scaleLabelFinder.at(0)).dy,
      closeTo(verticalTrackRect.top + labelInset, 0.01),
    );
    expect(
      tester.getCenter(scaleLabelFinder.at(5)).dy,
      closeTo(verticalTrackRect.bottom - labelInset, 0.01),
    );
    // 胶囊数值与 thumb 中心同高，不再上下错开。
    final capsuleTrackRect = tester.getRect(
      find.ancestor(
        of: find.byKey(const ValueKey('slider-vertical-capsule')),
        matching: find.byType(RotatedBox),
      ),
    );
    const capsuleInset = 23.5;
    expect(
      tester
          .getCenter(
            find.byKey(const ValueKey('slider-vertical-capsule-label')),
          )
          .dy,
      closeTo(
        capsuleTrackRect.top +
            capsuleInset +
            0.35 * (capsuleTrackRect.height - capsuleInset * 2),
        0.01,
      ),
    );
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
      final widget = tester.widget(find.byKey(ValueKey(key)));
      final variant = switch (widget) {
        TSlider() => widget.variant,
        TRangeSlider() => widget.variant,
        _ => throw StateError('Unexpected slider type for $key'),
      };
      expect(variant, TSliderVariant.capsule, reason: key);
    }
    await disposeDemoPage(tester);
  }, tags: 'demo');
  for (final end in [0, 100]) {
    testWidgets(
      'endpoint $end keeps vertical values and scale centers aligned',
      (tester) async {
        await pumpFullDemoPage(tester, sliderDemoPageTestSpec, ThemeMode.dark);
        await moveSliderDemoToEndpoints(tester, end);
        for (final id in ['vertical', 'vertical-capsule']) {
          final native = find.descendant(
            of: find.byKey(ValueKey('slider-$id')),
            matching: find.byType(Slider),
          );
          final box = tester.renderObject<RenderBox>(native);
          // The visible track is 200px; 10.5px at each end belongs to the
          // complete thumb hit area rather than being deducted from the track.
          expect(box.size.width, 221, reason: id);
          final theme = SliderTheme.of(tester.element(native));
          final travel = theme.trackShape!.getPreferredRect(
            parentBox: box,
            sliderTheme: theme,
          );
          expect(travel.width, id.contains('capsule') ? 174 : 200, reason: id);
          final start = id.contains('capsule') ? 23.5 : 10.5;
          final expected = box.localToGlobal(
            Offset(
              start + end / 100 * (box.size.width - start * 2),
              box.size.height / 2,
            ),
          );
          expect(
            tester.getCenter(find.byKey(ValueKey('slider-$id-label'))).dy,
            closeTo(expected.dy, 0.01),
          );
        }
        for (final id in [
          'vertical-scale-range',
          'vertical-capsule-scale-range',
        ]) {
          final native = find.descendant(
            of: find.byKey(ValueKey('slider-$id')),
            matching: find.byType(RangeSlider),
          );
          final box = tester.renderObject<RenderBox>(native);
          final start = id.contains('capsule') ? 23.5 : 10.5;
          final labelKey =
              'slider-${id.replaceFirst('-scale-range', '-scale-labels')}';
          final root = find.byKey(ValueKey(labelKey));
          for (var index = 0; index <= 5; index++) {
            final expected = box.localToGlobal(
              Offset(
                start + index / 5 * (box.size.width - start * 2),
                box.size.height / 2,
              ),
            );
            expect(
              tester
                  .getCenter(
                    find.descendant(
                      of: root,
                      matching: find.text('${index * 20}'),
                    ),
                  )
                  .dy,
              closeTo(expected.dy, 0.01),
            );
          }
        }
        await disposeDemoPage(tester);
      },
      tags: 'demo',
    );
  }
  for (final height in [8.0, 24.0]) {
    for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
      for (final end in [0, 100]) {
        testWidgets(
          'custom height $height $direction endpoint $end stays aligned',
          (tester) async {
            await pumpFullDemoPage(
              tester,
              sliderGeometryDemoSpec(height, direction),
              ThemeMode.dark,
            );
            await moveSliderDemoToEndpoints(tester, end);
            for (final id in ['vertical', 'vertical-capsule']) {
              final native = find.descendant(
                of: find.byKey(ValueKey('slider-$id')),
                matching: find.byType(Slider),
              );
              expect(
                Directionality.of(tester.element(native)),
                TextDirection.ltr,
              );
              final box = tester.renderObject<RenderBox>(native);
              final start = id.contains('capsule') ? 23.5 : 10.5;
              final expected = box.localToGlobal(
                Offset(
                  start + end / 100 * (box.size.width - 2 * start),
                  box.size.height / 2,
                ),
              );
              expect(
                tester.getCenter(find.byKey(ValueKey('slider-$id-label'))).dy,
                closeTo(expected.dy, .01),
              );
            }
            for (final id in [
              'vertical-scale-range',
              'vertical-capsule-scale-range',
            ]) {
              final native = find.descendant(
                of: find.byKey(ValueKey('slider-$id')),
                matching: find.byType(RangeSlider),
              );
              final box = tester.renderObject<RenderBox>(native);
              final start = id.contains('capsule') ? 23.5 : 10.5;
              final root = find.byKey(
                ValueKey(
                  'slider-${id.replaceFirst('-scale-range', '-scale-labels')}',
                ),
              );
              for (var index = 0; index <= 5; index++) {
                final expected = box.localToGlobal(
                  Offset(
                    start + index / 5 * (box.size.width - 2 * start),
                    box.size.height / 2,
                  ),
                );
                expect(
                  tester
                      .getCenter(
                        find.descendant(
                          of: root,
                          matching: find.text('${index * 20}'),
                        ),
                      )
                      .dy,
                  closeTo(expected.dy, .01),
                );
              }
            }
            await disposeDemoPage(tester);
          },
          tags: 'demo',
        );
      }
    }
  }
}
