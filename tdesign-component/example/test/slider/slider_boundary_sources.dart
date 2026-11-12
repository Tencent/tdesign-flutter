import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'slider_constraints_fixture.dart';
import 'slider_demo_test_spec.dart';

// Test-only sources. Public Demo widgets and component implementations stay
// unchanged. The first two cases retain the original 320px content width.
Future<void> pumpSliderGeometryBoundarySources(
  WidgetTester tester,
  ThemeMode mode,
) async {
  tester.view.physicalSize = const Size(375, 260);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  Widget item(String title, Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Column(
      children: [
        Text(title, style: const TextStyle(fontFamily: 'Roboto', fontSize: 12)),
        SizedBox(width: 320, height: 92, child: child),
      ],
    ),
  );
  final light = withDemoGoldenFonts(
    TThemeBuilder.light(TThemeData.defaultData()),
    sliderDemoPageTestSpec,
  );
  final dark = withDemoGoldenFonts(
    TThemeBuilder.dark(TThemeData.defaultData()),
    sliderDemoPageTestSpec,
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: light,
      darkTheme: dark,
      themeMode: mode,
      home: RepaintBoundary(
        key: const ValueKey('geometry-boundary-source'),
        child: Scaffold(
          body: Column(
            children: [
              item(
                'normal: trackHeight=24, value=0.02',
                Theme(
                  data: (mode == ThemeMode.dark ? dark : light).mergeExtension(
                    const TSliderThemeData(trackHeight: 24),
                  ),
                  child: TSlider(
                    key: const ValueKey('boundary-near-edge'),
                    value: .02,
                    showThumbValue: true,
                    onChanged: (_) {},
                  ),
                ),
              ),
              item(
                'narrow discrete range: width=48',
                Center(
                  child: SizedBox(
                    width: 48,
                    child: TRangeSlider(
                      key: const ValueKey('boundary-discrete-48'),
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
}

Future<void> pumpSliderConstraintBoundarySource(
  WidgetTester tester,
  ThemeMode mode,
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
        key: ValueKey('constraint-boundary-source'),
        child: Scaffold(body: SliderConstraintsFixture()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  // Reuse the actual sustained-drag/resize regression, then sample only the
  // visual boundaries. Callback and lifecycle states keep their own tests.
  await exerciseSliderConstraintsFixture(tester, 100);
}
