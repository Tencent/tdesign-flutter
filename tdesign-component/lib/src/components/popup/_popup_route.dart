import 'package:flutter/material.dart';

import '_popup_layout.dart';
import '_popup_shell.dart';
import 't_popup_config.dart';
import 't_popup_types.dart';

const Duration _kReverseDuration = Duration(milliseconds: 200);

/// 私有 Popup 路由。
class TPopupNavigatorRoute<T> extends PopupRoute<T> {
  TPopupNavigatorRoute({
    required this.config,
    required this.onCloseWithTrigger,
  }) : _layout = PopupLayout(
          placement: config.placement,
          screenSize: Size.zero,
          margin: config.margin,
          width: config.width,
          height: config.height,
        );

  final TPopupConfig config;
  final void Function(TPopupTrigger trigger, [Object? result])
      onCloseWithTrigger;

  late PopupLayout _layout;
  bool _animationListenerAttached = false;
  bool _openedFired = false;
  bool _closedFired = false;
  bool _closeStartFired = false;
  String? _barrierSemanticsLabel;

  Color get _barrierColor {
    if (!config.showOverlay) {
      return Colors.transparent;
    }
    final base = config.overlayColor ?? Colors.black54;
    if (config.overlayOpacity != null) {
      final opacity = config.overlayOpacity!.clamp(0.0, 1.0);
      return base.withValues(alpha: base.a * opacity);
    }
    return base;
  }

  @override
  Duration get transitionDuration => config.duration;

  @override
  Duration get reverseTransitionDuration => _kReverseDuration;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel =>
      config.showOverlay ? _barrierSemanticsLabel : null;

  @override
  Color get barrierColor => Colors.transparent;

  /// 路由须非 opaque，否则透明区域会露出 Modal 默认黑底。
  ///
  /// 无蒙层时滚动穿透由 [_scrollBlocker] 处理，不能靠 opaque=true（会整屏发黑）。
  @override
  bool get opaque => false;

  @override
  bool get maintainState => !config.destroyOnClose;

  /// 关闭动画开始前回调（系统返回 / handle.close / 蒙层等统一入口）。
  void fireCloseStart(TPopupTrigger trigger) {
    if (_closeStartFired) {
      return;
    }
    _closeStartFired = true;
    config.onVisibleChange?.call(false, trigger);
    config.onClose?.call();
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
    if (config.showOverlay) {
      _barrierSemanticsLabel ??=
          MaterialLocalizations.of(context).modalBarrierDismissLabel;
    }
    _layout = PopupLayout(
      placement: config.placement,
      screenSize: mediaQuery.size,
      margin: config.margin,
      width: config.width,
      height: config.height,
      centerLooseHeight:
          config.placement == TPopupPlacement.center && config.closeBtn,
    );

    final t = curved.value;
    final shell = PopupShell(
      config: config,
      onCloseWithTrigger: onCloseWithTrigger,
    );

    Widget popupContent;
    if (config.placement == TPopupPlacement.center) {
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
        if (config.showOverlay) barrier,
        if (!config.showOverlay && config.preventScrollThrough)
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
    if (config.showOverlay) {
      final label = _barrierSemanticsLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel;
      barrier = Semantics(
        label: label,
        button: true,
        child: barrier,
      );
    }
    if (config.preventScrollThrough) {
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
    config.onOverlayClick?.call();
    if (config.closeOnOverlayClick) {
      onCloseWithTrigger(TPopupTrigger.overlay);
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_openedFired) {
      _openedFired = true;
      config.onOpened?.call();
    }
    if (status == AnimationStatus.dismissed && !_closedFired) {
      _closedFired = true;
      config.onClosed?.call();
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
    config.onOpen?.call();
    config.onVisibleChange?.call(true, TPopupTrigger.programmatic);
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
