import 'package:flutter/material.dart';

import 'td_popup_route.dart';

enum TDPopupScaleStatus { enter, exit, idle }

class TDPopupScale extends StatefulWidget {
  const TDPopupScale({
    required this.child,
    required this.enterDuration,
    required this.exitDuration,
    required this.slideTransitionFrom,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Duration enterDuration;
  final Duration exitDuration;
  final SlideTransitionFrom slideTransitionFrom;
  final ValueNotifier<TDPopupScaleStatus> controller;

  @override
  _TDPopupScaleState createState() => _TDPopupScaleState();
}

class _TDPopupScaleState extends State<TDPopupScale> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(TDPopupScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: _getTransform(),
          alignment: _getAlignment(),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  void _enter() {
    if (_animationController.status == AnimationStatus.dismissed) {
      _animationController.duration = widget.enterDuration;
      _animationController.forward();
    }
  }

  void _exit() {
    if (_animationController.status != AnimationStatus.dismissed) {
      _animationController.duration = widget.exitDuration;
      _animationController.reverse();
    }
  }

  void _onControllerChanged() {
    switch (widget.controller.value) {
      case TDPopupScaleStatus.enter:
        _enter();
        break;
      case TDPopupScaleStatus.exit:
        _exit();
        break;
      default:
        break;
    }
  }

  Matrix4 _getTransform() {
    switch (widget.slideTransitionFrom) {
      case SlideTransitionFrom.top:
        return Matrix4.diagonal3Values(1, _animation.value, 1);
      case SlideTransitionFrom.right:
        return Matrix4.diagonal3Values(_animation.value, 1, 1);
      case SlideTransitionFrom.left:
        return Matrix4.diagonal3Values(_animation.value, 1, 1);
      case SlideTransitionFrom.bottom:
        return Matrix4.diagonal3Values(1, _animation.value, 1);
      case SlideTransitionFrom.center:
        return Matrix4.diagonal3Values(_animation.value, _animation.value, 1);
    }
  }

  AlignmentGeometry _getAlignment() {
    switch (widget.slideTransitionFrom) {
      case SlideTransitionFrom.top:
        return Alignment.topCenter;
      case SlideTransitionFrom.right:
        return Alignment.centerRight;
      case SlideTransitionFrom.left:
        return Alignment.centerLeft;
      case SlideTransitionFrom.bottom:
        return Alignment.bottomCenter;
      case SlideTransitionFrom.center:
        return Alignment.center;
    }
  }
}
