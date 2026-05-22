part of 't_popup.dart';

/// 浮层出现方向；决定 [TPopupOptions] 中哪些字段生效。
///
/// 与 [TPopupOptions] 类文档中的「字段与 placement」表对应。
/// 方向固定时请用 [TPopupOptions.bottom]、[TPopupOptions.center] 等命名工厂。
enum TPopupPlacement {
  /// 自顶部滑入；使用 [TPopupOptions.height]、[TPopupOptions.margin]（top/left/right）。
  top,

  /// 自左侧滑入；使用 [TPopupOptions.width]、[TPopupOptions.margin]（left/top/bottom）。
  left,

  /// 自右侧滑入；使用 [TPopupOptions.width]、[TPopupOptions.margin]（right/top/bottom）。
  right,

  /// 自底部滑入；默认内置头部；使用 [TPopupOptions.height]、[TPopupOptions.margin]。
  bottom,

  /// 屏幕居中；使用 [TPopupOptions.closeBuilder] 控制面板外下方关闭区。
  center,
}

/// bottom 整行头部自定义构建器。
///
/// * [context] 构建上下文
/// * [close] 关闭浮层，触发源为 [TPopupTrigger.programmatic]
typedef TPopupHeaderBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// bottom 左右操作槽或 center 关闭区构建器。
///
/// * [context] 构建上下文
/// * [close] 关闭浮层，触发源为 [TPopupTrigger.programmatic]
typedef TPopupSlotBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

// 库内 sentinel：识别 builder「未传 = 内置默认」。业务三态见 [TPopupOptions]。

Widget _kPopupDefaultHeader(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

Widget _kPopupDefaultCancel(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

Widget _kPopupDefaultConfirm(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

Widget _kPopupDefaultClose(BuildContext context, VoidCallback close) =>
    const SizedBox.shrink();

bool _isPopupDefaultHeader(TPopupHeaderBuilder? builder) =>
    identical(builder, _kPopupDefaultHeader);

bool _isPopupDefaultCancel(TPopupSlotBuilder? builder) =>
    identical(builder, _kPopupDefaultCancel);

bool _isPopupDefaultConfirm(TPopupSlotBuilder? builder) =>
    identical(builder, _kPopupDefaultConfirm);

bool _isPopupDefaultClose(TPopupSlotBuilder? builder) =>
    identical(builder, _kPopupDefaultClose);

/// 浮层关闭或显隐变化时的触发来源。
///
/// 作为 [TPopupVisibleChangeCallback] 的第二个参数，以及关闭流程中的语义标记。
///
/// 内置控件会映射为 [TPopupTrigger.overlay]、[TPopupTrigger.cancelBtn]、
/// [TPopupTrigger.confirmBtn]、[TPopupTrigger.closeBtn]；
/// [TPopupHandle.close]、系统返回、自定义 builder 内调用 `close` 均为
/// [TPopupTrigger.programmatic]。
enum TPopupTrigger {
  /// 点击蒙层，且 [TPopupOptions.closeOnOverlayClick] 为 true。
  overlay,

  /// 点击 bottom 内置「取消」按钮（[TPopupOptions.cancelBuilder] 为内置默认时）。
  cancelBtn,

  /// 点击 bottom 内置「确定」按钮（[TPopupOptions.confirmBuilder] 为内置默认时）。
  confirmBtn,

  /// 点击 center 内置关闭图标（[TPopupOptions.closeBuilder] 为内置默认时）。
  closeBtn,

  /// [TPopupHandle.close]、系统返回键、自定义 builder 调用 `close` 等。
  programmatic,
}

/// 浮层显隐变化回调。
///
/// * [visible] 为 true 表示打开，false 表示开始关闭
/// * [trigger] 关闭来源，见 [TPopupTrigger]；打开时为 [TPopupTrigger.programmatic]
typedef TPopupVisibleChangeCallback = void Function(
  bool visible,
  TPopupTrigger trigger,
);
