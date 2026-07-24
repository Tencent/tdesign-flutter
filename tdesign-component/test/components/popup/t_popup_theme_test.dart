import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_theme_data.dart';

/// TPopupThemeData 纯函数覆盖（merge / copyWith / lerp），用于提升覆盖率。
void main() {
  group('TPopupThemeData 纯函数', () {
    const theme = TPopupThemeData(
      barrierColor: Colors.black54,
      barrierOpacity: 0.5,
      transitionDuration: Duration(milliseconds: 300),
      panelRadius: 8,
      panelBackgroundColor: Colors.white,
    );

    test('merge other 优先', () {
      const other = TPopupThemeData(
        barrierColor: Colors.black38,
        panelRadius: 12,
      );
      final merged = theme.merge(other);
      expect(merged, isA<TPopupThemeData>());
      expect(merged.barrierColor, Colors.black38);
      expect(merged.panelRadius, 12);
      expect(merged.panelBackgroundColor, Colors.white);
    });

    test('merge null 返回 this', () {
      expect(theme.merge(null), theme);
    });

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        barrierOpacity: 0.8,
        panelBackgroundColor: Colors.blue,
      );
      expect(copied, isA<TPopupThemeData>());
      expect(copied.barrierOpacity, 0.8);
      expect(copied.panelBackgroundColor, Colors.blue);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TPopupThemeData', () {
      const other = TPopupThemeData(
        barrierColor: Colors.black12,
        barrierOpacity: 0.2,
        panelRadius: 16,
        panelBackgroundColor: Colors.blue,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TPopupThemeData>());
      expect(atHalf, isA<TPopupThemeData>());
      expect(at1, isA<TPopupThemeData>());
      expect(atHalf.panelRadius, 12);
      expect(at1.panelRadius, 16);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });

    test('lerpDouble 静态方法', () {
      expect(TPopupThemeData.lerpDouble(0, 10, 0.5), 5);
      expect(TPopupThemeData.lerpDouble(null, null, 0.5), isNull);
      expect(TPopupThemeData.lerpDouble(10, null, 0.5), 5);
    });
  });
}
