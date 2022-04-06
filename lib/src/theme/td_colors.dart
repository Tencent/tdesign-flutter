import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/theme/td_theme.dart';

///
/// 业务使用时有两种方法替换主题：
/// 第一种：有独立设计风格的app，明确知道哪些色值用到，哪些设置没用到，有自己设计规范，则可单独配置色值。
/// 第二中：直接接入TDesign，配置所有色值组，此时不需再自定义key-value，可以直接使用。
///
/// 如果业务需要扩展，可以按一下方式定义自己的ColorData，只要key在主题中能找到对应颜色即可
/// TDesign主题包含的颜色，这是一个大而全的色值。业务可以选择自己自己需要的色值进行二次封装，方便使用。
/// 不过有的色值是内部使用的，必传，否则可能显示异常。
extension TDColors on TDThemeData {
  /// 功能色组----------------------------------------------------

  ///#ECF2FE
  Color get brandColor1 => colorMap['brandColor1'] ?? const Color(0xFFECF2FE);

  ///#D4E3FC
  Color get brandColor2 => colorMap['brandColor2'] ?? const Color(0xFFD4E3FC);

  ///#BBD3FB
  Color get brandColor3 => colorMap['brandColor3'] ?? const Color(0xFFBBD3FB);

  ///#96BBF8
  Color get brandColor4 => colorMap['brandColor4'] ?? const Color(0xFF96BBF8);

  ///#699EF5
  Color get brandColor5 => colorMap['brandColor5'] ?? const Color(0xFF699EF5);

  ///#4787F0
  Color get brandColor6 => colorMap['brandColor6'] ?? const Color(0xFF4787F0);

  ///#266FE8
  Color get brandColor7 => colorMap['brandColor7'] ?? const Color(0xFF266FE8);

  ///#0052D9
  Color get brandColor8 => colorMap['brandColor8'] ?? const Color(0xFF0052D9);

  ///#0034B5
  Color get brandColor9 => colorMap['brandColor9'] ?? const Color(0xFF0034B5);

  ///#001F97
  Color get brandColor10 => colorMap['brandColor10'] ?? const Color(0xFF001F97);

  ///#ECF2FE
  Color get brandLightColor => colorMap['brandLightColor'] ?? brandColor1;

  ///#D4E3FC
  Color get brandFocusColor => colorMap['brandFocusColor'] ?? brandColor2;

  ///#BBD3FB
  Color get brandDisabledColor => colorMap['brandDisabledColor'] ?? brandColor3;

  ///#266FE8
  Color get brandHoverColor => colorMap['brandHoverColor'] ?? brandColor7;

  ///#0052D9
  Color get brandNormalColor => colorMap['brandNormalColor'] ?? brandColor8;

  ///#0034B5
  Color get brandClickColor => colorMap['brandClickColor'] ?? brandColor9;

  /// 错误色组----------------------------------------------------

  ///#FDECEE
  Color get errorColor1 => colorMap['errorColor1'] ?? const Color(0xFFFDECEE);

  ///#F9D7D9
  Color get errorColor2 => colorMap['errorColor2'] ?? const Color(0xFFF9D7D9);

  ///#F8B9BE
  Color get errorColor3 => colorMap['errorColor3'] ?? const Color(0xFFF8B9BE);

  ///#F78D94
  Color get errorColor4 => colorMap['errorColor4'] ?? const Color(0xFFF78D94);

  ///#F36D78
  Color get errorColor5 => colorMap['errorColor5'] ?? const Color(0xFFF36D78);

  ///#E34D59
  Color get errorColor6 => colorMap['errorColor6'] ?? const Color(0xFFE34D59);

  ///#C9353F
  Color get errorColor7 => colorMap['errorColor7'] ?? const Color(0xFFC9353F);

  ///#B11F26
  Color get errorColor8 => colorMap['errorColor8'] ?? const Color(0xFFB11F26);

