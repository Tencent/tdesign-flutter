import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/basic.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_font_loader.dart';
import 't_text_resolve.dart';
import 't_text_theme_data.dart';

/// 文本控件
/// 设计原则：
/// 1. 作为系统 Text 的扩展封装，保持系统文本能力可达。
/// 2. 非系统已有属性，尽量添加注释
///
/// 需求：把一部分在 TextStyle 中的属性扁平化，放到外层。
/// 1. 暴露系统的所有属性，支持系统所有操作
/// 2. 约束使用主题配置的几种字体
/// 3. 提供转换为系统 Text 的方法，以使某些系统组件指定接收系统 Text 时可使用。（Image 组件同理）
/// 4. 支持自定义 TextStyle
/// 5. 支持 TextSpan 形式
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
class TText extends StatelessWidget {
  const TText(
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
    this.isInFontLoader = false,
    this.fontFamilyUrl,
    Key? key,
  }) : textSpan = null,
       super(key: key);

  /// 富文本构造方法
  const TText.rich(
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
    this.isInFontLoader = false,
    this.fontFamilyUrl,
  }) : data = null,
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

  /// 透传至系统 [Text.data] 的文本内容
  final String? data;

  /// 透传至系统 [Text.strutStyle] 的段落支柱样式
  final StrutStyle? strutStyle;

  /// 透传至系统 [Text.textAlign] 的文本对齐方式
  final TextAlign? textAlign;

  /// 透传至系统 [Text.textDirection] 的文本方向
  final TextDirection? textDirection;

  /// 透传至系统 [Text.locale] 的区域设置
  final Locale? locale;

  /// 透传至系统 [Text.softWrap]，控制是否自动换行
  final bool? softWrap;

  /// 透传至系统 [Text.overflow] 的溢出处理方式
  final TextOverflow? overflow;

  /// 文本缩放倍率，内部转换为系统 [Text.textScaler]
  final double? textScaleFactor;

  /// 透传至系统 [Text.maxLines] 的最大行数
  final int? maxLines;

  /// 透传至系统 [Text.semanticsLabel] 的无障碍标签
  final String? semanticsLabel;

  /// 透传至系统 [Text.textWidthBasis] 的宽度计算基准
  final TextWidthBasis? textWidthBasis;

  /// 透传至系统 [Text.textHeightBehavior] 的高度行为
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 透传至系统 [Text.rich] 的富文本片段
  final InlineSpan? textSpan;

  /// 是否在 FontLoader 中使用
  final bool isInFontLoader;

  /// 是否禁用懒加载 FontFamily 的能力
  final String? fontFamilyUrl;

  @override
  Widget build(BuildContext context) {
    if (fontFamilyUrl?.isNotEmpty ?? false) {
      // 如果设置了 Url，则使用 TGFontLoader
      return TFontLoaderWidget(
        // coverage:ignore-line
        textWidget: this,
        fontFamilyUrl: fontFamilyUrl!, // coverage:ignore-line
      );
    }

    final themeExtension = Theme.of(context).extension<TTextThemeData>();
    var bgColor =
        style?.backgroundColor ??
        backgroundColor ??
        themeExtension?.defaultBackgroundColor;
    if (bgColor == null) {
      return _getRawText(context: context);
    }
    return Container(
      color: bgColor,
      child: _getRawText(context: context),
    );
  }

  /// 获取最终的 [TextStyle]，委托 [TTextResolve.resolve] 统一处理
  ///
  /// TText 与 TTextSpan 统一走单路径 Resolve。
  TextStyle? getTextStyle(
    BuildContext context, {
    Color? textStyleBackgroundColor,
  }) {
    return TTextResolve.resolve(
      context: context,
      style: style,
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough ?? false,
      lineThroughColor: lineThroughColor,
      package: package,
      isInFontLoader: isInFontLoader,
      textStyleBackgroundColor: textStyleBackgroundColor,
    );
  }

  /// 获取系统原始 [Text]，以便使用到只能接收系统 [Text] 组件的地方
  /// 转化为系统原始 [Text] 后，将失去 padding 和 background 属性
  Text getRawText({required BuildContext context}) {
    return _getRawText(
      context: context,
      textStyleBackgroundColor: backgroundColor,
      includeKey: true,
    );
  }

  Text _getRawText({
    required BuildContext context,
    TextStyle? textStyle,
    Color? textStyleBackgroundColor,
    bool includeKey = false,
  }) {
    final scale = textScaleFactor ?? _textTheme(context)?.textScaleFactor;
    final textScaler = scale == null ? null : TextScaler.linear(scale);
    return textSpan == null
        ? Text(
            data ?? '',
            key: includeKey ? key : null,
            style:
                textStyle ??
                getTextStyle(
                  context,
                  textStyleBackgroundColor: textStyleBackgroundColor,
                ),
            strutStyle: strutStyle ?? _textTheme(context)?.strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis:
                textWidthBasis ?? _textTheme(context)?.textWidthBasis,
            textHeightBehavior:
                textHeightBehavior ?? _textTheme(context)?.textHeightBehavior,
          )
        : Text.rich(
            textSpan!,
            key: includeKey ? key : null,
            style:
                textStyle ??
                getTextStyle(
                  context,
                  textStyleBackgroundColor: textStyleBackgroundColor,
                ),
            strutStyle: strutStyle ?? _textTheme(context)?.strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis:
                textWidthBasis ?? _textTheme(context)?.textWidthBasis,
            textHeightBehavior:
                textHeightBehavior ?? _textTheme(context)?.textHeightBehavior,
          );
  }

  TTextThemeData? _textTheme(BuildContext context) {
    return Theme.of(context).extension<TTextThemeData>();
  }
}

