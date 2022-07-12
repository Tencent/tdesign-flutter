import 'dart:io';

import 'package:flutter/material.dart';
import '../../util/platform_util.dart';

/// 去掉ListView上下滑动的波纹
class NoWaveBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (PlatformUtil.isAndroid || PlatformUtil.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
