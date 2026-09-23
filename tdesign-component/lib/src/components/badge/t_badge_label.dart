import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Badge 包内部使用的预设标签形状。
///
/// 该类型不导出到组件公共 API；TBadge 负责把公开的 variant 映射到这里。
@internal
enum TBadgeLabelShape { circle, dot, square, bubble }

/// 渲染 TDesign 自有几何的徽标标签。
///
/// Material [Badge] 只负责标准圆形与圆点的外层容器。square、bubble 必须直接
/// 渲染该 Widget，避免 Material [Badge] 固定的 [StadiumBorder] 再次裁剪形状。
@internal
class TBadgeLabel extends StatelessWidget {
  const TBadgeLabel({
    super.key,
    required this.shape,
    required this.visible,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.height,
    required this.dotSize,
  });

  static const double squareRadius = 2;
  static const double bubbleRadius = 10;
  static const double bubbleSharpRadius = 1;

  final TBadgeLabelShape shape;
  final bool visible;
  final Widget? label;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final double height;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final isDot = shape == TBadgeLabelShape.dot;
    final minHeight = isDot ? dotSize : height;
    final minWidth = switch (shape) {
      TBadgeLabelShape.bubble => 0.0,
      TBadgeLabelShape.dot => dotSize,
      _ => height,
    };
    final borderRadius = switch (shape) {
      TBadgeLabelShape.square => BorderRadius.circular(squareRadius),
      TBadgeLabelShape.bubble => const BorderRadius.only(
        topLeft: Radius.circular(bubbleRadius),
        topRight: Radius.circular(bubbleRadius),
        bottomRight: Radius.circular(bubbleRadius),
        bottomLeft: Radius.circular(bubbleSharpRadius),
      ),
      _ => BorderRadius.circular(999),
    };

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderWidth > 0
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: isDot ? EdgeInsets.zero : padding,
          child: Align(
            widthFactor: 1,
            heightFactor: 1,
            child: isDot ? null : label,
          ),
        ),
      ),
    );
  }
}
