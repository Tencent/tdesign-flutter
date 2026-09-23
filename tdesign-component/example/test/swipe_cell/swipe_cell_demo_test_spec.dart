import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/swipe_cell/swipe_cell_page.dart';

import '../demo_page_test_utils.dart';

class SwipeCellDemoScenario {
  const SwipeCellDemoScenario({
    required this.id,
    required this.label,
    required this.side,
    this.actionLabel,
  });
  final String id;
  final String label;
  final TSwipeCellSide side;
  final String? actionLabel;
}

const swipeCellDemoItems = ['左滑操作', '右滑操作', '左右滑操作', '带图标的滑动操作'];

const swipeCellDemoScenarios = [
  SwipeCellDemoScenario(
    id: 'end_single',
    label: '左滑单操作',
    side: TSwipeCellSide.end,
    actionLabel: '删除',
  ),
  SwipeCellDemoScenario(
    id: 'end_large',
    label: '左滑大列表',
    side: TSwipeCellSide.end,
    actionLabel: '删除',
  ),
  SwipeCellDemoScenario(
    id: 'end_double',
    label: '左滑双操作',
    side: TSwipeCellSide.end,
    actionLabel: '编辑',
  ),
  SwipeCellDemoScenario(
    id: 'end_multiple',
    label: '左滑多操作',
    side: TSwipeCellSide.end,
    actionLabel: '收藏',
  ),
  SwipeCellDemoScenario(
    id: 'start_single',
    label: '右滑单操作',
    side: TSwipeCellSide.start,
    actionLabel: '选择',
  ),
  SwipeCellDemoScenario(
    id: 'both_start',
    label: '左右滑操作',
    side: TSwipeCellSide.start,
    actionLabel: '选择',
  ),
  SwipeCellDemoScenario(
    id: 'both_end',
    label: '左右滑操作',
    side: TSwipeCellSide.end,
    actionLabel: '删除',
  ),
  SwipeCellDemoScenario(
    id: 'icon_text',
    label: '左滑-带图标文本双操作',
    side: TSwipeCellSide.end,
    actionLabel: '编辑',
  ),
  SwipeCellDemoScenario(
    id: 'icon_only',
    label: '左滑-仅带图标双操作',
    side: TSwipeCellSide.end,
  ),
];

const swipeCellDemoPageTestSpec = DemoPageTestSpec(
  name: 'swipe_cell',
  title: 'SwipeCell 滑动操作',
  page: TSwipeCellPage(),
  expectedTexts: ['01 组件类型'],
  componentType: TSwipeCell,
  expectedComponentCount: 8,
);

Future<void> openSwipeCellScenario(
  WidgetTester tester,
  SwipeCellDemoScenario scenario,
) async {
  final label = find.descendant(
    of: find.byType(TSwipeCell),
    matching: find.text(scenario.label),
  );
  final scrollable = find
      .descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      )
      .first;
  await tester.scrollUntilVisible(label, 240, scrollable: scrollable);
  await tester.pumpAndSettle();
  final cell = find.ancestor(of: label, matching: find.byType(TSwipeCell));
  await tester.drag(
    cell,
    Offset(scenario.side == TSwipeCellSide.end ? -260 : 260, 0),
  );
  await tester.pumpAndSettle();
}
