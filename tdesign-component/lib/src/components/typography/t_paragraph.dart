import 'package:flutter/material.dart';

import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_text.dart';

/// TDesign Typography 段落组件。
///
/// 对应小程序 `t-typography-paragraph`，基于 [TText] 组合实现。
/// 默认字号为 `fontBodyMedium`（14/22），语义化多行正文。
///
/// ```dart
/// TParagraph('这是一段正文文本')
/// TParagraph('可省略的段落', maxLines: 2, expandable: true)
/// ```
class TParagraph extends StatelessWidget {
  /// 段落内容。
  final String data;

  /// 段落颜色。
  final Color? textColor;

  /// 是否支持展开/收起。为 true 且内容超出 [maxLines] 时显示操作。
  final bool expandable;

  /// 展开状态（受控）。为 null 时组件内部自管理。
  final bool? expanded;

  /// 省略行数，配合 [expandable] 使用。
  final int? maxLines;

  /// 展开状态变化回调。
  final ValueChanged<bool>? onExpandedChange;

  /// 透传至 [TText.textAlign]。
  final TextAlign? textAlign;

  const TParagraph(
    this.data, {
    super.key,
    this.textColor,
    this.expandable = false,
    this.expanded,
    this.maxLines,
    this.onExpandedChange,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return TText(
      data,
      font: context.tTheme.fontBodyMedium,
      textColor: textColor,
      expandable: expandable,
      expanded: expanded,
      maxLines: maxLines,
      onExpandedChange: onExpandedChange,
      textAlign: textAlign,
    );
  }
}
