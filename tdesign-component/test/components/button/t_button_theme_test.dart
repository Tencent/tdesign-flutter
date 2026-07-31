import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/button/t_button_theme_data.dart';
import 'package:tdesign_flutter/src/components/button/t_button_types.dart';

/// TButtonThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TButtonThemeData 纯函数', () {
    const theme = TButtonThemeData(
      defaultVariant: TButtonVariant.fill,
      defaultSize: TButtonSize.medium,
      shape: TButtonShape.round,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      iconTextSpacing: 6,
      gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        defaultVariant: TButtonVariant.outline,
        defaultSize: TButtonSize.large,
        shape: TButtonShape.circle,
        iconTextSpacing: 10,
      );
      expect(copied, isA<TButtonThemeData>());
      expect(copied.defaultVariant, TButtonVariant.outline);
      expect(copied.defaultSize, TButtonSize.large);
      expect(copied.shape, TButtonShape.circle);
      // 未覆盖字段保持原值
      expect(copied.iconTextSpacing, 10);
      expect(copied.padding, theme.padding);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TButtonThemeData', () {
      const other = TButtonThemeData(
        defaultVariant: TButtonVariant.text,
        defaultSize: TButtonSize.small,
        shape: TButtonShape.square,
        iconTextSpacing: 20,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TButtonThemeData>());
      expect(atHalf, isA<TButtonThemeData>());
      expect(at1, isA<TButtonThemeData>());
      // t<0.5 时取 this 的枚举字段（t=0.5 边界归属 other 侧）
      expect(atHalf.defaultVariant, TButtonVariant.text);
      // t>=0.5 时取 other 的枚举字段
      expect(at1.defaultVariant, TButtonVariant.text);
    });

    test('lerp other 非同类型时返回 this', () {
      final result = theme.lerp(null, 0.5);
      expect(result, theme);
    });

    test('effectiveShape 未设置时返回 rectangle', () {
      const bare = TButtonThemeData();
      expect(bare.effectiveShape, TButtonShape.rectangle);
      expect(theme.effectiveShape, TButtonShape.round);
    });

    test('iconTextSpacing 拒绝负数和无穷值', () {
      expect(
        () => TButtonThemeData(iconTextSpacing: -1),
        throwsAssertionError,
      );
      expect(
        () => TButtonThemeData(iconTextSpacing: double.infinity),
        throwsAssertionError,
      );
    });
  });
}
