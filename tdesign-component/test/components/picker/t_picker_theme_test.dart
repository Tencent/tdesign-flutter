import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/t_picker_theme_data.dart';

/// TPickerThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  test(
    'unset height interpolates from its effective default in both directions',
    () {
      const unset = TPickerThemeData();
      const custom = TPickerThemeData(height: 240);
      for (final t in [0.0, 0.1, 0.5, 1.0]) {
        expect(unset.lerp(custom, t).height, 200 + 40 * t);
        expect(custom.lerp(unset, t).height, 240 - 40 * t);
        expect(unset.lerp(unset, t).height, isNull);
      }
    },
  );
  group('TPickerThemeData 纯函数', () {
    test('rejects invalid viewport dimensions', () {
      for (final height in [
        0.0,
        -1.0,
        double.infinity,
        double.negativeInfinity,
        double.nan,
      ]) {
        expect(() => TPickerThemeData(height: height), throwsAssertionError);
      }
      for (final count in [0, -1]) {
        expect(() => TPickerThemeData(itemCount: count), throwsAssertionError);
      }
      expect(const TPickerThemeData().height, isNull);
      expect(const TPickerThemeData().itemCount, isNull);
    });
    const theme = TPickerThemeData(height: 200, itemCount: 5);

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(height: 300, itemCount: 7);
      expect(copied, isA<TPickerThemeData>());
      expect(copied.height, 300);
      expect(copied.itemCount, 7);
      // 未覆盖字段保持原值
      expect(copied.height, isNotNull);
      expect(theme.copyWith().height, 200);
      expect(theme.copyWith().itemCount, 5);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TPickerThemeData', () {
      const other = TPickerThemeData(height: 400, itemCount: 9);
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TPickerThemeData>());
      expect(atHalf, isA<TPickerThemeData>());
      expect(at1, isA<TPickerThemeData>());
      // itemCount 在 t<0.5 取 this，t>=0.5 取 other
      expect(atHalf.itemCount, 9);
      expect(at1.itemCount, 9);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });
  });
}
