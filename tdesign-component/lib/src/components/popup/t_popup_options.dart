part of 't_popup.dart';

/// 用于 [TPopupOptions.copyWith] 区分"不传"与"显式 null"。
const Object _unset = Object();

Never _throwPopupOptionsValidationError(String error) {
  throw FlutterError('TPopupOptions: $error');
}

/// [TPopup.show] 的配置对象。
///
/// ## 如何创建
///
/// | 场景 | 推荐用法 |
/// |------|----------|
/// | 弹出方向已知 | [TPopupOptions.bottom]、[TPopupOptions.center]、[TPopupOptions.top]、[TPopupOptions.left]、[TPopupOptions.right] |
/// | 方向由变量决定 | 默认构造并设置 [placement]；传错字段会在 [TPopup.show] / [TPopupHandle.open] 时抛 [FlutterError] |
///
/// 命名工厂只暴露当前方向生效的字段（例如 [TPopupOptions.bottom] 无 [width] 参数）。
///
/// ## 字段与 [TPopupPlacement]
///
/// | [TPopupPlacement] | 头部 / 关闭区 | 尺寸 |
/// |-------------------|-------------|------|
/// | [TPopupPlacement.bottom] | [headerBuilder]、[titleWidget]、[cancelBuilder]、[confirmBuilder] | [height]、[inset] |
/// | [TPopupPlacement.center] | [closeBuilder] | [width]、[height] |
/// | [TPopupPlacement.top] | — | [height]、[inset] |
/// | [TPopupPlacement.left]、[TPopupPlacement.right] | — | [width]、[inset] |
///
/// ## Builder 三态（[headerBuilder]、[cancelBuilder]、[confirmBuilder]、[closeBuilder]）
///
/// | 传参方式 | 效果 |
/// |----------|------|
/// | 省略（使用默认值） | 渲染内置 UI |
/// | 显式 `null` | 隐藏该区域 |
/// | 自定义 [TPopupHeaderBuilder] / [TPopupSlotBuilder] | 完全替换；需自行提供交互与语义，可调用 `close` 关闭浮层 |
///
/// [titleWidget] 默认为 `null`，表示无标题内容。
///
/// 生命周期回调见 [onOpen]、[onOpened]、[onClose]、[onClosed]、[onVisibleChange]、[onOverlayClick]。
class TPopupOptions {
  /// 通用构造；[placement] 在运行时才能确定时使用。
  ///
  /// 方向已知时请优先使用 [TPopupOptions.bottom] 等命名工厂。
  const TPopupOptions({
    required this.child,
    this.placement = TPopupPlacement.bottom,
    this.width,
    this.height,
    this.inset,
    this.radius,
    this.backgroundColor,
    this.showOverlay = true,

    /// 点击蒙层时是否关闭浮层；未传时跟随 [showOverlay]。
    bool? closeOnOverlayClick,
    this.overlayColor,
    this.overlayOpacity,
    this.modal = true,
    this.destroyOnClose = false,
    this.animationDuration,
    this.headerBuilder = _kPopupDefaultHeader,
    this.titleWidget,
    this.cancelBuilder = _kPopupDefaultCancel,
    this.confirmBuilder = _kPopupDefaultConfirm,
    this.closeBuilder = _kPopupDefaultClose,
    this.onOpen,
    this.onOpened,
    this.onClose,
    this.onClosed,
    this.onVisibleChange,
    this.onOverlayClick,
    this.useSafeArea = true,
  }) : _closeOnOverlayClick = closeOnOverlayClick;

