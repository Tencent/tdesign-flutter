import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_badge_theme_data.dart';

/// 徽标形态。
enum TBadgeVariant {
  /// 标准数字徽标。
  normal,

  /// 紧凑数字徽标。
  small,

  /// 不显示数字的圆点徽标。
  dot,
}

/// 在内容右上角展示数字或圆点状态。
class TBadge extends StatelessWidget {
  const TBadge({
    super.key,
    this.count = 0,
    this.maxCount = 99,
    this.variant = TBadgeVariant.normal,
    this.border = false,
    this.showZero = true,
    this.child,
    this.onTap,
  })  : assert(count >= 0, 'count must not be negative'),
        assert(maxCount > 0, 'maxCount must be greater than zero');

  /// 当前数量。
  final int count;

  /// 最大显示数量，超出后显示 `[maxCount]+`。
  final int maxCount;

  /// 徽标形态。
  final TBadgeVariant variant;

  /// 是否为徽标增加对比色描边。
  final bool border;

  /// [count] 为 0 时是否显示徽标。
  final bool showZero;

  /// 被徽标标记的内容；为空时徽标可独立展示。
  final Widget? child;

  /// 点击回调；为空时不创建点击语义。
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final localBadgeTheme =
        context.dependOnInheritedWidgetOfExactType<BadgeTheme>()?.data;
    final globalBadgeTheme = materialTheme.badgeTheme;
    final tTheme = Theme.of(context).extension<TBadgeThemeData>();
    final token = context.tTheme;
    final backgroundColor = localBadgeTheme?.backgroundColor ??
        globalBadgeTheme.backgroundColor ??
        token.errorNormalColor;
    final textColor = localBadgeTheme?.textColor ??
        globalBadgeTheme.textColor ??
        token.textColorAnti;
    final smallSize =
        localBadgeTheme?.smallSize ?? globalBadgeTheme.smallSize ?? 6;
    final largeSize =
        localBadgeTheme?.largeSize ?? globalBadgeTheme.largeSize ?? 16;
    final textStyle = localBadgeTheme?.textStyle ??
        globalBadgeTheme.textStyle ??
        materialTheme.textTheme.labelSmall ??
        TextStyle(
          color: textColor,
          fontSize: token.fontMarkExtraSmall?.size,
          height: token.fontMarkExtraSmall?.height,
          fontWeight: token.fontMarkExtraSmall?.fontWeight,
        );
    final padding = localBadgeTheme?.padding ??
        globalBadgeTheme.padding ??
        const EdgeInsets.symmetric(horizontal: 4);
    final alignment = localBadgeTheme?.alignment ?? globalBadgeTheme.alignment;
    final offset = localBadgeTheme?.offset ?? globalBadgeTheme.offset;
    final visible = variant == TBadgeVariant.dot || showZero || count != 0;
    final effectiveLargeSize =
        variant == TBadgeVariant.small ? smallSize * 2 : largeSize;
    final isDot = variant == TBadgeVariant.dot;
    final isSmall = variant == TBadgeVariant.small;
    final text = count > maxCount ? '$maxCount+' : '$count';
    final textLabel = Text(text);
    final label = isDot
        ? null
        : isSmall
            ? _buildCompactLabel(
                textLabel,
                effectiveLargeSize,
                isSingleCharacter: text.length == 1,
              )
            : textLabel;
    final effectivePadding = isSmall || isDot ? EdgeInsets.zero : padding;
    final effectiveLabel = border
        ? _buildBorderedLabel(
            label: label,
            backgroundColor: backgroundColor,
            borderColor:
                tTheme?.borderColor ?? materialTheme.colorScheme.surface,
            borderWidth: tTheme?.borderWidth ?? 1,
            padding: effectivePadding,
            minHeight: isDot ? smallSize : effectiveLargeSize,
            minWidth: isDot ? smallSize : 0,
          )
        : label;
    final badge = Badge(
      isLabelVisible: visible,
      alignment: alignment,
      offset: offset,
      backgroundColor: border ? Colors.transparent : backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      padding: border ? EdgeInsets.zero : effectivePadding,
      largeSize: isDot && border ? smallSize : effectiveLargeSize,
      smallSize: smallSize,
      label: effectiveLabel,
      child: child,
    );

    if (onTap == null) {
      return badge;
    }
    return GestureDetector(onTap: onTap, child: badge);
  }

  Widget _buildCompactLabel(
    Widget label,
    double height, {
    required bool isSingleCharacter,
  }) {
    final fittedLabel = FittedBox(
      fit: BoxFit.scaleDown,
      child: label,
    );
    if (isSingleCharacter) {
      return SizedBox.square(
        dimension: height,
        child: fittedLabel,
      );
    }
    return SizedBox(
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: label,
        ),
      ),
    );
  }

  Widget _buildBorderedLabel({
    required Widget? label,
    required Color backgroundColor,
    required Color borderColor,
    required double borderWidth,
    required EdgeInsetsGeometry padding,
    required double minHeight,
    required double minWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: padding,
          child: Center(
            child: label,
          ),
        ),
      ),
    );
  }
}
