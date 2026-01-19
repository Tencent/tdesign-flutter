import 'dart:math';
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';
import '../../util/version_util.dart';

/// 是否启用强制居中
var kTextForceVerticalCenterEnable = true;

/// 是否启用全局字体
var kTextNeedGlobalFontFamily = true;

/// 文本控件
/// 设计原则：
/// 1. 为了使用更方便，所以对系统组件进行的扩展，需兼容系统控件所有功能，不能让用户使用 TDesign 时，因不能满足系统功能而弃用。
/// 2. 非系统已有属性，尽量添加注释
///
/// 需求：把一部分在 TextStyle 中的属性扁平化，放到外层。
/// 1. 暴露系统的所有属性，支持系统所有操作
/// 2. 约束使用主题配置的几种字体
/// 3. 提供转换为系统 Text 的方法，以使某些系统组件指定接收系统 Text 时可使用。（Image 组件同理）
/// 4. 支持自定义 TextStyle
/// 5. 兼容 TextSpan 形式
///
/// 技巧：
/// 命名参数替换属性的正则：
/// 第一步，把 Text 中的可选参数拷贝过来，变成如下格式：
/// Text(data,
/// this.style,
/// this.strutStyle,
/// ……)
/// 第二步，正则替换如下：
/// 匹配(前半有默认值，后半无默认值)：this\.([a-z|A-Z]+)[ ]*[\=]+[ ]*[a-z|A-Z]+\,|this\.([a-z|A-Z]+)\,
/// 替换：$1$2: this.$1$2,
///
class TDText extends StatelessWidget {
  const TDText(
    this.data, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.backgroundColor,
    this.isTextThrough = false,
    this.lineThroughColor,
    this.package,
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
    this.isInFontLoader = false,
    this.fontFamilyUrl,
    Key? key,
  })  : textSpan = null,
        super(key: key);

  /// 富文本构造方法
  const TDText.rich(
    this.textSpan, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.backgroundColor,
    this.isTextThrough = false,
    this.lineThroughColor,
    this.package,
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
    this.isInFontLoader = false,
    this.fontFamilyUrl,
  })  : data = null,
        super(key: key);

  /// 字体尺寸，包含 大小size 和 行高height
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 字体ttf
  final FontFamily? fontFamily;

  /// 文本颜色
  final Color? textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 字体包名
  final String? package;

  /// 是否是横线穿过样式（删除线）
  final bool? isTextThrough;

  /// 删除线颜色，对应 TestStyle 的 decorationColor
  final Color? lineThroughColor;

  /// 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性
  final TextStyle? style;

  /// 以下系统 text 属性，释义请参考系统 [Text] 中注释
  final data;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection? textDirection;

  final Locale? locale;

  final bool? softWrap;

  final TextOverflow? overflow;

  final double? textScaleFactor;

  final int? maxLines;

  final String? semanticsLabel;

  final TextWidthBasis? textWidthBasis;

  final ui.TextHeightBehavior? textHeightBehavior;

  final InlineSpan? textSpan;

  /// 是否强制居中
  final bool forceVerticalCenter;

  /// 是否在 FontLoader 中使用
  final bool isInFontLoader;

  /// 是否禁用懒加载 FontFamily 的能力
  final String? fontFamilyUrl;

  @override
  Widget build(BuildContext context) {
    if (fontFamilyUrl?.isNotEmpty ?? false) {
      // 如果设置了 Url，则使用 TGFontLoader
      return TDFontLoaderWidget(
        textWidget: this,
        fontFamilyUrl: fontFamilyUrl!,
      );
    }
    if (forceVerticalCenter && kTextForceVerticalCenterEnable) {
      var config = getConfiguration(context);
      var paddingConfig = config?.paddingConfig;

      var textFont = font ??
          TDTheme.of(context).fontBodyLarge ??
          Font(size: 16, lineHeight: 24);
      var fontSize = style?.fontSize ?? textFont.size;
      var height = style?.height ?? textFont.height;

      paddingConfig ??= TDTextPaddingConfig.getDefaultConfig();
      var showHeight = min(paddingConfig.heightRate, height);
      return Container(
        color: style?.backgroundColor ?? backgroundColor,
        height: fontSize * height,
        padding: paddingConfig.getPadding(data, fontSize, height),
        child: _getRawText(
            context: context,
            textStyle: getTextStyle(context, height: showHeight)),
      );
    }
    var bgColor = style?.backgroundColor ?? backgroundColor;
    if (bgColor == null) {
      return _getRawText(context: context);
    }
    return Container(
      color: bgColor,
      child: _getRawText(context: context),
    );
  }

  /// 提取成方法，允许业务定义自己的 TDTextConfiguration
  TDTextConfiguration? getConfiguration(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDTextConfiguration>();
  }

  TextStyle? getTextStyle(BuildContext context,
      {double? height, Color? backgroundColor}) {
    var textFont = font ??
        TDTheme.of(context).fontBodyLarge ??
        Font(size: 16, lineHeight: 24);

    var stylePackage = package ?? fontFamily?.package;
    var styleFontFamily = style?.fontFamily ?? fontFamily?.fontFamily;
    if (kTextNeedGlobalFontFamily) {
      var globalFontFamily = getConfiguration(context)?.globalFontFamily;
      styleFontFamily ??= globalFontFamily?.fontFamily;
      stylePackage ??= globalFontFamily?.package;
    }
    var realFontWeight = style?.fontWeight ?? fontWeight;
    // Flutter 3.0 之后，iOS w500 之下字体不生效，需要替换字体
    if (PlatformUtil.isIOS &&
        (styleFontFamily == null || styleFontFamily.isEmpty) &&
        realFontWeight != null &&
        realFontWeight.index <= FontWeight.w500.index) {
      stylePackage = null;
      styleFontFamily = 'PingFang SC';
    }
    var color =
        style?.color ?? textColor ?? TDTheme.of(context).textColorPrimary;
    return TextStyle(
      inherit: style?.inherit ?? true,
      color: color,

      /// 不使用系统本身的背景色，因为系统属性存在中英文时，会导致颜色出现阶梯状
      backgroundColor: backgroundColor,
      fontSize: style?.fontSize ?? textFont.size,
      fontWeight: style?.fontWeight ?? fontWeight ?? textFont.fontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: height ?? style?.height ?? textFont.height,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration: style?.decoration ??
          (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: style?.decorationColor ?? lineThroughColor ?? color,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      // 如果需要字体懒加载，则清空 fontFamily
      fontFamily: styleFontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: isInFontLoader ? null : stylePackage,
    );
  }

  /// 获取系统原始 [Text]，以便使用到只能接收系统 [Text] 组件的地方
  /// 转化为系统原始 [Text] 后，将失去 padding 和 background 属性
  Text getRawText({required BuildContext context}) {
    return _getRawText(context: context, backgroundColor: backgroundColor);
  }

  Text _getRawText(
      {required BuildContext context,
      TextStyle? textStyle,
      Color? backgroundColor}) {
    return textSpan == null
        ? Text(
            data,
            key: key,
            style: textStyle ??
                getTextStyle(context, backgroundColor: backgroundColor),
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
          )
        : Text.rich(
            textSpan!,
            style: textStyle ??
                getTextStyle(context, backgroundColor: backgroundColor),
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
          );
  }
}

