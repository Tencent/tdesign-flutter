import 'package:flutter/material.dart';

import '_popup_route.dart';
import 't_popup_config.dart';
import 't_popup_types.dart';

export 't_popup_types.dart';

part 't_popup_handle.dart';
part 't_popup_tracker.dart';

/// 弹出层：支持五向滑入/居中弹出、蒙层、bottom 操作栏与 center 关闭区。
///
/// 命令式用法优先调用 [show]；声明式将 [TPopup] 包裹业务子树并设 [initialVisible]（弹层在独立路由中，[build] 仅渲染 [child]）。
/// bottom 操作栏参数仅对 [TPopupPlacement.bottom] 生效；center 关闭参数仅对 center 生效；
/// top/left/right 仅使用 [child] 与布局参数。
/// 嵌套时 [close] 只关栈顶 Popup；无 Popup 时不操作当前页。
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
    this.navigatorContext,
    this.useRootNavigator = false,
  });

  /// 浮层主体内容（必填）。
  final Widget child;

  /// 声明式：为 true 时在首帧后自动 [show]。
  final bool initialVisible;

  /// 出现位置，默认 [TPopupPlacement.bottom]。
  final TPopupPlacement placement;

  /// 宽度；对 left、right、center 生效。
  final double? width;

  /// 高度；对 top、bottom 生效；center 且下方关闭时约束内容区高度。
  final double? height;

  /// 外边距；center 忽略。bottom 的 top 可用来做日历式距顶留白。
  final EdgeInsets? margin;

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

  /// 为 true 时 Popup 路由 [Route.maintainState] 为 false，关闭后不保留路由内 State；
  /// 不销毁包裹 [TPopup] 的 StatefulWidget State。
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

  /// center 关闭区：`null` 不显示；未传则用 [kPopupDefaultClose] 默认圆圈图标；
  /// 自定义时通过 [close] 回调关闭。bottom 与三边忽略。
  final TPopupCloseBuilder? closeBuilder;

  /// center 点击关闭控件前的回调。
  final VoidCallback? onCloseBtn;

  /// bottom 头部：`null` 无头部；未传则用 [kPopupDefaultHeader] 默认操作栏；自定义见 [TPopupHeaderBuilder]。
  final TPopupHeaderBuilder? headerBuilder;

  /// 开始打开时回调（路由入栈）。
  final VoidCallback? onOpen;

  /// 打开动画结束后回调。
  final VoidCallback? onOpened;

  /// 开始关闭时回调（含蒙层、按钮、程序化关闭）。
  final VoidCallback? onClose;

  /// 关闭动画结束且路由移除后回调。
  final VoidCallback? onClosed;

  /// 显隐变化及触发来源。
  final TPopupVisibleChangeCallback? onVisibleChange;

  /// 点击蒙层时回调（在是否关闭判断之前）。
  final VoidCallback? onOverlayClick;

  /// 指定 Navigator 的 context，默认使用当前 context。
  final BuildContext? navigatorContext;

  /// 是否使用根 Navigator。
  final bool useRootNavigator;

  /// 命令式打开浮层，参数与 [TPopup] 构造器一致。
  ///
  /// 返回 [TPopupHandle]；优先 [TPopupHandle.close]，或在 Popup 子树内 [close]。
  ///
  /// [cancel]/[confirm] 默认 [kPopupActionDefault] 表示默认文案，显式 null 可隐藏操作栏侧。
  /// [closeBuilder] 未传为 [kPopupDefaultClose]（默认关闭图标），显式 null 不显示关闭区。
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
      closeBuilder: closeBuilder,
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

    final existing = TPopupTracker.top(navigator);
    if (existing != null &&
        existing.isShowing &&
        ModalRoute.of(context) is! TPopupNavigatorRoute) {
      return existing;
    }

    TPopupNavigatorRoute<dynamic>? route;
    late TPopupHandle handle;

    void closeWithTrigger(TPopupTrigger trigger, [Object? result]) {
      if (!handle.isShowing) {
        return;
      }
      handle._markClosing();
      route?.fireCloseStart(trigger);
      navigator.pop(result);
    }

    route = TPopupNavigatorRoute<dynamic>(
      config: config,
      onCloseWithTrigger: closeWithTrigger,
    );

    handle = TPopupHandle._(
      route: route,
      onCloseWithTrigger: closeWithTrigger,
    );

    TPopupTracker.push(navigator, handle);

    navigator.push(route).whenComplete(() {
      TPopupTracker.remove(navigator, handle);
      handle._detachRoute();
    });

    return handle;
  }

  /// 关闭当前 Navigator 栈顶 [TPopup]。
  ///
  /// 仅关闭 Tracker 栈顶展示中的 Popup；无 Popup 时不操作（不会 pop 当前页）。
  static void close(BuildContext context, [Object? result]) {
    final navigator = Navigator.of(context);
    final handle = TPopupTracker.top(navigator);
    if (handle?.isShowing == true) {
      handle!.close(result);
    }
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
      closeBuilder: widget.closeBuilder,
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
