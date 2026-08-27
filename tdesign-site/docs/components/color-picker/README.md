---
title: ColorPicker 颜色选择器
description: 用于颜色选择，支持多种格式。
spline: base
isComponent: true
---

## 引入

在 `tdesign_flutter/tdesign_flutter.dart` 中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_color_picker_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_color_picker_page.dart)

### 1 组件类型

基础颜色选择器（仅系统预设色板）

```dart
Widget _buildBase(BuildContext context) {
  return TColorPicker(
    value: '#0052D9',
    onChanged: (value, change) {
      // value 为按 format 格式化后的新色值，
      // change.trigger 为触发来源、change.color 为当前颜色对象。
    },
  );
}
```

带色板的颜色选择器（色板 + 色相条 + 透明条 + 系统预设色板）

```dart
Widget _buildMultiple(BuildContext context) {
  return TColorPicker(
    value: '#0052D9',
    type: TColorPickerType.multiple,
    enableAlpha: true,
    onChanged: (value, change) {},
    onPaletteBarChange: (color) {
      // 色板拖拽过程回调
    },
  );
}
```

弹窗形式的颜色选择器（配合 `TPopup` 使用）

```dart
// 展示按钮：对齐 mobile-vue 的 block 用法，块级通栏展开至可用宽度。
SizedBox(
  width: double.infinity,
  child: TButton(
    size: TButtonSize.large,
    variant: TButtonVariant.outline,
    colorScheme: TButtonColorScheme.primary,
    child: const TText('展示'),
    onPressed: () => _showPopupPicker(context),
  ),
)

// 无标题栏与「确定/取消」按钮，点击遮罩层即关闭弹窗并提交草稿值。
var draft = popupValue;
TPopup.show(
  context,
  options: TPopupOptions.bottom(
    // multiple 类型内容较高，未传高度时 TPopup bottom 默认 240 会裁剪内容。
    height: MediaQuery.sizeOf(context).height * 0.72,
    child: StatefulBuilder(
      builder: (context, setPopupState) => TColorPicker(
        value: draft,
        type: TColorPickerType.multiple,
        enableAlpha: true,
        onChanged: (value, change) => setPopupState(() => draft = value),
      ),
    ),
    onVisibleChange: (visible, trigger) {
      // 弹窗关闭（点击遮罩）即提交草稿值到页面状态。
      if (!visible && mounted) {
        setState(() => popupValue = draft);
      }
    },
  ),
);
```

### 2 组件状态

组件模式选择（格式切换）：CSS / HEX / RGB / HSL / HSV / CMYK，默认 `CSS`，两行布局对齐 mobile-vue

```dart
TColorPicker(
  value: formatValue,
  type: TColorPickerType.multiple,
  enableAlpha: true,
  format: curFormat,
  onChanged: (result) {
    final (value, _) = result;
  },
);
```

## API

### TColorPicker Props

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | String | - | 受控色值，支持 HEX / RGB / RGBA / HSL / HSLA / HSV / HSVA / CMYK / CSS 任一格式 |
| onChanged | ValueChanged<(String, TColorPickerChangeContext)> | - | 选中色值变化时触发，第一个参数为新色值，context 含 color 与 trigger |
| type | TColorPickerType | base | 颜色选择器类型，base / multiple |
| format | TColorPickerFormat | rgb | 格式化色值。enableAlpha 为真时，hex8 / rgba / hsla / hsva 有效 |
| enableAlpha | bool | false | 是否开启透明通道，为真时展示透明条并输出带 alpha 的格式 |
| swatchColors | List\<String\>? | null | 系统预设颜色，null 用内置色板，空列表隐藏色板 |
| clearable | bool | false | 是否可清空。注：上游 mobile-vue 当前仅为 prop 占位，Flutter 侧已实现「清除」按钮并新增 `clear` 触发来源，属有意扩展 |
| onPaletteBarChange | ValueChanged\<TColorObject\>? | - | 色板拖拽过程回调 |
| themeData | TColorPickerThemeData? | - | 实例级主题覆盖 |


### TColorObject

颜色工具类，支持 HEX / RGB / HSL / HSV / CMYK / CSS 各格式间的解析、转换与格式化，无第三方依赖。
