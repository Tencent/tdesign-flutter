part of 't_popup.dart';

/// 浮层出现方向；决定 [TPopupOptions] 中哪些字段生效。
///
/// 与 [TPopupOptions] 类文档中的「字段与 placement」表对应。
/// 方向固定时请用 [TPopupOptions.bottom]、[TPopupOptions.center] 等命名工厂。
enum TPopupPlacement {
  /// 自顶部滑入；使用 [TPopupOptions.height]、[TPopupOptions.inset]（[TPopupTopInset]）。
  top,

  /// 自左侧滑入；使用 [TPopupOptions.width]、[TPopupOptions.inset]（[TPopupLeftInset]）。
  left,

  /// 自右侧滑入；使用 [TPopupOptions.width]、[TPopupOptions.inset]（[TPopupRightInset]）。
  right,

  /// 自底部滑入；默认内置头部；使用 [TPopupOptions.height]、[TPopupOptions.inset]（[TPopupBottomInset]）。
  bottom,

  /// 屏幕居中；使用 [TPopupOptions.closeBuilder] 控制面板外下方关闭区。
  center,
}

/// bottom 整行头部自定义构建器。
///
/// * [context] 构建上下文
/// * [close] 关闭浮层，触发源为 [TPopupTrigger.custom]
typedef TPopupHeaderBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// bottom 左右操作槽或 center 关闭区构建器。
///
/// * [context] 构建上下文
/// * [close] 关闭浮层；触发源与槽位语义保持一致
///
/// 自定义 builder 需自行提供交互与无障碍语义；框架仅为内置默认控件补充默认语义。
typedef TPopupSlotBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

// 库内 sentinel：识别 builder「未传 = 内置默认」。业务三态见 [TPopupOptions]。

Widget _kPopupDefaultHeader(BuildContext context, VoidCallback close) => const SizedBox.shrink(); // coverage:ignore-line

Widget _kPopupDefaultCancel(BuildContext context, VoidCallback close) => const SizedBox.shrink(); // coverage:ignore-line

Widget _kPopupDefaultConfirm(BuildContext context, VoidCallback close) => const SizedBox.shrink(); // coverage:ignore-line

Widget _kPopupDefaultClose(BuildContext context, VoidCallback close) => const SizedBox.shrink(); // coverage:ignore-line

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
/// 内置控件会映射为 [TPopupTrigger.overlay]、[TPopupTrigger.cancel]、
/// [TPopupTrigger.confirm]、[TPopupTrigger.close]；
/// [TPopupHandle.close] 为 [TPopupTrigger.api]；系统返回为
/// [TPopupTrigger.systemBack]；headerBuilder 内调用 `close` 等为
/// [TPopupTrigger.custom]。
enum TPopupTrigger {
  /// 点击蒙层，且 [TPopupOptions.closeOnOverlayClick] 为 true。
  overlay,

  /// 点击 bottom 取消语义槽位（含默认与自定义 [TPopupOptions.cancelBuilder]）。
  cancel,

  /// 点击 bottom 确认语义槽位（含默认与自定义 [TPopupOptions.confirmBuilder]）。
  confirm,

  /// 点击 center 关闭语义槽位（含默认与自定义 [TPopupOptions.closeBuilder]）。
  close,

  /// 外部 API 主动触发的显隐变化，如 [TPopupHandle.close] 或打开事件。
  api,

  /// 系统返回键或系统路由返回触发的关闭。
  systemBack,

  /// 无框架预设动作语义的自定义关闭，如 headerBuilder 内调用 `close`。
  custom,
}

/// 浮层显隐变化回调。
///
/// * [visible] 为 true 表示打开，false 表示开始关闭
/// * [trigger] 关闭来源，见 [TPopupTrigger]；打开时为 [TPopupTrigger.api]
typedef TPopupVisibleChangeCallback = void Function(
  bool visible,
  TPopupTrigger trigger,
);
