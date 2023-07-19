import 'package:flutter/material.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);

/// 从屏幕弹出的方向
enum SlideTransitionFrom { top, right, left, bottom, center }

/// 从屏幕的某个方向滑动弹出的Dialog框的路由，比如从顶部、底部、左、右滑出页面
class TDSlidePopupRoute<T> extends PopupRoute<T> {
  TDSlidePopupRoute(
      {required this.builder,
      this.barrierLabel,
      this.modalBarrierColor,
      this.isDismissible = true,
      this.transitionAnimationController,
      this.slideTransitionFrom = SlideTransitionFrom.bottom});

  /// 控件构建器
  final WidgetBuilder builder;

  /// 蒙层颜色
  final Color? modalBarrierColor;

  /// 点击蒙层能否关闭
  final bool isDismissible;

  /// 动画控制器
  final AnimationController? transitionAnimationController;

  /// 设置从屏幕的哪个方向滑出
  final SlideTransitionFrom slideTransitionFrom;

  @override
  Duration get transitionDuration => _bottomSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _bottomSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  // 实现转场动画
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var animValue = decelerateEasing.transform(animation.value);

    return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          return CustomSingleChildLayout(
            delegate:
                SlideTransitionLayout(animValue, slideTransitionFrom),
            child: child,
          );
        });
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder.call(context) ;
  }
}

/// 从各个方向弹出的Transition
/// progress为0到1区间的变化值
class SlideTransitionLayout extends SingleChildLayoutDelegate {
  final double progress;
  final SlideTransitionFrom slideTransitionFrom;

  SlideTransitionLayout(this.progress, this.slideTransitionFrom);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    var width = constraints.maxWidth;
    var height = constraints.maxHeight;
    // if (slideTransitionFrom == SlideTransitionFrom.center) {
    //   width = constraints.maxWidth * progress;
    //   height = constraints.maxHeight * progress;
    // }
    return BoxConstraints(maxWidth: width, maxHeight: height);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var posY = 0.0;
    var posX = 0.0;
    // 弹出的方向
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        posY = -(childSize.height - childSize.height * progress);
        break;
      case SlideTransitionFrom.left:
        posX = -(childSize.width - childSize.width * progress);
        break;
      case SlideTransitionFrom.right:
        posX = size.width - childSize.width * progress;
        break;
      case SlideTransitionFrom.bottom:
        posY = size.height - childSize.height * progress;
        break;
      case SlideTransitionFrom.center:
        posX = (size.width - childSize.width) / 2;
        posY = (size.height - childSize.height) / 2;
        break;
    }
    return Offset(posX, posY);
  }

  @override
  bool shouldRelayout(SlideTransitionLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        slideTransitionFrom != oldDelegate.slideTransitionFrom;
  }
}
