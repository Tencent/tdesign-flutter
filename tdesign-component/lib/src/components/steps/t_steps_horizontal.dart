import 'package:flutter/material.dart';

import 't_steps.dart';
import 't_steps_horizontal_item.dart';
import 't_steps_mode.dart';

/// Steps步骤条，水平步骤
class TStepsHorizontal extends StatelessWidget {
  /// 步骤条数据列表
  final List<TStepsItemData> steps;

  /// 当前激活的步骤索引
  final int activeIndex;

  /// 步骤条状态
  final TStepsStatus status;

  /// 步骤条指示器样式。
  final TStepsIndicator indicator;

  /// 根组件已解析的使用模式。
  final TStepsMode mode;

  /// 选择步骤回调。
  final ValueChanged<int>? onChange;

  const TStepsHorizontal({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.indicator,
    required this.mode,
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
          indicator: indicator,
          mode: mode,
          onTap: onChange == null ? null : () => onChange?.call(item.key),
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }
}
