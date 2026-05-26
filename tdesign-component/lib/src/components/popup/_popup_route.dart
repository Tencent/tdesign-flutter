part of 't_popup.dart';

/// 库内 [PopupRoute]；由 [TPopupHandle.open] push，勿在外部直接构造。
class _PopupNavigatorRoute<T> extends PopupRoute<T> {
  static const ValueKey<String> transparentInteractionBarrierKey =
      ValueKey<String>('tpopup-transparent-interaction-barrier');

  _PopupNavigatorRoute({
    required this.options,
    required this.onCloseWithTrigger,
  }) : _layout = PopupLayout(
          placement: options.placement,
          inset: options.inset,
          width: options.width,
          height: options.height,
        );

  final TPopupOptions options;
  final void Function(TPopupTrigger trigger, [Object? result])
      onCloseWithTrigger;

  late PopupLayout _layout;
  bool _animationListenerAttached = false;
  bool _openedFired = false;
  bool _closedFired = false;
  bool _closeStartFired = false;
  String? _barrierSemanticsLabel;

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
  Duration get transitionDuration => options.animationDuration;

  @override
  Duration get reverseTransitionDuration => options.animationDuration;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel =>
      options.showOverlay ? _barrierSemanticsLabel : null;

  @override
  Color? get barrierColor => null;

  /// 非 opaque，避免透明区域露出 Modal 默认底色。
  @override
  bool get opaque => false;

  @override
  bool get maintainState => !options.destroyOnClose;

  @override
  Widget buildModalBarrier() {
    // Popup 自己在 buildTransitions 里管理遮罩与透明交互层，
    // 这里返回空节点，避免 PopupRoute 默认的 ModalBarrier
    // 在 showOverlay=false 时仍偷偷阻断底层交互。
    return const SizedBox.shrink();
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
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.decelerate,
      reverseCurve: Curves.easeOut,
    );

    if (options.showOverlay) {
      _barrierSemanticsLabel ??=
          MaterialLocalizations.of(context).modalBarrierDismissLabel;
    }
    _layout = PopupLayout(
      placement: options.placement,
      inset: options.inset,
      width: options.width,
      height: options.height,
    );

    final t = curved.value;
    final shell = PopupShell(
      options: options,
      onCloseWithTrigger: onCloseWithTrigger,
    );

    Widget popupContent;
    if (options.placement == TPopupPlacement.center) {
      popupContent = Transform.scale(
        scale: t,
        alignment: Alignment.center,
        child: shell,
      );
    } else {
      popupContent = FractionalTranslation(
        translation: _layout.slideOffset(t),
        child: shell,
      );
    }

    final positioned = _layout.wrapPositioned(child: popupContent);

    final barrier = _buildBarrier(context, t);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (options.showOverlay) barrier,
        if (!options.showOverlay && options.preventScrollThrough)
          _buildTransparentInteractionBarrier(),
        positioned,
      ],
    );
  }

  Widget _buildBarrier(BuildContext context, double t) {
    Widget barrier = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleOverlayTap,
      child: Container(
        color: _barrierColor.withValues(
          alpha: _barrierColor.a * t,
        ),
      ),
    );
    if (options.showOverlay) {
      barrier = Semantics(
        label: _barrierSemanticsLabel!,
        button: true,
        child: barrier,
      );
    }
    return barrier;
  }

  Widget _buildTransparentInteractionBarrier() {
    return const AbsorbPointer(
      key: transparentInteractionBarrierKey,
      child: SizedBox.expand(),
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
