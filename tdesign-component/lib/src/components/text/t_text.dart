import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/basic.dart';
import 't_text_resolve.dart';
import 't_text_theme_data.dart';

/// 使用 TDesign Token 的 Flutter [Text]，保留原生文字布局与语义能力。
///
/// 文字布局、字体 fallback、无障碍缩放和语义均由 Flutter 原生 Text 负责。
/// 子树级默认文字样式通过 [TTextThemeData.textStyle] 配置；单实例完整样式通过 [style] 覆盖。
/// 固定容器居中与图文 baseline 应由父布局表达。
///
/// ### 主题配置
///
/// 组件主题通过 [TTextThemeData] 配置，放入 Flutter [ThemeData.extensions]
/// 后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
/// `TTextThemeData` 说明。
class TText extends StatelessWidget {
  const TText(
    String this.data, {
    this.font,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  }) : textSpan = null;

  /// 创建 TDesign 富文本。
  const TText.rich(
    InlineSpan this.textSpan, {
    this.font,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  }) : data = null;

  /// TDesign 字体 Token 预设，包含字号、行高和字重；[style] 的显式字段优先。
  final Font? font;

  /// 当前实例的完整文字样式；仅覆盖显式字段，优先于 [font] 和子树组件 Theme。
  final TextStyle? style;

  /// 文本内容。
  final String? data;

  /// 富文本内容。
  final InlineSpan? textSpan;

  /// 透传至 [Text.strutStyle]。
  final StrutStyle? strutStyle;

  /// 透传至 [Text.textAlign]。
  final TextAlign? textAlign;

  /// 透传至 [Text.textDirection]。
  final TextDirection? textDirection;

  /// 透传至 [Text.locale]。
  final Locale? locale;

  /// 透传至 [Text.softWrap]。
  final bool? softWrap;

  /// 透传至 [Text.overflow]。
  final TextOverflow? overflow;

  /// Flutter 原生文字缩放器；为 null 时继承 MediaQuery。
  final TextScaler? textScaler;

  /// 透传至 [Text.maxLines]。
  final int? maxLines;

  /// 透传至 [Text.semanticsLabel]。
  final String? semanticsLabel;

  /// 透传至 [Text.semanticsIdentifier]。
  final String? semanticsIdentifier;

  /// 透传至 [Text.textWidthBasis]。
  final TextWidthBasis? textWidthBasis;

  /// 透传至 [Text.textHeightBehavior]。
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 透传至 [Text.selectionColor]。
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) => _rawText(context);

  /// 获取与当前 TText 配置等价的 Flutter 原生 [Text]。
  ///
  /// ## 返回值
  /// 保留当前文本配置和 key 的原生 Text。
  Text getRawText({
    /// 当前构建上下文，用于读取祖先配置。
    required BuildContext context,
  }) {
    return _rawText(context, includeKey: true);
  }

  /// 获取最终 Flutter [TextStyle]。
  ///
  /// ## 返回值
  /// 结合当前组件配置与上下文主题解析出的最终 TextStyle。
  TextStyle getTextStyle(
    /// 当前构建上下文，用于读取祖先配置。
    BuildContext context,
  ) {
    return TTextResolve.resolve(context: context, font: font, style: style);
  }

  Text _rawText(BuildContext context, {bool includeKey = false}) {
    final theme = Theme.of(context).extension<TTextThemeData>();
    final effectiveStrutStyle = strutStyle ?? theme?.strutStyle;
    final effectiveTextWidthBasis = textWidthBasis ?? theme?.textWidthBasis;
    final effectiveTextHeightBehavior =
        textHeightBehavior ?? theme?.textHeightBehavior;
    final effectiveKey = includeKey ? key : null;

    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        key: effectiveKey,
        style: getTextStyle(context),
        strutStyle: effectiveStrutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        semanticsIdentifier: semanticsIdentifier,
        textWidthBasis: effectiveTextWidthBasis,
        textHeightBehavior: effectiveTextHeightBehavior,
        selectionColor: selectionColor,
      );
    }
    return Text(
      data!,
      key: effectiveKey,
      style: getTextStyle(context),
      strutStyle: effectiveStrutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: effectiveTextWidthBasis,
      textHeightBehavior: effectiveTextHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// 使用原生 [TextStyle] 配置局部样式的 Flutter [TextSpan]。
///
/// 未显式配置的字段保持为空，并继承父 Span 样式。
class TTextSpan extends TextSpan {
  const TTextSpan({
    /// 透传至 [TextSpan.text]。
    String? text,

    /// 透传至 [TextSpan.children]。
    List<InlineSpan>? children,

    /// Span 的唯一文字样式入口；未设置的字段继承父 Span。
    TextStyle? style,

    /// 透传至 [TextSpan.recognizer]。
    GestureRecognizer? recognizer,

    /// 透传至 [TextSpan.mouseCursor]。
    MouseCursor? mouseCursor,

    /// 透传至 [TextSpan.onEnter]。
    PointerEnterEventListener? onEnter,

    /// 透传至 [TextSpan.onExit]。
    PointerExitEventListener? onExit,

    /// 透传至 [TextSpan.semanticsLabel]。
    String? semanticsLabel,

    /// 透传至 [TextSpan.semanticsIdentifier]。
    String? semanticsIdentifier,

    /// 透传至 [TextSpan.locale]。
    Locale? locale,

    /// 透传至 [TextSpan.spellOut]。
    bool? spellOut,
  }) : super(
         text: text,
         children: children,
         style: style,
         recognizer: recognizer,
         mouseCursor: mouseCursor,
         onEnter: onEnter,
         onExit: onExit,
         semanticsLabel: semanticsLabel,
         semanticsIdentifier: semanticsIdentifier,
         locale: locale,
         spellOut: spellOut,
       );
}
