/*
 * Created by dorayhong@tencent.com on 6/8/23.
 */
import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';

/// 带水平缩进的折叠面板分隔线。
class TInsetDivider extends StatelessWidget {
  const TInsetDivider({
    this.color,
    this.indent,
    Key? key,
  }) : super(key: key);

  final Color? color;
  final double? indent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 1,
        child: Divider(
          color: color ??
              DividerTheme.of(context).color ??
              context.tTheme.componentStrokeColor,
          indent: indent ?? context.tTheme.spacer16,
          endIndent: 0.0,
          height: 1,
          thickness: 0.5,
        ));
  }
}
