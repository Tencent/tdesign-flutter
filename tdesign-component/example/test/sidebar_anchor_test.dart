import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/sidebar/t_sidebar_page_anchor.dart';
import 'package:tdesign_flutter_example/page/sidebar/t_sidebar_page_outline.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  const anchorEdgeTolerance = 0.5;

  Widget buildPage({Widget? page, double textScaleFactor = 1}) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScaleFactor)),
          child: page ?? const TSideBarAnchorPage(),
        ),
      ),
    );
  }

  int expectedValue(WidgetTester tester) {
    final viewport = tester.getRect(find.byType(SingleChildScrollView));
    var expectedValue = 0;
    for (var index = 1; index < 20; index++) {
      if (tester.getTopLeft(find.text('标题$index')).dy <=
          viewport.top + anchorEdgeTolerance) {
        expectedValue = index;
      }
    }

    return expectedValue;
  }

  void expectSelectionMatchesViewport(WidgetTester tester) {
    final dynamic sideBarState = tester.state(find.byType(TSideBar));
    expect(sideBarState.currentValue, expectedValue(tester));
  }

  testWidgets('手势滚动始终与最后越过顶边的标题对应', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
    expectSelectionMatchesViewport(tester);

    final content = find.byType(SingleChildScrollView);
    for (final offset in [
      const Offset(0, -360),
      const Offset(0, -720),
      const Offset(0, -1200)
    ]) {
      await tester.drag(content, offset);
      await tester.pumpAndSettle();
      expectSelectionMatchesViewport(tester);
    }
  });

  testWidgets('点击中间和末项后标题对齐且高亮保持同步', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    final pageState = tester.state<TSideBarAnchorPageState>(
      find.byType(TSideBarAnchorPage),
    );
    for (final index in [6, 10, 19]) {
      final scroll = pageState.handleSidebarChange(index);
      await tester.pumpAndSettle();
      await scroll;
      await tester.pump();

      final dynamic sideBarState = tester.state(find.byType(TSideBar));
      expect(sideBarState.currentValue, index);

      final viewport = tester.getRect(find.byType(SingleChildScrollView));
      final title = tester.getTopLeft(find.text('标题$index'));
      expect(title.dy, closeTo(viewport.top, 1));
      expectSelectionMatchesViewport(tester);

      if (index == 19) {
        final scrollable = tester.state<ScrollableState>(
          find.descendant(
            of: find.byType(SingleChildScrollView),
            matching: find.byType(Scrollable),
          ),
        );
        final offset = scrollable.position.pixels;
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -240),
        );
        await tester.pumpAndSettle();
        expect(scrollable.position.pixels, closeTo(offset, 0.5));
      }
    }
  });

  testWidgets('非通栏选项使用相同的标题锚点语义', (tester) async {
    await tester.pumpWidget(buildPage(page: const TSideBarOutlinePage()));
    await tester.pumpAndSettle();

    final content = find.byType(SingleChildScrollView);
    await tester.drag(content, const Offset(0, -900));
    await tester.pumpAndSettle();
    expectSelectionMatchesViewport(tester);

    final pageState = tester.state<TSideBarAnchorPageState>(
      find.byType(TSideBarAnchorPage),
    );
    final scroll = pageState.handleSidebarChange(6);
    await tester.pumpAndSettle();
    await scroll;
    await tester.pump();

    final dynamic sideBarState = tester.state(find.byType(TSideBar));
    expect(sideBarState.currentValue, 6);
    expectSelectionMatchesViewport(tester);
  });

  testWidgets('更新 children 和较大文本缩放不影响锚点同步', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage(textScaleFactor: 1.5));
    await tester.pumpAndSettle();

    final content = find.byType(SingleChildScrollView);
    await tester.drag(content, const Offset(0, -900));
    await tester.pumpAndSettle();
    expectSelectionMatchesViewport(tester);

    await tester.tap(find.text('更新children'));
    await tester.pumpAndSettle();
    expectSelectionMatchesViewport(tester);

    final pageState = tester.state<TSideBarAnchorPageState>(
      find.byType(TSideBarAnchorPage),
    );
    final scroll = pageState.handleSidebarChange(19);
    await tester.pumpAndSettle();
    await scroll;
    await tester.pump();

    final viewport = tester.getRect(find.byType(SingleChildScrollView));
    final title = tester.getTopLeft(find.text('标题19'));
    expect(title.dy, closeTo(viewport.top, 1));
    expectSelectionMatchesViewport(tester);
  });
}
