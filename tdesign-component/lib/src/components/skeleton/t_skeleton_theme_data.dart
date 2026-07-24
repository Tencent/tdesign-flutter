import 'package:flutter/material.dart';

/// 骨架屏组件级 ThemeExtension。
///
/// 仅保存占位块的视觉默认值。布局、动画类型和延迟均由实例决定。
class TSkeletonThemeData extends ThemeExtension<TSkeletonThemeData> {
  const TSkeletonThemeData({
    this.blockColor,
    this.highlightColor,
    this.borderRadius,
    this.rowSpacing,
  });

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
      borderRadius: _lerpDouble(borderRadius, other.borderRadius, t),
      rowSpacing: _lerpDouble(rowSpacing, other.rowSpacing, t),
    );
  }

  double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
  }
}
