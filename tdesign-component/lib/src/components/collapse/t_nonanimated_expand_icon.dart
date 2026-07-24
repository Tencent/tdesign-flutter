import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';

class TNonAnimatedExpandIcon extends StatelessWidget {
  const TNonAnimatedExpandIcon({
    required this.isExpanded,
    required this.padding,
    Key? key,
  }) : super(key: key);

  final bool isExpanded;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      iconSize: 24.0,
      color: context.tTheme.textColorSecondary,
      onPressed: null,
      icon: isExpanded
          ? const Icon(Icons.expand_less)
          : const Icon(Icons.expand_more),
    );
  }
}
