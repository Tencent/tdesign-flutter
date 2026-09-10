import 'package:flutter/material.dart';

/// 骨架屏组件级 ThemeExtension。
///
/// 仅保存占位块的视觉和布局默认值；动画、延迟与具体布局由实例决定。
class TSkeletonThemeData extends ThemeExtension<TSkeletonThemeData> {
  const TSkeletonThemeData({
    this.blockColor,
    this.highlightColor,
    this.borderRadius,
    this.rowSpacing,
  }) : assert(borderRadius == null || borderRadius >= 0),
       assert(rowSpacing == null || rowSpacing >= 0);

  /// 占位块背景色。
  final Color? blockColor;

  /// 渐变动画高亮色。
  final Color? highlightColor;

  /// 普通占位块圆角。
  final double? borderRadius;

  /// 多行布局的默认行间距。
  final double? rowSpacing;

  @override
  TSkeletonThemeData copyWith({
    Color? blockColor,
    Color? highlightColor,
    double? borderRadius,
    double? rowSpacing,
  }) {
    return TSkeletonThemeData(
      blockColor: blockColor ?? this.blockColor,
      highlightColor: highlightColor ?? this.highlightColor,
      borderRadius: borderRadius ?? this.borderRadius,
      rowSpacing: rowSpacing ?? this.rowSpacing,
    );
  }

  @override
  TSkeletonThemeData lerp(TSkeletonThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return TSkeletonThemeData(
      blockColor: Color.lerp(blockColor, other.blockColor, t),
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t),
      borderRadius: _lerpNullableDouble(borderRadius, other.borderRadius, t),
      rowSpacing: _lerpNullableDouble(rowSpacing, other.rowSpacing, t),
    );
  }

  double? _lerpNullableDouble(double? a, double? b, double t) {
    if (a == null || b == null) {
      return t < .5 ? a : b;
    }
    return a + (b - a) * t;
  }
}
