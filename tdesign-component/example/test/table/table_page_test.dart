import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

import '../demo_page_test_utils.dart';
import 'table_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(tableDemoPageTestSpec);

  testWidgets('Table 公开 Demo 的场景、尺寸与实例样式对齐', (tester) async {
    await pumpFullDemoPage(tester, tableDemoPageTestSpec, ThemeMode.light);

    final tableFinder = find.byWidgetPredicate((widget) => widget is TTable);
    final tables = tester.widgetList<TTable>(tableFinder).toList();
    final tableTopCoordinates = [
      for (var index = 0; index < tables.length; index++)
        tester.getTopLeft(tableFinder.at(index)).dy,
    ];
    expect(tables, hasLength(9));
    expect(
      find.descendant(of: find.byType(TNavBar), matching: find.text('Table')),
      findsOneWidget,
    );
    // Figma 的原始坐标已扣除 44px iOS 状态栏；公共标题行盒修正后，
    // 页面内容从 NavBar 起，与 Flutter Golden 使用同一个 375px / DPR 1 坐标系比较。
    expect(tableTopCoordinates, [
      274,
      746,
      1218,
      1652,
      2124,
      2595,
      3067,
      3589,
      4061,
    ]);
    for (var index = 0; index < tables.length; index++) {
      expect(tester.getSize(tableFinder.at(index)).height, 418);
    }
    expect(tables[7].stripe, isTrue);
    expect(tables[7].bordered, isNull);
    expect(tables[8].bordered, isTrue);
    expect(tables[8].stripe, isNull);

    await disposeDemoPage(tester);
  });

  testWidgets('Table 排序与横向滚动交互保持受控并同步', (tester) async {
    await pumpFullDemoPage(tester, tableDemoPageTestSpec, ThemeMode.light);

    final sortable = find.byKey(const ValueKey('table-sortable'));
    final sortableHeader = find.descendant(
      of: sortable,
      matching: find.text('标题'),
    );
    await tester.tap(sortableHeader.first);
    await tester.pump();
    var table = tester.widget<TTable>(sortable);
    expect(table.sort?.columnId, 'title1');
    expect(table.sort?.direction, TTableSortDirection.ascending);
    await tester.tap(sortableHeader.first);
    await tester.pump();
    table = tester.widget<TTable>(sortable);
    expect(table.sort?.direction, TTableSortDirection.descending);

    final horizontal = find.byKey(const ValueKey('table-horizontal-scroll'));
    final longText = find.descendant(
      of: horizontal,
      matching: find.text('横向平铺内容不省略'),
    );
    final before = tester.getTopLeft(longText.first).dx;
    await tester.drag(longText.first, const Offset(-80, 0));
    await tester.pump();
    expect(tester.getTopLeft(longText.first).dx, lessThan(before));

    final fixed = find.byKey(const ValueKey('table-fixed-first'));
    final fixedHeaders = find.descendant(of: fixed, matching: find.text('标题'));
    final fixedBefore = tester.getTopLeft(fixedHeaders.at(0)).dx;
    final scrollingBefore = tester.getTopLeft(fixedHeaders.at(1)).dx;
    await tester.drag(fixedHeaders.at(1), const Offset(-80, 0));
    await tester.pump();
    expect(tester.getTopLeft(fixedHeaders.at(0)).dx, fixedBefore);
    expect(tester.getTopLeft(fixedHeaders.at(1)).dx, lessThan(scrollingBefore));

    await disposeDemoPage(tester);
  });

  testWidgets('Table 全部代码面板映射到自包含的类级示例', (tester) async {
    await pumpFullDemoPage(tester, tableDemoPageTestSpec, ThemeMode.light);

    const names = [
      'TableBasicExample',
      'TableSortableExample',
      'TableOperationTextExample',
      'TableOperationIconExample',
      'TableFixedFirstExample',
      'TableFixedLastExample',
      'TableHorizontalScrollExample',
      'TableStripeExample',
      'TableBorderedExample',
    ];
    expect(
      tester
          .widgetList<CodeWrapper>(find.byType(CodeWrapper))
          .map((wrapper) => wrapper.methodName),
      names,
    );

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    expect(find.text('code'), findsNWidgets(names.length));

    for (var index = 0; index < names.length; index++) {
      final expected = await rootBundle.loadString(
        'assets/code/table.${names[index]}.txt',
      );
      expect(expected, contains('class ${names[index]}'));
      expect(expected, contains("import 'package:flutter/material.dart';"));

      await tester.tap(find.text('code').at(index));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Markdown>(find.byType(Markdown)).data,
        contains(expected),
      );
      Navigator.of(tester.element(find.byType(Markdown))).pop();
      await tester.pumpAndSettle();
    }

    await disposeDemoPage(tester);
  });
}
