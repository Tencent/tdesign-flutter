import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);

/// 从屏幕弹出的方向
enum SlideTransitionFrom { top, right, left, bottom, center }

/// 从屏幕的某个方向滑动弹出的Dialog框的路由，比如从顶部、底部、左、右滑出页面
class TDSlidePopupRoute<T> extends PopupRoute<T> {
  TDSlidePopupRoute({
    required this.builder,
    this.barrierLabel,
    this.modalBarrierColor = Colors.black54,
    this.isDismissible = true,
    this.modalBarrierFull = false,
    this.slideTransitionFrom = SlideTransitionFrom.bottom,
    this.modalWidth,
    this.modalHeight,
    this.modalTop = 0,
    this.modalLeft = 0,
    this.open,
    this.opened,
    this.close,
    this.barrierClick,
    this.focusMove = false,
  });

  /// 控件构建器
  final WidgetBuilder builder;

  /// 蒙层颜色
  final Color? modalBarrierColor;

  /// 点击蒙层能否关闭
  final bool isDismissible;

  /// 是否全屏显示蒙层
  final bool modalBarrierFull;

  /// 设置从屏幕的哪个方向滑出
  final SlideTransitionFrom slideTransitionFrom;

  /// 弹出框宽度
  final double? modalWidth;

  /// 弹出框高度
  final double? modalHeight;

  /// 弹出框顶部距离
  final double? modalTop;

  /// 弹出框左侧距离
  final double? modalLeft;

  /// 打开前事件
  final VoidCallback? open;

  /// 打开后事件
  final VoidCallback? opened;

  /// 关闭前事件
  final VoidCallback? close;

  /// 蒙层点击事件，仅在[modalBarrierFull]为false时触发
  final VoidCallback? barrierClick;

  /// 是否有输入框获取焦点时整体平移避免输入框被遮挡
  final bool focusMove;

  Color get _barrierColor => modalBarrierColor ?? Colors.black54;

  @override
  Duration get transitionDuration => _bottomSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _bottomSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierFull ? _barrierColor : Colors.transparent;

  /// 键盘焦点对象的Y坐标
  var _focusY = 0.0;

  /// 键盘焦点对象的高度
  var _focusHeight = 0.0;

  /// 键盘出现后bottom的偏移量
  var _lastBottom = 0.0;

  // 实现转场动画
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var animValue = decelerateEasing.transform(animation.value);
    return Stack(
      children: [
        if (!modalBarrierFull)
          _getPositionWidget(
            context,
            IgnorePointer(
              ignoring: true,
              child: Container(
                color: _barrierColor.withAlpha((animValue * _barrierColor.alpha).toInt()),
                child: GestureDetector(
                  onTap: () {
                    barrierClick?.call();
                    if (isDismissible) {
                      Navigator.pop(context);
                    }
                  },
                  onDoubleTap: () {
                    barrierClick?.call();
                    if (isDismissible) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          ),
        _getPositionWidget(
          context,
          Align(
            alignment: slideTransitionFromToAlignment(slideTransitionFrom),
            child: slideTransitionFrom != SlideTransitionFrom.center
                ? FractionalTranslation(
                    translation: _getOffset(animValue, slideTransitionFrom),
                    child: ClipRect(
                      clipper: RectClipper(animValue, slideTransitionFrom),
                      child: child,
                    ),
                  )
                : Transform(
                    transform: Matrix4.diagonal3Values(animValue, animValue, 1),
                    alignment: Alignment.center,
                    child: child,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      child: builder.call(context),
      color: Colors.transparent,
    );
  }

  @override
  TickerFuture didPush() {
    startFocusListener(navigator!.context);
    open?.call();
    animation?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        opened?.call();
      }
    });
    return super.didPush();
  }

  @override
  void dispose() {
    // close?.call();
    stopFocusListener(navigator!.context);
    super.dispose();
  }

  /// 监听焦点变化
  void startFocusListener(BuildContext context) {
    FocusManager.instance.addListener(_handleFocusChange);
  }

  /// 停止监听焦点变化
  void stopFocusListener(BuildContext context) {
    FocusManager.instance.removeListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    // 获取当前的焦点节点
    var focusNode = FocusManager.instance.primaryFocus;
    if (focusNode != null && focusNode.context != null) {
      var renderObject = focusNode.context!.findRenderObject();
      if (renderObject is RenderPointerListener) {
        _focusY = renderObject.localToGlobal(Offset.zero).dy;
        _focusHeight = renderObject.size.height;
      }
    }
    (focusNode?.context as Element?)?.markNeedsBuild();
  }

  @override
  bool didPop(T? result) {
    close?.call();
    return super.didPop(result);
  }

  Widget _getPositionWidget(BuildContext context, Widget child) {
    var bottom = 0.0;
    var mediaQuery = MediaQuery.of(context);
    if (slideTransitionFrom == SlideTransitionFrom.bottom) {
      bottom = mediaQuery.viewInsets.bottom;
    } else {
      if ((_focusY + mediaQuery.viewInsets.bottom + _focusHeight) > mediaQuery.size.height) {
        bottom = -(mediaQuery.size.height - (_focusY + mediaQuery.viewInsets.bottom + _focusHeight + 10));
        _lastBottom = bottom;
      } else {
        if (_lastBottom > 0.0) {
          bottom = max((_lastBottom -= 5), 0).toDouble();
        }
      }
    }

    var screenSize = mediaQuery.size;
    var _modalTop = (modalTop ?? 0).clamp(0, screenSize.height).toDouble() - (focusMove ? bottom : 0);
    var _modalLeft = (modalLeft ?? 0).clamp(0, screenSize.width).toDouble();
    var _modalHeight = (modalHeight ?? screenSize.height).clamp(0, screenSize.height - _modalTop).toDouble();
    var _modalWidth = (modalWidth ?? screenSize.width).clamp(0, screenSize.width - _modalLeft).toDouble();
    return Positioned(
      top: _modalTop,
      bottom: screenSize.height - _modalTop - _modalHeight,
      left: _modalLeft,
      right: screenSize.width - _modalLeft - _modalWidth,
      child: child,
    );
  }

  Offset _getOffset(double animValue, SlideTransitionFrom slideTransitionFrom) {
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        return Offset(0, animValue - 1);
      case SlideTransitionFrom.right:
        return Offset(1 - animValue, 0);
      case SlideTransitionFrom.left:
        return Offset(animValue - 1, 0);
      case SlideTransitionFrom.bottom:
        return Offset(0, 1 - animValue);
      default:
        return const Offset(0, 0);
    }
  }
}

Alignment slideTransitionFromToAlignment(SlideTransitionFrom from) {
  switch (from) {
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

class RectClipper extends CustomClipper<Rect> {
  final double animValue;
  final SlideTransitionFrom slideTransitionFrom;

  RectClipper(this.animValue, this.slideTransitionFrom);

  @override
  Rect getClip(Size size) {
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        return Rect.fromLTWH(0, size.height * (1 - animValue), size.width, size.height);
      case SlideTransitionFrom.right:
        return Rect.fromLTWH(0, 0, size.width * animValue, size.height);
      case SlideTransitionFrom.left:
        return Rect.fromLTWH(size.width * (1 - animValue), 0, size.width, size.height);
      case SlideTransitionFrom.bottom:
        return Rect.fromLTWH(0, 0, size.width, size.height * animValue);
      default:
        return Rect.fromLTWH(0, 0, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return oldClipper != this;
  }
}
