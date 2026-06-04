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

  Widget wrapPositioned({
    required Widget child,
    EdgeInsets safePadding = EdgeInsets.zero,
  }) {
    switch (placement) {
      case TPopupPlacement.top:
        final inset =
            this.inset is TPopupTopInset ? this.inset as TPopupTopInset : null;
        return Positioned(
          top: safePadding.top,
          left: (inset?.left ?? 0) + safePadding.left,
          right: (inset?.right ?? 0) + safePadding.right,
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
            left: (inset?.left ?? 0) + safePadding.left,
            right: (inset?.right ?? 0) + safePadding.right,
            bottom: safePadding.bottom,
            height: bottomHeight,
            child: child,
          );
        }
        return Positioned(
          left: (inset?.left ?? 0) + safePadding.left,
          right: (inset?.right ?? 0) + safePadding.right,
          bottom: safePadding.bottom,
          child: child,
        );
      case TPopupPlacement.left:
        final inset = this.inset is TPopupLeftInset
            ? this.inset as TPopupLeftInset
            : null;
        return Positioned(
          top: (inset?.top ?? 0) + safePadding.top,
          bottom: (inset?.bottom ?? 0) + safePadding.bottom,
          left: safePadding.left,
          width: width ?? defaultDrawerWidth,
          child: child,
        );
      case TPopupPlacement.right:
        final inset = this.inset is TPopupRightInset
            ? this.inset as TPopupRightInset
            : null;
        return Positioned(
          top: (inset?.top ?? 0) + safePadding.top,
          bottom: (inset?.bottom ?? 0) + safePadding.bottom,
          right: safePadding.right,
          width: width ?? defaultDrawerWidth,
          child: child,
        );
      case TPopupPlacement.center:
        return Positioned.fill(
          child: Center(child: child),
        );
    }
  }

  /// 按 [placement] 从 [MediaQuery.padding] 提取需避让的安全区内边距。
  static EdgeInsets safePaddingFor(
    TPopupPlacement placement,
    EdgeInsets mediaPadding,
    bool useSafeArea,
  ) {
    if (!useSafeArea) {
      return EdgeInsets.zero;
    }
    switch (placement) {
      case TPopupPlacement.top:
        return EdgeInsets.only(top: mediaPadding.top);
      case TPopupPlacement.bottom:
        return EdgeInsets.only(bottom: mediaPadding.bottom);
      case TPopupPlacement.left:
        return EdgeInsets.only(
          left: mediaPadding.left,
          top: mediaPadding.top,
          bottom: mediaPadding.bottom,
        );
      case TPopupPlacement.right:
        return EdgeInsets.only(
          right: mediaPadding.right,
          top: mediaPadding.top,
          bottom: mediaPadding.bottom,
        );
      case TPopupPlacement.center:
        // center 不参与贴边避让，由面板尺寸自然落在可视区中部。
        return EdgeInsets.zero;
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
