import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_fab_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'fab',
    title: 'Fab 悬浮按钮',
    page: TFabPage(),
    expectedTexts: ['01 组件类型', '02 组件样式'],
    componentType: TFab,
  );
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('fab collapsed ${mode.name} golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, spec, mode);
      await tester.tap(find.widgetWithText(TButton, '带自动收缩功能'));
      await tester.pump();
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(CustomScrollView)),
      );
      await gesture.moveBy(const Offset(0, -120));
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(TFab),
          matching: find.byIcon(TIcons.chevron_left),
        ),
        findsOneWidget,
      );

      await expectLater(
        find.byKey(const ValueKey('fab-demo-page')),
        matchesGoldenFile('goldens/fab_collapsed_${mode.name}.png'),
      );
      await gesture.up();
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
