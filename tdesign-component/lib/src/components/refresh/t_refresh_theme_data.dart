import 'package:flutter/material.dart';

import '../loading/t_loading.dart' show TLoadingIcon;

/// TRefreshHeader 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的下拉刷新默认样式。
class TRefreshThemeData extends ThemeExtension<TRefreshThemeData> {
  /// loading 样式
  final TLoadingIcon? loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

  const TRefreshThemeData({
    this.loadingIcon,
    this.backgroundColor,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TRefreshThemeData merge(TRefreshThemeData? other) {
    if (other == null) {
      return this;
    }
    return TRefreshThemeData(
      loadingIcon: other.loadingIcon ?? loadingIcon,
      backgroundColor: other.backgroundColor ?? backgroundColor,
    );
  }

  @override
  TRefreshThemeData copyWith({
    TLoadingIcon? loadingIcon,
    Color? backgroundColor,
  }) {
    return TRefreshThemeData(
      loadingIcon: loadingIcon ?? this.loadingIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  TRefreshThemeData lerp(ThemeExtension<TRefreshThemeData>? other, double t) {
    if (other is! TRefreshThemeData) {
      return this;
    }
    return TRefreshThemeData(
      loadingIcon: t < 0.5 ? loadingIcon : other.loadingIcon,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
