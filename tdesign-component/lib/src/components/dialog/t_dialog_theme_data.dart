import 'package:flutter/material.dart';

/// TDialog 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认对话框样式。
/// 面板视觉值由本扩展统一配置；未设置时回退 TDesign Token 或组件内置值，
/// 不从 Flutter DialogTheme 读取。
class TDialogThemeData extends ThemeExtension<TDialogThemeData> {
  /// 背景色（对应 Material [DialogThemeData.backgroundColor]）
  /// 未配置时使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 形状（圆角；对应 Material [DialogThemeData.shape]）
  /// 未配置时使用 radiusExtraLarge Token 构造圆角矩形。
  final ShapeBorder? shape;

  /// 阴影（对应 Material [DialogThemeData.elevation]）
  /// 未配置时为 0。
  final double? elevation;

  /// 标题文案样式（对应 Material [DialogThemeData.titleTextStyle]）
  /// 未配置时使用 fontTitleLarge / textColorPrimary Token。
  final TextStyle? titleTextStyle;

  /// 内容文案样式（对应 Material [DialogThemeData.contentTextStyle]）
  /// 未配置时使用 fontBodyLarge / textColorSecondary Token。
  final TextStyle? contentTextStyle;

  /// 内容内边距（对应 Material [Dialog] 的 contentPadding；TDesign 扩展）
  /// 未配置时左、上、右均使用 spacer3，底部为 0。
  final EdgeInsetsGeometry? contentPadding;

  /// 面板最大高度。
  /// 未配置时为视口高度的 80%；同时不超过视口高度减 spacer4，最小为 0。
  final double? maxHeight;

  /// 弹窗宽度
  /// 未配置时为 311 逻辑像素，实际布局仍受可用宽度限制。
  final double? width;

  const TDialogThemeData({
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.titleTextStyle,
    this.contentTextStyle,
    this.contentPadding,
    this.maxHeight,
    this.width,
  });

  /// 合并主题配置。
  ///
  /// ## 返回值
  /// other 的非空字段优先的合并主题；other 为 null 时返回当前主题。
  TDialogThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TDialogThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TDialogThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      shape: other.shape ?? shape,
      elevation: other.elevation ?? elevation,
      titleTextStyle: other.titleTextStyle ?? titleTextStyle,
      contentTextStyle: other.contentTextStyle ?? contentTextStyle,
      contentPadding: other.contentPadding ?? contentPadding,
      maxHeight: other.maxHeight ?? maxHeight,
      width: other.width ?? width,
    );
  }

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TDialogThemeData copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? contentPadding,
    double? maxHeight,
    double? width,
  }) {
    return TDialogThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      maxHeight: maxHeight ?? this.maxHeight,
      width: width ?? this.width,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TDialogThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TDialogThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TDialogThemeData) {
      return this;
    }
    return TDialogThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      contentTextStyle: TextStyle.lerp(
        contentTextStyle,
        other.contentTextStyle,
        t,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        contentPadding,
        other.contentPadding,
        t,
      ),
      maxHeight: lerpDouble(maxHeight, other.maxHeight, t),
      width: lerpDouble(width, other.width, t),
    );
  }

  /// 对 [a] 和 [b] 按 [t] 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。
  ///
  /// ## 返回值
  /// 按 t 线性插值的数值；两端均为 null 时为 null，仅一端为 null 时将该端按 0 计算。
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
