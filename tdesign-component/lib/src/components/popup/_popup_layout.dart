part of 't_popup.dart';

/// 按 [TPopupPlacement] 计算 [Positioned]；center 仅居中，尺寸由 [PopupShell] 约束。
class PopupLayout {
  PopupLayout({
    required this.placement,
    this.inset,
    this.width,
    this.height,
  });

  final TPopupPlacement placement;
  final TPopupInset? inset;
  final double? width;
  final double? height;

  static const double defaultDrawerWidth = 280;

  Widget wrapPositioned({required Widget child}) {
    switch (placement) {
      case TPopupPlacement.top:
        final inset =
            this.inset is TPopupTopInset ? this.inset as TPopupTopInset : null;
        return Positioned(
          top: 0,
          left: inset?.left ?? 0,
          right: inset?.right ?? 0,
          height: height,
          child: child,
        );
      case TPopupPlacement.bottom:
        final inset = this.inset is TPopupBottomInset
            ? this.inset as TPopupBottomInset
            : null;
        final bottomHeight = _bottomHeight();
        if (bottomHeight != null) {
          return Positioned(
            left: inset?.left ?? 0,
            right: inset?.right ?? 0,
            bottom: 0,
            height: bottomHeight,
            child: child,
          );
        }
        return Positioned(
          left: inset?.left ?? 0,
          right: inset?.right ?? 0,
          bottom: 0,
          child: child,
        );
      case TPopupPlacement.left:
        final inset = this.inset is TPopupLeftInset
            ? this.inset as TPopupLeftInset
            : null;
        return Positioned(
          top: inset?.top ?? 0,
          bottom: inset?.bottom ?? 0,
          left: 0,
          width: width ?? defaultDrawerWidth,
          child: child,
        );
      case TPopupPlacement.right:
        final inset = this.inset is TPopupRightInset
            ? this.inset as TPopupRightInset
            : null;
        return Positioned(
          top: inset?.top ?? 0,
          bottom: inset?.bottom ?? 0,
          right: 0,
          width: width ?? defaultDrawerWidth,
          child: child,
        );
      case TPopupPlacement.center:
        return Positioned.fill(
          child: Center(child: child),
        );
    }
  }

  double? _bottomHeight() {
    if (height != null) {
      return height;
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
