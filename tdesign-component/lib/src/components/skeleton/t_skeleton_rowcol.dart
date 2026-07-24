import 'package:flutter/material.dart';

/// 骨架块形状。
enum TSkeletonBlockShape {
  /// 读取 Theme 默认圆角。
  rounded,

  /// 圆形。
  circle,

  /// 无圆角矩形。
  square,
}

/// 骨架屏行布局样式。
class TSkeletonRowColStyle {
  const TSkeletonRowColStyle({this.rowSpacing});

  /// 行间距；未设置时读取 Theme 和 Token。
  final double? rowSpacing;
}

/// 骨架屏行列布局。
class TSkeletonRowCol {
  TSkeletonRowCol({
    required this.objects,
    this.style = const TSkeletonRowColStyle(),
  }) : assert(objects.isNotEmpty && objects.every((row) => row.isNotEmpty));

  /// 行列对象。
  final List<List<TSkeletonRowColObj>> objects;

  /// 行布局样式。
  final TSkeletonRowColStyle style;

  /// 根据指定行间距计算视觉高度。
  double visualHeight(double rowSpacing) {
    assert(rowSpacing >= 0);
    final spacing = rowSpacing < 0 ? 0.0 : rowSpacing;
    return objects
            .map((row) => row.fold(
                0.0,
                (height, object) => height > object.visualHeight
                    ? height
                    : object.visualHeight))
            .fold(0.0, (height, rowHeight) => height + rowHeight) +
        spacing * (objects.length - 1);
  }
}

/// 单个骨架块的视觉样式。
class TSkeletonRowColObjStyle {
  const TSkeletonRowColObjStyle({
    this.backgroundColor,
    this.borderRadius,
    this.shape = TSkeletonBlockShape.rounded,
  });

  /// 圆形块样式。
  const TSkeletonRowColObjStyle.circle({this.backgroundColor})
      : borderRadius = null,
        shape = TSkeletonBlockShape.circle;

  /// 无圆角矩形块样式。
  const TSkeletonRowColObjStyle.rect({this.backgroundColor})
      : borderRadius = null,
        shape = TSkeletonBlockShape.square;

  /// 文本块样式。
  const TSkeletonRowColObjStyle.text({
    this.backgroundColor,
    this.borderRadius,
  }) : shape = TSkeletonBlockShape.rounded;

  /// 背景颜色；未设置时读取 Theme 和 Token。
  final Color? backgroundColor;

  /// 自定义圆角；优先于 [shape] 和 Theme。
  final double? borderRadius;

  /// 骨架块形状。
  final TSkeletonBlockShape shape;
}

/// 骨架屏元素。
class TSkeletonRowColObj {
  const TSkeletonRowColObj({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle(),
    this.isSpacer = false,
  });

  /// 圆形元素。
  const TSkeletonRowColObj.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle.circle(),
  }) : isSpacer = false;

  /// 无圆角矩形元素。
  const TSkeletonRowColObj.rect({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle.rect(),
  }) : isSpacer = false;

  /// 文本元素。
  const TSkeletonRowColObj.text({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle.text(),
  }) : isSpacer = false;

  /// 透明占位元素。
  const TSkeletonRowColObj.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  })  : style = const TSkeletonRowColObjStyle.rect(),
        isSpacer = true;

  /// 宽度。
  final double? width;

  /// 高度。
  final double? height;

  /// 弹性因子。
  final int? flex;

  /// 外边距。
  final EdgeInsets margin;

  /// 视觉样式。
  final TSkeletonRowColObjStyle style;

  /// 是否为透明占位元素。
  final bool isSpacer;

  /// 包含垂直外边距的视觉高度。
  double get visualHeight => (height ?? 0) + margin.top + margin.bottom;
}
