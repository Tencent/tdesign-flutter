import '../../util/t_color_object.dart';

/// 颜色选择器类型，对齐 tdesign-mobile-vue `type`。
enum TColorPickerType {
  /// 仅展示系统预设色板。
  base,

  /// 展示色板 + 色相条（+透明条）+ 系统预设色板。
  multiple,
}

/// 颜色变化的触发来源，对齐 tdesign-mobile-vue `ColorPickerChangeTrigger`。
enum TColorPickerChangeTrigger {
  /// 色相条拖拽落定。
  paletteHueBar,

  /// 透明条拖拽落定。
  paletteAlphaBar,

  /// 预设色板点击。
  preset,

  /// 清除按钮。
  clear,
}

/// `TColorPicker.onChanged` 回调的上下文。
class TColorPickerChangeContext {
  /// 当前调色板控制器的颜色对象。
  final TColorObject color;

  /// 触发颜色变化的来源。
  final TColorPickerChangeTrigger trigger;

  const TColorPickerChangeContext(this.color, this.trigger);
}
