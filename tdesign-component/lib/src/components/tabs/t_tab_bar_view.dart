import 'package:flutter/material.dart';

/// TabBarView 组件 v1.0
///
/// Material TabBarView 薄包装。
/// `physics` 为空时默认不可滑动。
class TTabsBarView extends StatefulWidget {
  /// 子widget列表
  final List<Widget> children;

  /// 控制器
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
  State<TTabsBarView> createState() => _TTabsBarViewState();
}

class _TTabsBarViewState extends State<TTabsBarView> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: widget.physics ?? const NeverScrollableScrollPhysics(),
      controller: widget.controller,
      children: widget.children,
    );
  }
}
