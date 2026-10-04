import 'dart:ui';

import 'package:flutter/material.dart';
import 't_theme.dart';

///
/// 业务使用时有两种方法替换主题：
/// 第一种：有独立设计风格的app，明确知道哪些色值用到，哪些设置没用到，有自己设计规范，则可单独配置色值。
/// 第二中：直接接入TDesign，配置所有色值组，此时不需再自定义key-value，可以直接使用。
///
/// 如果业务需要扩展，可以按一下方式定义自己的ColorData，只要key在主题中能找到对应颜色即可
/// TDesign主题包含的颜色，这是一个大而全的色值。业务可以选择自己自己需要的色值进行二次封装，方便使用。
/// 不过有的色值是内部使用的，必传，否则可能显示异常。
extension TColors on TThemeData {
  /// 功能色组----------------------------------------------------

  /// 小程序 `--td-primary-color-*` 色阶；默认分别引用同级品牌色阶。
  Color get primaryColor1 => colorMap['primaryColor1'] ?? brandColor1;
  Color get primaryColor2 => colorMap['primaryColor2'] ?? brandColor2;
  Color get primaryColor3 => colorMap['primaryColor3'] ?? brandColor3;
  Color get primaryColor4 => colorMap['primaryColor4'] ?? brandColor4;
  Color get primaryColor5 => colorMap['primaryColor5'] ?? brandColor5;
  Color get primaryColor6 => colorMap['primaryColor6'] ?? brandColor6;
  Color get primaryColor7 => colorMap['primaryColor7'] ?? brandColor7;
  Color get primaryColor8 => colorMap['primaryColor8'] ?? brandColor8;
  Color get primaryColor9 => colorMap['primaryColor9'] ?? brandColor9;
  Color get primaryColor10 => colorMap['primaryColor10'] ?? brandColor10;

  ///#F2F3FF
  Color get brandColor1 => colorMap['brandColor1'] ?? const Color(0xFFF2F3FF);

  ///#D9E1FF
  Color get brandColor2 =>
      colorMap['brandColor2'] ??
      const Color(0xFFD9E1FF); // coverage:ignore-line

  ///#B5C7FF
  Color get brandColor3 => colorMap['brandColor3'] ?? const Color(0xFFB5C7FF);

  ///#8EABFF
  Color get brandColor4 =>
      colorMap['brandColor4'] ??
      const Color(0xFF8EABFF); // coverage:ignore-line

  ///#618DFF
  Color get brandColor5 =>
      colorMap['brandColor5'] ??
      const Color(0xFF618DFF); // coverage:ignore-line

  ///#366EF4
  Color get brandColor6 => colorMap['brandColor6'] ?? const Color(0xFF366EF4);

  ///#0052D9
  Color get brandColor7 => colorMap['brandColor7'] ?? const Color(0xFF0052D9);

  ///#003CAB
  Color get brandColor8 => colorMap['brandColor8'] ?? const Color(0xFF003CAB);

  ///#002A7C
  Color get brandColor9 =>
      colorMap['brandColor9'] ??
      const Color(0xFF002A7C); // coverage:ignore-line

  ///#001A57
  Color get brandColor10 =>
      colorMap['brandColor10'] ??
      const Color(0xFF001A57); // coverage:ignore-line

  ///#F2F3FF
  Color get brandColorLight => colorMap['brandColorLight'] ?? brandColor1;

  /// 浅色品牌色点击态，默认使用品牌色阶 2。
  Color get brandColorLightActive =>
      colorMap['brandColorLightActive'] ?? brandColor2;

  ///#F2F3FF
  Color get brandColorFocus => colorMap['brandColorFocus'] ?? brandColor1;

  ///#B5C7FF
  Color get brandColorDisabled => colorMap['brandColorDisabled'] ?? brandColor3;

  ///#0052D9
  Color get brandColor => colorMap['brandColor'] ?? brandColor7;

  ///#003CAB
  Color get brandColorActive => colorMap['brandColorActive'] ?? brandColor8;

  /// 错误色组----------------------------------------------------

  ///#FFF0ED
  Color get errorColor1 => colorMap['errorColor1'] ?? const Color(0xFFFFF0ED);

  ///#FFD8D2
  Color get errorColor2 =>
      colorMap['errorColor2'] ??
      const Color(0xFFFFD8D2); // coverage:ignore-line

  ///#FFB9B0
  Color get errorColor3 =>
      colorMap['errorColor3'] ??
      const Color(0xFFFFB9B0); // coverage:ignore-line

  ///#FF9285
  Color get errorColor4 =>
      colorMap['errorColor4'] ??
      const Color(0xFFFF9285); // coverage:ignore-line

