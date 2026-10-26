import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 't_badge.dart';
import 't_badge_fallback.dart';

/// 将组合组件的 [TBadgeConfig] 交给 TBadge 渲染。
///
/// 此适配层不属于公开 API；业务侧应使用 [TBadge] 或 [TBadgeConfig]。
@internal
class TBadgeFromConfig extends StatelessWidget {
  const TBadgeFromConfig({
    super.key,
    required this.config,
    this.child,
    this.onTap,
    this.fallbackAlignment,
    this.fallbackOffset,
  });

  final TBadgeConfig config;
  final Widget? child;
  final GestureTapCallback? onTap;
  final AlignmentGeometry? fallbackAlignment;
  final Offset? fallbackOffset;

  @override
  Widget build(BuildContext context) {
    final badge = config.isCustom
        ? TBadge.custom(
            badge: config.badge!,
            alignment: config.alignment,
            offset: config.offset,
            onTap: onTap,
            child: child,
          )
        : TBadge(
            label: config.label,
            variant: config.variant,
            size: config.size,
            border: config.border,
            showZero: config.showZero,
            alignment: config.alignment,
            offset: config.offset,
            onTap: onTap,
            child: child,
          );
    return TBadgeFallback(
      alignment: fallbackAlignment,
      offset: fallbackOffset,
      child: badge,
    );
  }
}
