import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TColors] 扩展的全部 getter（空 colorMap 走默认值分支）。
void main() {
  group('TColors 扩展 getter', () {
    test('全部色值 getter 可访问', () {
      final t = TThemeData.defaultData();

      // 功能色 brand
      t.brandColor1;
      t.brandColor2;
      t.brandColor3;
      t.brandColor4;
      t.brandColor5;
      t.brandColor6;
      t.brandColor7;
      t.brandColor8;
      t.brandColor9;
      t.brandColor10;
      t.brandColorLight;
      t.brandColorLightActive;
      t.brandColorFocus;
      t.brandColorDisabled;
      t.brandColor;
      t.brandColorActive;

      // 错误色 error
      t.errorColor1;
      t.errorColor2;
      t.errorColor3;
      t.errorColor4;
      t.errorColor5;
      t.errorColor6;
      t.errorColor7;
      t.errorColor8;
      t.errorColor9;
      t.errorColor10;
      t.errorColorLight;
      t.errorColorLightActive;
      t.errorColorFocus;
      t.errorColorDisabled;
      t.errorColor;
      t.errorColorActive;

      // 警告色 warning
      t.warningColor1;
      t.warningColor2;
      t.warningColor3;
      t.warningColor4;
      t.warningColor5;
      t.warningColor6;
      t.warningColor7;
      t.warningColor8;
      t.warningColor9;
      t.warningColor10;
      t.warningColorLight;
      t.warningColorLightActive;
      t.warningColorFocus;
      t.warningColorDisabled;
      t.warningColor;
      t.warningColorActive;

      // 成功色 success
      t.successColor1;
      t.successColor2;
      t.successColor3;
      t.successColor4;
      t.successColor5;
      t.successColor6;
      t.successColor7;
      t.successColor8;
      t.successColor9;
      t.successColor10;
      t.successColorLight;
      t.successColorLightActive;
      t.successColorFocus;
      t.successColorDisabled;
      t.successColor;
      t.successColorActive;

      // 文字灰/白
      t.fontGray1;
      t.fontGray2;
      t.fontGray3;
      t.fontGray4;
      t.fontWhite1;
      t.fontWhite2;
      t.fontWhite3;
      t.fontWhite4;

      // 中性面板灰
      t.whiteColor1;
      t.grayColor1;
      t.grayColor2;
      t.grayColor3;
      t.grayColor4;
      t.grayColor5;
      t.grayColor6;
      t.grayColor7;
      t.grayColor8;
      t.grayColor9;
      t.grayColor10;
      t.grayColor11;
      t.grayColor12;
      t.grayColor13;
      t.grayColor14;

      // 组件背景/边框/文字
      t.bgColorPage;
      t.bgColorContainer;
      t.bgColorContainerActive;
      t.bgColorSecondaryContainer;
      t.bgColorSecondaryContainerActive;
      t.bgColorSecondaryComponent;
      t.bgColorSecondaryComponentActive;
      t.bgColorSpecialComponent;
      t.bgColorComponent;
      t.bgColorComponentActive;
      t.bgColorComponentDisabled;
      t.componentStroke;
      t.componentBorder;
      t.textColorPrimary;
      t.textColorSecondary;
      t.textColorPlaceholder;
      t.textColorDisabled;
      t.textColorAnti;
      t.textColorBrand;
      t.textColorLink;
      t.maskActive;
      t.maskDisabled;
      t.maskBackground;
      t.tableShadowColor;
      t.scrollbarColor;
      t.scrollbarHoverColor;
      t.scrollTrackColor;

      // 抽样断言确保确实取到颜色
      expect(t.brandColor, isA<Color>());
      expect(t.errorColor, isA<Color>());
      expect(t.warningColor, isA<Color>());
      expect(t.successColor, isA<Color>());
      expect(t.textColorPrimary, isA<Color>());
      expect(t.bgColorContainer, isA<Color>());
    });

    test('浅色背景和文字引用上游 Token，直接覆盖优先', () {
      final base = TThemeData.defaultData();
      final customized =
          base.copyWith(
                colorMap: {
                  'fontWhite1': Colors.green,
                  'brandColor': Colors.orange,
                },
              )
              as TThemeData;

      expect(customized.bgColorContainer, Colors.green);
      expect(customized.textColorAnti, Colors.green);
      expect(customized.textColorBrand, Colors.orange);
      expect(customized.textColorLink, Colors.orange);

      final direct =
          customized.copyWith(
                colorMap: {
                  'bgColorContainer': Colors.red,
                  'textColorAnti': Colors.blue,
                  'textColorBrand': Colors.purple,
                  'textColorLink': Colors.teal,
                },
              )
              as TThemeData;
      expect(direct.bgColorContainer, Colors.red);
      expect(direct.textColorAnti, Colors.blue);
      expect(direct.textColorBrand, Colors.purple);
      expect(direct.textColorLink, Colors.teal);
    });

    test('暗色反色文字与品牌文字保持各自的引用链', () {
      final base = TThemeData.defaultData().dark!;
      final customized =
          base.copyWith(
                colorMap: {
                  'fontWhite1': Colors.green,
                  'brandColor': Colors.orange,
                  'primaryColor8': Colors.purple,
                },
              )
              as TThemeData;

      expect(customized.textColorAnti, Colors.green);
      expect(customized.textColorBrand, Colors.purple);
      expect(customized.textColorLink, Colors.purple);
      expect(customized.bgColorContainer, base.grayColor13);

      final direct =
          customized.copyWith(
                colorMap: {
                  'textColorAnti': Colors.blue,
                  'textColorBrand': Colors.red,
                  'textColorLink': Colors.teal,
                },
              )
              as TThemeData;
      expect(direct.textColorAnti, Colors.blue);
      expect(direct.textColorBrand, Colors.red);
      expect(direct.textColorLink, Colors.teal);
    });

    test('三个组件背景全局 Token 均可按名称读取与覆盖', () {
      final light = TThemeData.defaultData();
      final dark = light.dark!;
      expect(light.bgColorSecondaryComponent, light.grayColor4);
      expect(light.bgColorSecondaryComponentActive, light.grayColor6);
      expect(light.bgColorSpecialComponent, Colors.white);
      expect(dark.bgColorSecondaryComponent, dark.grayColor10);
      expect(dark.bgColorSecondaryComponentActive, dark.grayColor8);
      expect(dark.bgColorSpecialComponent, Colors.transparent);

      final customized =
          light.copyWith(
                colorMap: {
                  'bgColorSecondaryComponent': Colors.red,
                  'bgColorSecondaryComponentActive': Colors.blue,
                  'bgColorSpecialComponent': Colors.green,
                },
              )
              as TThemeData;
      expect(customized.bgColorSecondaryComponent, Colors.red);
      expect(customized.bgColorSecondaryComponentActive, Colors.blue);
      expect(customized.bgColorSpecialComponent, Colors.green);
    });

    test('默认主题灰阶保留已确认的设计稿浅色 grayColor3 例外', () {
      final light = TThemeData.defaultData();
      final dark = light.dark!;
      const expected = <Color>[
        Color(0xFFF3F3F3),
        Color(0xFFEEEEEE),
        Color(0xFFE8E8E8),
        Color(0xFFDCDCDC),
        Color(0xFFC5C5C5),
        Color(0xFFA6A6A6),
        Color(0xFF8B8B8B),
        Color(0xFF777777),
        Color(0xFF5E5E5E),
        Color(0xFF4B4B4B),
        Color(0xFF383838),
        Color(0xFF2C2C2C),
        Color(0xFF242424),
        Color(0xFF181818),
      ];
      const darkExpected = <Color>[
        Color(0xFFF3F3F3),
        Color(0xFFEEEEEE),
        Color(0xFFE8E8E8),
        Color(0xFFDDDDDD),
        Color(0xFFC6C6C6),
        Color(0xFFA6A6A6),
        Color(0xFF8B8B8B),
        Color(0xFF777777),
        Color(0xFF5E5E5E),
        Color(0xFF4B4B4B),
        Color(0xFF383838),
        Color(0xFF2C2C2C),
        Color(0xFF242424),
        Color(0xFF181818),
      ];

      List<Color> grayColors(TThemeData theme) => <Color>[
        theme.grayColor1,
        theme.grayColor2,
        theme.grayColor3,
        theme.grayColor4,
        theme.grayColor5,
        theme.grayColor6,
        theme.grayColor7,
        theme.grayColor8,
        theme.grayColor9,
        theme.grayColor10,
        theme.grayColor11,
        theme.grayColor12,
        theme.grayColor13,
        theme.grayColor14,
      ];

      expect(grayColors(light), expected);
      expect(grayColors(dark), darkExpected);
      expect(light.bgColorComponent, light.grayColor3);
      expect(light.bgColorContainerActive, light.grayColor3);
      expect(light.borderLevel1Color, light.grayColor3);
      expect(light.componentStroke, light.grayColor3);
      expect(light.bgColorPage, const Color(0xFFF3F3F3));
      expect(light.textColorLink, const Color(0xFF0052D9));
      expect(dark.bgColorContainerActive, const Color(0xFF2C2C2C));
      expect(dark.bgColorComponentActive, const Color(0xFF4B4B4B));
      expect(dark.bgColorSecondaryContainerActive, const Color(0xFF383838));
      expect(dark.textColorAnti, const Color(0xE6FFFFFF));
      expect(light.brandColorFocus, light.brandColor1);
      expect(dark.brandColorFocus, dark.brandColor1);
      expect(dark.warningColorActive, dark.warningColor4);
      expect(dark.errorColorActive, dark.errorColor5);
      expect(dark.successColorActive, dark.successColor4);
      expect(light.maskActive, const Color(0x99000000));
      expect(dark.maskActive, const Color(0x66000000));
      expect(light.tableShadowColor, const Color(0x14000000));
      expect(dark.tableShadowColor, const Color(0x8C000000));
      expect(light.scrollbarColor, const Color(0x1A000000));
      expect(dark.scrollbarColor, const Color(0x1AFFFFFF));
      expect(light.fontTitleSmall?.fontWeight, FontWeight.w600);
      expect(dark.fontTitleSmall?.fontWeight, FontWeight.w600);
    });
  });
}
