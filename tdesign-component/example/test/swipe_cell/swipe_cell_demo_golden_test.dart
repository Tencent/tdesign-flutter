import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'swipe_cell_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(swipeCellDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final scenario in swipeCellDemoScenarios) {
      testWidgets('swipe cell ${scenario.id} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          swipeCellDemoPageTestSpec,
          mode,
        );
        await openSwipeCellScenario(tester, scenario);
        await expectLater(
          find.byKey(const ValueKey('swipe_cell-demo-page')),
          matchesGoldenFile(
            'goldens/swipe_cell_${scenario.id}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
