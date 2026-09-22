import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/checkbox/checkbox_page.dart';

import 'demo_page_test_utils.dart';

const _checkboxSpec = DemoPageTestSpec(
  name: 'checkbox',
  title: 'Checkbox 多选框',
  page: TCheckboxPage(),
  expectedTexts: [
    '用于预设的一组选项中执行多项选择，并呈现选择结果。',
    '01 组件类型',
    '纵向多选框',
    '横向多选框',
    '多选标题',
    '上限四字',
    '带全选多选框',
    '02 组件状态',
    '多选框状态',
    '选项禁用-已选',
    '选项禁用-默认',
    '03 组件样式',
    '勾选样式',
    '勾选显示位置',
    '非通栏多选样式',
    '04 特殊样式',
    '纵向卡片多选框',
    '横向卡片多选框',
  ],
  componentType: TCheckbox,
  expectedComponentCount: 26,
);

void main() {
  registerDemoPageTests(_checkboxSpec);

  testWidgets('禁用列表只在两项之间显示分割线', (tester) async {
    await pumpFullDemoPage(tester, _checkboxSpec, ThemeMode.light);
    final disabled = tester
        .widgetList<TCheckbox>(find.byType(TCheckbox))
        .where(
          (checkbox) =>
              checkbox.title == '选项禁用-已选' || checkbox.title == '选项禁用-默认',
        )
        .toList();

    expect(disabled, hasLength(2));
    expect(disabled[0].showDivider, isTrue);
    expect(disabled[1].showDivider, isFalse);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('checkbox selected ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, _checkboxSpec, mode);
      final unchecked = find.byWidgetPredicate(
        (widget) =>
            widget is TCheckbox &&
            widget.value == false &&
            widget.onChanged != null,
      );
      expect(unchecked, findsWidgets);
      final uncheckedCount = unchecked.evaluate().length;
      await tester.tap(unchecked.first);
      await tester.pumpAndSettle();
      expect(unchecked, findsNWidgets(uncheckedCount - 1));
      await expectLater(
        find.byKey(const ValueKey('checkbox-demo-page')),
        matchesGoldenFile('goldens/checkbox_selected_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
