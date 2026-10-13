import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/t_internal_material.dart';
import '../../util/platform_util.dart';

/// 滚动行为：去掉 Android / Fuchsia 平台默认的水波纹（GlowingOverscrollIndicator）
///
/// 水波纹会与 [ListWheelScrollView] 的弧形外观产生视觉冲突。
/// 平台滚动物理和输入能力保留；桌面滚动条使用 TD 内部默认值。
@internal
class WheelBehavior extends TInternalScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (PlatformUtil.isAndroid || PlatformUtil.isFuchsia) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }

  /// 支持的拖动输入设备类型，覆盖桌面端 / Web 场景
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
    PointerDeviceKind.mouse,
  };
}
