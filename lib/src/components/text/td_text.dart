import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/td_export.dart';

/// 文本控件
/// 设计原则：
/// 1.为了使用更方便，所以对系统组件进行的扩展，需兼容系统控件所有功能，不能让用户使用TDesign时，因不能满足系统功能而弃用。
/// 2.非系统已有属性，尽量添加注释
/// 
/// 需求：把一部分在TextStyle中的属性扁平化，放到外层。
/// 1.暴露系统的所有属性，支持系统所有操作
/// 2.约束使用主题配置的几种字体
/// 3.提供转换为系统Text的方法，以使某些系统组件指定接收系统Text时可使用。（Image组件同理）
/// 4.支持自定义TextStyle
/// 5.兼容TextSpan形式
/// 
/// 技巧：
/// 命名参数替换属性的正则：
/// 第一步，把Text中的可选参数拷贝过来，变成如下格式：
/// Text(data,
/// this.style,
/// this.strutStyle,
/// ……)
/// 第二步，正则替换如下：
/// 匹配(前半有默认值，后半无默认值)：this\.([a-z|A-Z]+)[ ]*[\=]+[ ]*[a-z|A-Z]+\,|this\.([a-z|A-Z]+)\,
/// 替换：$1$2: this.$1$2,
///
class TDText extends StatelessWidget {

  /// 字体尺寸，包含大小size和行高height
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 字体ttf
  final FontFamily? fontFamily;

  /// 文本颜色
  final Color textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 字体包名
  final String package;

  /// 文本周围填充
  final EdgeInsets? padding;

  /// 是否是横线穿过样式(删除线)
  final bool? isTextThrough;

  /// 删除线颜色，对应TestStyle的decorationColor
  final Color? lineThroughColor;

  /// 是否设置行高，如果有遇到使用自带行高的主题Font，导致的文本不居中，可以设置showHeight为false不使用过Font的height
  final bool showHeight;

  /// 自定义的TextStyle，其中指定的属性，将覆盖扩展的外层属性
  final TextStyle? customStyle;

  /// 以下系统text属性，释义请参考系统[Text]中注释
  final data;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection?  textDirection;

  final Locale? locale;

  final bool? softWrap;

  final TextOverflow? overflow;

  final double? textScaleFactor;

  final int? maxLines;

  final String? semanticsLabel;

  final TextWidthBasis? textWidthBasis;

  final ui.TextHeightBehavior? textHeightBehavior;

  final InlineSpan? textSpan;


  /// 普通文本
  const TDText(this.data,
      {
        this.font,
        this.fontWeight = FontWeight.w400,
        this.fontFamily,
        this.textColor = Colors.black,
        this.backgroundColor,
        this.padding = EdgeInsets.zero,
        this.isTextThrough = false,
        this.lineThroughColor = Colors.white,
        this.showHeight = true,
        this.package = "tdesign_flutter",
        this.customStyle,
        this.strutStyle,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.semanticsLabel,
        this.textWidthBasis,
        this.textHeightBehavior,
        Key? key,})
      : textSpan = null,
        super(key: key);

