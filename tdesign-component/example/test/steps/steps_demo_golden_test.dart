import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'steps_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(stepsDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('steps selected ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, stepsDemoPageTestSpec, mode);
      final selectable = find.byType(TSteps).at(10);
      await tester.tap(
        find.descendant(of: selectable, matching: find.text('已完成步骤')).first,
      );
      await tester.pumpAndSettle();

      expect(tester.widget<TSteps>(find.byType(TSteps).at(10)).value, 0);
      await expectLater(
        find.byKey(const ValueKey('steps-demo-page')),
        matchesGoldenFile('goldens/steps_selected_${mode.name}.png'),
      );
      await tester.pump(const Duration(seconds: 3));
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
