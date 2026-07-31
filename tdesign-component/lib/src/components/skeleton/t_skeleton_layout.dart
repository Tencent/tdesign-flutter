import 'package:flutter/material.dart';

/// 骨架块形状。
enum TSkeletonBlockShape {
  /// 使用组件主题或 TDesign token 提供的圆角。
  rounded,

  /// 圆形或胶囊形。
  circle,

  /// 无圆角矩形。
  rectangle,
}

/// 骨架屏的行列布局。
class TSkeletonLayout {
  const TSkeletonLayout({
    required this.rows,
    this.rowSpacing,
  });

  /// 每个内层列表表示一行骨架块。
  final List<List<TSkeletonBlock>> rows;

  /// 行间距；未设置时读取组件主题和 TDesign token。
  final double? rowSpacing;
}

/// 单个骨架块的视觉样式。
class TSkeletonBlockStyle {
  const TSkeletonBlockStyle({
    this.color,
    this.borderRadius,
    this.shape = TSkeletonBlockShape.rounded,
  });

  /// 骨架块颜色；优先于组件主题。
  final Color? color;

  /// 骨架块圆角；优先于 [shape] 和组件主题。
  final double? borderRadius;

  /// 骨架块形状。
  final TSkeletonBlockShape shape;
}

/// 骨架屏中的一个占位块。
class TSkeletonBlock {
  const TSkeletonBlock({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonBlockStyle(),
  }) : isSpacer = false;

  /// 文本行占位块。
  const TSkeletonBlock.line({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonBlockStyle(),
  }) : isSpacer = false;

  /// 圆形占位块。
  const TSkeletonBlock.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonBlockStyle(shape: TSkeletonBlockShape.circle),
  }) : isSpacer = false;

  /// 无圆角矩形占位块。
  const TSkeletonBlock.rectangle({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style =
        const TSkeletonBlockStyle(shape: TSkeletonBlockShape.rectangle),
  }) : isSpacer = false;

  /// 透明间隔块。
  const TSkeletonBlock.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  })  : style = const TSkeletonBlockStyle(
          shape: TSkeletonBlockShape.rectangle,
        ),
        isSpacer = true;

  /// 宽度。
  final double? width;

  /// 高度。
  final double? height;

  /// 同一行内的弹性因子；为 null 时按固定宽度布局。
  final int? flex;

  /// 外边距。
  final EdgeInsets margin;

  /// 视觉样式。
  final TSkeletonBlockStyle style;

  /// 是否是透明间隔块。
  final bool isSpacer;
}
