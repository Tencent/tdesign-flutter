import 'package:flutter/material.dart';

import '_popup_layout.dart';
import '_popup_shell.dart';
import 't_popup_options.dart';
import 't_popup_types.dart';

/// 私有 Popup 路由。
class TPopupNavigatorRoute<T> extends PopupRoute<T> {
  TPopupNavigatorRoute({
    required this.options,
    required this.onCloseWithTrigger,
  }) : _layout = PopupLayout(
          placement: options.placement,
          screenSize: Size.zero,
          margin: options.margin,
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
  Duration get transitionDuration => options.duration;

  @override
  Duration get reverseTransitionDuration => options.duration;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel =>
      options.showOverlay ? _barrierSemanticsLabel : null;

  @override
  Color get barrierColor => Colors.transparent;

  /// 路由须非 opaque，否则透明区域会露出 Modal 默认黑底。
  ///
  /// 无蒙层时滚动穿透由 [_scrollBlocker] 处理，不能靠 opaque=true（会整屏发黑）。
  @override
  bool get opaque => false;

  @override
  bool get maintainState => !options.destroyOnClose;

  /// 关闭动画开始前回调（系统返回 / handle.close / 蒙层等统一入口）。
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

    final mediaQuery = MediaQuery.of(context);
    if (options.showOverlay) {
      _barrierSemanticsLabel ??=
          MaterialLocalizations.of(context).modalBarrierDismissLabel;
    }
    _layout = PopupLayout(
      placement: options.placement,
      screenSize: mediaQuery.size,
      margin: options.margin,
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
          _scrollBlocker(child: const SizedBox.expand()),
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
    if (options.preventScrollThrough) {
      barrier = _scrollBlocker(child: barrier);
    }
    return barrier;
  }

  Widget _scrollBlocker({required Widget child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: child,
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
    options.onVisibleChange?.call(true, TPopupTrigger.programmatic);
    final future = super.didPush();
    future.whenComplete(_attachAnimationListener);
    return future;
  }

  @override
  bool didPop(T? result) {
    fireCloseStart(TPopupTrigger.programmatic);
    return super.didPop(result);
  }

  @override
  void dispose() {
    if (_animationListenerAttached) {
      animation?.removeStatusListener(_onAnimationStatus);
    }
    super.dispose();
  }
}
