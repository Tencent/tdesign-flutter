import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'slider_demo_test_spec.dart';
import 'slider_golden_matrix.dart';

void main() {
  setUpAll(() => loadDemoGoldenFonts(sliderDemoPageTestSpec));
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('slider boundaries matrix ${mode.name}', (tester) async {
      final matrix = await captureSliderBoundaryMatrix(tester, mode);
      addTearDown(matrix.image.dispose);
      if (const bool.fromEnvironment('SLIDER_REVIEW_CAPTURE')) {
        await tester.runAsync(
          () => matrix.saveEvidence('slider_boundaries_${mode.name}'),
        );
      }
      await expectLater(
        matrix.image,
        matchesGoldenFile('goldens/slider_boundaries_${mode.name}.png'),
      );
    }, tags: 'golden');
  }
}
