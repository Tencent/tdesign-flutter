import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/platform_util.dart';
import 't_text.dart' show TText, TTextConfiguration, TTextSpan;
import 't_text_theme_data.dart';

/// Text 样式解析器
///
/// 统一 [TText.getTextStyle] 与 TTextSpan 内部样式逻辑，
/// 确保纯文本与富文本样式一致性。
///
/// 优先级链：
/// P0 [TextStyle] style 实例
///  > 构造器糖（font/textColor/fontWeight/fontFamily/isTextThrough 等）
///  > [TTextConfiguration]（globalFontFamily · paddingConfig）
///  > [TTextThemeData]（ThemeExtension）
///  > [TextTheme] / DefaultTextStyle（Material P2）
///  > Token 默认值（P4）
class TTextResolve {
  TTextResolve._(); // coverage:ignore-line

  /// 解析 [TText] 的最终 [TextStyle]
  ///
  /// 含完整覆盖链：P0 style > 构造器糖 > TTextConfiguration > TTextThemeData > Token。
  static TextStyle resolve({
    required BuildContext context,
    // P0 实例
    TextStyle? style,
    // 构造器糖
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool isTextThrough = false,
    Color? lineThroughColor,
    String? package,
    bool isInFontLoader = false,
    // 强制居中时由 build 传入覆写 height
    double? overrideHeight,
    // TextStyle.backgroundColor（TText 不以此为块背景，但与 forceVerticalCenter 分支共用 Container 时传入）
    Color? textStyleBackgroundColor,
  }) {
    final tTheme = context.tTheme;
    final themeExtension = Theme.of(context).extension<TTextThemeData>();
    final configuration =
        context.dependOnInheritedWidgetOfExactType<TTextConfiguration>();

    // 1. 基准 Font：构造器 > Theme > Token
    final textFont = font ??
        themeExtension?.defaultFont ??
        tTheme.fontBodyLarge ??
        Font(size: 16, lineHeight: 24); // coverage:ignore-line

    // 2. fontSize：P0 style > 构造器糖（font.size）> Theme > Token
    final fontSize = style?.fontSize ?? textFont.size;

    // 3. height：overrideHeight（forceVerticalCenter 分支传入）> P0 style.height > 构造器糖（font.height）> Token
    final resolvedHeight = overrideHeight ?? style?.height ?? textFont.height;

    // 4. fontWeight：P0 style > 构造器糖 > Theme > Token
    final resolvedFontWeight = style?.fontWeight ??
        fontWeight ??
        themeExtension?.defaultFontWeight ??
        textFont.fontWeight;

    // 5. 字体族解析（含 globalFontFamily 注入 + iOS PingFang 回退 + Theme 回退）
    final resolvedFontFamily = _resolveFontFamily(
      style: style,
      fontFamily: fontFamily,
      themeFontFamily: themeExtension?.defaultFontFamily,
      configuration: configuration,
      resolvedFontWeight: resolvedFontWeight,
    );
    final resolvedPackage = _resolvePackage(
      package: package,
      fontFamily: fontFamily,
      themePackage: themeExtension?.defaultPackage,
      configuration: configuration,
      isInFontLoader: isInFontLoader,
    );

    // 6. 颜色：P0 style.color > 构造器糖 textColor > Theme > Token
    final color = style?.color ??
        textColor ??
        themeExtension?.defaultTextColor ??
        tTheme.textColorPrimary;

    // 7. 删除线：P0 style.decoration > 构造器糖 isTextThrough > Theme
    final decoration = style?.decoration ??
        ((isTextThrough || (themeExtension?.isTextThrough ?? false))
            ? TextDecoration.lineThrough
            : TextDecoration.none);
    final decorationColor = style?.decorationColor ??
        lineThroughColor ??
        themeExtension?.lineThroughColor ??
        color;

    return TextStyle(
      inherit: style?.inherit ?? true,
      color: color,
      // TText 不用 TextStyle.backgroundColor 做块背景（改用 Container），
      // 仅 forceVerticalCenter 分支 Container 传入时作为 TextStyle 背景（非块背景用途）
      backgroundColor: textStyleBackgroundColor,
      fontSize: fontSize,
      fontWeight: resolvedFontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: resolvedHeight,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: resolvedFontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: resolvedPackage,
    );
  }

