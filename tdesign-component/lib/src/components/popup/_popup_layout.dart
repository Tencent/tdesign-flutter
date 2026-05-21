import 'package:flutter/material.dart';

import 't_popup_types.dart';

/// 根据 placement 计算 Positioned 约束。
class PopupLayout {
  PopupLayout({
    required this.placement,
    required this.screenSize,
    required this.margin,
    this.width,
    this.height,
    this.centerLooseHeight = false,
  });

  final TPopupPlacement placement;
  final Size screenSize;
  final EdgeInsets margin;
  final double? width;
  final double? height;

  /// 居中且关闭按钮在内容下方时，不限制总高度（含下方关闭区）。
  final bool centerLooseHeight;

  static const double defaultDrawerWidth = 280;

  EdgeInsets resolvedMargin() {
    if (placement == TPopupPlacement.center) {
      return EdgeInsets.zero;
    }
    return margin;
  }

  Widget wrapPositioned({required Widget child}) {
    final m = resolvedMargin();
    switch (placement) {
      case TPopupPlacement.top:
        return Positioned(
          top: m.top,
          left: m.left,
          right: m.right,
          height: height,
          child: child,
        );
      case TPopupPlacement.bottom:
        final bottomHeight = _bottomHeight(m);
        if (bottomHeight != null && m.top > 0) {
          return Positioned(
            top: m.top,
            left: m.left,
            right: m.right,
            height: bottomHeight,
            child: child,
          );
        }
        if (bottomHeight != null) {
          return Positioned(
            left: m.left,
            right: m.right,
            bottom: m.bottom,
            height: bottomHeight,
            child: child,
          );
        }
        return Positioned(
          top: m.top > 0 ? m.top : null,
          left: m.left,
          right: m.right,
          bottom: m.bottom,
          child: child,
        );
      case TPopupPlacement.left:
        return Positioned(
          top: m.top,
          bottom: m.bottom,
          left: m.left,
          width: width ?? defaultDrawerWidth,
          child: child,
        );
      case TPopupPlacement.right:
        return Positioned(
          top: m.top,
          bottom: m.bottom,
          right: m.right,
          width: width ?? defaultDrawerWidth,
          child: child,
        );
      case TPopupPlacement.center:
        return Positioned.fill(
          child: Center(
            child: SizedBox(
              width: centerLooseHeight ? null : width,
              height: centerLooseHeight ? null : height,
              child: child,
            ),
          ),
        );
    }
  }

  double? _bottomHeight(EdgeInsets m) {
    if (height != null) {
      return height;
    }
    if (m.top > 0) {
      return screenSize.height - m.top - m.bottom;
    }
    return null;
  }

  Alignment get alignment {
    switch (placement) {
      case TPopupPlacement.top:
        return Alignment.topCenter;
      case TPopupPlacement.bottom:
        return Alignment.bottomCenter;
      case TPopupPlacement.left:
        return Alignment.centerLeft;
      case TPopupPlacement.right:
        return Alignment.centerRight;
      case TPopupPlacement.center:
        return Alignment.center;
    }
  }

  Offset slideOffset(double t) {
    switch (placement) {
      case TPopupPlacement.top:
        return Offset(0, t - 1);
      case TPopupPlacement.bottom:
        return Offset(0, 1 - t);
      case TPopupPlacement.left:
        return Offset(t - 1, 0);
      case TPopupPlacement.right:
        return Offset(1 - t, 0);
      case TPopupPlacement.center:
        return Offset.zero;
    }
  }
}
