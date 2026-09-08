import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dropdown_menu_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'demo_page_test_utils.dart';
import 'dropdown_menu_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(dropdownMenuDemoPageTestSpec);

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TDropdownMenuPage(),
      ),
    );
  }

  testWidgets('官方多选和禁用 Demo 入口公开可见', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    const labels = ['全部产品', '默认排序', '单列多选', '双列多选', '三列多选', '禁用菜单'];
    for (final label in labels) {
      final finder = find.text(label);
      await tester.scrollUntilVisible(
        finder.first,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(finder, label == '禁用菜单' ? findsNWidgets(2) : findsOneWidget);
    }
    expect(find.text('单元测试'), findsNothing);
  });

  testWidgets('两个禁用菜单均不展开', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final disabled = find.text('禁用菜单');
    await tester.scrollUntilVisible(
      disabled.first,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(disabled, findsNWidgets(2));
    await tester.tap(disabled.first);
    await tester.pumpAndSettle();
    expect(find.text('最新产品'), findsNothing);

    await tester.tap(disabled.last);
    await tester.pumpAndSettle();
    expect(find.text('最新产品'), findsNothing);
  });

  testWidgets('三列多选展开态与设计稿一致', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final trigger = find.text('三列多选');
    await tester.scrollUntilVisible(
      trigger,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    expect(find.text('选项名称'), findsNWidgets(12));
    expect(find.text('禁用选项'), findsNWidgets(3));
    expect(find.text('数码'), findsNothing);
    expect(find.text('生活'), findsNothing);
    expect(
      tester
          .getSize(
            find.byKey(const ValueKey<String>('t-dropdown-menu-panel-surface')),
          )
          .height,
      closeTo(348, 0.5),
    );
  });
}
