import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/basic.dart';
import 't_text_resolve.dart';
import 't_text_theme_data.dart';

/// Flutter [Text] 的 TDesign Token 薄封装。
///
/// 文字布局、字体 fallback、无障碍缩放和语义均由 Flutter 原生 Text 负责。
/// 固定容器居中与图文 baseline 应由父布局表达。
class TText extends StatelessWidget {
  const TText(
    String this.data, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough,
    this.lineThroughColor,
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
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough,
    this.lineThroughColor,
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

  /// TDesign 字体 Token，包含字号、行高和字重。
  final Font? font;

  /// 字体粗细。
  final FontWeight? fontWeight;

  /// 字体族及可选资源 package。
  final FontFamily? fontFamily;

  /// 文字颜色。
  final Color? textColor;

  /// 是否显示删除线。为 null 时继承 Theme 或父级样式。
  final bool? isTextThrough;

  /// 删除线颜色。
  final Color? lineThroughColor;

  /// Flutter 原生文字样式，具有最高优先级。
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
  Text getRawText({required BuildContext context}) {
    return _rawText(context, includeKey: true);
  }

  /// 获取最终 Flutter [TextStyle]。
  TextStyle getTextStyle(BuildContext context) {
    return TTextResolve.resolve(
      context: context,
      style: style,
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough,
      lineThroughColor: lineThroughColor,
    );
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

/// 支持 TDesign 字体便利参数的 Flutter [TextSpan]。
///
/// 未显式配置的字段保持为空，并继承父 Span 样式。
class TTextSpan extends TextSpan {
  TTextSpan({
    /// TDesign 字体 Token，包含字号、行高和字重。
    Font? font,

    /// 字体粗细。
    FontWeight? fontWeight,

    /// 字体族及可选资源 package。
    FontFamily? fontFamily,

    /// 文字颜色。
    Color? textColor,

    /// 是否显示删除线。为 null 时继承父 Span。
    bool? isTextThrough,

    /// 删除线颜色。
    Color? lineThroughColor,

    /// 透传至 [TextSpan.text]。
    String? text,

    /// 透传至 [TextSpan.children]。
    List<InlineSpan>? children,

    /// Flutter 原生文字样式，具有最高优先级。
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
         style: TTextResolve.resolveSpan(
           style: style,
           font: font,
           fontWeight: fontWeight,
           fontFamily: fontFamily,
           textColor: textColor,
           isTextThrough: isTextThrough,
           lineThroughColor: lineThroughColor,
         ),
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
