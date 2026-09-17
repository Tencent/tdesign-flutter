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

  testWidgets('公开菜单入口与场景契约顺序完全一致', (tester) async {
    await pumpFullDemoPage(
      tester,
      dropdownMenuDemoPageTestSpec,
      ThemeMode.light,
    );

    final actualLabels = <String?>[];
    final actualEnabledStates = <bool>[];
    for (final menu in tester.widgetList<TDropdownMenu>(
      find.byType(TDropdownMenu),
    )) {
      for (final item in menu.items) {
        actualLabels.add(item.label);
        actualEnabledStates.add(item.enabled);
      }
    }
    expect(
      actualLabels,
      dropdownMenuPublicScenarios.map((scenario) => scenario.label).toList(),
    );
    expect(
      actualEnabledStates,
      dropdownMenuPublicScenarios.map((scenario) => scenario.enabled).toList(),
    );
    expect(find.text('单元测试'), findsNothing);
    await disposeDemoPage(tester);
  });

  testWidgets('全部公开菜单入口均执行对应展开或禁用行为', (tester) async {
    configureViewport(tester);

    for (final scenario in dropdownMenuPublicScenarios) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(buildPage());
      await tester.pumpAndSettle();

      final duplicateIndex = dropdownMenuPublicScenarios
          .takeWhile((candidate) => candidate.id != scenario.id)
          .where((candidate) => candidate.label == scenario.label)
          .length;
      final matchingTriggers = find.text(scenario.label);
      final trigger = matchingTriggers.at(duplicateIndex);
      await tester.scrollUntilVisible(
        trigger,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(trigger);
      await tester.pumpAndSettle();

      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );
      if (scenario.enabled) {
        expect(panelSurface, findsOneWidget, reason: scenario.id);
        expect(
          find.text(scenario.expectedPanelText),
          findsNWidgets(scenario.expectedPanelTextCount),
          reason: scenario.id,
        );
      } else {
        expect(panelSurface, findsNothing, reason: scenario.id);
      }
    }
  });

  testWidgets('单选项选中文字和勾选图标使用品牌色', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    await tester.tap(find.text('全部产品'));
    await tester.pumpAndSettle();

    final selectedText = tester.widget<Text>(find.text('全部产品').last);
    final selectedIcon = tester.widget<Icon>(find.byIcon(TIcons.check));
    final brandColor = TThemeData.defaultData().brandNormalColor;
    expect(selectedText.style?.color, brandColor);
    expect(selectedIcon.color, brandColor);
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
    final disabledChip = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('禁用选项').first,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container && widget.decoration is BoxDecoration,
            ),
          )
          .first,
    );
    expect(
      (disabledChip.decoration! as BoxDecoration).color,
      const Color(0xFFEEEEEE),
    );
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
