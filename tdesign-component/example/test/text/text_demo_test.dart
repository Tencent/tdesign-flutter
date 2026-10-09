import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/text/text_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'text',
    title: 'Text 文本',
    page: TTextPage(),
    expectedTexts: ['01 组件类型', '02 文本样式', '03 段落与辅助能力', '04 组件主题'],
    componentType: TText,
  );
  registerDemoPageTests(spec);

  testWidgets('普通文本 Demo 使用 body-medium 字号和行高', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    final text = tester.widget<Text>(find.text('文本 Text').first);
    expect(text.style?.fontSize, 14);
    expect(text.style?.height, 22 / 14);
    await disposeDemoPage(tester);
  });
}
