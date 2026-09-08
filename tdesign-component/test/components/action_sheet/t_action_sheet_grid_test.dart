import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_item_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TActionSheetGrid 宫格动作面板测试
///
/// 覆盖描述文本、分页（PageView + 圆点 + 翻页回调）和横向滚动布局。
void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), const TActionSheetThemeData()],
      ),
      home: Scaffold(body: child),
    );
  }

  List<TActionSheetItem<int>> items(int n) =>
      List.generate(n, (i) => TActionSheetItem(value: i, label: '项$i'));

  testWidgets('默认宫格渲染', (tester) async {
    await tester.pumpWidget(wrap(TActionSheetGrid(items: items(6))));
    expect(find.byType(TActionSheetGrid<int>), findsOneWidget);

    final token = TThemeData.defaultData();
    final cancelSpacing = tester
        .widgetList<Container>(find.byType(Container))
        .firstWhere(
          (container) =>
              container.padding == EdgeInsets.only(top: token.spacer8) &&
              container.color == token.bgColorContainer,
        );
    expect(cancelSpacing.color, token.bgColorContainer);
  });

  testWidgets('带 subtitle 渲染描述分支', (tester) async {
    await tester.pumpWidget(
      wrap(TActionSheetGrid(items: items(6), subtitle: '请选择')),
    );
    expect(find.text('请选择'), findsOneWidget);
    expect(tester.widget<Text>(find.text('请选择')).textAlign, TextAlign.center);
  });

  testWidgets('长 subtitle 在窄宽度下可换行且不溢出', (tester) async {
    const longSubtitle = '这是用于验证宫格动作面板描述在窄屏下不会横向溢出的长文案';
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 160,
          child: TActionSheetGrid(
            items: items(2),
            subtitle: longSubtitle,
            showCancel: false,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.text(longSubtitle)).width,
      lessThanOrEqualTo(160),
    );
  });

  testWidgets('scroll layout 横向滚动分支', (tester) async {
    await tester.pumpWidget(
      wrap(
        TActionSheetGrid(
          items: items(10),
          layout: const TActionSheetGridLayout.scroll(rows: 2),
        ),
      ),
    );
    expect(find.byType(TActionSheetGrid<int>), findsOneWidget);
  });

  testWidgets('相同 count 和 rows 下默认宫格与滚动宫格密度一致', (tester) async {
    Future<double> itemWidth({required bool scrollable}) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 400,
            child: TActionSheetGrid(
              items: items(8),
              layout: scrollable
                  ? const TActionSheetGridLayout.scroll(count: 8, rows: 2)
                  : const TActionSheetGridLayout.fixed(count: 8, rows: 2),
              showCancel: false,
            ),
          ),
        ),
      );
      return tester
          .getSize(find.byType(TActionSheetItemWidget<int>).first)
          .width;
    }

    final defaultWidth = await itemWidth(scrollable: false);
    final scrollWidth = await itemWidth(scrollable: true);

    expect(defaultWidth, 100);
    expect(scrollWidth, defaultWidth);
  });

  testWidgets('scrollable 的 count=10 rows=2 首屏按两行五列排列', (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 400,
          child: TActionSheetGrid(
            items: items(12),
            layout: const TActionSheetGridLayout.scroll(count: 10, rows: 2),
            showCancel: false,
          ),
        ),
      ),
    );

    for (var index = 0; index < 10; index++) {
      expect(find.text('项$index'), findsOneWidget);
    }
    expect(find.text('项10'), findsNothing);
    expect(
      tester.getSize(find.byType(TActionSheetItemWidget<int>).first).width,
      80,
    );
    expect(
      tester.getTopLeft(find.text('项0')).dy,
      tester.getTopLeft(find.text('项4')).dy,
    );
    expect(
      tester.getTopLeft(find.text('项5')).dy,
      greaterThan(tester.getTopLeft(find.text('项0')).dy),
    );
    expect(
      tester.getCenter(find.text('项0')).dx,
      tester.getCenter(find.text('项5')).dx,
    );
    final scrollView = find.descendant(
      of: find.byType(TActionSheetGrid<int>),
      matching: find.byType(ListView),
    );
    await tester.drag(scrollView, const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('项10'), findsOneWidget);
    expect(find.text('项11'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('项10')).dy,
      tester.getTopLeft(find.text('项11')).dy,
    );
  });

  testWidgets('显式 itemMinWidth 可以扩大滚动项目并产生横向溢出', (tester) async {
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 375,
          child: TActionSheetGrid(
            items: items(10),
            layout: const TActionSheetGridLayout.scroll(
              count: 10,
              rows: 2,
              itemMinWidth: 80,
            ),
            showCancel: false,
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(TActionSheetItemWidget<int>).first).width,
      80,
    );
    final scrollable = tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byType(TActionSheetGrid<int>),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(scrollable.position.maxScrollExtent, 25);
  });

  test('count 和 rows 必须构成完整宫格', () {
    expect(
      () => TActionSheetGridLayout.fixed(count: 9, rows: 2),
      throwsAssertionError,
    );
    expect(
      () => TActionSheetGridLayout.fixed(count: 1, rows: 2),
      throwsAssertionError,
    );
    expect(() => TActionSheetGridLayout.fixed(count: 0), throwsAssertionError);
    expect(() => TActionSheetGridLayout.fixed(rows: 0), throwsAssertionError);
    expect(
      () => TActionSheetGridLayout.scroll(itemMinWidth: 0),
      throwsAssertionError,
    );
  });

  testWidgets('scrollable 空列表安全渲染', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TActionSheetGrid<int>(
          items: [],
          layout: TActionSheetGridLayout.scroll(rows: 2),
        ),
      ),
    );

    expect(find.byType(TActionSheetGrid<int>), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('paged layout 分页 + 翻页触发回调', (tester) async {
    int? selectedValue;
    await tester.pumpWidget(
      wrap(
        TActionSheetGrid(
          items: items(12),
          layout: const TActionSheetGridLayout.paged(count: 8, rows: 2),
          onSelected: (item) => selectedValue = item.value,
        ),
      ),
    );
    expect(find.byType(TActionSheetGrid<int>), findsOneWidget);
    final token = TThemeData.defaultData();
    final dotColors = tester
        .widgetList<Container>(find.byType(Container))
        .map((container) => container.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.shape == BoxShape.circle)
        .map((decoration) => decoration.color)
        .toList();
    expect(dotColors, contains(token.brandNormalColor));
    expect(dotColors, contains(token.textDisabledColor));
    // 翻页（左滑）触发 onPageChanged
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.byType(TActionSheetGrid<int>), findsOneWidget);
    await tester.tap(find.text('项10'));
    expect(selectedValue, 10);
  });

  testWidgets('scroll layout 跨面板点击返回稳定业务值', (tester) async {
    int? selectedValue;
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 400,
          child: TActionSheetGrid(
            items: items(12),
            layout: const TActionSheetGridLayout.scroll(count: 10, rows: 2),
            showCancel: false,
            onSelected: (item) => selectedValue = item.value,
          ),
        ),
      ),
    );

    final scrollView = find.descendant(
      of: find.byType(TActionSheetGrid<int>),
      matching: find.byType(ListView),
    );
    await tester.drag(scrollView, const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('项11'));

    expect(selectedValue, 11);
  });

  testWidgets('fixed layout 走默认 grid', (tester) async {
    await tester.pumpWidget(wrap(TActionSheetGrid(items: items(4))));
    expect(find.byType(TActionSheetGrid<int>), findsOneWidget);
  });

  testWidgets('默认 grid 超出 count 时可纵向滚动', (tester) async {
    await tester.pumpWidget(
      wrap(
        TActionSheetGrid(
          items: items(12),
          layout: const TActionSheetGridLayout.fixed(count: 8, rows: 2),
        ),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    expect(grid.physics, isNot(const NeverScrollableScrollPhysics()));
    expect(tester.takeException(), isNull);
  });
}
