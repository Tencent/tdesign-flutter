import 'package:flutter/material.dart';

/// TLoading 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认加载样式。
class TLoadingThemeData extends ThemeExtension<TLoadingThemeData> {
  /// 图标颜色
  final Color? iconColor;

  /// 文案颜色
  final Color? textColor;

  /// 文案和图标相对方向
  final Axis? axis;

  /// 一次刷新的时间（毫秒），控制动画速度
  final int? duration;

  const TLoadingThemeData({
    this.iconColor,
    this.textColor,
    this.axis,
    this.duration,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TLoadingThemeData merge(TLoadingThemeData? other) {
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

  @override
  TLoadingThemeData lerp(ThemeExtension<TLoadingThemeData>? other, double t) {
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
