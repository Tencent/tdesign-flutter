import 'package:flutter/material.dart';

/// Popup 子树默认样式，通过 Theme.extensions 注入。
///
/// | 配置来源 | 优先级 |
/// | --- | --- |
/// | TPopupOptions 显式值 | 最高 |
/// | TPopupThemeData | 其次 |
/// | 组件默认值 | 最后 |
///
/// {@category ComponentTheme}
class TPopupThemeData extends ThemeExtension<TPopupThemeData> {
  /// 蒙层颜色，透明度直接由 [Color] 的 alpha 指定。
  final Color? barrierColor;

  /// 面板圆角；未指定时顶部/底部/居中取全局主题大圆角，左侧/右侧无圆角。
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
    this.panelRadius,
    this.panelBackgroundColor,
    this.edgeHeight,
    this.drawerWidth,
    this.centerSize,
  }) : assert(edgeHeight == null || edgeHeight > 0),
       assert(drawerWidth == null || drawerWidth > 0);

  /// 合并主题；[other] 的非空字段优先，空字段保留当前值。
  ///
  /// ## 返回值
  ///
  /// 合并后的主题；[other] 为空时返回当前对象。
  TPopupThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TPopupThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TPopupThemeData(
      barrierColor: other.barrierColor ?? barrierColor,
      panelRadius: other.panelRadius ?? panelRadius,
      panelBackgroundColor: other.panelBackgroundColor ?? panelBackgroundColor,
      edgeHeight: other.edgeHeight ?? edgeHeight,
      drawerWidth: other.drawerWidth ?? drawerWidth,
      centerSize: other.centerSize ?? centerSize,
    );
  }

  /// 复制主题；非空参数替换对应配置，null 参数保留当前配置。
  ///
  /// ## 返回值
  ///
  /// 应用指定参数后的主题副本。
  @override
  TPopupThemeData copyWith({
    /// 蒙层颜色（含透明度）。
    Color? barrierColor,

    /// 面板圆角。
    double? panelRadius,

    /// 面板背景色。
    Color? panelBackgroundColor,

    /// 顶部/底部面板高度。
    double? edgeHeight,

    /// 左侧/右侧面板宽度。
    double? drawerWidth,

    /// 居中面板尺寸。
    Size? centerSize,
  }) {
    return TPopupThemeData(
      barrierColor: barrierColor ?? this.barrierColor,
      panelRadius: panelRadius ?? this.panelRadius,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      edgeHeight: edgeHeight ?? this.edgeHeight,
      drawerWidth: drawerWidth ?? this.drawerWidth,
      centerSize: centerSize ?? this.centerSize,
    );
  }

  /// 按 [t] 对主题进行插值。
  ///
  /// ## 返回值
  ///
  /// 过渡主题；目标为空或类型不匹配时返回当前对象。
  @override
  TPopupThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TPopupThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TPopupThemeData) {
      return this;
    }
    return TPopupThemeData(
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
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

  /// 数值线性插值。
  ///
  /// | 输入 | 结果 |
  /// | --- | --- |
  /// | 两端均为 null | null |
  /// | 一端为 null | 该端按 0 计算 |
  /// | 两端均非空 | 按 [t] 线性插值 |
  ///
  /// ## 返回值
  ///
  /// 插值结果；两端均为 null 时返回 null。
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
