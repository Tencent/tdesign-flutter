import 'package:flutter/material.dart';

/// 不带旋转动画的折叠面板展开状态图标。
class TNonAnimatedExpandIcon extends StatelessWidget {
  const TNonAnimatedExpandIcon({
    required this.isExpanded,
    required this.padding,
    required this.color,
    Key? key,
  }) : super(key: key);

  final bool isExpanded;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        size: 24,
        color: color,
      ),
    );
  }
}
