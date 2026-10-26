import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';

import '../../theme/t_internal_material.dart';

/// 内置滚轮不使用 Material 默认过度滚动装饰。
///
/// 水波纹会与 `ListWheelScrollView` 的弧形外观产生视觉冲突。
/// 平台滚动物理和输入能力保留；桌面滚动条使用 TD 内部默认值。
/// 自定义内容恢复调用方滚动配置，不继承内置滚轮的行为。
@internal
class WheelBehavior extends TInternalScrollBehavior {
  const WheelBehavior({super.callerBehavior});

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
