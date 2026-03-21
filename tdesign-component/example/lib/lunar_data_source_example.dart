import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 基于 lunar 库的农历数据源实现示例
/// 
/// 使用方法：
/// 1. 在 pubspec.yaml 中添加依赖：
///    dependencies:
///      lunar: ^1.5.0
/// 
/// 2. 导入并使用：
///    import 'package:lunar/lunar.dart';
///    
///    TDCalendar(
///      dateType: TDCalendarDateType.lunar,
///      dataSource: LunarDataSourceExample(),
///    )
/// 
/// 注意：此示例需要 lunar 包，实际使用时需要先安装该包。
class LunarDataSourceExample extends TDCalendarDataSource {
  /// 将数字转换为中文数字
  static String _convertToChineseNumber(int number) {
    const digits = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    return number
        .toString()
        .split('')
        .map((d) => digits[int.parse(d)])
        .join();
  }

  /// 获取农历月份中文名称
  static String _getLunarMonthName(int month, bool isLeapMonth) {
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

  /// 获取农历日期中文名称
  static String _getLunarDayName(int day) {
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

  @override
  TDLunarInfo? getLunarInfo(DateTime solarDate) {
    // 使用 lunar 包转换
    // 实际实现时需要导入 lunar 包：
    // import 'package:lunar/lunar.dart';
    // 
    // final solar = Solar.fromDate(solarDate);
    // final lunar = solar.getLunar();
    // 
    // return TDLunarInfo(
    //   year: lunar.getYear(),
    //   month: lunar.getMonth().abs(),
    //   day: lunar.getDay(),
    //   isLeapMonth: lunar.getMonth() < 0,
    //   yearText: _convertToChineseNumber(lunar.getYear()),
    //   monthText: _getLunarMonthName(lunar.getMonth().abs(), lunar.getMonth() < 0),
    //   dayText: _getLunarDayName(lunar.getDay()),
    // );

    // 这里返回 null，实际使用时请按上面注释实现
    return null;
  }

  @override
  String formatDate(
    DateTime date,
    TDCalendarDateType type, [
    TDLunarInfo? lunarInfo,
  ]) {
    if (type == TDCalendarDateType.solar) {
      return '${date.year}年${date.month}月${date.day}日';
    } else {
      if (lunarInfo != null) {
        return '${lunarInfo.yearText}年 ${lunarInfo.monthText}${lunarInfo.dayText}';
      }
      return '${date.year}年${date.month}月${date.day}日';
    }
  }

  @override
  String? getSolarTerm(DateTime date) {
    // 使用 lunar 包获取节气
    // 实际实现时：
    // final solar = Solar.fromDate(date);
    // final jieQi = solar.getJieQi();
    // return jieQi.isEmpty ? null : jieQi;
    
    return null;
  }

  @override
  String? getFestival(DateTime date, [TDLunarInfo? lunarInfo]) {
    // 可以根据阳历和农历判断节日
    // 阳历节日
    if (date.month == 1 && date.day == 1) return '元旦';
    if (date.month == 5 && date.day == 1) return '劳动节';
    if (date.month == 10 && date.day == 1) return '国庆节';

    // 农历节日
    if (lunarInfo != null) {
      if (lunarInfo.month == 1 && lunarInfo.day == 1) return '春节';
      if (lunarInfo.month == 1 && lunarInfo.day == 15) return '元宵节';
      if (lunarInfo.month == 5 && lunarInfo.day == 5) return '端午节';
      if (lunarInfo.month == 8 && lunarInfo.day == 15) return '中秋节';
    }

    return null;
  }
}
