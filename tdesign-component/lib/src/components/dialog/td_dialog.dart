/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * td_dialog.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

export 'td_alert_dialog.dart';
export 'td_confirm_dialog.dart';
export 'td_image_dialog.dart';
export 'td_input_dialog.dart';

/// Dialog按钮样式
///
/// 用于在Dialog层面配置按钮样式
/// Dialog内支持配置每个按钮的样式
enum TDDialogButtonStyle {
  normal,
  text,
}

/// 弹窗按钮配置
class TDDialogButtonOptions {
  TDDialogButtonOptions({
    required this.title,
    required this.action,
    this.titleColor,
    this.style,
    this.type,
    this.theme,
    this.height,
    this.fontWeight,
  });

  /// 标题内容
  final String title;

  /// 标题颜色
  Color? titleColor;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 按钮样式
  /// 设置单个按钮的样式会覆盖Dialog的默认样式
  final TDButtonStyle? style;

  /// 按钮类型
  final TDButtonType? type;

  /// 按钮类型
  final TDButtonTheme? theme;

  /// 按钮高度
  /// 建议使用默认高度
  final double? height;

  /// 点击操作
  final Function() action;
}
