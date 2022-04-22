import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'dart:ui' as ui show TextHeightBehavior;

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
/// 替换：$1$2: this.customStyle.$1$2
///
class TDText extends StatelessWidget {
  final Font? font;
  final FontWeight fontWeight;
  final FontFamily? fontFamily;
  final Color textColor;
  final String package;
  final EdgeInsets? padding;

  /// 是否是横线穿过样式
  final bool? isTextThrough;
  final Color? lineThroughColor;
  final bool showHeight;
  
  // 系统text属性
  final data;
  
  final TextStyle? customStyle;

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


  const TDText(this.data,
      {
        this.font,
        this.fontWeight = FontWeight.w500,
        this.fontFamily,
        this.textColor = Colors.black,
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
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Text(
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
      ),
    );
  }

  TextStyle? _getTextStyle(BuildContext context) {
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
}
