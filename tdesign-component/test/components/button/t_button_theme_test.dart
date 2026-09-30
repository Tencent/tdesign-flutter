import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/button/t_button_theme_data.dart';

/// TButtonThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TButtonThemeData 纯函数', () {
    const theme = TButtonThemeData(
      iconTextSpacing: 6,
      gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(iconTextSpacing: 10);
      expect(copied, isA<TButtonThemeData>());
      // 未覆盖字段保持原值
      expect(copied.iconTextSpacing, 10);
      expect(copied.gradient, theme.gradient);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TButtonThemeData', () {
      const other = TButtonThemeData(iconTextSpacing: 20);
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TButtonThemeData>());
      expect(atHalf, isA<TButtonThemeData>());
      expect(at1, isA<TButtonThemeData>());
      expect(atHalf.iconTextSpacing, 13);
      expect(at1.iconTextSpacing, 20);
    });

    test('lerp other 非同类型时返回 this', () {
      final result = theme.lerp(null, 0.5);
      expect(result, theme);
    });

    test('iconTextSpacing 拒绝负数和无穷值', () {
      expect(() => TButtonThemeData(iconTextSpacing: -1), throwsAssertionError);
      expect(
        () => TButtonThemeData(iconTextSpacing: double.infinity),
        throwsAssertionError,
      );
    });
  });
}
