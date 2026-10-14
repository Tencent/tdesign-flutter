import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:meta/meta.dart';

import '../../theme/basic.dart';
import 't_text.dart';
import 't_text_resolve.dart';
import 't_text_theme_data.dart';

/// 供组合组件绘制逐项变化的文字样式；不属于 TText 的公开配置入口。
///
/// 例如日历每天、标签栏选中态的文字样式来自所属组件的状态或 Theme，
/// 无法由整个子树的 TTextThemeData 表达。
@internal
class TTextStyled extends TText {
  const TTextStyled(
    super.data, {
    required super.style,
    super.font,
    this.centerLeading = false,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough,
    this.lineThroughColor,
    super.strutStyle,
    super.maxLines,
    super.overflow,
    super.textAlign,
    super.textDirection,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
    super.semanticsIdentifier,
    super.locale,
    super.textWidthBasis,
    super.textHeightBehavior,
    this.defaultTextHeightBehavior,
    super.selectionColor,
    super.key,
  });

  /// 固定数字、星期等内置文字的行高留白策略，不改变换行约束。
  final bool centerLeading;

  /// 组件自身的高度行为回退；实例和 TD 文字主题仍优先。
  final TextHeightBehavior? defaultTextHeightBehavior;

  static final _lineBreaks = RegExp(r'[\r\n\u2028\u2029]');

  final FontWeight? fontWeight;
  final FontFamily? fontFamily;
  final Color? textColor;
  final bool? isTextThrough;
  final Color? lineThroughColor;

  bool get _centered =>
      maxLines == 1 || (centerLeading && !data!.contains(_lineBreaks));

  @override
  Widget build(BuildContext context) {
    final text = _withStrut(context, super.build(context) as Text);
    if (!_centered) {
      return text;
    }
    // 单行先完成自然排版，再将真实行框居中到内容槽。
    // 原生 Text 在高度受限时会压缩 RenderParagraph 的布局框，但不会缩小
    // 绘制行；仅在外层 Align 居中该框，会使文字实际绘制位置偏下。
    // deferToChild 保留正常情况下的自适应尺寸；显式字体、槽尺寸与祖先裁切
    // 仍保持生效，不改写多行段落或调用方 Widget。
    return OverflowBox(
      fit: OverflowBoxFit.deferToChild,
      minHeight: 0,
      maxHeight: double.infinity,
      child: text,
    );
  }

  /// 按相同原生排版参数测量内置文字，供默认内容槽增长使用。
  /// 显式尺寸和自定义 Widget 的尺寸由所属组件保留。
  Size naturalSize(BuildContext context, {double maxWidth = double.infinity}) {
    final text = getRawText(context: context);
    final inherited = DefaultTextStyle.of(context);
    final style = MediaQuery.boldTextOf(context)
        ? text.style?.merge(const TextStyle(fontWeight: FontWeight.bold))
        : text.style;
    final painter = TextPainter(
      text: TextSpan(text: text.data, style: style),
      textDirection: text.textDirection ?? Directionality.of(context),
      textAlign: text.textAlign ?? inherited.textAlign ?? TextAlign.start,
      textScaler: text.textScaler ?? MediaQuery.textScalerOf(context),
      strutStyle: text.strutStyle,
      textHeightBehavior:
          text.textHeightBehavior ??
          inherited.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
      locale: text.locale ?? Localizations.maybeLocaleOf(context),
      maxLines: text.maxLines ?? inherited.maxLines,
      textWidthBasis: text.textWidthBasis ?? inherited.textWidthBasis,
    )..layout(maxWidth: maxWidth);
    final size = painter.size;
    painter.dispose();
    return size;
  }

  @override
  Text getRawText({required BuildContext context}) =>
      _withStrut(context, super.getRawText(context: context));

  Text _withStrut(BuildContext context, Text text) {
    final heightBehavior = text.textHeightBehavior ?? defaultTextHeightBehavior;
    final defaultStrut = !_centered
        ? text.strutStyle
        : TTextResolve.singleLineStrut(
            context: context,
            resolvedStyle: text.style!,
            configuredStyle: style,
            strutStyle: text.strutStyle,
            textHeightBehavior: heightBehavior,
          );
    final strut = defaultStrut ?? text.strutStyle;
    if (identical(strut, text.strutStyle) &&
        identical(heightBehavior, text.textHeightBehavior)) {
      return text;
    }
    return Text(
      text.data!,
      key: text.key,
      style: text.style,
      strutStyle: strut,
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      locale: text.locale,
      softWrap: text.softWrap,
      overflow: text.overflow,
      textScaler: text.textScaler,
      maxLines: text.maxLines,
      semanticsLabel: text.semanticsLabel,
      semanticsIdentifier: text.semanticsIdentifier,
      textWidthBasis: text.textWidthBasis,
      textHeightBehavior: heightBehavior,
      selectionColor: text.selectionColor,
    );
  }

  @override
  TextStyle getTextStyle(BuildContext context) {
    final explicitHeightBehavior =
        textHeightBehavior ??
        Theme.of(context).extension<TTextThemeData>()?.textHeightBehavior;
    return TTextResolve.resolve(
      context: context,
      singleLine: _centered && explicitHeightBehavior == null,
      style: style,
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough,
      lineThroughColor: lineThroughColor,
    );
  }
}
