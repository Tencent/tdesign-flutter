import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// TButton按钮样式
class TButtonStyle {
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

  TButtonStyle(
      {this.backgroundColor, this.frameColor, this.textColor, this.frameWidth, this.radius, this.gradient});

  /// 生成不同主题的填充按钮样式
  TButtonStyle.generateFillStyleByTheme(
      BuildContext context, TButtonTheme? theme, TButtonStatus status) {
    switch (theme) {
      case TButtonTheme.primary:
        textColor = TTheme.of(context).textColorAnti;
        backgroundColor = _getBrandColor(context, status);
        break;
      case TButtonTheme.danger:
        textColor = TTheme.of(context).textColorAnti;
        backgroundColor = _getErrorColor(context, status);
        break;
      case TButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
        break;
      case TButtonTheme.defaultTheme:
      default:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getDefaultBgColor(context, status);
    }
    frameColor = backgroundColor;
  }

  /// 生成不同主题的描边按钮样式
  TButtonStyle.generateOutlineStyleByTheme(
      BuildContext context, TButtonTheme? theme, TButtonStatus status) {
    switch (theme) {
      case TButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        backgroundColor = status == TButtonStatus.active
            ? TTheme.of(context).bgColorContainerActive
            : Colors.transparent;
        frameColor = textColor;
        break;
      case TButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor = status == TButtonStatus.active
            ? TTheme.of(context).bgColorContainerActive
            : Colors.transparent;
        frameColor = textColor;
        break;
      case TButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
        frameColor = textColor;
        break;
      case TButtonTheme.defaultTheme:
      default:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getOutlineDefaultBgColor(context, status);
        frameColor = TTheme.of(context).componentBorderColor;
    }
    frameWidth = 1;
  }

  /// 生成不同主题的文本按钮样式
  TButtonStyle.generateTextStyleByTheme(
      BuildContext context, TButtonTheme? theme, TButtonStatus status) {
    switch (theme) {
      case TButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        break;
      case TButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        break;
      case TButtonTheme.light:
        textColor = _getBrandColor(context, status);
        break;
      case TButtonTheme.defaultTheme:
      default:
        textColor = _getDefaultTextColor(context, status);
    }
    backgroundColor = status == TButtonStatus.active
        ? TTheme.of(context).bgColorContainerActive
        : Colors.transparent;
    frameColor = backgroundColor;
  }

  /// 生成不同主题的幽灵按钮样式
  TButtonStyle.generateGhostStyleByTheme(
      BuildContext context, TButtonTheme? theme, TButtonStatus status) {
    switch (theme) {
      case TButtonTheme.primary:
        textColor = status == TButtonStatus.disable
            ? TTheme.of(context).fontWhColor4
            : _getBrandColor(context, status);
        break;
      case TButtonTheme.danger:
        textColor = status == TButtonStatus.disable
            ? TTheme.of(context).fontWhColor4
            : _getErrorColor(context, status);
        break;
      case TButtonTheme.light:
        textColor = status == TButtonStatus.disable
            ? TTheme.of(context).fontWhColor4
            : _getBrandColor(context, status);
        break;
      case TButtonTheme.defaultTheme:
      default:
        switch (status) {
          case TButtonStatus.active:
            textColor = TTheme.of(context).fontWhColor2;
            break;
          case TButtonStatus.disable:
            textColor = TTheme.of(context).fontWhColor4;
            break;
          default:
            textColor = TTheme.of(context).fontWhColor1;
        }
    }
    backgroundColor = Colors.transparent;
    frameColor = textColor;
    frameWidth = 1;
  }

  Color _getBrandColor(BuildContext context, TButtonStatus status) {
    switch (status) {
      case TButtonStatus.defaultState:
        return TTheme.of(context).brandNormalColor;
      case TButtonStatus.active:
        return TTheme.of(context).brandClickColor;
      case TButtonStatus.disable:
        return TTheme.of(context).brandDisabledColor;
    }
  }

  Color _getLightColor(BuildContext context, TButtonStatus status) {
    switch (status) {
      case TButtonStatus.defaultState:
      case TButtonStatus.disable:
        return TTheme.of(context).brandLightColor;
      case TButtonStatus.active:
        return TTheme.of(context).brandFocusColor;
    }
  }

  Color _getErrorColor(BuildContext context, TButtonStatus status) {
    switch (status) {
      case TButtonStatus.defaultState:
        return TTheme.of(context).errorNormalColor;
      case TButtonStatus.active:
        return TTheme.of(context).errorClickColor;
      case TButtonStatus.disable:
        return TTheme.of(context).errorDisabledColor;
    }
  }

  Color _getDefaultBgColor(BuildContext context, TButtonStatus status) {
    switch (status) {
      case TButtonStatus.defaultState:
        return TTheme.of(context).bgColorComponent;
      case TButtonStatus.active:
        return TTheme.of(context).bgColorComponentHover;
      case TButtonStatus.disable:
        return TTheme.of(context).bgColorComponentDisabled;
    }
  }

  Color _getDefaultTextColor(BuildContext context, TButtonStatus status) {
    switch (status) {
      case TButtonStatus.defaultState:
      case TButtonStatus.active:
        return TTheme.of(context).textColorPrimary;
      case TButtonStatus.disable:
        return TTheme.of(context).textDisabledColor;
    }
  }

  Color _getOutlineDefaultBgColor(BuildContext context, TButtonStatus status) {
    switch (status) {
      case TButtonStatus.defaultState:
        return Colors.transparent;
      case TButtonStatus.active:
        return TTheme.of(context).bgColorContainerActive;
      case TButtonStatus.disable:
        return TTheme.of(context).bgColorComponentDisabled;
    }
  }
}