/// TextSpan 的 TDesign 扩展，将部分 TextStyle 中的参数扁平化。
class TDTextSpan extends TextSpan {
  /// 构造参数，扩展参数释义可参考[TDText]中字段注释
  TDTextSpan({
    BuildContext?
        context, // 如果未设置font，且不想使用默认的 fontBodyLarge 尺寸时，需设置context，否则可省略
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough = false,
    Color? lineThroughColor,
    String? package,
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
          style: _getTextStyle(context, style, font, fontWeight, fontFamily,
              textColor, isTextThrough, lineThroughColor, package),
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
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
    String? package,
  ) {
    var textFont = font ??
        TDTheme.of(context).fontBodyLarge ??
        Font(size: 16, lineHeight: 24);
    var color =
        style?.color ?? textColor ?? TDTheme.of(context).textColorPrimary;
    return TextStyle(
      inherit: style?.inherit ?? true,
      color: color,
      backgroundColor: style?.backgroundColor,
      fontSize: style?.fontSize ?? textFont.size,
      fontWeight: style?.fontWeight ?? fontWeight ?? textFont.fontWeight,
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
      decorationColor: style?.decorationColor ?? lineThroughColor ?? color,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: style?.fontFamily ?? fontFamily?.fontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: package,
    );
  }
}

/// 存储可以自定义 TDText 居中算法数据的内部控件
class TDTextConfiguration extends InheritedWidget {
  /// forceVerticalCenter=true 时，内置 padding 配置
  final TDTextPaddingConfig? paddingConfig;

