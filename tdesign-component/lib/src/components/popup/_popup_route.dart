part of 't_popup.dart';

/// 库内 [PopupRoute]；由 [TPopupHandle.open] push，勿在外部直接构造。
class _PopupNavigatorRoute<T> extends PopupRoute<T> {
  _PopupNavigatorRoute({
    required this.options,
    required this.onCloseWithTrigger,
    required this.capturedThemes,
  }) : _layout = PopupLayout(
         placement: options.placement,
         inset: options.inset,
         width: options.width,
         height: options.height,
       ),
       super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final TPopupOptions options;
  final void Function(TPopupTrigger trigger) onCloseWithTrigger;
  final CapturedThemes? capturedThemes;

  late PopupLayout _layout;
  bool _animationListenerAttached = false;
  bool _openedFired = false;
  bool _closedFired = false;
  bool _closeStartFired = false;

  _PopupBarrierMode get _barrierMode {
    if (!options.modal) {
      return _PopupBarrierMode.nonModal;
    }
    return options.showOverlay
        ? _PopupBarrierMode.modalOverlay
        : _PopupBarrierMode.modalTransparent;
  }

  Color get _barrierColor {
    if (!options.showOverlay) {
      return Colors.transparent;
    }
    final base = options.overlayColor ?? Colors.black54;
    if (options.overlayOpacity != null) {
      final opacity = options.overlayOpacity!.clamp(0.0, 1.0);
      return base.withValues(alpha: base.a * opacity);
    }
    return base;
  }

  @override
  Duration get transitionDuration =>
      options.animationDuration ?? const Duration(milliseconds: 240);

  @override
  Duration get reverseTransitionDuration => transitionDuration;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Color? get barrierColor => null;

  /// 非 opaque，避免透明区域露出 Modal 默认底色。
  @override
  bool get opaque => false;

  @override
  bool get maintainState => !options.destroyOnClose;

  /// 蒙层屏障：只负责阻断背景交互，不处理点击关闭。
  ///
  /// 点击关闭统一由 [buildTransitions] 中 [_buildBarrier] 的 GestureDetector 处理，
  /// 避免与 ModalBarrier 的 onDismiss 在同一手势里双重触发 [onOverlayClick] / 关闭。
  /// 这里仍保留 ModalBarrier 以在模态场景下正确阻断底层语义与焦点。
  @override
  Widget buildModalBarrier() {
    if (_barrierMode == _PopupBarrierMode.nonModal) {
      return const SizedBox.shrink();
    }
    return const ModalBarrier(
      color: Colors.transparent,
      dismissible: false,
      barrierSemanticsDismissible: false,
    );
  }

  /// 关闭开始前统一入口：触发 [TPopupOptions.onClose]、[onVisibleChange](false, …)。
  ///
  /// 回调顺序与打开保持一致（打开：onOpen → onVisibleChange(true)；
  /// 关闭：onClose → onVisibleChange(false)），避免使用者对时序产生歧义。
  void fireCloseStart(TPopupTrigger trigger) {
    if (_closeStartFired) {
      return;
    }
    _closeStartFired = true;
    options.onClose?.call();
    options.onVisibleChange?.call(false, trigger);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    _layout = PopupLayout(
      placement: options.placement,
      inset: options.inset,
      width: options.width,
      height: options.height,
    );

    final t = animation.status == AnimationStatus.reverse
        ? Curves.easeOut.transform(animation.value)
        : Curves.decelerate.transform(animation.value);
    final panel = PopupShell(
      options: options,
      onCloseWithTrigger: onCloseWithTrigger,
    );

    Widget popupContent;
    if (options.placement == TPopupPlacement.center) {
      popupContent = Transform.scale(
        scale: t,
        alignment: Alignment.center,
        child: panel,
      );
    } else {
      popupContent = FractionalTranslation(
        translation: _layout.slideOffset(t),
        child: panel,
      );
    }

    final safePadding = PopupLayout.safePaddingFor(
      options.placement,
      MediaQuery.paddingOf(context),
      options.useSafeArea,
    );
    final positioned = _layout.wrapPositioned(
      child: popupContent,
      safePadding: safePadding,
      availableSize: MediaQuery.sizeOf(context),
    );

    final barrier = _buildBarrier(context, t);

    final content = IgnorePointer(
      ignoring: animation.status == AnimationStatus.reverse,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_barrierMode == _PopupBarrierMode.modalOverlay) barrier,
          positioned,
        ],
      ),
    );
    return capturedThemes?.wrap(content) ?? content;
  }

  /// 可见蒙层的着色层 + 唯一点击处理层。
  ///
  /// 仅在 [TPopupPlacement] 有蒙层（[modal] 且 [showOverlay]）时被 [buildTransitions]
  /// 放入 [Stack]，作为整屏可见蒙层：负责绘制 [overlayColor]，并通过 [_handleOverlayTap]
  /// 统一处理"点击蒙层"语义（是否关闭由 [TPopupOptions.closeOnOverlayClick] 决定）。
  /// 它比 [buildModalBarrier] 的透明 ModalBarrier 更靠上，命中测试时优先于后者，
  /// 因此点击关闭只会在这一层触发一次。
  Widget _buildBarrier(BuildContext context, double t) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleOverlayTap,
      child: Container(
        color: _barrierColor.withValues(alpha: _barrierColor.a * t),
      ),
    );
  }

  void _handleOverlayTap() {
    options.onOverlayClick?.call();
    if (options.closeOnOverlayClick) {
      onCloseWithTrigger(TPopupTrigger.overlay);
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_openedFired) {
      _openedFired = true;
      options.onOpened?.call();
    }
    if (status == AnimationStatus.dismissed && !_closedFired) {
      _closedFired = true;
      options.onClosed?.call();
    }
  }

  void _attachAnimationListener() {
    if (_animationListenerAttached) {
      return;
    }
    final anim = animation;
    if (anim == null) {
      return;
    }
    _animationListenerAttached = true;
    anim.addStatusListener(_onAnimationStatus);
    if (anim.status == AnimationStatus.completed) {
      _onAnimationStatus(AnimationStatus.completed);
    }
  }

  @override
  TickerFuture didPush() {
    options.onOpen?.call();
    options.onVisibleChange?.call(true, TPopupTrigger.api);
    final future = super.didPush();
    future.whenComplete(_attachAnimationListener);
    return future;
  }

  @override
  bool didPop(T? result) {
    fireCloseStart(TPopupTrigger.systemBack);
    return super.didPop(result);
  }

  @override
  void dispose() {
    if (!_closedFired) {
      _closedFired = true;
      options.onClosed?.call();
    }
    if (_animationListenerAttached) {
      animation?.removeStatusListener(_onAnimationStatus);
    }
    super.dispose();
  }
}

enum _PopupBarrierMode { modalOverlay, modalTransparent, nonModal }
