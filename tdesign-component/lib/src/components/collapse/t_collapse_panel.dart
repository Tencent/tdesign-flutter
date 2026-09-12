/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */
import 'package:flutter/material.dart';

import 't_collapse_types.dart';

/// 根据折叠状态构建面板头部区域内容的回调。
typedef TCollapsePanelBuilder =
    Widget Function(BuildContext context, bool isExpanded);

Widget _defaultExpandIconBuilder(BuildContext context, bool isExpanded) {
  return Icon(isExpanded ? Icons.expand_less : Icons.expand_more);
}

/// 折叠面板配置。
class TCollapsePanel<T extends Object> {
  const TCollapsePanel({
    required this.value,
    required this.headerBuilder,
    required this.body,
    this.bodyHeight,
    this.key,
    this.disabled = false,
    this.placement = TCollapsePlacement.bottom,
    this.semanticsLabel,
    this.leadingBuilder,
    this.trailingBuilder,
    this.expandIconBuilder = _defaultExpandIconBuilder,
    this.backgroundColor,
  }) : assert(
         bodyHeight == null || (bodyHeight > 0 && bodyHeight < double.infinity),
         'bodyHeight must be a finite value greater than zero',
       );

  /// 面板标识，用于列表插入、删除和重排时保留内容状态。
  final Key? key;

  /// 折叠面板的头部组件构造函数。
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// 折叠面板的内容组件。
  final Widget body;

  /// 展开内容区域的固定高度（包含内容内边距）。
  ///
  /// 适用于 [ListView] 等需要有界高度的内容；为空时由内容自然决定高度。
  final double? bodyHeight;

  /// 是否禁用面板交互。
  final bool disabled;

  /// 内容相对标题的展开方向。
  final TCollapsePlacement placement;

  /// 面板标题的无障碍标签；复杂自定义标题无法自动提取文本时使用。
  final String? semanticsLabel;

  /// 折叠面板的背景色。
  final Color? backgroundColor;

  /// 面板唯一标识，用于匹配父级 `TCollapse.value` 中的展开值。
  final T value;

  /// 构建标题左侧区域。
  ///
  /// 返回的 Widget 会继承组件解析出的文字和图标主题。
  final TCollapsePanelBuilder? leadingBuilder;

  /// 构建标题右侧、展开图标之前的操作区域。
  ///
  /// 可根据 builder 收到的 `isExpanded` 显示“展开/收起”等文案或任意 Widget。
  final TCollapsePanelBuilder? trailingBuilder;

  /// 构建展开图标。
  ///
  /// 省略时使用 TDesign 默认箭头；显式传入 null 时隐藏箭头；传入 builder
  /// 时以其返回的 Widget 替换默认箭头。Widget 会继承组件解析出的图标主题。
  final TCollapsePanelBuilder? expandIconBuilder;
}
