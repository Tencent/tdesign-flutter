import 'package:flutter/material.dart';

/// 索引组件 ThemeExtension
///
/// 管理 TIndexes 的子树级默认样式（吸顶、偏移、胶囊样式等）。
/// 构造器参数优先级高于 ThemeData。
class TIndexesThemeData extends ThemeExtension<TIndexesThemeData> {
  /// 默认锚点是否吸顶
  final bool? sticky;

  /// 默认锚点吸顶时与顶部的距离
  final double? stickyOffset;

  /// 默认锚点是否为胶囊式样式
  final bool? capsuleTheme;

  /// 默认反方向滚动置顶
  final bool? reverse;

  /// 默认索引列表最大高度（父容器高度的百分比）
  final double? indexListMaxHeight;

  const TIndexesThemeData({
    this.sticky,
    this.stickyOffset,
    this.capsuleTheme,
    this.reverse,
    this.indexListMaxHeight,
  });

  @override
  TIndexesThemeData copyWith({
    bool? sticky,
    double? stickyOffset,
    bool? capsuleTheme,
    bool? reverse,
    double? indexListMaxHeight,
  }) {
    return TIndexesThemeData(
      sticky: sticky ?? this.sticky,
      stickyOffset: stickyOffset ?? this.stickyOffset,
      capsuleTheme: capsuleTheme ?? this.capsuleTheme,
      reverse: reverse ?? this.reverse,
      indexListMaxHeight: indexListMaxHeight ?? this.indexListMaxHeight,
    );
  }

  @override
  TIndexesThemeData lerp(ThemeExtension<TIndexesThemeData>? other, double t) {
    if (other is! TIndexesThemeData) {
      return this;
    }
    return TIndexesThemeData(
      sticky: t < 0.5 ? sticky : other.sticky,
      stickyOffset:
          (stickyOffset ?? 0) * (1 - t) + (other.stickyOffset ?? 0) * t,
      capsuleTheme: t < 0.5 ? capsuleTheme : other.capsuleTheme,
      reverse: t < 0.5 ? reverse : other.reverse,
      indexListMaxHeight:
          (indexListMaxHeight ?? 0.8) * (1 - t) + (other.indexListMaxHeight ?? 0.8) * t,
    );
  }
}
