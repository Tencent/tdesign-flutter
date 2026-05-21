import 'package:flutter/widgets.dart';

/// 浮层出现位置。
enum TPopupPlacement {
  /// 自屏幕顶部滑入；height 与 margin 的 top/left/right 生效。
  top,

  /// 自屏幕左侧滑入；width 与 margin 的 left/top/bottom 生效。
  left,

  /// 自屏幕右侧滑入；width 与 margin 的 right/top/bottom 生效。
  right,

  /// 自屏幕底部滑入；默认带操作栏，height 与 margin 生效。
  bottom,

  /// 屏幕居中缩放弹出；默认内容下方关闭按钮。
  center,
}

/// 未传 [cancel]/[confirm] 时的占位 Widget，表示使用默认「取消」「确定」文案。
///
/// 须显式传 `cancel: null` / `confirm: null` 才能隐藏对应侧；两侧均为 null 且无
/// Builder 时不渲染 bottom 操作栏。
class TPopupActionDefault extends StatelessWidget {
  const TPopupActionDefault({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 与 [TPopupActionDefault] 同一实例，供 [TPopup.show] / [TPopup] 默认参数使用。
const Widget kPopupActionDefault = TPopupActionDefault();

/// 自定义 [headerBuilder] 时传入的标题栏数据（已按 cancel/confirm/title 参数组装好 Widget）。
class TPopupHeaderData {
  const TPopupHeaderData({
    this.title,
    this.cancel,
    this.confirm,
    this.onCancel,
    this.onConfirm,
  });

  /// 中间标题区（可能为 null）。
  final Widget? title;

  /// 左侧按钮区（可能为 null，表示该侧已隐藏）。
  final Widget? cancel;

  /// 右侧按钮区（可能为 null）。
  final Widget? confirm;

  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
}

/// bottom 自定义头部构建器。
typedef TPopupHeaderBuilder = Widget Function(
  BuildContext context,
  TPopupHeaderData data,
);

/// 未传 [headerBuilder] 时的默认参数占位，表示使用内置 bottom 操作栏。
///
/// **勿直接调用**；仅作为默认参数值。
/// 与 [headerBuilder: null]（不渲染任何头部）不同，须显式区分。
Widget kPopupDefaultHeader(BuildContext context, TPopupHeaderData data) {
  return const SizedBox.shrink();
}

/// 是否为「使用默认操作栏」（未传 [headerBuilder] 时的默认参数值）。
bool isPopupDefaultHeader(TPopupHeaderBuilder? builder) =>
    builder == kPopupDefaultHeader;

/// center 下方关闭区构建器；[close] 会触发 [onCloseBtn] 并关闭浮层。
typedef TPopupCloseBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// 未传 [closeBuilder] 时的默认参数占位，表示使用内置圆圈关闭图标。
///
/// **勿直接调用**；仅作为 [TPopup.show] / [TPopup] 的默认参数值。
/// 与 [closeBuilder: null]（不渲染关闭区）不同，须显式区分。
Widget kPopupDefaultClose(BuildContext context, VoidCallback close) {
  return const SizedBox.shrink();
}

/// 是否为「使用默认关闭按钮」（未传 [closeBuilder] 时的默认参数值）。
bool isPopupDefaultClose(TPopupCloseBuilder? builder) =>
    builder == kPopupDefaultClose;

/// 显隐变化触发来源。
enum TPopupTrigger {
  /// 点击半透明蒙层。
  overlay,

  /// 点击 center 下方关闭控件。
  closeBtn,

  /// 点击 bottom 操作栏左侧取消。
  cancelBtn,

  /// 点击 bottom 操作栏右侧确定。
  confirmBtn,

  /// [TPopupHandle.close]、[TPopup.close] 或系统返回等程序化关闭。
  programmatic,
}

/// 显隐回调：是否可见及触发来源。
typedef TPopupVisibleChangeCallback = void Function(
  bool visible,
  TPopupTrigger trigger,
);
