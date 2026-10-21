import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 打开 ActionSheet 列表浮层。
///
/// 每个用例使用独立的按钮文案与全新 Navigator，并在用例结束前通过
/// [closeActionSheet] 关闭浮层，避免 `TActionSheet` 内部静态 handle 的
/// `isShowing` 状态跨用例残留导致后续用例浮层无法打开。
Future<void> pumpActionSheet(
  WidgetTester tester, {
  required List<TActionSheetItem> items,
  required String buttonText,
}) async {
  late BuildContext hostContext;
  await tester.pumpWidget(
    MaterialApp(
      home: TTheme(
        data: TThemeData.defaultData(),
        child: Scaffold(
          body: Builder(
            builder: (context) {
              hostContext = context;
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    TActionSheet(
                      hostContext,
                      visible: true,
                      items: items,
                    );
                  },
                  child: Text(buttonText),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text(buttonText));
  await tester.pumpAndSettle();
}

/// 关闭当前展示的浮层并等待动画结束，重置静态 handle 状态。
Future<void> closeActionSheet(WidgetTester tester) async {
  final cancelFinder = find.text('取消');
  if (cancelFinder.evaluate().isNotEmpty) {
    await tester.tap(cancelFinder);
    await tester.pumpAndSettle();
  }
}

void main() {
  group('TActionSheetList 徽标位置', () {
    testWidgets('徽标渲染在列表项中（message 类型）', (tester) async {
      await pumpActionSheet(
        tester,
        buttonText: 'open-1',
        items: [
          TActionSheetItem(
            label: '选项一',
            badge: TBadge(TBadgeType.message, count: '8'),
          ),
          TActionSheetItem(label: '选项二'),
        ],
      );

      // 标题与徽标均正常渲染
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      // 未设置徽标的选项正常渲染
      expect(find.text('选项二'), findsOneWidget);
      // 徽标位于右上角定位容器中（负偏移 Positioned，非面板全屏占位）
      final badgePositioned = tester.widgetList<Positioned>(
        find.ancestor(
          of: find.text('8'),
          matching: find.byType(Positioned),
        ),
      );
      expect(
        badgePositioned,
        anyElement(
          isA<Positioned>()
              .having((p) => p.top, 'top', lessThan(0))
              .having((p) => p.right, 'right', lessThan(0)),
        ),
      );

      await closeActionSheet(tester);
    });

    testWidgets('红点徽标正常渲染（redPoint 类型）', (tester) async {
      await pumpActionSheet(
        tester,
        buttonText: 'open-2',
        items: [
          TActionSheetItem(
            label: '选项一',
            badge: TBadge(TBadgeType.redPoint),
          ),
        ],
      );

      expect(find.text('选项一'), findsOneWidget);
      // 红点尺寸为 8x8（TBadgeSize.small / 2）
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.maxWidth == 8.0,
        ),
        findsAtLeastNWidgets(1),
      );

      await closeActionSheet(tester);
    });

    testWidgets('带副标题的列表项徽标仍然渲染', (tester) async {
      await pumpActionSheet(
        tester,
        buttonText: 'open-3',
        items: [
          TActionSheetItem(
            label: '选项一',
            description: '描述文本',
            badge: TBadge(TBadgeType.message, count: '99+'),
          ),
        ],
      );

      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('描述文本'), findsOneWidget);
      expect(find.text('99+'), findsOneWidget);

      await closeActionSheet(tester);
    });

    testWidgets('禁用态列表项徽标仍然渲染', (tester) async {
      await pumpActionSheet(
        tester,
        buttonText: 'open-4',
        items: [
          TActionSheetItem(
            label: '选项一',
            disabled: true,
            badge: TBadge(TBadgeType.message, count: '8'),
          ),
        ],
      );

      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);

      await closeActionSheet(tester);
    });

    testWidgets('徽标 Positioned 位于标题右上角（负偏移定位）', (tester) async {
      await pumpActionSheet(
        tester,
        buttonText: 'open-5',
        items: [
          TActionSheetItem(
            label: '选项一',
            badge: TBadge(TBadgeType.message, count: '8'),
          ),
        ],
      );

      final badgePositioned = tester
          .widgetList<Positioned>(
            find.ancestor(
              of: find.text('8'),
              matching: find.byType(Positioned),
            ),
          )
          .firstWhere(
            (p) => p.top != null || p.right != null,
            orElse: () => const Positioned(child: SizedBox.shrink()),
          );
      // 右上角定位：top/right 均为负偏移（徽标中心对齐标题右上角）
      expect(badgePositioned.top, lessThanOrEqualTo(0));
      expect(badgePositioned.right, lessThanOrEqualTo(0));

      await closeActionSheet(tester);
    });

    testWidgets('点击带徽标的选项正常关闭浮层', (tester) async {
      await pumpActionSheet(
        tester,
        buttonText: 'open-6',
        items: [
          TActionSheetItem(
            label: '选项一',
            badge: TBadge(TBadgeType.message, count: '8'),
          ),
        ],
      );

      await tester.tap(find.text('选项一'));
      await tester.pumpAndSettle();

      // 点击后浮层关闭
      expect(find.text('选项一'), findsNothing);

      await closeActionSheet(tester);
    });
  });
}
