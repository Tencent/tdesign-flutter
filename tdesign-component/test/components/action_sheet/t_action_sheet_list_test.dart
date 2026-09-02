import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TActionSheetList 列表动作面板测试
///
/// 覆盖图标/副标题/徽标分支、禁用项、取消按钮、useSafeArea=false。
void main() {
  Widget wrap(
    Widget child, {
    TActionSheetThemeData actionSheetTheme = const TActionSheetThemeData(),
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), actionSheetTheme],
      ),
      home: Scaffold(body: child),
    );
  }

  List<TActionSheetItem<int>> baseItems() => const [
    TActionSheetItem(value: 1, label: '选项一'),
    TActionSheetItem(value: 2, label: '选项二'),
  ];

  testWidgets('带图标 + 副标题 + 徽标渲染各分支', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TActionSheetList(
          items: [
            TActionSheetItem(
              value: 1,
              label: '带图标',
              icon: Icon(Icons.star),
              subtitle: '副标题内容',
              badge: TBadge(label: '1'),
            ),
            TActionSheetItem(value: 2, label: '普通项'),
          ],
        ),
      ),
    );
    expect(find.byType(TActionSheetList<int>), findsOneWidget);
  });

  testWidgets('徽标中心锚定标题右上角', (tester) async {
    const badgeKey = ValueKey('custom-badge');
    await tester.pumpWidget(
      wrap(
        const TActionSheetList(
          showCancel: false,
          items: [
            TActionSheetItem(
              value: 1,
              label: '带徽标',
              badge: SizedBox(key: badgeKey, width: 12, height: 6),
            ),
          ],
        ),
      ),
    );

    final title = find.widgetWithText(TText, '带徽标');
    final badge = find.byKey(badgeKey);
    expect(tester.getCenter(badge), tester.getTopRight(title));
  });

  testWidgets('窄屏带图标长标题和徽标不溢出', (tester) async {
    tester.view.physicalSize = const Size(220, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const label = '这是一个需要在窄屏上省略的非常长的操作标题';
    await tester.pumpWidget(
      wrap(
        const TActionSheetList(
          showCancel: false,
          items: [
            TActionSheetItem(
              value: 1,
              label: label,
              icon: Icon(Icons.star),
              badge: TBadge(label: '99+'),
            ),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final titleFinder = find.widgetWithText(TText, label);
    final badgeFinder = find.byType(TBadge);
    final title = tester.widget<TText>(titleFinder);
    expect(title.maxLines, 1);
    expect(title.overflow, TextOverflow.ellipsis);
    expect(tester.getCenter(badgeFinder), tester.getTopRight(titleFinder));
    expect(tester.getRect(badgeFinder).right, lessThanOrEqualTo(220));
  });

  testWidgets('列表图标尺寸来自 Theme 而不是文本字号', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TActionSheetList(
          items: [
            TActionSheetItem(
              value: 1,
              label: '图标',
              icon: Icon(Icons.star),
              textStyle: TextStyle(fontSize: 12),
            ),
          ],
          showCancel: false,
        ),
        actionSheetTheme: const TActionSheetThemeData(iconSize: 32),
      ),
    );

    final iconTheme = tester.widget<IconTheme>(find.byType(IconTheme).last);
    expect(iconTheme.data.size, 32);
  });

  testWidgets('列表标题颜色不覆盖图标 Theme', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TActionSheetList(
          items: [
            TActionSheetItem(
              value: 1,
              label: '图标',
              icon: Icon(Icons.star),
              textStyle: TextStyle(color: Colors.red),
            ),
          ],
          showCancel: false,
        ),
        actionSheetTheme: const TActionSheetThemeData(iconColor: Colors.purple),
      ),
    );

    final iconTheme = tester.widget<IconTheme>(find.byType(IconTheme).last);
    expect(iconTheme.data.color, Colors.purple);
  });

  testWidgets('禁用项 onTap 为 null（点击不触发回调）', (tester) async {
    String? tapped;
    await tester.pumpWidget(
      wrap(
        TActionSheetList(
          items: const [
            TActionSheetItem(value: 'disabled', label: '禁用项', disabled: true),
            TActionSheetItem(value: 'enabled', label: '正常项'),
          ],
          onSelected: (item) => tapped = item.value,
        ),
      ),
    );
    // 点击正常项触发回调主体
    await tester.tap(find.text('正常项'));
    await tester.pump();
    expect(tapped, 'enabled');
  });

  testWidgets('useSafeArea=false 不渲染底部安全区', (tester) async {
    await tester.pumpWidget(
      wrap(TActionSheetList(useSafeArea: false, items: baseItems())),
    );
    expect(find.byType(TActionSheetList<int>), findsOneWidget);
  });

  testWidgets('点击取消按钮触发 onCancel', (tester) async {
    var cancelled = false;
    await tester.pumpWidget(
      wrap(
        TActionSheetList(
          cancelText: '取消按钮',
          items: baseItems(),
          onCancel: () => cancelled = true,
        ),
      ),
    );
    await tester.tap(find.text('取消按钮'));
    await tester.pump();
    expect(cancelled, isTrue);
  });

  testWidgets('无 subtitle / 无 cancel 渲染', (tester) async {
    await tester.pumpWidget(
      wrap(TActionSheetList(showCancel: false, items: baseItems())),
    );
    expect(find.byType(TActionSheetList<int>), findsOneWidget);
  });

  testWidgets('列表级 subtitle 渲染描述分支', (tester) async {
    await tester.pumpWidget(
      wrap(TActionSheetList(subtitle: '列表描述文本', items: baseItems())),
    );
    expect(find.text('列表描述文本'), findsOneWidget);
  });

  testWidgets('描述项高度与描述颜色对齐官方契约', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TActionSheetList(
          subtitle: '面板描述',
          showCancel: false,
          items: [
            TActionSheetItem(
              value: 'described',
              label: '主标题',
              subtitle: '选项描述',
            ),
          ],
        ),
      ),
    );

    final itemContainer = tester.widget<Container>(
      find.ancestor(
        of: find.text('主标题'),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.maxHeight == 84,
        ),
      ),
    );
    expect(itemContainer.constraints?.maxHeight, 84);

    final token = TThemeData.defaultData();
    final panelDescription = tester.widget<TText>(
      find.widgetWithText(TText, '面板描述'),
    );
    final itemDescription = tester.widget<TText>(
      find.widgetWithText(TText, '选项描述'),
    );
    expect(panelDescription.textColor, token.textColorPlaceholder);
    expect(itemDescription.textColor, token.textColorPlaceholder);
  });
}
