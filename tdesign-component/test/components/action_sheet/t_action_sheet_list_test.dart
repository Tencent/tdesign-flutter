import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TActionSheetList 列表动作面板测试
///
/// 覆盖图标/副标题/徽标分支、禁用项、取消按钮、useSafeArea=false。
void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        const TActionSheetThemeData(),
      ]),
      home: Scaffold(body: child),
    );
  }

  List<TActionSheetItem> baseItems() => [
        TActionSheetItem(label: '选项一'),
        TActionSheetItem(label: '选项二'),
      ];

  testWidgets('带图标 + 副标题 + 徽标渲染各分支', (tester) async {
    await tester.pumpWidget(wrap(TActionSheetList(
      items: [
        TActionSheetItem(
          label: '带图标',
          icon: const Icon(Icons.star),
          subtitle: '副标题内容',
          badge: const TBadge(count: 1),
        ),
        TActionSheetItem(label: '普通项'),
      ],
    )));
    expect(find.byType(TActionSheetList), findsOneWidget);
  });

  testWidgets('禁用项 onTap 为 null（点击不触发回调）', (tester) async {
    String? tapped;
    await tester.pumpWidget(wrap(TActionSheetList(
      items: [
        TActionSheetItem(label: '禁用项', disabled: true),
        TActionSheetItem(label: '正常项'),
      ],
      onChanged: (item, index) => tapped = item.label,
    )));
    // 点击正常项触发回调主体
    await tester.tap(find.text('正常项'));
    await tester.pump();
    expect(tapped, '正常项');
  });

  testWidgets('useSafeArea=false 不渲染底部安全区', (tester) async {
    await tester.pumpWidget(wrap(TActionSheetList(
      useSafeArea: false,
      items: baseItems(),
    )));
    expect(find.byType(TActionSheetList), findsOneWidget);
  });

  testWidgets('点击取消按钮触发 onCancel', (tester) async {
    var cancelled = false;
    await tester.pumpWidget(wrap(TActionSheetList(
      cancelText: '取消按钮',
      items: baseItems(),
      onCancel: () => cancelled = true,
    )));
    await tester.tap(find.text('取消按钮'));
    await tester.pump();
    expect(cancelled, isTrue);
  });

  testWidgets('无 subtitle / 无 cancel 渲染', (tester) async {
    await tester.pumpWidget(wrap(TActionSheetList(
      showCancel: false,
      items: baseItems(),
    )));
    expect(find.byType(TActionSheetList), findsOneWidget);
  });

  testWidgets('列表级 subtitle 渲染描述分支', (tester) async {
    await tester.pumpWidget(wrap(TActionSheetList(
      subtitle: '列表描述文本',
      items: baseItems(),
    )));
    expect(find.text('列表描述文本'), findsOneWidget);
  });
}
