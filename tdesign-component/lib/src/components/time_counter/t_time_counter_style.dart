import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font, FontFamily;
import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_time_counter_types.dart';

/// 计时组件样式
class TTimeCounterStyle {
  TTimeCounterStyle({
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
  TTimeCounterStyle.generateStyle(
    BuildContext context, {
    TTimeCounterSize? size,
    TTimeCounterVariant? theme,
    bool? splitWithUnit,
  }) {
    timeFontFamily = context.tTheme.numberFontFamily;
    late Font? font;
    switch (size ?? TTimeCounterSize.medium) {
      case TTimeCounterSize.small:
        if (theme == TTimeCounterVariant.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.tTheme.fontBodyMedium;
          timeFontSize = splitFontSize = font?.size ?? 14;
          timeFontHeight =
              splitFontHeight = font?.height ?? (22 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 20;
          font = context.tTheme.fontBodySmall;
          timeFontSize = splitFontSize = font?.size ?? 12;
          timeFontHeight = splitFontHeight = null;
        }
        space = context.tTheme.spacer4 / 2;
        break;
      case TTimeCounterSize.medium:
        if (theme == TTimeCounterVariant.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.tTheme.fontBodyLarge;
          timeFontSize = splitFontSize = font?.size ?? 16;
          timeFontHeight =
              splitFontHeight = font?.height ?? (24 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 24;
          font = context.tTheme.fontBodyMedium;
          timeFontSize = splitFontSize = font?.size ?? 14;
          timeFontHeight = splitFontHeight = null;
        }
        space = context.tTheme.spacer8 / 2;
        break;
      case TTimeCounterSize.large:
        if (theme == TTimeCounterVariant.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.tTheme.fontBodyExtraLarge;
          timeFontSize = splitFontSize = font?.size ?? 18;
          timeFontHeight =
              splitFontHeight = font?.height ?? (26 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 28;
          font = context.tTheme.fontBodyLarge;
          timeFontSize = splitFontSize = font?.size ?? 16;
          timeFontHeight = splitFontHeight = null;
        }
        space = context.tTheme.spacer12 / 2;
    }

    switch (theme ?? TTimeCounterVariant.defaultTheme) {
      case TTimeCounterVariant.round:
        timeBox = BoxDecoration(
          shape: BoxShape.circle,
          color: context.tTheme.errorNormalColor,
        );
        timeColor = context.tTheme.textColorAnti;
        splitColor = context.tTheme.errorNormalColor;
        break;
      case TTimeCounterVariant.square:
        timeBox = BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
          color: context.tTheme.errorNormalColor,
        );
        timeColor = context.tTheme.textColorAnti;
        splitColor = context.tTheme.errorNormalColor;
        break;
      case TTimeCounterVariant.defaultTheme:
        timeBox = null;
        timeColor = splitColor = context.tTheme.textColorPrimary;
        timeWidth = null;
        timeHeight = null;
    }

    if (splitWithUnit ?? false) {
      splitColor = context.tTheme.textColorPrimary;
    }
  }
}
