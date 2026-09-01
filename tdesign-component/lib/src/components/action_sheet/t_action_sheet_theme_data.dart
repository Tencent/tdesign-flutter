import 'package:flutter/material.dart';

/// TActionSheet 组件级 ThemeExtension
class TActionSheetThemeData extends ThemeExtension<TActionSheetThemeData> {
  /// 项高度
  final double? itemHeight;

  /// 蒙层颜色
  final Color? barrierColor;

  /// 面板圆角
  final double? panelRadius;

  /// 默认图标字形尺寸；同时作为列表图标槽位尺寸。
  final double? iconSize;

  /// 宫格布局的图标槽位尺寸。
  final double? gridIconExtent;

  /// 默认图标颜色。
  final Color? iconColor;

  const TActionSheetThemeData({
    this.itemHeight,
    this.barrierColor,
    this.panelRadius,
    this.iconSize,
    this.gridIconExtent,
    this.iconColor,
  });

  TActionSheetThemeData merge(TActionSheetThemeData? other) {
    if (other == null) {
      return this;
    }
    return TActionSheetThemeData(
      itemHeight: other.itemHeight ?? itemHeight,
      barrierColor: other.barrierColor ?? barrierColor,
      panelRadius: other.panelRadius ?? panelRadius,
      iconSize: other.iconSize ?? iconSize,
      gridIconExtent: other.gridIconExtent ?? gridIconExtent,
      iconColor: other.iconColor ?? iconColor,
    );
  }

  @override
  TActionSheetThemeData copyWith({
    double? itemHeight,
    Color? barrierColor,
    double? panelRadius,
    double? iconSize,
    double? gridIconExtent,
    Color? iconColor,
  }) {
    return TActionSheetThemeData(
      itemHeight: itemHeight ?? this.itemHeight,
      barrierColor: barrierColor ?? this.barrierColor,
      panelRadius: panelRadius ?? this.panelRadius,
      iconSize: iconSize ?? this.iconSize,
      gridIconExtent: gridIconExtent ?? this.gridIconExtent,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  TActionSheetThemeData lerp(
    ThemeExtension<TActionSheetThemeData>? other,
    double t,
  ) {
    if (other is! TActionSheetThemeData) {
      return this;
    }
    return TActionSheetThemeData(
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      gridIconExtent: lerpDouble(gridIconExtent, other.gridIconExtent, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
