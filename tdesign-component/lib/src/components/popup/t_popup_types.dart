part of 't_popup.dart';

/// 浮层出现方向；决定 [TPopupOptions] 中哪些字段生效。
///
/// 与 [TPopupOptions] 类文档中的「字段与 placement」表对应。
/// 方向固定时请用 [TPopupOptions.bottom]、[TPopupOptions.center] 等命名工厂。
enum TPopupPlacement {
  /// 自顶部滑入；默认高 240，使用 [TPopupOptions.height]、[TPopupOptions.inset]（[TPopupTopInset]）覆盖。
  top,

  /// 自左侧滑入；默认宽 280，使用 [TPopupOptions.width]、[TPopupOptions.inset]（[TPopupLeftInset]）覆盖。
  left,

  /// 自右侧滑入；默认宽 280，使用 [TPopupOptions.width]、[TPopupOptions.inset]（[TPopupRightInset]）覆盖。
  right,

  /// 自底部滑入；默认高 240；使用 [TPopupOptions.height]、[TPopupOptions.inset]（[TPopupBottomInset]）覆盖。
  bottom,

  /// 屏幕居中；默认 240 × 240，使用 [TPopupOptions.width]、[TPopupOptions.height] 覆盖；
  /// 使用 [TPopupOptions.closeBuilder] 控制面板外下方关闭区。
  center,
}

/// bottom 整行头部自定义构建器。
///
/// * [context] 构建上下文
/// * [close] 关闭浮层，触发源为 [TPopupTrigger.custom]
typedef TPopupHeaderBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// center 面板外关闭区构建器。
///
/// * [context] 构建上下文
/// * [close] 关闭浮层，触发源为 [TPopupTrigger.close]
///
/// 自定义 builder 需自行提供交互与无障碍语义；框架仅为内置默认控件补充默认语义。
typedef TPopupSlotBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// Popup 蒙层行为配置（可见遮罩、背景拦截、点击行为）。
///
/// 统一收敛 [TPopupOptions] 上散落的蒙层参数（`showOverlay` / `modal` /
/// `closeOnOverlayClick` / `overlayColor` / `overlayOpacity` / `onOverlayClick`），
/// 与 Toast 的 `TOverlayConfig` 命名风格一脉相承，作为蒙层行为的单一真源。
///
/// [showOverlay] 与 [preventTap] 解耦，可独立配置：
/// * `showOverlay=true, preventTap=true`（默认）：标准模态弹层（显示蒙层 + 拦截背景）；
/// * `showOverlay=true, preventTap=false`：显示蒙层但不拦截背景交互；
/// * `showOverlay=false, preventTap=true`：透明模态弹层（拦截交互但不显示蒙层）；
/// * `showOverlay=false, preventTap=false`：非模态浮层（不显示蒙层也不拦截交互）。
class TPopupOverlayConfig {
  /// 是否显示可见半透明蒙层（默认 true）。
  final bool showOverlay;

  /// 蒙层颜色；为 null 时默认 black54。
  final Color? color;

  /// 蒙层透明度系数（0–1），与 [color] 的 alpha 相乘后用于绘制；为 null 时不额外调整。
  final double? opacity;

  /// 是否拦截背景交互（默认 true）；对应原 `modal` 参数。
  final bool preventTap;

  /// 点击可见蒙层是否关闭；省略时在可点击的可见蒙层上默认为 true。
  ///
  /// 仅当 [showOverlay] 与 [preventTap] 都为 true 时生效；视觉蒙层允许点击穿透时，
  /// 不会接收点击事件，也不会关闭 Popup。
  final bool? closeOnClick;

  /// 可见蒙层点击回调；是否关闭取决于 [effectiveCloseOnClick]。
  ///
  /// 仅当 [showOverlay] 与 [preventTap] 都为 true 时触发。
  final VoidCallback? onClick;

  /// 创建蒙层配置。
  const TPopupOverlayConfig({
    this.showOverlay = true,
    this.color,
    this.opacity,
    this.preventTap = true,
    this.closeOnClick,
    this.onClick,
  });

  /// 解析后的点击可见蒙层是否关闭。
  ///
  /// 没有可见蒙层或允许点击穿透时始终为 false；其余情况省略 [closeOnClick] 时
  /// 默认为 true。
  bool get effectiveCloseOnClick =>
      showOverlay && preventTap && (closeOnClick ?? true);
}

/// 浮层关闭或显隐变化时的触发来源。
///
/// 作为 [TPopupVisibleChangeCallback] 的第二个参数，以及关闭流程中的语义标记。
///
/// 内置行为会映射为 [TPopupTrigger.overlay]，center 关闭 builder 调用 `close`
/// 映射为 [TPopupTrigger.close]；
/// [TPopupHandle.close] 为 [TPopupTrigger.api]；系统返回为
/// [TPopupTrigger.systemBack]；headerBuilder 内调用 `close` 等为
/// [TPopupTrigger.custom]。
enum TPopupTrigger {
  /// 点击蒙层，且 [TPopupOverlayConfig.effectiveCloseOnClick] 为 true。
  overlay,

  /// 点击 center 关闭槽位。
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
typedef TPopupVisibleChangeCallback =
    void Function(bool visible, TPopupTrigger trigger);
