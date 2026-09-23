import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/pull_down_refresh/pull_down_refresh_loading_texts_example.dart';
import 'package:tdesign_flutter_example/page/pull_down_refresh/pull_down_refresh_page.dart';
import 'package:tdesign_flutter_example/page/pull_down_refresh/pull_down_refresh_timeout_example.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import '../demo_page_test_utils.dart';
import 'pull_down_refresh_demo_test_spec.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TPullDownRefreshPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('基础 Demo 与小程序公开骨架结构对应', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    expect(find.byType(TPullDownRefresh), findsOneWidget);
    // 首屏可见：大骨架 + 前两组双列骨架；第三组位于内部滚动区域下方。
    expect(find.byType(TSkeleton), findsAtLeastNWidgets(5));
    final cardSkeletons = tester
        .widgetList<TSkeleton>(find.byType(TSkeleton))
        .where((skeleton) => skeleton.layout?.rows.length == 3);
    expect(cardSkeletons, isNotEmpty);
    for (final skeleton in cardSkeletons) {
      expect(skeleton.layout!.rows.first.single.height, 164);
      expect(skeleton.layout!.rows[1].single.height, 16);
    }
    expect(find.text('拖拽该区域演示 顶部下拉刷新'), findsOneWidget);
    expect(
      tester
          .widget<TText>(find.widgetWithText(TText, '拖拽该区域演示 顶部下拉刷新'))
          .textColor,
      TThemeData.defaultData().textDisabledColor,
    );
    expect(find.textContaining('刷新次数'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('公开场景与契约双向一致', (tester) async {
    await pumpFullDemoPage(
      tester,
      pullDownRefreshDemoPageTestSpec,
      ThemeMode.light,
    );
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    final actual = [
      for (final module in page.children)
        for (final item in module.children) '${module.title}/${item.desc}',
    ];
    final expected = pullDownRefreshDemoScenarios
        .map((scenario) => '${scenario.group}/${scenario.label}')
        .toList();
    expect(actual, expected);
    expect(
      pullDownRefreshDemoScenarios.map((scenario) => scenario.id).toSet(),
      hasLength(pullDownRefreshDemoScenarios.length),
    );
    await disposeDemoPage(tester);
  });

  testWidgets('点击中央提示可触发刷新，供 Web Preview 验收', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await tester.tap(find.text('拖拽该区域演示 顶部下拉刷新'));
    for (var index = 0; index < 8; index++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('正在刷新'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('超时回调更新公开示例中的刷新次数', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const Scaffold(body: PullDownRefreshTimeoutExample()),
      ),
    );

    expect(find.text('超时刷新次数：0'), findsOneWidget);
    expect(
      tester.widget<TText>(find.widgetWithText(TText, '超时刷新次数：0')).textColor,
      TThemeData.defaultData().textColorSecondary,
    );
    final refresh = tester.widget<TPullDownRefresh>(
      find.byType(TPullDownRefresh),
    );
    refresh.onStateChanged!(TPullDownRefreshState.timeout);
    await tester.pump();

    expect(find.text('超时刷新次数：1'), findsOneWidget);
    TToast.dismissAll();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('扩展示例常驻正文使用次要文字色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const Scaffold(body: PullDownRefreshLoadingTextsExample()),
      ),
    );

    for (final text in ['下拉刷新', '自定义提示语刷新次数：0']) {
      expect(
        tester.widget<TText>(find.widgetWithText(TText, text)).textColor,
        TThemeData.defaultData().textColorSecondary,
      );
    }
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
