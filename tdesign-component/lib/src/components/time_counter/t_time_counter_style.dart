import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font, FontFamily;
import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
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
    final effectiveSize = size ?? TTimeCounterSize.medium;
    final effectiveTheme = theme ?? TTimeCounterVariant.defaultTheme;
    final hasUnit = splitWithUnit ?? false;
    late Font? defaultFont;
    late Font? blockFont;
    late Font? unitFont;
    late double blockExtent;
    late double unitSpace;
    late double dotSpace;
    switch (effectiveSize) {
      case TTimeCounterSize.small:
        defaultFont = context.tTheme.fontBodyMedium;
        blockFont = context.tTheme.fontBodySmall;
        unitFont = context.tTheme.fontBodyExtraSmall;
        blockExtent = 20;
        unitSpace = 4;
        dotSpace = 2;
        break;
      case TTimeCounterSize.medium:
        defaultFont = context.tTheme.fontBodyLarge;
        blockFont = context.tTheme.fontBodyMedium;
        unitFont = context.tTheme.fontBodySmall;
        blockExtent = 24;
        unitSpace = 5;
        dotSpace = 3;
        break;
      case TTimeCounterSize.large:
        defaultFont = context.tTheme.fontBodyExtraLarge;
        blockFont = context.tTheme.fontBodyLarge;
        unitFont = context.tTheme.fontBodyMedium;
        blockExtent = 28;
        unitSpace = 6;
        dotSpace = 6;
    }

    final timeFont = effectiveTheme == TTimeCounterVariant.defaultTheme
        ? defaultFont
        : blockFont;
    final splitFont = hasUnit ? unitFont : defaultFont;
    timeFontSize = timeFont?.size;
    timeFontHeight = effectiveTheme == TTimeCounterVariant.defaultTheme
        ? timeFont?.height
        : null;
    splitFontSize = splitFont?.size;
    splitFontHeight = hasUnit ? splitFont?.height : timeFontHeight;
    timeWidth = timeHeight = effectiveTheme == TTimeCounterVariant.defaultTheme
        ? null
        : blockExtent;
    space = hasUnit
        ? unitSpace
        : effectiveTheme == TTimeCounterVariant.defaultTheme
        ? 0
        : dotSpace;

    switch (effectiveTheme) {
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

    if (hasUnit) {
      splitColor = context.tTheme.textColorPrimary;
    }
  }
}
