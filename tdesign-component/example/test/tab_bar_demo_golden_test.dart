import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'tab_bar_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(tabBarDemoPageTestSpec);
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('TabBar 双层菜单展开 ${mode.name}', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, tabBarDemoPageTestSpec, mode);
      final bar = find.byWidgetPredicate(
        (widget) => widget is TTabBar && widget.type == TTabBarType.doubleLayer,
      );
      await tester.ensureVisible(bar);
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: bar, matching: find.text('我的')));
      await tester.pumpAndSettle();
      expect(find.text('个人主页'), findsOneWidget);
      expect(
        tester.getBottomLeft(find.text('设置')).dy,
        lessThan(tester.getTopLeft(bar).dy),
      );
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/tab_bar_menu_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
