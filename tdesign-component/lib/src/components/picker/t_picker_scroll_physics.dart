import 'package:flutter/widgets.dart';

/// TPicker 滚动物理效果 —— disabled 项穿透
///
/// 策略：完全不干预滚动物理，让滚动自然结束。
/// disabled 修正统一由调用方的 [ScrollEndNotification] 处理（jumpToItem 瞬时修正）。
class TPickerScrollPhysics extends FixedExtentScrollPhysics {
  const TPickerScrollPhysics({
    super.parent,
  });

  @override
  TPickerScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      TPickerScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // 完全委托父类，不干预任何滚动物理
    // disabled 修正由 ScrollEndNotification + jumpToItem 处理（瞬时、无抖动）
    return super.createBallisticSimulation(position, velocity);
  }
}
