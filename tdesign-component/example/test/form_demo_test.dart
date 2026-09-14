import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_form_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'form',
    title: 'Form 表单',
    page: TFormPage(),
    expectedTexts: ['01 组件类型'],
    componentType: TFormItem,
  );
  registerDemoPageTests(spec);

  testWidgets('日期和籍贯弹窗为 Picker 保留完整高度', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    await tester.tap(find.text('请输入生日'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TDateTimePicker)).height, 200);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('请选择籍贯'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TPicker)).height, 200);
  });
}
