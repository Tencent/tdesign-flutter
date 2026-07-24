/*
 * Created by dorayhong@tencent.com on 6/8/23.
 */
import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';

class TInsetDivider extends StatelessWidget {
  const TInsetDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 1,
        child: Divider(
          color: context.tTheme.componentStrokeColor,
          indent: context.tTheme.spacer16,
          endIndent: 0.0,
          height: 1,
          thickness: 0.5,
        ));
  }
}