  /// 创建 [TPopupPlacement.bottom] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.bottom]；默认带内置头部。
  /// 蒙层、动画、生命周期等字段语义见同名成员文档。
  factory TPopupOptions.bottom({
    required Widget child,
    double? height,
    TPopupBottomInset? inset,
    TPopupHeaderBuilder? headerBuilder = _kPopupDefaultHeader,
    Widget? titleWidget,
    TPopupSlotBuilder? cancelBuilder = _kPopupDefaultCancel,
    TPopupSlotBuilder? confirmBuilder = _kPopupDefaultConfirm,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,

    /// 点击蒙层时是否关闭浮层；未传时跟随 [showOverlay]。
    bool? closeOnOverlayClick,
    Color? overlayColor,
    double? overlayOpacity,
    bool modal = true,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
    bool useSafeArea = true,
  }) =>
      TPopupOptions(
        child: child,
        placement: TPopupPlacement.bottom,
        height: height,
        inset: inset,
        headerBuilder: headerBuilder,
        titleWidget: titleWidget,
        cancelBuilder: cancelBuilder,
        confirmBuilder: confirmBuilder,
        radius: radius,
        backgroundColor: backgroundColor,
        showOverlay: showOverlay,
        closeOnOverlayClick: closeOnOverlayClick,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
        modal: modal,
        destroyOnClose: destroyOnClose,
        animationDuration: animationDuration,
        onOpen: onOpen,
        onOpened: onOpened,
        onClose: onClose,
        onClosed: onClosed,
        onVisibleChange: onVisibleChange,
        onOverlayClick: onOverlayClick,
        useSafeArea: useSafeArea,
      );

  /// 创建 [TPopupPlacement.center] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.center]；默认展示面板外下方圆形关闭按钮。
  factory TPopupOptions.center({
    required Widget child,
    double? width,
    double? height,
    TPopupSlotBuilder? closeBuilder = _kPopupDefaultClose,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,

    /// 点击蒙层时是否关闭浮层；未传时跟随 [showOverlay]。
    bool? closeOnOverlayClick,
    Color? overlayColor,
    double? overlayOpacity,
    bool modal = true,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
    bool useSafeArea = true,
  }) =>
      TPopupOptions(
        child: child,
        placement: TPopupPlacement.center,
        width: width,
        height: height,
        closeBuilder: closeBuilder,
        radius: radius,
        backgroundColor: backgroundColor,
        showOverlay: showOverlay,
        closeOnOverlayClick: closeOnOverlayClick,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
        modal: modal,
        destroyOnClose: destroyOnClose,
        animationDuration: animationDuration,
        onOpen: onOpen,
        onOpened: onOpened,
        onClose: onClose,
        onClosed: onClosed,
        onVisibleChange: onVisibleChange,
        onOverlayClick: onOverlayClick,
        useSafeArea: useSafeArea,
      );

  /// 创建 [TPopupPlacement.top] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.top]；无内置头部。
  factory TPopupOptions.top({
    required Widget child,
    double? height,
    TPopupTopInset? inset,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,

    /// 点击蒙层时是否关闭浮层；未传时跟随 [showOverlay]。
    bool? closeOnOverlayClick,
    Color? overlayColor,
    double? overlayOpacity,
    bool modal = true,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
    bool useSafeArea = true,
  }) =>
      TPopupOptions(
        child: child,
        placement: TPopupPlacement.top,
        height: height,
        inset: inset,
        radius: radius,
        backgroundColor: backgroundColor,
        showOverlay: showOverlay,
        closeOnOverlayClick: closeOnOverlayClick,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
        modal: modal,
        destroyOnClose: destroyOnClose,
        animationDuration: animationDuration,
        onOpen: onOpen,
        onOpened: onOpened,
        onClose: onClose,
        onClosed: onClosed,
        onVisibleChange: onVisibleChange,
        onOverlayClick: onOverlayClick,
        useSafeArea: useSafeArea,
      );

