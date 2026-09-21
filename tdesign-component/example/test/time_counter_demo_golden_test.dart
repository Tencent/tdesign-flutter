import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'time_counter_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(timeCounterDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('time counter advanced ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, timeCounterDemoPageTestSpec, mode);
      await tester.pump(const Duration(seconds: 1));
      final first = find.byType(TTimeCounter).first;
      expect(
        find.descendant(of: first, matching: find.text('35')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: first, matching: find.text('59')),
        findsOneWidget,
      );
      await expectLater(
        find.byKey(const ValueKey('time_counter-demo-page')),
        matchesGoldenFile('goldens/time_counter_advanced_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
