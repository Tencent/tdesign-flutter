import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';

/// 仅供 TDesign 组合组件传递已解析的图标外观；不读取外部 Material IconTheme。
class TIconStyleScope extends InheritedWidget {
  const TIconStyleScope({
    super.key,
    required this.color,
    required this.size,
    required super.child,
  });

  final Color? color;
  final double? size;

  static TIconStyleScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TIconStyleScope>();

  @override
  bool updateShouldNotify(TIconStyleScope oldWidget) =>
      color != oldWidget.color || size != oldWidget.size;
}

/// TIcon 图标组件
///
/// Material [Icon] 的薄包装，提供 TDesign 默认尺寸和颜色。
/// 图标数据由 `tdesign_flutter_icons` 资源包提供，通过 `TIcons.xxx` 常量引用。
///
/// 构造器参数优先，其次使用 TDesign 组合组件的内部样式；独立使用时
/// 默认尺寸为 24dp，默认颜色读取 TDesign 全局 Token。
/// 外层 Material [IconTheme] 不控制 TDesign 图标。
/// 没有独立的 Icon Theme，独立使用时可配置 [size]、[color]，
/// 默认颜色来自 [TThemeData] 的 `textColorPrimary` Token。
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
/// ```
class TIcon extends StatelessWidget {
  /// 要绘制的图标数据，通常使用 `tdesign_flutter_icons` 提供的 `TIcons.xxx`。
  final IconData icon;

  /// 图标尺寸，单位为逻辑像素。
  ///
  /// 未设置时继承 TDesign 组合组件的图标尺寸；独立使用时为 24dp。
  final double? size;

  /// 图标颜色。
  ///
  /// 未设置时继承 TDesign 组合组件的图标颜色；独立使用时读取 `textColorPrimary` Token。
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
    final scope = TIconStyleScope.maybeOf(context);
    final effectiveSize = size ?? scope?.size ?? 24.0;
    final effectiveColor =
        color ?? scope?.color ?? context.tTheme.textColorPrimary;

    return Icon(
      icon,
      size: effectiveSize,
      color: effectiveColor,
      semanticLabel: semanticLabel,
    );
  }
}
