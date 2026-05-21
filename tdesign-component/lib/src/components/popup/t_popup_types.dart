import 'package:flutter/widgets.dart';

/// 浮层出现位置。
enum TPopupPlacement { top, left, right, bottom, center }

/// [TPopup.show] 未传 [cancel]/[confirm] 时的占位，表示使用默认「取消」「确定」文案。
///
/// 传 `cancel: null` / `confirm: null` 可隐藏对应侧；两侧均为 `null` 且无
/// [cancelBuilder]/[confirmBuilder] 时不渲染操作栏。
class TPopupActionDefault extends StatelessWidget {
  const TPopupActionDefault({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 与 [TPopupActionDefault] 同一实例，供默认参数使用。
const Widget kPopupActionDefault = TPopupActionDefault();

/// 显隐变化触发来源。
enum TPopupTrigger {
  overlay,
  closeBtn,
  cancelBtn,
  confirmBtn,
  programmatic,
}

typedef TPopupVisibleChangeCallback = void Function(
  bool visible,
  TPopupTrigger trigger,
);
