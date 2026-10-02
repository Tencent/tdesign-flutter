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

  @override
  TButtonThemeData copyWith({double? iconTextSpacing, Gradient? gradient}) {
    return TButtonThemeData(
      iconTextSpacing: iconTextSpacing ?? this.iconTextSpacing,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  TButtonThemeData lerp(ThemeExtension<TButtonThemeData>? other, double t) {
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
