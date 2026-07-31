import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_theme_data.dart';

/// TStepsThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TStepsThemeData 纯函数', () {
    const theme = TStepsThemeData(
      simple: false,
      readOnly: false,
      verticalSelect: false,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(simple: true, readOnly: true);
      expect(copied, isA<TStepsThemeData>());
      expect(copied.simple, true);
      expect(copied.readOnly, true);
      expect(copied.verticalSelect, false);
    });

    test('copyWith cover verticalSelect', () {
      final copied = theme.copyWith(verticalSelect: true);
      expect(copied.verticalSelect, true);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TStepsThemeData', () {
      const other = TStepsThemeData(simple: true, readOnly: true, verticalSelect: true);
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TStepsThemeData>());
      expect(atHalf, isA<TStepsThemeData>());
      expect(at1, isA<TStepsThemeData>());
      expect(atHalf.simple, true);
      expect(at1.simple, true);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });

    test('lerp cover remaining fields', () {
      const other = TStepsThemeData(
        simple: true,
        readOnly: true,
        verticalSelect: true,
      );
      final lerped = theme.lerp(other, 0.5);
      expect(lerped.simple, true);
      expect(lerped.readOnly, true);
      expect(lerped.verticalSelect, true);
    });
  });
}
