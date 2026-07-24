import 'package:flutter/material.dart';

/// TDropdownMenu 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认下拉菜单样式。
class TDropdownThemeData extends ThemeExtension<TDropdownThemeData> {
  /// 菜单栏宽度
  final double? width;

  /// 菜单栏高度
  final double? height;

  /// 菜单栏装饰
  final BoxDecoration? decoration;

  /// 箭头图标
  final IconData? arrowIcon;

  /// 箭头颜色
  final Color? arrowColor;

  /// 标签栏对齐
  final MainAxisAlignment? tabBarAlign;

  /// 弹出层遮罩颜色
  final Color? overlayColor;

  const TDropdownThemeData({
    this.width,
    this.height,
    this.decoration,
    this.arrowIcon,
    this.arrowColor,
    this.tabBarAlign,
    this.overlayColor,
  });

  TDropdownThemeData merge(TDropdownThemeData? other) {
    if (other == null) {
      return this;
    }
    return TDropdownThemeData(
      width: other.width ?? width,
      height: other.height ?? height,
      decoration: other.decoration ?? decoration,
      arrowIcon: other.arrowIcon ?? arrowIcon,
      arrowColor: other.arrowColor ?? arrowColor,
      tabBarAlign: other.tabBarAlign ?? tabBarAlign,
      overlayColor: other.overlayColor ?? overlayColor,
    );
  }

  @override
  TDropdownThemeData copyWith({
    double? width,
    double? height,
    BoxDecoration? decoration,
    IconData? arrowIcon,
    Color? arrowColor,
    MainAxisAlignment? tabBarAlign,
    Color? overlayColor,
  }) {
    return TDropdownThemeData(
      width: width ?? this.width,
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      arrowIcon: arrowIcon ?? this.arrowIcon,
      arrowColor: arrowColor ?? this.arrowColor,
      tabBarAlign: tabBarAlign ?? this.tabBarAlign,
      overlayColor: overlayColor ?? this.overlayColor,
    );
  }

  @override
  TDropdownThemeData lerp(ThemeExtension<TDropdownThemeData>? other, double t) {
    if (other is! TDropdownThemeData) {
      return this;
    }
    return TDropdownThemeData(
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      decoration: t < 0.5 ? decoration : other.decoration,
      arrowIcon: t < 0.5 ? arrowIcon : other.arrowIcon,
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t),
      tabBarAlign: t < 0.5 ? tabBarAlign : other.tabBarAlign,
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