  ///#F6685D
  Color get errorColor5 =>
      colorMap['errorColor5'] ??
      const Color(0xFFF6685D); // coverage:ignore-line

  ///#D54941
  Color get errorColor6 => colorMap['errorColor6'] ?? const Color(0xFFD54941);

  ///#AD352F
  Color get errorColor7 => colorMap['errorColor7'] ?? const Color(0xFFAD352F);

  ///#881F1C
  Color get errorColor8 =>
      colorMap['errorColor8'] ??
      const Color(0xFF881F1C); // coverage:ignore-line

  ///#68070A
  Color get errorColor9 =>
      colorMap['errorColor9'] ??
      const Color(0xFF68070A); // coverage:ignore-line

  ///#490002
  Color get errorColor10 =>
      colorMap['errorColor10'] ??
      const Color(0xFF490002); // coverage:ignore-line

  ///#FFF0ED
  Color get errorColorLight => colorMap['errorColorLight'] ?? errorColor1;

  /// 浅色错误色点击态，默认使用错误色阶 2。
  Color get errorColorLightActive =>
      colorMap['errorColorLightActive'] ?? errorColor2;

  ///#FFD8D2
  Color get errorColorFocus =>
      colorMap['errorColorFocus'] ?? errorColor2; // coverage:ignore-line

  ///#FFB9B0
  Color get errorColorDisabled => colorMap['errorColorDisabled'] ?? errorColor3;

  ///#D54941
  Color get errorColor => colorMap['errorColor'] ?? errorColor6;

  ///#AD352F
  Color get errorColorActive => colorMap['errorColorActive'] ?? errorColor7;

  /// 警告色组----------------------------------------------------

  ///#FFF1E9
  Color get warningColor1 =>
      colorMap['warningColor1'] ?? const Color(0xFFFFF1E9);

  ///#FFD9C2
  Color get warningColor2 =>
      colorMap['warningColor2'] ??
      const Color(0xFFFFD9C2); // coverage:ignore-line

  ///#FFB98C
  Color get warningColor3 =>
      colorMap['warningColor3'] ??
      const Color(0xFFFFB98C); // coverage:ignore-line

  ///#FA9550
  Color get warningColor4 =>
      colorMap['warningColor4'] ??
      const Color(0xFFFA9550); // coverage:ignore-line

  ///#E37318
  Color get warningColor5 =>
      colorMap['warningColor5'] ?? const Color(0xFFE37318);

  ///#BE5A00
  Color get warningColor6 =>
      colorMap['warningColor6'] ??
      const Color(0xFFBE5A00); // coverage:ignore-line

  ///#954500
  Color get warningColor7 =>
      colorMap['warningColor7'] ??
      const Color(0xFF954500); // coverage:ignore-line

  ///#713300
  Color get warningColor8 =>
      colorMap['warningColor8'] ??
      const Color(0xFF713300); // coverage:ignore-line

  ///#532300
  Color get warningColor9 =>
      colorMap['warningColor9'] ??
      const Color(0xFF532300); // coverage:ignore-line

  ///#3B1700
  Color get warningColor10 =>
      colorMap['warningColor10'] ??
      const Color(0xFF3B1700); // coverage:ignore-line

  ///#FFF1E9
  Color get warningColorLight => colorMap['warningColorLight'] ?? warningColor1;

  /// 浅色警告色点击态，默认使用警告色阶 2。
  Color get warningColorLightActive =>
      colorMap['warningColorLightActive'] ?? warningColor2;

  ///#FFD9C2
  Color get warningColorFocus =>
      colorMap['warningColorFocus'] ?? warningColor2; // coverage:ignore-line

  ///#FFB98C
  Color get warningColorDisabled =>
      colorMap['warningColorDisabled'] ?? warningColor3; // coverage:ignore-line

  ///#E37318
  Color get warningColor => colorMap['warningColor'] ?? warningColor5;

  ///#BE5A00
  Color get warningColorActive =>
      colorMap['warningColorActive'] ?? warningColor6; // coverage:ignore-line

  /// 成功色组----------------------------------------------------

  ///#E3F9E9
  Color get successColor1 =>
      colorMap['successColor1'] ??
      const Color(0xFFE3F9E9); // coverage:ignore-line

  ///#C6F3D7
  Color get successColor2 =>
      colorMap['successColor2'] ??
      const Color(0xFFC6F3D7); // coverage:ignore-line

  ///#92DAB2
  Color get successColor3 =>
      colorMap['successColor3'] ??
      const Color(0xFF92DAB2); // coverage:ignore-line

