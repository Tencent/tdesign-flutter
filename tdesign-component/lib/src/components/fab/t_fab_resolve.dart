import 'package:flutter/material.dart';

import '../../components/button/t_button.dart';
import '../../components/button/t_button_theme_data.dart';
import '../../components/button/t_button_types.dart';
import '../../theme/t_theme.dart';
import 't_fab_defaults.dart';
import 't_fab_layout.dart';

/// TFab 唯一样式 resolve 入口
///
/// - [resolveLayout]：将构造器扁平参数 + Theme + 安全区组装为 [TFabLayout]
/// - [resolveButton]：将 Fab 默认配置 + text/icon 组装为一颗 [TButton]
class TFabResolve {
  TFabResolve._(); // coverage:ignore-line

  /// 组装定位层模型
  static TFabLayout resolveLayout({
    required double? right,
    required double? bottom,
    required TFabDragAxis? draggable,
    required TFabMagnet? magnet,
    required TFabBounds? xBounds,
    required TFabBounds? yBounds,
    required double? themeDefaultRight,
    required double? themeDefaultBottom,
    required TFabBounds? themeDefaultXBounds,
    required TFabBounds? themeDefaultYBounds,
    required EdgeInsets safePadding,
  }) {
    final effectiveRight = right ?? themeDefaultRight ?? 16;
    final effectiveBottom = bottom ?? themeDefaultBottom ?? 32;
    final adjustedRight = effectiveRight + safePadding.right;
    final adjustedBottom = effectiveBottom + safePadding.bottom;

    return TFabLayout(
      right: adjustedRight,
      bottom: adjustedBottom,
      draggable: draggable,
      magnet: magnet,
      xBounds: xBounds ?? themeDefaultXBounds,
      yBounds: yBounds ?? themeDefaultYBounds,
      safePadding: safePadding,
    );
  }

  /// 组装内嵌 TButton
  ///
  /// shape 推导（对齐 fab.md §1）：
  /// - 纯图标（text 空）→ `TButtonShape.circle`
  /// - 有 text → `TButtonShape.round`
  static Widget resolveButton({
    required String? text,
    required Widget? icon,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    required BuildContext context,
  }) {
    final hasText = text != null && text.isNotEmpty;
    final effectiveIcon = icon ?? const Icon(TFabDefaults.defaultIconData);

    // shape 推导：纯图标=圆形，有文字=胶囊形。
    final effectiveShape = hasText ? TButtonShape.round : TButtonShape.circle;

    final tButton = TButton(
      child: hasText ? Text(text) : null,
      icon: effectiveIcon,
      onPressed: onPressed,
      onLongPress: onLongPress,
    );

    // TButton 的 shape 由 TButtonThemeData.shape 控制
    // 合并父级 TButtonThemeData（保留其他字段）+ 推导出的 shape
    final parentBtnTheme = Theme.of(context).extension<TButtonThemeData>();
    final fabBtnTheme = (parentBtnTheme ?? const TButtonThemeData())
        .copyWith(shape: effectiveShape);

    return Theme(
      data: Theme.of(context).mergeExtension(fabBtnTheme),
      child: tButton,
    );
  }
}
