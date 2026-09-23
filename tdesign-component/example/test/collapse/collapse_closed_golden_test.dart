import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'collapse_demo_test.dart' show collapseDemoSpec;

void main() {
  registerDemoGoldenTests(collapseDemoSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('collapse basic closed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, collapseDemoSpec, mode);
      final collapse = find.byType(TCollapse<String>).first;
      await tester.tap(
        find.descendant(of: collapse, matching: find.text('折叠面板标题')),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<TCollapse<String>>(collapse).value, isEmpty);
      await expectLater(
        find.byKey(const ValueKey('collapse-demo-page')),
        matchesGoldenFile('goldens/collapse_basic_closed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
