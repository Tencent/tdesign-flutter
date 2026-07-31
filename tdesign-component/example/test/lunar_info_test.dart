import 'package:flutter_test/flutter_test.dart';

import 'package:tdesign_flutter_example/lunar_info.dart';

void main() {
  group('LunarInfo (example)', () {
    test('creates and formats fullText', () {
      const lunarInfo = LunarInfo(
        year: 2025,
        month: 3,
        day: 7,
        yearText: '二〇二五',
        monthText: '三月',
        dayText: '初七',
      );

      expect(lunarInfo.year, 2025);
      expect(lunarInfo.fullText, '二〇二五年 三月初七');
    });
  });
}
