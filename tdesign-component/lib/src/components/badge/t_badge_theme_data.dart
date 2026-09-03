import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Material [BadgeThemeData] 未覆盖的 TDesign 徽标视觉默认值。
///
/// 只保存描边的视觉默认值，不保存形态、尺寸、内容或交互状态。
@immutable
class TBadgeThemeData extends ThemeExtension<TBadgeThemeData> {
  const TBadgeThemeData({this.borderColor, this.borderWidth});

  /// 开启描边时使用的颜色；为空时回退到当前容器背景色。
  final Color? borderColor;

  /// 开启描边时使用的宽度；为空时使用 1 逻辑像素。
  final double? borderWidth;

  @override
  TBadgeThemeData copyWith({Color? borderColor, double? borderWidth}) {
    return TBadgeThemeData(
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  TBadgeThemeData lerp(ThemeExtension<TBadgeThemeData>? other, double t) {
    if (other is! TBadgeThemeData) {
      return this;
    }
    return TBadgeThemeData(
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
    );
  }
}
