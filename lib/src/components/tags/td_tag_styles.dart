import 'package:flutter/material.dart';
import '../../../td_export.dart';

/// 标签样式
class TDTagStyle {
  const TDTagStyle(
      {this.context,
      this.textColor,
      this.backgroundColor,
      this.font,
      this.fontWeight,
      this.border = 0,
      this.wireFrameColor,
      this.borderRadius});

  /// 上下文，方便获取主题内容
  final BuildContext? context;

  /// 文字颜色
  final Color? textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 边框颜色
  final Color? wireFrameColor;

  /// 圆角
  final BorderRadiusGeometry? borderRadius;

  /// 字体尺寸
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 线框粗细
  final double border;

  /// 字体颜色，与属性不同名，方便子类自定义处理
  Color get getTextColor => textColor ?? TDTheme.of(context).fontWhColor1;

  /// 背景颜色，与属性不同名，方便子类自定义处理
  Color get getBackgroundColor =>
      backgroundColor ?? TDTheme.of(context).brandNormalColor;

  /// 线框颜色，与属性不同名，方便子类自定义处理
  Color get getWireFrameColor => Colors.transparent;

  /// 圆角，，与属性不同名，方便子类自定义处理
  BorderRadiusGeometry get getBorderRadius => BorderRadius.circular(0);
}


/// 两端圆弧Style
class CircleRectTagStyle extends TDTagStyle {
  CircleRectTagStyle({
    BuildContext? context,
    Color? textColor,
    Color? backgroundColor,
    Font? font,
    FontWeight? fontWeight,
  }) : super(
    context: context,
    textColor: textColor,
    backgroundColor: backgroundColor,
    font: font,
    fontWeight: fontWeight,
  );

  @override
  BorderRadiusGeometry get getBorderRadius => BorderRadius.circular(1000);
}

/// 右边端圆弧Style
class SemicircleRectTagStyle extends TDTagStyle {
  SemicircleRectTagStyle({
    BuildContext? context,
    Color? textColor,
    Color? backgroundColor,
    Font? font,
    FontWeight? fontWeight,
  }) : super(
    context: context,
    textColor: textColor,
    backgroundColor: backgroundColor,
    font: font,
    fontWeight: fontWeight,
  );

  @override
  BorderRadiusGeometry get getBorderRadius =>
      const BorderRadius.horizontal(right: Radius.circular(1000));
}


/// 描边圆角矩形Style
class WireframeRoundRectTagStyle extends TDTagStyle {
  /// 圆角半径
  final double radius;

  /// 是否为浅色背景
  final bool isLight;

  const WireframeRoundRectTagStyle({
    BuildContext? context,
    Color? textColor,
    Color? backgroundColor,
    Font? font,
    FontWeight? fontWeight,
    Color? wireFrameColor,
    double border = 1,
    this.isLight = false,
    this.radius = 2,
  }) : super(
          context: context,
          textColor: textColor,
          backgroundColor: backgroundColor,
          font: font,
          fontWeight: fontWeight,
          wireFrameColor: wireFrameColor,
          border: border,
        );

  @override
  Color get getBackgroundColor {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    return isLight
        ? TDTheme.of(context).brandColor2
        : TDTheme.of(context).whiteColor1;
  }

  @override
  BorderRadiusGeometry get getBorderRadius => BorderRadius.circular(radius);

  @override
  Color get getTextColor => textColor ?? TDTheme.of(context).brandNormalColor;

  @override
  Color get getWireFrameColor =>
      wireFrameColor ?? TDTheme.of(context).brandNormalColor;
}

/// Tag展示类型
enum TDTagType {
  /// 常规
  normal,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,

  /// 信息
  message,
}

/// 常规圆角矩形Style
class RoundRectTagStyle extends WireframeRoundRectTagStyle {
  /// 展示类型
  final TDTagType type;

  const RoundRectTagStyle(
      {BuildContext? context,
      Color? textColor,
      Color? backgroundColor,
      Font? font,
      FontWeight? fontWeight,
      this.type = TDTagType.normal,
      double radius = 2,
      bool isLight = false})
      : super(
          context: context,
          textColor: textColor,
          backgroundColor: backgroundColor,
          font: font,
          fontWeight: fontWeight,
          radius: radius,
          isLight: isLight,
    border: 0,
        );

  @override
  Color get getBackgroundColor {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    if (isLight) {
      return TDTheme.of(context).brandColor2;
    }
    switch (type) {
      case TDTagType.normal:
        return TDTheme.of(context).brandNormalColor;
      case TDTagType.success:
        return TDTheme.of(context).successNormalColor;
      case TDTagType.warning:
        return TDTheme.of(context).warningNormalColor;
      case TDTagType.error:
        return TDTheme.of(context).errorNormalColor;
      case TDTagType.message:
        return TDTheme.of(context).grayColor7;
      default:
        return TDTheme.of(context).whiteColor1;
    }
  }

  @override
  Color get getTextColor {
    if (textColor != null) {
      return textColor!;
    }
    if (isLight) {
      return TDTheme.of(context).brandNormalColor;
    } else {
      return TDTheme.of(context).fontWhColor1;
    }
  }

  @override
  Color get getWireFrameColor => Colors.transparent;
}