  /// 解析 [TTextSpan] 的最终 [TextStyle]
  ///
  /// Span 无 TTextConfiguration 子树上下文（不继承 globalFontFamily），
  /// 但仍获取 TTextThemeData 做 P1 默认值。
  static TextStyle resolveSpan({
    BuildContext? context,
    // P0 实例
    TextStyle? style,
    // 构造器糖
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool isTextThrough = false,
    Color? lineThroughColor,
    String? package,
  }) {
    // Token 默认值（context 可能为 null，此时用硬编码回退）
    final tTheme =
        context != null ? context.tTheme : null; // coverage:ignore-line
    final themeExtension = context != null
        ? Theme.of(context).extension<TTextThemeData>() // coverage:ignore-line
        : null;

    // 基准 Font
    final textFont = font ??
        themeExtension?.defaultFont ?? // coverage:ignore-line
        tTheme?.fontBodyLarge ?? // coverage:ignore-line
        Font(size: 16, lineHeight: 24);

    final fontSize = style?.fontSize ?? textFont.size;
    final resolvedFontWeight = style?.fontWeight ??
        fontWeight ??
        themeExtension?.defaultFontWeight ??
        textFont.fontWeight;

    // Span 不注入 globalFontFamily（无 TTextConfiguration 上下文）
    final resolvedFontFamily = _resolveSpanFontFamily(
      style: style,
      fontFamily: fontFamily,
      resolvedFontWeight: resolvedFontWeight,
    );

    final color = style?.color ??
        textColor ??
        themeExtension?.defaultTextColor ?? // coverage:ignore-line
        tTheme?.textColorPrimary; // coverage:ignore-line

    final decoration = style?.decoration ??
        ((isTextThrough ||
                (themeExtension?.isTextThrough ??
                    false)) // coverage:ignore-line
            ? TextDecoration.lineThrough
            : TextDecoration.none);
    final decorationColor = style?.decorationColor ??
        lineThroughColor ??
        themeExtension?.lineThroughColor ?? // coverage:ignore-line
        color;

    return TextStyle(
      inherit: style?.inherit ?? true,
      color: color,
      backgroundColor: style?.backgroundColor,
      fontSize: fontSize,
      fontWeight: resolvedFontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: style?.height ?? textFont.height,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: resolvedFontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: package ?? fontFamily?.package, // coverage:ignore-line
    );
  }

  // ---- 内部辅助 ----

  /// 解析 TText 的 fontFamily（含 globalFontFamily 注入 + iOS PingFang 回退 + Theme 回退）
  static String? _resolveFontFamily({
    required TextStyle? style,
    required FontFamily? fontFamily,
    FontFamily? themeFontFamily,
    TTextConfiguration? configuration,
    required FontWeight? resolvedFontWeight,
  }) {
    final globalFontFamily = configuration?.globalFontFamily;
    final styleFontFamily = style?.fontFamily ??
        fontFamily?.fontFamily ??
        globalFontFamily?.fontFamily ??
        themeFontFamily?.fontFamily;

    // iOS FontWeight≤w500 且无 fontFamily → 回退 PingFang SC
    if (PlatformUtil.isIOS &&
        (styleFontFamily == null ||
            styleFontFamily.isEmpty) && // coverage:ignore-line
        resolvedFontWeight != null &&
        resolvedFontWeight.value <= FontWeight.w500.value) {
      // coverage:ignore-line
      // coverage:ignore-line
      return 'PingFang SC';
    }

    return styleFontFamily;
  }

  /// 解析 TTextSpan 的 fontFamily（不含 globalFontFamily，仅 iOS PingFang）
  static String? _resolveSpanFontFamily({
    required TextStyle? style,
    required FontFamily? fontFamily,
    required FontWeight? resolvedFontWeight,
  }) {
    var styleFontFamily = style?.fontFamily ?? fontFamily?.fontFamily;

    // iOS PingFang 回退
    if (PlatformUtil.isIOS &&
        (styleFontFamily == null ||
            styleFontFamily.isEmpty) && // coverage:ignore-line
        resolvedFontWeight != null &&
        resolvedFontWeight.value <= FontWeight.w500.value) {
      // coverage:ignore-line
      // coverage:ignore-line
      return 'PingFang SC';
    }

    return styleFontFamily;
  }

  /// 解析 package（全局字体 package 回退 + Theme 回退 + isInFontLoader 时清空）
  static String? _resolvePackage({
    String? package,
    FontFamily? fontFamily,
    String? themePackage,
    TTextConfiguration? configuration,
    required bool isInFontLoader,
  }) {
    final globalFontFamily = configuration?.globalFontFamily;
    var stylePackage = package ??
        fontFamily?.package ??
        globalFontFamily?.package ??
        themePackage;

    // 字体懒加载模式下清空 package，避免引擎查找未注册字体
    if (isInFontLoader) {
      stylePackage = null;
    }

    return stylePackage;
  }
}
