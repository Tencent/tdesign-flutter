import 'package:flutter/material.dart';

import '../../../td_export.dart';

/// TDButton按钮样式
class TDButtonStyle {
  /// 背景颜色
  Color? backgroundColor;
  /// 边框颜色
  Color? frameColor;
  /// 文字颜色
  Color? textColor;
  /// 边框宽度
  double? frameWidth;

  TDButtonStyle(
      {this.backgroundColor,
      this.frameColor,
      this.textColor,
      this.frameWidth,});

  /// 生成不同主题的填充按钮样式
  TDButtonStyle.generateFillStyleByTheme(
      BuildContext context, TDButtonTheme? theme, TDButtonStatus status) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = TDTheme.of(context).fontWhColor1;
        backgroundColor = _getBrandColor(context, status);
        break;
      case TDButtonTheme.danger:
        textColor = TDTheme.of(context).fontWhColor1;
        backgroundColor = _getErrorColor(context, status);
        break;
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getDefaultBgColor(context, status);
    }
    frameColor = backgroundColor;
  }

  /// 生成不同主题的描边按钮样式
  TDButtonStyle.generateOutlineStyleByTheme(
      BuildContext context, TDButtonTheme? theme, TDButtonStatus status) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        backgroundColor = TDTheme.of(context).whiteColor1;
        frameColor = textColor;
        break;
      case TDButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor = TDTheme.of(context).whiteColor1;
        frameColor = textColor;
        break;
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
        frameColor = textColor;
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = TDTheme.of(context).whiteColor1;
        frameColor = TDTheme.of(context).grayColor4;
    }
    frameWidth = 1;
  }

  /// 生成不同主题的文本按钮样式
  TDButtonStyle.generateTextStyleByTheme(
      BuildContext context, TDButtonTheme? theme, TDButtonStatus status) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        break;
      case TDButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        break;
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = _getDefaultTextColor(context, status);
    }
    backgroundColor = Colors.transparent;
    frameColor = backgroundColor;
  }

  /// 生成不同主题的幽灵按钮样式
  TDButtonStyle.generateGhostStyleByTheme(
      BuildContext context, TDButtonTheme? theme, TDButtonStatus status) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        break;
      case TDButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        break;
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = TDTheme.of(context).fontWhColor1;
    }
    backgroundColor = Colors.transparent;
    frameColor = textColor;
    frameWidth = 1;
  }

  Color _getBrandColor(BuildContext context, TDButtonStatus status) {
    switch(status){
      case TDButtonStatus.defaultState:
        return TDTheme.of(context).brandNormalColor;
      case TDButtonStatus.active:
        return TDTheme.of(context).brandClickColor;
      case TDButtonStatus.disable:
        return TDTheme.of(context).brandDisabledColor;
    }
  }

  Color _getLightColor(BuildContext context, TDButtonStatus status) {
    switch(status){
      case TDButtonStatus.defaultState:
      case TDButtonStatus.disable:
        return TDTheme.of(context).brandLightColor;
      case TDButtonStatus.active:
        return TDTheme.of(context).brandFocusColor;
    }
  }

  Color _getErrorColor(BuildContext context, TDButtonStatus status) {
    switch(status){
      case TDButtonStatus.defaultState:
        return TDTheme.of(context).errorNormalColor;
      case TDButtonStatus.active:
        return TDTheme.of(context).errorClickColor;
      case TDButtonStatus.disable:
        return TDTheme.of(context).errorDisabledColor;
    }
  }

  Color _getDefaultBgColor(BuildContext context, TDButtonStatus status) {
    switch(status){
      case TDButtonStatus.defaultState:
        return TDTheme.of(context).grayColor3;
      case TDButtonStatus.active:
        return TDTheme.of(context).grayColor5;
      case TDButtonStatus.disable:
        return TDTheme.of(context).grayColor2;
    }
  }

  Color _getDefaultTextColor(BuildContext context, TDButtonStatus status) {
    switch(status){
      case TDButtonStatus.defaultState:
      case TDButtonStatus.active:
        return TDTheme.of(context).fontGyColor1;
      case TDButtonStatus.disable:
        return TDTheme.of(context).fontGyColor4;
    }
  }

}
