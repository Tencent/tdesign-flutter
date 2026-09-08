import 'package:flutter/material.dart';

/// TabBarView 组件
///
/// Material TabBarView 薄包装。
/// `physics` 为空时默认不可滑动。
class TTabsBarView extends StatelessWidget {
  /// 子widget列表
  final List<Widget> children;

  /// 可选的内容区控制器；为空时使用最近的 [DefaultTabController]。
  ///
  /// 与 `TTabsBar` 放在同一 [DefaultTabController] 下即可共享选中状态。
  final TabController? controller;

  /// 滑动物理特性；未传时默认不可滑动。
  final ScrollPhysics? physics;

  const TTabsBarView({
    Key? key,
    required this.children,
    this.controller,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: physics ?? const NeverScrollableScrollPhysics(),
      controller: controller,
      children: children,
    );
  }
}