  ///#951114
  Color get errorColor9 => colorMap['errorColor9'] ?? const Color(0xFF951114);

  ///#680506
  Color get errorColor10 => colorMap['errorColor10'] ?? const Color(0xFF680506);

  ///#FDECEE
  Color get errorLightColor => colorMap['errorLightColor'] ?? errorColor1;

  ///#F9D7D9
  Color get errorFocusColor => colorMap['errorFocusColor'] ?? errorColor2;

  ///#F8B9BE
  Color get errorDisabledColor => colorMap['errorDisabledColor'] ?? errorColor3;

  ///#F36D78
  Color get errorHoverColor => colorMap['errorHoverColor'] ?? errorColor5;

  ///#E34D59
  Color get errorNormalColor => colorMap['errorNormalColor'] ?? errorColor6;

  ///#C9353F
  Color get errorClickColor => colorMap['errorClickColor'] ?? errorColor7;

  /// 警告色组----------------------------------------------------

  ///#FEF3E6
  Color get warningColor1 => colorMap['warningColor1'] ?? const Color(0xFFFEF3E6);

  ///#F9E0C7
  Color get warningColor2 => colorMap['warningColor2'] ?? const Color(0xFFF9E0C7);

  ///#F7C797
  Color get warningColor3 => colorMap['warningColor3'] ?? const Color(0xFFF7C797);

  ///#F2995F
  Color get warningColor4 => colorMap['warningColor4'] ?? const Color(0xFFF2995F);

  ///#ED7B2F
  Color get warningColor5 => colorMap['warningColor5'] ?? const Color(0xFFED7B2F);

  ///#D35A21
  Color get warningColor6 => colorMap['warningColor6'] ?? const Color(0xFFD35A21);

  ///#BA431B
  Color get warningColor7 => colorMap['warningColor7'] ?? const Color(0xFFBA431B);

  ///#9E3610
  Color get warningColor8 => colorMap['warningColor8'] ?? const Color(0xFF9E3610);

  ///#842B0B
  Color get warningColor9 => colorMap['warningColor9'] ?? const Color(0xFF842B0B);

  ///#5A1907
  Color get warningColor10 =>
      colorMap['warningColor10'] ?? const Color(0xFF5A1907);

  ///#FEF3E6
  Color get warningLightColor => colorMap['warningLightColor'] ?? warningColor1;

  ///#F9E0C7
  Color get warningFocusColor => colorMap['warningFocusColor'] ?? warningColor2;

  ///#F7C797
  Color get warningDisabledColor =>
      colorMap['warningDisabledColor'] ?? warningColor3;

  ///#F2995F
  Color get warningHoverColor => colorMap['warningHoverColor'] ?? warningColor4;

  ///#ED7B2F
  Color get warningNormalColor => colorMap['warningNormalColor'] ?? warningColor5;

  ///#D35A21
  Color get warningClickColor => colorMap['warningClickColor'] ?? warningColor6;

  /// 成功色组----------------------------------------------------

  ///#E8F8F2
  Color get successColor1 => colorMap['successColor1'] ?? const Color(0xFFE8F8F2);

  ///#BCEBDC
  Color get successColor2 => colorMap['successColor2'] ?? const Color(0xFFBCEBDC);

  ///#85DBBE
  Color get successColor3 => colorMap['successColor3'] ?? const Color(0xFF85DBBE);

  ///#48C79C
  Color get successColor4 => colorMap['successColor4'] ?? const Color(0xFF48C79C);

  ///#00A870
  Color get successColor5 => colorMap['successColor5'] ?? const Color(0xFF00A870);

  ///#078D5C
  Color get successColor6 => colorMap['successColor6'] ?? const Color(0xFF078D5C);

  ///#067945
  Color get successColor7 => colorMap['successColor7'] ?? const Color(0xFF067945);

  ///#056334
  Color get successColor8 => colorMap['successColor8'] ?? const Color(0xFF056334);

