import 'package:flutter/material.dart';

import 't_steps_horizontal.dart';
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
         'title, content, customContent needs at least one non-empty value',
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

/// 步骤条视觉形态。
enum TStepsVariant {
  /// 默认的数字或图标步骤条。
  defaultTheme,

  /// 点状步骤条，状态仍由 [TSteps.value] 和 [TSteps.status] 决定。
  dot,

  /// 纯展示时间线，所有节点与连接线均使用完成态视觉。
  display,
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
  const TSteps({
    super.key,
    required this.steps,
    this.value = 0,
    this.direction = TStepsDirection.horizontal,
    this.status = TStepsStatus.process,
    this.variant = TStepsVariant.defaultTheme,
    this.onChange,
  });

  /// 步骤条数据
  final List<TStepsItemData> steps;

  /// 步骤条方向
  final TStepsDirection direction;

  /// 步骤条当前激活的索引；越界值会收敛到有效范围。
  final int value;

  /// 当前 [value] 对应步骤的状态。
  final TStepsStatus status;

  /// 步骤条视觉形态。
  final TStepsVariant variant;

  /// 用户选择步骤时触发；为空时组件为只读，通过更新 [value] 实现受控模式。
  ///
  /// 垂直步骤条设置回调后会显示右侧箭头并允许选择。
  final ValueChanged<int>? onChange;

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
            variant: variant,
            onChange: onChange,
          )
        : TStepsVertical(
            steps: steps,
            activeIndex: currentActiveIndex,
            status: status,
            variant: variant,
            onChange: onChange,
          );
  }
}
