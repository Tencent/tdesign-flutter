import 'package:flutter/material.dart';

import '../popup/t_popup.dart';
import 'picker_defaults.dart';
import 't_picker_theme_data.dart';

/// 构建 Picker 标准弹层头部。
///
/// 返回类型限定为 [TPopupHeader]，使弹层尺寸计算与实际头部的
/// [TPopupHeader.headerHeight] 保持一致。
typedef TPickerPopupHeaderBuilder =
    TPopupHeader Function(BuildContext context, VoidCallback close);

/// Picker 专用弹层入口。
///
/// `TPicker` 与 `TDateTimePicker` 的滚轮仍是可独立组合的纯面板；需要设计稿中的
/// 底部弹层时使用 [show]。该入口统一为标准 [TPopupHeader] 和完整滚轮视窗预留
/// 高度，避免调用方按通用 Popup 默认高度拼装后压缩或裁切滚轮。
final class TPickerPopup {
  const TPickerPopup._();

  /// 打开包含标准头部和 Picker 滚轮的底部弹层。
  ///
  /// 弹层总高为当前 [TPickerThemeData.height]（默认 200）加
  /// [TPopupHeader.headerHeight]（58）。[child] 通常为 `TPicker` 或
  /// `TDateTimePicker`，其受控值、确认和取消状态仍由调用方管理。
  static TPopupHandle show(
    BuildContext context, {

    /// Picker 滚轮面板。
    required Widget child,

    /// 标准 58px 头部构建器。
    required TPickerPopupHeaderBuilder headerBuilder,

    /// 底部弹层的边缘缩进。
    TPopupBottomInset? inset,

    /// 顶部圆角；null 时使用 Popup 主题或 TDesign 默认值。
    double? radius,

    /// 面板背景色；null 时使用 Popup 主题或容器色。
    Color? backgroundColor,

    /// 蒙层行为；null 时沿用 Popup 默认值。
    TPopupOverlayConfig? overlay,

    /// 关闭后是否销毁弹层内容，默认 false。
    bool destroyOnClose = false,

    /// 打开和关闭动画时长。
    Duration? animationDuration,

    /// 打开动画完成回调。
    VoidCallback? onOpened,

    /// 关闭动画完成回调。
    VoidCallback? onClosed,

    /// 弹层显隐变化回调。
    TPopupVisibleChangeCallback? onVisibleChange,

    /// 是否避让底部安全区，默认 false。
    bool useSafeArea = false,

    /// 可选的 Navigator 上下文；默认使用 [context]。
    BuildContext? navigatorContext,

    /// 是否使用根 Navigator，默认 false。
    bool useRootNavigator = false,
  }) {
    return TPopup.show(
      context,
      navigatorContext: navigatorContext,
      useRootNavigator: useRootNavigator,
      options: TPopupOptions.bottom(
        height:
            (Theme.of(context).extension<TPickerThemeData>()?.height ??
                defaultPickerHeight) +
            TPopupHeader.headerHeight,
        inset: inset,
        headerBuilder: headerBuilder,
        radius: radius,
        backgroundColor: backgroundColor,
        overlay: overlay,
        destroyOnClose: destroyOnClose,
        animationDuration: animationDuration,
        onOpened: onOpened,
        onClosed: onClosed,
        onVisibleChange: onVisibleChange,
        useSafeArea: useSafeArea,
        child: child,
      ),
    );
  }
}