  ///#044F2A
  Color get successColor9 => colorMap['successColor9'] ?? const Color(0xFF044F2A);

  ///#033017
  Color get successColor10 =>
      colorMap['successColor10'] ?? const Color(0xFF033017);

  ///#E8F8F2
  Color get successLightColor => colorMap['successLightColor'] ?? successColor1;

  ///#BCEBDC
  Color get successFocusColor => colorMap['successFocusColor'] ?? successColor2;

  ///#85DBBE
  Color get successDisabledColor =>
      colorMap['successDisabledColor'] ?? successColor3;

  ///#48C79C
  Color get successHoverColor => colorMap['successHoverColor'] ?? successColor4;

  ///#00A870
  Color get successNormalColor => colorMap['successNormalColor'] ?? successColor5;

  ///#078D5C
  Color get successClickColor => colorMap['successClickColor'] ?? successColor6;

  /// 文字色组----------------------------------------------------

  ///#e6000000
  Color get fontGyColor1 => colorMap['fontGyColor1'] ?? const Color(0xE6000000);

  ///#99000000
  Color get fontGyColor2 => colorMap['fontGyColor2'] ?? const Color(0x99000000);

  ///#66000000
  Color get fontGyColor3 => colorMap['fontGyColor3'] ?? const Color(0x66000000);

  ///#42000000
  Color get fontGyColor4 => colorMap['fontGyColor4'] ?? const Color(0x42000000);

  ///#ff000000
  Color get fontWhColor1 => colorMap['fontWhColor1'] ?? const Color(0xFFFFFFFF);

  ///#8c000000
  Color get fontWhColor2 => colorMap['fontWhColor2'] ?? const Color(0x8CFFFFFF);

  ///#59000000
  Color get fontWhColor3 => colorMap['fontWhColor3'] ?? const Color(0x59FFFFFF);

  ///#38000000
  Color get fontWhColor4 => colorMap['fontWhColor4'] ?? const Color(0x38FFFFFF);

  /// 中性面板色组----------------------------------------------------

  ///#FFFFFF
  Color get whiteColor1 => colorMap['whiteColor1'] ?? const Color(0xFFFFFFFF);

  ///#F3F3F3
  Color get grayColor1 => colorMap['grayColor1'] ?? const Color(0xFFF3F3F3);

  ///#EEEEEE
  Color get grayColor2 => colorMap['grayColor2'] ?? const Color(0xFFEEEEEE);

  ///#E7E7E7
  Color get grayColor3 => colorMap['grayColor3'] ?? const Color(0xFFE7E7E7);

  ///#DCDCDC
  Color get grayColor4 => colorMap['grayColor4'] ?? const Color(0xFFDCDCDC);

  ///#C5C5C5
  Color get grayColor5 => colorMap['grayColor5'] ?? const Color(0xFFC5C5C5);

  ///#A6A6A6
  Color get grayColor6 => colorMap['grayColor6'] ?? const Color(0xFFA6A6A6);

  ///#8B8B8B
  Color get grayColor7 => colorMap['grayColor7'] ?? const Color(0xFF8B8B8B);

  ///#777777
  Color get grayColor8 => colorMap['grayColor8'] ?? const Color(0xFF777777);

  ///#5E5E5E
  Color get grayColor9 => colorMap['grayColor9'] ?? const Color(0xFF5E5E5E);

  ///#4B4B4B
  Color get grayColor10 => colorMap['grayColor10'] ?? const Color(0xFF4B4B4B);

  ///#383838
  Color get grayColor11 => colorMap['grayColor11'] ?? const Color(0xFF383838);

  ///#2C2C2C
  Color get grayColor12 => colorMap['grayColor12'] ?? const Color(0xFF2C2C2C);

  ///#242424
  Color get grayColor13 => colorMap['grayColor13'] ?? const Color(0xFF242424);

  ///#181818
  Color get grayColor14 => colorMap['grayColor14'] ?? const Color(0xFF181818);
}
