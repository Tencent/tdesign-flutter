/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * td_dialog.dart
 * 
 */


import 'package:flutter/material.dart';

import '../../../td_export.dart';

export 'td_alert_dialog.dart';
export 'td_confirm_dialog.dart';
export 'td_image_dialog.dart';
export 'td_input_dialog.dart';

/// Dialog按钮样式
/// 用于在Dialog层面配置按钮样式
/// Dialog内支持配置每个按钮的样式
enum TDDialogButtonStyle {
  normal,
  text,
}

/// 弹窗按钮配置
class TDDialogButtonOptions {
  Color? titleColor;
  final TDButtonStyle? style;
  final double? height;
  final FontWeight? fontWeight;
  final String title;
  final Function() action;

  TDDialogButtonOptions({
    required this.title,
    required this.action,
    this.titleColor,
    this.style,
    this.height,
    this.fontWeight,
  });
}