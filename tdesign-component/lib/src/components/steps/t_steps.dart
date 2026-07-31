import 'package:flutter/material.dart';

import 't_steps_horizontal.dart';
import 't_steps_theme_data.dart';
import 't_steps_vertical.dart';

/// Steps步骤条数据类型
class TStepsItemData {
  TStepsItemData({
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
enum TStepsDirection {
  /// 水平方向
  horizontal,

  /// 垂直方向
  vertical,
}

/// steps步骤条状态
enum TStepsStatus {
  /// 成功状态
  success,

  /// 错误状态
  error,
}

/// Steps步骤条
class TSteps extends StatefulWidget {
  const TSteps({
    super.key,
    required this.steps,
    this.value = 0,
    this.direction = TStepsDirection.horizontal,
    this.status = TStepsStatus.success,
    this.simple,
    this.readOnly,
    this.verticalSelect,
    this.onChange,
  });

  /// 步骤条数据
  final List<TStepsItemData> steps;

  /// 步骤条方向
  final TStepsDirection direction;

  /// 步骤条当前激活的索引
  final int value;

  /// 步骤条状态。
  final TStepsStatus status;

  /// 步骤条simple模式（优先级高于 ThemeData）
  final bool? simple;

  /// 步骤条readOnly模式（优先级高于 ThemeData）
  final bool? readOnly;

  /// 步骤条垂直自定义步骤条选择模式（优先级高于 ThemeData）
  final bool? verticalSelect;

  /// 用户选择步骤时触发；通过更新 [value] 实现受控模式。
  final ValueChanged<int>? onChange;

  /// 子树级主题数据（v1.0 新增）

  @override
  _TStepsState createState() => _TStepsState();
}

class _TStepsState extends State<TSteps> {
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
    final theme = Theme.of(context).extension<TStepsThemeData>();
    final effectiveIndex = widget.value;
    final effectiveSimple = widget.simple ?? theme?.simple ?? false;
    final effectiveReadOnly = widget.readOnly ?? theme?.readOnly ?? false;
    final effectiveVerticalSelect =
        widget.verticalSelect ?? theme?.verticalSelect ?? false;

    /// 当前激活的step索引
    final currentActiveIndex = _clampActiveIndex(
      effectiveIndex,
      widget.steps.length,
    );

    return widget.direction == TStepsDirection.horizontal
        ? TStepsHorizontal(
            steps: widget.steps,
            activeIndex: currentActiveIndex,
            status: widget.status,
            simple: effectiveSimple,
            readOnly: effectiveReadOnly,
            onChange: widget.onChange)
        : TStepsVertical(
            steps: widget.steps,
            activeIndex: currentActiveIndex,
            status: widget.status,
            simple: effectiveSimple,
            readOnly: effectiveReadOnly,
            verticalSelect: effectiveVerticalSelect,
            onChange: widget.onChange,
          );
  }
}
