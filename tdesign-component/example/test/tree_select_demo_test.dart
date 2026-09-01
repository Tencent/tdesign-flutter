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
    expect(single.value.single, ['guangdong', 'shenzhen']);
    expect(multiple.multiple, isTrue);
    expect(multiple.value, hasLength(2));
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
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
