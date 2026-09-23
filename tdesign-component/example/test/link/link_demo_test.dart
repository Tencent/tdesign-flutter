import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/link/link_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'link',
    title: 'Link 链接',
    page: TLinkViewPage(),
    expectedTexts: ['01 组件类型', '02 组件状态', '03 组件样式'],
    componentType: TLink,
  );
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('link feedback ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      await tester.tap(find.byType(TLink).first);
      await tester.pump();
      expect(find.text('点击了链接'), findsOneWidget);

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/link_feedback_${mode.name}.png'),
      );
      await tester.pump(const Duration(seconds: 3));
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
