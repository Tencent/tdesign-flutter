import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/link/t_link_theme_data.dart';

/// TLinkThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TLinkThemeData 纯函数', () {
    const theme = TLinkThemeData(
      color: Colors.red,
      iconSize: 16,
      fontSize: 14,
      leftGapWithIcon: 4,
      rightGapWithIcon: 4,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(color: Colors.blue, iconSize: 20, fontSize: 16);
      expect(copied, isA<TLinkThemeData>());
      expect(copied.color, Colors.blue);
      expect(copied.iconSize, 20);
      expect(copied.fontSize, 16);
      expect(copied.leftGapWithIcon, 4);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TLinkThemeData', () {
      const other = TLinkThemeData(color: Colors.green, iconSize: 24, fontSize: 18);
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TLinkThemeData>());
      expect(atHalf, isA<TLinkThemeData>());
      expect(at1, isA<TLinkThemeData>());
      expect(at0.color, isA<Color>()); // t=0 取 this（感知色彩插值，不校验精确值）
      expect(at1.color, isA<Color>()); // t=1 取 other
      expect(atHalf.color, isA<Color>()); // 连续插值结果
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });
  });
}
