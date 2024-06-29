import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_horizontal.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_vertical.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条数据类型
class TDStepsItemData {
  final String title;
  final String content;

  final IconData? successIcon;
  final IconData? errorIcon;

  final Widget? customContent;

  TDStepsItemData({
    required this.title,
    required this.content,
    this.successIcon,
    this.errorIcon,
    this.customContent,
  });
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
  final List<TDStepsItemData> steps;
  final TDStepsDirection direction;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;
  const TDSteps({
    super.key,
    required this.steps,
    this.activeIndex = 0,
    this.direction = TDStepsDirection.horizontal,
    this.status = TDStepsStatus.success,
    this.simple = false,
    this.readOnly = false,
  });

  @override
  _TDStepsState createState() => _TDStepsState();

}
class _TDStepsState extends State<TDSteps> {
  @override
  Widget build(BuildContext context) {
    /// 当前激活的step索引
    final currentActiveIndex = widget.activeIndex < 0 ? 0 :
      (widget.activeIndex >= widget.steps.length ? widget.steps.length - 1 : widget.activeIndex);
    return widget.direction == TDStepsDirection.horizontal ?
      TDStepsHorizontal(
        steps: widget.steps,
        activeIndex: currentActiveIndex,
        status: widget.status,
        simple: widget.simple,
        readOnly: widget.readOnly
      ):
      TDStepsVertical(
        steps: widget.steps,
        activeIndex: currentActiveIndex,
        status: widget.status,
        simple: widget.simple,
        readOnly: widget.readOnly,
      );
  }

}
