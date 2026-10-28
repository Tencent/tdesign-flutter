import 'package:flutter/material.dart';

import 't_steps.dart';
import 't_steps_mode.dart';
import 't_steps_vertical_item.dart';

/// Steps步骤条，垂直步骤
class TStepsVertical extends StatelessWidget {
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
  /// 与旧参数同时提供时优先使用本参数。
  // ignore: deprecated_member_use_from_same_package
  ValueChanged<int>? get onStepTapped => _onStepTapped ?? onChange;

  final ValueChanged<int>? _onStepTapped;
  final ValueChanged<int>? _onChange;

  /// 已废弃，此为兼容入口。请使用 [onStepTapped]；将在 2.0.0 删除。
  @Deprecated('Use onStepTapped instead. Deprecated in 1.1.0; remove in 2.0.0.')
  ValueChanged<int>? get onChange => _onChange;

  const TStepsVertical({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.indicator,
    required this.mode,
    @Deprecated(
      'Use onStepTapped instead. Deprecated in 1.1.0; remove in 2.0.0.',
    )
    ValueChanged<int>? onChange,
    ValueChanged<int>? onStepTapped,
  }) : _onStepTapped = onStepTapped,
       _onChange = onStepTapped ?? onChange;

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
        indicator: indicator,
        mode: mode,
        onTap: onStepTapped == null ? null : () => onStepTapped?.call(item.key),
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stepsVerticalItem,
    );
  }
}
