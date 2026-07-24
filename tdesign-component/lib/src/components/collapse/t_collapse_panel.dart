/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */
import 'package:flutter/material.dart';

typedef TCollapseIconTextBuilder = String Function(
    BuildContext context, bool isExpanded);

/// 折叠面板配置。
class TCollapsePanel<T extends Object> {
  const TCollapsePanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.expandIconTextBuilder,
    this.value,
    this.backgroundColor,
  });

  /// 折叠面板的头部组件构造函数。
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// 折叠面板的内容组件。
  final Widget body;

  /// 折叠面板是否展开。
  final bool isExpanded;

  /// 折叠面板的背景色。
  final Color? backgroundColor;

  /// 手风琴模式下用于标识面板的值。
  final T? value;

  /// 展开图标旁的说明文案构建器。
  final TCollapseIconTextBuilder? expandIconTextBuilder;
}
