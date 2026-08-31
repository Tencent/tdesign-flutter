import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_text.dart';

/// 标题级别。
///
/// 对应 TDesign Typography `Title` 的 `level`，从 h1（最大）到 h6（最小）。
enum TTitleLevel {
  /// 一级标题。
  h1,

  /// 二级标题。
  h2,

  /// 三级标题。
  h3,

  /// 四级标题。
  h4,

  /// 五级标题。
  h5,

  /// 六级标题。
  h6,
}

/// TDesign Typography 标题组件。
///
/// 对应小程序 `t-typography-title`，基于 [TText] 组合实现。
/// 通过 [level] 映射 TDesign Font token，固定消费 TDesign token，
/// 不随 Flutter 平台 `TextTheme` 本地化。
///
/// ```dart
/// TTitle('一级标题')
/// TTitle('三级标题', level: TTitleLevel.h3)
/// ```
class TTitle extends StatelessWidget {
  /// 标题内容。
  final String data;

  /// 标题级别，默认 [TTitleLevel.h1]。
  final TTitleLevel level;

  /// 标题颜色。
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

  const TTitle(
    this.data, {
    super.key,
    this.level = TTitleLevel.h1,
    this.textColor,
    this.expandable = false,
    this.expanded,
    this.maxLines,
    this.onExpandedChange,
    this.textAlign,
  });

  /// 根据 [level] 映射对应 TDesign Font token。
  ///
  /// 固定消费 TDesign token，不随 Flutter 平台 `TextTheme` 本地化；
  /// token 缺失时回退到 `fontTitleLarge`。
  Font _resolveFont(BuildContext context) {
    final token = context.tTheme;
    switch (level) {
      case TTitleLevel.h1:
        return token.fontHeadlineLarge ?? token.fontTitleLarge!;
      case TTitleLevel.h2:
        return token.fontHeadlineMedium ?? token.fontTitleLarge!;
      case TTitleLevel.h3:
        return token.fontHeadlineSmall ?? token.fontTitleLarge!;
      case TTitleLevel.h4:
        return token.fontTitleLarge!;
      case TTitleLevel.h5:
        return token.fontTitleMedium ?? token.fontTitleLarge!;
      case TTitleLevel.h6:
        return token.fontTitleSmall ?? token.fontTitleLarge!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TText(
      data,
      font: _resolveFont(context),
      textColor: textColor,
      expandable: expandable,
      expanded: expanded,
      maxLines: maxLines,
      onExpandedChange: onExpandedChange,
      textAlign: textAlign,
    );
  }
}
