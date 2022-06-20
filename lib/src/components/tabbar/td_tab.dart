import 'package:flutter/material.dart';

class TDTab extends Tab {
  /// 文字内容
  final String? text;

  /// 子widget
  final Widget? child;

  /// 图标
  final Widget? icon;

  /// 图标间距
  final EdgeInsetsGeometry iconMargin;

  @override
  const TDTab(
      {Key? key,
      this.text,
      this.child,
      this.icon,
      this.iconMargin = const EdgeInsets.only(bottom: 10.0)})
      : super(
            key: key,
            text: text,
            child: child,
            icon: icon,
            iconMargin: iconMargin);

  Widget build(BuildContext context) {
    return Tab(
      key: key,
      text: text,
      child: child,
      icon: icon,
      iconMargin: iconMargin,
    );
  }
}
