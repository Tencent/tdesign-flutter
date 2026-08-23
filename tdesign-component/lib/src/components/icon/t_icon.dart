import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_icon_theme_data.dart';

/// TIcon 图标组件
///
/// Material [Icon] 的薄包装，提供 TDesign 默认颜色和组件级 Theme 注入能力。
/// 图标数据由 `tdesign_flutter_icons` 资源包提供，通过 `TIcons.xxx` 常量引用。
///
/// 优先级链：
/// 构造器参数 > [TIconThemeData] > [IconTheme] > ThemeData.iconTheme >
/// TDesign token 颜色兜底。
///
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
  /// 要绘制的图标数据，通常使用 `tdesign_flutter_icons` 提供的 `TIcons.xxx`。
  final IconData icon;

  /// 图标尺寸，单位为逻辑像素。
  ///
  /// 未设置时依次读取 [TIconThemeData.size]、显式 [IconTheme]，最后由 Flutter
  /// 原生 [Icon] 使用其默认尺寸。
  final double? size;

  /// 图标颜色。
  ///
  /// 未设置时依次读取 [TIconThemeData.color]、显式 [IconTheme]，最后回退到
  /// TDesign 的 `textColorPrimary` Token。
  final Color? color;

  /// 无障碍语义标签。
  ///
  /// 非空时由原生 [Icon] 暴露给辅助技术；为空时图标不单独提供语义节点。
  final String? semanticLabel;

  const TIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  /// 通过图标名称构造，并在 [TIcons.allIconsMap] 中查找对应图标。
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
    final effectiveColor =
        color ??
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
