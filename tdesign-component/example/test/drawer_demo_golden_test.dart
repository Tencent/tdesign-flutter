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

    for (final entry in const {
      'icon': '带图标抽屉',
      'small_title': '小标题抽屉',
      'large_title': '大标题抽屉',
      'left': '左侧抽屉',
      'right': '右侧抽屉',
      'footer': '带底部插槽',
    }.entries) {
      testWidgets('drawer ${entry.key} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(tester, drawerDemoPageTestSpec, mode);
        await tester.tap(find.widgetWithText(TButton, entry.value));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/drawer_${entry.key}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
