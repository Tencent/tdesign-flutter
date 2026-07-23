import 'package:flutter/material.dart';

/// TPopup 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认浮层样式。
/// `TPopupOptions` 的对应字段优先于 Theme Extension。
class TPopupThemeData extends ThemeExtension<TPopupThemeData> {
  /// 蒙层颜色
  final Color? barrierColor;

  /// 蒙层透明度系数
  final double? barrierOpacity;

  /// 打开/关闭动画时长
  final Duration? transitionDuration;

  /// 内容区圆角
  final double? panelRadius;

  /// 内容区背景色
  final Color? panelBackgroundColor;

  const TPopupThemeData({
    this.barrierColor,
    this.barrierOpacity,
    this.transitionDuration,
    this.panelRadius,
    this.panelBackgroundColor,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TPopupThemeData merge(TPopupThemeData? other) {
    if (other == null) {
      return this;
    }
    return TPopupThemeData(
      barrierColor: other.barrierColor ?? barrierColor,
      barrierOpacity: other.barrierOpacity ?? barrierOpacity,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      panelRadius: other.panelRadius ?? panelRadius,
      panelBackgroundColor: other.panelBackgroundColor ?? panelBackgroundColor,
    );
  }

  @override
  TPopupThemeData copyWith({
    Color? barrierColor,
    double? barrierOpacity,
    Duration? transitionDuration,
    double? panelRadius,
    Color? panelBackgroundColor,
  }) {
    return TPopupThemeData(
      barrierColor: barrierColor ?? this.barrierColor,
      barrierOpacity: barrierOpacity ?? this.barrierOpacity,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      panelRadius: panelRadius ?? this.panelRadius,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
    );
  }

  @override
  TPopupThemeData lerp(ThemeExtension<TPopupThemeData>? other, double t) {
    if (other is! TPopupThemeData) {
      return this;
    }
    return TPopupThemeData(
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      barrierOpacity: lerpDouble(barrierOpacity, other.barrierOpacity, t),
      transitionDuration:
          t < 0.5 ? transitionDuration : other.transitionDuration,
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      panelBackgroundColor:
          Color.lerp(panelBackgroundColor, other.panelBackgroundColor, t),
    );
  }

  static double? lerpDouble(
    /// 起始值。
    double? a,

    /// 目标值。
    double? b,

    /// 插值进度。
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
