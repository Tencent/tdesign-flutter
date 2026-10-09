import 'package:flutter/material.dart';

/// 骨架屏组件级 ThemeExtension。
///
/// 仅保存占位块的视觉和布局默认值；动画、延迟与具体布局由实例决定。
///
/// {@category ComponentTheme}
class TSkeletonThemeData extends ThemeExtension<TSkeletonThemeData> {
  const TSkeletonThemeData({
    this.blockColor,
    this.highlightColor,
    this.borderRadius,
    this.rowSpacing,
  }) : assert(borderRadius == null || borderRadius >= 0),
       assert(rowSpacing == null || rowSpacing >= 0);

  /// 占位块背景色。
  /// 未配置时使用 bgColorSecondaryContainer Token。
  final Color? blockColor;

  /// 渐变动画高亮色。
  /// 未配置时使用 bgColorSecondaryContainerActive Token。
  final Color? highlightColor;

  /// 普通占位块圆角。
  /// 未配置时使用 radiusSmall Token，必须大于或等于 0。
  final double? borderRadius;

  /// 多行布局的默认行间距。
  /// 未配置时使用 spacer2 Token，必须大于或等于 0。
  final double? rowSpacing;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSkeletonThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    TSkeletonThemeData? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
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
