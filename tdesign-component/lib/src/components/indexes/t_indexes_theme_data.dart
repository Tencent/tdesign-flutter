import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font;

/// 索引组件的子树级视觉主题。
///
/// 仅管理尺寸、颜色和字体。吸顶、滚动方向与胶囊模式属于组件实例行为。
class TIndexesThemeData extends ThemeExtension<TIndexesThemeData> {
  const TIndexesThemeData({
    this.indexListMaxHeight,
    this.sidebarRight,
    this.indexItemSize,
    this.indexItemSpacing,
    this.tipSize,
    this.tipMaxWidth,
    this.tipGap,
    this.indexColor,
    this.activeIndexColor,
    this.activeIndexBackgroundColor,
    this.tipColor,
    this.tipBackgroundColor,
    this.indexFont,
    this.activeIndexFont,
    this.tipFont,
    this.anchorColor,
    this.activeAnchorColor,
    this.anchorBackgroundColor,
    this.activeAnchorBackgroundColor,
    this.anchorBorderColor,
    this.anchorFont,
    this.activeAnchorFont,
    this.anchorVerticalPadding,
    this.anchorHorizontalPadding,
    this.capsuleMargin,
  }) : assert(
         indexListMaxHeight == null ||
             indexListMaxHeight > 0 && indexListMaxHeight <= 1,
       ),
       assert(indexItemSize == null || indexItemSize > 0),
       assert(indexItemSpacing == null || indexItemSpacing >= 0),
       assert(tipSize == null || tipSize > 0),
       assert(tipMaxWidth == null || tipSize == null || tipMaxWidth >= tipSize);

  /// 索引列表最大高度占父容器高度的比例。
  final double? indexListMaxHeight;

  /// 侧栏距容器右侧的距离。
  final double? sidebarRight;

  /// 单个索引的尺寸。
  final double? indexItemSize;

  /// 相邻索引之间的距离。
  final double? indexItemSpacing;

  /// 按压提示的最小尺寸。
  final double? tipSize;

  /// 按压提示的最大宽度。
  final double? tipMaxWidth;

  /// 按压提示与索引之间的距离。
  final double? tipGap;

  /// 普通索引文字颜色。
  final Color? indexColor;

  /// 激活索引文字颜色。
  final Color? activeIndexColor;

  /// 激活索引背景色。
  final Color? activeIndexBackgroundColor;

  /// 按压提示文字颜色。
  final Color? tipColor;

  /// 按压提示背景色。
  final Color? tipBackgroundColor;

  /// 普通索引字体。
  final Font? indexFont;

  /// 激活索引字体。
  final Font? activeIndexFont;

  /// 按压提示字体。
  final Font? tipFont;

  /// 普通锚点文字颜色。
  final Color? anchorColor;

  /// 激活锚点文字颜色。
  final Color? activeAnchorColor;

  /// 普通锚点背景色。
  final Color? anchorBackgroundColor;

  /// 激活锚点背景色。
  final Color? activeAnchorBackgroundColor;

  /// 激活锚点边框颜色。
  final Color? anchorBorderColor;

  /// 普通锚点字体。
  final Font? anchorFont;

  /// 激活锚点字体。
  final Font? activeAnchorFont;

  /// 锚点垂直内边距。
  final double? anchorVerticalPadding;

  /// 锚点水平内边距。
  final double? anchorHorizontalPadding;

  /// 胶囊锚点的水平外边距。
  final double? capsuleMargin;

