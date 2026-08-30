import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dropdown_menu_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
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

  testWidgets('custom price panel updates, confirms and cancels draft', (
    tester,
  ) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('¥100–500'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('¥100–500'));
    await tester.pumpAndSettle();

    final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
    slider.onChanged!(const RangeValues(200, 800));
    await tester.pump();
    tester.binding.handleMetricsChanged();
    await tester.pump();
    await tester.pump();
    expect(find.text('价格区间：¥200–800'), findsOneWidget);

    await tester.tap(find.text('应用价格'));
    await tester.pumpAndSettle();
    expect(find.text('¥200–800'), findsOneWidget);

    await tester.tap(find.text('¥200–800'));
    await tester.pumpAndSettle();
    tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged!(
      const RangeValues(300, 700),
    );
    await tester.pump();
    expect(find.text('价格区间：¥300–700'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('¥200–800'), findsOneWidget);
    expect(find.text('¥300–700'), findsNothing);
  });

  testWidgets('官方多选、禁用和方向 Demo 入口公开可见', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    const labels = ['全部产品', '默认排序', '单列多选', '双列多选', '三列多选', '禁用菜单', '向上展开'];
    for (final label in labels) {
      final finder = find.text(label);
      await tester.scrollUntilVisible(
        finder.first,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(finder, label == '禁用菜单' ? findsNWidgets(2) : findsOneWidget);
    }
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

  testWidgets('自定义图标的菜单明确向上展开', (tester) async {
    configureViewport(tester);
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final trigger = find.text('向上展开');
    await tester.scrollUntilVisible(
      trigger,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    final triggerTop = tester.getTopLeft(trigger).dy;

    await tester.tap(trigger);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    expect(tester.getTopLeft(find.text('最新产品')).dy, lessThan(triggerTop));
    expect(tester.takeException(), isNull);
  });
}
