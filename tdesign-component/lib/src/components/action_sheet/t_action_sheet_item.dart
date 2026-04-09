import 'package:flutter/material.dart';

import '../badge/t_badge.dart';
import 't_action_sheet.dart';

/// 动作面板项目
class TActionSheetItem {
  TActionSheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.description,
    this.disabled = false,
    this.iconSize,
    this.group,
  });

  /// 标题
  final String label;

  /// 标题样式
  final TextStyle? textStyle;

  /// 图标
  final Widget? icon;

  /// 角标
  final TBadge? badge;

  /// 是否禁用
  final bool disabled;

  /// 图标大小
  final double? iconSize;

  /// 分组，用于带描述多行滚动宫格
  /// 当[TActionSheet.theme]等于[TActionSheetTheme.group]时有效
  /// 有效时，如果该值未配置整个[TActionSheetItem]会被忽略，即不会展示
  final String? group;

  /// 描述信息
  final String? description;
}

