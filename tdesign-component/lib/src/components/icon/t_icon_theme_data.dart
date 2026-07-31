import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TIcon 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认图标尺寸和颜色。
/// 构造器参数优先于 Theme（构造器 > TIconThemeData > IconTheme）。
class TIconThemeData extends ThemeExtension<TIconThemeData> {
  /// 图标默认尺寸（null 时回退 [IconTheme.of]）
  final double? size;

  /// 图标默认颜色（null 时回退 [IconTheme.of]）
  final Color? color;

  const TIconThemeData({this.size, this.color});

  @override
  TIconThemeData copyWith({double? size, Color? color}) {
    return TIconThemeData(
      size: size ?? this.size,
      color: color ?? this.color,
    );
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
