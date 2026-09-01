import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_item_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TActionSheetItemWidget 组件测试
void main() {
  Widget wrapWithTheme(
    Widget child, {
    TActionSheetThemeData? actionSheetTheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (actionSheetTheme != null) actionSheetTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TActionSheetItemWidget', () {
    testWidgets('item=null 渲染空', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TActionSheetItemWidget<int>(item: null)),
      );
      expect(find.byType(TActionSheetItemWidget<int>), findsOneWidget);
    });

    testWidgets('基础渲染 label + icon', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TActionSheetItemWidget(
            item: TActionSheetItem(
              value: 'test',
              label: '测试',
              icon: Icon(Icons.add),
            ),
          ),
        ),
      );
      expect(find.text('测试'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('disabled 时 onTap 为 null', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TActionSheetItemWidget(
            item: TActionSheetItem(
              value: 'disabled',
              label: '禁用',
              disabled: true,
            ),
          ),
        ),
      );
      expect(find.text('禁用'), findsOneWidget);
    });

    testWidgets('badge 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TActionSheetItemWidget(
            item: TActionSheetItem(
              value: 'badge',
              label: '带角标',
              icon: Icon(Icons.star),
              badge: TBadge(label: '3'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('带角标'), findsOneWidget);
    });

    testWidgets('点击触发 onSelected 并返回业务值', (tester) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithTheme(
          TActionSheetItemWidget(
            item: const TActionSheetItem(value: 'tap', label: '点击'),
            onSelected: (item) => selected = item.value,
          ),
        ),
      );
      await tester.tap(find.text('点击'));
      await tester.pumpAndSettle();
      expect(selected, 'tap');
    });

    testWidgets('默认图标字形和宫格槽位尺寸分离', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TActionSheetItemWidget(
            item: TActionSheetItem(
              value: 'style',
              label: '样式',
              icon: Icon(Icons.star),
              textStyle: TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
      expect(find.text('样式'), findsOneWidget);
      final iconTheme = tester.widget<IconTheme>(find.byType(IconTheme).last);
      expect(iconTheme.data.size, 24);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 48 && widget.height == 48,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Theme 控制默认字形、槽位和颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TActionSheetItemWidget(
            item: TActionSheetItem(
              value: 'icon',
              label: '图标',
              icon: Icon(Icons.star),
            ),
          ),
          actionSheetTheme: const TActionSheetThemeData(
            iconSize: 32,
            gridIconExtent: 56,
            iconColor: Colors.purple,
          ),
        ),
      );

      final iconTheme = tester.widget<IconTheme>(find.byType(IconTheme).last);
      expect(iconTheme.data.size, 32);
      expect(iconTheme.data.color, Colors.purple);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 56 && widget.height == 56,
        ),
        findsOneWidget,
      );
    });

    testWidgets('自定义 icon Widget 的显式尺寸和颜色不被 Theme 覆盖', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TActionSheetItemWidget(
            item: TActionSheetItem(
              value: 'custom-icon',
              label: '自定义图标',
              icon: Icon(Icons.star, size: 18, color: Colors.green),
            ),
          ),
          actionSheetTheme: const TActionSheetThemeData(
            iconSize: 32,
            iconColor: Colors.purple,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 18);
      expect(icon.color, Colors.green);
      expect(find.byType(FittedBox), findsNothing);
    });
  });

  group('getMainAxisAlignment', () {
    test('各 align 值', () {
      expect(
        getMainAxisAlignment(TActionSheetAlign.left),
        MainAxisAlignment.start,
      );
      expect(
        getMainAxisAlignment(TActionSheetAlign.right),
        MainAxisAlignment.end,
      );
      expect(
        getMainAxisAlignment(TActionSheetAlign.center),
        MainAxisAlignment.center,
      );
    });
  });

  group('buildCancelButton', () {
    testWidgets('showPagination=true', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final widget = buildCancelButton(ctx, true, '取消', () {});
      final divider = widget as Container;
      expect(divider.color, TThemeData.defaultData().bgColorPage);
      expect(
        (divider.padding! as EdgeInsets).top,
        TThemeData.defaultData().spacer16,
      );
      await tester.pumpWidget(wrapWithTheme(widget));
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('showPagination=false + cancelText=null', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final widget = buildCancelButton(ctx, false, null, null);
      final divider = widget as Container;
      expect(divider.color, TThemeData.defaultData().bgColorPage);
      expect(
        (divider.padding! as EdgeInsets).top,
        TThemeData.defaultData().spacer8,
      );
      await tester.pumpWidget(wrapWithTheme(widget));
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
