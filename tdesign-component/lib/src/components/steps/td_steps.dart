import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_horizontal.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_vertical.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条数据类型
class StepsItemData {
  final String title;
  final String content;

  final IconData? successIcon;
  final IconData? errorIcon;

  StepsItemData({
    required this.title,
    required this.content,
    this.successIcon,
    this.errorIcon,
  });
}

/// Steps步骤条方向
enum StatusDirection {
  vertical,
  horizontal,
}

/// steps步骤条状态
enum StepsStatus {
  success,
  error,
}

/// Steps步骤条
class TDSteps extends StatefulWidget {
  final List<StepsItemData> steps;
  final StatusDirection direction;
  final int activeIndex;
  final StepsStatus status;
  final bool simple;
  const TDSteps({
    super.key,
    required this.steps,
    required this.activeIndex,
    this.direction = StatusDirection.horizontal,
    this.status = StepsStatus.success,
    this.simple = false,
  });

  @override
  _TDStepsState createState() => _TDStepsState();

}
class _TDStepsState extends State<TDSteps> {
  @override
  Widget build(BuildContext context) {
    /// 当前激活的step索引
    final currentActiveIndex = widget.activeIndex < 0 ? 0 : (widget.activeIndex >= widget.steps.length ? widget.steps.length - 1 : widget.activeIndex);
    return widget.direction == StatusDirection.horizontal ?
      TDStepsHorizontal(steps: widget.steps, activeIndex: currentActiveIndex, status: widget.status, simple: widget.simple):
      Container();
  }

}
