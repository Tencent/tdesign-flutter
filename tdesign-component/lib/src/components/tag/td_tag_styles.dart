import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// Tag展示类型
enum TTagTheme {
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
enum TTagSize { extraLarge, large, medium, small, custom }

/// 标签形状
enum TTagShape { square, round, mark }

/// 标签样式
class TTagStyle {
  TTagStyle({
    this.context,
    this.textColor,
    this.backgroundColor,
    this.font,
    this.fontWeight,
    this.border = 0,
    this.borderColor,
    this.borderRadius,
  });

  /// 上下文，方便获取主题内容
  BuildContext? context;

  /// 文字颜色
  Color? textColor;

  /// 背景颜色
  Color? backgroundColor;

  /// 边框颜色
  Color? borderColor;

  /// 关闭图标颜色
  Color? closeIconColor;

  /// 圆角
  BorderRadiusGeometry? borderRadius;

  /// 字体尺寸
  Font? font;

  /// 字体粗细
  FontWeight? fontWeight;

  /// 线框粗细
  double border = 0;

  /// 字体颜色，与属性不同名，方便子类自定义处理
  Color get getTextColor => textColor ?? TTheme.of(context).fontWhColor1;

  /// 背景颜色，与属性不同名，方便子类自定义处理
  Color get getBackgroundColor =>
      backgroundColor ?? TTheme.of(context).brandNormalColor;

  /// 线框颜色，与属性不同名，方便子类自定义处理
  Color get getBorderColor => borderColor ?? Colors.transparent;

  /// 圆角，，与属性不同名，方便子类自定义处理
  BorderRadiusGeometry get getBorderRadius =>
      borderRadius ?? BorderRadius.circular(0);

  /// 根据主题生成填充Tag样式
  TTagStyle.generateFillStyleByTheme(
    BuildContext context,
    TTagTheme? theme,
    bool light,
    TTagShape shape,
  ) {
    this.context = context;
    switch (theme) {
      case TTagTheme.primary:
        textColor = light
            ? TTheme.of(context).brandNormalColor
            : TTheme.of(context).textColorAnti;
        backgroundColor = light
            ? TTheme.of(context).brandLightColor
            : TTheme.of(context).brandNormalColor;
        break;
      case TTagTheme.warning:
        textColor = light
            ? TTheme.of(context).warningNormalColor
            : TTheme.of(context).textColorAnti;
        backgroundColor = light
            ? TTheme.of(context).warningLightColor
            : TTheme.of(context).warningNormalColor;
        break;
      case TTagTheme.danger:
        textColor = light
            ? TTheme.of(context).errorNormalColor
            : TTheme.of(context).textColorAnti;
        backgroundColor = light
            ? TTheme.of(context).errorLightColor
            : TTheme.of(context).errorNormalColor;
        break;
      case TTagTheme.success:
        textColor = light
            ? TTheme.of(context).successNormalColor
            : TTheme.of(context).textColorAnti;
        backgroundColor = light
            ? TTheme.of(context).successLightColor
            : TTheme.of(context).successNormalColor;
        break;
      case TTagTheme.defaultTheme:
      default:
        textColor = TTheme.of(context).textColorPrimary;
        backgroundColor = light
            ? TTheme.of(context).bgColorSecondaryContainer
            : TTheme.of(context).bgColorComponent;
    }
    switch (shape) {
      case TTagShape.square:
        borderRadius = BorderRadius.circular(TTheme.of(context).radiusSmall);
        break;
      case TTagShape.round:
        borderRadius = BorderRadius.circular(TTheme.of(context).radiusRound);
        break;
      case TTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(TTheme.of(context).radiusRound),
          bottomRight: Radius.circular(TTheme.of(context).radiusRound),
        );
        break;
    }
    closeIconColor = textColor;
    borderColor = backgroundColor;
  }

  /// 根据主题生成描边Tag样式
  TTagStyle.generateOutlineStyleByTheme(
    BuildContext context,
    TTagTheme? theme,
    bool light,
    TTagShape shape,
  ) {
    this.context = context;
    switch (theme) {
      case TTagTheme.primary:
        borderColor = TTheme.of(context).brandNormalColor;
        textColor = TTheme.of(context).brandNormalColor;
        backgroundColor =
            light ? TTheme.of(context).brandLightColor : Colors.transparent;
        break;
      case TTagTheme.warning:
        borderColor = TTheme.of(context).warningNormalColor;
        textColor = TTheme.of(context).warningNormalColor;
        backgroundColor =
            light ? TTheme.of(context).warningLightColor : Colors.transparent;
        break;
      case TTagTheme.danger:
        borderColor = TTheme.of(context).errorNormalColor;
        textColor = TTheme.of(context).errorNormalColor;
        backgroundColor =
            light ? TTheme.of(context).errorLightColor : Colors.transparent;
        break;
      case TTagTheme.success:
        borderColor = TTheme.of(context).successNormalColor;
        textColor = TTheme.of(context).successNormalColor;
        backgroundColor =
            light ? TTheme.of(context).successLightColor : Colors.transparent;
        break;
      case TTagTheme.defaultTheme:
      default:
        borderColor = TTheme.of(context).componentBorderColor;
        textColor = TTheme.of(context).textColorPrimary;
        backgroundColor = light
            ? TTheme.of(context).bgColorSecondaryContainer
            : Colors.transparent;
    }
    switch (shape) {
      case TTagShape.square:
        borderRadius = BorderRadius.circular(TTheme.of(context).radiusSmall);
        break;
      case TTagShape.round:
        borderRadius = BorderRadius.circular(TTheme.of(context).radiusRound);
        break;
      case TTagShape.mark:
        borderRadius = BorderRadius.only(
            topRight: Radius.circular(TTheme.of(context).radiusRound),
            bottomRight: Radius.circular(TTheme.of(context).radiusRound));
        break;
    }
    border = 1;
    closeIconColor = textColor;
  }

  /// 根据主题生成禁用Tag样式
  TTagStyle.generateDisableSelectStyle(
    BuildContext context,
    bool isLight,
    bool isOutline,
    TTagShape shape,
  ) {
    borderColor = TTheme.of(context).componentBorderColor;
    textColor = TTheme.of(context).textDisabledColor;
    backgroundColor = isOutline && !isLight
        ? Colors.transparent
        : TTheme.of(context).bgColorComponentDisabled;
    switch (shape) {
      case TTagShape.square:
        borderRadius = BorderRadius.circular(TTheme.of(context).radiusSmall);
        break;
      case TTagShape.round:
        borderRadius = BorderRadius.circular(TTheme.of(context).radiusRound);
        break;
      case TTagShape.mark:
        borderRadius = BorderRadius.only(
            topRight: Radius.circular(TTheme.of(context).radiusRound),
            bottomRight: Radius.circular(TTheme.of(context).radiusRound));
        break;
    }
    border = isOutline ? 1 : 0;
  }
}
