import 'package:flutter/material.dart';

/// TActionSheet 组件级视觉 ThemeExtension
class TActionSheetThemeData extends ThemeExtension<TActionSheetThemeData> {
  /// 宫格项目高度
  /// 未配置时为 96 逻辑像素，show 方法的 itemHeight 优先。
  final double? gridItemHeight;

  /// 蒙层颜色
  final Color? barrierColor;

  /// 面板圆角
  final double? panelRadius;

  /// 默认图标字形尺寸；同时作为列表图标槽位尺寸。
  /// 未配置时为 24 逻辑像素。
  final double? iconSize;

  /// 宫格布局的图标槽位尺寸；未设置时默认 40dp。
  final double? gridIconExtent;

  /// 默认图标颜色。
  /// 未配置时使用 textColorPrimary Token；禁用项使用 textColorDisabled。
  final Color? iconColor;

  const TActionSheetThemeData({
    this.gridItemHeight,
    this.barrierColor,
    this.panelRadius,
    this.iconSize,
    this.gridIconExtent,
    this.iconColor,
  });

  /// 返回合并后的主题；[other] 的非空字段覆盖当前字段，other 为空时返回当前主题。
  TActionSheetThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TActionSheetThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TActionSheetThemeData(
      gridItemHeight: other.gridItemHeight ?? gridItemHeight,
      barrierColor: other.barrierColor ?? barrierColor,
      panelRadius: other.panelRadius ?? panelRadius,
      iconSize: other.iconSize ?? iconSize,
      gridIconExtent: other.gridIconExtent ?? gridIconExtent,
      iconColor: other.iconColor ?? iconColor,
    );
  }

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TActionSheetThemeData copyWith({
    double? gridItemHeight,
    Color? barrierColor,
    double? panelRadius,
    double? iconSize,
    double? gridIconExtent,
    Color? iconColor,
  }) {
    return TActionSheetThemeData(
      gridItemHeight: gridItemHeight ?? this.gridItemHeight,
      barrierColor: barrierColor ?? this.barrierColor,
      panelRadius: panelRadius ?? this.panelRadius,
      iconSize: iconSize ?? this.iconSize,
      gridIconExtent: gridIconExtent ?? this.gridIconExtent,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TActionSheetThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TActionSheetThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TActionSheetThemeData) {
      return this;
    }
    return TActionSheetThemeData(
      gridItemHeight: _lerpDouble(gridItemHeight, other.gridItemHeight, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      panelRadius: _lerpDouble(panelRadius, other.panelRadius, t),
      iconSize: _lerpDouble(iconSize, other.iconSize, t),
      gridIconExtent: _lerpDouble(gridIconExtent, other.gridIconExtent, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
