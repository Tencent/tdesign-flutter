import 'package:flutter/material.dart';

/// TLoading 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认加载样式。
class TLoadingThemeData extends ThemeExtension<TLoadingThemeData> {
  /// 图标颜色。
  ///
  /// 未指定时 circle / point 使用品牌主色，activity 使用主文字色；
  /// 不读取 Flutter ProgressIndicatorTheme 或 ColorScheme 的默认颜色。
  final Color? iconColor;

  /// 文案颜色
  /// 未配置时使用 textColorPrimary Token。
  final Color? textColor;

  /// 文案和图标相对方向
  /// 未配置时为 Axis.horizontal。
  final Axis? axis;

  /// 一次刷新的时间（毫秒），控制动画速度。
  /// 未指定时默认 `800`ms（对齐 TDesign 小程序 / Mobile Vue 的 `duration` 默认值）。
  /// 小于或等于 0 时归一化为 1 毫秒。
  final int? duration;

  const TLoadingThemeData({
    this.iconColor,
    this.textColor,
    this.axis,
    this.duration,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TLoadingThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TLoadingThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TLoadingThemeData(
      iconColor: other.iconColor ?? iconColor,
      textColor: other.textColor ?? textColor,
      axis: other.axis ?? axis,
      duration: other.duration ?? duration,
    );
  }

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TLoadingThemeData copyWith({
    Color? iconColor,
    Color? textColor,
    Axis? axis,
    int? duration,
  }) {
    return TLoadingThemeData(
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      axis: axis ?? this.axis,
      duration: duration ?? this.duration,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TLoadingThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TLoadingThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TLoadingThemeData) {
      return this;
    }
    return TLoadingThemeData(
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      axis: t < 0.5 ? axis : other.axis,
      duration: t < 0.5 ? duration : other.duration,
    );
  }
}
