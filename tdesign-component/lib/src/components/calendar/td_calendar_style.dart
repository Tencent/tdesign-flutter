import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 日历组件样式
class TDCalendarStyle {
  TDCalendarStyle({
    this.decoration,
    this.titleStyle,
    this.titleMaxLine,
    this.titleCloseColor,
    this.weekdayStyle,
    this.monthTitleStyle,
    this.cellStyle,
    this.centreColor,
    this.cellDecoration,
    this.cellPrefixStyle,
    this.cellSuffixStyle,
  });

  BoxDecoration? decoration;

  /// header区域 [TDCalendar.title]的样式
  TextStyle? titleStyle;

  /// header区域 [TDCalendar.title]的行数
  int? titleMaxLine;

  /// header区域 关闭图标的颜色
  Color? titleCloseColor;

  /// header区域 周 文字样式
  TextStyle? weekdayStyle;

  /// body区域 年月文字样式
  TextStyle? monthTitleStyle;

  /// 日期样式
  TextStyle? cellStyle;

  /// 当天日期样式
  TextStyle? todayStyle;

  /// 日期decoration
  BoxDecoration? cellDecoration;

  /// 日期范围内背景样式
  Color? centreColor;

  /// 日期前面的字符串的样式
  TextStyle? cellPrefixStyle;

  /// 日期后面的字符串的样式
  TextStyle? cellSuffixStyle;

  /// 日期垂直间距，水平间距为[verticalGap] / 2
  double? verticalGap;

  /// 月与月之间的垂直间距
  double? bodyPadding;

  /// 生成默认样式
  TDCalendarStyle.generateStyle(BuildContext context) {
    decoration = BoxDecoration(
      color: TDTheme.of(context).bgColorContainer,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(TDTheme.of(context).radiusExtraLarge),
      ),
    );
    titleStyle = TextStyle(
      fontSize: TDTheme.of(context).fontTitleLarge?.size,
      fontWeight: TDTheme.of(context).fontTitleLarge?.fontWeight,
      color: TDTheme.of(context).textColorPrimary,
    );
    titleMaxLine = 1;
    titleCloseColor = titleStyle?.color;
    weekdayStyle = TextStyle(
      fontSize: TDTheme.of(context).fontTitleSmall?.size,
      color: TDTheme.of(context).textColorSecondary,
    );
    monthTitleStyle = TextStyle(
      fontSize: TDTheme.of(context).fontMarkMedium?.size,
      fontWeight: TDTheme.of(context).fontMarkMedium?.fontWeight,
      color: TDTheme.of(context).textColorPrimary,
    );
    verticalGap = TDTheme.of(context).spacer8;
    bodyPadding = TDTheme.of(context).spacer16;
  }

  /// 日期样式
  TDCalendarStyle.cellStyle(BuildContext context, DateSelectType? type) {
    final radius6 = TDTheme.of(context).radiusDefault;
    final defStyle = TextStyle(
      fontSize: TDTheme.of(context).fontTitleMedium?.size,
      height: TDTheme.of(context).fontTitleMedium?.height,
      fontWeight: TDTheme.of(context).fontTitleMedium?.fontWeight,
    );
    final prefixStyle = TextStyle(
      fontSize: TDTheme.of(context).fontBodyExtraSmall?.size,
      height: TDTheme.of(context).fontBodyExtraSmall?.height,
      fontWeight: FontWeight.w400,
    );
    centreColor = TDTheme.of(context).brandLightColor;
    switch (type) {
      case DateSelectType.empty:
        cellStyle =
            defStyle.copyWith(color: TDTheme.of(context).textColorPrimary);
        todayStyle = defStyle.copyWith(color: TDTheme.of(context).brandNormalColor);
        cellPrefixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).errorNormalColor);
        cellSuffixStyle = prefixStyle.copyWith(
            color: TDTheme.of(context).textColorPlaceholder);
        cellDecoration = null;
        break;
      case DateSelectType.disabled:
        cellStyle =
            defStyle.copyWith(color: TDTheme.of(context).textDisabledColor);
        todayStyle = defStyle.copyWith(color: TDTheme.of(context).brandDisabledColor);
        cellPrefixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).errorDisabledColor);
        cellSuffixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textDisabledColor);
        cellDecoration = null;
        break;
      case DateSelectType.selected:
        cellStyle = defStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellPrefixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellSuffixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(radius6),
          color: TDTheme.of(context).brandNormalColor,
        );
        break;
      case DateSelectType.centre:
        cellStyle =
            defStyle.copyWith(color: TDTheme.of(context).textColorPrimary);
        cellPrefixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).errorNormalColor);
        cellSuffixStyle = prefixStyle.copyWith(
            color: TDTheme.of(context).textColorPlaceholder);
        cellDecoration = BoxDecoration(
          color: centreColor,
        );
        break;
      case DateSelectType.start:
        cellStyle = defStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellPrefixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellSuffixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellDecoration = BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(radius6)),
        );
        break;
      case DateSelectType.end:
        cellStyle = defStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellPrefixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellSuffixStyle =
            prefixStyle.copyWith(color: TDTheme.of(context).textColorAnti);
        cellDecoration = BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.horizontal(right: Radius.circular(radius6)),
        );
        break;
      default:
        break;
    }
  }
}
