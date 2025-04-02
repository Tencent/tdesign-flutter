import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';


/// 骨架屏样式
class TDSkeletonRowColStyle {
  const TDSkeletonRowColStyle({
    this.rowSpacing = _defaultRowSpacing,
  });

  /// 行间距
  final double Function(BuildContext) rowSpacing;

  /// 默认行间距
  static double _defaultRowSpacing(BuildContext context) =>
      TDTheme.of(context).spacer16;
}


/// 骨架屏行列框架
class TDSkeletonRowCol {
  TDSkeletonRowCol({
    required this.objects,
    this.style = const TDSkeletonRowColStyle(),
  }) : assert(objects.isNotEmpty && objects.every((row) => row.isNotEmpty));

  /// 行列对象
  final List<List<TDSkeletonRowColObj>> objects;

  /// 样式
  final TDSkeletonRowColStyle style;

  /// 视觉高度
  double visualHeight(BuildContext context) {
    var rowSpacing = style.rowSpacing(context);
    assert (rowSpacing >= 0); 
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
class TDSkeletonRowColObjStyle {
  const TDSkeletonRowColObjStyle({
    this.background = _defaultBackground,
    this.borderRadius = _textBorderRadius,
  });

  /// 圆形
  const TDSkeletonRowColObjStyle.circle({this.background = _defaultBackground})
      : borderRadius = _circleBorderRadius;

  /// 矩形
  const TDSkeletonRowColObjStyle.rect({this.background = _defaultBackground})
      : borderRadius = _rectBorderRadius;

  /// 文本
  const TDSkeletonRowColObjStyle.text({this.background = _defaultBackground})
      : borderRadius = _textBorderRadius;

  /// 空白占位符
  const TDSkeletonRowColObjStyle.spacer()
      : background = _transparentBackground,
        borderRadius = _textBorderRadius;

  /// 背景颜色
  final Color Function(BuildContext) background;

  /// 圆角
  final double Function(BuildContext) borderRadius;

  /// 默认背景颜色
  static Color _defaultBackground(BuildContext context) =>
      TDTheme.of(context).grayColor1;

  /// 透明背景颜色
  static Color _transparentBackground(BuildContext context) =>
      Colors.transparent;

  /// 圆形圆角
  static double _circleBorderRadius(BuildContext context) =>
      TDTheme.of(context).radiusCircle;

  /// 矩形圆角
  static double _rectBorderRadius(BuildContext context) =>
      TDTheme.of(context).radiusDefault;

  /// 文本圆角
  static double _textBorderRadius(BuildContext context) =>
      TDTheme.of(context).radiusSmall;
}


/// 骨架屏元素
class TDSkeletonRowColObj {
  const TDSkeletonRowColObj({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle(),
  });

  /// 圆形
  const TDSkeletonRowColObj.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle.circle(),
  });

  /// 矩形
  const TDSkeletonRowColObj.rect({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle.rect(),
  });

  /// 文本
  const TDSkeletonRowColObj.text({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle.text(),
  });

  /// 空白占位符
  const TDSkeletonRowColObj.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  }) : style = const TDSkeletonRowColObjStyle.spacer();

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 弹性因子
  final int? flex;

  /// 间距
  final EdgeInsets margin;

  /// 样式
  final TDSkeletonRowColObjStyle style;

  /// 视觉高度
  double get visualHeight => (height ?? 0) + margin.top + margin.bottom;
}
