import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 theme 扩展 getter 和 Font.withSize 方法
void main() {
  group('TBoxShadows extension', () {
    test('shadow1 从 defaultData 返回非 null', () {
      final theme = TThemeData.defaultData();
      expect(theme.shadow1, isNotNull);
      expect(theme.shadow1, hasLength(3));
      expect(theme.shadow1!.first.offset, const Offset(0, 1));
      expect(theme.shadow1!.first.blurRadius, 10);
      expect(theme.shadow4!.single.offset, const Offset(0, 2));

      final dark = theme.dark!;
      expect(dark.shadow1!.first.offset, const Offset(0, 4));
      expect(dark.shadow1!.first.blurRadius, 6);
      expect(dark.shadow3!.first.offset, const Offset(0, 16));
    });
  });

  test('零模糊内阴影以定向 BorderSide 保存亮暗色', () {
    final light = TThemeData.defaultData();
    final dark = light.dark!;
    expect(
      light.shadowInsetTop,
      const BorderSide(color: Color(0xFFDCDCDC), width: 0.5),
    );
    expect(
      dark.shadowInsetBottom,
      const BorderSide(color: Color(0xFF5E5E5E), width: 0.5),
    );
    final overridden = light.copyWith(
      name: 'inset-override',
      insetShadowMap: {
        'shadowInsetTop': const BorderSide(color: Colors.red, width: 1),
      },
    );
    expect(overridden.shadowInsetTop?.color, Colors.red);
    expect(overridden.shadowInsetRight, light.shadowInsetRight);
  });

  group('TSpacers extension', () {
    test('间距等级使用逻辑像素默认值', () {
      final theme = TThemeData.defaultData();
      expect(theme.spacer, 8);
      expect(theme.spacer1, 12);
      expect(theme.spacer2, 16);
      expect(theme.spacer3, 24);
      expect(theme.spacer4, 32);
      expect(theme.spacer5, 48);
      expect(theme.spacer6, 80);
    });
  });

  group('TFonts extension', () {
    testWidgets('TText 默认字体跟随独立字号和行高 Token', (tester) async {
      final token = TThemeData.defaultData().copyWith(
        name: 'text-metric-override',
        fontMetricMap: {'fontSizeBodyMedium': 19, 'lineHeightBodyMedium': 29},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: const Scaffold(body: TText('字体 Token')),
        ),
      );
      final text = tester.widget<Text>(find.text('字体 Token'));
      expect(text.style?.fontSize, 19);
      expect(text.style?.height, 29 / 19);
    });

    test('字体族保留 Flutter 字体回退列表', () {
      final theme = TThemeData.defaultData();
      expect(theme.fontFamily?.fontFamily, 'PingFang SC');
      expect(theme.fontFamily?.fallback, ['Microsoft YaHei', 'Arial Regular']);
      expect(theme.fontFamilyMedium?.fallback?.last, 'Arial Medium');
    });

    test('独立字号与行高覆盖会传递到复合字体', () {
      final base = TThemeData.defaultData();
      expect(base.fontSizeBase, 14);
      expect(base.fontBodyMedium?.size, 14);
      expect(base.fontBodyMedium?.height, 22 / 14);

      final metrics = base.copyWith(
        name: 'font-metric-override',
        fontMetricMap: {
          'fontSizeBodyMedium': 18,
          'lineHeightBodyMedium': 28,
          'fontSizeTitleSmall': 17,
        },
      );
      expect(metrics.fontBodyMedium?.size, 18);
      expect(metrics.fontBodyMedium?.height, 28 / 18);
      expect(metrics.fontSizeBase, 17);

      final composite = metrics.copyWith(
        name: 'font-composite-override',
        fontMap: {'fontBodyMedium': Font(size: 19, lineHeight: 30)},
      );
      expect(composite.fontBodyMedium?.size, 19);
      expect(composite.fontBodyMedium?.height, 30 / 19);
    });

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
