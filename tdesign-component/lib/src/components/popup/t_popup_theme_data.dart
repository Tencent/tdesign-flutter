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

  /// 打开/关闭动画时长，默认 300ms（与官方及仓库其他浮层组件对齐）。
  final Duration? transitionDuration;

  /// 内容区圆角。
  ///
  /// top/bottom/center 默认取全局主题大圆角；
  /// left/right 默认**无圆角**（对齐官方全高矩形），仅当设置本字段时应用圆角。
  final double? panelRadius;

  /// 内容区背景色
  final Color? panelBackgroundColor;

  /// top / bottom 未显式传入高度时的默认面板高度
  final double? edgeHeight;

  /// left / right 未显式传入宽度时的默认抽屉宽度
  final double? drawerWidth;

  /// center 未显式传入宽高时的默认面板尺寸
  final Size? centerSize;

  const TPopupThemeData({
    this.barrierColor,
    this.barrierOpacity,
    this.transitionDuration,
    this.panelRadius,
    this.panelBackgroundColor,
    this.edgeHeight,
    this.drawerWidth,
    this.centerSize,
  }) : assert(edgeHeight == null || edgeHeight > 0),
       assert(drawerWidth == null || drawerWidth > 0);

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
      edgeHeight: other.edgeHeight ?? edgeHeight,
      drawerWidth: other.drawerWidth ?? drawerWidth,
      centerSize: other.centerSize ?? centerSize,
    );
  }

  @override
  TPopupThemeData copyWith({
    Color? barrierColor,
    double? barrierOpacity,
    Duration? transitionDuration,
    double? panelRadius,
    Color? panelBackgroundColor,
    double? edgeHeight,
    double? drawerWidth,
    Size? centerSize,
  }) {
    return TPopupThemeData(
      barrierColor: barrierColor ?? this.barrierColor,
      barrierOpacity: barrierOpacity ?? this.barrierOpacity,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      panelRadius: panelRadius ?? this.panelRadius,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      edgeHeight: edgeHeight ?? this.edgeHeight,
      drawerWidth: drawerWidth ?? this.drawerWidth,
      centerSize: centerSize ?? this.centerSize,
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
      transitionDuration: t < 0.5
          ? transitionDuration
          : other.transitionDuration,
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      panelBackgroundColor: Color.lerp(
        panelBackgroundColor,
        other.panelBackgroundColor,
        t,
      ),
      edgeHeight: lerpDouble(edgeHeight, other.edgeHeight, t),
      drawerWidth: lerpDouble(drawerWidth, other.drawerWidth, t),
      centerSize: Size.lerp(centerSize, other.centerSize, t),
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
