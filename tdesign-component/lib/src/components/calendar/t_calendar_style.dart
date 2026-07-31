import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_calendar_types.dart';

// ---------------------------------------------------------------------------
// TCalendarStyle — 日历样式配置
// ---------------------------------------------------------------------------

/// Calendar 内部样式快照。
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

  /// 区间中间格背景与格间衔接条颜色。
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
        color: context.tTheme.bgColorContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.tTheme.radiusExtraLarge),
        ),
      ),
      weekdayStyle: TextStyle(
        fontSize: context.tTheme.fontTitleSmall?.size,
        color: context.tTheme.textColorSecondary,
      ),
      monthTitleStyle: TextStyle(
        fontSize: context.tTheme.fontMarkMedium?.size,
        fontWeight: context.tTheme.fontMarkMedium?.fontWeight,
        color: context.tTheme.textColorPrimary,
      ),
      dayStyle: TextStyle(
        fontSize: context.tTheme.fontTitleMedium?.size,
        height: context.tTheme.fontTitleMedium?.height,
        fontWeight: context.tTheme.fontTitleMedium?.fontWeight,
        color: context.tTheme.textColorPrimary,
      ),
      todayDayStyle: TextStyle(
        fontSize: context.tTheme.fontTitleMedium?.size,
        height: context.tTheme.fontTitleMedium?.height,
        fontWeight: context.tTheme.fontTitleMedium?.fontWeight,
        color: context.tTheme.brandNormalColor,
      ),
      verticalGap: context.tTheme.spacer8,
      bodyPadding: context.tTheme.spacer16,
      weekdayGap: context.tTheme.spacer4,
    );
  }

  /// 按选中态生成单元格样式
  TCalendarStyle forSelectType(BuildContext context, DateSelectType? type) {
    final radius6 = context.tTheme.radiusDefault;
    final defaultDayStyle = TextStyle(
      fontSize: context.tTheme.fontTitleMedium?.size,
      height: context.tTheme.fontTitleMedium?.height,
      fontWeight: context.tTheme.fontTitleMedium?.fontWeight,
      color: context.tTheme.textColorPrimary,
    );
    final defaultTodayStyle =
        defaultDayStyle.copyWith(color: context.tTheme.brandNormalColor);
    final defaultSubtitleStyle = TextStyle(
      fontSize: context.tTheme.fontBodyExtraSmall?.size,
      height: context.tTheme.fontBodyExtraSmall?.height,
      fontWeight: FontWeight.w400,
      color: context.tTheme.textColorPlaceholder,
    );
    final resolvedDayStyle = dayStyle ?? defaultDayStyle;
    final resolvedTodayStyle = todayDayStyle ?? defaultTodayStyle;
    final resolvedSubtitleStyle = subtitleStyle ?? defaultSubtitleStyle;
    final rangeCentreColor = centreColor ?? context.tTheme.brandLightColor;

    TCalendarStyle stateStyle({
      required TextStyle dayStyle,
      TextStyle? todayDayStyle,
      required TextStyle subtitleStyle,
      BoxDecoration? cellDecoration,
    }) {
      return TCalendarStyle(
        centreColor: rangeCentreColor,
        dayStyle: dayStyle,
        todayDayStyle: todayDayStyle,
        subtitleStyle: subtitleStyle,
        cellDecoration: cellDecoration,
      );
    }

    BoxDecoration selectedDecoration(BorderRadius borderRadius) {
      final themed = cellDecoration;
      if (themed == null) {
        return BoxDecoration(
          borderRadius: borderRadius,
          color: context.tTheme.brandNormalColor,
        );
      }
      return BoxDecoration(
        color: themed.color ??
            (themed.gradient == null ? context.tTheme.brandNormalColor : null),
        image: themed.image,
        border: themed.border,
        borderRadius: themed.shape == BoxShape.circle
            ? null
            : themed.borderRadius ?? borderRadius,
        boxShadow: themed.boxShadow,
        gradient: themed.gradient,
        backgroundBlendMode: themed.backgroundBlendMode,
        shape: themed.shape,
      );
    }

    switch (type) {
      case DateSelectType.empty:
        return stateStyle(
          dayStyle: resolvedDayStyle,
          todayDayStyle: resolvedTodayStyle,
          subtitleStyle: resolvedSubtitleStyle,
        );
      case DateSelectType.disabled:
        return stateStyle(
          dayStyle: resolvedDayStyle.copyWith(
              color: context.tTheme.textDisabledColor),
          todayDayStyle: resolvedTodayStyle.copyWith(
            color: context.tTheme.brandDisabledColor,
          ),
          subtitleStyle: resolvedSubtitleStyle.copyWith(
            color: context.tTheme.textDisabledColor,
          ),
        );
      case DateSelectType.selected:
        final selectedDayStyle =
            resolvedDayStyle.copyWith(color: context.tTheme.textColorAnti);
        return stateStyle(
          dayStyle: selectedDayStyle,
          todayDayStyle: selectedDayStyle,
          subtitleStyle: resolvedSubtitleStyle.copyWith(
            color: context.tTheme.textColorAnti,
          ),
          cellDecoration: selectedDecoration(
            BorderRadius.circular(radius6),
          ),
        );
      case DateSelectType.centre:
        return stateStyle(
          dayStyle: resolvedDayStyle,
          todayDayStyle: resolvedTodayStyle,
          subtitleStyle: resolvedSubtitleStyle,
          cellDecoration: BoxDecoration(
            color: rangeCentreColor,
          ),
        );
      case DateSelectType.start:
        final selectedDayStyle =
            resolvedDayStyle.copyWith(color: context.tTheme.textColorAnti);
        return stateStyle(
          dayStyle: selectedDayStyle,
          todayDayStyle: selectedDayStyle,
          subtitleStyle: resolvedSubtitleStyle.copyWith(
            color: context.tTheme.textColorAnti,
          ),
          cellDecoration: selectedDecoration(
            BorderRadius.horizontal(
              left: Radius.circular(radius6),
            ),
          ),
        );
      case DateSelectType.end:
        final selectedDayStyle =
            resolvedDayStyle.copyWith(color: context.tTheme.textColorAnti);
        return stateStyle(
          dayStyle: selectedDayStyle,
          todayDayStyle: selectedDayStyle,
          subtitleStyle: resolvedSubtitleStyle.copyWith(
            color: context.tTheme.textColorAnti,
          ),
          cellDecoration: selectedDecoration(
            BorderRadius.horizontal(
              right: Radius.circular(radius6),
            ),
          ),
        );
      default:
        return this;
    }
  }
}
