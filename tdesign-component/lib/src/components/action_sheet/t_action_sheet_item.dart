import 'package:flutter/material.dart';

import '../badge/t_badge.dart';

/// 动作面板项目
class TActionSheetItem {
  TActionSheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.subtitle,
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
  /// 仅分组动作面板使用；未配置时该项目不会进入任何分组
  final String? group;

  /// 描述信息
  final String? subtitle;
}
