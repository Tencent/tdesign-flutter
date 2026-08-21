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
    onChanged: (result) {
      final (value, _) = result;
      // value 为按 format 格式化后的新色值
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
    onChanged: (result) {
      final (value, _) = result;
    },
    onPaletteBarChange: (color) {
      // 色板拖拽过程回调
    },
  );
}
```

弹窗形式的颜色选择器（配合 `TPopup` 使用）

```dart
TPopup.show(
  context,
  options: TPopupOptions.bottom(
    titleWidget: const Text('选择颜色'),
    child: TColorPicker(
      value: popupValue,
      type: TColorPickerType.multiple,
      enableAlpha: true,
      onChanged: (result) {
        final (value, _) = result;
      },
    ),
  ),
);
```

### 2 组件状态

格式切换（HEX / RGB / HSL / HSV / CMYK / CSS）

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
| clearable | bool | false | 是否可清空 |
| onPaletteBarChange | ValueChanged\<TColorObject\>? | - | 色板拖拽过程回调 |
| themeData | TColorPickerThemeData? | - | 实例级主题覆盖 |

> `fixed`（`position: fixed` 语义）在 Flutter 布局体系下不适用，故不提供该属性。

### TColorObject

颜色工具类，支持 HEX / RGB / HSL / HSV / CMYK / CSS 各格式间的解析、转换与格式化，无第三方依赖。