  /// 创建 [TPopupPlacement.left] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.left]；未传 [width] 时布局默认宽度 280。
  factory TPopupOptions.left({
    required Widget child,
    double? width,
    TPopupLeftInset? inset,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,

    /// 点击蒙层时是否关闭浮层；未传时跟随 [showOverlay]。
    bool? closeOnOverlayClick,
    Color? overlayColor,
    double? overlayOpacity,
    bool modal = true,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
    bool useSafeArea = true,
  }) =>
      TPopupOptions(
        child: child,
        placement: TPopupPlacement.left,
        width: width,
        inset: inset,
        radius: radius,
        backgroundColor: backgroundColor,
        showOverlay: showOverlay,
        closeOnOverlayClick: closeOnOverlayClick,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
        modal: modal,
        destroyOnClose: destroyOnClose,
        animationDuration: animationDuration,
        onOpen: onOpen,
        onOpened: onOpened,
        onClose: onClose,
        onClosed: onClosed,
        onVisibleChange: onVisibleChange,
        onOverlayClick: onOverlayClick,
        useSafeArea: useSafeArea,
      );

  /// 创建 [TPopupPlacement.right] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.right]；未传 [width] 时布局默认宽度 280。
  factory TPopupOptions.right({
    required Widget child,
    double? width,
    TPopupRightInset? inset,
    double? radius,
    Color? backgroundColor,
    bool showOverlay = true,

    /// 点击蒙层时是否关闭浮层；未传时跟随 [showOverlay]。
    bool? closeOnOverlayClick,
    Color? overlayColor,
    double? overlayOpacity,
    bool modal = true,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    VoidCallback? onOverlayClick,
    bool useSafeArea = true,
  }) =>
      TPopupOptions(
        child: child,
        placement: TPopupPlacement.right,
        width: width,
        inset: inset,
        radius: radius,
        backgroundColor: backgroundColor,
        showOverlay: showOverlay,
        closeOnOverlayClick: closeOnOverlayClick,
        overlayColor: overlayColor,
        overlayOpacity: overlayOpacity,
        modal: modal,
        destroyOnClose: destroyOnClose,
        animationDuration: animationDuration,
        onOpen: onOpen,
        onOpened: onOpened,
        onClose: onClose,
        onClosed: onClosed,
        onVisibleChange: onVisibleChange,
        onOverlayClick: onOverlayClick,
        useSafeArea: useSafeArea,
      );

  /// 浮层主体内容（必填）。
  final Widget child;

  /// 出现位置，默认 [TPopupPlacement.bottom]。
  final TPopupPlacement placement;

  /// 宽度；[TPopupPlacement.left]、[TPopupPlacement.right]、[TPopupPlacement.center] 生效。
  ///
  /// left / right 未传时默认 280；center 未传时默认 240。
  final double? width;

  /// 高度；[TPopupPlacement.top]、[TPopupPlacement.bottom] 生效；[TPopupPlacement.center] 约束面板尺寸。
  ///
  /// top / bottom 未传时默认 240；center 未传时默认 240。
  final double? height;

  /// 交叉轴边缘留白；具体类型由 [placement] 决定。
  ///
  /// * [TPopupPlacement.bottom] 使用 [TPopupBottomInset]
  /// * [TPopupPlacement.top] 使用 [TPopupTopInset]
  /// * [TPopupPlacement.left] 使用 [TPopupLeftInset]
  /// * [TPopupPlacement.right] 使用 [TPopupRightInset]
  /// * [TPopupPlacement.center] 不支持
  final TPopupInset? inset;

  /// 内容区圆角。
  ///
  /// [TPopupPlacement.top]、[TPopupPlacement.bottom]、[TPopupPlacement.center]
  /// 默认取主题大圆角；[TPopupPlacement.left]、[TPopupPlacement.right]
  /// 默认**无圆角**（对齐官方全高矩形），仅当显式设置本字段或通过
  /// [TPopupThemeData.panelRadius] 注入时应用圆角。
  final double? radius;

  /// 内容区背景色，默认主题容器色。
  final Color? backgroundColor;

  /// 是否绘制半透明蒙层。
  ///
  /// 当 [modal] 为 true 且此值为 false 时，为“透明模态弹层”。
  final bool showOverlay;

  final bool? _closeOnOverlayClick;

  /// 点击可见蒙层是否关闭。
  ///
  /// 省略时默认跟随 [showOverlay]：显示蒙层时为 true，否则为 false。
  bool get closeOnOverlayClick => _closeOnOverlayClick ?? showOverlay;

