import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 't_badge_resolved_style.dart';

/// 判断文本是否只包含一个用户可见字符。
///
/// 使用 grapheme cluster 而不是 Unicode code point，确保组合音标、肤色修饰符
/// 和 ZWJ emoji 与普通单字符采用相同的徽标几何规则。
@internal
bool isSingleBadgeCharacter(String value) => value.characters.length == 1;

/// 将以物理右上角为基准的组件默认偏移转换到最终对齐位置。
///
/// 仅用于组合组件提供的默认值。水平和垂直方向跟随最终生效的 [alignment]；
/// 用户显式传入的 [Offset] 是物理坐标，不经过该转换。
@internal
Offset resolveBadgeFallbackOffset(
  BuildContext context,
  Offset topRightOffset, {
  AlignmentGeometry? alignment,
  AlignmentGeometry? fallbackAlignment,
}) {
  final resolvedAlignment = TBadgeResolvedStyle.resolveAlignment(
    context,
    alignment: alignment,
    fallbackAlignment: fallbackAlignment,
  ).resolve(Directionality.of(context));
  return Offset(
    topRightOffset.dx * resolvedAlignment.x,
    topRightOffset.dy * -resolvedAlignment.y,
  );
}
