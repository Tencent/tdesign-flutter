import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'tree_select_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(treeSelectDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('tree select changed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, treeSelectDemoPageTestSpec, mode);
      final tree = find.byKey(const ValueKey('tree-select-single'));
      await tester.tap(find.descendant(of: tree, matching: find.text('云浮市')));
      await tester.pumpAndSettle();
      expect(tester.widget<TTreeSelect>(tree).value.single, [
        'guangdong',
        'yunfu',
      ]);
      await expectLater(
        find.byKey(const ValueKey('tree_select-demo-page')),
        matchesGoldenFile('goldens/tree_select_changed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
