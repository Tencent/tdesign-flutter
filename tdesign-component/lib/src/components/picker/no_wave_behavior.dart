import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../util/platform_util.dart';

/// 去掉ListView上下滑动的波纹
class NoWaveBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    if (PlatformUtil.isAndroid || PlatformUtil.isFuchsia) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }

  // 增加mouse拖拽
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    // The VoiceAccess sends pointer events with unknown type when scrolling
    // scrollables.
    PointerDeviceKind.unknown,
    PointerDeviceKind.mouse,
  };

}
