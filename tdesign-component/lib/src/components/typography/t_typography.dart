import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import 't_paragraph.dart';
import 't_text.dart';
import 't_title.dart';

/// TDesign Typography 组件族命名空间父组件。
///
/// 对应 TDesign H5 / 小程序的 `typography` 父级形态，作为静态入口
/// 暴露三个子组件：`text` / `title` / `paragraph`。
///
/// 注意：本类与 Flutter 原生 [Typography]（平台字阶数据容器）职责不同，
/// 前者是 TDesign 组件家族的静态入口，后者是主题字阶容器，两者不冲突。
///
/// ```dart
/// TTypography.text('基础文本')
/// TTypography.title('标题', level: TTitleLevel.h2)
/// TTypography.paragraph('段落', maxLines: 2, expandable: true)
/// ```
abstract final class TTypography {
  /// 基础文本子组件，等价于 [TText]。
  static TText text(
    String data, {
    Key? key,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
    TextStyle? style,
    bool copyable = false,
    bool expandable = false,
    bool? expanded,
    int? maxLines,
    ValueChanged<bool>? onExpandedChange,
    VoidCallback? onCopied,
    TextAlign? textAlign,
    TextOverflow? overflow,
  }) {
    return TText(
      data,
      key: key,
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough,
      lineThroughColor: lineThroughColor,
      style: style,
      copyable: copyable,
      expandable: expandable,
      expanded: expanded,
      maxLines: maxLines,
      onExpandedChange: onExpandedChange,
      onCopied: onCopied,
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  /// 标题子组件，等价于 [TTitle]。
  static TTitle title(
    String data, {
    Key? key,
    TTitleLevel level = TTitleLevel.h1,
    Color? textColor,
    bool expandable = false,
    bool? expanded,
    int? maxLines,
    ValueChanged<bool>? onExpandedChange,
    TextAlign? textAlign,
  }) {
    return TTitle(
      data,
      key: key,
      level: level,
      textColor: textColor,
      expandable: expandable,
      expanded: expanded,
      maxLines: maxLines,
      onExpandedChange: onExpandedChange,
      textAlign: textAlign,
    );
  }

  /// 段落子组件，等价于 [TParagraph]。
  static TParagraph paragraph(
    String data, {
    Key? key,
    Color? textColor,
    bool expandable = false,
    bool? expanded,
    int? maxLines,
    ValueChanged<bool>? onExpandedChange,
    TextAlign? textAlign,
  }) {
    return TParagraph(
      data,
      key: key,
      textColor: textColor,
      expandable: expandable,
      expanded: expanded,
      maxLines: maxLines,
      onExpandedChange: onExpandedChange,
      textAlign: textAlign,
    );
  }
}
