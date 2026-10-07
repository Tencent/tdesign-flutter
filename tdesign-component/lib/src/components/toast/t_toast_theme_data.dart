import 'package:flutter/material.dart';

/// TToast 组件级 ThemeExtension
class TToastThemeData extends ThemeExtension<TToastThemeData> {
  /// 背景色
  final Color? backgroundColor;

  /// 文案样式
  final TextStyle? textStyle;

  /// 图标尺寸
  final double? iconSize;

  /// 图标颜色
  final Color? iconColor;

  /// 圆角
  final double? borderRadius;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 最大宽度
  final double? maxWidth;

  const TToastThemeData({
    this.backgroundColor,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.borderRadius,
    this.padding,
    this.maxWidth,
  });

  /// 合并其他 ThemeData，非空字段优先取 [other]
  TToastThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TToastThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TToastThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: other.textStyle ?? textStyle,
      iconSize: other.iconSize ?? iconSize,
      iconColor: other.iconColor ?? iconColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      maxWidth: other.maxWidth ?? maxWidth,
    );
  }

  @override
  TToastThemeData copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
  }) {
    return TToastThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
    );
  }

  @override
  TToastThemeData lerp(ThemeExtension<TToastThemeData>? other, double t) {
    if (other is! TToastThemeData) {
      return this;
    }
    return TToastThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t),
    );
  }

  /// 对 [a] 和 [b] 按 [t] 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。
  static double? lerpDouble(
    /// 插值起始值；单端为空时按 0 参与插值。
    double? a,

    /// 插值目标值；单端为空时按 0 参与插值。
    double? b,

    /// 插值进度；0 表示起点，1 表示终点。
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
