import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/src/util/platform_util.dart';
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

  /// 是否是横线穿过样式(删除线)
  final bool? isTextThrough;

  /// 删除线颜色，对应TestStyle的decorationColor
  final Color? lineThroughColor;

  /// 自定义的TextStyle，其中指定的属性，将覆盖扩展的外层属性
  final TextStyle? style;

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

  final bool forceVerticalCenter;


  /// 普通文本
  const TDText(this.data,
      {
        this.font,
        this.fontWeight = FontWeight.w400,
        this.fontFamily,
        this.textColor = Colors.black,
        this.backgroundColor,
        this.isTextThrough = false,
        this.lineThroughColor = Colors.white,
        this.package = "tdesign_flutter",
        this.style,
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
        this.forceVerticalCenter = false,
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
        this.isTextThrough = false,
        this.lineThroughColor = Colors.white,
        this.package = "tdesign_flutter",
        Key? key,
        this.style,
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
        this.forceVerticalCenter = false,
      }) :
        data = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if(forceVerticalCenter){
      var config = getConfiguration(context);
      var paddingConfig = config?.paddingConfig;

      var textFont =
          font ?? TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
      var fontSize = this.style?.fontSize ?? textFont.size;
      var height = this.style?.height ?? textFont.height;
      
      paddingConfig ??= TDTextPaddingConfig.getDefaultConfig();
      var showHeight = min(paddingConfig.heightRate, height);
      return Container(
        color: this.style?.backgroundColor ?? backgroundColor,
        height: fontSize * height,
        padding: paddingConfig.getPadding(data, fontSize, height),
        child: _getRawText(context: context, textStyle: _getTextStyle(context, height: showHeight)),
      );
    }
    return Container(
      color: this.style?.backgroundColor ?? backgroundColor,
      child: _getRawText(context: context),
    );
  }

  /// 提取成方法，允许业务定义自己的TDTextConfiguration
  TDTextConfiguration? getConfiguration(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<TDTextConfiguration>();
  }



  TextStyle? _getTextStyle(BuildContext? context,{ double? height}) {
    var textFont =
        font ?? TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
    return TextStyle(
      inherit: this.style?.inherit ?? true,
      color: this.style?.color ?? textColor,
      /// 不使用系统本身的背景色，因为系统属性存在中英文是，会导致颜色出现阶梯状
      // backgroundColor: this.style?.backgroundColor ?? backgroundColor,
      fontSize: this.style?.fontSize ?? textFont.size,
      fontWeight: this.style?.fontWeight ?? fontWeight,
      fontStyle: this.style?.fontStyle,
      letterSpacing: this.style?.letterSpacing,
      wordSpacing: this.style?.wordSpacing,
      textBaseline: this.style?.textBaseline,
      height: height ?? this.style?.height ?? textFont.height,
      leadingDistribution: this.style?.leadingDistribution,
      locale: this.style?.locale,
      foreground: this.style?.foreground,
      background: this.style?.background,
      shadows: this.style?.shadows,
      fontFeatures: this.style?.fontFeatures,
      decoration: this.style?.decoration ?? (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: this.style?.decorationColor ?? lineThroughColor,
      decorationStyle: this.style?.decorationStyle,
      decorationThickness: this.style?.decorationThickness,
      debugLabel: this.style?.debugLabel,
      fontFamily: this.style?.fontFamily ?? fontFamily?.fontFamily,
      fontFamilyFallback: this.style?.fontFamilyFallback,
      package: this.package,
        );
  }

  /// 获取系统原始Text，以便使用到只能接收系统Text组件的地方
  /// 转化为系统原始Text后，将失去padding和background属性
  Text getRawText({BuildContext? context}){
    return _getRawText(context: context);
  }
  
  Text _getRawText({BuildContext? context, TextStyle? textStyle}){
    return textSpan == null ? Text(
      data,
      key: this.key,
      style: textStyle ?? _getTextStyle(context),
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
      style: this.style,
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
    String package = "tdesign_flutter",
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
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
              style,
              font,
              fontWeight,
              fontFamily,
              textColor,
              isTextThrough,
              lineThroughColor,
              package),
          recognizer: recognizer,
          mouseCursor: mouseCursor,
          onEnter: onEnter,
          onExit: onExit,
          semanticsLabel: semanticsLabel,
        );

  static TextStyle? _getTextStyle(
    BuildContext? context,
    TextStyle? style,
    Font? font,
    FontWeight fontWeight,
    FontFamily? fontFamily,
    Color textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
    String package,
  ) {
    var textFont =
        font ?? TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
    return TextStyle(
      inherit: style?.inherit ?? true,
      color: style?.color ?? textColor,
      backgroundColor: style?.backgroundColor,
      fontSize: style?.fontSize ?? textFont.size,
      fontWeight: style?.fontWeight ?? fontWeight,
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
      decoration: style?.decoration ??
          (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: style?.decorationColor ?? lineThroughColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: style?.fontFamily ?? fontFamily?.fontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: package,
    );
  }
}

/// 存储可以自定义TDText居中算法数据的内部控件
class TDTextConfiguration extends InheritedWidget {
  final TDTextPaddingConfig? paddingConfig;

  const TDTextConfiguration(
      {this.paddingConfig, Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant TDTextConfiguration oldWidget) {
    return paddingConfig != oldWidget.paddingConfig;
  }


}

/// 通过Padding自定义TDText居中算法
class TDTextPaddingConfig {

  static TDTextPaddingConfig? _defaultConfig;

  /// 获取默认配置
  static TDTextPaddingConfig getDefaultConfig(){
    _defaultConfig ??= TDTextPaddingConfig();
    return _defaultConfig!;
  }

  /// 获取padding
  EdgeInsetsGeometry getPadding(String data, double fontSize, double height){
    var paddingFont = fontSize * paddingRate;
    var paddingLeading ;
    if(height < heightRate){
      paddingLeading = 0;
    } else {
      if(PlatformUtil.isIOS || PlatformUtil.isAndroid){
        paddingLeading = (height * 0.5 - paddingExtraRate) * fontSize;
      } else {
        paddingLeading = 0;
      }
    }
    var paddingTop = paddingFont + paddingLeading;
    if(paddingTop < 0) {
      paddingTop = 0;
    }
    print("text padding data: $data fontSize: $fontSize height: $height paddingRate:$paddingRate paddingTop:$paddingTop paddingLeading: $paddingLeading");
    return EdgeInsets.only(top: paddingTop);
  }

  /// 以多个汉字测量计算的平均值,Android为Pixel 4模拟器，iOS为iphone 8 plus 模拟器
  double get paddingRate => PlatformUtil.isAndroid? - 7/128 : 0;

  /// 以多个汉字测量计算的平均值,Android为Pixel 4模拟器，iOS为iphone 8 plus 模拟器
  double get paddingExtraRate => PlatformUtil.isAndroid? 115/256 : 97/240;

  /// height比率，因为设置1时，Android文字可能显示不全，默认为1.1
  double get heightRate => PlatformUtil.isAndroid ? 1.1 : 1;

}