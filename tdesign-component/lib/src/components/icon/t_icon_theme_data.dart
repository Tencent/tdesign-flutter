import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TIcon 组件级 ThemeExtension
///
/// 通过 Material Theme 子树注入，控制 `TIcon` 的默认尺寸和颜色。
/// 未配置的字段继续回退显式 [IconTheme] 和 TDesign Token，不会覆盖其它组件主题。
/// `TIcon` 构造器参数始终具有最高优先级。
class TIconThemeData extends ThemeExtension<TIconThemeData> {
  /// 图标默认尺寸，单位为逻辑像素；为空时回退显式 [IconTheme]。
  final double? size;

  /// 图标默认颜色；为空时回退显式 [IconTheme]，最终回退 `textColorPrimary` Token。
  final Color? color;

  const TIconThemeData({this.size, this.color});

  @override
  TIconThemeData copyWith({double? size, Color? color}) {
    return TIconThemeData(size: size ?? this.size, color: color ?? this.color);
  }

  @override
  TIconThemeData lerp(ThemeExtension<TIconThemeData>? other, double t) {
    if (other is! TIconThemeData) {
      return this;
    }
    return TIconThemeData(
      size: lerpDouble(size, other.size, t),
      color: Color.lerp(color, other.color, t),
    );
  }
}
