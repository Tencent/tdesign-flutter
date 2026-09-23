import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'table_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(tableDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('table sorted ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, tableDemoPageTestSpec, mode);
      final sortable = find.byKey(const ValueKey('table-sortable'));
      await tester.tap(
        find.descendant(of: sortable, matching: find.text('标题')).first,
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<TTable>(sortable).sort?.direction,
        TTableSortDirection.ascending,
      );
      await expectLater(
        find.byKey(const ValueKey('table-demo-page')),
        matchesGoldenFile('goldens/table_sorted_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table horizontally scrolled ${mode.name} golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, tableDemoPageTestSpec, mode);
      final table = find.byKey(const ValueKey('table-horizontal-scroll'));
      final content = find.descendant(
        of: table,
        matching: find.text('横向平铺内容不省略'),
      );
      final before = tester.getTopLeft(content.first).dx;
      await tester.drag(content.first, const Offset(-80, 0));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(content.first).dx, lessThan(before));
      await expectLater(
        find.byKey(const ValueKey('table-demo-page')),
        matchesGoldenFile('goldens/table_scrolled_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
