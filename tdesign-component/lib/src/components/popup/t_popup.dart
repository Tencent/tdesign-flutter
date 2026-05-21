import 'package:flutter/material.dart';

import '_popup_route.dart';
import 't_popup_config.dart';
import 't_popup_tracker.dart';
import 't_popup_types.dart';

export 't_popup_types.dart';

/// 弹出层。
class TPopup extends StatefulWidget {
  const TPopup({
    super.key,
    required this.child,
    this.initialVisible = false,
    this.placement = TPopupPlacement.bottom,
    this.width,
    this.height,
    this.margin,
    this.radius,
    this.backgroundColor,
    this.showOverlay = true,
    this.closeOnOverlayClick = true,
    this.overlayColor,
    this.overlayOpacity,
    this.preventScrollThrough = true,
    /// 关闭后 Popup 路由是否不再 [maintainState]（不保留路由内 State）。
    /// 不影响声明式 [TPopup] 自身 [State] 的存活。
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
    this.closeBtn,
    Widget? close,
    this.closeBuilder,
    this.closeBelowContent,
    this.onCloseBtn,
    this.headerBuilder,
    this.onOpen,
    this.onOpened,
    this.onClose,
    this.onClosed,
    this.onVisibleChange,
    this.onOverlayClick,
    this.navigatorContext,
    this.useRootNavigator = false,
  }) : closeWidget = close;

  final Widget child;
  final bool initialVisible;

  final TPopupPlacement placement;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final double? radius;
  final Color? backgroundColor;
  final bool showOverlay;
  final bool closeOnOverlayClick;
  final Color? overlayColor;
  final double? overlayOpacity;
  final bool preventScrollThrough;

  /// 关闭后 Popup 路由是否不再 [maintainState]（不保留路由内 State）。
  /// 不影响声明式 [TPopup] 自身 [State] 的存活。
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

  /// center 默认 true；bottom / 三边忽略。
  final bool? closeBtn;
  /// [TPopupPlacement.center] 自定义关闭控件；构造参数名为 [close]（与 [show] 一致）。
  final Widget? closeWidget;
  final WidgetBuilder? closeBuilder;

  /// center 且显示关闭时默认 true。
  final bool? closeBelowContent;
  final VoidCallback? onCloseBtn;

  /// 仅 [TPopupPlacement.bottom] 生效。
  final WidgetBuilder? headerBuilder;

  final VoidCallback? onOpen;
  final VoidCallback? onOpened;
  final VoidCallback? onClose;
  final VoidCallback? onClosed;
  final TPopupVisibleChangeCallback? onVisibleChange;
  final VoidCallback? onOverlayClick;

  final BuildContext? navigatorContext;
  final bool useRootNavigator;

  /// 打开浮层。
  static TPopupHandle show({
    required BuildContext context,
    required Widget child,
    TPopupPlacement placement = TPopupPlacement.bottom,
    double? width,
    double? height,
    EdgeInsets? margin,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    Color? overlayColor,
    double? overlayOpacity,
    bool preventScrollThrough = true,
    /// 关闭后 Popup 路由是否不再 [maintainState]（不保留路由内 State）。
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
    bool? closeBtn,
    Widget? close,
    WidgetBuilder? closeBuilder,
    bool? closeBelowContent,
    VoidCallback? onCloseBtn,
    WidgetBuilder? headerBuilder,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
    BuildContext? navigatorContext,
    bool useRootNavigator = false,
  }) {
    final config = TPopupConfig.create(
      child: child,
      placement: placement,
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.zero,
      radius: radius,
      backgroundColor: backgroundColor,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      preventScrollThrough: preventScrollThrough,
      destroyOnClose: destroyOnClose,
      duration: duration,
      title: title,
      titleWidget: titleWidget,
      titleAlignLeft: titleAlignLeft,
      cancelBtn: cancelBtn,
      cancel: cancel,
      cancelBuilder: cancelBuilder,
      onCancel: onCancel,
      confirmBtn: confirmBtn,
      confirm: confirm,
      confirmBuilder: confirmBuilder,
      onConfirm: onConfirm,
      autoCloseOnCancel: autoCloseOnCancel,
      autoCloseOnConfirm: autoCloseOnConfirm,
      closeBtn: closeBtn,
      close: close,
      closeBuilder: closeBuilder,
      closeBelowContent: closeBelowContent,
      onCloseBtn: onCloseBtn,
      headerBuilder: headerBuilder,
      onOpen: onOpen,
      onOpened: onOpened,
      onClose: onClose,
      onClosed: onClosed,
      onVisibleChange: onVisibleChange,
      onOverlayClick: onOverlayClick,
    );
    config.assertPlacementParams();

    final navContext = navigatorContext ?? context;
    final navigator = Navigator.of(
      navContext,
      rootNavigator: useRootNavigator,
    );

    TPopupNavigatorRoute<dynamic>? route;
    late TPopupHandle handle;

    void closeWithTrigger(TPopupTrigger trigger, [Object? result]) {
      if (handle._isClosed) {
        return;
      }
      handle._isClosed = true;
      route?.fireCloseStart(trigger);
      navigator.pop(result);
    }

    route = TPopupNavigatorRoute<dynamic>(
      config: config,
      onCloseWithTrigger: closeWithTrigger,
    );

    handle = TPopupHandle._(
      navigator: navigator,
      route: route,
      onCloseWithTrigger: closeWithTrigger,
    );

    TPopupTracker.push(navigator, handle);

    navigator.push(route).whenComplete(() {
      TPopupTracker.remove(navigator, handle);
      handle._isClosed = true;
      handle._route = null;
    });

    return handle;
  }

