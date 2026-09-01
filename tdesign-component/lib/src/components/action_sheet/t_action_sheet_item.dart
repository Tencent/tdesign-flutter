import 'package:flutter/material.dart';

import '../badge/t_badge.dart';
import 't_action_sheet_theme_data.dart';

/// 动作面板项目
class TActionSheetItem<T> {
  const TActionSheetItem({
    required this.value,
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.subtitle,
    this.disabled = false,
  });

  /// 稳定的业务值
  final T value;

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

  /// 描述信息
  final String? subtitle;
}
