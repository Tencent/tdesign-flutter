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
      t.brandLightColor;
      t.brandFocusColor;
      t.brandDisabledColor;
      t.brandHoverColor;
      t.brandNormalColor;
      t.brandClickColor;

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
      t.errorLightColor;
      t.errorFocusColor;
      t.errorDisabledColor;
      t.errorHoverColor;
      t.errorNormalColor;
      t.errorClickColor;

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
      t.warningLightColor;
      t.warningFocusColor;
      t.warningDisabledColor;
      t.warningHoverColor;
      t.warningNormalColor;
      t.warningClickColor;

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
      t.successLightColor;
      t.successFocusColor;
      t.successDisabledColor;
      t.successHoverColor;
      t.successNormalColor;
      t.successClickColor;

      // 文字灰/白
      t.fontGyColor1;
      t.fontGyColor2;
      t.fontGyColor3;
      t.fontGyColor4;
      t.fontWhColor1;
      t.fontWhColor2;
      t.fontWhColor3;
      t.fontWhColor4;

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
      t.bgColorContainerSelect;
      t.bgColorContainerHover;
      t.bgColorContainerActive;
      t.bgColorSecondaryContainer;
      t.bgColorSecondaryContainerHover;
      t.bgColorSecondaryContainerActive;
      t.bgColorComponent;
      t.bgColorComponentHover;
      t.bgColorComponentActive;
      t.bgColorComponentDisabled;
      t.componentStrokeColor;
      t.componentBorderColor;
      t.textColorPrimary;
      t.textColorSecondary;
      t.textColorPlaceholder;
      t.textDisabledColor;
      t.textColorAnti;
      t.textColorBrand;
      t.textColorLink;

      // 抽样断言确保确实取到颜色
      expect(t.brandNormalColor, isA<Color>());
      expect(t.errorNormalColor, isA<Color>());
      expect(t.warningNormalColor, isA<Color>());
      expect(t.successNormalColor, isA<Color>());
      expect(t.textColorPrimary, isA<Color>());
      expect(t.bgColorContainer, isA<Color>());
    });
  });
}
