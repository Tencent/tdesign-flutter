import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/backtop/t_backtop_theme_data.dart';

/// TBackTopThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TBackTopThemeData 纯函数', () {
    const theme = TBackTopThemeData(
      backgroundColor: Colors.red,
      borderColor: Colors.redAccent,
      contentColor: Colors.white,
      roundSize: 48,
      halfCircleHeight: 40,
      halfCircleMinWidth: 38,
      iconSize: 20,
      borderWidth: 0.5,
      halfCircleHorizontalPadding: 8,
      contentGap: 2,
      textStyle: TextStyle(fontSize: 10),
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(roundSize: 56, iconSize: 24);
      expect(copied, isA<TBackTopThemeData>());
      expect(copied.roundSize, 56);
      expect(copied.iconSize, 24);
      expect(copied.backgroundColor, Colors.red);
    });

    test('copyWith cover remaining fields', () {
      final copied = theme.copyWith(
        backgroundColor: Colors.blue,
        borderColor: Colors.blueAccent,
        contentColor: Colors.black,
        halfCircleHeight: 44,
        halfCircleMinWidth: 42,
        borderWidth: 1,
        halfCircleHorizontalPadding: 10,
        contentGap: 4,
        textStyle: const TextStyle(fontSize: 12),
      );
      expect(copied.backgroundColor, Colors.blue);
      expect(copied.borderColor, Colors.blueAccent);
      expect(copied.contentColor, Colors.black);
      expect(copied.halfCircleHeight, 44);
      expect(copied.halfCircleMinWidth, 42);
      expect(copied.borderWidth, 1);
      expect(copied.halfCircleHorizontalPadding, 10);
      expect(copied.contentGap, 4);
      expect(copied.textStyle?.fontSize, 12);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TBackTopThemeData', () {
      const other = TBackTopThemeData(roundSize: 56, iconSize: 24);
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TBackTopThemeData>());
      expect(atHalf, isA<TBackTopThemeData>());
      expect(at1, isA<TBackTopThemeData>());
      expect(atHalf.roundSize, 52);
      expect(at1.roundSize, 56);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });

    test('lerp cover remaining fields', () {
      const other = TBackTopThemeData(
        backgroundColor: Colors.blue,
        borderColor: Colors.blueAccent,
        contentColor: Colors.black,
        halfCircleHeight: 48,
        halfCircleMinWidth: 46,
        iconSize: 24,
        borderWidth: 1.5,
        halfCircleHorizontalPadding: 12,
        contentGap: 6,
        textStyle: TextStyle(fontSize: 14),
      );
      final lerped = theme.lerp(other, 0.5);
      expect(lerped.backgroundColor, Color.lerp(Colors.red, Colors.blue, .5));
      expect(
        lerped.borderColor,
        Color.lerp(Colors.redAccent, Colors.blueAccent, .5),
      );
      expect(lerped.contentColor, Color.lerp(Colors.white, Colors.black, .5));
      expect(lerped.halfCircleHeight, 44);
      expect(lerped.halfCircleMinWidth, 42);
      expect(lerped.iconSize, 22);
      expect(lerped.borderWidth, 1);
      expect(lerped.halfCircleHorizontalPadding, 10);
      expect(lerped.contentGap, 4);
      expect(lerped.textStyle?.fontSize, 12);
    });

    test('lerp 双空保持空，一侧空不制造透明颜色', () {
      const empty = TBackTopThemeData();
      const explicit = TBackTopThemeData(
        backgroundColor: Colors.red,
        roundSize: 56,
      );
      final beforeSwitch = empty.lerp(explicit, 0.25);
      final afterSwitch = empty.lerp(explicit, 0.75);
      expect(beforeSwitch.backgroundColor, isNull);
      expect(afterSwitch.backgroundColor, Colors.red);
      expect(beforeSwitch.roundSize, 50);
      expect(afterSwitch.roundSize, 54);
      expect(empty.lerp(const TBackTopThemeData(), 0.5).roundSize, isNull);
    });
  });
}