  @override
  TIndexesThemeData copyWith({
    double? indexListMaxHeight,
    double? sidebarRight,
    double? indexItemSize,
    double? indexItemSpacing,
    double? tipSize,
    double? tipMaxWidth,
    double? tipGap,
    Color? indexColor,
    Color? activeIndexColor,
    Color? activeIndexBackgroundColor,
    Color? tipColor,
    Color? tipBackgroundColor,
    Font? indexFont,
    Font? activeIndexFont,
    Font? tipFont,
    Color? anchorColor,
    Color? activeAnchorColor,
    Color? anchorBackgroundColor,
    Color? activeAnchorBackgroundColor,
    Color? anchorBorderColor,
    Font? anchorFont,
    Font? activeAnchorFont,
    double? anchorVerticalPadding,
    double? anchorHorizontalPadding,
    double? capsuleMargin,
  }) {
    return TIndexesThemeData(
      indexListMaxHeight: indexListMaxHeight ?? this.indexListMaxHeight,
      sidebarRight: sidebarRight ?? this.sidebarRight,
      indexItemSize: indexItemSize ?? this.indexItemSize,
      indexItemSpacing: indexItemSpacing ?? this.indexItemSpacing,
      tipSize: tipSize ?? this.tipSize,
      tipMaxWidth: tipMaxWidth ?? this.tipMaxWidth,
      tipGap: tipGap ?? this.tipGap,
      indexColor: indexColor ?? this.indexColor,
      activeIndexColor: activeIndexColor ?? this.activeIndexColor,
      activeIndexBackgroundColor:
          activeIndexBackgroundColor ?? this.activeIndexBackgroundColor,
      tipColor: tipColor ?? this.tipColor,
      tipBackgroundColor: tipBackgroundColor ?? this.tipBackgroundColor,
      indexFont: indexFont ?? this.indexFont,
      activeIndexFont: activeIndexFont ?? this.activeIndexFont,
      tipFont: tipFont ?? this.tipFont,
      anchorColor: anchorColor ?? this.anchorColor,
      activeAnchorColor: activeAnchorColor ?? this.activeAnchorColor,
      anchorBackgroundColor:
          anchorBackgroundColor ?? this.anchorBackgroundColor,
      activeAnchorBackgroundColor:
          activeAnchorBackgroundColor ?? this.activeAnchorBackgroundColor,
      anchorBorderColor: anchorBorderColor ?? this.anchorBorderColor,
      anchorFont: anchorFont ?? this.anchorFont,
      activeAnchorFont: activeAnchorFont ?? this.activeAnchorFont,
      anchorVerticalPadding:
          anchorVerticalPadding ?? this.anchorVerticalPadding,
      anchorHorizontalPadding:
          anchorHorizontalPadding ?? this.anchorHorizontalPadding,
      capsuleMargin: capsuleMargin ?? this.capsuleMargin,
    );
  }

  @override
  TIndexesThemeData lerp(ThemeExtension<TIndexesThemeData>? other, double t) {
    if (other is! TIndexesThemeData) {
      return this;
    }
    return TIndexesThemeData(
      indexListMaxHeight: lerpDouble(
        indexListMaxHeight,
        other.indexListMaxHeight,
        t,
      ),
      sidebarRight: lerpDouble(sidebarRight, other.sidebarRight, t),
      indexItemSize: lerpDouble(indexItemSize, other.indexItemSize, t),
      indexItemSpacing: lerpDouble(indexItemSpacing, other.indexItemSpacing, t),
      tipSize: lerpDouble(tipSize, other.tipSize, t),
      tipMaxWidth: lerpDouble(tipMaxWidth, other.tipMaxWidth, t),
      tipGap: lerpDouble(tipGap, other.tipGap, t),
      indexColor: Color.lerp(indexColor, other.indexColor, t),
      activeIndexColor: Color.lerp(activeIndexColor, other.activeIndexColor, t),
      activeIndexBackgroundColor: Color.lerp(
        activeIndexBackgroundColor,
        other.activeIndexBackgroundColor,
        t,
      ),
      tipColor: Color.lerp(tipColor, other.tipColor, t),
      tipBackgroundColor: Color.lerp(
        tipBackgroundColor,
        other.tipBackgroundColor,
        t,
      ),
      indexFont: t < 0.5 ? indexFont : other.indexFont,
      activeIndexFont: t < 0.5 ? activeIndexFont : other.activeIndexFont,
      tipFont: t < 0.5 ? tipFont : other.tipFont,
      anchorColor: Color.lerp(anchorColor, other.anchorColor, t),
      activeAnchorColor: Color.lerp(
        activeAnchorColor,
        other.activeAnchorColor,
        t,
      ),
      anchorBackgroundColor: Color.lerp(
        anchorBackgroundColor,
        other.anchorBackgroundColor,
        t,
      ),
      activeAnchorBackgroundColor: Color.lerp(
        activeAnchorBackgroundColor,
        other.activeAnchorBackgroundColor,
        t,
      ),
      anchorBorderColor: Color.lerp(
        anchorBorderColor,
        other.anchorBorderColor,
        t,
      ),
      anchorFont: t < 0.5 ? anchorFont : other.anchorFont,
      activeAnchorFont: t < 0.5 ? activeAnchorFont : other.activeAnchorFont,
      anchorVerticalPadding: lerpDouble(
        anchorVerticalPadding,
        other.anchorVerticalPadding,
        t,
      ),
      anchorHorizontalPadding: lerpDouble(
        anchorHorizontalPadding,
        other.anchorHorizontalPadding,
        t,
      ),
      capsuleMargin: lerpDouble(capsuleMargin, other.capsuleMargin, t),
    );
  }
}
