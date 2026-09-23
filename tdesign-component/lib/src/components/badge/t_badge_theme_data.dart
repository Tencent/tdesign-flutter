import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_badge_defaults.dart';

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
      // null 表示依赖当前上下文的容器背景色，不能把它当作透明色参与
      // 插值；在动画中点切换配置，才能保留两端各自的运行时回退语义。
      borderColor: _lerpContextualColor(borderColor, other.borderColor, t),
      borderWidth: _lerpBorderWidth(borderWidth, other.borderWidth, t),
    );
  }

  static Color? _lerpContextualColor(Color? begin, Color? end, double t) {
    if (begin == null || end == null) {
      return t < 0.5 ? begin : end;
    }
    return Color.lerp(begin, end, t);
  }

  static double? _lerpBorderWidth(double? begin, double? end, double t) {
    if (begin == null && end == null) {
      return null;
    }
    return lerpDouble(
      begin ?? TBadgeDefaults.borderWidth,
      end ?? TBadgeDefaults.borderWidth,
      t,
    );
  }
}
