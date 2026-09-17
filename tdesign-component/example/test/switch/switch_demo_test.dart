import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_switch_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'switch',
    title: 'Switch 开关',
    page: TSwitchPage(),
    expectedTexts: [
      '01 组件类型',
      '02 组件状态',
      '03 组件样式',
      '基础开关',
      '带描述开关',
      '自定义颜色开关',
      '开关尺寸',
    ],
    componentType: TSwitch,
    expectedComponentCount: 11,
  );
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('switch changed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final basic = find.descendant(
        of: find.byKey(const Key('switch-demo-basic')),
        matching: find.byType(TSwitch),
      );
      expect(tester.widget<TSwitch>(basic).value, isTrue);
      await tester.tap(basic);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.widget<TSwitch>(basic).value, isFalse);

      await expectLater(
        find.byKey(const ValueKey('switch-demo-page')),
        matchesGoldenFile('goldens/switch_changed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
