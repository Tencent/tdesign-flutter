import 'package:flutter/material.dart';

import 't_popup_types.dart';

/// 浮层配置：[TPopup] 构造与 [TPopup.show] 的唯一参数来源。
///
/// ## 按 [placement] 用哪些字段
///
/// | placement | 常用字段 |
/// |-----------|----------|
/// | [TPopupPlacement.bottom] | `title` / `cancel` / `confirm` / `headerBuilder`、`height`、`margin` |
/// | [TPopupPlacement.center] | `closeBuilder`、`width`、`height`（有下方关闭时） |
/// | [TPopupPlacement.top] / [left] / [right] | 主要 `child`、`margin`、方向对应 `width` 或 `height` |
///
/// 传给其它 placement 的 bottom / center 专用字段会在 [normalized] 里裁掉。
///
/// ## 三态占位（bottom / center）
///
/// - **未传参数**：使用默认 UI（如默认取消/确定文案、默认关闭图标）。
/// - **显式 `null`**：隐藏该槽位（如 `cancel: null` 隐藏左侧；`closeBuilder: null` 无关闭按钮）。
/// - **自定义 Widget / Builder**：完全自定义该区域。
///
/// [TPopup.show] 内部会先 [normalized] 再绘制。
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
    this.title,
    this.titleWidget,
    this.titleAlignLeft = false,
    this.cancelBtn,
    this.cancel = kPopupActionDefault,
    this.cancelBuilder,
    this.onCancel,
    this.confirmBtn,
    this.confirm = kPopupActionDefault,
    this.confirmBuilder,
    this.onConfirm,
    this.autoCloseOnCancel = true,
    this.autoCloseOnConfirm = true,
    this.closeBuilder = kPopupDefaultClose,
    this.onCloseBtn,
    this.headerBuilder = kPopupDefaultHeader,
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

  /// 高度；对 top、bottom 生效；center 且下方关闭时约束内容区高度。
  final double? height;

  /// 外边距；center 忽略。bottom 的 top 可用来做日历式距顶留白。
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

  /// bottom 操作栏中间标题文案。
  final String? title;

  /// bottom 操作栏中间标题组件，优先级高于 [title]。
  final Widget? titleWidget;

  /// bottom 仅标题行时是否左对齐，默认居中。
  final bool titleAlignLeft;

  /// bottom 左侧按钮文案，覆盖默认「取消」。
  final String? cancelBtn;

  /// bottom 左侧按钮；默认 [kPopupActionDefault] 表示默认文案，传 null 隐藏左侧。
  final Widget? cancel;

  /// bottom 左侧按钮构建器，优先级高于 [cancel]。
  final WidgetBuilder? cancelBuilder;

  /// 点击 bottom 左侧按钮回调。
  final VoidCallback? onCancel;

  /// bottom 右侧按钮文案，覆盖默认「确定」。
  final String? confirmBtn;

  /// bottom 右侧按钮；默认 [kPopupActionDefault]，传 null 隐藏右侧。
  final Widget? confirm;

  /// bottom 右侧按钮构建器，优先级高于 [confirm]。
  final WidgetBuilder? confirmBuilder;

  /// 点击 bottom 右侧按钮回调。
  final VoidCallback? onConfirm;

  /// 点击取消后是否自动关闭，默认 true。
  final bool autoCloseOnCancel;

  /// 点击确定后是否自动关闭，默认 true。
  final bool autoCloseOnConfirm;

  /// center 关闭区：`null` 不显示；未传则用 [kPopupDefaultClose]；bottom 与三边忽略。
  final TPopupCloseBuilder? closeBuilder;

  /// center 点击关闭控件前的回调。
  final VoidCallback? onCloseBtn;

  /// bottom 头部：`null` 无头部；未传则用 [kPopupDefaultHeader]；自定义见 [TPopupHeaderBuilder]。
  final TPopupHeaderBuilder? headerBuilder;

  /// 开始打开时回调（路由入栈）。
  final VoidCallback? onOpen;

  /// 打开动画结束后回调。
  final VoidCallback? onOpened;

  /// 开始关闭时回调。
  final VoidCallback? onClose;

  /// 关闭动画结束且路由移除后回调。
  final VoidCallback? onClosed;

  /// 显隐变化及触发来源。
  final TPopupVisibleChangeCallback? onVisibleChange;

  /// 点击蒙层时回调（在是否关闭判断之前）。
  final VoidCallback? onOverlayClick;

  /// 按 [placement] 裁剪无效字段，得到路由实际使用的配置副本。
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
      title: isBottom ? title : null,
      titleWidget: isBottom ? titleWidget : null,
      titleAlignLeft: isBottom ? titleAlignLeft : false,
      cancelBtn: isBottom ? cancelBtn : null,
      cancel: isBottom ? cancel : null,
      cancelBuilder: isBottom ? cancelBuilder : null,
      onCancel: isBottom ? onCancel : null,
      confirmBtn: isBottom ? confirmBtn : null,
      confirm: isBottom ? confirm : null,
      confirmBuilder: isBottom ? confirmBuilder : null,
      onConfirm: isBottom ? onConfirm : null,
      autoCloseOnCancel: autoCloseOnCancel,
      autoCloseOnConfirm: autoCloseOnConfirm,
      closeBuilder: isCenter ? closeBuilder : null,
      onCloseBtn: isCenter ? onCloseBtn : null,
      headerBuilder: isBottom ? headerBuilder : null,
      onOpen: onOpen,
      onOpened: onOpened,
      onClose: onClose,
      onClosed: onClosed,
      onVisibleChange: onVisibleChange,
      onOverlayClick: onOverlayClick,
    );
  }

  bool get showCancelSlot =>
      placement == TPopupPlacement.bottom &&
      (cancelBuilder != null || cancel != null);

  bool get showConfirmSlot =>
      placement == TPopupPlacement.bottom &&
      (confirmBuilder != null || confirm != null);

  bool get hasNoHeader =>
      placement == TPopupPlacement.bottom && headerBuilder == null;

  bool get useActionHeader =>
      placement == TPopupPlacement.bottom &&
      isPopupDefaultHeader(headerBuilder) &&
      (showCancelSlot || showConfirmSlot);

  bool get useCustomHeader =>
      placement == TPopupPlacement.bottom &&
      headerBuilder != null &&
      !isPopupDefaultHeader(headerBuilder);

  static bool isActionDefault(Widget? action) => action is TPopupActionDefault;

  bool get useTitleOnlyHeader =>
      placement == TPopupPlacement.bottom &&
      isPopupDefaultHeader(headerBuilder) &&
      !showCancelSlot &&
      !showConfirmSlot &&
      ((title != null && title!.isNotEmpty) || titleWidget != null);

  bool get hasBuiltInHeader =>
      placement == TPopupPlacement.bottom &&
      !hasNoHeader &&
      (useCustomHeader || useActionHeader || useTitleOnlyHeader);

  /// Debug 下检查易误用参数（如 bottom 传 `width`），仅 `debugPrint` 不抛错。
  void assertPlacementParams() {
    assert(() {
      switch (placement) {
        case TPopupPlacement.left:
        case TPopupPlacement.right:
          if (height != null) {
            debugPrint(
              'TPopup: height is ignored for placement=$placement',
            );
          }
          break;
        case TPopupPlacement.center:
          if (height != null && closeBuilder == null) {
            debugPrint(
              'TPopup: height is ignored for placement=$placement',
            );
          }
          break;
        case TPopupPlacement.top:
        case TPopupPlacement.bottom:
          if (width != null) {
            debugPrint(
              'TPopup: width is ignored for placement=$placement',
            );
          }
          break;
      }
      if (placement != TPopupPlacement.bottom &&
          (cancel != null ||
              confirm != null ||
              cancelBuilder != null ||
              confirmBuilder != null)) {
        debugPrint(
          'TPopup: cancel/confirm only applies to placement=bottom',
        );
      }
      return true;
    }());
  }
}
