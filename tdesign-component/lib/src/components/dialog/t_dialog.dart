/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * t_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../button/t_button_types.dart';

export 't_confirm_dialog.dart';

/// Dialog 按钮样式
///
/// 用于在 Dialog 层面配置按钮样式
/// Dialog 内支持配置每个按钮的样式
enum TDialogButtonStyle {
  /// 常规按钮样式
  normal,

  /// 文字按钮样式
  text,
}

/// 弹窗按钮配置
class TDialogButtonOptions {
  TDialogButtonOptions({
    required this.title,
    required this.onPressed,
    this.titleColor,
    this.titleSize,
    this.style,
    this.type,
    this.colorScheme,
    this.height,
    this.fontWeight,
  });

  /// 标题内容
  final String title;

  /// 标题颜色
  Color? titleColor;

  /// 字体大小
  final double? titleSize;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 按钮样式
  final ButtonStyle? style;

  /// 按钮变体类型
  final TButtonVariant? type;

  /// 按钮配色方案
  final TButtonColorScheme? colorScheme;

  /// 按钮高度
  /// 建议使用默认高度
  final double? height;

  /// 点击操作
  final VoidCallback? onPressed;
}
