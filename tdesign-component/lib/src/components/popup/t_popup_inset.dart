part of 't_popup.dart';

/// Popup 在交叉轴方向的边缘留白基类。
abstract class TPopupInset {
  const TPopupInset();
}

/// bottom 方向的左右留白。
class TPopupBottomInset extends TPopupInset {
  const TPopupBottomInset({
    this.left = 0,
    this.right = 0,
  });

  /// 左侧留白
  final double left;

  /// 右侧留白
  final double right;
}

/// top 方向的左右留白。
class TPopupTopInset extends TPopupInset {
  const TPopupTopInset({
    this.left = 0,
    this.right = 0,
  });

  /// 左侧留白
  final double left;

  /// 右侧留白
  final double right;
}

/// left 方向的上下留白。
class TPopupLeftInset extends TPopupInset {
  const TPopupLeftInset({
    this.top = 0,
    this.bottom = 0,
  });

  /// 顶部留白
  final double top;

  /// 底部留白
  final double bottom;
}

/// right 方向的上下留白。
class TPopupRightInset extends TPopupInset {
  const TPopupRightInset({
    this.top = 0,
    this.bottom = 0,
  });

  /// 顶部留白
  final double top;

  /// 底部留白
  final double bottom;
}
