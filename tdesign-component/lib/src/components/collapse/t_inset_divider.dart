/*
 * Created by dorayhong@tencent.com on 6/8/23.
 */
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TInsetDivider extends StatelessWidget {
  const TInsetDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 1,
        child: Divider(
          color: TTheme.of(context).componentStrokeColor,
          indent: TTheme.of(context).spacer16,
          endIndent: 0.0,
          height: 1,
          thickness: 0.5,
        ));
  }
}
