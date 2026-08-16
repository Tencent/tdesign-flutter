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
  String? _barrierSemanticsLabel;

  _PopupBarrierMode get _barrierMode {
    final overlay = options.overlayConfig;
    if (!overlay.preventTap) {
      return _PopupBarrierMode.nonModal;
    }
    return overlay.showOverlay
        ? _PopupBarrierMode.modalOverlay
        : _PopupBarrierMode.modalTransparent;
  }

  Color get _barrierColor {
    final overlay = options.overlayConfig;
    if (!overlay.showOverlay) {
      return Colors.transparent;
    }
    final base = overlay.color ?? Colors.black54;
    if (overlay.opacity != null) {
      final opacity = overlay.opacity!.clamp(0.0, 1.0);
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
  String? get barrierLabel =>
      options.overlayConfig.showOverlay ? _barrierSemanticsLabel : null;

  @override
  Color? get barrierColor => null;

  /// 非 opaque，避免透明区域露出 Modal 默认底色。
  @override
  bool get opaque => false;

  @override
  bool get maintainState => !options.destroyOnClose;

  @override
  Widget buildModalBarrier() {
    final overlay = options.overlayConfig;
    if (_barrierMode == _PopupBarrierMode.nonModal) {
      return const SizedBox.shrink();
    }
    if (_barrierMode == _PopupBarrierMode.modalOverlay &&
        overlay.effectiveCloseOnClick) {
      return ModalBarrier(
        color: Colors.transparent,
        dismissible: true,
        onDismiss: _handleOverlayTap,
        semanticsLabel: _resolveBarrierSemanticsLabel(navigator!.context),
        barrierSemanticsDismissible: true,
      );
    }
    return const ModalBarrier(
      color: Colors.transparent,
      dismissible: false,
      barrierSemanticsDismissible: false,
    );
  }

  /// 关闭开始前统一入口：触发 [TPopupOptions.onClose]、[onVisibleChange](false, …)。
  void fireCloseStart(TPopupTrigger trigger) {
    if (_closeStartFired) {
      return;
    }
    _closeStartFired = true;
    options.onVisibleChange?.call(false, trigger);
    options.onClose?.call();
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
          if (options.overlayConfig.showOverlay) barrier,
          positioned,
        ],
      ),
    );
    return capturedThemes?.wrap(content) ?? content;
  }

  Widget _buildBarrier(BuildContext context, double t) {
    final overlay = options.overlayConfig;
    final barrier = Container(
      color: _barrierColor.withValues(alpha: _barrierColor.a * t),
    );
    if (!overlay.preventTap) {
      // 不拦截背景交互：蒙层仅视觉展示，点击穿透到背景。
      return IgnorePointer(child: barrier);
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleOverlayTap,
      child: barrier,
    );
  }

  String _resolveBarrierSemanticsLabel(BuildContext context) {
    return _barrierSemanticsLabel ??= MaterialLocalizations.of(
      context,
    ).modalBarrierDismissLabel;
  }

  void _handleOverlayTap() {
    final overlay = options.overlayConfig;
    overlay.onClick?.call();
    if (overlay.effectiveCloseOnClick) {
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
