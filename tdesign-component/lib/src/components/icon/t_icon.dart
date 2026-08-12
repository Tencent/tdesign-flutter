import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_icon_theme_data.dart';

/// TIcon 图标组件
///
/// Material [Icon] 的薄包装（T2 纯展示），提供组件级 Theme 注入能力。
/// 图标数据由 `tdesign_flutter_icons` 资源包提供，通过 `TIcons.xxx` 常量引用。
///
/// 优先级链：
/// 构造器参数 > [TIconThemeData] > [IconTheme] > ThemeData.iconTheme >
/// TDesign token 颜色兜底。
///
/// 示例：
/// ```dart
/// // 基础使用
/// TIcon(TIcons.home_filled)
///
/// // 指定尺寸和颜色
/// TIcon(TIcons.setting, size: 24, color: Colors.blue)
///
/// // 通过名称引用
/// TIcon.fromName('home_filled')
///
/// // 子树 Theme 注入
/// Theme(
///   data: Theme.of(context).mergeExtension(
///     const TIconThemeData(size: 20, color: Colors.grey),
///   ),
///   child: TIcon(TIcons.home_filled),
/// )
/// ```
class TIcon extends StatelessWidget {
  /// 图标数据（位置参数）
  final IconData icon;

  /// 图标尺寸（优先于 [TIconThemeData.size] 和 [IconTheme.of]）
  final double? size;

  /// 图标颜色（优先于 [TIconThemeData.color]、[IconTheme.of] 和 token 兜底）
  final Color? color;

  /// 无障碍语义标签
  final String? semanticLabel;

  const TIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  /// 通过图标名称构造（查找 [TIcons.allIconsMap]）
  ///
  /// 如果名称不存在，抛出 [ArgumentError]。
  factory TIcon.fromName(
    /// 图标名称，对应 [TIcons.allIconsMap] 中的 key。
    String name, {
    Key? key,
    double? size,
    Color? color,
    String? semanticLabel,
  }) {
    final iconData = TIcons.allIconsMap[name];
    if (iconData == null) {
      throw ArgumentError('Unknown icon name: $name');
    }
    return TIcon(
      iconData,
      key: key,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final theme = materialTheme.extension<TIconThemeData>();
    final iconTheme = context.tExplicitIconTheme;

    // 尺寸不硬造 token 映射，颜色必须兜到 TDesign token。
    final effectiveSize = size ?? theme?.size ?? iconTheme?.size;
    final effectiveColor = color ??
        theme?.color ??
        iconTheme?.color ??
        context.tTheme.textColorPrimary;

    return Icon(
      icon,
      size: effectiveSize,
      color: effectiveColor,
      semanticLabel: semanticLabel,
    );
  }
}
