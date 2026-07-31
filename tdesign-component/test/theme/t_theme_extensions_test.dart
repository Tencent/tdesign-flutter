import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 theme 扩展 getter 和 Font.withSize 方法
void main() {
  group('TBoxShadows extension', () {
    test('shadowsBase 从 defaultData 返回非 null', () {
      final theme = TThemeData.defaultData();
      expect(theme.shadowsBase, isNotNull);
    });
  });

  group('TSpacers extension', () {
    test('spacer40 返回默认值', () {
      final theme = TThemeData.defaultData();
      // 默认数据中应有 spacer40，若没有则走 ?? 40.0
      expect(theme.spacer40, isA<double>());
    });

    test('spacer64 返回默认值', () {
      final theme = TThemeData.defaultData();
      expect(theme.spacer64, isA<double>());
    });

    test('spacer96 返回默认值', () {
      final theme = TThemeData.defaultData();
      expect(theme.spacer96, isA<double>());
    });

    test('spacer160 返回默认值', () {
      final theme = TThemeData.defaultData();
      expect(theme.spacer160, isA<double>());
    });
  });

  group('TFonts extension', () {
    test('fontDisplayLarge getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontDisplayLarge, isNotNull);
    });

    test('fontDisplayMedium getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontDisplayMedium, isNotNull);
    });

    test('fontHeadlineLarge getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontHeadlineLarge, isNotNull);
    });

    test('fontHeadlineMedium getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontHeadlineMedium, isNotNull);
    });

    test('fontHeadlineSmall getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontHeadlineSmall, isNotNull);
    });

    test('fontMarkLarge getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontMarkLarge, isNotNull);
    });

    test('fontLinkLarge getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontLinkLarge, isNotNull);
    });

    test('fontLinkMedium getter', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontLinkMedium, isNotNull);
    });
  });

  group('FontExtensions.withSize', () {
    test('withSize 按比例计算新 lineHeight', () {
      final font = Font(size: 16, lineHeight: 24, fontWeight: FontWeight.w700);
      final resized = font.withSize(32);
      expect(resized.size, 32.0);
      // height = lineHeight / size = 24/16 = 1.5, withSize 不改变 height 比例
      expect(resized.height, 1.5);
      expect(resized.fontWeight, FontWeight.w700);
    });

    test('withSize 保持 fontWeight', () {
      final font = Font(size: 12, lineHeight: 20, fontWeight: FontWeight.w400);
      final resized = font.withSize(24);
      expect(resized.fontWeight, FontWeight.w400);
    });
  });
}
