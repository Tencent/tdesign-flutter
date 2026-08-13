import 'package:flutter/material.dart';

import '../loading/t_loading.dart' show TLoadingIcon;

/// TRefreshHeader 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的下拉刷新默认样式。
class TRefreshThemeData extends ThemeExtension<TRefreshThemeData> {
  /// loading 样式
  final TLoadingIcon? loadingIcon;

  /// loading 图标颜色
  final Color? loadingIconColor;

  /// loading 文案颜色
  final Color? loadingTextColor;

  /// 背景颜色
  final Color? backgroundColor;

  const TRefreshThemeData({
    this.loadingIcon,
    this.loadingIconColor,
    this.loadingTextColor,
    this.backgroundColor,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TRefreshThemeData merge(TRefreshThemeData? other) {
    if (other == null) {
      return this;
    }
    return TRefreshThemeData(
      loadingIcon: other.loadingIcon ?? loadingIcon,
      loadingIconColor: other.loadingIconColor ?? loadingIconColor,
      loadingTextColor: other.loadingTextColor ?? loadingTextColor,
      backgroundColor: other.backgroundColor ?? backgroundColor,
    );
  }

  @override
  TRefreshThemeData copyWith({
    TLoadingIcon? loadingIcon,
    Color? loadingIconColor,
    Color? loadingTextColor,
    Color? backgroundColor,
  }) {
    return TRefreshThemeData(
      loadingIcon: loadingIcon ?? this.loadingIcon,
      loadingIconColor: loadingIconColor ?? this.loadingIconColor,
      loadingTextColor: loadingTextColor ?? this.loadingTextColor,
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
      loadingIconColor: Color.lerp(loadingIconColor, other.loadingIconColor, t),
      loadingTextColor: Color.lerp(loadingTextColor, other.loadingTextColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
    );
  }
}
