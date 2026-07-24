import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_theme_data.dart';

/// TCalendarThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TCalendarThemeData 纯函数', () {
    const theme = TCalendarThemeData(
      height: 300,
      decoration: BoxDecoration(color: Colors.white),
      weekdayStyle: TextStyle(fontSize: 12),
      monthTitleStyle: TextStyle(fontSize: 16),
      dayStyle: TextStyle(fontSize: 14),
      todayDayStyle: TextStyle(color: Colors.red),
      cellDecoration: BoxDecoration(color: Colors.blue),
      subtitleStyle: TextStyle(fontSize: 10),
      cellHeight: 60,
      monthTitleHeight: 22,
      verticalGap: 4,
      bodyPadding: 8,
      weekdayGap: 2,
      centreColor: Colors.green,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        height: 400,
      );
      expect(copied, isA<TCalendarThemeData>());
      expect(copied.height, 400);
      // 未覆盖字段保持原值
      expect(copied.centreColor, Colors.green);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TCalendarThemeData', () {
      const other = TCalendarThemeData(
        height: 500,
        weekdayStyle: TextStyle(fontSize: 20),
        centreColor: Colors.purple,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TCalendarThemeData>());
      expect(atHalf, isA<TCalendarThemeData>());
      expect(at1, isA<TCalendarThemeData>());
      expect(atHalf.height, 400);
      expect(at1.height, 500);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });
  });
}
