import 'package:flutter/material.dart';

import 't_fab_layout.dart';

/// 内嵌 TButton 默认配置
///
/// 纯图标 Fab 默认 shape = circle，有 text 时 shape = round。
class TFabDefaults {
  TFabDefaults._(); // coverage:ignore-line

  /// 默认尺寸
  static const defaultSizeIndex = 0; // TButtonSize.large

  /// 默认变体
  static const defaultVariantIndex = 0; // TButtonVariant.fill

  /// 默认配色
  static const defaultColorSchemeIndex = 1; // TButtonColorScheme.primary

  /// 默认图标
  static const IconData defaultIconData = Icons.add;

  /// 根据是否有 text 推导 shape
  ///
  /// 纯图标 → circle，有 text → round
  static String shapeForText(bool hasText) {
    return hasText ? 'round' : 'circle';
  }
}
