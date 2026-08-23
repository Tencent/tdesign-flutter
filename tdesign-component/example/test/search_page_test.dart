import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_search_bar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TSearchBarPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('官方 Search Demo 分组与场景完整', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    expect(find.text('用于用户输入搜索信息，并进行页面内容搜索。'), findsOneWidget);
    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('基础搜索框'), findsOneWidget);
    expect(find.text('字数限制'), findsOneWidget);
    expect(find.text('获取焦点后显示取消按钮'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('03 组件状态'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(find.text('02 组件样式'), findsOneWidget);
    expect(find.text('搜索框形状'), findsOneWidget);
    expect(find.text('03 组件状态'), findsOneWidget);
    expect(find.text('默认状态其他对齐方式'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Demo 外层留白不改变 Search 40dp 组件高度', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final searchBars = find.byType(TSearchBar);
    expect(searchBars, findsWidgets);
    for (final element in searchBars.evaluate()) {
      expect(tester.getSize(find.byWidget(element.widget)).height, 40);
    }
  });

  testWidgets('手机尺寸浅色 Search Demo 快照', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await expectLater(
      find.byType(TSearchBarPage),
      matchesGoldenFile('goldens/search_demo_light.png'),
    );
  });
}
