import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_text.dart' show TText, TTextSpan;
import 't_text_theme_data.dart';

/// TText 与 TTextSpan 的 Flutter 原生样式解析器。
class TTextResolve {
  TTextResolve._();

  /// 解析 [TText] 最终样式。
  ///
  /// 优先级：实例 style > 实例便利参数 > TTextThemeData >
  /// DefaultTextStyle > Material TextTheme > TDesign Token。
  static TextStyle resolve({
    required BuildContext context,
    TextStyle? style,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    final token = context.tTheme;
    final tokenFont = token.fontBodyLarge ?? Font(size: 16, lineHeight: 24);
    final material = Theme.of(context);
    final componentTheme = material.extension<TTextThemeData>();

    final ambientTextStyle = DefaultTextStyle.of(context).style;
    var resolved = _isMaterialFallbackStyle(ambientTextStyle)
        ? const TextStyle()
        : ambientTextStyle;
    resolved = _merge(
      resolved,
      _fontStyle(tokenFont).copyWith(color: token.textColorPrimary),
    );
    resolved = _merge(resolved, material.tExplicitTextTheme?.bodyLarge);
    final defaultTextStyle = context.tExplicitDefaultTextStyle;
    if (!_isMaterialFallbackStyle(defaultTextStyle)) {
      resolved = _merge(resolved, defaultTextStyle);
    }
    resolved = _merge(resolved, _fontStyleOrNull(componentTheme?.font));
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

    // 样式已经按完整优先级解析，禁止原生 Text 再次合并同一个
    // DefaultTextStyle。否则 MaterialApp 在缺少 Material 祖先时注入的诊断
    // 样式会把黄色双下划线等字段重新带回最终结果。
    return resolved.inherit ? resolved.copyWith(inherit: false) : resolved;
  }

  /// 解析 [TTextSpan] 的显式样式。
  ///
  /// Span 不读取 Theme 或 Token；未指定的字段保持为空并继承父 Span。
  static TextStyle? resolveSpan({
    TextStyle? style,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    final explicit = _explicitStyle(
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough,
      lineThroughColor: lineThroughColor,
    );
    if (explicit == null) {
      return style;
    }
    return style == null ? explicit : explicit.merge(style);
  }

  static TextStyle _merge(TextStyle base, TextStyle? override) {
    return override == null ? base : base.merge(override);
  }

  static bool _isMaterialFallbackStyle(TextStyle? style) {
    return style?.debugLabel?.contains(
          'fallback style; consider putting your text in a Material',
        ) ??
        false;
  }

  static TextStyle _fontStyle(Font font) {
    return TextStyle(
      fontSize: font.size,
      height: font.height,
      fontWeight: font.fontWeight,
    );
  }

  static TextStyle? _fontStyleOrNull(Font? font) {
    return font == null ? null : _fontStyle(font);
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
