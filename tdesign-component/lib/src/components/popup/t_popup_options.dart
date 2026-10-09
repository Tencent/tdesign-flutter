part of 't_popup.dart';

/// 用于 [TPopupOptions.copyWith] 区分"不传"与"显式 null"。
const Object _unset = Object();

Never _throwPopupOptionsValidationError(String error) {
  throw FlutterError('TPopupOptions: $error');
}

/// [TPopup.show] 的配置对象。
///
/// | 构造方法 | 方向 | 方向专用参数 |
/// | --- | --- | --- |
/// | [TPopupOptions] | 由 [placement] 指定 | 按对应方向使用下列参数 |
/// | [TPopupOptions.bottom] | 底部 | [height]、[inset]（[TPopupBottomInset]）、[headerBuilder] |
/// | [TPopupOptions.center] | 居中 | [width]、[height]、[closeBuilder] |
/// | [TPopupOptions.top] | 顶部 | [height]、[inset]（[TPopupTopInset]） |
/// | [TPopupOptions.left] | 左侧 | [width]、[inset]（[TPopupLeftInset]） |
/// | [TPopupOptions.right] | 右侧 | [width]、[inset]（[TPopupRightInset]） |
///
/// | 条件 | 行为 |
/// | --- | --- |
/// | 显式设置尺寸、圆角、面板颜色或蒙层颜色 | 优先于 [TPopupThemeData] |
/// | 参数与方向不匹配 | [TPopup.show] / [TPopupHandle.open] 抛出 [FlutterError] |
class TPopupOptions {
  /// 通过 [placement] 指定方向。
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
    this.onOpened,
    this.onClosed,
    this.onVisibleChange,
    this.useSafeArea = false,
  });

  /// 底部弹出配置。
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
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = false,
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
    onOpened: onOpened,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
    useSafeArea: useSafeArea,
  );

  /// 居中弹出配置。
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
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = false,
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
    onOpened: onOpened,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
    useSafeArea: useSafeArea,
  );

  /// 顶部弹出配置。
  factory TPopupOptions.top({
    required Widget child,
    double? height,
    TPopupTopInset? inset,
    double? radius,
    Color? backgroundColor,
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = false,
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
    onOpened: onOpened,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
    useSafeArea: useSafeArea,
  );

  /// 左侧弹出配置。
  factory TPopupOptions.left({
    required Widget child,
    double? width,
    TPopupLeftInset? inset,
    double? radius,
    Color? backgroundColor,
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = false,
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
    onOpened: onOpened,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
    useSafeArea: useSafeArea,
  );

  /// 右侧弹出配置。
  factory TPopupOptions.right({
    required Widget child,
    double? width,
    TPopupRightInset? inset,
    double? radius,
    Color? backgroundColor,
    TPopupOverlayConfig? overlay,
    bool destroyOnClose = false,
    Duration? animationDuration,
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    TPopupVisibleChangeCallback? onVisibleChange,
    bool useSafeArea = false,
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
    onOpened: onOpened,
    onClosed: onClosed,
    onVisibleChange: onVisibleChange,
    useSafeArea: useSafeArea,
  );

  /// 面板内容，占用面板内可用空间；底部有头部时占用剩余高度。长内容需自行使用滚动组件。
  final Widget child;

  /// 弹出方向。
  final TPopupPlacement placement;

  /// 面板宽度，受可用宽度约束；未传时取方向对应的 Popup 主题值，再回退到左侧/右侧 280、居中 240。其他方向不支持。
  final double? width;

  /// 面板高度，受可用高度约束；底部包含头部，居中不包含面板外关闭区。未传时取方向对应的 Popup 主题值，再回退到 240；仅顶部/底部/居中支持。
  final double? height;

  /// 交叉轴留白；须使用当前方向的 Inset 类型，居中不支持。
  final TPopupInset? inset;

  /// 顶部/底部/居中默认取主题大圆角，左侧/右侧默认无圆角；显式值或 [TPopupThemeData.panelRadius] 可覆盖。
  final double? radius;

  /// 内容区背景色，默认主题容器色。
  final Color? backgroundColor;

  /// 蒙层配置；未指定时显示蒙层、拦截背景交互并支持点击关闭。
  final TPopupOverlayConfig? overlay;

  /// 解析后的蒙层配置；未传时使用默认值。
  TPopupOverlayConfig get overlayConfig =>
      overlay ?? const TPopupOverlayConfig();

  /// 为 true 时，被其他不透明路由覆盖可释放内容状态；关闭后始终释放，再次打开创建新状态。
  final bool destroyOnClose;

  /// 打开/关闭动画时长；未指定时使用 240ms。
  final Duration? animationDuration;

  /// 底部头部，占用 [height] 内的空间；未指定时不显示，可用 [TPopupHeader] 组合标题与操作按钮。
  final TPopupHeaderBuilder? headerBuilder;

  /// 居中面板外下方关闭区，不计入 [height]，与间距一起占用额外高度；未指定时不显示，按钮由 builder 提供。
  final TPopupSlotBuilder? closeBuilder;

  /// 打开动画结束后触发。
  final VoidCallback? onOpened;

  /// 关闭动画结束后触发；非栈顶浮层直接移除时在路由释放时触发。关闭完成前重新 [TPopupHandle.open]，旧周期不触发。
  final VoidCallback? onClosed;

  /// 打开时同步触发 true，开始关闭时触发 false，均不等待动画结束；第二个参数为 [TPopupTrigger]。
  final TPopupVisibleChangeCallback? onVisibleChange;

  /// 避让安全区：顶部仅上边，底部仅下边，左侧避让左/上/下边，右侧避让右/上/下边，居中避让全部边；与 [inset] 叠加。仅内容需避让时可在 [child] 中使用 [SafeArea]。
  final bool useSafeArea;

  /// 复制配置。
  ///
  /// ## 返回值
  ///
  /// 应用指定参数后的配置副本。
  TPopupOptions copyWith({
    /// 非空值替换原配置；不传或 null 保留原值。
    Widget? child,

    /// 非空值替换原配置；不传或 null 保留原值。
    TPopupPlacement? placement,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 num。
    Object? width = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 num。
    Object? height = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupInset。
    Object? inset = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 num。
    Object? radius = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 Color。
    Object? backgroundColor = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupOverlayConfig。
    Object? overlay = _unset,

    /// 非空值替换原配置；不传或 null 保留原值。
    bool? destroyOnClose,

    /// 非空值替换原配置；不传或 null 保留原值。
    Duration? animationDuration,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupHeaderBuilder。
    Object? headerBuilder = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupSlotBuilder。
    Object? closeBuilder = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 VoidCallback。
    Object? onOpened = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 VoidCallback。
    Object? onClosed = _unset,

    /// 不传时保留原值；显式 null 清除本字段，非空值须为 TPopupVisibleChangeCallback。
    Object? onVisibleChange = _unset,

    /// 非空值替换原配置；不传或 null 保留原值。
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
      onOpened: identical(onOpened, _unset)
          ? this.onOpened
          : onOpened as VoidCallback?,
      onClosed: identical(onClosed, _unset)
          ? this.onClosed
          : onClosed as VoidCallback?,
      onVisibleChange: identical(onVisibleChange, _unset)
          ? this.onVisibleChange
          : onVisibleChange as TPopupVisibleChangeCallback?,
      useSafeArea: useSafeArea ?? this.useSafeArea,
    );
  }

  /// 按方向整理配置。
  ///
  /// | 字段 | 保留条件 | 不满足时 |
  /// | --- | --- | --- |
  /// | [headerBuilder] | 底部 | 清除 |
  /// | [closeBuilder] | 居中 | 清除 |
  /// | 其他参数 | 所有方向 | 保持原值 |
  ///
  /// ## 返回值
  ///
  /// 保留当前方向适用插槽的配置副本。
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
      onOpened: onOpened,
      onClosed: onClosed,
      onVisibleChange: onVisibleChange,
      useSafeArea: useSafeArea,
    );
  }

  /// 检查参数与方向是否匹配。
  ///
  /// | 模式 | 行为 |
  /// | --- | --- |
  /// | debug | 无效组合抛出 [FlutterError] |
  /// | release | 不执行检查 |
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
