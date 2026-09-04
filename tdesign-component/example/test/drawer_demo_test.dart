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

  testWidgets('公开 Demo 仅展示小程序主场景和必要变体', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );

    expect(find.text('单元测试'), findsNothing);
    for (final label in const [
      '基础抽屉',
      '带图标抽屉',
      '右侧抽屉',
      '带标题抽屉',
      '带底部操作抽屉',
      '无遮罩抽屉',
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
    expect(find.text('菜单1'), findsOneWidget);
    expect(find.text('菜单8'), findsOneWidget);
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

  testWidgets('右侧、标题和底部操作变体可操作', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );
    await openDrawer(tester, '右侧抽屉');
    expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 95);
    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '带标题抽屉');
    expect(find.text('标题'), findsOneWidget);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '带底部操作抽屉');
    expect(find.text('标题'), findsOneWidget);
    expect(find.widgetWithText(TButton, '操作'), findsOneWidget);
  });

  testWidgets('无遮罩抽屉可通过菜单项关闭', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );
    await openDrawer(tester, '无遮罩抽屉');
    expect(find.byType(TDrawerWidget), findsOneWidget);

    await tester.tap(find.text('菜单1'));
    await tester.pumpAndSettle();
    expect(find.byType(TDrawerWidget), findsNothing);
  });
}
