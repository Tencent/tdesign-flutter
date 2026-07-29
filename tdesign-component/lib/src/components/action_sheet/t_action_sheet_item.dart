import 'package:flutter/material.dart';

import '../badge/t_badge.dart';
import 't_action_sheet_theme_data.dart';

/// 动作面板项目
class TActionSheetItem {
  TActionSheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.subtitle,
    this.disabled = false,
    this.group,
  });

  /// 标题
  final String label;

  /// 标题样式
  final TextStyle? textStyle;

  /// 图标槽位；调用方拥有其背景、形状和显式尺寸。
  ///
  /// 未显式设置尺寸或颜色的 [Icon] 会继承 [TActionSheetThemeData]。
  final Widget? icon;

  /// 角标
  final TBadge? badge;

  /// 是否禁用
  final bool disabled;

  /// 分组，用于带描述多行滚动宫格
  /// 仅分组动作面板使用；未配置时该项目不会进入任何分组
  final String? group;

  /// 描述信息
  final String? subtitle;
}
