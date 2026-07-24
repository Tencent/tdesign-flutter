import 'package:flutter/material.dart';

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
    final badgeTheme = BadgeTheme.of(context);
    final tTheme = Theme.of(context).extension<TBadgeThemeData>();
    final visible = variant == TBadgeVariant.dot || showZero || count != 0;
    final standaloneSize = badgeTheme.largeSize ?? 16;
    final content = child ?? SizedBox.square(dimension: standaloneSize);
    final badge = Badge(
      isLabelVisible: visible,
      alignment: badgeTheme.alignment,
      offset: badgeTheme.offset,
      backgroundColor: border ? Colors.transparent : badgeTheme.backgroundColor,
      textColor: badgeTheme.textColor,
      textStyle: badgeTheme.textStyle,
      padding: badgeTheme.padding,
      largeSize: variant == TBadgeVariant.small
          ? (badgeTheme.smallSize ?? 6) * 2
          : badgeTheme.largeSize,
      smallSize: badgeTheme.smallSize,
      label: variant == TBadgeVariant.dot
          ? null
          : _buildLabel(context, badgeTheme, tTheme),
      child: content,
    );

    if (onTap == null) {
      return badge;
    }
    return GestureDetector(onTap: onTap, child: badge);
  }

  Widget _buildLabel(
    BuildContext context,
    BadgeThemeData badgeTheme,
    TBadgeThemeData? tTheme,
  ) {
    final text = count > maxCount ? '$maxCount+' : '$count';
    if (!border) {
      return Text(text);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            badgeTheme.backgroundColor ?? Theme.of(context).colorScheme.error,
        border: Border.all(
          color: tTheme?.borderColor ?? Theme.of(context).colorScheme.surface,
          width: tTheme?.borderWidth ?? 1,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding:
            badgeTheme.padding ?? const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: badgeTheme.textStyle?.copyWith(color: badgeTheme.textColor),
        ),
      ),
    );
  }
}
