import 'package:flutter/material.dart';

import 't_popup_types.dart';

/// 浮层配置：[TPopup.show] 的唯一参数来源。
///
/// ## 按 [placement] 用哪些字段
///
/// | placement | 头部 / 关闭区 | 尺寸字段 |
/// |-----------|----------------|----------|
/// | [TPopupPlacement.bottom] | `headerBuilder` / `titleBuilder` / `cancelBuilder` / `confirmBuilder` | `height`、`margin` |
/// | [TPopupPlacement.center] | `closeBuilder` | `width`、`height` |
/// | [TPopupPlacement.top] | — | `height`、`margin.top` / `left` / `right` |
/// | [TPopupPlacement.left] / [right] | — | `width`、对应方向 `margin` |
///
/// 非 bottom 上传 `headerBuilder` / `titleBuilder` / `cancelBuilder` / `confirmBuilder`、
/// 或非 center 上传 `closeBuilder` 都会被 [normalized] 裁掉。
///
/// ## Builder 三态
///
/// 每个 builder 字段都有三种使用方式：
///
/// - **不传**（保留默认）→ 使用内置 UI（如 `headerBuilder` 默认走三段式、`cancelBuilder` 默认显示「取消」、
///   `closeBuilder` 默认显示圆形关闭图标）。
/// - **显式传 `null`** → 隐藏该部分。
/// - **传自定义函数** → 完全替换该部分；函数会拿到 `close` 回调，用于在 onTap 中关闭浮层。
///
/// `titleBuilder` 例外：默认为 `null` 表示无标题（不需要内置标题文案）。
class TPopupOptions {
  const TPopupOptions({
    required this.child,
    this.placement = TPopupPlacement.bottom,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.radius,
    this.backgroundColor,
    this.showOverlay = true,
    this.closeOnOverlayClick = true,
    this.overlayColor,
    this.overlayOpacity,
    this.preventScrollThrough = true,
    this.destroyOnClose = false,
    this.duration = const Duration(milliseconds: 240),
    this.headerBuilder = kPopupDefaultHeader,
    this.titleBuilder,
    this.cancelBuilder = kPopupDefaultCancel,
    this.confirmBuilder = kPopupDefaultConfirm,
    this.closeBuilder = kPopupDefaultClose,
    this.onOpen,
    this.onOpened,
    this.onClose,
    this.onClosed,
    this.onVisibleChange,
    this.onOverlayClick,
  });

  /// 浮层主体内容（必填）。
  final Widget child;

  /// 出现位置，默认 [TPopupPlacement.bottom]。
  final TPopupPlacement placement;

  /// 宽度；对 left、right、center 生效。
  final double? width;

  /// 高度；对 top、bottom 生效；center 用于约束面板尺寸。
  final double? height;

  /// 外边距：
  /// - top：`top` / `left` / `right` 生效。
  /// - bottom：`top` > 0 触发「贴顶模式」（日历式留白）；否则贴底，`left` / `right` / `bottom` 生效。
  /// - left：`top` / `bottom` / `left` 生效。
  /// - right：`top` / `bottom` / `right` 生效。
  /// - center：全忽略。
  final EdgeInsets margin;

  /// 内容区圆角，默认主题大圆角。
  final double? radius;

  /// 内容区背景色，默认主题容器色。
  final Color? backgroundColor;

  /// 是否绘制半透明蒙层；为 false 时须保留其它关闭入口。
  final bool showOverlay;

  /// 点击蒙层是否关闭（须 [showOverlay] 为 true）。
  final bool closeOnOverlayClick;

  /// 蒙层颜色，默认 black54。
  final Color? overlayColor;

  /// 蒙层透明度系数（0–1），与 [overlayColor] 的 alpha 相乘后用于绘制。
  final double? overlayOpacity;

  /// 是否拦截底层滚动；无蒙层时用透明层吸收滚动。
  final bool preventScrollThrough;

  /// 为 true 时 Popup 路由 maintainState 为 false，关闭后不保留路由内 State。
  final bool destroyOnClose;

  /// 打开与关闭动画时长（一致）。
  final Duration duration;

  // ============ bottom 头部 ============

  /// bottom 头部构建器：
  /// - 默认 [kPopupDefaultHeader] → 渲染内置三段式（`cancelBuilder | titleBuilder | confirmBuilder`）。
  /// - `null` → 不显示头部。
  /// - 自定义 `(ctx, close) => Widget` → 完全替换整行头部（[titleBuilder] / [cancelBuilder] /
  ///   [confirmBuilder] 被忽略）。
  final TPopupHeaderBuilder? headerBuilder;

  /// bottom 标题槽（仅当 [headerBuilder] 为 [kPopupDefaultHeader] 时生效）：
  /// - `null` → 无标题。
  /// - 自定义 `(ctx) => Widget` → 显示自定义标题。
  final WidgetBuilder? titleBuilder;

  /// bottom 左槽（仅当 [headerBuilder] 为 [kPopupDefaultHeader] 时生效）：
  /// - 默认 [kPopupDefaultCancel] → 显示本地化「取消」按钮，点击关闭浮层。
  /// - `null` → 隐藏左槽。
  /// - 自定义 `(ctx, close) => Widget` → 替换左槽，自行决定是否调 `close()`。
  final TPopupSlotBuilder? cancelBuilder;

  /// bottom 右槽（仅当 [headerBuilder] 为 [kPopupDefaultHeader] 时生效）：
  /// - 默认 [kPopupDefaultConfirm] → 显示本地化「确定」按钮，点击关闭浮层。
  /// - `null` → 隐藏右槽。
  /// - 自定义 `(ctx, close) => Widget` → 替换右槽。
  final TPopupSlotBuilder? confirmBuilder;