  /// 蒙层颜色，默认 black54。
  final Color? overlayColor;

  /// 蒙层透明度系数（0–1），与 [overlayColor] 的 alpha 相乘后用于绘制。
  final double? overlayOpacity;

  /// 是否以模态方式展示；为 true 时阻断背景交互与底层语义/焦点。
  ///
  /// 结合 [showOverlay] 可表达三种模式：
  /// * `modal=true, showOverlay=true`：标准模态弹层
  /// * `modal=true, showOverlay=false`：透明模态弹层
  /// * `modal=false, showOverlay=false`：非模态浮层
  final bool modal;

  /// 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。
  final bool destroyOnClose;

  /// 打开/关闭动画时长，默认 300ms（与官方及仓库其他浮层组件对齐）。
  final Duration? animationDuration;

  /// bottom 头部；仅 [TPopupPlacement.bottom] 生效。三态见类文档「Builder 三态」。
  ///
  /// 自定义时忽略 [titleWidget]、[cancelBuilder]、[confirmBuilder]。
  final TPopupHeaderBuilder? headerBuilder;

  /// bottom 标题插槽；仅 [headerBuilder] 为内置默认时生效。`null` 表示无标题。
  final Widget? titleWidget;

  /// bottom 左侧操作槽；仅 [headerBuilder] 为内置默认时生效。
  ///
  /// 内置默认为「取消」，点击触发 [TPopupTrigger.cancel]。
  final TPopupSlotBuilder? cancelBuilder;

  /// bottom 右侧操作槽；仅 [headerBuilder] 为内置默认时生效。
  ///
  /// 内置默认为「确定」，点击触发 [TPopupTrigger.confirm]。
  final TPopupSlotBuilder? confirmBuilder;

  /// center 面板外下方关闭区；仅 [TPopupPlacement.center] 生效。三态见类文档「Builder 三态」。
  ///
  /// 内置默认点击触发 [TPopupTrigger.close]。
  final TPopupSlotBuilder? closeBuilder;

  /// 路由 push 时（打开动画开始前）。
  final VoidCallback? onOpen;

  /// 打开动画结束。
  final VoidCallback? onOpened;

  /// 开始关闭（与 [onVisibleChange] 的 `visible: false` 同期）。
  final VoidCallback? onClose;

  /// 当前展示周期真正结束。
  ///
  /// 大多数场景下会在关闭动画结束后触发；非栈顶路由被直接移除时不保证存在关闭动画。
  final VoidCallback? onClosed;

  /// 显隐变化；第二个参数为 [TPopupTrigger]。
  final TPopupVisibleChangeCallback? onVisibleChange;

  /// 蒙层点击；是否关闭取决于 [closeOnOverlayClick]。
  final VoidCallback? onOverlayClick;

  /// 是否避让系统安全区，默认 true；center 使用完整安全区，其他方向避让贴边侧及相邻边。
  ///
  /// 为 true 时通过 [Positioned] 偏移使面板不侵入刘海、Home Indicator 等区域；
  /// top/bottom/left/right 还会与对应 [inset] 叠加。设为 false 可贴满屏幕边缘。
  final bool useSafeArea;

