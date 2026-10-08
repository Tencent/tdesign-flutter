part of 't_popup.dart';

/// [TPopupOptions.placement] 的弹出方向。
enum TPopupPlacement {
  /// 顶部滑入。
  top,

  /// 左侧滑入。
  left,

  /// 右侧滑入。
  right,

  /// 底部滑入。
  bottom,

  /// 屏幕居中。
  center,
}

/// 底部头部构建器。
///
/// | 回调参数 | 说明 |
/// | --- | --- |
/// | [context] | 构建上下文 |
/// | [close] | 关闭 Popup，触发源为 [TPopupTrigger.custom] |
typedef TPopupHeaderBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// 居中面板外关闭区构建器；交互与无障碍语义由 builder 提供。
///
/// | 回调参数 | 说明 |
/// | --- | --- |
/// | [context] | 构建上下文 |
/// | [close] | 关闭 Popup，触发源为 [TPopupTrigger.close] |
typedef TPopupSlotBuilder =
    Widget Function(BuildContext context, VoidCallback close);

/// 蒙层配置。
///
/// | showOverlay | preventTap | 行为 |
/// | --- | --- | --- |
/// | true | true | 显示蒙层、拦截背景交互；支持点击回调和关闭 |
/// | true | false | 显示蒙层，背景可交互；不接收蒙层点击 |
/// | false | true | 无可见蒙层，拦截背景交互；不支持蒙层点击关闭 |
/// | false | false | 无可见蒙层，背景可交互 |
class TPopupOverlayConfig {
  /// 是否显示可见蒙层。
  final bool showOverlay;

  /// 蒙层颜色（含透明度）；未指定时取 [TPopupThemeData.barrierColor]，再回退到 black54。
  final Color? color;

  /// 是否拦截背景交互。
  final bool preventTap;

  /// 点击蒙层是否关闭；仅显示蒙层且拦截交互时生效，未指定时为 true。
  final bool? closeOnClick;

  /// 蒙层点击回调；仅显示蒙层且拦截交互时触发，是否关闭由 [closeOnClick] 决定。
  final VoidCallback? onClick;

  /// 创建蒙层配置。
  const TPopupOverlayConfig({
    this.showOverlay = true,
    this.color,
    this.preventTap = true,
    this.closeOnClick,
    this.onClick,
  });

  /// 实际是否支持蒙层点击关闭；无可见蒙层或允许穿透时为 false，否则取 [closeOnClick]（未指定为 true）。
  bool get effectiveCloseOnClick =>
      showOverlay && preventTap && (closeOnClick ?? true);
}

/// [TPopupVisibleChangeCallback] 的触发来源。
enum TPopupTrigger {
  /// 点击蒙层，且 [TPopupOverlayConfig.effectiveCloseOnClick] 为 true。
  overlay,

  /// 居中关闭区 builder 调用 close。
  close,

  /// 外部 API 主动触发的显隐变化，如 [TPopupHandle.close] 或打开事件。
  api,

  /// 系统返回键或系统路由返回触发的关闭。
  systemBack,

  /// 头部 builder 调用 close 等自定义关闭。
  custom,
}

/// 浮层显隐变化回调。
///
/// | 回调参数 | 说明 |
/// | --- | --- |
/// | [visible] | true 表示打开，false 表示开始关闭 |
/// | [trigger] | 触发来源；打开时为 [TPopupTrigger.api] |
typedef TPopupVisibleChangeCallback =
    void Function(bool visible, TPopupTrigger trigger);
