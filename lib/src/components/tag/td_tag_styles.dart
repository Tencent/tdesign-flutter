import 'package:flutter/material.dart';
import '../../../td_export.dart';

/// 标签样式
class TDTagStyle {
  TDTagStyle(
      {this.context,
      this.textColor,
      this.backgroundColor,
      this.font,
      this.fontWeight,
      this.border = 0,
      this.borderColor,
      this.borderRadius});

  /// 上下文，方便获取主题内容
  BuildContext? context;

  /// 文字颜色
  Color? textColor;

  /// 背景颜色
  Color? backgroundColor;

  /// 边框颜色
  Color? borderColor;

  /// 圆角
  BorderRadiusGeometry? borderRadius;

  /// 字体尺寸
  Font? font;

  /// 字体粗细
  FontWeight? fontWeight;

  /// 线框粗细
  double border = 0;

  /// 字体颜色，与属性不同名，方便子类自定义处理
  Color get getTextColor => textColor ?? TDTheme.of(context).fontWhColor1;

  /// 背景颜色，与属性不同名，方便子类自定义处理
  Color get getBackgroundColor =>
      backgroundColor ?? TDTheme.of(context).brandNormalColor;

  /// 线框颜色，与属性不同名，方便子类自定义处理
  Color get getBorderColor => borderColor ?? Colors.transparent;

  /// 圆角，，与属性不同名，方便子类自定义处理
  BorderRadiusGeometry get getBorderRadius =>
      borderRadius ?? BorderRadius.circular(0);

  TDTagStyle.generateFillStyleByTheme(
      BuildContext context, TDTagTheme? theme, bool light, bool isCircle) {
    this.context = context;
    switch (theme) {
      case TDTagTheme.primary:
        textColor = light
            ? TDTheme.of(context).brandNormalColor
            : TDTheme.of(context).whiteColor1;
        backgroundColor = light
            ? TDTheme.of(context).brandLightColor
            : TDTheme.of(context).brandNormalColor;
        break;
      case TDTagTheme.warning:
        textColor = light
            ? TDTheme.of(context).warningNormalColor
            : TDTheme.of(context).whiteColor1;
        backgroundColor = light
            ? TDTheme.of(context).warningLightColor
            : TDTheme.of(context).warningNormalColor;
        break;
      case TDTagTheme.danger:
        textColor = light
            ? TDTheme.of(context).errorNormalColor
            : TDTheme.of(context).whiteColor1;
        backgroundColor = light
            ? TDTheme.of(context).errorLightColor
            : TDTheme.of(context).errorNormalColor;
        break;
      case TDTagTheme.success:
        textColor = light
            ? TDTheme.of(context).successNormalColor
            : TDTheme.of(context).whiteColor1;
        backgroundColor = light
            ? TDTheme.of(context).successLightColor
            : TDTheme.of(context).successNormalColor;
        break;
      case TDTagTheme.defaultTheme:
      default:
        textColor = TDTheme.of(context).fontGyColor1;
        backgroundColor = light
            ? TDTheme.of(context).grayColor1
            : TDTheme.of(context).grayColor3;
    }
    borderRadius = BorderRadius.circular(isCircle
        ? TDTheme.of(context).radiusRound
        : TDTheme.of(context).radiusSmall);
    borderColor = backgroundColor;
  }

  TDTagStyle.generateStrokeStyleByTheme(
      BuildContext context, TDTagTheme? theme, bool light, bool isCircle) {
    this.context = context;
    switch (theme) {
      case TDTagTheme.primary:
        borderColor = TDTheme.of(context).brandNormalColor;
        textColor = TDTheme.of(context).brandNormalColor;
        backgroundColor = light
            ? TDTheme.of(context).brandLightColor
            : TDTheme.of(context).whiteColor1;
        break;
      case TDTagTheme.warning:
        borderColor = TDTheme.of(context).warningNormalColor;
        textColor = TDTheme.of(context).warningNormalColor;
        backgroundColor = light
            ? TDTheme.of(context).warningLightColor
            : TDTheme.of(context).whiteColor1;
        break;
      case TDTagTheme.danger:
        borderColor = TDTheme.of(context).errorNormalColor;
        textColor = TDTheme.of(context).errorNormalColor;
        backgroundColor = light
            ? TDTheme.of(context).errorLightColor
            : TDTheme.of(context).whiteColor1;
        break;
      case TDTagTheme.success:
        borderColor = TDTheme.of(context).successNormalColor;
        textColor = TDTheme.of(context).successNormalColor;
        backgroundColor = light
            ? TDTheme.of(context).successLightColor
            : TDTheme.of(context).whiteColor1;
        break;
      case TDTagTheme.defaultTheme:
      default:
        borderColor = TDTheme.of(context).fontGyColor4;
        textColor = TDTheme.of(context).fontGyColor1;
        backgroundColor = light
            ? TDTheme.of(context).grayColor1
            : TDTheme.of(context).whiteColor1;
    }
    borderRadius = BorderRadius.circular(isCircle
        ? TDTheme.of(context).radiusRound
        : TDTheme.of(context).radiusSmall);
    border = 1;
  }
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
class StrokeRoundRectTagStyle extends TDTagStyle {
  /// 圆角半径
  final double radius;

  /// 是否为浅色背景
  final bool isLight;

  StrokeRoundRectTagStyle({
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
          borderColor: wireFrameColor,
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
  Color get getBorderColor =>
      borderColor ?? TDTheme.of(context).brandNormalColor;
}

/// 常规圆角矩形Style
class RoundRectTagStyle extends StrokeRoundRectTagStyle {
  /// 展示类型
  final TDTagTheme type;

  RoundRectTagStyle(
      {BuildContext? context,
      Color? textColor,
      Color? backgroundColor,
      Font? font,
      FontWeight? fontWeight,
      this.type = TDTagTheme.defaultTheme,
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
      case TDTagTheme.primary:
        return TDTheme.of(context).brandNormalColor;
      case TDTagTheme.success:
        return TDTheme.of(context).successNormalColor;
      case TDTagTheme.warning:
        return TDTheme.of(context).warningNormalColor;
      case TDTagTheme.danger:
        return TDTheme.of(context).errorNormalColor;
      case TDTagTheme.defaultTheme:
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
  Color get getBorderColor => Colors.transparent;
}
