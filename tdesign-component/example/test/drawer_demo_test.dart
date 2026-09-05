import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'drawer_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(drawerDemoPageTestSpec);

  Finder pageScrollable() => find.descendant(
    of: find.byType(CustomScrollView).first,
    matching: find.byType(Scrollable),
  );

  Future<void> openDrawer(WidgetTester tester, String label) async {
    final trigger = find.widgetWithText(TButton, label);
    await tester.scrollUntilVisible(
      trigger,
      160,
      scrollable: pageScrollable().first,
    );
    await tester.ensureVisible(trigger);
    await tester.pumpAndSettle();
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  testWidgets('公开 Demo 展示 Figma 的七个入口', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );

    expect(find.text('单元测试'), findsNothing);
    for (final label in const [
      '基础抽屉',
      '带图标抽屉',
      '小标题抽屉',
      '大标题抽屉',
      '左侧抽屉',
      '右侧抽屉',
      '带底部插槽',
    ]) {
      await tester.scrollUntilVisible(
        find.widgetWithText(TButton, label),
        160,
        scrollable: pageScrollable().first,
      );
      expect(find.widgetWithText(TButton, label), findsOneWidget);
    }
  });

  testWidgets('基础抽屉从左侧打开，宽 280 且展示 8 项', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );
    await openDrawer(tester, '基础抽屉');

    final drawer = find.byType(TDrawerWidget);
    expect(drawer, findsOneWidget);
    expect(tester.getTopLeft(drawer).dx, 0);
    expect(tester.getSize(drawer).width, 280);
    expect(find.text('菜单一'), findsOneWidget);
    expect(find.text('菜单八'), findsOneWidget);
    expect(
      find.descendant(of: drawer, matching: find.byType(TIcon)),
      findsNothing,
    );

    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();
    expect(drawer, findsNothing);
  });

  testWidgets('带图标抽屉为 8 项提供前缀图标', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );
    await openDrawer(tester, '带图标抽屉');

    final drawer = find.byType(TDrawerWidget);
    expect(
      find.descendant(of: drawer, matching: find.byType(TIcon)),
      findsNWidgets(8),
    );
  });

  testWidgets('大小标题、左右方向和底部插槽均可操作', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );
    await openDrawer(tester, '小标题抽屉');
    expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 0);
    expect(find.text('标题'), findsOneWidget);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '大标题抽屉');
    expect(find.text('标题'), findsOneWidget);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '左侧抽屉');
    expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 0);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '右侧抽屉');
    expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 95);
    await tester.tapAt(const Offset(15, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '带底部插槽');
    expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 0);
    expect(find.text('标题'), findsOneWidget);
    expect(find.widgetWithText(TButton, '操作'), findsOneWidget);
    expect(find.text('菜单四'), findsNWidgets(2));
    expect(find.text('菜单八'), findsNWidgets(2));
  });
}
