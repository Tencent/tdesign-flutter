import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'tabs_page_test_spec.dart';

void main() {
  registerDemoGoldenTests(tabsDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Tabs content tab selected ${mode.name} golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, tabsDemoPageTestSpec, mode);
      await tester.ensureVisible(find.text('选项四'));
      await tester.tap(find.text('选项四'));
      await tester.pumpAndSettle();

      expect(find.text('内容区'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('tabs-demo-page')),
        matchesGoldenFile('goldens/tabs_content_selected_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