  /// 返回配置副本。
  ///
  /// 未传入的字段保持原值；对头部/关闭相关插槽显式传入 `null` 表示隐藏该区域。
  TPopupOptions copyWith({
    Widget? child,
    TPopupPlacement? placement,
    Object? width = _unset,
    Object? height = _unset,
    Object? inset = _unset,
    Object? radius = _unset,
    Object? backgroundColor = _unset,
    bool? showOverlay,
    Object? closeOnOverlayClick = _unset,
    Object? overlayColor = _unset,
    Object? overlayOpacity = _unset,
    bool? modal,
    bool? destroyOnClose,
    Duration? animationDuration,
    Object? headerBuilder = _unset,
    Object? titleWidget = _unset,
    Object? cancelBuilder = _unset,
    Object? confirmBuilder = _unset,
    Object? closeBuilder = _unset,
    Object? onOpen = _unset,
    Object? onOpened = _unset,
    Object? onClose = _unset,
    Object? onClosed = _unset,
    Object? onVisibleChange = _unset,
    Object? onOverlayClick = _unset,
    bool? useSafeArea,
  }) {
    return TPopupOptions(
      child: child ?? this.child,
      placement: placement ?? this.placement,
      width:
          identical(width, _unset) ? this.width : (width as num?)?.toDouble(),
      height: identical(height, _unset)
          ? this.height
          : (height as num?)?.toDouble(),
      inset: identical(inset, _unset) ? this.inset : inset as TPopupInset?,
      radius: identical(radius, _unset)
          ? this.radius
          : (radius as num?)?.toDouble(),
      backgroundColor: identical(backgroundColor, _unset)
          ? this.backgroundColor
          : backgroundColor as Color?,
      showOverlay: showOverlay ?? this.showOverlay,
      closeOnOverlayClick: identical(closeOnOverlayClick, _unset)
          ? _closeOnOverlayClick
          : closeOnOverlayClick as bool?,
      overlayColor: identical(overlayColor, _unset)
          ? this.overlayColor
          : overlayColor as Color?,
      overlayOpacity: identical(overlayOpacity, _unset)
          ? this.overlayOpacity
          : (overlayOpacity as num?)?.toDouble(),
      modal: modal ?? this.modal,
      destroyOnClose: destroyOnClose ?? this.destroyOnClose,
      animationDuration: animationDuration ?? this.animationDuration,
      headerBuilder: identical(headerBuilder, _unset)
          ? this.headerBuilder
          : headerBuilder as TPopupHeaderBuilder?,
      titleWidget: identical(titleWidget, _unset)
          ? this.titleWidget
          : titleWidget as Widget?,
      cancelBuilder: identical(cancelBuilder, _unset)
          ? this.cancelBuilder
          : cancelBuilder as TPopupSlotBuilder?,
      confirmBuilder: identical(confirmBuilder, _unset)
          ? this.confirmBuilder
          : confirmBuilder as TPopupSlotBuilder?,
      closeBuilder: identical(closeBuilder, _unset)
          ? this.closeBuilder
          : closeBuilder as TPopupSlotBuilder?,
      onOpen: identical(onOpen, _unset) ? this.onOpen : onOpen as VoidCallback?,
      onOpened: identical(onOpened, _unset)
          ? this.onOpened
          : onOpened as VoidCallback?,
      onClose:
          identical(onClose, _unset) ? this.onClose : onClose as VoidCallback?,
      onClosed: identical(onClosed, _unset)
          ? this.onClosed
          : onClosed as VoidCallback?,
      onVisibleChange: identical(onVisibleChange, _unset)
          ? this.onVisibleChange
          : onVisibleChange as TPopupVisibleChangeCallback?,
      onOverlayClick: identical(onOverlayClick, _unset)
          ? this.onOverlayClick
          : onOverlayClick as VoidCallback?,
      useSafeArea: useSafeArea ?? this.useSafeArea,
    );
  }

  TPopupOptions normalized() {
    final isBottom = placement == TPopupPlacement.bottom;
    final isCenter = placement == TPopupPlacement.center;

    return TPopupOptions(
      child: child,
      placement: placement,
      width: width,
      height: height,
      inset: inset,
      radius: radius,
      backgroundColor: backgroundColor,
      showOverlay: showOverlay,
      closeOnOverlayClick: _closeOnOverlayClick,
      overlayColor: overlayColor,
      overlayOpacity: overlayOpacity,
      modal: modal,
      destroyOnClose: destroyOnClose,
      animationDuration: animationDuration,
      headerBuilder: isBottom ? headerBuilder : null,
      titleWidget: isBottom ? titleWidget : null,
      cancelBuilder: isBottom ? cancelBuilder : null,
      confirmBuilder: isBottom ? confirmBuilder : null,
      closeBuilder: isCenter ? closeBuilder : null,
      onOpen: onOpen,
      onOpened: onOpened,
      onClose: onClose,
      onClosed: onClosed,
      onVisibleChange: onVisibleChange,
      onOverlayClick: onOverlayClick,
      useSafeArea: useSafeArea,
    );
  }

