import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

// ---------------------------------------------------------------------------
// TCalendarStyle — 日历样式配置
// ---------------------------------------------------------------------------

/// [TCalendar] 的样式配置，通过 [TCalendar.style] 传入。
///
/// 使用 [TCalendarStyle.generateStyle] 获取主题默认样式，
/// 再用 [forSelectType] 按 [DateSelectType] 区分选中/区间等态下的文字与装饰。
class TCalendarStyle {
  const TCalendarStyle({
    this.decoration,
    this.weekdayStyle,
    this.monthTitleStyle,
    this.dayStyle,
    this.todayDayStyle,
    this.cellDecoration,
    this.subtitleStyle,
    this.cellHeight = 60,
    this.monthTitleHeight = 22,
    this.verticalGap,
    this.bodyPadding,
    this.weekdayGap,
    this.centreColor,
  });

  /// 组件容器装饰
  final BoxDecoration? decoration;

  /// 星期文字样式
  final TextStyle? weekdayStyle;

  /// 月份标题文字样式
  final TextStyle? monthTitleStyle;

  /// 日期数字样式
  final TextStyle? dayStyle;

  /// 今天日期数字样式
  final TextStyle? todayDayStyle;

  /// 日期单元格装饰（选中状态）
  final BoxDecoration? cellDecoration;

  /// 副标题样式
  final TextStyle? subtitleStyle;

  /// 日期单元格高度，默认 60
  final double cellHeight;

  /// 月份标题高度，默认 22
  final double monthTitleHeight;

  /// 日期格垂直间距，水平间距为 [verticalGap] / 2
  final double? verticalGap;

  /// 内边距
  final double? bodyPadding;

  /// 星期之间的水平间距
  final double? weekdayGap;

  /// 区间中间格背景与格间衔接条颜色；[forSelectType] 中设为 [TTheme.brandLightColor]。
  final Color? centreColor;

  /// 星期标题高度
  double get weekdayHeight => _kDefaultWeekdayHeight;

  static const _kDefaultWeekdayHeight = 46.0;

  /// 生成默认样式
  static TCalendarStyle generateStyle({BuildContext? context}) {
    if (context == null) {
      return const TCalendarStyle();
    }
    return TCalendarStyle(
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TTheme.of(context).radiusExtraLarge),
        ),
      ),
      weekdayStyle: TextStyle(
        fontSize: TTheme.of(context).fontTitleSmall?.size,
        color: TTheme.of(context).textColorSecondary,
      ),
      monthTitleStyle: TextStyle(
        fontSize: TTheme.of(context).fontMarkMedium?.size,
        fontWeight: TTheme.of(context).fontMarkMedium?.fontWeight,
        color: TTheme.of(context).textColorPrimary,
      ),
      dayStyle: TextStyle(
        fontSize: TTheme.of(context).fontTitleMedium?.size,
        height: TTheme.of(context).fontTitleMedium?.height,
        fontWeight: TTheme.of(context).fontTitleMedium?.fontWeight,
        color: TTheme.of(context).textColorPrimary,
      ),
      todayDayStyle: TextStyle(
        fontSize: TTheme.of(context).fontTitleMedium?.size,
        height: TTheme.of(context).fontTitleMedium?.height,
        fontWeight: TTheme.of(context).fontTitleMedium?.fontWeight,
        color: TTheme.of(context).brandNormalColor,
      ),
      verticalGap: TTheme.of(context).spacer8,
      bodyPadding: TTheme.of(context).spacer16,
      weekdayGap: TTheme.of(context).spacer4,
    );
  }

  /// 按选中态生成单元格样式
  TCalendarStyle forSelectType(BuildContext context, DateSelectType? type) {
    final radius6 = TTheme.of(context).radiusDefault;
    final defStyle = TextStyle(
      fontSize: TTheme.of(context).fontTitleMedium?.size,
      height: TTheme.of(context).fontTitleMedium?.height,
      fontWeight: TTheme.of(context).fontTitleMedium?.fontWeight,
    );
    final subtitleBase = TextStyle(
      fontSize: TTheme.of(context).fontBodyExtraSmall?.size,
      height: TTheme.of(context).fontBodyExtraSmall?.height,
      fontWeight: FontWeight.w400,
    );
    final rangeCentreColor = TTheme.of(context).brandLightColor;
    switch (type) {
      case DateSelectType.empty:
        return TCalendarStyle(
          centreColor: rangeCentreColor,
          dayStyle: defStyle.copyWith(color: TTheme.of(context).textColorPrimary),
          todayDayStyle:
              defStyle.copyWith(color: TTheme.of(context).brandNormalColor),
          subtitleStyle: subtitleBase.copyWith(
              color: TTheme.of(context).textColorPlaceholder),
          cellDecoration: null,
        );
      case DateSelectType.disabled:
        return TCalendarStyle(
          centreColor: rangeCentreColor,
          dayStyle: defStyle.copyWith(color: TTheme.of(context).textDisabledColor),
          todayDayStyle:
              defStyle.copyWith(color: TTheme.of(context).brandDisabledColor),
          subtitleStyle:
              subtitleBase.copyWith(color: TTheme.of(context).textDisabledColor),
          cellDecoration: null,
        );
      case DateSelectType.selected:
        return TCalendarStyle(
          centreColor: rangeCentreColor,
          dayStyle: defStyle.copyWith(color: TTheme.of(context).textColorAnti),
          subtitleStyle:
              subtitleBase.copyWith(color: TTheme.of(context).textColorAnti),
          cellDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius6),
            color: TTheme.of(context).brandNormalColor,
          ),
        );
      case DateSelectType.centre:
        return TCalendarStyle(
          centreColor: rangeCentreColor,
          dayStyle: defStyle.copyWith(color: TTheme.of(context).textColorPrimary),
          subtitleStyle: subtitleBase.copyWith(
              color: TTheme.of(context).textColorPlaceholder),
          cellDecoration: BoxDecoration(
            color: rangeCentreColor,
          ),
        );
      case DateSelectType.start:
        return TCalendarStyle(
          centreColor: rangeCentreColor,
          dayStyle: defStyle.copyWith(color: TTheme.of(context).textColorAnti),
          subtitleStyle:
              subtitleBase.copyWith(color: TTheme.of(context).textColorAnti),
          cellDecoration: BoxDecoration(
            color: TTheme.of(context).brandNormalColor,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(radius6)),
          ),
        );
      case DateSelectType.end:
        return TCalendarStyle(
          centreColor: rangeCentreColor,
          dayStyle: defStyle.copyWith(color: TTheme.of(context).textColorAnti),
          subtitleStyle:
              subtitleBase.copyWith(color: TTheme.of(context).textColorAnti),
          cellDecoration: BoxDecoration(
            color: TTheme.of(context).brandNormalColor,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(radius6)),
          ),
        );
      default:
        return this;
    }
  }
}
