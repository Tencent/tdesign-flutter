import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'progress_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(progressDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('progress completed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, progressDemoPageTestSpec, mode);
      final button = find.byKey(const ValueKey('progress-button'));
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pump(const Duration(milliseconds: 2400));
      await tester.pump();
      expect(
        find.descendant(of: button, matching: find.text('80%')),
        findsOneWidget,
      );
      await expectLater(
        find.byKey(const ValueKey('progress-demo-page')),
        matchesGoldenFile('goldens/progress_completed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
