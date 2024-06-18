import 'dart:math';

import 'package:flutter/material.dart';

const Duration _bottomSheetEnterDuration = Duration(milliseconds: 250);
const Duration _bottomSheetExitDuration = Duration(milliseconds: 200);

/// 从屏幕弹出的方向
enum SlideTransitionFrom { top, right, left, bottom, center }

/// 从屏幕的某个方向滑动弹出的Dialog框的路由，比如从顶部、底部、左、右滑出页面
class TDSlidePopupRoute<T> extends OverlayRoute<T> {
  TDSlidePopupRoute({
    required this.builder,
    this.modalBarrierColor = Colors.black54,
    this.isDismissible = true,
    this.slideTransitionFrom = SlideTransitionFrom.bottom,
    this.modalWidth,
    this.modalHeight,
    this.modalTop = 0,
    this.modalLeft = 0,
  });

  /// 控件构建器
  final WidgetBuilder builder;

  /// 蒙层颜色
  final Color? modalBarrierColor;

  /// 点击蒙层能否关闭
  final bool isDismissible;

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

  late final _size = ValueNotifier<Size?>(null);

  var _close = false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (BuildContext context) {
          var buildWidget = builder(context);
          var screenSize = MediaQuery.of(context).size;
          var _modalTop = (modalTop ?? 0).clamp(0, screenSize.height).toDouble();
          var _modalLeft = (modalLeft ?? 0).clamp(0, screenSize.width).toDouble();
          var _modalHeight = (modalHeight ?? screenSize.height).clamp(0, screenSize.height - _modalTop).toDouble();
          var _modalWidth = (modalWidth ?? screenSize.width).clamp(0, screenSize.width - _modalLeft).toDouble();
          return ValueListenableBuilder(
            valueListenable: _size,
            builder: (BuildContext context, value, Widget? child) {
              var color = modalBarrierColor ?? Colors.black54;
              var transparentColor = color.withAlpha(0);
              var duration = value != null ? _bottomSheetEnterDuration : _bottomSheetExitDuration;
              var position = _getPosition(screenSize, value, _modalTop, _modalLeft, _modalHeight, _modalWidth);
              return Stack(
                children: [
                  Positioned(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isDismissible) {
                          Navigator.maybePop(context);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: _modalTop,
                    bottom: screenSize.height - _modalTop - _modalHeight,
                    left: _modalLeft,
                    right: screenSize.width - _modalLeft - _modalWidth,
                    child: AnimatedContainer(
                      color: value == null ? transparentColor : color,
                      duration: duration,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (isDismissible) {
                            Navigator.maybePop(context);
                          }
                        },
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    top: position['top'],
                    bottom: position['bottom'],
                    left: position['left'],
                    right: position['right'],
                    duration: duration,
                    child: _getContent(context, buildWidget),
                  ),
                ],
              );
            },
          );
        },
      ),
    ];
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    _size.value = null;
    _close = true;
    await Future.delayed(_bottomSheetExitDuration);
    return RoutePopDisposition.pop;
  }

  Widget _getContent(BuildContext context, Widget child) {
    var childWidget = Builder(
      builder: (BuildContext context) {
        if (_size.value != null) {
          return child;
        }
        if (_close) {
          _close = false;
          return child;
        }
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var renderBox = context.findRenderObject() as RenderBox;
          _size.value = renderBox.size;
        });
        return child;
      },
    );
    var vertical = slideTransitionFrom == SlideTransitionFrom.top || slideTransitionFrom == SlideTransitionFrom.bottom;
    return slideTransitionFrom == SlideTransitionFrom.center
        ? SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: childWidget,
            ),
          )
        : SingleChildScrollView(
            scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
            child: childWidget,
          );
  }

  Map<String, double> _getPosition(
    Size screenSize,
    Size? size,
    double _modalTop,
    double _modalLeft,
    double _modalHeight,
    double _modalWidth,
  ) {
    var position = <String, double>{};
    var height = size?.height ?? 0;
    var width = size?.width ?? 0;
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        position['top'] = _modalTop;
        position['bottom'] = screenSize.height - _modalTop - min(height, _modalHeight); // 移动
        position['left'] = _modalLeft;
        position['right'] = screenSize.width - _modalLeft - _modalWidth;
        break;
      case SlideTransitionFrom.bottom:
        position['top'] = max(_modalTop + _modalHeight - height, 0); // 移动
        position['bottom'] = screenSize.height - _modalTop - _modalHeight;
        position['left'] = _modalLeft;
        position['right'] = screenSize.width - _modalLeft - _modalWidth;
        break;
      case SlideTransitionFrom.left:
        position['top'] = _modalTop;
        position['bottom'] = screenSize.height - _modalTop - _modalHeight;
        position['left'] = _modalLeft;
        position['right'] = max(screenSize.width - _modalLeft - width, 0); // 移动
        break;
      case SlideTransitionFrom.right:
        position['top'] = _modalTop;
        position['bottom'] = screenSize.height - _modalTop - _modalHeight;
        position['left'] = max(_modalLeft + _modalWidth - width, 0); // 移动
        position['right'] = screenSize.width - _modalLeft - _modalWidth;
        break;
      case SlideTransitionFrom.center:
        position['top'] = max(_modalTop + _modalHeight - height, 0) / 2; // 移动
        position['bottom'] = (screenSize.height - _modalTop - min(height, _modalHeight)) / 2; // 移动
        position['left'] = max(_modalLeft + _modalWidth - width, 0) / 2; // 移动
        position['right'] = max(screenSize.width - _modalLeft - width, 0) / 2; // 移动
        break;
    }
    return position;
  }
}
