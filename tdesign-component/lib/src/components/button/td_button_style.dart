import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

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

  /// 自定义圆角
  BorderRadiusGeometry? radius;

  /// 渐变背景色
  Gradient? gradient;

  TDButtonStyle(
      {this.backgroundColor, this.frameColor, this.textColor, this.frameWidth, this.radius, this.gradient});

  /// 生成不同主题的填充按钮样式
  TDButtonStyle.generateFillStyleByTheme(
      BuildContext context, TDButtonTheme? theme, TDButtonStatus status) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = TDTheme.of(context).textColorAnti;
        backgroundColor = _getBrandColor(context, status);
        break;
      case TDButtonTheme.danger:
        textColor = TDTheme.of(context).textColorAnti;
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
        backgroundColor = status == TDButtonStatus.active
            ? TDTheme.of(context).bgColorContainerActive
            : Colors.transparent;
        frameColor = textColor;
        break;
      case TDButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor = status == TDButtonStatus.active
            ? TDTheme.of(context).bgColorContainerActive
            : Colors.transparent;
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
        backgroundColor = _getOutlineDefaultBgColor(context, status);
        frameColor = TDTheme.of(context).componentBorderColor;
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
    backgroundColor = status == TDButtonStatus.active
        ? TDTheme.of(context).bgColorContainerActive
        : Colors.transparent;
    frameColor = backgroundColor;
  }

  /// 生成不同主题的幽灵按钮样式
  TDButtonStyle.generateGhostStyleByTheme(
      BuildContext context, TDButtonTheme? theme, TDButtonStatus status) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = status == TDButtonStatus.disable
            ? TDTheme.of(context).fontWhColor4
            : _getBrandColor(context, status);
        break;
      case TDButtonTheme.danger:
        textColor = status == TDButtonStatus.disable
            ? TDTheme.of(context).fontWhColor4
            : _getErrorColor(context, status);
        break;
      case TDButtonTheme.light:
        textColor = status == TDButtonStatus.disable
            ? TDTheme.of(context).fontWhColor4
            : _getBrandColor(context, status);
        break;
      case TDButtonTheme.defaultTheme:
      default:
        switch (status) {
          case TDButtonStatus.active:
            textColor = TDTheme.of(context).fontWhColor2;
            break;
          case TDButtonStatus.disable:
            textColor = TDTheme.of(context).fontWhColor4;
            break;
          default:
            textColor = TDTheme.of(context).fontWhColor1;
        }
    }
    backgroundColor = Colors.transparent;
    frameColor = textColor;
    frameWidth = 1;
  }

  Color _getBrandColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return TDTheme.of(context).brandNormalColor;
      case TDButtonStatus.active:
        return TDTheme.of(context).brandClickColor;
      case TDButtonStatus.disable:
        return TDTheme.of(context).brandDisabledColor;
    }
  }

  Color _getLightColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
      case TDButtonStatus.disable:
        return TDTheme.of(context).brandLightColor;
      case TDButtonStatus.active:
        return TDTheme.of(context).brandFocusColor;
    }
  }

  Color _getErrorColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return TDTheme.of(context).errorNormalColor;
      case TDButtonStatus.active:
        return TDTheme.of(context).errorClickColor;
      case TDButtonStatus.disable:
        return TDTheme.of(context).errorDisabledColor;
    }
  }

  Color _getDefaultBgColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return TDTheme.of(context).bgColorComponent;
      case TDButtonStatus.active:
        return TDTheme.of(context).bgColorComponentHover;
      case TDButtonStatus.disable:
        return TDTheme.of(context).bgColorComponentDisabled;
    }
  }

  Color _getDefaultTextColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
      case TDButtonStatus.active:
        return TDTheme.of(context).textColorPrimary;
      case TDButtonStatus.disable:
        return TDTheme.of(context).textDisabledColor;
    }
  }

  Color _getOutlineDefaultBgColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return Colors.transparent;
      case TDButtonStatus.active:
        return TDTheme.of(context).bgColorContainerActive;
      case TDButtonStatus.disable:
        return TDTheme.of(context).bgColorComponentDisabled;
    }
  }
}