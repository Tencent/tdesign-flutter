import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/sidebar/t_sidebar_theme_data.dart';

/// TSideBarThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TSideBarThemeData 纯函数', () {
    const theme = TSideBarThemeData(
      style: TSideBarVariant.normal,
      height: 50,
      contentPadding: EdgeInsets.all(8),
      selectedColor: Colors.red,
      unSelectedColor: Colors.grey,
      selectedTextStyle: TextStyle(fontSize: 14),
      selectedBgColor: Colors.blue,
      unSelectedBgColor: Colors.white,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        style: TSideBarVariant.outline,
        height: 60,
        selectedColor: Colors.green,
      );
      expect(copied, isA<TSideBarThemeData>());
      expect(copied.style, TSideBarVariant.outline);
      expect(copied.height, 60);
      expect(copied.selectedColor, Colors.green);
      expect(copied.unSelectedColor, Colors.grey);
    });

    test('copyWith cover padding and backgrounds', () {
      final copied = theme.copyWith(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        selectedBgColor: Colors.black,
        unSelectedBgColor: Colors.white,
      );
      expect(copied.contentPadding, const EdgeInsets.symmetric(horizontal: 12));
      expect(copied.selectedBgColor, Colors.black);
      expect(copied.unSelectedBgColor, Colors.white);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TSideBarThemeData', () {
      const other = TSideBarThemeData(
        style: TSideBarVariant.outline,
        height: 80,
        selectedColor: Colors.purple,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TSideBarThemeData>());
      expect(atHalf, isA<TSideBarThemeData>());
      expect(at1, isA<TSideBarThemeData>());
      expect(atHalf.style, TSideBarVariant.outline);
      expect(at1.style, TSideBarVariant.outline);
    });

    test('lerp cover remaining fields', () {
      const other = TSideBarThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        selectedBgColor: Colors.green,
        unSelectedBgColor: Colors.black,
      );
      final lerped = theme.lerp(other, 0.5);
      expect(lerped.contentPadding, isA<EdgeInsetsGeometry>());
      expect(lerped.selectedBgColor, isA<Color>());
      expect(lerped.unSelectedBgColor, isA<Color>());
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });
  });
}
