import 'package:flutter/material.dart';

import '../../../td_export.dart';

/// TDButton按钮样式
class TDButtonStyle {
  Color? backgroundColor;
  Color? frameColor;
  Color? textColor;
  double? frameWidth;
  bool isFullWidth = false;

  TDButtonStyle(
      {this.backgroundColor,
      this.frameColor,
      this.textColor,
      this.frameWidth,});

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

  TDButtonStyle.generateStrokeStyleByTheme(
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
