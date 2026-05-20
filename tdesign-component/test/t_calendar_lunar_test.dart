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
      expect(lunarInfo.fullText, '二〇二五年 三月初七');
    });
  });

  group('TCalendarDataSource', () {
    test('getSubtitle 默认返回 null', () {
      final dataSource = _MockDataSource();
      expect(dataSource.getSubtitle(DateTime(2025, 6, 15)), isNull);
    });

    test('getSubtitle 可返回自定义副标题', () {
      final dataSource = _SubtitleDataSource();
      expect(
        dataSource.getSubtitle(DateTime(2025, 6, 15)),
        '初七',
      );
    });
  });

  group('TCalendarCellModel', () {
    test('selectType 随 typeNotifier 更新', () {
      final cell = TCalendarCellModel(
        date: DateTime(2025, 6, 15),
        typeNotifier: DateSelectTypeNotifier(DateSelectType.empty),
        isLastDayOfMonth: false,
      );

      expect(cell.selectType, DateSelectType.empty);
      cell.typeNotifier.setType(DateSelectType.selected);
      expect(cell.selectType, DateSelectType.selected);
    });
  });
}

class _MockDataSource extends TCalendarDataSource {}

class _SubtitleDataSource extends TCalendarDataSource {
  @override
  String? getSubtitle(DateTime date) => '初七';
}
