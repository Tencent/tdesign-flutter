import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'drawer_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(drawerDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('drawer basic ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, drawerDemoPageTestSpec, mode);
      await tester.tap(find.widgetWithText(TButton, '基础抽屉'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/drawer_basic_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('drawer icon ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, drawerDemoPageTestSpec, mode);
      await tester.tap(find.widgetWithText(TButton, '带图标抽屉'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/drawer_icon_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
