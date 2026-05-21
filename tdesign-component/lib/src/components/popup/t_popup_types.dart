import 'package:flutter/widgets.dart';

/// 浮层从哪个方向出现；决定哪些 [TPopupOptions] 字段生效。
///
/// - [top] / [bottom]：纵向滑入，用 `height`、`margin`（bottom 可用 `margin.top` 做日历式留白）。
/// - [left] / [right]：侧栏，用 `width`、`margin`。
/// - [center]：居中缩放，用 `closeBuilder` 控制下方关闭按钮；不用 bottom 操作栏字段。
enum TPopupPlacement {
  /// 自屏幕顶部滑入；`height` 与 `margin` 的 top/left/right 生效。
  top,

  /// 自屏幕左侧滑入；`width` 与 margin 的 left/top/bottom 生效。
  left,

  /// 自屏幕右侧滑入；`width` 与 margin 的 right/top/bottom 生效。
  right,

  /// 自屏幕底部滑入；默认操作栏（取消 | 标题 | 确定），`height`、`margin` 生效。
  bottom,

  /// 屏幕居中弹出；默认面板外下方关闭按钮，不用 `title` / `cancel` / `confirm`。
  center,
}

/// 未传 [TPopupOptions.cancel] / [confirm] 时的占位，表示渲染默认「取消」「确定」文案。
///
/// 要**隐藏**某一侧须写 `cancel: null` 或 `confirm: null`（不是省略参数）。
/// 两侧都为 `null` 且无 Builder 时，bottom 不显示操作栏（适合 Picker 等自带工具栏）。
class TPopupActionDefault extends StatelessWidget {
  const TPopupActionDefault({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 与 [TPopupActionDefault] 同一实例，作为 [TPopupOptions.cancel] / [confirm] 的默认值。
const Widget kPopupActionDefault = TPopupActionDefault();

/// 传给自定义 [TPopupOptions.headerBuilder] 的标题栏数据（库内已组装好各槽 Widget）。
class TPopupHeaderData {
  const TPopupHeaderData({
    this.title,
    this.cancel,
    this.confirm,
    this.onCancel,
    this.onConfirm,
  });

  /// 中间标题（可为 null）。
  final Widget? title;

  /// 左侧区域 Widget（null 表示该侧已隐藏）。
  final Widget? cancel;

  /// 右侧区域 Widget（null 表示该侧已隐藏）。
  final Widget? confirm;

  /// 点击左侧区域时回调（是否关闭由 [TPopupOptions.autoCloseOnCancel] 决定）。
  final VoidCallback? onCancel;

  /// 点击右侧区域时回调（是否关闭由 [TPopupOptions.autoCloseOnConfirm] 决定）。
  final VoidCallback? onConfirm;
}

/// bottom 完全自定义头部：`Widget Function(context, data)`，优先级高于默认操作栏。
typedef TPopupHeaderBuilder = Widget Function(
  BuildContext context,
  TPopupHeaderData data,
);

/// 默认 [headerBuilder] 占位：表示使用内置「取消 | 标题 | 确定」操作栏。
///
/// 勿直接调用。与 [headerBuilder: null]（完全不显示头部）不同。
Widget kPopupDefaultHeader(BuildContext context, TPopupHeaderData data) {
  return const SizedBox.shrink();
}

/// 是否为默认操作栏占位（未自定义 [headerBuilder]）。
bool isPopupDefaultHeader(TPopupHeaderBuilder? builder) =>
    builder == kPopupDefaultHeader;

/// center 面板**外下方**关闭区；须调用入参 [close] 才会关层（会走 [onCloseBtn] 等逻辑）。
typedef TPopupCloseBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// 默认 [closeBuilder] 占位：使用内置圆圈关闭图标（面板外下方）。
///
/// 勿直接调用。与 [closeBuilder: null]（不显示关闭区）不同。
Widget kPopupDefaultClose(BuildContext context, VoidCallback close) {
  return const SizedBox.shrink();
}

/// 是否为默认关闭按钮占位。
bool isPopupDefaultClose(TPopupCloseBuilder? builder) =>
    builder == kPopupDefaultClose;

/// 浮层被关闭时的触发来源，见 [TPopupOptions.onVisibleChange]。
enum TPopupTrigger {
  /// 点击蒙层（且 [closeOnOverlayClick] 为 true）。
  overlay,

  /// 点击 center 下方关闭控件。
  closeBtn,

  /// 点击 bottom 操作栏「取消」。
  cancelBtn,

  /// 点击 bottom 操作栏「确定」。
  confirmBtn,

  /// [TPopupHandle.close]、系统返回键等。
  programmatic,
}

/// 显隐变化：`onVisibleChange(visible, trigger)`。
typedef TPopupVisibleChangeCallback = void Function(
  bool visible,
  TPopupTrigger trigger,
);
