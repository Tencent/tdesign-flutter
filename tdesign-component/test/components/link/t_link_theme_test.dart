import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TLinkThemeData', () {
    const theme = TLinkThemeData(
      defaultSize: TLinkSize.small,
      defaultColorScheme: TLinkColorScheme.primary,
      underline: true,
      textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      iconSize: 16,
      iconGap: 4,
    );

    test('copyWith 仅覆盖显式字段', () {
      final copied = theme.copyWith(
        defaultSize: TLinkSize.large,
        textStyle: const TextStyle(color: Colors.blue),
        iconGap: 8,
      );

      expect(copied.defaultSize, TLinkSize.large);
      expect(copied.defaultColorScheme, TLinkColorScheme.primary);
      expect(copied.underline, isTrue);
      expect(copied.textStyle?.color, Colors.blue);
      expect(copied.iconSize, 16);
      expect(copied.iconGap, 8);
    });

    test('lerp 插值视觉字段并切换离散字段', () {
      const other = TLinkThemeData(
        defaultSize: TLinkSize.large,
        defaultColorScheme: TLinkColorScheme.danger,
        underline: false,
        textStyle: TextStyle(color: Colors.blue),
        iconSize: 24,
        iconGap: 12,
      );

      final atStart = theme.lerp(other, 0);
      final atEnd = theme.lerp(other, 1);
      expect(atStart.defaultSize, TLinkSize.small);
      expect(atStart.underline, isTrue);
      expect(atStart.iconSize, 16);
      expect(atEnd.defaultSize, TLinkSize.large);
      expect(atEnd.defaultColorScheme, TLinkColorScheme.danger);
      expect(atEnd.underline, isFalse);
      expect(atEnd.iconSize, 24);
      expect(atEnd.iconGap, 12);
    });

    test('lerp 非同类型时返回当前主题', () {
      expect(theme.lerp(null, 0.5), same(theme));
    });
  });
}