  /// 全局字体，kTextNeedGlobalFontFamily=true 时生效
  final FontFamily? globalFontFamily;

  const TDTextConfiguration(
      {Key? key,
      required Widget child,
      this.paddingConfig,
      this.globalFontFamily})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant TDTextConfiguration oldWidget) {
    return paddingConfig != oldWidget.paddingConfig;
  }
}

/// 通过 Padding 自定义 TDText 居中算法
class TDTextPaddingConfig {
  static TDTextPaddingConfig? _defaultConfig;
  static final Map<double, Map<double, EdgeInsetsGeometry>> _cacheMap = {};

  /// 获取默认配置
  static TDTextPaddingConfig getDefaultConfig() {
    _defaultConfig ??= TDTextPaddingConfig();
    return _defaultConfig!;
  }

  /// 获取 padding
  EdgeInsetsGeometry getPadding(String? data, double fontSize, double height) {
    var cache = _cacheMap[fontSize]?[height];
    if (cache != null) {
      return cache;
    }
    var paddingFont = fontSize * paddingRate;
    var paddingLeading;
    if (height < heightRate) {
      paddingLeading = 0;
    } else {
      if (PlatformUtil.isIOS || PlatformUtil.isAndroid) {
        paddingLeading = (height * 0.5 - paddingExtraRate) * fontSize;
      } else {
        paddingLeading = 0;
      }
    }
    var paddingTop = paddingFont + paddingLeading;
    if (paddingTop < 0) {
      paddingTop = 0;
    }
    var padding = EdgeInsets.only(top: paddingTop);

    // 记录缓存
    var heightMap = _cacheMap[fontSize];
    if (heightMap == null) {
      heightMap = {};
      _cacheMap[fontSize] = heightMap;
    }
    heightMap[height] = padding;
    return padding;
  }

  /// todo 【待优化】在 web 中，顶部会有内边距（如24号字体有大小为6的内边距）
  /// 以多个汉字测量计算的平均值，Android为Pixel 4 模拟器，iOS 为 iphone 8 plus 模拟器
  double get paddingRate {
    if (VersionUtil.isAfterThen('3.2.0')) {
      // Dart 3.2.0 之后，文字渲染高度有改变。
      return PlatformUtil.isWeb
          ? 29 / 128
          : PlatformUtil.isAndroid
              ? -20 / 128
              : PlatformUtil.isOhos
                  ? 43 / 128
                  : -10 / 128;
    }
    return PlatformUtil.isWeb
        ? 3 / 8
        : PlatformUtil.isAndroid
            ? -7 / 128
            : PlatformUtil.isOhos
                ? 43 / 128
                : 0;
  }

  /// 以多个汉字测量计算的平均值，Android 为 Pixel 4 模拟器，iOS 为 iphone 8 plus 模拟器
  double get paddingExtraRate => PlatformUtil.isAndroid ? 115 / 256 : 97 / 240;

  /// height比 率，因为设置 1 时，Android 文字可能显示不全，默认为 1.1
  double get heightRate => PlatformUtil.isAndroid ? 1.1 : 1;
}
