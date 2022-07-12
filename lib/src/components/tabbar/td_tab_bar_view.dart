import 'package:flutter/material.dart';

class TDTabBarView extends TabBarView {
  /// 子widget列表
  @override
  final List<Widget> children;

  /// 控制器
  @override
  final TabController? controller;

  /// 是否可以滑动切换
  final bool isSlideSwitch;

  @override
  const TDTabBarView({
    Key? key,
    required this.children,
    this.controller,
    this.isSlideSwitch = false,
  }) : super(
            key: key,
            children: children,
            controller: controller,
            physics: isSlideSwitch
                ? const ScrollPhysics()
                : const NeverScrollableScrollPhysics());

  Widget build(BuildContext context) {
    return TabBarView(
      children: children,
      controller: controller,
    );
  }
}
