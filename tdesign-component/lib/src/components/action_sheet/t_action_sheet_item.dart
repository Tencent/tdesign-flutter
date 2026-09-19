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

  /// 展示在项目内容上的徽标配置；为空时不显示。
  ///
  /// 列表模式下以标题为锚点；宫格模式下以 [icon] 为锚点，因此宫格模式仅在
  /// [icon] 非空时展示。默认位置由 ActionSheet 管理，[TBadgeConfig.alignment]
  /// 与 [TBadgeConfig.offset] 可逐项覆盖；完全自定义外观使用
  /// [TBadgeConfig.custom]。
  final TBadgeConfig? badge;

  /// 是否禁用
  final bool disabled;

  /// 列表模式下的描述信息；宫格模式不展示。
  final String? subtitle;
}
