import 'package:flutter/material.dart';

import 't_action_sheet_types.dart';

/// TActionSheet 组件级 ThemeExtension
class TActionSheetThemeData extends ThemeExtension<TActionSheetThemeData> {
  /// 默认对齐
  final TActionSheetAlign? defaultAlign;

  /// 项高度
  final double? itemHeight;

  /// 横向滚动宫格与分组项目的最小宽度。
  ///
  /// 滚动宫格未配置时会按 `count / rows` 自适应项目宽度；配置后作为最小宽度。
  final double? itemMinWidth;

  /// 宫格列数
  final int? count;

  /// 宫格行数
  final int? rows;

  /// 蒙层颜色
  final Color? barrierColor;

  /// 面板圆角
  final double? panelRadius;

  /// 默认图标字形尺寸；同时作为列表图标槽位尺寸。
  final double? iconSize;

  /// 宫格和分组布局的图标槽位尺寸。
  final double? gridIconExtent;

  /// 默认图标颜色。
  final Color? iconColor;

  const TActionSheetThemeData({
    this.defaultAlign,
    this.itemHeight,
    this.itemMinWidth,
    this.count,
    this.rows,
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
      defaultAlign: other.defaultAlign ?? defaultAlign,
      itemHeight: other.itemHeight ?? itemHeight,
      itemMinWidth: other.itemMinWidth ?? itemMinWidth,
      count: other.count ?? count,
      rows: other.rows ?? rows,
      barrierColor: other.barrierColor ?? barrierColor,
      panelRadius: other.panelRadius ?? panelRadius,
      iconSize: other.iconSize ?? iconSize,
      gridIconExtent: other.gridIconExtent ?? gridIconExtent,
      iconColor: other.iconColor ?? iconColor,
    );
  }

  @override
  TActionSheetThemeData copyWith({
    TActionSheetAlign? defaultAlign,
    double? itemHeight,
    double? itemMinWidth,
    int? count,
    int? rows,
    Color? barrierColor,
    double? panelRadius,
    double? iconSize,
    double? gridIconExtent,
    Color? iconColor,
  }) {
    return TActionSheetThemeData(
      defaultAlign: defaultAlign ?? this.defaultAlign,
      itemHeight: itemHeight ?? this.itemHeight,
      itemMinWidth: itemMinWidth ?? this.itemMinWidth,
      count: count ?? this.count,
      rows: rows ?? this.rows,
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
      defaultAlign: t < 0.5 ? defaultAlign : other.defaultAlign,
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t),
      itemMinWidth: lerpDouble(itemMinWidth, other.itemMinWidth, t),
      count: t < 0.5 ? count : other.count,
      rows: t < 0.5 ? rows : other.rows,
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