  // ============ center 关闭区 ============

  /// center 面板下方关闭区：
  /// - 默认 [kPopupDefaultClose] → 显示圆形关闭图标，点击关闭浮层。
  /// - `null` → 不显示关闭区。
  /// - 自定义 `(ctx, close) => Widget` → 替换关闭区。
  final TPopupSlotBuilder? closeBuilder;

  // ============ 生命周期 ============

  final VoidCallback? onOpen;
  final VoidCallback? onOpened;
  final VoidCallback? onClose;
  final VoidCallback? onClosed;
  final TPopupVisibleChangeCallback? onVisibleChange;
  final VoidCallback? onOverlayClick;

  /// 按 [placement] 裁剪无效字段，得到路由实际使用的配置副本。
  ///
  /// - bottom 才保留 `headerBuilder` / `titleBuilder` / `cancelBuilder` / `confirmBuilder`；
  ///   其它 placement 上这些字段强制重置为 sentinel（不渲染头部，因为没渲染入口）。
  /// - center 才保留 `closeBuilder`；其它 placement 重置为 sentinel。
  TPopupOptions normalized() {
    final isBottom = placement == TPopupPlacement.bottom;
    final isCenter = placement == TPopupPlacement.center;

    return TPopupOptions(
      child: child,
      placement: placement,
      width: width,
      height: height,
      margin: margin,
      radius: radius,
      backgroundColor: backgroundColor,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      preventScrollThrough: preventScrollThrough,
      destroyOnClose: destroyOnClose,
      duration: duration,
      headerBuilder: isBottom ? headerBuilder : null,
      titleBuilder: isBottom ? titleBuilder : null,
      cancelBuilder: isBottom ? cancelBuilder : null,
      confirmBuilder: isBottom ? confirmBuilder : null,
      closeBuilder: isCenter ? closeBuilder : null,
      onOpen: onOpen,
      onOpened: onOpened,
      onClose: onClose,
      onClosed: onClosed,
      onVisibleChange: onVisibleChange,
      onOverlayClick: onOverlayClick,
    );
  }

  // ============ 派生 ============

  /// 是否走自定义 header（[headerBuilder] 非 null 且非默认 sentinel）。
  bool get useCustomHeader =>
      placement == TPopupPlacement.bottom &&
      headerBuilder != null &&
      !isPopupDefaultHeader(headerBuilder);

  /// 是否走内置三段式头部（[headerBuilder] 为默认 sentinel）。
  bool get useDefaultHeader =>
      placement == TPopupPlacement.bottom &&
      isPopupDefaultHeader(headerBuilder);

  /// 内置三段式中，左槽是否要画（非 null）。
  bool get showCancelSlot =>
      placement == TPopupPlacement.bottom &&
      useDefaultHeader &&
      cancelBuilder != null;

  /// 内置三段式中，右槽是否要画（非 null）。
  bool get showConfirmSlot =>
      placement == TPopupPlacement.bottom &&
      useDefaultHeader &&
      confirmBuilder != null;

  /// bottom 是否实际渲染头部（自定义 / 内置三段中至少有一项可见）。
  bool get hasBuiltInHeader {
    if (placement != TPopupPlacement.bottom || headerBuilder == null) {
      return false;
    }
    if (useCustomHeader) {
      return true;
    }
    // 默认三段：任一槽位（cancel/title/confirm）非 null 都算
    return cancelBuilder != null ||
        confirmBuilder != null ||
        titleBuilder != null;
  }

  /// Debug 下检查易误用参数（如 bottom 传 `width`、center 传 `margin`），仅 `debugPrint` 不抛错。
  void assertPlacementParams() {
    assert(() {
      switch (placement) {
        case TPopupPlacement.top:
          if (width != null) {
            debugPrint('TPopup: width is ignored for placement=top');
          }
          if (margin.bottom > 0) {
            debugPrint('TPopup: margin.bottom is ignored for placement=top');
          }
          break;
        case TPopupPlacement.bottom:
          if (width != null) {
            debugPrint('TPopup: width is ignored for placement=bottom');
          }
          break;
        case TPopupPlacement.left:
          if (height != null) {
            debugPrint('TPopup: height is ignored for placement=left');
          }
          if (margin.right > 0) {
            debugPrint('TPopup: margin.right is ignored for placement=left');
          }
          break;
        case TPopupPlacement.right:
          if (height != null) {
            debugPrint('TPopup: height is ignored for placement=right');
          }
          if (margin.left > 0) {
            debugPrint('TPopup: margin.left is ignored for placement=right');
          }
          break;
        case TPopupPlacement.center:
          if (margin != EdgeInsets.zero) {
            debugPrint('TPopup: margin is ignored for placement=center');
          }
          break;
      }
      // 非 bottom 设了 header / 三段相关字段（非默认 sentinel）→ 提示
      final hasBottomHeaderCustom = !isPopupDefaultHeader(headerBuilder) ||
          titleBuilder != null ||
          !isPopupDefaultCancel(cancelBuilder) ||
          !isPopupDefaultConfirm(confirmBuilder);
      if (placement != TPopupPlacement.bottom && hasBottomHeaderCustom) {
        debugPrint(
          'TPopup: header/title/cancel/confirmBuilder only apply to placement=bottom',
        );
      }
      // 非 center 设了 closeBuilder 自定义 → 提示
      if (placement != TPopupPlacement.center &&
          !isPopupDefaultClose(closeBuilder)) {
        debugPrint('TPopup: closeBuilder only applies to placement=center');
      }
      return true;
    }());
  }
}
