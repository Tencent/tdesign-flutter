import 'package:flutter/material.dart';

import '../badge/td_badge.dart';
import 'td_action_sheet.dart';

/// 动作面板项目
class TDActionSheetItem {
  TDActionSheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.disabled = false,
    this.iconSize,
    this.group,
  });

  /// 标提
  final String label;

  /// 标题样式
  final TextStyle? textStyle;

  /// 图标
  final Widget? icon;

  /// 角标
  final TDBadge? badge;

  /// 是否禁用
  final bool disabled;

  /// 图标大小
  final double? iconSize;

  /// 分组，用于带描述多行滚动宫格
  /// 当[TDActionSheet.theme]等于[TDActionSheetTheme.group]时有效
  /// 有效时，如果该值未配置整个[TDActionSheetItem]会被忽略，即不会展示
  final String? group;
}

