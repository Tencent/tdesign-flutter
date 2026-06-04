import 'package:flutter/material.dart';
import 'package:lunar/lunar.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'lunar_info.dart';

/// 农历示例数据：为 [TCalendar.subtitleBuilder] 提供节日 / 节气 / 农历日副标题文案。
///
/// 接入方式：`subtitleBuilder: lunarExample.buildSubtitle`。
/// 控制栏切换月份请改 [TCalendar.anchorDate]，勿用 [TCalendar.initialValue] 驱动滚动。
class LunarDataSourceExample {
  static String convertToChineseNumber(int number) {
    const digits = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    return number
        .toString()
        .split('')
        .map((d) => digits[int.parse(d)])
        .join();
  }

  static String lunarMonthName(int month, bool isLeapMonth) {
    const months = [
      '正月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '冬月',
      '腊月'
    ];
    final monthText = months[month - 1];
    return isLeapMonth ? '闰$monthText' : monthText;
  }

  static String lunarDayName(int day) {
    const days = [
      '初一',
      '初二',
      '初三',
      '初四',
      '初五',
      '初六',
      '初七',
      '初八',
      '初九',
      '初十',
      '十一',
      '十二',
      '十三',
      '十四',
      '十五',
      '十六',
      '十七',
      '十八',
      '十九',
      '二十',
      '廿一',
      '廿二',
      '廿三',
      '廿四',
      '廿五',
      '廿六',
      '廿七',
      '廿八',
      '廿九',
      '三十'
    ];
    return days[day - 1];
  }

  LunarInfo? getLunarInfo(DateTime solarDate) {
    try {
      final solar = Solar.fromDate(solarDate);
      final lunar = solar.getLunar();

      return LunarInfo(
        year: lunar.getYear(),
        month: lunar.getMonth().abs(),
        day: lunar.getDay(),
        isLeapMonth: lunar.getMonth() < 0,
        yearText: convertToChineseNumber(lunar.getYear()),
        monthText: lunarMonthName(lunar.getMonth().abs(), lunar.getMonth() < 0),
        dayText: lunarDayName(lunar.getDay()),
      );
    } catch (e) {
      return null;
    }
  }

  /// 按阳历日期解析副标题文案；无内容时返回 null。
  String? subtitleTextFor(DateTime date) {
    final lunar = getLunarInfo(date);
    final festival = festivalOf(date, lunar);
    if (festival != null && festival.isNotEmpty) {
      return festival;
    }
    final term = solarTermOf(date);
    if (term != null && term.isNotEmpty) {
      return term;
    }
    return lunar?.dayText;
  }

  /// 供 [TCalendar.subtitleBuilder] 使用，按格子的 [TCalendarSubtitleContext] 渲染副标题。
  Widget? buildSubtitle(
    BuildContext context,
    TCalendarSubtitleContext subtitleContext,
  ) {
    final text = subtitleTextFor(subtitleContext.date);
    if (text == null || text.isEmpty) {
      return null;
    }
    final cellStyle = TCalendarStyle.generateStyle(context: null)
        .forSelectType(context, subtitleContext.selectType);
    return TText(
      text,
      style: cellStyle.subtitleStyle?.copyWith(fontSize: 9),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String formatYear(int year, {bool lunar = false}) {
    if (!lunar) {
      return '$year年';
    }
    return '${convertToChineseNumber(year)}年';
  }

  String formatMonth(int month, {bool lunar = false, bool isLeapMonth = false}) {
    if (!lunar) {
      return '$month月';
    }
    return lunarMonthName(month, isLeapMonth);
  }

  String? solarTermOf(DateTime date) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    const solarTerms = {
      '2026-03-20': '春分',
      '2026-04-04': '清明',
      '2026-04-20': '谷雨',
      '2026-05-05': '立夏',
      '2026-05-21': '小满',
      '2026-06-05': '芒种',
      '2026-06-21': '夏至',
      '2026-07-07': '小暑',
      '2026-07-22': '大暑',
      '2026-08-07': '立秋',
      '2026-08-23': '处暑',
      '2026-09-07': '白露',
      '2026-09-23': '秋分',
      '2026-10-08': '寒露',
      '2026-10-23': '霜降',
      '2026-11-07': '立冬',
      '2026-11-22': '小雪',
      '2026-12-07': '大雪',
      '2026-12-21': '冬至',
    };
    return solarTerms[key];
  }

  String? festivalOf(DateTime date, [LunarInfo? lunarInfo]) {
    if (date.month == 1 && date.day == 1) {
      return '元旦';
    }
    if (date.month == 2 && date.day == 14) {
      return '情人节';
    }
    if (date.month == 5 && date.day == 1) {
      return '劳动节';
    }
    if (date.month == 10 && date.day == 1) {
      return '国庆节';
    }

    if (lunarInfo != null) {
      if (lunarInfo.month == 1 && lunarInfo.day == 1) {
        return '春节';
      }
      if (lunarInfo.month == 1 && lunarInfo.day == 15) {
        return '元宵节';
      }
      if (lunarInfo.month == 5 && lunarInfo.day == 5) {
        return '端午节';
      }
      if (lunarInfo.month == 8 && lunarInfo.day == 15) {
        return '中秋节';
      }
    }
    return null;
  }
}
