import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_item_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/action_sheet/action_sheet_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import '../demo_page_test_utils.dart';
import 'action_sheet_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(actionSheetDemoPageTestSpec);

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TActionSheetPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Finder pageScrollable() => find.descendant(
    of: find.byType(CustomScrollView),
    matching: find.byType(Scrollable),
  );

  Future<void> openBasicGrid(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '常规宫格型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.ensureVisible(trigger);
    await tester.pumpAndSettle();
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openBasicList(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '常规列表型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openDescribedList(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '带描述列表型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openBadgeList(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '带徽标列表型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openScrollGrid(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '多行滚动宫格型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.ensureVisible(trigger);
    await tester.pumpAndSettle();
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  Future<void> openGrid(WidgetTester tester, String label) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, label);
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: pageScrollable().first,
    );
    await tester.ensureVisible(trigger);
    await tester.pumpAndSettle();
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  testWidgets('官方 Demo 矩阵公开展示全部场景', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    const labels = [
      '常规列表型',
      '带描述列表型',
      '带图标列表型',
      '带徽标列表型',
      '常规宫格型',
      '带描述宫格型',
      '带翻页宫格型',
      '带徽标宫格型',
      '多行滚动宫格型',
      '带描述多行滚动宫格型',
      '列表型选项状态',
      '居中列表型',
      '左对齐列表型',
    ];
    final position = tester
        .state<ScrollableState>(pageScrollable().first)
        .position;
    final foundLabels = <String>{};
    for (var offset = 0.0; offset <= position.maxScrollExtent; offset += 200) {
      position.jumpTo(offset.clamp(0, position.maxScrollExtent));
      await tester.pump();
      for (final label in labels) {
        if (find.widgetWithText(TButton, label).evaluate().isNotEmpty) {
          foundLabels.add(label);
        }
      }
    }
    position.jumpTo(position.maxScrollExtent);
    await tester.pump();
    for (final label in labels) {
      if (find.widgetWithText(TButton, label).evaluate().isNotEmpty) {
        foundLabels.add(label);
      }
    }
    expect(foundLabels, containsAll(labels));
    expect(find.text('单元测试'), findsNothing);
  });

  testWidgets('触发按钮按 Figma 顺序使用 16dp 边距和 8dp 间距连续排列', (tester) async {
    tester.view.physicalSize = const Size(375, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    const labels = [
      '常规列表型',
      '带描述列表型',
      '带图标列表型',
      '带徽标列表型',
      '常规宫格型',
      '带描述宫格型',
      '带翻页宫格型',
      '带徽标宫格型',
      '多行滚动宫格型',
      '带描述多行滚动宫格型',
    ];
    final triggers = labels
        .map((label) => find.widgetWithText(TButton, label))
        .toList();
    final rects = triggers.map(tester.getRect).toList();
    for (final rect in rects) {
      expect(rect.left, 16);
      expect(rect.right, 359);
      expect(rect.height, 48);
    }
    for (var index = 1; index < rects.length; index++) {
      final gap = rects[index].top - rects[index - 1].bottom;
      if (index == 4) {
        expect(gap, greaterThan(8));
      } else {
        expect(gap, 8);
      }
    }
  });

  testWidgets('常规宫格型在手机视口完整展示且不溢出', (tester) async {
    configurePhone(tester);

    await openBasicGrid(tester);

    expect(find.byType(TActionSheetGrid<String>), findsOneWidget);
    expect(find.text('WeChat'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('常规宫格与多行滚动宫格首屏 Item 视觉一致', (tester) async {
    configurePhone(tester);

    Future<
      ({
        Size itemSize,
        Size iconSlotSize,
        Size iconSize,
        double iconTextGap,
        TextStyle textStyle,
      })
    >
    readMetrics(Future<void> Function(WidgetTester) open) async {
      await open(tester);
      final item = find
          .ancestor(
            of: find.text('WeChat'),
            matching: find.byType(TActionSheetItemWidget<String>),
          )
          .first;
      final iconSlot = find
          .descendant(
            of: item,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is SizedBox &&
                  widget.width == 40 &&
                  widget.height == 40,
            ),
          )
          .first;
      final icon = find
          .descendant(of: item, matching: find.byType(Image))
          .first;
      final label = find
          .descendant(
            of: item,
            matching: find.byWidgetPredicate(
              (widget) => widget is TText && widget.data == 'WeChat',
            ),
          )
          .first;
      final labelWidget = tester.widget<TText>(label);
      final metrics = (
        itemSize: tester.getSize(item),
        iconSlotSize: tester.getSize(iconSlot),
        iconSize: tester.getSize(icon),
        iconTextGap:
            tester.getTopLeft(label).dy - tester.getBottomLeft(iconSlot).dy,
        textStyle: labelWidget.getTextStyle(tester.element(label)),
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      return metrics;
    }

    final basic = await readMetrics(openBasicGrid);
    final scroll = await readMetrics(openScrollGrid);

    expect(basic.itemSize.width, 93.75);
    expect(scroll.itemSize.width, 80);
    expect(scroll.itemSize.height, basic.itemSize.height);
    expect(scroll.iconSlotSize, basic.iconSlotSize);
    expect(scroll.iconSlotSize, const Size.square(40));
    expect(scroll.iconSize, basic.iconSize);
    expect(scroll.iconSize, const Size.square(39));
    expect(scroll.iconTextGap, basic.iconTextGap);
    expect(scroll.iconTextGap, 8);
    expect(scroll.textStyle.fontSize, basic.textStyle.fontSize);
    expect(scroll.textStyle.height, basic.textStyle.height);
    expect(scroll.textStyle.fontWeight, basic.textStyle.fontWeight);
  });

  testWidgets('带描述宫格的描述文字到首行图标容器间距为 28dp', (tester) async {
    configurePhone(tester);
    await openGrid(tester, '带描述宫格型');

    final subtitle = find.text('Forward To');
    final firstIconContainer = find.byKey(
      const ValueKey('assets/img/action_sheet_wechat.png'),
    );
    expect(
      tester.getTopLeft(firstIconContainer).dy -
          tester.getBottomLeft(subtitle).dy,
      28,
    );
  });

  testWidgets('常规宫格使用设计稿品牌资源和 40dp 图标槽', (tester) async {
    configurePhone(tester);
    await openGrid(tester, '常规宫格型');

    final iconContainer = find.byKey(
      const ValueKey('assets/img/action_sheet_wechat.png'),
    );
    expect(tester.getSize(iconContainer), const Size.square(40));
    final container = tester.widget<Container>(iconContainer);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.border, isNotNull);
    expect(decoration.borderRadius, BorderRadius.circular(6));
  });

  testWidgets('带翻页宫格展示三页指示器并可滑动到下一页', (tester) async {
    configurePhone(tester);
    await openGrid(tester, '带翻页宫格型');

    expect(find.byType(PageView), findsOneWidget);
    final dots = tester.widgetList<Container>(find.byType(Container)).where((
      container,
    ) {
      final decoration = container.decoration;
      return decoration is BoxDecoration &&
          decoration.shape == BoxShape.circle &&
          container.constraints?.maxWidth == 8 &&
          container.constraints?.maxHeight == 8;
    });
    expect(dots, hasLength(3));
    await tester.drag(find.byType(PageView), const Offset(-375, 0));
    await tester.pumpAndSettle();
    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('多行滚动宫格按两行五列排列并露出第五列', (tester) async {
    configurePhone(tester);

    await openScrollGrid(tester);

    final firstRow = ['WeChat', 'QQ', 'Doc', 'Map', 'QQ Music'];
    final secondRow = ['Share', 'Collect', 'Download', 'Edit', 'Link'];
    final firstTop = tester.getTopLeft(find.text(firstRow.first)).dy;
    final secondTop = tester.getTopLeft(find.text(secondRow.first)).dy;
    for (final label in firstRow) {
      expect(tester.getTopLeft(find.text(label)).dy, firstTop);
    }
    for (final label in secondRow) {
      expect(tester.getTopLeft(find.text(label)).dy, secondTop);
    }
    expect(secondTop, greaterThan(firstTop));
    for (var column = 0; column < 5; column++) {
      expect(
        tester.getCenter(find.text(firstRow[column])).dx,
        tester.getCenter(find.text(secondRow[column])).dx,
      );
    }
    final scrollable = tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byType(TActionSheetGrid<String>),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(scrollable.position.maxScrollExtent, 25);
    expect(tester.takeException(), isNull);
  });

  testWidgets('常规列表型触发后展示内容', (tester) async {
    configurePhone(tester);

    await openBasicList(tester);

    expect(find.text('Move'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('带描述列表型完整展示描述、四个选项和取消项', (tester) async {
    configurePhone(tester);

    await openDescribedList(tester);

    expect(find.text('Email Settings'), findsOneWidget);
    for (final label in [
      'Move',
      'Mark as important',
      'Unsubscribe',
      'Add to Tasks',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Cancel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('带徽标列表型对齐官方圆点与计数数据', (tester) async {
    configurePhone(tester);

    await openBadgeList(tester);

    expect(find.byType(TBadge), findsNWidgets(4));
    expect(find.text('8'), findsOneWidget);
    expect(find.text('99'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    final badges = tester.widgetList<TBadge>(find.byType(TBadge)).toList();
    expect(badges.first.variant, TBadgeVariant.dot);
    expect(badges[1].offset, isNull);
    expect(badges[2].offset, isNull);
    expect(badges[3].offset, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('带徽标宫格型按设计稿展示 NEW、圆点与计数', (tester) async {
    configurePhone(tester);

    await openGrid(tester, '带徽标宫格型');

    TBadge badgeFor(String label) => tester.widget<TBadge>(
      find.descendant(
        of: find.ancestor(
          of: find.text(label),
          matching: find.byType(TActionSheetItemWidget<String>),
        ),
        matching: find.byType(TBadge),
      ),
    );

    expect(find.byType(TBadge), findsNWidgets(3));
    const labels = ['微信', '朋友圈', 'QQ', '企业微信', '收藏', '刷新', '下载', '复制'];
    for (final label in labels) {
      expect(find.text(label), findsOneWidget);
    }
    expect(badgeFor('微信').label, 'NEW');
    expect(badgeFor('微信').variant, TBadgeVariant.circle);
    expect(badgeFor('收藏').variant, TBadgeVariant.dot);
    expect(badgeFor('下载').label, '8');
    expect(badgeFor('下载').variant, TBadgeVariant.circle);
    expect(find.byIcon(TIcons.queue), findsOneWidget);
    expect(find.text('99+'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
