import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_group.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Future<BuildContext> pumpHost(
    WidgetTester tester, {
    TActionSheetThemeData? theme,
  }) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: theme == null
            ? TThemeBuilder.light(TThemeData.defaultData())
            : TThemeBuilder.light(
                TThemeData.defaultData(),
              ).mergeExtension(theme),
        home: Scaffold(body: SizedBox(key: key)),
      ),
    );
    return key.currentContext!;
  }

  List<TActionSheetItem> items() => [
    TActionSheetItem(label: '拍照'),
    TActionSheetItem(label: '相册'),
  ];

  group('TActionSheet 命令式入口', () {
    testWidgets('showList 返回句柄并在选择后关闭', (tester) async {
      final context = await pumpHost(tester);
      TActionSheetItem? selected;
      var selectedIndex = -1;

      final handle = TActionSheet.showList(
        context,
        items: items(),
        onChanged: (item, index) {
          selected = item;
          selectedIndex = index;
        },
      );
      await tester.pumpAndSettle();

      expect(handle.isShowing, isTrue);
      expect(find.byType(TActionSheetList), findsOneWidget);
      expect(find.text('拍照'), findsOneWidget);

      await tester.tap(find.text('相册'));
      await tester.pumpAndSettle();
      expect(selected?.label, '相册');
      expect(selectedIndex, 1);
      expect(handle.isShowing, isFalse);
    });

    testWidgets('关闭动画期间重复点击不会重复回调或弹出宿主页', (tester) async {
      final context = await pumpHost(tester);
      var changedCount = 0;
      TActionSheet.showList(
        context,
        items: items(),
        onChanged: (_, __) => changedCount++,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('拍照'));
      await tester.tap(find.text('拍照'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(changedCount, 1);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('showList 继承 popup 视觉契约并收口溢出', (tester) async {
      final context = await pumpHost(
        tester,
        theme: const TActionSheetThemeData(
          barrierColor: Colors.black38,
          panelRadius: 10,
        ),
      );

      const longLabel = '这里是一段非常非常非常长的动作项标题用于验证省略号';
      final handle = TActionSheet.showList(
        context,
        items: [
          TActionSheetItem(label: longLabel),
          TActionSheetItem(label: '带描述', subtitle: '辅助说明'),
        ],
      );
      await tester.pumpAndSettle();

      final barrier = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((container) => container.color == Colors.black38);
      expect(barrier.color, Colors.black38);

      final shell = tester
          .widgetList<Container>(
            find.ancestor(
              of: find.byType(TActionSheetList),
              matching: find.byType(Container),
            ),
          )
          .firstWhere(
            (container) =>
                container.decoration is BoxDecoration &&
                (container.decoration! as BoxDecoration).borderRadius != null,
          );
      final shellDecoration = shell.decoration! as BoxDecoration;
      expect(shellDecoration.color, context.tTheme.bgColorContainer);
      expect(
        shellDecoration.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(10)),
      );

      final listContainer = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(TActionSheetList),
              matching: find.byType(Container),
            ),
          )
          .firstWhere(
            (container) =>
                container.decoration is BoxDecoration &&
                (container.decoration! as BoxDecoration).borderRadius != null,
          );
      expect(
        (listContainer.decoration! as BoxDecoration).color,
        context.tTheme.bgColorContainer,
      );

      final text = tester.widget<Text>(find.text(longLabel));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);

      final itemContainers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TActionSheetList),
          matching: find.byType(Container),
        ),
      );
      expect(
        itemContainers.any(
          (container) =>
              container.constraints?.minHeight == 56 &&
              container.constraints?.maxHeight == 56 &&
              container.decoration is BoxDecoration &&
              (container.decoration! as BoxDecoration).border != null,
        ),
        isTrue,
      );
      expect(
        itemContainers.any(
          (container) =>
              container.constraints?.minHeight == 84 &&
              container.constraints?.maxHeight == 84 &&
              container.decoration is BoxDecoration &&
              (container.decoration! as BoxDecoration).border != null,
        ),
        isTrue,
      );

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('列表描述长文案在窄宽度下可换行且不溢出', (tester) async {
      const longSubtitle = '这是用于验证动作面板描述区域在窄屏下不会横向溢出的长描述文案';
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: SizedBox(
              width: 160,
              child: TActionSheetList(
                items: items(),
                subtitle: longSubtitle,
                showCancel: false,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final textBox = tester.getRect(find.text(longSubtitle));
      expect(textBox.width, lessThanOrEqualTo(160));
    });

    testWidgets('showGrid 传递分页和尺寸配置', (tester) async {
      final context = await pumpHost(
        tester,
        theme: const TActionSheetThemeData(
          defaultAlign: TActionSheetAlign.left,
          count: 4,
          rows: 1,
          itemHeight: 88,
          itemMinWidth: 72,
        ),
      );

      final handle = TActionSheet.showGrid(
        context,
        items: items(),
        showPagination: true,
      );
      await tester.pumpAndSettle();

      final grid = tester.widget<TActionSheetGrid>(
        find.byType(TActionSheetGrid),
      );
      expect(grid.align, TActionSheetAlign.left);
      expect(grid.count, 4);
      expect(grid.rows, 1);
      expect(grid.itemHeight, 88);
      expect(grid.itemMinWidth, 72);
      expect(grid.showPagination, isTrue);
      expect(grid.useSafeArea, isFalse);

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('showGrid 按实际宫格内容计算弹窗高度', (tester) async {
      final context = await pumpHost(tester);
      final handle = TActionSheet.showGrid(
        context,
        subtitle: '选择分享方式',
        items: List.generate(
          6,
          (index) => TActionSheetItem(label: '分享方式 $index'),
        ),
      );
      await tester.pumpAndSettle();

      final positioned = tester.widgetList<Positioned>(
        find.ancestor(
          of: find.byType(TActionSheetGrid),
          matching: find.byType(Positioned),
        ),
      );
      expect(positioned.last.height, 282);
      expect(tester.takeException(), isNull);

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('showGrid 在小视口内收缩并允许纵向滚动', (tester) async {
      tester.view.physicalSize = const Size(375, 220);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final context = await pumpHost(tester);
      final handle = TActionSheet.showGrid(
        context,
        subtitle: '选择分享方式',
        items: List.generate(
          6,
          (index) => TActionSheetItem(label: '分享方式 $index'),
        ),
      );
      await tester.pumpAndSettle();

      final grid = tester.widget<GridView>(find.byType(GridView));
      expect(grid.physics, isA<AlwaysScrollableScrollPhysics>());
      expect(tester.takeException(), isNull);

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('showGroup 渲染分组内容', (tester) async {
      final context = await pumpHost(tester);
      final handle = TActionSheet.showGroup(
        context,
        items: [
          TActionSheetItem(label: '编辑', group: '常用'),
          TActionSheetItem(label: '删除', group: '危险'),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(TActionSheetGroup), findsOneWidget);
      expect(find.text('常用'), findsOneWidget);
      expect(find.text('危险'), findsOneWidget);
      expect(
        tester
            .widget<TActionSheetGroup>(find.byType(TActionSheetGroup))
            .useSafeArea,
        isFalse,
      );

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('取消按钮回调并关闭', (tester) async {
      final context = await pumpHost(tester);
      var cancelled = false;
      final handle = TActionSheet.showList(
        context,
        items: items(),
        cancelText: '取消操作',
        onCancel: () => cancelled = true,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('取消操作'));
      await tester.pumpAndSettle();
      expect(cancelled, isTrue);
      expect(handle.isShowing, isFalse);
    });

    testWidgets('句柄可主动关闭并触发 onClosed', (tester) async {
      final context = await pumpHost(tester);
      var closed = false;
      final handle = TActionSheet.showGrid(
        context,
        items: items(),
        showCancel: false,
        showOverlay: false,
        closeOnOverlayClick: false,
        useSafeArea: false,
        scrollable: true,
        onClosed: () => closed = true,
      );
      await tester.pumpAndSettle();

      handle.close();
      await tester.pumpAndSettle();
      expect(handle.isShowing, isFalse);
      expect(closed, isTrue);
    });

    testWidgets('showList 透传 useSafeArea 到底部弹层定位', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(375, 812),
            padding: EdgeInsets.only(bottom: 34),
          ),
          child: MaterialApp(
            theme: TThemeBuilder.light(TThemeData.defaultData()),
            home: Scaffold(body: SizedBox(key: key)),
          ),
        ),
      );
      final context = key.currentContext!;

      final safeHandle = TActionSheet.showList(
        context,
        items: items(),
        showCancel: false,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TActionSheetList>(find.byType(TActionSheetList))
            .useSafeArea,
        isFalse,
      );
      final safePositioned = tester.widgetList<Positioned>(
        find.ancestor(
          of: find.byType(TActionSheetList),
          matching: find.byType(Positioned),
        ),
      );
      expect(safePositioned.last.bottom, 34);
      safeHandle.close();
      await tester.pumpAndSettle();

      final unsafeHandle = TActionSheet.showList(
        context,
        items: items(),
        showCancel: false,
        useSafeArea: false,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TActionSheetList>(find.byType(TActionSheetList))
            .useSafeArea,
        isFalse,
      );
      final unsafePositioned = tester.widgetList<Positioned>(
        find.ancestor(
          of: find.byType(TActionSheetList),
          matching: find.byType(Positioned),
        ),
      );
      expect(unsafePositioned.last.bottom, 0);
      unsafeHandle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('长列表在小屏下可滚动且不溢出', (tester) async {
      final context = await pumpHost(tester);
      final handle = TActionSheet.showList(
        context,
        items: List.generate(
          20,
          (index) => TActionSheetItem(label: '选项 $index'),
        ),
        showCancel: false,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.physics, isNot(const NeverScrollableScrollPhysics()));
      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('多分组在小屏下可滚动且不溢出', (tester) async {
      final context = await pumpHost(tester);
      final handle = TActionSheet.showGroup(
        context,
        items: List.generate(
          12,
          (index) => TActionSheetItem(label: '选项 $index', group: '分组 $index'),
        ),
        showCancel: false,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final listView = tester.widget<ListView>(find.byType(ListView).first);
      expect(listView.scrollDirection, Axis.vertical);
      expect(listView.physics, isNot(const NeverScrollableScrollPhysics()));
      handle.close();
      await tester.pumpAndSettle();
    });
  });

  group('TActionSheetThemeData', () {
    test('merge/copyWith/lerp 保留视觉布局字段', () {
      const base = TActionSheetThemeData(
        defaultAlign: TActionSheetAlign.left,
        itemHeight: 80,
        count: 4,
        barrierColor: Colors.black,
        iconSize: 24,
        iconColor: Colors.blue,
      );
      const override = TActionSheetThemeData(
        itemHeight: 96,
        panelRadius: 12,
        gridIconExtent: 56,
        iconColor: Colors.red,
      );

      final merged = base.merge(override);
      expect(merged.defaultAlign, TActionSheetAlign.left);
      expect(merged.itemHeight, 96);
      expect(merged.panelRadius, 12);
      expect(merged.iconSize, 24);
      expect(merged.gridIconExtent, 56);
      expect(merged.iconColor, Colors.red);

      final copied = merged.copyWith(rows: 3);
      expect(copied.rows, 3);
      expect(copied.count, 4);

      final lerped = base.lerp(override, 0.75);
      expect(lerped.panelRadius, 9);
      expect(base.merge(null), same(base));
      expect(base.lerp(null, 0.5), same(base));
    });
  });
}
