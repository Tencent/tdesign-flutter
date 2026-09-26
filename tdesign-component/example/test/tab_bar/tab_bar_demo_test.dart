import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

import '../demo_page_test_utils.dart';
import 'tab_bar_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(tabBarDemoPageTestSpec);

  testWidgets('Golden 字体实际用于胶囊标签文字', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    final capsule = find.byWidgetPredicate(
      (widget) => widget is TTabBar && widget.style == TTabBarStyle.capsule,
    );
    final label = find
        .descendant(
          of: capsule,
          matching: find.byWidgetPredicate(
            (widget) => widget is TText && widget.data == 'Item',
          ),
        )
        .first;
    expect(tester.widget<TText>(label).style?.fontFamily, 'Roboto');
    await disposeDemoPage(tester);
  });

  testWidgets('双层级示例初始状态与菜单操作符合设计稿', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    final barFinder = find.byType(TTabBar).at(3);
    final bar = tester.widget<TTabBar>(barFinder);
    expect(bar.type, TTabBarType.doubleLayer);
    expect(bar.value, 3);
    await tester.tap(find.descendant(of: barFinder, matching: find.text('我的')));
    await tester.pumpAndSettle();
    for (final label in ['基本信息', '个人主页', '设置']) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('个人主页'));
    await tester.pumpAndSettle();
    expect(find.text('选择了个人主页'), findsOneWidget);
    expect(find.byType(TTabBarMenuItem), findsNothing);
    await tester.pump(const Duration(seconds: 3));
    await disposeDemoPage(tester);
  });

  testWidgets('滚动后展开菜单仍定位在触发标签上方', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      tabBarDemoPageTestSpec,
      ThemeMode.light,
    );
    final bar = find.byWidgetPredicate(
      (widget) => widget is TTabBar && widget.type == TTabBarType.doubleLayer,
    );
    await tester.ensureVisible(bar);
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: bar, matching: find.text('我的')));
    await tester.pumpAndSettle();
    expect(
      tester.getBottomLeft(find.text('设置')).dy,
      lessThan(tester.getTopLeft(bar).dy),
    );
    await tester.pump(const Duration(seconds: 3));
    await disposeDemoPage(tester);
  });

  testWidgets('示例选中状态由页面 State 持有且不因代码层重建丢失', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    final first = find.byType(TTabBar).first;
    await tester.tap(find.descendant(of: first, matching: find.text('聊天')));
    await tester.pumpAndSettle();
    expect(tester.widget<TTabBar>(first).value, 2);
    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    expect(tester.widget<TTabBar>(first).value, 2);
    TNotification.postNotification('onApiVisibleChange', {'apiVisible': false});
    await tester.pumpAndSettle();
    expect(tester.widget<TTabBar>(first).value, 2);
    await tester.pump(const Duration(seconds: 3));
    await disposeDemoPage(tester);
  });

  testWidgets('所有公开标签栏场景均可受控切换选中项', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    final bars = find.byType(TTabBar);
    expect(bars, findsNWidgets(9));

    for (final index in [...List.generate(8, (index) => index + 1), 0]) {
      final bar = bars.at(index);
      final widget = tester.widget<TTabBar>(bar);
      final target = widget.style == TTabBarStyle.capsule
          ? find.descendant(of: bar, matching: find.text('Item')).at(1)
          : switch (widget.type) {
              TTabBarType.text ||
              TTabBarType.iconText ||
              TTabBarType.doubleLayer => find.descendant(
                of: bar,
                matching: find.text('应用'),
              ),
              TTabBarType.icon => find.descendant(
                of: bar,
                matching: find.byIcon(TIcons.app),
              ),
            };
      await tester.tap(target);
      await tester.pumpAndSettle();
      expect(
        find.text('第 2 项'),
        findsOneWidget,
        reason: 'TabBar index $index 的点击反馈',
      );
      expect(
        tester.widget<TTabBar>(bar).value,
        1,
        reason: 'TabBar index $index',
      );
      await tester.pump(const Duration(seconds: 3));
    }

    final firstBar = bars.first;
    await tester.tap(find.descendant(of: firstBar, matching: find.text('首页')));
    await tester.pumpAndSettle();
    expect(find.text('第 1 项'), findsOneWidget);
    await tester.tap(find.descendant(of: firstBar, matching: find.text('首页')));
    await tester.pumpAndSettle();
    expect(find.text('第 1 项'), findsOneWidget);
    expect(tester.widget<TTabBar>(firstBar).value, 0);

    await tester.pump(const Duration(seconds: 3));
    await disposeDemoPage(tester);
  });

  testWidgets('默认徽标示例不通过逐项 offset 修正组件位置', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    final weakTextBar = tester.widget<TTabBar>(find.byType(TTabBar).at(4));

    expect(weakTextBar.type, TTabBarType.text);
    expect(
      weakTextBar.navigationTabs.map((item) => item.badge?.offset),
      everyElement(isNull),
    );
    await disposeDemoPage(tester);
  });

  testWidgets('胶囊示例展示设计稿中的图文和首项圆点徽标', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    final capsuleFinder = find.byWidgetPredicate(
      (widget) => widget is TTabBar && widget.style == TTabBarStyle.capsule,
    );
    final capsule = tester.widget<TTabBar>(capsuleFinder);
    expect(capsule.type, TTabBarType.iconText);
    expect(capsule.selectedBgColor, isNull);
    expect(capsule.centerDistance, isNull);
    expect(capsule.navigationTabs, hasLength(4));
    expect(
      capsule.navigationTabs.map((item) => item.selectTabTextStyle),
      everyElement(isNull),
    );
    expect(
      capsule.navigationTabs.map((item) => item.unselectTabTextStyle),
      everyElement(isNull),
    );
    expect(
      capsule.navigationTabs.map((item) => item.tabText),
      everyElement('Item'),
    );
    expect(capsule.navigationTabs.first.badge?.variant, TBadgeVariant.dot);
    expect(
      capsule.navigationTabs.map((item) => item.selectedIcon),
      everyElement(
        isA<Icon>()
            .having((icon) => icon.icon, 'icon', TIcons.app)
            .having((icon) => icon.size, 'size', isNull),
      ),
    );
    expect(
      capsule.navigationTabs.map((item) => item.unselectedIcon),
      everyElement(
        isA<Icon>()
            .having((icon) => icon.icon, 'icon', TIcons.app)
            .having((icon) => icon.size, 'size', isNull),
      ),
    );
    expect(
      find.descendant(of: capsuleFinder, matching: find.byIcon(TIcons.app)),
      findsNWidgets(4),
    );
    expect(
      capsule.navigationTabs.skip(1).map((item) => item.badge),
      everyElement(isNull),
    );
    await disposeDemoPage(tester);
  });

  testWidgets('TabBar 所有代码入口展示实际生成片段', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    const snippetNames = [
      'TextTabBarExample',
      'IconTextTabBarExample',
      'IconTabBarExample',
      'DoubleLayerTabBarExample',
      'WeakTabBarsExample',
      'CapsuleTabBarExample',
      'CustomTabBarExample',
    ];

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    expect(find.byType(CodeWrapper), findsNWidgets(snippetNames.length));
    for (var index = 0; index < snippetNames.length; index++) {
      final name = snippetNames[index];
      final snippet = await rootBundle.loadString(
        'assets/code/tabBar.$name.txt',
      );
      final wrapper = find.byType(CodeWrapper).at(index);
      await tester.tap(
        find.descendant(of: wrapper, matching: find.text('code')),
      );
      await tester.pumpAndSettle();
      final panel = find.byType(Markdown);
      expect(tester.widget<Markdown>(panel).data, contains(snippet));
      Navigator.of(tester.element(panel)).pop();
      await tester.pumpAndSettle();
    }
    await disposeDemoPage(tester);
  });
}
