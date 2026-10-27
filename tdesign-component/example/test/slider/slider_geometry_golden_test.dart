import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import '../support/review_golden.dart';
import 'slider_constraints_fixture.dart';
import 'slider_demo_test_spec.dart';
import 'slider_endpoint_test_utils.dart';

void main() {
  setUpAll(() => loadDemoGoldenFonts(sliderDemoPageTestSpec));
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final end in [0, 100]) {
      testWidgets('constraints after real gestures ${mode.name} $end', (
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
            darkTheme: withDemoGoldenFonts(
              TThemeBuilder.dark(TThemeData.defaultData()),
              sliderDemoPageTestSpec,
            ),
            themeMode: mode,
            home: const RepaintBoundary(
              key: ValueKey('constraints-matrix'),
              child: Scaffold(body: SliderConstraintsFixture()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await exerciseSliderConstraintsFixture(tester, end);
        if (const bool.fromEnvironment('SLIDER_REVIEW_CAPTURE')) {
          await captureGoldenEvidence(
            tester,
            find.byKey(const ValueKey('constraints-matrix')),
            'goldens/slider_constraints_${end}_${mode.name}.png',
          );
        }
        await expectLater(
          find.byKey(const ValueKey('constraints-matrix')),
          matchesGoldenFile(
            'goldens/slider_constraints_${end}_${mode.name}.png',
          ),
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }, tags: 'golden');
    }
  }
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final height in [8.0, 24.0]) {
      for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
        for (final end in [0, 100]) {
          testWidgets(
            'slider geometry $height ${direction.name} $end ${mode.name}',
            (tester) async {
              await pumpFullDemoPage(
                tester,
                sliderGeometryDemoSpec(height, direction),
                mode,
              );
              await moveSliderDemoToEndpoints(tester, end);
              if (const bool.fromEnvironment('SLIDER_REVIEW_CAPTURE')) {
                await captureGoldenEvidence(
                  tester,
                  find.byKey(const ValueKey('slider-demo-page')),
                  'goldens/slider_geometry_${height.toInt()}_${direction.name}_${end}_${mode.name}.png',
                );
              }
              await expectLater(
                find.byKey(const ValueKey('slider-demo-page')),
                matchesGoldenFile(
                  'goldens/slider_geometry_${height.toInt()}_${direction.name}_${end}_${mode.name}.png',
                ),
              );
              await disposeDemoPage(tester);
            },
            tags: 'golden',
          );
        }
      }
    }
    testWidgets('slider public geometry matrix ${mode.name}', (tester) async {
      tester.view.physicalSize = const Size(375, 1040);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Widget item(String title, Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 12),
            ),
            SizedBox(width: 320, height: 92, child: child),
          ],
        ),
      );
      Widget normal(double value) => Theme(
        data: withDemoGoldenFonts(
          mode == ThemeMode.light
              ? TThemeBuilder.light(TThemeData.defaultData())
              : TThemeBuilder.dark(TThemeData.defaultData()),
          sliderDemoPageTestSpec,
        ).mergeExtension(const TSliderThemeData(trackHeight: 24)),
        child: TSlider(value: value, onChanged: (_) {}, showThumbValue: true),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: withDemoGoldenFonts(
            TThemeBuilder.light(TThemeData.defaultData()),
            sliderDemoPageTestSpec,
          ),
          darkTheme: withDemoGoldenFonts(
            TThemeBuilder.dark(TThemeData.defaultData()),
            sliderDemoPageTestSpec,
          ),
          themeMode: mode,
          home: RepaintBoundary(
            key: const ValueKey('slider-geometry-matrix'),
            child: Scaffold(
              body: Column(
                children: [
                  item('normal: trackHeight=24, value=0', normal(0)),
                  item('normal: trackHeight=24, value=0.02', normal(.02)),
                  item('normal: trackHeight=24, value=1', normal(1)),
                  item(
                    'capsule: spacer3=16, range=0..1',
                    Builder(
                      builder: (context) => Theme(
                        data: Theme.of(context).mergeExtension(
                          context.tTheme.copyWith(
                            spacerMap: const {'spacer3': 16},
                          ),
                        ),
                        child: TRangeSlider(
                          value: const RangeValues(0, 1),
                          variant: TSliderVariant.capsule,
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                  item(
                    'discrete: input 23 -> effective 20',
                    TSlider(
                      value: 23,
                      min: 0,
                      max: 100,
                      divisions: 5,
                      variant: TSliderVariant.capsule,
                      showThumbValue: true,
                      showScaleValue: true,
                      onChanged: (_) {},
                    ),
                  ),
                  item(
                    'discrete range: input 23..77 -> effective 20..80',
                    TRangeSlider(
                      value: const RangeValues(23, 77),
                      min: 0,
                      max: 100,
                      divisions: 5,
                      variant: TSliderVariant.capsule,
                      showThumbValue: true,
                      onChanged: (_) {},
                    ),
                  ),
                  item(
                    'narrow capsule: width=48',
                    Center(
                      child: SizedBox(
                        width: 48,
                        child: TSlider(
                          value: 0,
                          variant: TSliderVariant.capsule,
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                  item(
                    'narrow discrete range: width=48',
                    Center(
                      child: SizedBox(
                        width: 48,
                        child: TRangeSlider(
                          value: const RangeValues(0, 1),
                          divisions: 5,
                          variant: TSliderVariant.capsule,
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('SLIDER_REVIEW_CAPTURE')) {
        await captureGoldenEvidence(
          tester,
          find.byKey(const ValueKey('slider-geometry-matrix')),
          'goldens/slider_geometry_matrix_${mode.name}.png',
        );
      }
      await expectLater(
        find.byKey(const ValueKey('slider-geometry-matrix')),
        matchesGoldenFile('goldens/slider_geometry_matrix_${mode.name}.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }, tags: 'golden');
  }
}
