import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'dashed_widget.dart';

enum TextAlignment { left, center, right }

/// 分割线
/// 对于非flutter原有的控件，则只需满足TDesign规范即可；
/// 如果有业务在实际使用，还需兼容实际业务场景。
class TDDivider extends StatelessWidget {
  const TDDivider({
    Key? key,
    this.color,
    this.margin,
    this.width,
    this.height = 0.5,
    this.text,
    this.textStyle,
    this.widget,
    this.gapPadding,
    this.hideLine = false,
    this.isDashed = false,
    this.alignment = TextAlignment.center,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  /// 线条颜色
  final Color? color;

  /// 文字位置
  final TextAlignment alignment;

  /// 外部填充
  final EdgeInsetsGeometry? margin;

  /// 线条和中间文本之间的填充
  final EdgeInsetsGeometry? gapPadding;

  /// 宽度，需要竖向线条时使用
  final double? width;

  /// 高度，横向线条使用
  final double height;

  /// 文本字符串，使用默认样式
  final String? text;

  /// 自定义文本样式
  final TextStyle? textStyle;

  /// 中间控件，可自定义样式
  final Widget? widget;

  /// 隐藏线条，使用纯文本分割
  final bool hideLine;

  /// 是否为虚线
  final bool isDashed;

  /// 方向，竖直虚线必须传
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    // 普通直线
    if (widget == null && text == null) {
      return _buildLine(context, width: width, margin: margin);
    }

    // 隐藏线条，纯文本分割
    if (hideLine) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        child: _buildMiddleWidget(context),
      );
    }

    // 文本 + 线条
    return _buildDivider(context, alignment);
  }

  Widget _buildDivider(BuildContext context, TextAlignment alignment) {
    final middleWidget = Padding(
        padding: gapPadding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: _buildMiddleWidget(context));

    final line = Expanded(child: Center(child: _buildLine(context)));

    final lineWithWidth = _buildLine(context, width: 16);

    List<Widget> children;

    switch (alignment) {
      case TextAlignment.left:
        children = [lineWithWidth, middleWidget, line];
        break;
      case TextAlignment.center:
        children = [line, middleWidget, line];
        break;
      case TextAlignment.right:
        children = [line, middleWidget, lineWithWidth];
        break;
    }

    return Container(
      width: width,
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  /// 绘制线条
  Container _buildLine(BuildContext context,
      {double? width, EdgeInsetsGeometry? margin}) {
    final lineColor = color ?? TDTheme.of(context).componentStrokeColor;

    if (isDashed) {
      return Container(
        width: width,
        margin: margin,
        child: DashedWidget(
          width: width,
          height: height,
          color: lineColor,
          direction: direction,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      color: lineColor,
    );
  }

  /// 构建中间控件
  Widget _buildMiddleWidget(BuildContext context) {
    return widget ??
        TDText(
          text,
          font: TDTheme.of(context).fontBodySmall,
          textColor: TDTheme.of(context).textColorPlaceholder,
          forceVerticalCenter: true,
          style: textStyle,
        );
  }
}
