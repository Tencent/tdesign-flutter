import 'package:flutter/material.dart';

import 't_steps_horizontal.dart';
import 't_steps_mode.dart';
import 't_steps_vertical.dart';

/// Steps步骤条数据类型
class TStepsItemData {
  const TStepsItemData({
    this.title,
    this.content,
    this.icon,
    this.errorIcon,
    this.customContent,
    this.customTitle,
  }) : assert(
         title != null ||
             customTitle != null ||
             content != null ||
             customContent != null,
         'title, customTitle, content, or customContent must be provided',
       );

  /// 标题
  final String? title;

  /// 内容
  final String? content;

  /// 步骤图标；未设置时使用数字或状态图标。
  final IconData? icon;

  /// 失败图标
  final IconData? errorIcon;

  /// 自定义内容
  final Widget? customContent;

  /// 自定义标题
  final Widget? customTitle;
}

/// Steps步骤条方向
enum TStepsDirection {
  /// 水平方向
  horizontal,

  /// 垂直方向
  vertical,
}

/// 步骤条指示器样式。
enum TStepsIndicator {
  /// 标准的数字或图标步骤条。
  standard,

  /// 点状进度指示器；横向与纵向均以当前节点实心表达进度。
  ///
  /// 在 [TSteps.progress] 中是否传入 [TSteps.onChange] 不改变该视觉语义。
  dot,
}

/// steps步骤条状态
enum TStepsStatus {
  /// 当前步骤进行中。
  process,

  /// 错误状态
  error,
}

/// Steps步骤条
class TSteps extends StatelessWidget {
  /// 普通进度步骤条。
  ///
  /// [onChange] 为空时只读；非空时只报告用户点击的索引；当前进度仍由调用方更新 [value] 控制。
  const TSteps.progress({
    super.key,
    required this.steps,
    this.value = 0,
    this.direction = TStepsDirection.horizontal,
    this.status = TStepsStatus.process,
    this.indicator = TStepsIndicator.standard,
    this.onChange,
  }) : _mode = TStepsMode.progress;

  /// 垂直可选择步骤条。
  ///
  /// 固定使用点状指示器并显示右侧箭头：已完成节点实心，
  /// 当前与未完成节点空心。[onChange] 只报告用户选择的索引，
  /// 调用方需要更新 [value] 完成受控重建。
  const TSteps.selectable({
    super.key,
    required this.steps,
    required this.value,
    required ValueChanged<int> onChange,
  }) : direction = TStepsDirection.vertical,
       status = TStepsStatus.process,
       indicator = TStepsIndicator.dot,
       onChange = onChange,
       _mode = TStepsMode.selectable;

  /// 纯展示步骤条。
  ///
  /// 所有节点和连线均使用完成态，不接收进度、状态或交互参数。
  const TSteps.display({
    super.key,
    required this.steps,
    this.direction = TStepsDirection.vertical,
  }) : value = 0,
       status = TStepsStatus.process,
       indicator = TStepsIndicator.dot,
       onChange = null,
       _mode = TStepsMode.display;

  /// 步骤条数据
  final List<TStepsItemData> steps;

  /// 步骤条方向
  final TStepsDirection direction;

  /// 进度或可选择步骤条当前激活的索引；越界值会收敛到有效范围。
  final int value;

  /// 进度步骤条当前 [value] 对应步骤的状态。
  final TStepsStatus status;

  /// 进度步骤条的指示器样式。
  final TStepsIndicator indicator;

  /// 用户选择步骤时触发；调用方通过更新 [value] 实现受控模式。
  ///
  /// [TSteps.progress] 中为空时只读，非空时不改变指示器视觉；
  /// [TSteps.selectable] 中必填。[TSteps.display] 不接收此参数。
  final ValueChanged<int>? onChange;

  final TStepsMode _mode;

  int _clampActiveIndex(int index, int length) {
    if (index < 0) {
      return 0;
    }
    if (index >= length) {
      return length > 0 ? length - 1 : 0;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    /// 当前激活的step索引
    final currentActiveIndex = _clampActiveIndex(value, steps.length);

    return direction == TStepsDirection.horizontal
        ? TStepsHorizontal(
            steps: steps,
            activeIndex: currentActiveIndex,
            status: status,
            indicator: indicator,
            mode: _mode,
            onChange: onChange,
          )
        : TStepsVertical(
            steps: steps,
            activeIndex: currentActiveIndex,
            status: status,
            indicator: indicator,
            mode: _mode,
            onChange: onChange,
          );
  }
}
