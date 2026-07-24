import 'package:flutter/material.dart';

/// TSwipeCell 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认滑动单元格样式。
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData> {
  /// 打开关闭动画时长
  final Duration? duration;

  const TSwipeCellThemeData({
    this.duration,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TSwipeCellThemeData merge(TSwipeCellThemeData? other) {
    if (other == null) {
      return this;
    }
    return TSwipeCellThemeData(
      duration: other.duration ?? duration,
    );
  }

  @override
  TSwipeCellThemeData copyWith({
    Duration? duration,
  }) {
    return TSwipeCellThemeData(
      duration: duration ?? this.duration,
    );
  }

  @override
  TSwipeCellThemeData lerp(ThemeExtension<TSwipeCellThemeData>? other, double t) {
    if (other is! TSwipeCellThemeData) {
      return this;
    }
    return TSwipeCellThemeData(
      duration: t < 0.5 ? duration : other.duration,
    );
  }
}
