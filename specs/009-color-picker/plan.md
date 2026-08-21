# 实施方案

## 技术方案

### 组件结构

`TColorPicker` 采用受控组件模式（`value` + `onChanged`），内部持有 `TColorObject` 作为当前颜色状态。渲染结构：

- `base` 类型：仅系统预设色板（swatch 网格），可配清除按钮。
- `multiple` 类型：顶部为二维饱和度-明度色板（带十字拖拽 thumb），下方为色相条，`enableAlpha` 时追加透明条，再下方为 swatch 网格与清除按钮。

色板、色相条、透明条使用 `GestureDetector` + `onPanUpdate`/`onPanDown` 处理拖拽，通过全局 `LayoutBuilder` 获取实际尺寸计算坐标比例。thumb 位置由 `TColorObject` 当前分量计算。

### 颜色状态管理

- 解析 `value` 构造 `TColorObject`，内部状态 `hue`/`saturation`/`value`/`alpha`。
- 色板拖拽 → 更新 `saturation`/`value`，触发 `onPaletteBarChange`（不触发 `onChanged`，对齐 mobile-vue）；色相条 → 更新 `hue`；透明条 → 更新 `alpha`。
- 色相条 / 透明条拖拽落定后触发 `onChanged`（`trigger` 分别对应 `paletteHueBar`/`paletteAlphaBar`）。
- 点击 swatch → `TColorObject.update(swatch)`，触发 `onChanged`（`trigger=preset`）。
- 清除 → 调用 `onChanged`（`trigger=clear`），清空语义由使用方处理。

### 颜色工具类

`TColorObject` 纯 Dart 实现，参照 mobile-vue `Color` 类（tdesign-common `js/color-picker/color.ts`）：
- 内部统一以 HSV 状态存储，输出时转换到目标色彩空间。
- 实现 RGB↔HSV、RGB↔HSL、RGB↔CMYK 转换与格式化字符串。
- alpha 解析：支持 `#RRGGBBAA`、`rgba(...)`、`hsla(...)`、`hsva(...)` 中的 alpha，默认 1。

### 主题

`TColorPickerThemeData` 实现 `ThemeExtension`，提供 `copyWith`/`lerp`，默认值对齐 mobile-vue CSS Variables。组件读取顺序：实例 `themeData` > 主题子树 `TColorPickerThemeData` > 内置默认值。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_color_picker.dart`、`t_color_picker_palette.dart`、`t_color_picker_types.dart`、`t_color_picker_theme_data.dart` | 新增 |
| 工具 | `util/t_color_object.dart` | 新增 |
| 导出 | `tdesign_flutter.dart` | 新增导出 |
| 测试 | `test/components/color_picker/`、`test/util/` | 新增 |
| 示例 | `example/lib/page/t_color_picker_page.dart`、`config.dart` | 新增 |
| 文档 | `tdesign-site/docs/components/color-picker/README.md` | 新增 |

## API 变化

仅新增组件与工具类，无既有 API 变更，非 breaking change。

## 风险与取舍

- **CMYK 精度**：RGB↔CMYK 互转有舍入损耗，工具类测试锁定期望值。
- **trigger 语义**：拖拽过程触发 `onPaletteBarChange`，落定触发 `onChanged`，与 mobile-vue 严格一致。
- **无第三方颜色库**：`TColorObject` 纯 Dart 实现，需仔细核对各转换公式与 mobile-vue（tinycolor2）输出一致。
- **`fixed` 不映射**：Flutter 无 `position:fixed` 语义，文档注明省略。
- **弹窗形式**：示例通过外部 `TPopup` 包裹实现，组件本身不内建弹窗。

## 验证策略

- 单元测试：`TColorObject` 各格式互转、alpha 解析、范围裁剪。
- Widget 测试：`TColorPicker` 类型渲染、交互回调、格式输出、swatch 逻辑、清除。
- 静态检查：`cd tdesign-component && flutter analyze`（0 error / 0 warning）。
- 人工验收：示例页对比 mobile-vue `mobile.vue` 分组。
