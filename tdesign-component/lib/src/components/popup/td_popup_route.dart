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

  late BuildContext? _context;

  var _close = false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (BuildContext context) {
          _context = context;
          var screenSize = MediaQuery.of(context).size;
          return ValueListenableBuilder(
            valueListenable: _size,
            builder: (BuildContext context, value, Widget? child) {
              var color = modalBarrierColor ?? Colors.black54;
              var transparentColor = color.withAlpha(0);
              var duration = value != null ? _bottomSheetEnterDuration : _bottomSheetExitDuration;
              var position = _getPosition(context, value);
              return Stack(
                children: [
                  Positioned(
                    top: modalTop ?? 0,
                    bottom: screenSize.height - (modalTop ?? 0) - (modalHeight ?? screenSize.height),
                    left: modalLeft ?? 0,
                    right: screenSize.width - (modalLeft ?? 0) - (modalWidth ?? screenSize.width),
                    child: AnimatedContainer(
                      color: value == null ? transparentColor : color,
                      duration: duration,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (isDismissible) {
                            close();
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
                    child: SingleChildScrollView(
                      child: Builder(
                        builder: (BuildContext context) {
                          _open(context);
                          return builder(context);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    ];
  }

  Map<String, double> _getPosition(BuildContext context, Size? size) {
    var screenSize = MediaQuery.of(context).size;
    var position = <String, double>{};
    var _modalTop = (modalTop ?? 0).clamp(0, screenSize.height).toDouble();
    var _modalLeft = (modalLeft ?? 0).clamp(0, screenSize.width).toDouble();
    var _modalHeight = (modalHeight ?? screenSize.height).clamp(0, screenSize.height - _modalTop).toDouble();
    var _modalWidth = (modalWidth ?? screenSize.width).clamp(0, screenSize.width - _modalLeft).toDouble();
    switch (slideTransitionFrom) {
      case SlideTransitionFrom.top:
        position['top'] = _modalTop;
        position['bottom'] = screenSize.height - _modalTop - min(size?.height ?? 0, _modalHeight); // 移动
        position['left'] = _modalLeft;
        position['right'] = screenSize.width - _modalLeft - _modalWidth;
        break;
      case SlideTransitionFrom.bottom:
        position['top'] = max(_modalTop + _modalHeight - (size?.height ?? 0), 0); // 移动
        position['bottom'] = screenSize.height - _modalTop - _modalHeight;
        position['left'] = _modalLeft;
        position['right'] = screenSize.width - _modalLeft - _modalWidth;
        break;
      case SlideTransitionFrom.left:
        position['top'] = _modalTop;
        position['bottom'] = screenSize.height - _modalTop - _modalHeight;
        position['left'] = _modalLeft;
        position['right'] = max(screenSize.width - _modalLeft - (size?.width ?? 0), 0); // 移动
        break;
      case SlideTransitionFrom.right:
        position['top'] = _modalTop;
        position['bottom'] = screenSize.height - _modalTop - _modalHeight;
        position['left'] = max(_modalLeft + _modalWidth - (size?.width ?? 0), 0); // 移动
        position['right'] = screenSize.width - _modalLeft;
        break;
      case SlideTransitionFrom.center:
        break;
    }
    return position;
  }

  void _open(BuildContext context) {
    if (_size.value != null || _close) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var renderBox = context.findRenderObject() as RenderBox;
      _size.value = renderBox.size;
    });
  }

  /// 关闭
  void close() {
    if (_size.value != null) {
      _size.value = null;
      _close = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Future.delayed(_bottomSheetExitDuration);
        if (_context != null) {
          Navigator.pop(_context!);
          _context = null;
        }
      });
    } else {
      if (_context != null) {
        Navigator.pop(_context!);
        _context = null;
      }
    }
  }
}
