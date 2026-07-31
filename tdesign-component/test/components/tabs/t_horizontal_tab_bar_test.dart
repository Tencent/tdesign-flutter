import 'package:flutter/material.dart'
    hide TabPageSelector, TabPageSelectorIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/tabs/t_horizontal_tab_bar.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// THorizontalTabBar / THorizontalTabBarView / TabPageSelector 测试。

/// flutter_test 中构建期抛出的 FlutterError 会被框架异步上报而非同步抛出，
/// 因此用 pumpWidget 后取 takeException 来断言错误。
Future<void> expectBuildFlutterError(WidgetTester tester, Widget widget) async {
  FlutterError? err;
  try {
    await tester.pumpWidget(widget);
  } catch (e) {
    if (e is FlutterError) {
      err = e;
    }
  }
  err ??= tester.takeException() as FlutterError?;
  expect(err, isA<FlutterError>());
}

void main() {
  List<TTab> buildTabs(int count) =>
      List.generate(count, (i) => TTab(text: '选项${i + 1}'));

  Widget wrapBar(Widget bar, {bool rtl = false, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(
        body: rtl
            ? Directionality(textDirection: TextDirection.rtl, child: bar)
            : bar,
      ),
    );
  }

  group('THorizontalTabBar getter', () {
    test('preferredSize 取最高 tab + indicatorWeight', () {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      final bar = THorizontalTabBar(tabs: buildTabs(3), controller: c);
      expect(bar.preferredSize.height, greaterThanOrEqualTo(46.0));
    });

    test('tabHasTextAndIcon 含图标 tab 返回 true', () {
      final c = TabController(length: 1, vsync: const TestVSync());
      addTearDown(c.dispose);
      final bar = THorizontalTabBar(
        tabs: const [TTab(text: 'x', icon: Icon(Icons.star))],
        controller: c,
      );
      expect(bar.tabHasTextAndIcon, isTrue);
    });

    test('tabHasTextAndIcon 纯文本返回 false', () {
      final c = TabController(length: 2, vsync: const TestVSync());
      addTearDown(c.dispose);
      final bar = THorizontalTabBar(tabs: buildTabs(2), controller: c);
      expect(bar.tabHasTextAndIcon, isFalse);
    });
  });

  group('THorizontalTabBar 默认/裸渲染', () {
    testWidgets('裸渲染（labelStyle/labelColor 为 null 走默认分支）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(THorizontalTabBar(tabs: buildTabs(3), controller: c)),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('带 labelColor/labelStyle/unselected* 覆盖非空分支', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            labelColor: Colors.red,
            labelStyle: const TextStyle(fontSize: 16),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(fontSize: 12),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });
  });

  group('THorizontalTabBar 指示器相关', () {
    testWidgets('indicatorColor 自定义', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('indicator 自定义 Decoration（忽略 color/weight）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicator: const BoxDecoration(color: Colors.green),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('TabBarTheme 注入 indicator/indicatorSize/labelPadding', (
      tester,
    ) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicatorSize: TabBarIndicatorSize.label,
          ),
          theme: ThemeData(
            extensions: [TThemeData.defaultData()],
            tabBarTheme: const TabBarThemeData(
              indicator: BoxDecoration(color: Colors.purple),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.all(8),
            ),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('indicatorSize: label 计算指示宽度', (tester) async {
      final c = TabController(length: 2, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(2),
            controller: c,
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('indicatorPadding 自定义', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });
  });

  group('THorizontalTabBar 其它参数', () {
    testWidgets('labelPadding / overlayColor / mouseCursor / enableFeedback', (
      tester,
    ) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            labelPadding: const EdgeInsets.all(6),
            overlayColor: WidgetStateProperty.all<Color?>(Colors.black12),
            mouseCursor: SystemMouseCursors.text,
            enableFeedback: false,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('onTap 回调（触发 animateTo + onTap）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      int? tapped;
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            onTap: (i) => tapped = i,
          ),
        ),
      );
      await tester.tap(find.text('选项2'));
      await tester.pumpAndSettle();
      expect(tapped, 1);
    });

    testWidgets('physics 自定义', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            physics: const BouncingScrollPhysics(),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('padding 非滚动', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            padding: const EdgeInsets.all(8),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('variant: capsule', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            variant: TTabsBarVariant.capsule,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('variant: card（选中/未选中装饰分支）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            variant: TTabsBarVariant.card,
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('automaticIndicatorColorAdjustment: false', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        Material(
          color: Colors.blue,
          child: MaterialApp(
            theme: ThemeData(extensions: [TThemeData.defaultData()]),
            home: Scaffold(
              body: THorizontalTabBar(
                tabs: buildTabs(3),
                controller: c,
                indicatorColor: Colors.blue,
                automaticIndicatorColorAdjustment: false,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });
  });

  group('THorizontalTabBar 滚动', () {
    testWidgets('isScrollable: true（SingleChildScrollView）', (tester) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c,
            isScrollable: true,
          ),
        ),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('isScrollable + tabAlignment: start', (tester) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('isScrollable + tabAlignment: startOffset（左侧 padding）', (
      tester,
    ) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c,
            isScrollable: true,
            tabAlignment: TabAlignment.startOffset,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('isScrollable + rtl 滚动偏移', (tester) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c,
            isScrollable: true,
          ),
          rtl: true,
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('isScrollable 点击 tab 触发滚动到当前项', (tester) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c,
            isScrollable: true,
          ),
        ),
      );
      await tester.tap(find.text('选项4'));
      await tester.pumpAndSettle();
      expect(c.index, 3);
    });
  });

  group('THorizontalTabBar 边界/断言', () {
    testWidgets('controller length 0 渲染空 Container', (tester) async {
      final c = TabController(length: 0, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(THorizontalTabBar(tabs: const [], controller: c)),
      );
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('didUpdateWidget：indicatorColor 变化重建指示器', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicatorColor: Colors.blue,
          ),
        ),
      );
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicatorColor: Colors.red,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('didUpdateWidget：切换 variant 重建', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            variant: TTabsBarVariant.filled,
          ),
        ),
      );
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            variant: TTabsBarVariant.card,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('build 断言 controller 长度与 tabs 不匹配抛 FlutterError', (
      tester,
    ) async {
      final c = TabController(length: 2, vsync: const TestVSync());
      addTearDown(c.dispose);
      await expectBuildFlutterError(
        tester,
        wrapBar(THorizontalTabBar(tabs: buildTabs(3), controller: c)),
      );
    });

    testWidgets('scrollable + TabAlignment.fill 抛断言', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await expectBuildFlutterError(
        tester,
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            isScrollable: true,
            tabAlignment: TabAlignment.fill,
          ),
        ),
      );
    });

    testWidgets('非 scrollable + TabAlignment.start 抛断言', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await expectBuildFlutterError(
        tester,
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            tabAlignment: TabAlignment.start,
          ),
        ),
      );
    });

    testWidgets('indicatorPadding 过大抛 FlutterError（479,481）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await expectBuildFlutterError(
        tester,
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            indicatorPadding: const EdgeInsets.all(1000),
          ),
        ),
      );
    });

    testWidgets('didUpdateWidget 切换 controller 重建并移除旧监听', (tester) async {
      final c3 = TabController(length: 3, vsync: const TestVSync());
      final c5 = TabController(length: 5, vsync: const TestVSync());
      addTearDown(() {
        c3.dispose();
        c5.dispose();
      });
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c3,
            isScrollable: true,
          ),
        ),
      );
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c5,
            isScrollable: true,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('didUpdateWidget tabs 数量增加追加 keys', (tester) async {
      final c3 = TabController(length: 3, vsync: const TestVSync());
      final c5 = TabController(length: 5, vsync: const TestVSync());
      addTearDown(() {
        c3.dispose();
        c5.dispose();
      });
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c3,
            isScrollable: true,
          ),
        ),
      );
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c5,
            isScrollable: true,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('同一 tabs 列表原地增长会同步 keys', (tester) async {
      final tabs = buildTabs(2);
      final c2 = TabController(length: 2, vsync: const TestVSync());
      final c3 = TabController(length: 3, vsync: const TestVSync());
      addTearDown(() {
        c2.dispose();
        c3.dispose();
      });
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(tabs: tabs, controller: c2, isScrollable: true),
        ),
      );

      tabs.add(const TTab(text: '选项3'));
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(tabs: tabs, controller: c3, isScrollable: true),
        ),
      );

      expect(find.text('选项3'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('didUpdateWidget tabs 数量减少裁剪 keys（656）', (tester) async {
      final c5 = TabController(length: 5, vsync: const TestVSync());
      final c2 = TabController(length: 2, vsync: const TestVSync());
      addTearDown(() {
        c5.dispose();
        c2.dispose();
      });
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(5),
            controller: c5,
            isScrollable: true,
          ),
        ),
      );
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(2),
            controller: c2,
            isScrollable: true,
          ),
        ),
      );
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('card variant 选中非首项时装饰分支（822）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        wrapBar(
          THorizontalTabBar(
            tabs: buildTabs(3),
            controller: c,
            variant: TTabsBarVariant.card,
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
      );
      c.animateTo(1);
      await tester.pumpAndSettle();
      expect(c.index, 1);
    });
  });

  group('THorizontalTabBarView', () {
    Widget buildView(TabController c, {List<Widget>? children}) {
      return MaterialApp(
        home: THorizontalTabBarView(
          controller: c,
          children:
              children ??
              const [
                Center(child: Text('页面1')),
                Center(child: Text('页面2')),
                Center(child: Text('页面3')),
              ],
        ),
      );
    }

    testWidgets('默认渲染 + didChangeDependencies', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      expect(find.byType(THorizontalTabBarView), findsOneWidget);
      expect(find.text('页面1'), findsOneWidget);
    });

    testWidgets('didUpdateWidget：controller 变化 jumpToPage', (tester) async {
      final c1 = TabController(length: 3, vsync: const TestVSync());
      final c2 = TabController(length: 3, vsync: const TestVSync());
      addTearDown(() {
        c1.dispose();
        c2.dispose();
      });
      await tester.pumpWidget(buildView(c1));
      await tester.pumpWidget(buildView(c2));
      expect(find.byType(THorizontalTabBarView), findsOneWidget);
    });

    testWidgets('didUpdateWidget：children 变化更新', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      await tester.pumpWidget(
        buildView(
          c,
          children: const [
            Center(child: Text('A')),
            Center(child: Text('B')),
            Center(child: Text('C')),
          ],
        ),
      );
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('切换 index 单步 warp（diff==1）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      c.animateTo(1);
      await tester.pumpAndSettle();
      expect(c.index, 1);
    });

    testWidgets('切换 index 多步 warp（diff>1）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      c.animateTo(2);
      await tester.pumpAndSettle();
      expect(c.index, 2);
    });

    testWidgets('animationDuration 为 0 时直接 jumpToPage', (tester) async {
      final c = TabController(
        length: 3,
        vsync: const TestVSync(),
        animationDuration: Duration.zero,
      );
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      c.animateTo(1);
      await tester.pumpAndSettle();
      expect(c.index, 1);
    });

    testWidgets('warp 时 page 已在目标页直接返回', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      c.animateTo(0);
      await tester.pumpAndSettle();
      expect(c.index, 0);
    });

    testWidgets('拖拽 PageView 触发 ScrollNotification', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildView(c));
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('physics 非 null 走自定义物理分支（1488）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: THorizontalTabBarView(
            controller: c,
            physics: const BouncingScrollPhysics(),
            children: const [
              Center(child: Text('A')),
              Center(child: Text('B')),
              Center(child: Text('C')),
            ],
          ),
        ),
      );
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('build 断言 children 数量与 controller 不匹配抛 FlutterError', (
      tester,
    ) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await expectBuildFlutterError(
        tester,
        MaterialApp(
          home: THorizontalTabBarView(
            controller: c,
            children: const [
              Center(child: Text('A')),
              Center(child: Text('B')),
            ],
          ),
        ),
      );
    });
  });

  group('THorizontalTabBar + THorizontalTabBarView 组合', () {
    Widget buildCombined(TabController c, {bool scrollable = false}) {
      return MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(
          body: Column(
            children: [
              THorizontalTabBar(
                tabs: buildTabs(5),
                controller: c,
                isScrollable: scrollable,
              ),
              Expanded(
                child: THorizontalTabBarView(
                  controller: c,
                  children: const [
                    Center(child: Text('页面1')),
                    Center(child: Text('页面2')),
                    Center(child: Text('页面3')),
                    Center(child: Text('页面4')),
                    Center(child: Text('页面5')),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('scrollable 拖拽 PageView 同步 TabBar 滚动（708-744/1449-1463）', (
      tester,
    ) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildCombined(c, scrollable: true));
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('非 scrollable 组合渲染', (tester) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildCombined(c));
      expect(find.byType(THorizontalTabBar), findsOneWidget);
    });

    testWidgets('组合下点击 tab 切换页面', (tester) async {
      final c = TabController(length: 5, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(buildCombined(c, scrollable: true));
      await tester.tap(find.text('选项3'));
      await tester.pumpAndSettle();
      expect(c.index, 2);
    });
  });

  group('TabPageSelector / TabPageSelectorIndicator', () {
    testWidgets('TabPageSelectorIndicator 直接渲染', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TabPageSelectorIndicator(
            backgroundColor: Colors.red,
            borderColor: Colors.blue,
            size: 12,
          ),
        ),
      );
      expect(find.byType(TabPageSelectorIndicator), findsOneWidget);
    });

    testWidgets('TabPageSelector 默认渲染', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(home: TabPageSelector(controller: c)),
      );
      expect(find.byType(TabPageSelector), findsWidgets);
    });

    testWidgets('TabPageSelector 带 color/selectedColor/indicatorSize', (
      tester,
    ) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: TabPageSelector(
            controller: c,
            color: Colors.grey,
            selectedColor: Colors.blue,
            indicatorSize: 16,
          ),
        ),
      );
      expect(find.byType(TabPageSelector), findsWidgets);
    });

    testWidgets('TabPageSelector 动画中 indexIsChanging 分支', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(home: TabPageSelector(controller: c)),
      );
      c.animateTo(1);
      await tester.pump();
      expect(c.indexIsChanging, isTrue);
      // 结束动画，避免测试结束时仍有动画在运行
      await tester.pumpAndSettle();
    });

    testWidgets('TabPageSelector 拖动 offset>0 分支（1595）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(home: TabPageSelector(controller: c)),
      );
      c.offset = 0.5;
      c.notifyListeners();
      await tester.pump();
      expect(c.offset, 0.5);
      await tester.pumpAndSettle();
    });

    testWidgets('TabPageSelector 拖动 offset<0 分支（1598）', (tester) async {
      final c = TabController(length: 3, vsync: const TestVSync());
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(home: TabPageSelector(controller: c)),
      );
      // 直接设置 index（不触发 indexIsChanging），再设负 offset 走 1598 分支
      c.index = 1;
      c.notifyListeners();
      await tester.pump();
      c.offset = -0.5;
      c.notifyListeners();
      await tester.pump();
      expect(c.offset, -0.5);
      await tester.pumpAndSettle();
    });
  });
}
