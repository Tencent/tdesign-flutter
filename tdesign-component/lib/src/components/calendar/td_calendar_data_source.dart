import 'td_lunar_date.dart';

/// 日历数据源接口
/// 
/// 开发者需要实现此接口来提供农历转换能力。
/// 组件内部不包含农历算法和数据，完全依赖外部实现。
abstract class TDCalendarDataSource {
  /// 获取指定阳历日期的农历信息
  /// 
  /// [solarDate] 阳历日期
  /// 
  /// 返回 null 表示不显示农历信息
  TDLunarInfo? getLunarInfo(DateTime solarDate);

  /// 格式化日期文本
  /// 
  /// [date] 阳历日期
  /// [type] 日历类型
  /// [lunarInfo] 农历信息（可选）
  /// 
  /// 返回格式化后的日期字符串
  String formatDate(
    DateTime date,
    TDCalendarDateType type, [
    TDLunarInfo? lunarInfo,
  ]);

  /// 获取节气信息（可选实现）
  /// 
  /// [date] 阳历日期
  /// 
  /// 返回节气名称，如"春分"、"秋分"等，无节气则返回 null
  String? getSolarTerm(DateTime date) => null;

  /// 获取节日信息（可选实现）
  /// 
  /// [date] 阳历日期
  /// [lunarInfo] 农历信息（可选）
  /// 
  /// 返回节日名称，如"春节"、"中秋节"等，无节日则返回 null
  String? getFestival(DateTime date, [TDLunarInfo? lunarInfo]) => null;

  /// 获取假期信息（可选实现）
  /// 
  /// [date] 阳历日期
  /// 
  /// 返回假期类型和名称：
  /// - 'holiday': 法定节假日/公共假期（如"国庆节"）
  /// - 'workday': 调休工作日（如"补班"）
  /// - null: 正常日期
  /// 
  /// 示例返回值：
  /// - {'type': 'holiday', 'name': '国庆节'}
  /// - {'type': 'workday', 'name': '补班'}
  /// - null
  Map<String, String>? getHolidayInfo(DateTime date) => null;

  /// 格式化年份文本
  /// 
  /// [year] 年份
  /// [type] 日历类型
  /// 
  /// 返回格式化后的年份字符串
  /// 阳历示例：2025 -> "2025年"
  /// 阴历示例：2025 -> "二〇二五年"
  String formatYear(int year, TDCalendarDateType type) {
    if (type == TDCalendarDateType.solar) {
      return '$year年';
    }
    return '${_convertToChineseNumber(year)}年';
  }

  /// 格式化月份文本
  /// 
  /// [month] 月份（1-12）
  /// [type] 日历类型
  /// [isLeapMonth] 是否是闰月（仅农历有效）
  /// 
  /// 返回格式化后的月份字符串
  /// 阳历示例：3 -> "3月"
  /// 阴历示例：3 -> "三月"，闰3月 -> "闰三月"
  String formatMonth(int month, TDCalendarDateType type,
      [bool isLeapMonth = false]) {
    if (type == TDCalendarDateType.solar) {
      return '$month月';
    }
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

  /// 格式化日期文本
  /// 
  /// [day] 日期（1-31）
  /// [type] 日历类型
  /// 
  /// 返回格式化后的日期字符串
  /// 阳历示例：7 -> "7日"
  /// 阴历示例：7 -> "初七"
  String formatDay(int day, TDCalendarDateType type) {
    if (type == TDCalendarDateType.solar) {
      return '$day日';
    }
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

  /// 将数字转换为中文数字
  String _convertToChineseNumber(int number) {
    const digits = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    return number
        .toString()
        .split('')
        .map((d) => digits[int.parse(d)])
        .join();
  }
}
