import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'dashed_widget.dart';

enum TextAlignment {
  left,
  center,
  right
}

/// 分割线
/// 对于非flutter原有的控件，则只需满足TDesign规范即可；
/// 如果有业务在实际使用，还需兼容实际业务场景。
class TDDivider extends StatelessWidget {
  const TDDivider({
    Key? key,
    this.color,
    this.margin,
    this.width,
    this.height,
    this.text,
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
  final double? height;

  /// 文本字符串，使用默认样式
  final String? text;

  /// 中间控件，可自定义样式
  final Widget? widget;

  /// 隐藏线条，使用纯文本分割
  final bool hideLine;

  /// 是否为虚线
  final bool isDashed;

  /// 方向,竖直虚线必须传
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    // 普通直线
    if (widget == null && text == null) {
      return _buildLine(context,
          width: width, height: height, margin: margin, color: color);
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

    // 文本+线条
    return _buildDivider(context, alignment);
  }

  Widget _buildDivider(BuildContext context, TextAlignment alignment) {
    switch(alignment) {
      case TextAlignment.left:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLine(
                context,
                width: 16,
                height: height ?? 0.5,
                color: color ?? TDTheme.of(context).grayColor3,
              ),
              Padding(
                  padding: gapPadding ?? const EdgeInsets.only(left: 8, right: 8),
                  child: _buildMiddleWidget(context)),
              Expanded(
                  child: Center(
                      child: _buildLine(
                        context,
                        height: height ?? 0.5,
                        color: color ?? TDTheme.of(context).grayColor3,
                      ))),
            ],
          ),
        );
      case TextAlignment.center:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                    child: _buildLine(
                      context,
                      height: height ?? 0.5,
                      color: color ?? TDTheme.of(context).grayColor3,
                    ),
                  )),
              Padding(
                  padding: gapPadding ?? const EdgeInsets.only(left: 8, right: 8),
                  child: _buildMiddleWidget(context)),
              Expanded(
                  child: Center(
                      child: _buildLine(
                        context,
                        height: height ?? 0.5,
                        color: color ?? TDTheme.of(context).grayColor3,
                      ))),
            ],
          ),
        );
      case TextAlignment.right:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                    child: _buildLine(
                      context,
                      height: height ?? 0.5,
                      color: color ?? TDTheme.of(context).grayColor3,
                    ),
                  )),
              Padding(
                  padding: gapPadding ?? const EdgeInsets.only(left: 8, right: 8),
                  child: _buildMiddleWidget(context)),
              _buildLine(
                context,
                width: 16,
                height: height ?? 0.5,
                color: color ?? TDTheme.of(context).grayColor3,
              ),
            ],
          ),
        );
    }
  }

  /// 绘制线条
  Container _buildLine(BuildContext context,
      {double? width,
      double? height,
      EdgeInsetsGeometry? margin,
      Color? color}) {
    if (isDashed) {
      return Container(
        width: width,
        margin: margin,
        child: DashedWidget(
          width: width,
          height: height,
          color: color ?? TDTheme.of(context).grayColor3,
          direction: direction,
        ),
      );
    } else {
      return Container(
        width: width,
        height: height ?? 0.5,
        margin: margin,
        color: color ?? TDTheme.of(context).grayColor3,
      );
    }
  }

  /// 构建中间控件
  Widget _buildMiddleWidget(BuildContext context) {
    return widget ??
        TDText(
          text,
          font: TDTheme.of(context).fontBodySmall,
          textColor: TDTheme.of(context).fontGyColor3,
          forceVerticalCenter: true,
        );
  }
}
