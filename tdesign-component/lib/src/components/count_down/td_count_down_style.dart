import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 倒计时组件尺寸
enum TDCountDownSize {
  /// 小
  small,

  /// 中等
  medium,

  /// 大
  large,
}

/// 倒计时组件风格
enum TDCountDownTheme {
  /// 默认
  defaultTheme,

  /// 圆形
  round,

  /// 方形
  square,
}

/// 倒计时组件样式
class TDCountDownStyle {
  TDCountDownStyle({
    this.timeWidth,
    this.timeHeight,
    this.timePadding,
    this.timeMargin,
    this.timeBox,
    this.timeFontFamily,
    this.timeFontSize,
    this.timeFontHeight,
    this.timeFontWeight,
    this.timeColor,
    this.splitFontSize,
    this.splitFontHeight,
    this.splitFontWeight,
    this.splitColor,
    this.space,
  });

  /// 时间容器宽度
  double? timeWidth;

  /// 时间容器高度
  double? timeHeight;

  /// 时间容器内边距
  EdgeInsets? timePadding;

  /// 时间容器外边距
  EdgeInsets? timeMargin;

  /// 时间容器装饰
  BoxDecoration? timeBox;

  /// 时间字体
  FontFamily? timeFontFamily;

  /// 时间字体尺寸
  double? timeFontSize;

  /// 时间字体行高
  double? timeFontHeight;

  /// 时间字体粗细
  FontWeight? timeFontWeight;

  /// 时间字体颜色
  Color? timeColor;

  /// 分隔符字体尺寸
  double? splitFontSize;

  /// 分隔符字体行高
  double? splitFontHeight;

  /// 分隔符字体粗细
  FontWeight? splitFontWeight;

  /// 分隔符字体颜色
  Color? splitColor;

  /// 时间与分隔符的间隔
  double? space;

  /// 生成默认样式
  TDCountDownStyle.generateStyle(
    BuildContext context, {
    TDCountDownSize? size,
    TDCountDownTheme? theme,
    bool? splitWithUnit,
  }) {
    timeFontFamily = TDTheme.defaultData().numberFontFamily;
    late Font? font;
    switch (size ?? TDCountDownSize.medium) {
      case TDCountDownSize.small:
        if (theme == TDCountDownTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = TDTheme.of(context).fontBodyMedium;
          timeFontSize = splitFontSize = font?.size ?? 14;
          timeFontHeight = splitFontHeight = (font?.height ?? 22) / (timeFontSize ?? 14);
        } else {
          timeWidth = timeHeight = 20;
          font = TDTheme.of(context).fontBodySmall;
          timeFontSize = splitFontSize = font?.size ?? 12;
          timeFontHeight = splitFontHeight = null;
        }
        space = TDTheme.of(context).spacer4 / 2;
        break;
      case TDCountDownSize.medium:
        if (theme == TDCountDownTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = TDTheme.of(context).fontBodyLarge;
          timeFontSize = splitFontSize = font?.size ?? 16;
          timeFontHeight = splitFontHeight = (font?.height ?? 24) / (timeFontSize ?? 16);
        } else {
          timeWidth = timeHeight = 24;
          font = TDTheme.of(context).fontBodyMedium;
          timeFontSize = splitFontSize = font?.size ?? 14;
          timeFontHeight = splitFontHeight = null;
        }
        space = TDTheme.of(context).spacer8 / 2;
        break;
      case TDCountDownSize.large:
        if (theme == TDCountDownTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = TDTheme.of(context).fontBodyExtraLarge;
          timeFontSize = splitFontSize = font?.size ?? 18;
          timeFontHeight = splitFontHeight = (font?.height ?? 26) / (timeFontSize ?? 18);
        } else {
          timeWidth = timeHeight = 28;
          font = TDTheme.of(context).fontBodyLarge;
          timeFontSize = splitFontSize = font?.size ?? 16;
          timeFontHeight = splitFontHeight = null;
        }
        space = TDTheme.of(context).spacer12 / 2;
    }

    switch (theme ?? TDCountDownTheme.defaultTheme) {
      case TDCountDownTheme.round:
        timeBox = BoxDecoration(
          shape: BoxShape.circle,
          color: TDTheme.of(context).errorColor6,
        );
        timeColor = TDTheme.of(context).fontWhColor1;
        splitColor = TDTheme.of(context).errorColor6;
        break;
      case TDCountDownTheme.square:
        timeBox = BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusSmall),
          color: TDTheme.of(context).errorColor6,
        );
        timeColor = TDTheme.of(context).fontWhColor1;
        splitColor = TDTheme.of(context).errorColor6;
        break;
      case TDCountDownTheme.defaultTheme:
        timeBox = null;
        timeColor = splitColor = TDTheme.of(context).fontGyColor1;
        timeWidth = null;
        timeHeight = null;
    }

    if (splitWithUnit ?? false) {
      splitColor = TDTheme.of(context).fontGyColor1;
    }
  }
}
