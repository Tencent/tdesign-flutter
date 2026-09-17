import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_table_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'table',
    title: 'Table 表格',
    page: TTablePage(),
    expectedTexts: [
      '01 基础能力',
      '基础表格',
      '受控三态排序',
      '受控多选',
      '02 布局与状态',
      '固定列',
      '受限高度滚动',
      '加载状态',
      '空状态',
      '03 样式',
      '带边框表格',
      '斑马纹表格',
    ],
    supplementalCjkFontFamily: 'Table Golden CJK',
    supplementalCjkFontPath: 'test/fonts/TableGoldenCJK-Regular.otf',
  );
  registerDemoPageTests(spec);

  Finder tables() => find.byWidgetPredicate((widget) => widget is TTable);

  testWidgets('table Demo renders all public scenarios', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    expect(tables(), findsNWidgets(9));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('table sort states ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final sortable = tables().at(1);
      final nameHeader = find.descendant(
        of: sortable,
        matching: find.text('姓名'),
      );

      await tester.tap(nameHeader);
      await tester.pump(const Duration(milliseconds: 250));
      final dynamic ascendingTable = tester.widget(sortable);
      expect(
        (ascendingTable.sort as TTableSort).direction,
        TTableSortDirection.ascending,
      );
      await expectLater(
        sortable,
        matchesGoldenFile(
          'goldens/table_sort_ascending_${mode.name}.png',
        ),
      );

      await tester.tap(nameHeader);
      await tester.pump(const Duration(milliseconds: 250));
      final dynamic descendingTable = tester.widget(sortable);
      expect(
        (descendingTable.sort as TTableSort).direction,
        TTableSortDirection.descending,
      );
      await expectLater(
        sortable,
        matchesGoldenFile(
          'goldens/table_sort_descending_${mode.name}.png',
        ),
      );

      await tester.tap(nameHeader);
      await tester.pump();
      final dynamic unsortedTable = tester.widget(sortable);
      expect(unsortedTable.sort, isNull);
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table selection changed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final selectable = tables().at(2);
      final checkboxes = find.descendant(
        of: selectable,
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkboxes.at(1));
      await tester.pump(const Duration(milliseconds: 250));

      final dynamic selectedTable = tester.widget(selectable);
      expect((selectedTable.selectedRows as Set<Object?>), hasLength(1));
      await expectLater(
        selectable,
        matchesGoldenFile(
          'goldens/table_selection_changed_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table fixed columns scrolled ${mode.name} golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, spec, mode);
      final fixed = tables().at(3);
      await tester.drag(
        find.descendant(of: fixed, matching: find.text('职位')),
        const Offset(-80, 0),
      );
      await tester.pump();

      await expectLater(
        find.byKey(const ValueKey('table-demo-page')),
        matchesGoldenFile(
          'goldens/table_fixed_scrolled_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('table max height scrolled ${mode.name} golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, spec, mode);
      final maxHeight = tables().at(4);
      await tester.drag(
        find.descendant(of: maxHeight, matching: find.text('用户 1')),
        const Offset(0, -80),
      );
      await tester.pump();

      await expectLater(
        find.byKey(const ValueKey('table-demo-page')),
        matchesGoldenFile(
          'goldens/table_max_height_scrolled_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
