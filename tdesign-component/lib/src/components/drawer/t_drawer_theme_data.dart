import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../cell/t_cell_theme_data.dart';

/// 抽屉组件 ThemeExtension
///
/// 管理 TDrawer 的子树级默认样式（宽度、背景色、边框、点击反馈等）。
/// 构造器参数优先级高于 ThemeData。
class TDrawerThemeData extends ThemeExtension<TDrawerThemeData> {
  /// 默认宽度
  final double? width;

  /// 默认顶部偏移
  final double? drawerTop;

  /// 默认背景颜色
  final Color? backgroundColor;

  /// 是否默认显示边框
  final bool? bordered;

  /// 是否默认显示最后一行分割线
  final bool? isShowLastBordered;

  /// 是否默认开启点击反馈
  final bool? hover;

  /// 默认列表自定义样式
  final TCellThemeData? style;

  const TDrawerThemeData({
    this.width,
    this.drawerTop,
    this.backgroundColor,
    this.bordered,
    this.isShowLastBordered,
    this.hover,
    this.style,
  });

  @override
  TDrawerThemeData copyWith({
    double? width,
    double? drawerTop,
    Color? backgroundColor,
    bool? bordered,
    bool? isShowLastBordered,
    bool? hover,
    TCellThemeData? style,
  }) {
    return TDrawerThemeData(
      width: width ?? this.width,
      drawerTop: drawerTop ?? this.drawerTop,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      bordered: bordered ?? this.bordered,
      isShowLastBordered: isShowLastBordered ?? this.isShowLastBordered,
      hover: hover ?? this.hover,
      style: style ?? this.style,
    );
  }

  @override
  TDrawerThemeData lerp(ThemeExtension<TDrawerThemeData>? other, double t) {
    if (other is! TDrawerThemeData) {
      return this;
    }
    return TDrawerThemeData(
      width: lerpDouble(width, other.width, t),
      drawerTop: lerpDouble(drawerTop, other.drawerTop, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      bordered: t < 0.5 ? bordered : other.bordered,
      isShowLastBordered:
          t < 0.5 ? isShowLastBordered : other.isShowLastBordered,
      hover: t < 0.5 ? hover : other.hover,
      style: t < 0.5 ? style : other.style,
    );
  }
}
