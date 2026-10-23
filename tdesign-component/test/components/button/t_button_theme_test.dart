import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TButtonThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  _perSizeThemeTests();
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

void _perSizeThemeTests() {
  const a = TButtonThemeData();
  const b = TButtonThemeData(
    largeIconSize: 30,
    mediumIconSize: 26,
    smallIconSize: 22,
    extraSmallIconSize: 20,
  );
  test(
    'per-size icon null/default, copy and interrupted transitions retain actual fallback',
    () {
      final unchanged = a.lerp(a, .5);
      expect([
        unchanged.largeIconSize,
        unchanged.mediumIconSize,
        unchanged.smallIconSize,
        unchanged.extraSmallIconSize,
      ], everyElement(isNull));
      for (final size in TButtonSize.values) {
        final end = [30.0, 26.0, 22.0, 20.0][size.index];
        final fallback = [28.0, 23.0, 18.0, 18.0][size.index];
        for (final t in [0.0, .25, 1.0]) {
          expect(
            a.lerp(b, t).resolveIconSize(size, fallback),
            fallback + (end - fallback) * t,
          );
          expect(
            b.lerp(a, t).resolveIconSize(size, fallback),
            end + (fallback - end) * t,
          );
        }
        final mid = a.lerp(b, .5);
        expect(
          mid.copyWith(iconTextSpacing: 9).resolveIconSize(size, fallback),
          (fallback + end) / 2,
        );
        expect(
          mid.lerp(a, .5).resolveIconSize(size, fallback),
          fallback + (end - fallback) / 4,
        );
        expect(b.lerp(b, .5).resolveIconSize(size, fallback), end);
        expect(unchanged.resolveIconSize(size, fallback), fallback);
      }
      final copy = a.copyWith(
        largeIconSize: 33,
        mediumIconSize: 29,
        smallIconSize: 25,
        extraSmallIconSize: 23,
      );
      expect(
        [
          copy.largeIconSize,
          copy.mediumIconSize,
          copy.smallIconSize,
          copy.extraSmallIconSize,
        ],
        [33, 29, 25, 23],
      );
      final overridden = a
          .lerp(b, .5)
          .copyWith(
            largeIconSize: 33,
            mediumIconSize: 29,
            smallIconSize: 25,
            extraSmallIconSize: 23,
          );
      for (final size in TButtonSize.values) {
        expect(
          overridden.resolveIconSize(size, 18),
          [33, 29, 25, 23][size.index],
        );
      }
      expect(b.copyWith().largeIconSize, 30);
    },
  );
  test('icon sizes reject negative, infinite and NaN values', () {
    for (final invalid in [-1.0, double.infinity, double.nan]) {
      expect(
        () => TButtonThemeData(largeIconSize: invalid),
        throwsAssertionError,
      );
      expect(
        () => TButtonThemeData(mediumIconSize: invalid),
        throwsAssertionError,
      );
      expect(
        () => TButtonThemeData(smallIconSize: invalid),
        throwsAssertionError,
      );
      expect(
        () => TButtonThemeData(extraSmallIconSize: invalid),
        throwsAssertionError,
      );
    }
  });
}
