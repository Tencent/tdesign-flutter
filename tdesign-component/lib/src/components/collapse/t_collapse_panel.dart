/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */
import 'package:flutter/material.dart';

import 't_collapse_types.dart';

/// 根据折叠状态构建面板操作文字的回调。
typedef TCollapseIconTextBuilder = String Function(
    BuildContext context, bool isExpanded);

/// 折叠面板配置。
class TCollapsePanel<T extends Object> {
  const TCollapsePanel({
    required this.headerBuilder,
    required this.body,
    this.key,
    this.isExpanded = false,
    this.disabled = false,
    this.placement = TCollapsePlacement.bottom,
    this.semanticsLabel,
    this.expandIconTextBuilder,
    this.value,
    this.backgroundColor,
  });

  /// 面板标识，用于列表插入、删除和重排时保留内容状态。
  final Key? key;

  /// 折叠面板的头部组件构造函数。
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// 折叠面板的内容组件。
  final Widget body;

  /// 折叠面板是否展开。
  final bool isExpanded;

  /// 是否禁用面板交互。
  final bool disabled;

  /// 内容相对标题的展开方向。
  final TCollapsePlacement placement;

  /// 面板标题的无障碍标签；复杂自定义标题无法自动提取文本时使用。
  final String? semanticsLabel;

  /// 折叠面板的背景色。
  final Color? backgroundColor;

  /// 手风琴模式下用于标识面板的值。
  final T? value;

  /// 展开图标旁的说明文案构建器。
  final TCollapseIconTextBuilder? expandIconTextBuilder;
}
