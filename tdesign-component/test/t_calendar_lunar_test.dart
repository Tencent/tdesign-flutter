import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TLunarInfo', () {
    test('should create lunar info correctly', () {
      const lunarInfo = TLunarInfo(
        year: 2025,
        month: 3,
        day: 7,
        yearText: '二〇二五',
        monthText: '三月',
        dayText: '初七',
      );

      expect(lunarInfo.year, 2025);
      expect(lunarInfo.month, 3);
      expect(lunarInfo.day, 7);
      expect(lunarInfo.isLeapMonth, false);
      expect(lunarInfo.yearText, '二〇二五');
      expect(lunarInfo.monthText, '三月');
      expect(lunarInfo.dayText, '初七');
      expect(lunarInfo.fullText, '二〇二五年 三月初七');
    });

    test('should handle leap month correctly', () {
      const lunarInfo = TLunarInfo(
        year: 2025,
        month: 3,
        day: 7,
        isLeapMonth: true,
        yearText: '二〇二五',
        monthText: '闰三月',
        dayText: '初七',
      );

      expect(lunarInfo.isLeapMonth, true);
      expect(lunarInfo.monthText, '闰三月');
      expect(lunarInfo.fullText, '二〇二五年 闰三月初七');
    });

    test('should compare lunar info correctly', () {
      const info1 = TLunarInfo(
        year: 2025,
        month: 3,
        day: 7,
        yearText: '二〇二五',
        monthText: '三月',
        dayText: '初七',
      );

      const info2 = TLunarInfo(
        year: 2025,
        month: 3,
        day: 7,
        yearText: '二〇二五',
        monthText: '三月',
        dayText: '初七',
      );

      const info3 = TLunarInfo(
        year: 2025,
        month: 3,
        day: 8,
        yearText: '二〇二五',
        monthText: '三月',
        dayText: '初八',
      );

      expect(info1, equals(info2));
      expect(info1, isNot(equals(info3)));
      expect(info1.hashCode, equals(info2.hashCode));
    });
  });

  group('TCalendarDataSource', () {
    test('should format year correctly', () {
      final dataSource = _MockDataSource();

      // 阳历
      expect(
        dataSource.formatYear(2025, TCalendarDateType.solar),
        '2025年',
      );

      // 农历
      expect(
        dataSource.formatYear(2025, TCalendarDateType.lunar),
        '二〇二五年',
      );
    });

    test('should format month correctly', () {
      final dataSource = _MockDataSource();

      // 阳历
      expect(
        dataSource.formatMonth(3, TCalendarDateType.solar),
        '3月',
      );

      // 农历
      expect(
        dataSource.formatMonth(1, TCalendarDateType.lunar),
        '正月',
      );
      expect(
        dataSource.formatMonth(3, TCalendarDateType.lunar),
        '三月',
      );
      expect(
        dataSource.formatMonth(11, TCalendarDateType.lunar),
        '冬月',
      );
      expect(
        dataSource.formatMonth(12, TCalendarDateType.lunar),
        '腊月',
      );

      // 闰月
      expect(
        dataSource.formatMonth(3, TCalendarDateType.lunar, true),
        '闰三月',
      );
    });

    test('should format day correctly', () {
      final dataSource = _MockDataSource();

      // 阳历
      expect(
        dataSource.formatDay(7, TCalendarDateType.solar),
        '7日',
      );

      // 农历
      expect(
        dataSource.formatDay(1, TCalendarDateType.lunar),
        '初一',
      );
      expect(
        dataSource.formatDay(7, TCalendarDateType.lunar),
        '初七',
      );
      expect(
        dataSource.formatDay(15, TCalendarDateType.lunar),
        '十五',
      );
      expect(
        dataSource.formatDay(21, TCalendarDateType.lunar),
        '廿一',
      );
      expect(
        dataSource.formatDay(30, TCalendarDateType.lunar),
        '三十',
      );
    });
  });

  group('TDate with LunarInfo', () {
    test('should create TDate with lunar info', () {
      const lunarInfo = TLunarInfo(
        year: 2025,
        month: 3,
        day: 7,
        yearText: '二〇二五',
        monthText: '三月',
        dayText: '初七',
      );

      final tdate = TDate(
        date: DateTime(2025, 4, 5),
        typeNotifier: DateSelectTypeNotifier(DateSelectType.empty),
        isLastDayOfMonth: false,
        lunarInfo: lunarInfo,
      );

      expect(tdate.date, DateTime(2025, 4, 5));
      expect(tdate.lunarInfo, lunarInfo);
      expect(tdate.lunarInfo?.dayText, '初七');
    });

    test('should create TDate without lunar info', () {
      final tdate = TDate(
        date: DateTime(2025, 4, 5),
        typeNotifier: DateSelectTypeNotifier(DateSelectType.empty),
        isLastDayOfMonth: false,
      );

      expect(tdate.date, DateTime(2025, 4, 5));
      expect(tdate.lunarInfo, isNull);
    });
  });
}

/// Mock 数据源用于测试
class _MockDataSource extends TCalendarDataSource {
  @override
  TLunarInfo? getLunarInfo(DateTime solarDate) {
    // 简单的 mock 实现
    return const TLunarInfo(
      year: 2025,
      month: 3,
      day: 7,
      yearText: '二〇二五',
      monthText: '三月',
      dayText: '初七',
    );
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
        return '${lunarInfo.yearText} ${lunarInfo.monthText}${lunarInfo.dayText}';
      }
      return '${date.year}年${date.month}月${date.day}日';
    }
  }
}
