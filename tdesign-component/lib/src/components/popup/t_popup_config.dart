import 'package:flutter/material.dart';

import 't_popup_types.dart';

/// Popup 运行时配置（库内共享，由 [TPopup.show] 通过 [TPopupConfig.create] 构建）。
class TPopupConfig {
  TPopupConfig({
    required this.child,
    required this.placement,
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
    this.cancel,
    this.cancelBuilder,
    this.onCancel,
    this.confirmBtn,
    this.confirm,
    this.confirmBuilder,
    this.onConfirm,
    this.autoCloseOnCancel = true,
    this.autoCloseOnConfirm = true,
    this.closeBuilder,
    this.onCloseBtn,
    this.headerBuilder,
    this.onOpen,
    this.onOpened,
    this.onClose,
    this.onClosed,
    this.onVisibleChange,
    this.onOverlayClick,
  });

  /// 按 [placement] 归一化参数（bottom/三边忽略 closeBuilder；center 默认 [kPopupDefaultClose]）。
  factory TPopupConfig.create({
    required Widget child,
    TPopupPlacement placement = TPopupPlacement.bottom,
    double? width,
    double? height,
    EdgeInsets margin = EdgeInsets.zero,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    Color? overlayColor,
    double? overlayOpacity,
    bool preventScrollThrough = true,
    bool destroyOnClose = false,
    Duration duration = const Duration(milliseconds: 240),
    String? title,
    Widget? titleWidget,
    bool titleAlignLeft = false,
    String? cancelBtn,
    Widget? cancel = kPopupActionDefault,
    WidgetBuilder? cancelBuilder,
    VoidCallback? onCancel,
    String? confirmBtn,
    Widget? confirm = kPopupActionDefault,
    WidgetBuilder? confirmBuilder,
    VoidCallback? onConfirm,
    bool autoCloseOnCancel = true,
    bool autoCloseOnConfirm = true,
    TPopupCloseBuilder? closeBuilder = kPopupDefaultClose,
    VoidCallback? onCloseBtn,
    TPopupHeaderBuilder? headerBuilder = kPopupDefaultHeader,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
  }) {
    final isBottom = placement == TPopupPlacement.bottom;
    final isCenter = placement == TPopupPlacement.center;
    final effectiveCloseBuilder = isCenter ? closeBuilder : null;

    return TPopupConfig(
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
      closeBuilder: effectiveCloseBuilder,
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

  final Widget child;
  final TPopupPlacement placement;
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final double? radius;
  final Color? backgroundColor;
  final bool showOverlay;
  final bool closeOnOverlayClick;
  final Color? overlayColor;
  final double? overlayOpacity;
  final bool preventScrollThrough;

  /// 为 true 时路由 maintainState 为 false，关闭后丢弃 Popup 路由 State。
  final bool destroyOnClose;
  final Duration duration;

  final String? title;
  final Widget? titleWidget;
  final bool titleAlignLeft;
  final String? cancelBtn;
  final Widget? cancel;
  final WidgetBuilder? cancelBuilder;
  final VoidCallback? onCancel;
  final String? confirmBtn;
  final Widget? confirm;
  final WidgetBuilder? confirmBuilder;
  final VoidCallback? onConfirm;
  final bool autoCloseOnCancel;
  final bool autoCloseOnConfirm;

  /// center 关闭区：`null` 不显示；未传则用 [kPopupDefaultClose]；自定义见 [TPopupCloseBuilder]。
  final TPopupCloseBuilder? closeBuilder;

  final VoidCallback? onCloseBtn;

  final TPopupHeaderBuilder? headerBuilder;

  final VoidCallback? onOpen;
  final VoidCallback? onOpened;
  final VoidCallback? onClose;
  final VoidCallback? onClosed;
  final TPopupVisibleChangeCallback? onVisibleChange;
  final VoidCallback? onOverlayClick;

  /// bottom 左侧是否渲染（[cancel] 为 `null` 时隐藏，未传则用默认文案）。
  bool get showCancelSlot =>
      placement == TPopupPlacement.bottom &&
      (cancelBuilder != null || cancel != null);

  /// bottom 右侧是否渲染。
  bool get showConfirmSlot =>
      placement == TPopupPlacement.bottom &&
      (confirmBuilder != null || confirm != null);

  /// 不渲染 bottom 头部（显式 [headerBuilder: null]）。
  bool get hasNoHeader =>
      placement == TPopupPlacement.bottom && headerBuilder == null;

  /// 使用内置操作栏（未传 headerBuilder，占位为 [kPopupDefaultHeader]）。
  bool get useActionHeader =>
      placement == TPopupPlacement.bottom &&
      isPopupDefaultHeader(headerBuilder) &&
      (showCancelSlot || showConfirmSlot);

  /// 自定义头部（非 null 且非默认占位）。
  bool get useCustomHeader =>
      placement == TPopupPlacement.bottom &&
      headerBuilder != null &&
      !isPopupDefaultHeader(headerBuilder);

  static bool isActionDefault(Widget? action) => action is TPopupActionDefault;

  /// bottom 仅标题行（默认头部占位 + 无 cancel/confirm 槽 + 有 title）。
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
