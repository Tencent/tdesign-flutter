import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// Tag展示类型
enum TDTagTheme {
  /// 默认
  defaultTheme,

  /// 常规
  primary,

  /// 警告
  warning,

  /// 危险
  danger,

  /// 成功
  success,
}

/// 标签尺寸
enum TDTagSize { extraLarge, large, medium, small, custom }

/// 标签形状
enum TDTagShape { square, round, mark }

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

  /// 根据主题生成填充Tag样式
  TDTagStyle.generateFillStyleByTheme(
      BuildContext context, TDTagTheme? theme, bool light, TDTagShape shape) {
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
    switch(shape){
      case TDTagShape.square:
        borderRadius = BorderRadius.circular(TDTheme.of(context).radiusSmall);
        break;
      case TDTagShape.round:
        borderRadius = BorderRadius.circular(TDTheme.of(context).radiusRound);
        break;
      case TDTagShape.mark:
        borderRadius = BorderRadius.only(topRight:Radius.circular(TDTheme.of(context).radiusRound),bottomRight: Radius.circular(TDTheme.of(context).radiusRound));
        break;
    }
    borderColor = backgroundColor;
  }

  /// 根据主题生成描边Tag样式
  TDTagStyle.generateOutlineStyleByTheme(
      BuildContext context, TDTagTheme? theme, bool light, TDTagShape shape) {
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
    switch(shape){
      case TDTagShape.square:
        borderRadius = BorderRadius.circular(TDTheme.of(context).radiusSmall);
        break;
      case TDTagShape.round:
        borderRadius = BorderRadius.circular(TDTheme.of(context).radiusRound);
        break;
      case TDTagShape.mark:
        borderRadius = BorderRadius.only(topRight:Radius.circular(TDTheme.of(context).radiusRound),bottomRight: Radius.circular(TDTheme.of(context).radiusRound));
        break;
    }
    border = 1;
  }

  /// 根据主题生成禁用Tag样式
  TDTagStyle.generateDisableSelectStyle(
      BuildContext context, bool isOutline , TDTagShape shape) {

    borderColor = TDTheme.of(context).grayColor4;
    textColor = TDTheme.of(context).fontGyColor4;
    backgroundColor = TDTheme.of(context).grayColor2;
    switch(shape){
      case TDTagShape.square:
        borderRadius = BorderRadius.circular(TDTheme.of(context).radiusSmall);
        break;
      case TDTagShape.round:
        borderRadius = BorderRadius.circular(TDTheme.of(context).radiusRound);
        break;
      case TDTagShape.mark:
        borderRadius = BorderRadius.only(topRight:Radius.circular(TDTheme.of(context).radiusRound),bottomRight: Radius.circular(TDTheme.of(context).radiusRound));
        break;
    }
    border = isOutline ? 1 : 0;
  }
}
