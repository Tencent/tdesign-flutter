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
/// | [TPopupPlacement.bottom] | [headerBuilder] | [height]、[inset] |
/// | [TPopupPlacement.center] | [closeBuilder] | [width]、[height] |
/// | [TPopupPlacement.top] | — | [height]、[inset] |
/// | [TPopupPlacement.left]、[TPopupPlacement.right] | — | [width]、[inset] |
///
/// [headerBuilder] 与 [closeBuilder] 默认均为 `null`，基础 Popup 只渲染
/// [child]。显式提供 builder 时才会渲染相应区域，builder 可调用 `close`
/// 关闭浮层。
///
/// 生命周期回调见 [onOpen]、[onOpened]、[onClose]、[onClosed]、[onVisibleChange]；
/// 蒙层行为见 [overlay]（[TPopupOverlayConfig]）。
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
    this.overlay,
    this.destroyOnClose = false,
    this.animationDuration,
    this.headerBuilder,
    this.closeBuilder,
    this.onOpen,
    this.onOpened,
    this.onClose,
    this.onClosed,
    this.onVisibleChange,
    this.useSafeArea = true,
  });

  /// 创建 [TPopupPlacement.bottom] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.bottom]；默认不显示头部。
  /// 蒙层、动画、生命周期等字段语义见同名成员文档。
  factory TPopupOptions.bottom({
    required Widget child,
    double? height,
    TPopupBottomInset? inset,
    TPopupHeaderBuilder? headerBuilder,
    double? radius,
    Color? backgroundColor,
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = true,
  }) => TPopupOptions(
    child: child,
    placement: TPopupPlacement.bottom,
    height: height,
    inset: inset,
    headerBuilder: headerBuilder,
    radius: radius,
    backgroundColor: backgroundColor,
    overlay: overlay,
    destroyOnClose: destroyOnClose,
    animationDuration: animationDuration,
    onOpen: onOpen,
    onOpened: onOpened,
    onClose: onClose,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
    useSafeArea: useSafeArea,
  );

  /// 创建 [TPopupPlacement.center] 配置。
  ///
  /// 固定 [placement] 为 [TPopupPlacement.center]；默认不显示关闭按钮。
  factory TPopupOptions.center({
    required Widget child,
    double? width,
    double? height,
    TPopupSlotBuilder? closeBuilder,
    double? radius,
    Color? backgroundColor,
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = true,
  }) => TPopupOptions(
    child: child,
    placement: TPopupPlacement.center,
    width: width,
    height: height,
    closeBuilder: closeBuilder,
    radius: radius,
    backgroundColor: backgroundColor,
    overlay: overlay,
    destroyOnClose: destroyOnClose,
    animationDuration: animationDuration,
    onOpen: onOpen,
    onOpened: onOpened,
    onClose: onClose,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
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
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = true,
  }) => TPopupOptions(
    child: child,
    placement: TPopupPlacement.top,
    height: height,
    inset: inset,
    radius: radius,
    backgroundColor: backgroundColor,
    overlay: overlay,
    destroyOnClose: destroyOnClose,
    animationDuration: animationDuration,
    onOpen: onOpen,
    onOpened: onOpened,
    onClose: onClose,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
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
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = true,
  }) => TPopupOptions(
    child: child,
    placement: TPopupPlacement.left,
    width: width,
    inset: inset,
    radius: radius,
    backgroundColor: backgroundColor,
    overlay: overlay,
    destroyOnClose: destroyOnClose,
    animationDuration: animationDuration,
    onOpen: onOpen,
    onOpened: onOpened,
    onClose: onClose,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
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
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpen,
    VoidCallback? onOpened,
    VoidCallback? onClose,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = true,
  }) => TPopupOptions(
    child: child,
    placement: TPopupPlacement.right,
    width: width,
    inset: inset,
    radius: radius,
    backgroundColor: backgroundColor,
    overlay: overlay,
    destroyOnClose: destroyOnClose,
    animationDuration: animationDuration,
    onOpen: onOpen,
    onOpened: onOpened,
    onClose: onClose,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
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

  /// 蒙层行为配置；为 null 时使用 [TPopupOverlayConfig] 默认值（标准模态弹层）。
  final TPopupOverlayConfig? overlay;

  /// 解析后的蒙层配置；未传时使用默认值。
  TPopupOverlayConfig get overlayConfig =>
      overlay ?? const TPopupOverlayConfig();

  /// 为 true 时路由 `maintainState` 为 false，关闭后不保留路由内 State。
  final bool destroyOnClose;

  /// 打开/关闭动画时长，默认 300ms（与官方及仓库其他浮层组件对齐）。
  final Duration? animationDuration;

  /// bottom 头部；仅 [TPopupPlacement.bottom] 生效，默认不显示。
  ///
  /// 可返回 [TPopupHeader] 组合取消按钮、标题和确认按钮；builder 的 `close`
  /// 参数只负责关闭 Popup，不会自动生成任何按钮。
  final TPopupHeaderBuilder? headerBuilder;

  /// center 面板外下方关闭区；仅 [TPopupPlacement.center] 生效，默认不显示。
  /// builder 的 `close` 参数只负责关闭 Popup，不会自动生成关闭按钮。
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

  /// 是否避让系统安全区，默认 true；center 使用完整安全区，其他方向避让贴边侧及相邻边。
  ///
  /// 为 true 时通过 [Positioned] 偏移使面板不侵入刘海、Home Indicator 等区域；
  /// top/bottom/left/right 还会与对应 [inset] 叠加。设为 false 可贴满屏幕边缘。
  final bool useSafeArea;

  /// 返回配置副本。
  ///
  /// 未传入的字段保持原值；对头部/关闭 builder 显式传入 `null` 表示隐藏该区域。
  TPopupOptions copyWith({
    Widget? child,
    TPopupPlacement? placement,
    Object? width = _unset,
    Object? height = _unset,
    Object? inset = _unset,
    Object? radius = _unset,
    Object? backgroundColor = _unset,
    Object? overlay = _unset,
    bool? destroyOnClose,
    Duration? animationDuration,
    Object? headerBuilder = _unset,
    Object? closeBuilder = _unset,
    Object? onOpen = _unset,
    Object? onOpened = _unset,
    Object? onClose = _unset,
    Object? onClosed = _unset,
    Object? onVisibleChange = _unset,
    bool? useSafeArea,
  }) {
    return TPopupOptions(
      child: child ?? this.child,
      placement: placement ?? this.placement,
      width: identical(width, _unset)
          ? this.width
          : (width as num?)?.toDouble(),
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
      overlay: identical(overlay, _unset)
          ? this.overlay
          : overlay as TPopupOverlayConfig?,
      destroyOnClose: destroyOnClose ?? this.destroyOnClose,
      animationDuration: animationDuration ?? this.animationDuration,
      headerBuilder: identical(headerBuilder, _unset)
          ? this.headerBuilder
          : headerBuilder as TPopupHeaderBuilder?,
      closeBuilder: identical(closeBuilder, _unset)
          ? this.closeBuilder
          : closeBuilder as TPopupSlotBuilder?,
      onOpen: identical(onOpen, _unset) ? this.onOpen : onOpen as VoidCallback?,
      onOpened: identical(onOpened, _unset)
          ? this.onOpened
          : onOpened as VoidCallback?,
      onClose: identical(onClose, _unset)
          ? this.onClose
          : onClose as VoidCallback?,
      onClosed: identical(onClosed, _unset)
          ? this.onClosed
          : onClosed as VoidCallback?,
      onVisibleChange: identical(onVisibleChange, _unset)
          ? this.onVisibleChange
          : onVisibleChange as TPopupVisibleChangeCallback?,
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
      overlay: overlay,
      destroyOnClose: destroyOnClose,
      animationDuration: animationDuration,
      headerBuilder: isBottom ? headerBuilder : null,
      closeBuilder: isCenter ? closeBuilder : null,
      onOpen: onOpen,
      onOpened: onOpened,
      onClose: onClose,
      onClosed: onClosed,
      onVisibleChange: onVisibleChange,
      useSafeArea: useSafeArea,
    );
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
    if (placement != TPopupPlacement.bottom && headerBuilder != null) {
      return 'headerBuilder only applies to '
          'placement=bottom (got placement=$placement).';
    }
    if (placement != TPopupPlacement.center && closeBuilder != null) {
      return 'closeBuilder only applies to placement=center '
          '(got placement=$placement).';
    }
    return null;
  }
}
