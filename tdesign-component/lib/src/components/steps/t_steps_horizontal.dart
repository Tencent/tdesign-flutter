import 'package:flutter/material.dart';

import 't_steps.dart';
import 't_steps_horizontal_item.dart';

/// Steps步骤条，水平步骤
class TStepsHorizontal extends StatelessWidget {
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

  /// 选择步骤回调。
  final ValueChanged<int>? onChange;

  const TStepsHorizontal({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;

    List<Widget> stepsHorizontalItem = steps.asMap().entries.map((item) {
      return Expanded(
        flex: 1,
        child: TStepsHorizontalItem(
          index: item.key,
          data: item.value,
          stepsCount: stepsCount,
          activeIndex: activeIndex,
          status: status,
          simple: simple,
          readOnly: readOnly,
          onTap: readOnly ? null : () => onChange?.call(item.key),
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }
}
