import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 骨架屏样式
class TSkeletonRowColStyle {
  const TSkeletonRowColStyle({
    this.rowSpacing = _defaultRowSpacing,
  });

  /// 行间距
  final double Function(BuildContext) rowSpacing;

  /// 默认行间距
  static double _defaultRowSpacing(BuildContext context) =>
      TTheme.of(context).spacer16;
}

/// 骨架屏行列框架
class TSkeletonRowCol {
  TSkeletonRowCol({
    required this.objects,
    this.style = const TSkeletonRowColStyle(),
  }) : assert(objects.isNotEmpty && objects.every((row) => row.isNotEmpty));

  /// 行列对象
  final List<List<TSkeletonRowColObj>> objects;

  /// 样式
  final TSkeletonRowColStyle style;

  /// 视觉高度
  double visualHeight(BuildContext context) {
    var rowSpacing = style.rowSpacing(context);
    assert(rowSpacing >= 0);
    if (rowSpacing < 0) {
      rowSpacing = 0;
    }

    return objects
            .map((row) =>
                row.fold(.0, (a, b) => a > b.visualHeight ? a : b.visualHeight))
            .fold(.0, (a, b) => a + b) +
        rowSpacing * (objects.length - 1);
  }
}

/// 骨架屏元素样式
class TSkeletonRowColObjStyle {
  const TSkeletonRowColObjStyle({
    this.background = _defaultBackground,
    this.borderRadius = _textBorderRadius,
  });

  /// 圆形
  const TSkeletonRowColObjStyle.circle({this.background = _defaultBackground})
      : borderRadius = _circleBorderRadius;

  /// 矩形
  const TSkeletonRowColObjStyle.rect({this.background = _defaultBackground})
      : borderRadius = _rectBorderRadius;

  /// 文本
  const TSkeletonRowColObjStyle.text({this.background = _defaultBackground})
      : borderRadius = _textBorderRadius;

  /// 空白占位符
  const TSkeletonRowColObjStyle.spacer()
      : background = _transparentBackground,
        borderRadius = _textBorderRadius;

  /// 背景颜色
  final Color Function(BuildContext) background;

  /// 圆角
  final double Function(BuildContext) borderRadius;

  /// 默认背景颜色
  static Color _defaultBackground(BuildContext context) =>
      TTheme.of(context).bgColorComponent;

  /// 透明背景颜色
  static Color _transparentBackground(BuildContext context) =>
      Colors.transparent;

  /// 圆形圆角
  static double _circleBorderRadius(BuildContext context) =>
      TTheme.of(context).radiusCircle;

  /// 矩形圆角
  static double _rectBorderRadius(BuildContext context) =>
      TTheme.of(context).radiusDefault;

  /// 文本圆角
  static double _textBorderRadius(BuildContext context) =>
      TTheme.of(context).radiusSmall;
}

/// 骨架屏元素
class TSkeletonRowColObj {
  const TSkeletonRowColObj({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle(),
  });

  /// 圆形
  const TSkeletonRowColObj.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle.circle(),
  });

  /// 矩形
  const TSkeletonRowColObj.rect({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle.rect(),
  });

  /// 文本
  const TSkeletonRowColObj.text({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TSkeletonRowColObjStyle.text(),
  });

  /// 空白占位符
  const TSkeletonRowColObj.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  }) : style = const TSkeletonRowColObjStyle.spacer();

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 弹性因子
  final int? flex;

  /// 间距
  final EdgeInsets margin;

  /// 样式
  final TSkeletonRowColObjStyle style;

  /// 视觉高度
  double get visualHeight => (height ?? 0) + margin.top + margin.bottom;
}
