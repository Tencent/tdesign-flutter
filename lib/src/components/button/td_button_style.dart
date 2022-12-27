import 'package:flutter/material.dart';

import '../../../td_export.dart';

/// TDButton按钮样式
class TDButtonStyle {
  Color? backgroundColor;
  Color? frameColor;
  Color? textColor;
  Color? disableBackgroundColor;
  Color? disableFrameColor;
  Color? disableTextColor;
  Radius? radius;
  double? frameWidth;
  bool isFullWidth = false;

  Color getBackgroundColor({BuildContext? context, bool disable = false}) {
    return (disable ? disableBackgroundColor : backgroundColor) ??
        TDTheme.of(context).brandNormalColor;
  }

  Color getFrameColor({BuildContext? context, bool disable = false}) {
    return (disable ? disableFrameColor : frameColor) ??
        TDTheme.of(context).brandNormalColor;
  }

  Color getTextColor({BuildContext? context, bool disable = false}) {
    return (disable ? disableTextColor : textColor) ??
        TDTheme.of(context).fontWhColor1;
  }

  TDButtonStyle(
      {this.backgroundColor,
      this.frameColor,
      this.textColor,
      this.disableBackgroundColor,
      this.disableFrameColor,
      this.disableTextColor,
      this.frameWidth,
      this.radius});

  TDButtonStyle.generateFillStyleByTheme(
      BuildContext context, TDButtonTheme? theme) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = TDTheme.of(context).fontWhColor1;
        backgroundColor = TDTheme.of(context).brandNormalColor;
        break;
      case TDButtonTheme.danger:
        textColor = TDTheme.of(context).fontWhColor1;
        backgroundColor = TDTheme.of(context).errorNormalColor;
        break;
      case TDButtonTheme.light:
        textColor = TDTheme.of(context).brandNormalColor;
        backgroundColor = TDTheme.of(context).brandLightColor;
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = TDTheme.of(context).fontGyColor1;
        backgroundColor = TDTheme.of(context).grayColor3;
    }
    frameColor = backgroundColor;
    radius = const Radius.circular(6);
  }

  TDButtonStyle.generateStrokeStyleByTheme(
      BuildContext context, TDButtonTheme? theme) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = TDTheme.of(context).brandNormalColor;
        backgroundColor = TDTheme.of(context).whiteColor1;
        frameColor = textColor;
        break;
      case TDButtonTheme.danger:
        textColor = TDTheme.of(context).errorNormalColor;
        backgroundColor = TDTheme.of(context).whiteColor1;
        frameColor = textColor;
        break;
      case TDButtonTheme.light:
        textColor = TDTheme.of(context).brandNormalColor;
        backgroundColor = TDTheme.of(context).brandLightColor;
        frameColor = textColor;
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = TDTheme.of(context).fontGyColor1;
        backgroundColor = TDTheme.of(context).whiteColor1;
        frameColor = TDTheme.of(context).grayColor4;
    }
    frameWidth = 1;
    radius = const Radius.circular(6);
  }

  TDButtonStyle.generateTextStyleByTheme(
      BuildContext context, TDButtonTheme? theme) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = TDTheme.of(context).brandNormalColor;
        break;
      case TDButtonTheme.danger:
        textColor = TDTheme.of(context).errorNormalColor;
        break;
      case TDButtonTheme.light:
        textColor = TDTheme.of(context).brandNormalColor;
        break;
      case TDButtonTheme.defaultTheme:
      default:
        textColor = TDTheme.of(context).fontGyColor1;
    }
    backgroundColor = Colors.transparent;
    frameColor = backgroundColor;
  }

  TDButtonStyle.primary({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    backgroundColor = themeData.brandNormalColor;
    textColor = themeData.fontWhColor1;
    frameColor = backgroundColor;
    disableBackgroundColor = themeData.brandDisabledColor;
    disableTextColor = themeData.fontWhColor1;
    disableFrameColor = disableBackgroundColor;
    radius = const Radius.circular(4);
  }

  TDButtonStyle.weakly({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    textColor = themeData.brandNormalColor;
    frameColor = themeData.brandNormalColor;
    backgroundColor = themeData.whiteColor1;
    disableTextColor = themeData.brandDisabledColor;
    disableFrameColor = themeData.brandDisabledColor;
    disableBackgroundColor = themeData.whiteColor1;
    radius = const Radius.circular(4);
    frameWidth = 0.5;
  }

  TDButtonStyle.secondary({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    disableTextColor = themeData.fontGyColor4;
    disableFrameColor = themeData.grayColor4;
    textColor = themeData.fontGyColor1;
    frameColor = themeData.grayColor4;
    backgroundColor = themeData.whiteColor1;
    disableBackgroundColor = themeData.whiteColor1;
    radius = const Radius.circular(4);
    frameWidth = 0.5;
  }

  TDButtonStyle.warningPrimary({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    disableBackgroundColor = themeData.errorDisabledColor;
    disableTextColor = themeData.fontWhColor1;
    backgroundColor = themeData.errorNormalColor;
    textColor = themeData.fontWhColor1;
    frameColor = backgroundColor;
    disableFrameColor = backgroundColor;
    radius = const Radius.circular(4);
  }

  TDButtonStyle.warningWeakly({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    disableTextColor = themeData.errorDisabledColor;
    disableFrameColor = themeData.errorDisabledColor;
    textColor = themeData.errorNormalColor;
    frameColor = themeData.errorNormalColor;
    backgroundColor = themeData.whiteColor1;
    disableBackgroundColor = themeData.whiteColor1;
    radius = const Radius.circular(4);
    frameWidth = 0.5;
  }

  TDButtonStyle.ghost({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    textColor = themeData.fontWhColor1;
    frameColor = themeData.whiteColor1;
    backgroundColor = Colors.transparent;
    disableTextColor = themeData.fontWhColor3;
    disableFrameColor = themeData.fontWhColor3;
    disableBackgroundColor = Colors.transparent;
    radius = const Radius.circular(4);
    frameWidth = 0.5;
  }

  TDButtonStyle.text(
      {BuildContext? context, Color? textColor, Color? disableTextColor}) {
    this.textColor = textColor ?? TDTheme.of(context).brandNormalColor;
    this.disableTextColor =
        disableTextColor ?? TDTheme.of(context).brandDisabledColor;
    frameColor = Colors.transparent;
    backgroundColor = Colors.transparent;
    disableFrameColor = Colors.transparent;
    disableBackgroundColor = Colors.transparent;
    radius = const Radius.circular(4);
  }

  TDButtonStyle.full({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    textColor = themeData.fontWhColor1;
    frameColor = themeData.brandNormalColor;
    backgroundColor = themeData.brandNormalColor;
    disableTextColor = themeData.fontWhColor1;
    disableFrameColor = themeData.brandDisabledColor;
    disableBackgroundColor = themeData.brandDisabledColor;
    radius = const Radius.circular(0);
    isFullWidth = true;
  }

  TDButtonStyle.fullSecondary({BuildContext? context}) {
    var themeData = TDTheme.of(context);
    textColor = themeData.fontGyColor1;
    frameColor = themeData.whiteColor1;
    backgroundColor = themeData.whiteColor1;
    disableTextColor = themeData.fontGyColor4;
    disableFrameColor = themeData.whiteColor1;
    disableBackgroundColor = themeData.whiteColor1;
    radius = const Radius.circular(0);
    isFullWidth = true;
  }
}
