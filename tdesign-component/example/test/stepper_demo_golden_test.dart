import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'stepper_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(stepperDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('stepper incremented ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, stepperDemoPageTestSpec, mode);
      final stepper = find.byKey(const ValueKey('stepper-base'));
      await tester.tap(
        find.descendant(of: stepper, matching: find.bySemanticsLabel('增加')),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<TStepper>(stepper).value, 4);
      await expectLater(
        find.byKey(const ValueKey('stepper-demo-page')),
        matchesGoldenFile('goldens/stepper_incremented_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
