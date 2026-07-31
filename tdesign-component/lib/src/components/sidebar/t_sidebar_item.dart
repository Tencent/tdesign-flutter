// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../badge/t_badge.dart';

/// 侧边导航栏的不可变配置项。
///
/// [value] 应在同一个侧边导航栏的 children 列表中保持唯一，以便组件稳定地
/// 保留选中状态和滚动目标。
class TSideBarItem {
  const TSideBarItem({
    Key? key,
    this.badge,
    this.disabled = false,
    this.icon,
    this.textStyle,
    this.label = '',
    this.value = -1,
  });

  /// 徽标
  final TBadge? badge;

  /// 是否禁用
  final bool disabled;

  /// 图标
  final IconData? icon;

  /// 标签
  final String label;

  /// 标签样式
  final TextStyle? textStyle;

  /// 值
  final int value;
}
