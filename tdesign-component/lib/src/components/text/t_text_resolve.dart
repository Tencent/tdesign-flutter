import 'package:flutter/foundation.dart' show listEquals;
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
  /// [singleLine] 仅供内置单行文字均分额外行高，不覆盖显式排版配置。
  /// [defaults] 仅供组合组件提供内置文字样式，不代表调用方显式覆盖。
  /// 调用方的部分主题配置只替换对应字段，未配置字段仍使用组件默认值。
  static TextStyle resolve({
    required BuildContext context,
    bool singleLine = false,
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
      const TextStyle(
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: 0,
        wordSpacing: 0,
      ),
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

    // 只调整内置单行文字的默认额外行高；显式样式始终优先。
    // 多行、富文本和调用方内容不使用此默认策略。
    if (singleLine && resolved.leadingDistribution == null) {
      resolved = resolved.copyWith(
        leadingDistribution: TextLeadingDistribution.even,
      );
    }

    // 已解析 TDesign 样式，禁止原生 Text 再次合并 Material 默认字体。
    return resolved.inherit ? resolved.copyWith(inherit: false) : resolved;
  }

  /// 内置单行的默认支柱行高，避免回退字体混排使 Token 行盒增高。
  /// 显式 leading、支柱与高度行为仍由调用方控制。
  static StrutStyle? singleLineStrut({
    required BuildContext context,
    required TextStyle resolvedStyle,
    TextStyle? configuredStyle,
    StrutStyle? strutStyle,
    TextHeightBehavior? textHeightBehavior,
  }) {
    final theme = Theme.of(context).extension<TTextThemeData>();
    final explicitStrut = strutStyle ?? theme?.strutStyle;
    if (explicitStrut != null) {
      return explicitStrut;
    }
    if (resolvedStyle.height == null ||
        resolvedStyle.leadingDistribution != TextLeadingDistribution.even ||
        configuredStyle?.leadingDistribution != null ||
        theme?.textStyle?.leadingDistribution != null ||
        textHeightBehavior != null ||
        theme?.textHeightBehavior != null) {
      return null;
    }
    return _TDefaultSingleLineStrut(resolvedStyle);
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

// 旧版 Flutter 的 StrutStyle 相等判断未包含 leadingDistribution 与 fallback。
// 区分组件默认支柱与显式原生配置，并完整比较默认支柱的排版字段，避免
// Theme 更新时 RenderParagraph 将新配置误认为旧值；不重建文字或选择状态。
class _TDefaultSingleLineStrut extends StrutStyle {
  _TDefaultSingleLineStrut(TextStyle style)
    : super.fromTextStyle(style, forceStrutHeight: true);

  @override
  bool operator ==(Object other) =>
      other is _TDefaultSingleLineStrut &&
      super == other &&
      leadingDistribution == other.leadingDistribution &&
      listEquals(fontFamilyFallback, other.fontFamilyFallback);

  @override
  int get hashCode => Object.hash(
    super.hashCode,
    leadingDistribution,
    Object.hashAll(fontFamilyFallback ?? const <String>[]),
  );
}