  bool get usesDefaultHeader => _isPopupDefaultHeader(headerBuilder);

  bool get usesDefaultCancel => _isPopupDefaultCancel(cancelBuilder);

  bool get usesDefaultConfirm => _isPopupDefaultConfirm(confirmBuilder);

  bool get usesDefaultClose => _isPopupDefaultClose(closeBuilder);

  bool get useCustomHeader =>
      placement == TPopupPlacement.bottom &&
      headerBuilder != null &&
      !_isPopupDefaultHeader(headerBuilder);

  bool get useDefaultHeader =>
      placement == TPopupPlacement.bottom &&
      _isPopupDefaultHeader(headerBuilder);

  bool get showCancelSlot =>
      placement == TPopupPlacement.bottom &&
      useDefaultHeader &&
      cancelBuilder != null;

  bool get showConfirmSlot =>
      placement == TPopupPlacement.bottom &&
      useDefaultHeader &&
      confirmBuilder != null;

  bool get hasBuiltInHeader {
    if (placement != TPopupPlacement.bottom || headerBuilder == null) {
      return false;
    }
    if (useCustomHeader) {
      return true;
    }
    return cancelBuilder != null ||
        confirmBuilder != null ||
        titleWidget != null;
  }

  void assertPlacementParams() {
    assert(() {
      final err = _validatePlacementParams();
      if (err != null) {
        _throwPopupOptionsValidationError(err);
      }
      return true;
    }());
  }

  String? _validatePlacementParams() {
    switch (placement) {
      case TPopupPlacement.top:
        if (width != null) {
          return 'width is not valid for placement=top; use height + inset.';
        }
        if (inset != null && inset is! TPopupTopInset) {
          return 'inset must be TPopupTopInset for placement=top.';
        }
        break;
      case TPopupPlacement.bottom:
        if (width != null) {
          return 'width is not valid for placement=bottom; use height + inset.';
        }
        if (inset != null && inset is! TPopupBottomInset) {
          return 'inset must be TPopupBottomInset for placement=bottom.';
        }
        break;
      case TPopupPlacement.left:
        if (height != null) {
          return 'height is not valid for placement=left; use width + inset.';
        }
        if (inset != null && inset is! TPopupLeftInset) {
          return 'inset must be TPopupLeftInset for placement=left.';
        }
        break;
      case TPopupPlacement.right:
        if (height != null) {
          return 'height is not valid for placement=right; use width + inset.';
        }
        if (inset != null && inset is! TPopupRightInset) {
          return 'inset must be TPopupRightInset for placement=right.';
        }
        break;
      case TPopupPlacement.center:
        if (inset != null) {
          return 'inset is not valid for placement=center.';
        }
        break;
    }
    final hasBottomHeaderCustom = !_isPopupDefaultHeader(headerBuilder) ||
        titleWidget != null ||
        !_isPopupDefaultCancel(cancelBuilder) ||
        !_isPopupDefaultConfirm(confirmBuilder);
    if (placement != TPopupPlacement.bottom && hasBottomHeaderCustom) {
      return 'header/titleWidget/cancel/confirmBuilder only apply to '
          'placement=bottom (got placement=$placement).';
    }
    if (placement != TPopupPlacement.center &&
        !_isPopupDefaultClose(closeBuilder)) {
      return 'closeBuilder only applies to placement=center '
          '(got placement=$placement).';
    }
    if (showOverlay && !modal) {
      return 'showOverlay=true requires modal=true.';
    }
    if (!showOverlay && _closeOnOverlayClick == true) {
      return 'closeOnOverlayClick=true requires showOverlay=true.';
    }
    return null;
  }
}
