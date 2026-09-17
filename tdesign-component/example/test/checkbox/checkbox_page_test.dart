import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_checkbox_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
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
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('checkbox changed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final checkbox = find.byType(TCheckbox).first;
      expect(tester.widget<TCheckbox>(checkbox).value, isTrue);
      await tester.tap(checkbox);
      await tester.pump();
      expect(tester.widget<TCheckbox>(checkbox).value, isFalse);

      await expectLater(
        find.byKey(const ValueKey('checkbox-demo-page')),
        matchesGoldenFile('goldens/checkbox_changed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
