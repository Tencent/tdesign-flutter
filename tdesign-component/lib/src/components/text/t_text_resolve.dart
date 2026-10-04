import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_text.dart' show TText;
import 't_text_theme_data.dart';

/// TText 的 Flutter 原生样式解析器。
class TTextResolve {
  TTextResolve._();

  /// 解析 [TText] 最终样式。
  ///
  /// 优先级：实例样式 > 组件 Theme > 组合组件 defaults > TDesign Token。
  ///
  /// [defaults] 仅供组合组件提供内置文字样式，不代表调用方显式覆盖。
  /// 调用方的部分主题配置只替换对应字段，未配置字段仍使用组件默认值。
  static TextStyle resolve({
    required BuildContext context,
    TextStyle? defaults,
    TextStyle? style,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    final token = context.tTheme;
    final tokenFont = token.fontBodyMedium ?? Font(size: 14, lineHeight: 22);
    final material = Theme.of(context);
    final componentTheme = material.extension<TTextThemeData>();

    var resolved = _merge(
      const TextStyle(),
      _fontStyle(tokenFont).copyWith(
        color: token.textColorPrimary,
        fontFamily: token.fontFamily?.flutterFontFamily,
        fontFamilyFallback: token.fontFamily?.flutterFontFamilyFallback,
      ),
    );
    resolved = _merge(resolved, defaults);
    resolved = _merge(resolved, componentTheme?.textStyle);
    resolved = _merge(
      resolved,
      _explicitStyle(
        font: font,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        textColor: textColor,
        isTextThrough: isTextThrough,
        lineThroughColor: lineThroughColor,
      ),
    );
    resolved = _merge(resolved, style);

    // 已解析 TDesign 样式，禁止原生 Text 再次合并 Material 默认字体。
    return resolved.inherit ? resolved.copyWith(inherit: false) : resolved;
  }

  static TextStyle _merge(TextStyle base, TextStyle? override) {
    return override == null ? base : base.merge(override);
  }

  static TextStyle _fontStyle(Font font) {
    return TextStyle(
      fontSize: font.size,
      height: font.height,
      fontWeight: font.fontWeight,
    );
  }

  static TextStyle? _explicitStyle({
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    if (font == null &&
        fontWeight == null &&
        fontFamily == null &&
        textColor == null &&
        isTextThrough == null &&
        lineThroughColor == null) {
      return null;
    }
    return TextStyle(
      color: textColor,
      fontSize: font?.size,
      height: font?.height,
      fontWeight: fontWeight ?? font?.fontWeight,
      fontFamily: fontFamily?.fontFamily,
      fontFamilyFallback: fontFamily?.fallback,
      package: fontFamily?.package,
      decoration: isTextThrough == null
          ? null
          : isTextThrough
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      decorationColor: lineThroughColor,
    );
  }
}
