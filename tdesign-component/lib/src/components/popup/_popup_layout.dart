part of 't_popup.dart';

/// 按 [TPopupPlacement] 计算 [Positioned]；center 仅居中，尺寸由 [PopupShell] 约束。
class PopupLayout {
  PopupLayout({required this.placement, this.inset, this.width, this.height});

  final TPopupPlacement placement;
  final TPopupInset? inset;
  final double? width;
  final double? height;

  /// top / bottom 未指定高度时的默认面板高度。
  static const double defaultEdgeHeight = 240;

  /// left / right 未指定宽度时的默认抽屉宽度。
  static const double defaultDrawerWidth = 280;

  /// center 未指定尺寸时的默认面板宽度。
  static const double defaultCenterWidth = 240;

  /// center 未指定尺寸时的默认面板高度。
  static const double defaultCenterHeight = 240;

  Widget wrapPositioned({
    required Widget child,
    EdgeInsets safePadding = EdgeInsets.zero,
    Size? availableSize,
  }) {
    double clampHeight(double preferred) {
      if (availableSize == null) {
        return preferred;
      }
      final availableHeight = math.max(
        0.0,
        availableSize.height - safePadding.vertical,
      );
      return math.min(preferred, availableHeight);
    }

    double clampWidth(double preferred) {
      if (availableSize == null) {
        return preferred;
      }
      final availableWidth = math.max(
        0.0,
        availableSize.width - safePadding.horizontal,
      );
      return math.min(preferred, availableWidth);
    }

    switch (placement) {
      case TPopupPlacement.top:
        final inset = this.inset is TPopupTopInset
            ? this.inset as TPopupTopInset
            : null;
        return Positioned(
          top: safePadding.top,
          left: (inset?.left ?? 0) + safePadding.left,
          right: (inset?.right ?? 0) + safePadding.right,
          height: clampHeight(height ?? defaultEdgeHeight),
          child: child,
        );
      case TPopupPlacement.bottom:
        final inset = this.inset is TPopupBottomInset
            ? this.inset as TPopupBottomInset
            : null;
        return Positioned(
          left: (inset?.left ?? 0) + safePadding.left,
          right: (inset?.right ?? 0) + safePadding.right,
          bottom: safePadding.bottom,
          height: clampHeight(height ?? defaultEdgeHeight),
          child: child,
        );
      case TPopupPlacement.left:
        final inset = this.inset is TPopupLeftInset
            ? this.inset as TPopupLeftInset
            : null;
        // Full-height drawer (issue #1225): vertical safe area no longer
        // participates; top/bottom come only from the explicit inset
        // (kept numeric so the height stays bounded).
        return Positioned(
          top: inset?.top ?? 0,
          bottom: inset?.bottom ?? 0,
          left: safePadding.left,
          width: clampWidth(width ?? defaultDrawerWidth),
          child: child,
        );
      case TPopupPlacement.right:
        final inset = this.inset is TPopupRightInset
            ? this.inset as TPopupRightInset
            : null;
        // Same as left: full-height rect, vertical only from explicit inset.
        return Positioned(
          top: inset?.top ?? 0,
          bottom: inset?.bottom ?? 0,
          right: safePadding.right,
          width: clampWidth(width ?? defaultDrawerWidth),
          child: child,
        );
      case TPopupPlacement.center:
        return Positioned(
          top: safePadding.top,
          bottom: safePadding.bottom,
          left: safePadding.left,
          right: safePadding.right,
          child: Center(child: child),
        );
    }
  }

  /// 按 [placement] 从 MediaQuery.padding 提取需避让的安全区内边距。
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
        // Full-height drawer per official design (issue #1225): skip
        // vertical safe-area avoidance here; content handles it via
        // SafeArea so the panel never shows hollow strips.
        return EdgeInsets.only(left: mediaPadding.left);
      case TPopupPlacement.right:
        // Same as left: full height, only the attached edge is avoided.
        return EdgeInsets.only(right: mediaPadding.right);
      case TPopupPlacement.center:
        return mediaPadding;
    }
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
