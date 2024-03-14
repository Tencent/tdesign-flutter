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
    this.timeFont,
    this.timeColor,
    this.splitFont,
    this.splitColor,
    this.space,
  });

  /// 时间容器宽度
  double? timeWidth;

  /// 时间容器宽度
  double? timeHeight;

  /// 时间容器内边距
  EdgeInsets? timePadding;

  /// 时间容器外边距
  EdgeInsets? timeMargin;

  /// 时间容器装饰
  BoxDecoration? timeBox;
  
  /// 时间字体尺寸
  Font? timeFont;

  /// 时间字体颜色
  Color? timeColor;
    
  /// 分隔符字体尺寸
  Font? splitFont;

  /// 分隔符字体颜色
  Color? splitColor;

  /// 时间与分隔符的间隔
  double? space;

  /// 生成默认样式
  TDCountDownStyle.generateStyle(
    BuildContext context,
    {
      TDCountDownSize? size,
      TDCountDownTheme? theme,
      bool? splitWithUnit,
    }
  ) {
    switch (size ?? TDCountDownSize.medium) {
      case TDCountDownSize.small:
        timeWidth = 20;
        timeHeight = 20;
        timeFont = TDTheme.of(context).fontMarkSmall;
        splitFont = TDTheme.of(context).fontMarkExtraSmall;
        space = TDTheme.of(context).spacer4 / 2;
        break;
      case TDCountDownSize.medium:
        timeWidth = 24;
        timeHeight = 24;
        timeFont = TDTheme.of(context).fontMarkMedium;
        splitFont = TDTheme.of(context).fontMarkSmall;
        space = TDTheme.of(context).spacer8 / 2;
        break;
      case TDCountDownSize.large:
        timeWidth = 28;
        timeHeight = 28;
        timeFont = TDTheme.of(context).fontMarkLarge;
        splitFont = TDTheme.of(context).fontMarkMedium;
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

