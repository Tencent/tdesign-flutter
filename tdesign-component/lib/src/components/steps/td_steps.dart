import 'package:flutter/material.dart';

import 'td_steps_horizontal.dart';
import 'td_steps_vertical.dart';

/// Steps步骤条数据类型
class TDStepsItemData {
  TDStepsItemData({
    this.title,
    this.content,
    this.successIcon,
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

  /// 成功图标
  final IconData? successIcon;

  /// 失败图标
  final IconData? errorIcon;

  /// 自定义内容
  final Widget? customContent;

  /// 自定义标题
  final Widget? customTitle;
}

/// Steps步骤条方向
enum TDStepsDirection {
  horizontal,
  vertical,
}

/// steps步骤条状态
enum TDStepsStatus {
  success,
  error,
}

/// Steps步骤条
class TDSteps extends StatefulWidget {
  const TDSteps({
    super.key,
    required this.steps,
    this.activeIndex = 0,
    this.direction = TDStepsDirection.horizontal,
    this.status = TDStepsStatus.success,
    this.simple = false,
    this.readOnly = false,
    this.verticalSelect = false,
  });

  /// 步骤条数据
  final List<TDStepsItemData> steps;

  /// 步骤条方向
  final TDStepsDirection direction;

  /// 步骤条当前激活的索引
  final int activeIndex;

  /// 步骤条状态
  final TDStepsStatus status;

  /// 步骤条simple模式
  final bool simple;

  /// 步骤条readOnly模式
  final bool readOnly;

  /// 步骤条垂直自定义步骤条选择模式
  final bool verticalSelect;

  @override
  _TDStepsState createState() => _TDStepsState();
}

class _TDStepsState extends State<TDSteps> {
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
    final currentActiveIndex = _clampActiveIndex(
      widget.activeIndex,
      widget.steps.length,
    );

    return widget.direction == TDStepsDirection.horizontal
        ? TDStepsHorizontal(
            steps: widget.steps,
            activeIndex: currentActiveIndex,
            status: widget.status,
            simple: widget.simple,
            readOnly: widget.readOnly)
        : TDStepsVertical(
            steps: widget.steps,
            activeIndex: currentActiveIndex,
            status: widget.status,
            simple: widget.simple,
            readOnly: widget.readOnly,
            verticalSelect: widget.verticalSelect,
          );
  }
}
