import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_button_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'button',
    title: 'Button 按钮',
    page: TButtonPage(),
    expectedTexts: ['01 组件类型', '02 组件状态', '03 组件主题'],
    componentType: TButton,
  );
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('button ${mode.name} pressed golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final button = find.widgetWithText(TButton, '填充按钮').first;
      final gesture = await tester.startGesture(tester.getCenter(button));
      await tester.pump();

      await expectLater(
        find.byKey(const ValueKey('button-demo-page')),
        matchesGoldenFile('goldens/button_pressed_${mode.name}.png'),
      );

      await gesture.cancel();
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