  ///#56C08D
  Color get successColor4 =>
      colorMap['successColor4'] ??
      const Color(0xFF56C08D); // coverage:ignore-line

  ///#2BA471
  Color get successColor5 =>
      colorMap['successColor5'] ??
      const Color(0xFF2BA471); // coverage:ignore-line

  ///#008858
  Color get successColor6 =>
      colorMap['successColor6'] ??
      const Color(0xFF008858); // coverage:ignore-line

  ///#006C45
  Color get successColor7 =>
      colorMap['successColor7'] ??
      const Color(0xFF006C45); // coverage:ignore-line

  ///#005334
  Color get successColor8 =>
      colorMap['successColor8'] ??
      const Color(0xFF005334); // coverage:ignore-line

  ///#003B23
  Color get successColor9 =>
      colorMap['successColor9'] ??
      const Color(0xFF003B23); // coverage:ignore-line

  ///#002515
  Color get successColor10 =>
      colorMap['successColor10'] ??
      const Color(0xFF002515); // coverage:ignore-line

  ///#E3F9E9
  Color get successColorLight => colorMap['successColorLight'] ?? successColor1;

  /// 浅色成功色点击态，默认使用成功色阶 2。
  Color get successColorLightActive =>
      colorMap['successColorLightActive'] ?? successColor2;

  ///#C6F3D7
  Color get successColorFocus =>
      colorMap['successColorFocus'] ?? successColor2; // coverage:ignore-line

  ///#92DAB2
  Color get successColorDisabled =>
      colorMap['successColorDisabled'] ?? successColor3; // coverage:ignore-line

  ///#2BA471
  Color get successColor => colorMap['successColor'] ?? successColor5;

  ///#008858
  Color get successColorActive =>
      colorMap['successColorActive'] ?? successColor6; // coverage:ignore-line

  /// 文字色组----------------------------------------------------

  ///#e6000000
  Color get fontGray1 => colorMap['fontGray1'] ?? const Color(0xE6000000);

  ///#99000000
  Color get fontGray2 => colorMap['fontGray2'] ?? const Color(0x99000000);

  ///#66000000
  Color get fontGray3 => colorMap['fontGray3'] ?? const Color(0x66000000);

  ///#42000000
  Color get fontGray4 => colorMap['fontGray4'] ?? const Color(0x42000000);

  ///#FFFFFFFF
  Color get fontWhite1 => colorMap['fontWhite1'] ?? const Color(0xFFFFFFFF);

  ///#8CFFFFFF
  Color get fontWhite2 => colorMap['fontWhite2'] ?? const Color(0x8CFFFFFF);

  ///#59FFFFFF
  Color get fontWhite3 =>
      colorMap['fontWhite3'] ?? const Color(0x59FFFFFF); // coverage:ignore-line

  ///#38FFFFFF
  Color get fontWhite4 => colorMap['fontWhite4'] ?? const Color(0x38FFFFFF);

  /// 中性面板色组----------------------------------------------------

  ///#FFFFFF
  Color get whiteColor1 => colorMap['whiteColor1'] ?? const Color(0xFFFFFFFF);

  ///#F3F3F3
  Color get grayColor1 => colorMap['grayColor1'] ?? const Color(0xFFF3F3F3);

  ///#EEEEEE
  Color get grayColor2 =>
      colorMap['grayColor2'] ?? const Color(0xFFEEEEEE); // coverage:ignore-line

  ///#E8E8E8
  Color get grayColor3 => colorMap['grayColor3'] ?? const Color(0xFFE8E8E8);

  ///#DCDCDC
  Color get grayColor4 => colorMap['grayColor4'] ?? const Color(0xFFDCDCDC);

  ///#C5C5C5
  Color get grayColor5 =>
      colorMap['grayColor5'] ?? const Color(0xFFC5C5C5); // coverage:ignore-line

  ///#A6A6A6
  Color get grayColor6 =>
      colorMap['grayColor6'] ?? const Color(0xFFA6A6A6); // coverage:ignore-line

  ///#8B8B8B
  Color get grayColor7 =>
      colorMap['grayColor7'] ?? const Color(0xFF8B8B8B); // coverage:ignore-line

  ///#777777
  Color get grayColor8 =>
      colorMap['grayColor8'] ?? const Color(0xFF777777); // coverage:ignore-line

  ///#5E5E5E
  Color get grayColor9 => colorMap['grayColor9'] ?? const Color(0xFF5E5E5E);

  ///#4B4B4B
  Color get grayColor10 =>
      colorMap['grayColor10'] ??
      const Color(0xFF4B4B4B); // coverage:ignore-line