  /// 支持分段TextSpan的文本
  const TDText.rich(
      InlineSpan this.textSpan, {
        this.font,
        this.fontWeight = FontWeight.w500,
        this.fontFamily,
        this.textColor = Colors.black,
        this.backgroundColor,
        this.padding = EdgeInsets.zero,
        this.isTextThrough = false,
        this.lineThroughColor = Colors.white,
        this.showHeight = true,
        this.package = "tdesign_flutter",
        Key? key,
        this.customStyle,
        this.strutStyle,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.semanticsLabel,
        this.textWidthBasis,
        this.textHeightBehavior,
      }) :
        data = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      color: backgroundColor,
      child: getRawText(context: context),
    );
  }



  TextStyle? _getTextStyle(BuildContext? context) {
    var textFont =
        font ?? TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
    return TextStyle(
      inherit: this.customStyle?.inherit ?? true,
      color: this.customStyle?.color ?? textColor,
      backgroundColor: this.customStyle?.backgroundColor,
      fontSize: this.customStyle?.fontSize ?? textFont.size,
      fontWeight: this.customStyle?.fontWeight ?? fontWeight,
      fontStyle: this.customStyle?.fontStyle,
      letterSpacing: this.customStyle?.letterSpacing,
      wordSpacing: this.customStyle?.wordSpacing,
      textBaseline: this.customStyle?.textBaseline,
      height: this.customStyle?.height ?? (showHeight ? textFont.height : null),
      leadingDistribution: this.customStyle?.leadingDistribution,
      locale: this.customStyle?.locale,
      foreground: this.customStyle?.foreground,
      background: this.customStyle?.background,
      shadows: this.customStyle?.shadows,
      fontFeatures: this.customStyle?.fontFeatures,
      decoration: this.customStyle?.decoration ?? (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: this.customStyle?.decorationColor ?? lineThroughColor,
      decorationStyle: this.customStyle?.decorationStyle,
      decorationThickness: this.customStyle?.decorationThickness,
      debugLabel: this.customStyle?.debugLabel,
      fontFamily: this.customStyle?.fontFamily ?? fontFamily?.fontFamily,
      fontFamilyFallback: this.customStyle?.fontFamilyFallback,
      package: this.package,
        );
  }

  /// 获取系统原始Text，以便使用到只能接收系统Text组件的地方
  /// 转化为系统原始Text后，将失去padding和background属性
  Text getRawText({BuildContext? context}){
    return textSpan == null ? Text(
      data,
      key: this.key,
      style: _getTextStyle(context),
      strutStyle: this.strutStyle,
      textAlign: this.textAlign,
      textDirection: this.textDirection,
      locale: this.locale,
      softWrap: this.softWrap,
      overflow: this.overflow,
      textScaleFactor: this.textScaleFactor,
      maxLines: this.maxLines,
      semanticsLabel: this.semanticsLabel,
      textWidthBasis: this.textWidthBasis,
      textHeightBehavior: this.textHeightBehavior,
    ) : Text.rich(this.textSpan!,
      style: this.customStyle,
      strutStyle: this.strutStyle,
      textAlign: this.textAlign,
      textDirection: this.textDirection,
      locale: this.locale,
      softWrap: this.softWrap,
      overflow: this.overflow,
      textScaleFactor: this.textScaleFactor,
      maxLines: this.maxLines,
      semanticsLabel: this.semanticsLabel,
      textWidthBasis: this.textWidthBasis,
      textHeightBehavior: this.textHeightBehavior,
    );
  }
}

/// TextSpan的TDesign扩展，将部分TextStyle中的参数扁平化。
class TDTextSpan extends TextSpan{

  /// 构造参数，扩展参数释义可参考[TDText]中字段注释
  TDTextSpan({
    BuildContext? context, // 如果未设置font，且不想使用默认的fontM尺寸时，需设置context，否则可省略
    Font? font,
    FontWeight fontWeight = FontWeight.w500,
    FontFamily? fontFamily,
    Color textColor = Colors.black,
    bool? isTextThrough = false,
    Color? lineThroughColor = Colors.white,
    bool showHeight = true,
    String package = "tdesign_flutter",
    String? text,
    List<InlineSpan>? children,
    TextStyle? customStyle,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
  }) : super(
          text: text,
          children: children,
          style: _getTextStyle(
              context,
              customStyle,
              font,
              fontWeight,
              fontFamily,
              textColor,
              isTextThrough,
              lineThroughColor,
              showHeight,
              package),
          recognizer: recognizer,
          mouseCursor: mouseCursor,
          onEnter: onEnter,
          onExit: onExit,
          semanticsLabel: semanticsLabel,
        );

  static TextStyle? _getTextStyle(
    BuildContext? context,
    TextStyle? customStyle,
    Font? font,
    FontWeight fontWeight,
    FontFamily? fontFamily,
    Color textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
    bool showHeight,
    String package,
  ) {
    var textFont =
        font ?? TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
    return TextStyle(
      inherit: customStyle?.inherit ?? true,
      color: customStyle?.color ?? textColor,
      backgroundColor: customStyle?.backgroundColor,
      fontSize: customStyle?.fontSize ?? textFont.size,
      fontWeight: customStyle?.fontWeight ?? fontWeight,
      fontStyle: customStyle?.fontStyle,
      letterSpacing: customStyle?.letterSpacing,
      wordSpacing: customStyle?.wordSpacing,
      textBaseline: customStyle?.textBaseline,
      height: customStyle?.height ?? (showHeight ? textFont.height : null),
      leadingDistribution: customStyle?.leadingDistribution,
      locale: customStyle?.locale,
      foreground: customStyle?.foreground,
      background: customStyle?.background,
      shadows: customStyle?.shadows,
      fontFeatures: customStyle?.fontFeatures,
      decoration: customStyle?.decoration ??
          (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: customStyle?.decorationColor ?? lineThroughColor,
      decorationStyle: customStyle?.decorationStyle,
      decorationThickness: customStyle?.decorationThickness,
      debugLabel: customStyle?.debugLabel,
      fontFamily: customStyle?.fontFamily ?? fontFamily?.fontFamily,
      fontFamilyFallback: customStyle?.fontFamilyFallback,
      package: package,
    );
  }
}