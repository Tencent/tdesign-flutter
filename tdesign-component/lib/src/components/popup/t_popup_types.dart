import 'package:flutter/widgets.dart';

/// 浮层从哪个方向出现；决定哪些 [TPopupOptions] 字段生效。
///
/// - [top] / [bottom]：纵向滑入，用 `height`、`margin`（bottom 可用 `margin.top` 做日历式留白）。
/// - [left] / [right]：侧栏，用 `width`、`margin`。
/// - [center]：居中缩放，用 `closeBuilder` 控制下方关闭区。
enum TPopupPlacement {
  /// 自屏幕顶部滑入；`height` 与 `margin` 的 top/left/right 生效。
  top,

  /// 自屏幕左侧滑入；`width` 与 margin 的 left/top/bottom 生效。
  left,

  /// 自屏幕右侧滑入；`width` 与 margin 的 right/top/bottom 生效。
  right,

  /// 自屏幕底部滑入；默认内置「取消 | 标题 | 确定」头部，`height`、`margin` 生效。
  bottom,

  /// 屏幕居中弹出；默认面板下方圆形关闭图标；`closeBuilder: null` 隐藏关闭区。
  center,
}

/// bottom 头部完全自定义构建器签名。
///
/// - [close]：调用即关闭浮层（触发 [TPopupTrigger.programmatic]）。
typedef TPopupHeaderBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// bottom 槽位 / center 关闭区构建器签名。
///
/// - [close]：调用即关闭浮层（触发 [TPopupTrigger.programmatic]）。
typedef TPopupSlotBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// **内置三段式头部**占位常量（bottom 默认）：
/// 实际渲染为 `cancelBuilder | titleBuilder | confirmBuilder` 三段。
///
/// 直接调用返回空 Widget；库内通过 `identical` 判断是否走内置布局。
/// 与 `headerBuilder: null`（无头部）语义不同。
Widget kPopupDefaultHeader(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

/// **内置「取消」按钮**占位常量（bottom 默认左槽）。
///
/// 实际渲染为本地化「取消」文本，点击调用 [close]。
/// 与 `cancelBuilder: null`（隐藏左槽）语义不同。
Widget kPopupDefaultCancel(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

/// **内置「确定」按钮**占位常量（bottom 默认右槽）。
///
/// 实际渲染为本地化「确定」文本，点击调用 [close]。
/// 与 `confirmBuilder: null`（隐藏右槽）语义不同。
Widget kPopupDefaultConfirm(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

/// **内置「关闭」图标**占位常量（center 默认关闭区）。
///
/// 实际渲染为圆形关闭图标，点击调用 [close]。
/// 与 `closeBuilder: null`（隐藏关闭区）语义不同。
Widget kPopupDefaultClose(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

/// 是否为「使用内置三段式头部」占位（bottom）。
bool isPopupDefaultHeader(TPopupHeaderBuilder? builder) =>
    identical(builder, kPopupDefaultHeader);

/// 是否为「使用内置取消按钮」占位。
bool isPopupDefaultCancel(TPopupSlotBuilder? builder) =>
    identical(builder, kPopupDefaultCancel);

/// 是否为「使用内置确定按钮」占位。
bool isPopupDefaultConfirm(TPopupSlotBuilder? builder) =>
    identical(builder, kPopupDefaultConfirm);

/// 是否为「使用内置圆形关闭图标」占位（center）。
bool isPopupDefaultClose(TPopupSlotBuilder? builder) =>
    identical(builder, kPopupDefaultClose);

/// 浮层被关闭时的触发来源，见 [TPopupOptions.onVisibleChange]。
///
/// 注意：从库内的内置按钮触发关闭统一上报 [programmatic]（自定义 builder 走自己的 `close`），
/// 「点击蒙层」仍单独上报 [overlay]。
enum TPopupTrigger {
  /// 点击蒙层（且 [closeOnOverlayClick] 为 true）。
  overlay,

  /// [TPopupHandle.close]、内置按钮、系统返回键等。
  programmatic,
}

/// 显隐变化：`onVisibleChange(visible, trigger)`。
typedef TPopupVisibleChangeCallback = void Function(
  bool visible,
  TPopupTrigger trigger,
);
