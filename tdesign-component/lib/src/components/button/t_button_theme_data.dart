import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_button_defaults.dart';

/// TButton 组件级 ThemeExtension
///
/// 只承载 [ButtonStyle] 不能表达的按钮子树默认视觉值。
class TButtonThemeData extends ThemeExtension<TButtonThemeData> {
  /// 图标与文案之间的间距，单位为逻辑像素。
  ///
  /// 仅在按钮同时提供 icon 和 child 时生效；该值控制两者
  /// 之间的实际间隔，不会改变按钮整体内边距。为空时使用组件内置
  /// 默认值 4dp；全局 `spacer4` 对应 32dp，不用于此间距。
  final double? iconTextSpacing;

  /// 渐变背景色（装饰层，非 ButtonStyle 字段）
  final Gradient? gradient;

  const TButtonThemeData({this.iconTextSpacing, this.gradient})
    : assert(
        iconTextSpacing == null ||
            (iconTextSpacing >= 0 && iconTextSpacing < double.infinity),
        'iconTextSpacing must be finite and non-negative',
      );

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TButtonThemeData copyWith({double? iconTextSpacing, Gradient? gradient}) {
    return TButtonThemeData(
      iconTextSpacing: iconTextSpacing ?? this.iconTextSpacing,
      gradient: gradient ?? this.gradient,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TButtonThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TButtonThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TButtonThemeData) {
      return this;
    }
    return TButtonThemeData(
      iconTextSpacing: iconTextSpacing == null && other.iconTextSpacing == null
          ? null
          : lerpDouble(
              iconTextSpacing ?? TButtonDefaults.iconTextSpacing,
              other.iconTextSpacing ?? TButtonDefaults.iconTextSpacing,
              t,
            ),
      gradient: t < 0.5 ? gradient : other.gradient,
    );
  }
}
