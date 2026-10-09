import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_fab_layout.dart';

/// Fab 定位层 ThemeExtension
///
/// 仅管理 Fab 定位层的默认值（偏移、边界、拖拽阈值等）。
/// 默认动作层固定使用 large / fill / primary；需要完整自定义动作层时使用
/// `TFab.child`。
///
/// {@category ComponentTheme}
class TFabThemeData extends ThemeExtension<TFabThemeData> {
  /// 距父级 Stack 右侧的默认偏移；未设置时为 16 逻辑像素。
  final double? defaultRight;

  /// 距父级 Stack 底部的默认偏移；未设置时为 32 逻辑像素。
  final double? defaultBottom;

  /// 默认水平拖拽边界；未设置时左右各保留 16 逻辑像素。
  final TFabBounds? defaultXBounds;

  /// 默认垂直拖拽边界；未设置时上下边界均为 0。
  final TFabBounds? defaultYBounds;

  /// 吸附动画时长；未设置时为 200 毫秒。
  final Duration? magnetAnimationDuration;

  /// 点击与拖拽的判定阈值；未设置时为 18 逻辑像素。
  ///
  /// 按手势起点到当前位置的屏幕全方向最大位移判定，与 [TFabDragAxis] 限制的
  /// 位置更新轴向无关。
  final double? dragTapSlop;

  const TFabThemeData({
    this.defaultRight,
    this.defaultBottom,
    this.defaultXBounds,
    this.defaultYBounds,
    this.magnetAnimationDuration,
    this.dragTapSlop,
  });

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TFabThemeData copyWith({
    double? defaultRight,
    double? defaultBottom,
    TFabBounds? defaultXBounds,
    TFabBounds? defaultYBounds,
    Duration? magnetAnimationDuration,
    double? dragTapSlop,
  }) {
    return TFabThemeData(
      defaultRight: defaultRight ?? this.defaultRight,
      defaultBottom: defaultBottom ?? this.defaultBottom,
      defaultXBounds: defaultXBounds ?? this.defaultXBounds,
      defaultYBounds: defaultYBounds ?? this.defaultYBounds,
      magnetAnimationDuration:
          magnetAnimationDuration ?? this.magnetAnimationDuration,
      dragTapSlop: dragTapSlop ?? this.dragTapSlop,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TFabThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TFabThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TFabThemeData) {
      return this;
    }
    return TFabThemeData(
      defaultRight: lerpDouble(defaultRight, other.defaultRight, t),
      defaultBottom: lerpDouble(defaultBottom, other.defaultBottom, t),
      defaultXBounds: t < 0.5 ? defaultXBounds : other.defaultXBounds,
      defaultYBounds: t < 0.5 ? defaultYBounds : other.defaultYBounds,
      magnetAnimationDuration: t < 0.5
          ? magnetAnimationDuration
          : other.magnetAnimationDuration,
      dragTapSlop: lerpDouble(dragTapSlop, other.dragTapSlop, t),
    );
  }
}
