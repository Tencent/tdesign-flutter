import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:lunar/lunar.dart';

/// 基于 lunar 库的农历数据源实现示例
/// 
/// 使用方法：
/// TCalendar(
///   dateType: TCalendarDateType.lunar,
///   dataSource: LunarDataSourceExample(),
/// )
class LunarDataSourceExample extends TCalendarDataSource {
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
  TLunarInfo? getLunarInfo(DateTime solarDate) {
    try {
      final solar = Solar.fromDate(solarDate);
      final lunar = solar.getLunar();
      
      return TLunarInfo(
        year: lunar.getYear(),
        month: lunar.getMonth().abs(),
        day: lunar.getDay(),
        isLeapMonth: lunar.getMonth() < 0,
        yearText: _convertToChineseNumber(lunar.getYear()),
        monthText: _getLunarMonthName(lunar.getMonth().abs(), lunar.getMonth() < 0),
        dayText: _getLunarDayName(lunar.getDay()),
      );
    } catch (e) {
      print('农历转换错误: $e');
      return null;
    }
  }

  @override
  String formatDate(
    DateTime date,
    TCalendarDateType type, [
    TLunarInfo? lunarInfo,
  ]) {
    if (type == TCalendarDateType.solar) {
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
    // 节气功能暂未实现
    // lunar 包的不同版本 API 可能不同
    // 可以使用专门的节气计算库或查表法
    
    // 以下是 2026 年部分节气示例数据（仅用于演示）
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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

  @override
  String? getFestival(DateTime date, [TLunarInfo? lunarInfo]) {
    // 阳历节日
    if (date.month == 1 && date.day == 1) return '元旦';
    if (date.month == 2 && date.day == 14) return '情人节';
    if (date.month == 3 && date.day == 8) return '妇女节';
    if (date.month == 5 && date.day == 1) return '劳动节';
    if (date.month == 5 && date.day == 4) return '青年节';
    if (date.month == 6 && date.day == 1) return '儿童节';
    if (date.month == 7 && date.day == 1) return '建党节';
    if (date.month == 8 && date.day == 1) return '建军节';
    if (date.month == 9 && date.day == 10) return '教师节';
    if (date.month == 10 && date.day == 1) return '国庆节';
    if (date.month == 12 && date.day == 25) return '圣诞节';

    // 农历节日
    if (lunarInfo != null) {
      if (lunarInfo.month == 1 && lunarInfo.day == 1) return '春节';
      if (lunarInfo.month == 1 && lunarInfo.day == 15) return '元宵节';
      if (lunarInfo.month == 2 && lunarInfo.day == 2) return '龙抬头';
      if (lunarInfo.month == 5 && lunarInfo.day == 5) return '端午节';
      if (lunarInfo.month == 7 && lunarInfo.day == 7) return '七夕节';
      if (lunarInfo.month == 7 && lunarInfo.day == 15) return '中元节';
      if (lunarInfo.month == 8 && lunarInfo.day == 15) return '中秋节';
      if (lunarInfo.month == 9 && lunarInfo.day == 9) return '重阳节';
      if (lunarInfo.month == 12 && lunarInfo.day == 8) return '腊八节';
      if (lunarInfo.month == 12 && lunarInfo.day == 23) return '小年';
      // 除夕：农历十二月最后一天
      if (lunarInfo.month == 12 && (lunarInfo.day == 29 || lunarInfo.day == 30)) {
        // 需要判断是否是该月最后一天，这里简化处理
        return '除夕';
      }
    }

    return null;
  }

  @override
  Map<String, String>? getHolidayInfo(DateTime date) {
    // 2026 年法定节假日和调休安排（根据国务院发布的实际安排）
    // 这里提供示例数据，实际使用时应根据每年最新公布的假期安排更新
    
    final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    // 法定节假日
    const holidays = {
      // 元旦（2026年1月1-3日放假）
      '2026-01-01': {'type': 'holiday', 'name': '元旦'},
      '2026-01-02': {'type': 'holiday', 'name': '元旦'},
      '2026-01-03': {'type': 'holiday', 'name': '元旦'},
      
      // 春节（假设2026年1月29日-2月4日放假）
      '2026-01-29': {'type': 'holiday', 'name': '春节'},
      '2026-01-30': {'type': 'holiday', 'name': '春节'},
      '2026-01-31': {'type': 'holiday', 'name': '春节'},
      '2026-02-01': {'type': 'holiday', 'name': '春节'},
      '2026-02-02': {'type': 'holiday', 'name': '春节'},
      '2026-02-03': {'type': 'holiday', 'name': '春节'},
      '2026-02-04': {'type': 'holiday', 'name': '春节'},
      
      // 清明节（假设2026年4月4-6日放假）
      '2026-04-04': {'type': 'holiday', 'name': '清明节'},
      '2026-04-05': {'type': 'holiday', 'name': '清明节'},
      '2026-04-06': {'type': 'holiday', 'name': '清明节'},
      
      // 劳动节（假设2026年5月1-5日放假）
      '2026-05-01': {'type': 'holiday', 'name': '劳动节'},
      '2026-05-02': {'type': 'holiday', 'name': '劳动节'},
      '2026-05-03': {'type': 'holiday', 'name': '劳动节'},
      '2026-05-04': {'type': 'holiday', 'name': '劳动节'},
      '2026-05-05': {'type': 'holiday', 'name': '劳动节'},
      
      // 端午节（假设2026年6月25-27日放假）
      '2026-06-25': {'type': 'holiday', 'name': '端午节'},
      '2026-06-26': {'type': 'holiday', 'name': '端午节'},
      '2026-06-27': {'type': 'holiday', 'name': '端午节'},
      
      // 国庆节+中秋节（假设2026年10月1-8日放假）
      '2026-10-01': {'type': 'holiday', 'name': '国庆节'},
      '2026-10-02': {'type': 'holiday', 'name': '国庆节'},
      '2026-10-03': {'type': 'holiday', 'name': '国庆节'},
      '2026-10-04': {'type': 'holiday', 'name': '国庆节'},
      '2026-10-05': {'type': 'holiday', 'name': '国庆节'},
      '2026-10-06': {'type': 'holiday', 'name': '中秋节'},
      '2026-10-07': {'type': 'holiday', 'name': '假期'},
      '2026-10-08': {'type': 'holiday', 'name': '假期'},
    };
    
    // 调休工作日（假设数据，实际需根据国务院通知）
    const workdays = {
      '2026-01-04': {'type': 'workday', 'name': '补班'},
      '2026-01-24': {'type': 'workday', 'name': '补班'},
      '2026-02-07': {'type': 'workday', 'name': '补班'},
      '2026-04-26': {'type': 'workday', 'name': '补班'},
      '2026-09-27': {'type': 'workday', 'name': '补班'},
      '2026-10-10': {'type': 'workday', 'name': '补班'},
    };
    
    return holidays[key] ?? workdays[key];
  }
}