  /// 关闭当前 Navigator 栈顶 [TPopup]；触发与 [TPopupHandle.close] 相同的生命周期回调。
  static void close(BuildContext context, [Object? result]) {
    final navigator = Navigator.of(context);
    final handle = TPopupTracker.top(navigator);
    if (handle?.isShowing == true) {
      handle!.close(result);
      return;
    }
    navigator.maybePop(result);
  }

  @override
  State<TPopup> createState() => _TPopupState();
}

class _TPopupState extends State<TPopup> {
  TPopupHandle? _handle;

  @override
  void initState() {
    super.initState();
    if (widget.initialVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _open());
    }
  }

  @override
  void dispose() {
    _handle?.close();
    super.dispose();
  }

  void _open() {
    if (_handle?.isShowing == true) {
      return;
    }
    _handle = TPopup.show(
      context: context,
      navigatorContext: widget.navigatorContext ?? context,
      useRootNavigator: widget.useRootNavigator,
      child: widget.child,
      placement: widget.placement,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      showOverlay: widget.showOverlay,
      closeOnOverlayClick: widget.closeOnOverlayClick,
      overlayColor: widget.overlayColor,
      overlayOpacity: widget.overlayOpacity,
      preventScrollThrough: widget.preventScrollThrough,
      destroyOnClose: widget.destroyOnClose,
      duration: widget.duration,
      title: widget.title,
      titleWidget: widget.titleWidget,
      titleAlignLeft: widget.titleAlignLeft,
      cancelBtn: widget.cancelBtn,
      cancel: widget.cancel,
      cancelBuilder: widget.cancelBuilder,
      onCancel: widget.onCancel,
      confirmBtn: widget.confirmBtn,
      confirm: widget.confirm,
      confirmBuilder: widget.confirmBuilder,
      onConfirm: widget.onConfirm,
      autoCloseOnCancel: widget.autoCloseOnCancel,
      autoCloseOnConfirm: widget.autoCloseOnConfirm,
      closeBtn: widget.closeBtn,
      close: widget.closeWidget,
      closeBuilder: widget.closeBuilder,
      closeBelowContent: widget.closeBelowContent,
      onCloseBtn: widget.onCloseBtn,
      headerBuilder: widget.headerBuilder,
      onOpen: widget.onOpen,
      onOpened: widget.onOpened,
      onClose: widget.onClose,
      onClosed: widget.onClosed,
      onVisibleChange: widget.onVisibleChange,
      onOverlayClick: widget.onOverlayClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// [TPopup.show] 返回的句柄。
class TPopupHandle {
  TPopupHandle._({
    required NavigatorState navigator,
    required TPopupNavigatorRoute<dynamic>? route,
    required void Function(TPopupTrigger trigger, [Object? result])
        onCloseWithTrigger,
  })  : _route = route,
        _onCloseWithTrigger = onCloseWithTrigger;

  TPopupNavigatorRoute<dynamic>? _route;
  final void Function(TPopupTrigger trigger, [Object? result])
      _onCloseWithTrigger;
  bool _isClosed = false;

  bool get isShowing => _route != null && !_isClosed;

  void close([Object? result]) {
    if (!isShowing) {
      return;
    }
    _onCloseWithTrigger(TPopupTrigger.programmatic, result);
  }
}
