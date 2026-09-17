import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'tab_bar_demo_test_spec.dart';

void main() {
  final registeredGoldenCases = {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) ...{
      for (final scene in tabBarDemoSceneIds)
        'scene:$scene:initial:${mode.name}',
      for (final scene in tabBarDemoSceneIds)
        'scene:$scene:selected:${mode.name}',
      'double_layer:menu_open:${mode.name}',
      'text:toast:${mode.name}',
      'double_layer:menu_toast:${mode.name}',
    },
  };

  test('TabBar Golden 注册集合覆盖全部公开场景和操作后状态', () {
    expect(registeredGoldenCases, expectedTabBarGoldenCases());
  });

  registerDemoGoldenTests(tabBarDemoPageTestSpec);
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('TabBar 全部公开场景切换后 ${mode.name}', (tester) async {
      await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, mode);
      final bars = find.byType(TTabBar);
      expect(bars, findsNWidgets(9));

      for (final index in [...List.generate(8, (index) => index + 1), 0]) {
        final bar = bars.at(index);
        final widget = tester.widget<TTabBar>(bar);
        final target = switch (widget.type) {
          TTabBarType.text || TTabBarType.iconText || TTabBarType.doubleLayer =>
            find.descendant(of: bar, matching: find.text('应用')),
          TTabBarType.icon => find.descendant(
            of: bar,
            matching: find.byIcon(TIcons.app),
          ),
        };
        await tester.tap(target);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 3));

      await expectLater(
        find.byKey(const ValueKey('tab_bar-demo-page')),
        matchesGoldenFile('goldens/tab_bar_post_action_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('TabBar 纯文本点击反馈 ${mode.name}', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, tabBarDemoPageTestSpec, mode);
      final bar = find.byType(TTabBar).first;
      await tester.tap(find.descendant(of: bar, matching: find.text('应用')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('点击了 Item 2'), findsOneWidget);

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/tab_bar_text_toast_${mode.name}.png'),
      );
      await tester.pump(const Duration(seconds: 3));
      await disposeDemoPage(tester);
    }, tags: 'golden');

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

    testWidgets('TabBar 双层菜单选择反馈 ${mode.name}', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, tabBarDemoPageTestSpec, mode);
      final bar = find.byWidgetPredicate(
        (widget) => widget is TTabBar && widget.type == TTabBarType.doubleLayer,
      );
      await tester.ensureVisible(bar);
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: bar, matching: find.text('我的')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('个人主页'));
      await tester.pumpAndSettle();
      expect(find.text('选择了个人主页'), findsOneWidget);
      expect(find.byType(TTabBarMenuItem), findsNothing);

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/tab_bar_menu_selected_toast_${mode.name}.png',
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
