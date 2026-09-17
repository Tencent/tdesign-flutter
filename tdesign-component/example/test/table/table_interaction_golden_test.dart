import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'table_demo_test_spec.dart';

void main() {
  setUpAll(() => loadDemoGoldenFonts(tableDemoPageTestSpec));

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('table sort states ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, tableDemoPageTestSpec, mode);
      final sortable = find.byKey(const ValueKey('table-sortable'));
      final sortableHeader = find.descendant(
        of: sortable,
        matching: find.text('标题'),
      );

      await tester.tap(sortableHeader.first);
      await tester.pump();
      var table = tester.widget<TTable>(sortable);
      expect(table.sort?.direction, TTableSortDirection.ascending);
      await expectLater(
        sortable,
        matchesGoldenFile('goldens/table_sort_ascending_${mode.name}.png'),
      );

      await tester.tap(sortableHeader.first);
      await tester.pump();
      table = tester.widget<TTable>(sortable);
      expect(table.sort?.direction, TTableSortDirection.descending);
      await expectLater(
        sortable,
        matchesGoldenFile('goldens/table_sort_descending_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table horizontal scroll ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, tableDemoPageTestSpec, mode);
      final horizontal = find.byKey(const ValueKey('table-horizontal-scroll'));
      final longText = find.descendant(
        of: horizontal,
        matching: find.text('横向平铺内容不省略'),
      );
      final before = tester.getTopLeft(longText.first).dx;
      await tester.drag(longText.first, const Offset(-80, 0));
      await tester.pump();
      expect(tester.getTopLeft(longText.first).dx, lessThan(before));
      await expectLater(
        horizontal,
        matchesGoldenFile('goldens/table_horizontal_scrolled_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table fixed first scroll ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, tableDemoPageTestSpec, mode);
      final fixed = find.byKey(const ValueKey('table-fixed-first'));
      final headers = find.descendant(of: fixed, matching: find.text('标题'));
      final fixedBefore = tester.getTopLeft(headers.at(0)).dx;
      final scrollingBefore = tester.getTopLeft(headers.at(1)).dx;
      await tester.drag(headers.at(1), const Offset(-80, 0));
      await tester.pump();
      expect(tester.getTopLeft(headers.at(0)).dx, fixedBefore);
      expect(tester.getTopLeft(headers.at(1)).dx, lessThan(scrollingBefore));
      await expectLater(
        fixed,
        matchesGoldenFile(
          'goldens/table_fixed_first_scrolled_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table fixed last scroll ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, tableDemoPageTestSpec, mode);
      final fixed = find.byKey(const ValueKey('table-fixed-last'));
      final headers = find.descendant(of: fixed, matching: find.text('标题'));
      final scrollingBefore = tester.getTopLeft(headers.first).dx;
      final action = find.descendant(of: fixed, matching: find.text('修改'));
      final actionBefore = tester.getTopLeft(action.first).dx;
      await tester.drag(headers.first, const Offset(-80, 0));
      await tester.pump();
      expect(tester.getTopLeft(headers.first).dx, lessThan(scrollingBefore));
      expect(tester.getTopLeft(action.first).dx, actionBefore);
      await expectLater(
        fixed,
        matchesGoldenFile('goldens/table_fixed_last_scrolled_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