/// TextSpan 的 TDesign 扩展，将部分 TextStyle 中的参数扁平化。
class TTextSpan extends TextSpan {
  /// 构造 TDesign 扩展富文本片段。
  ///
  /// [context] 当前构建上下文；提供 Theme 和 Token 以解析默认字体样式。
  /// [font] 字体尺寸，包含 size 和 lineHeight。
  /// [fontWeight] 字体粗细。
  /// [fontFamily] 字体族。
  /// [textColor] 文本颜色。
  /// [isTextThrough] 是否应用删除线样式。
  /// [lineThroughColor] 删除线颜色，对应 [TextStyle.decorationColor]。
  /// [package] 字体资源包名。
  /// [text] 文本内容，透传至系统 [TextSpan.text]。
  /// [children] 子富文本片段，透传至系统 [TextSpan.children]。
  /// [style] 自定义文本样式；其中指定的属性优先于扁平化参数。
  /// [recognizer] 手势识别器，透传至系统 [TextSpan.recognizer]。
  /// [mouseCursor] 鼠标指针样式，透传至系统 [TextSpan.mouseCursor]。
  /// [onEnter] 鼠标进入回调，透传至系统 [TextSpan.onEnter]。
  /// [onExit] 鼠标离开回调，透传至系统 [TextSpan.onExit]。
  /// [semanticsLabel] 无障碍标签，透传至系统 [TextSpan.semanticsLabel]。
  TTextSpan({
    /// 当前构建上下文；提供 Theme 和 Token 以解析默认字体样式。
    BuildContext? context,

    /// 字体尺寸，包含 size 和 lineHeight。
    Font? font,

    /// 字体粗细。
    FontWeight? fontWeight,

    /// 字体族。
    FontFamily? fontFamily,

    /// 文本颜色。
    Color? textColor,

    /// 是否应用删除线样式。
    bool? isTextThrough = false,

    /// 删除线颜色，对应 [TextStyle.decorationColor]。
    Color? lineThroughColor,

    /// 字体资源包名。
    String? package,

    /// 文本内容，透传至系统 [TextSpan.text]。
    String? text,

    /// 子富文本片段，透传至系统 [TextSpan.children]。
    List<InlineSpan>? children,

    /// 自定义文本样式；其中指定的属性优先于扁平化参数。
    TextStyle? style,

    /// 手势识别器，透传至系统 [TextSpan.recognizer]。
    GestureRecognizer? recognizer,

    /// 鼠标指针样式，透传至系统 [TextSpan.mouseCursor]。
    MouseCursor? mouseCursor,

    /// 鼠标进入回调，透传至系统 [TextSpan.onEnter]。
    PointerEnterEventListener? onEnter,

    /// 鼠标离开回调，透传至系统 [TextSpan.onExit]。
    PointerExitEventListener? onExit,

    /// 无障碍标签，透传至系统 [TextSpan.semanticsLabel]。
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
           package,
         ),
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
    return TTextResolve.resolveSpan(
      context: context,
      style: style,
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough ?? false,
      lineThroughColor: lineThroughColor,
      package: package,
    );
  }
}

/// 存储可以自定义 TText 居中算法数据的内部控件
class TTextConfiguration extends InheritedWidget {
  /// 全局字体族，设置后子树中所有 TText 将默认使用此字体
  ///
  /// 始终作为子树配置参与样式 resolve。
  final FontFamily? globalFontFamily;

  /// 构造 TText 子树配置。
  ///
  /// [child] 子树内容，配置会作用于该子树内的 TText。
  /// [globalFontFamily] 全局字体族，设置后子树中所有 TText 将默认使用此字体。
  const TTextConfiguration({
    Key? key,

    /// 子树内容，配置会作用于该子树内的 TText。
    required Widget child,

    /// 全局字体族，设置后子树中所有 TText 将默认使用此字体。
    this.globalFontFamily,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant TTextConfiguration oldWidget) {
    return globalFontFamily != oldWidget.globalFontFamily;
  }
}
