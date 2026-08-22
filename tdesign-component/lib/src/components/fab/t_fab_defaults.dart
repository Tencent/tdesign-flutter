import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../button/t_button_types.dart';

/// 内嵌 TButton 默认配置
///
/// 纯图标 Fab 默认 shape = circle，有 text 时 shape = round。
class TFabDefaults {
  TFabDefaults._(); // coverage:ignore-line

  /// 默认尺寸：与小程序 Fab 的 large 基线一致。
  static const defaultSize = TButtonSize.large;

  /// 默认变体：Fab 始终使用填充动作层。
  static const defaultVariant = TButtonVariant.fill;

  /// 默认配色：Fab 默认表达主操作。
  static const defaultColorScheme = TButtonColorScheme.primary;

  /// 默认图标
  static const IconData defaultIconData = TIcons.add;

  /// 默认距父容器右侧偏移。
  static const defaultRight = 16.0;

  /// 默认距父容器底部偏移。
  static const defaultBottom = 32.0;

  /// 默认拖拽判定阈值。
  static const defaultDragTapSlop = 18.0;

  /// 默认磁吸动画时长。
  static const defaultMagnetAnimationDuration = Duration(milliseconds: 200);

  /// 默认动作层边长。
  static const defaultActionExtent = 48.0;

  /// 默认水平拖拽边界留白。
  static const defaultHorizontalBoundary = 16.0;

  /// 默认垂直拖拽边界留白。
  static const defaultVerticalBoundary = 0.0;

  /// 根据是否有 text 推导 shape
  ///
  /// 纯图标 → circle，有 text → round
  static TButtonShape shapeForText(bool hasText) {
    return hasText ? TButtonShape.round : TButtonShape.circle;
  }
}
