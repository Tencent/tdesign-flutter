import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

import 'demo_page_test_utils.dart';
import 'tab_bar_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(tabBarDemoPageTestSpec);

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

  testWidgets('TabBar 所有代码入口展示实际生成片段', (tester) async {
    await pumpFullDemoPage(tester, tabBarDemoPageTestSpec, ThemeMode.light);
    const snippetNames = [
      '_textTabBar',
      '_iconTextTabBar',
      '_iconTabBar',
      '_doubleLayerTabBar',
      '_weakTabBars',
      '_capsuleTabBar',
      '_customTabBar',
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
