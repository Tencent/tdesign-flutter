import 'package:flutter/material.dart';

import 't_steps.dart';
import 't_steps_vertical_item.dart';

/// Steps步骤条，垂直步骤
class TStepsVertical extends StatelessWidget {
  /// 步骤条数据列表
  final List<TStepsItemData> steps;

  /// 当前激活的步骤索引
  final int activeIndex;

  /// 步骤条状态
  final TStepsStatus status;

  /// 是否为简略模式
  final bool simple;

  /// 是否为只读模式（纯展示）
  final bool readOnly;

  /// 垂直模式下是否可点击选择
  final bool verticalSelect;

  const TStepsVertical({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    required this.verticalSelect,
  });

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;
    List<Widget> stepsVerticalItem = steps.asMap().entries.map((item) {
      return TStepsVerticalItem(
        index: item.key,
        data: item.value,
        stepsCount: stepsCount,
        activeIndex: activeIndex,
        status: status,
        simple: simple,
        readOnly: readOnly,
        verticalSelect: verticalSelect,
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stepsVerticalItem,
    );
  }
}
