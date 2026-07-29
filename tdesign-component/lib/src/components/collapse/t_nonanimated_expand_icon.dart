import 'package:flutter/material.dart';

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
