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

  /// 步骤条视觉形态。
  final TStepsVariant variant;

  /// 选择步骤回调。
  final ValueChanged<int>? onChange;

  const TStepsVertical({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.variant,
    this.onChange,
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
        variant: variant,
        selectable: onChange != null,
        onTap: onChange == null ? null : () => onChange?.call(item.key),
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stepsVerticalItem,
    );
  }
}
