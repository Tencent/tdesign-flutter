import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

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

  testWidgets('所有 Drawer 查看代码入口展示自包含的当前实现', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );

    const entries = {
      '基础抽屉': 'drawer._buildBaseSimple.txt',
      '带图标抽屉': 'drawer._buildIconSimple.txt',
      '小标题抽屉': 'drawer._buildTitleSimple.txt',
      '左侧抽屉': 'drawer._buildPlacementSimple.txt',
      '带底部插槽': 'drawer._buildBottomSimple.txt',
    };
    for (final entry in entries.entries) {
      final trigger = find.widgetWithText(TButton, entry.key);
      await tester.scrollUntilVisible(
        trigger,
        160,
        scrollable: pageScrollable().first,
      );
      await tester.ensureVisible(trigger);
      await tester.pumpAndSettle();

      final source = await rootBundle.loadString('assets/code/${entry.value}');
      expect(source.trim(), isNotEmpty);
      expect(source, contains("'菜单一'"));
      expect(source, isNot(contains('_baseItems')));
      expect(source, isNot(contains('_footerItems')));
      expect(source, isNot(contains('_menuLabels')));

      TNotification.postNotification('onApiVisibleChange', {
        'apiVisible': true,
      });
      await tester.pumpAndSettle();
      final wrapper = find.ancestor(
        of: trigger,
        matching: find.byType(CodeWrapper),
      );
      await tester.tap(
        find.descendant(of: wrapper, matching: find.text('code')),
      );
      await tester.pumpAndSettle();
      final panel = find.byType(Markdown);
      expect(tester.widget<Markdown>(panel).data, contains(source));
      Navigator.of(tester.element(panel)).pop();
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('基础抽屉从左侧打开，宽 280 且展示 8 项', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      drawerDemoPageTestSpec,
      ThemeMode.light,
    );
    await openDrawer(tester, '基础抽屉');

    final drawer = find.byType(TDrawer);
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

    final drawer = find.byType(TDrawer);
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
    expect(tester.getTopLeft(find.byType(TDrawer)).dx, 0);
    expect(find.text('标题'), findsOneWidget);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '大标题抽屉');
    expect(find.text('标题'), findsOneWidget);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '左侧抽屉');
    expect(tester.getTopLeft(find.byType(TDrawer)).dx, 0);
    await tester.tapAt(const Offset(360, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '右侧抽屉');
    expect(tester.getTopLeft(find.byType(TDrawer)).dx, 95);
    await tester.tapAt(const Offset(15, 400));
    await tester.pumpAndSettle();

    await openDrawer(tester, '带底部插槽');
    expect(tester.getTopLeft(find.byType(TDrawer)).dx, 0);
    expect(find.text('标题'), findsOneWidget);
    expect(find.widgetWithText(TButton, '操作'), findsOneWidget);
    expect(find.text('菜单四'), findsNWidgets(2));
    expect(find.text('菜单八'), findsNWidgets(2));
  });
}
