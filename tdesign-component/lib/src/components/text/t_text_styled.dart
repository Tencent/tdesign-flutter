import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 't_text.dart';
import 't_text_resolve.dart';

/// 供组合组件绘制逐项变化的文字样式；不属于 TText 的公开配置入口。
///
/// 例如日历每天、标签栏选中态的文字样式来自所属组件的状态或 Theme，
/// 无法由整个子树的 TTextThemeData 表达。
@internal
class TTextStyled extends TText {
  const TTextStyled(
    super.data, {
    required this.style,
    super.font,
    super.fontWeight,
    super.fontFamily,
    super.textColor,
    super.isTextThrough,
    super.lineThroughColor,
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
    super.selectionColor,
    super.key,
  });

  final TextStyle? style;

  @override
  TextStyle getTextStyle(BuildContext context) => TTextResolve.resolve(
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
