import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_badge_defaults.dart';
import 't_badge_theme_data.dart';

/// TBadge 与内部消费组件共用的主题和几何解析结果。
@internal
class TBadgeResolvedStyle {
  const TBadgeResolvedStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.smallSize,
    required this.largeSize,
    required this.textStyle,
    required this.padding,
    required this.alignment,
    required this.offset,
    required this.borderColor,
    required this.borderWidth,
  });

  factory TBadgeResolvedStyle.resolve(
    BuildContext context, {
    required bool large,
    AlignmentGeometry? alignment,
    Offset? offset,
    AlignmentGeometry? fallbackAlignment,
    Offset? fallbackOffset,
  }) {
    final tBadgeTheme = Theme.of(context).extension<TBadgeThemeData>();
    final token = context.tTheme;
    final backgroundColor = tBadgeTheme?.backgroundColor ?? token.errorColor;
    final textColor = tBadgeTheme?.textStyle?.color ?? token.textColorAnti;
    final smallSize = tBadgeTheme?.dotSize ?? TBadgeDefaults.dotSize;
    final font = large ? token.fontMarkSmall : token.fontMarkExtraSmall;
    final themedTextStyle = tBadgeTheme?.textStyle;
    final resolvedTextStyle = TextStyle(
      color: textColor,
      fontSize: font?.size,
      height: font?.height,
      fontWeight: font?.fontWeight,
      letterSpacing: 0,
    ).merge(themedTextStyle);
    final padding =
        tBadgeTheme?.padding ?? EdgeInsets.symmetric(horizontal: large ? 6 : 4);
    final tokenHeight = (font?.size ?? 0) * (font?.height ?? 0);
    final defaultLabelHeight = tokenHeight > 0
        ? tokenHeight
        : large
        ? 20.0
        : 16.0;

    return TBadgeResolvedStyle(
      backgroundColor: backgroundColor,
      textColor: textColor,
      smallSize: smallSize,
      largeSize: tBadgeTheme?.labelHeight ?? defaultLabelHeight,
      textStyle: resolvedTextStyle,
      padding: padding,
      alignment: resolveAlignment(
        context,
        alignment: alignment,
        fallbackAlignment: fallbackAlignment,
      ),
      offset: offset ?? fallbackOffset ?? Offset.zero,
      borderColor: tBadgeTheme?.borderColor ?? token.bgColorContainer,
      borderWidth: tBadgeTheme?.borderWidth ?? TBadgeDefaults.borderWidth,
    );
  }

  /// 按实例和消费组件默认值解析最终对齐方式。
  static AlignmentGeometry resolveAlignment(
    BuildContext context, {
    AlignmentGeometry? alignment,
    AlignmentGeometry? fallbackAlignment,
  }) {
    return alignment ?? fallbackAlignment ?? AlignmentDirectional.topEnd;
  }

  final Color backgroundColor;
  final Color textColor;
  final double smallSize;
  final double largeSize;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Offset offset;
  final Color borderColor;
  final double borderWidth;

  /// 文本徽标按 TBadge 实际规则占用的尺寸。
  Size measureLabel(BuildContext context, String label) {
    final resolvedPadding = padding.resolve(Directionality.of(context));
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = math.max(
      largeSize,
      textPainter.width + resolvedPadding.horizontal,
    );
    textPainter.dispose();
    return Size(width, largeSize);
  }
}