  ///#383838
  Color get grayColor11 =>
      colorMap['grayColor11'] ??
      const Color(0xFF383838); // coverage:ignore-line

  ///#2C2C2C
  Color get grayColor12 =>
      colorMap['grayColor12'] ??
      const Color(0xFF2C2C2C); // coverage:ignore-line

  ///#242424
  Color get grayColor13 => colorMap['grayColor13'] ?? const Color(0xFF242424);

  ///#181818
  Color get grayColor14 => colorMap['grayColor14'] ?? const Color(0xFF181818);

  /// 组件颜色配置----------------------------------------------------

  Color get bgColorPage => colorMap['bgColorPage'] ?? grayColor1;

  /// 小程序 `--td-bg-color-container`；浅色默认引用 [fontWhite1]。
  Color get bgColorContainer => colorMap['bgColorContainer'] ?? fontWhite1;

  Color get bgColorContainerActive =>
      colorMap['bgColorContainerActive'] ?? grayColor3;

  Color get bgColorSecondaryContainer =>
      colorMap['bgColorSecondaryContainer'] ?? grayColor1;

  Color get bgColorSecondaryContainerActive =>
      colorMap['bgColorSecondaryContainerActive'] ?? grayColor4;

  /// 小程序 `--td-bg-color-secondarycomponent`，默认引用灰阶 4。
  Color get bgColorSecondaryComponent =>
      colorMap['bgColorSecondaryComponent'] ?? grayColor4;

  /// 小程序 `--td-bg-color-secondarycomponent-active`，默认引用灰阶 6。
  Color get bgColorSecondaryComponentActive =>
      colorMap['bgColorSecondaryComponentActive'] ?? grayColor6;

  /// 小程序 `--td-bg-color-specialcomponent`；暗色主题默认透明。
  Color get bgColorSpecialComponent =>
      colorMap['bgColorSpecialComponent'] ?? whiteColor1;

  Color get bgColorComponent => colorMap['bgColorComponent'] ?? grayColor3;

  Color get bgColorComponentActive =>
      colorMap['bgColorComponentActive'] ?? grayColor6; // coverage:ignore-line

  Color get bgColorComponentDisabled =>
      colorMap['bgColorComponentDisabled'] ?? grayColor2;

  Color get componentStroke => colorMap['componentStroke'] ?? grayColor3;

  Color get componentBorder => colorMap['componentBorder'] ?? grayColor4;

  /// 小程序一级分割线颜色，默认与 [componentStroke] 使用同一色阶。
  Color get borderLevel1Color =>
      colorMap['borderLevel1Color'] ?? componentStroke;

  /// 小程序二级边框颜色，默认与 [componentBorder] 使用同一色阶。
  Color get borderLevel2Color =>
      colorMap['borderLevel2Color'] ?? componentBorder;

  /// 文字颜色配置----------------------------------------------------

  Color get textColorPrimary => colorMap['textColorPrimary'] ?? fontGray1;

  Color get textColorSecondary => colorMap['textColorSecondary'] ?? fontGray2;

  Color get textColorPlaceholder =>
      colorMap['textColorPlaceholder'] ?? fontGray3;

  Color get textColorDisabled => colorMap['textColorDisabled'] ?? fontGray4;

  /// 小程序 `--td-text-color-anti`，默认引用 [fontWhite1]。
  Color get textColorAnti => colorMap['textColorAnti'] ?? fontWhite1;

  Color get textColorBrand =>
      colorMap['textColorBrand'] ?? brandColor; // coverage:ignore-line

  Color get textColorLink =>
      colorMap['textColorLink'] ?? brandColor; // coverage:ignore-line

  /// 弹层遮罩色。
  Color get maskActive => colorMap['maskActive'] ?? const Color(0x99000000);

  /// 禁用态遮罩色。
  Color get maskDisabled => colorMap['maskDisabled'] ?? const Color(0x99FFFFFF);

  /// 二维码等背景遮罩色。
  Color get maskBackground =>
      colorMap['maskBackground'] ?? const Color(0xF5FFFFFF);

  /// 表格专用阴影色。
  Color get tableShadowColor =>
      colorMap['tableShadowColor'] ?? const Color(0x14000000);

  /// 滚动条颜色。
  Color get scrollbarColor =>
      colorMap['scrollbarColor'] ?? const Color(0x1A000000);

  /// 滚动条悬停颜色。
  Color get scrollbarHoverColor =>
      colorMap['scrollbarHoverColor'] ?? const Color(0x4D000000);

  /// 滚动条轨道颜色。
  Color get scrollTrackColor =>
      colorMap['scrollTrackColor'] ?? const Color(0xFFFFFFFF);
}
