import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'tree_select_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(treeSelectDemoPageTestSpec);

  testWidgets('TreeSelect Demo follows official scenario order', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, treeSelectDemoPageTestSpec, ThemeMode.light);
    final keys = ['single', 'multiple', 'three-columns'];
    final tops = keys
        .map(
          (id) => tester.getTopLeft(find.byKey(ValueKey('tree-select-$id'))).dy,
        )
        .toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('single and multiple values use complete controlled paths', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, treeSelectDemoPageTestSpec, ThemeMode.light);
    final single = tester.widget<TTreeSelect>(
      find.byKey(const ValueKey('tree-select-single')),
    );
    final multiple = tester.widget<TTreeSelect>(
      find.byKey(const ValueKey('tree-select-multiple')),
    );
    expect(single.multiple, isFalse);
    expect(single.value.single, ['guangdong', 'shanwei']);
    expect(multiple.multiple, isTrue);
    expect(multiple.value.single, ['guangdong', 'shanwei']);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('two-column examples match the design data and stay controlled', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, treeSelectDemoPageTestSpec, ThemeMode.light);
    final tree = find.byKey(const ValueKey('tree-select-single'));
    for (final province in const ['甘肃省', '广东省', '贵州省', '海南省', '河北省', '黑龙江省']) {
      expect(
        find.descendant(of: tree, matching: find.text(province)),
        findsOneWidget,
      );
    }
    for (final city in const ['汕头市', '汕尾市', '韶关市', '深圳市', '阳江市', '云浮市']) {
      expect(
        find.descendant(of: tree, matching: find.text(city)),
        findsOneWidget,
      );
    }

    await tester.tap(find.descendant(of: tree, matching: find.text('云浮市')));
    await tester.pump();
    expect(tester.widget<TTreeSelect>(tree).value.single, [
      'guangdong',
      'yunfu',
    ]);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('multiple example toggles complete leaf paths', (tester) async {
    await pumpFullDemoPage(tester, treeSelectDemoPageTestSpec, ThemeMode.light);
    final tree = find.byKey(const ValueKey('tree-select-multiple'));
    await tester.tap(find.descendant(of: tree, matching: find.text('深圳市')));
    await tester.pump();
    expect(tester.widget<TTreeSelect>(tree).value, [
      ['guangdong', 'shanwei'],
      ['guangdong', 'shenzhen'],
    ]);
    await tester.tap(find.descendant(of: tree, matching: find.text('汕尾市')));
    await tester.pump();
    expect(tester.widget<TTreeSelect>(tree).value.single, [
      'guangdong',
      'shenzhen',
    ]);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('three-column example renders the complete depth', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, treeSelectDemoPageTestSpec, ThemeMode.light);
    final tree = find.byKey(const ValueKey('tree-select-three-columns'));
    expect(tester.widget<TTreeSelect>(tree).value.single, [
      'guangdong',
      'shenzhen',
      'nanshan',
    ]);
    expect(
      find.descendant(of: tree, matching: find.text('南山区')),
      findsOneWidget,
    );
    expect(tester.getSize(tree), const Size(375, 336));
    final horizontalScroll = find.descendant(
      of: tree,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.right,
      ),
    );
    expect(
      tester.state<ScrollableState>(horizontalScroll).position.maxScrollExtent,
      0,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
