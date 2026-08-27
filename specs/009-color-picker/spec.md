# ColorPicker 颜色选择器

## 背景

Issue #105：需求新增 `ColorPicker` 颜色选择器组件，参考 tdesign-mobile-vue，示例一致、API 尽量一致。

tdesign-flutter 仓库当前没有颜色选择器组件，也没有可复用的颜色解析 / 格式化工具（RGB/HSL/HSV/CMYK 互转、alpha 解析等）。Flutter `MaterialColor`/`Color` 仅支持 ARGB，无法直接输出并格式化为 HEX/HSL/HSV/CMYK/CSS 等字符串，也不支持 CMYK 颜色空间。为对齐 mobile-vue 的 ColorPicker 交互（调色板拖拽、色相条、透明通道、预设色板、格式切换）与 API，需要新增组件及配套的颜色工具类。

## 目标

- 新增顶层组件 **`TColorPicker`**，API 与交互尽量对齐 tdesign-mobile-vue `TdColorPickerProps`。
- 新增内部颜色工具类 `TColorObject`，纯 Dart 实现 RGB / HSL / HSV / CMYK / HEX 互转与 alpha 解析、格式化，无第三方依赖。
- 新增主题 `TColorPickerThemeData`（`ThemeExtension`），承载面板背景/圆角、色板/滑块/swatch 尺寸、选中描边等外观参数，默认值对齐 mobile-vue CSS Variables。
- 新增示例页 `td_color_picker_page.dart`，分组对齐 mobile-vue `mobile.vue`（01 组件类型、02 组件状态）。
- 新增站点文档 `tdesign-site/docs/components/color-picker/README.md`。
- 补充单元 / Widget 测试。
- 保持 `flutter@3.32.0` 与 `flutter@latest` 双版本兼容，`flutter analyze` 0 error / 0 warning。

## 非目标

- 不实现 mobile-vue 的 `fixed`（`position: fixed` 语义），Flutter 布局体系不适用，文档注明不映射。
- 不实现 `defaultValue` / `modelValue` 语法糖；Flutter 采用单一受控 `value` + `onChanged`，非受控状态由使用方持有。
- 不实现渐变（gradient）颜色选择（mobile-vue ColorPicker 主体为单色选择，渐变属于高级扩展，Issue 未要求）。
- 不实现颜色输入框/自由输入 HEX/RGB 值（mobile-vue 组件本身也未内建输入框，输入属宿主层）。
- 不修改 `tdesign-component/CHANGELOG.md`（CLI 自动生成）。

## 范围

### 涉及

- `specs/009-color-picker/`（本 Spec）
- `tdesign-component/lib/src/components/color_picker/t_color_picker.dart`（新增，核心组件）
- `tdesign-component/lib/src/components/color_picker/t_color_picker_theme_data.dart`（新增，主题）
- `tdesign-component/lib/src/components/color_picker/t_color_picker_types.dart`（新增，类型/枚举）
- `tdesign-component/lib/src/components/color_picker/t_color_picker_palette.dart`（新增，色板/滑块内部渲染）
- `tdesign-component/lib/src/util/t_color_object.dart`（新增，颜色工具类，纯 Dart）
- `tdesign-component/lib/tdesign_flutter.dart`（导出新增公开类）
- `tdesign-component/test/components/color_picker/t_color_picker_test.dart`（新增，Widget 测试）
- `tdesign-component/test/util/t_color_object_test.dart`（新增，工具类单元测试）
- `tdesign-component/example/lib/page/t_color_picker_page.dart`（新增，示例页）
- `tdesign-component/example/lib/config.dart`（注册示例页路由）
- `tdesign-site/docs/components/color-picker/README.md`（新增，站点文档）

### 不涉及

- 其他组件 / 页面
- 站点文档以外的其他文档仓库
- `tdesign-component/CHANGELOG.md`

## 行为契约

### TColorPicker（顶层组件）

```dart
class TColorPicker extends StatefulWidget {
  const TColorPicker({
    Key? key,
    required this.value,
    required this.onChanged,
    this.type = TColorPickerType.base,
    this.format = TColorPickerFormat.rgb,
    this.enableAlpha = false,
    this.swatchColors,
    this.clearable = false,
    this.onPaletteBarChange,
    this.themeData,
  });
}
```

字段语义（对齐 mobile-vue，Flutter 化命名）：

- `value`：`String`，受控色值（对应 `value`/`modelValue`/`defaultValue`）。传入的字符串支持 HEX / RGB / RGBA / HSL / HSLA / HSV / HSVA / CMYK / CSS 任一格式，由 `TColorObject` 解析。
- `type`：`TColorPickerType`（`base`/`multiple`）。默认 `base`，仅展示系统预设色板；`multiple` 额外展示二维饱和度-明度色板、色相条、透明条（`enableAlpha` 为 true 时）。
- `format`：`TColorPickerFormat`（`hex`/`hex8`/`rgb`/`rgba`/`hsl`/`hsla`/`hsv`/`hsva`/`cmyk`/`css`）。默认 `rgb`，决定 `onChanged` 输出格式。当 `enableAlpha` 为 true 时，`hex`→`hex8`、`rgb`→`rgba`、`hsl`→`hsla`、`hsv`→`hsva` 自动升级（对齐 mobile-vue `ALPHA_FORMAT_MAP`）。
- `enableAlpha`：`bool`，默认 `false`。为 true 时展示透明条，并输出带 alpha 的格式。
- `swatchColors`：`List<String>?`。`null` 时用内置默认系统色板（对齐 `DEFAULT_SYSTEM_SWATCH_COLORS` 前 10 个）；空列表 `[]` 时隐藏系统色板。
- `clearable`：`bool`，默认 `false`。为 true 时展示"清除"按钮（位于"系统预设色彩"标题行右侧；色板隐藏时单独成行），点击后调用 `onChanged`（清空语义由使用方处理）。

布局契约（对齐 tdesign-mobile-vue 真实 DOM 结构与 CSS，用户反馈设计稿差异后修正）：

- `multiple` 类型区块自上而下：饱和度面板 → 16px → 色相条 → 20px（+透明条）→ 20px → 格式区 → 28px → swatch 区。
- 格式区对齐 mobile-vue `__format`：左侧格式名框（68px、1px 边框、左圆角 6），右侧各通道值连体分段框（相邻边共线合并、末格右圆角 6），每段居中展示数值；最后一段固定为百分比 alpha（如 RGB 显示 `0 | 26 | 87 | 100%`），CSS 为单整段。数值只读，输入属宿主层。
- 格式区文字与边框颜色跟随全局 Token（`textColorPrimary` / `componentBorderColor`），不用硬编码色值，保证深浅色模式下均可读；边框圆角、布局尺寸与 mobile-vue 一致。
- 色相条渐变 stop 对齐 mobile-vue（red→黄 17%→绿 33%→青 50%→蓝 67%→品红 83%→red）；滑块 thumb 与轨道同层绝对定位，白圆底 + 内嵌当前色圆点。
- 透明条以斜向棋盘格为底（6px 网格、#c5c5c5，对齐 mobile-vue alpha wrapper 背景棋盘），上层覆盖当前色透明渐变。
- swatch 区：标题加粗与"清除"同行（space-between），下方 12px 单行横向滚动排列，块间距 12（对齐 mobile-vue `__swatches-items` 横滚与 12px margin）。
- `onChanged`：`void Function(String value, TColorPickerChangeContext context)`，必填。选中色值变化时触发，`value` 为按 `format` 格式化后的新色值；`context.color` 为 `TColorObject`，`context.trigger` 为 `TColorPickerChangeTrigger`（`paletteHueBar`/`paletteAlphaBar`/`preset`/`clear`）。
- `onPaletteBarChange`：`void Function(TColorObject color)?`，调色板拖拽过程回调，`color` 为当前 `TColorObject`。**仅色板（饱和度/明度）拖拽时触发**（对齐 mobile-vue：色板拖拽只触发 `onPaletteBarChange`，不触发 `onChanged`）。
- `themeData`：`TColorPickerThemeData?`，实例级主题覆盖。

### TColorObject（颜色工具类）

纯 Dart 类，无第三方依赖，用于颜色解析、转换与格式化：

- 解析：从字符串（HEX / HEX8 / RGB / RGBA / HSL / HSLA / HSV / HSVA / CMYK / CSS / 命名色）构造。
- 内部状态：`hue`、`saturation`、`value`（0-1）、`alpha`（0-1）。
- 输出格式化：`hex`、`hex8`、`rgb`、`rgba`、`hsl`、`hsla`、`hsv`、`hsva`、`cmyk`、`css` 字符串。
- 数值访问：`getHsl()`、`getHsv()`、`getRgb()`、`getCmyk()` 等，返回分量值。
- `format()`：按 `TColorPickerFormat` + `enableAlpha` 输出字符串。
- 分量 setter（`saturation`/`value`/`hue`/`alpha`）带范围裁剪（对齐 mobile-vue `Color` 类）。

### TColorPickerThemeData

`ThemeExtension<TColorPickerThemeData>`，字段（默认值对齐 mobile-vue CSS Variables）：

- 面板：`panelBackgroundColor`（`bg-color-container`）、`panelRadius`（12）、`panelPadding`（16）、`panelWidth`（默认自适应）。
- 色板：`saturationHeight`（144）、`saturationRadius`（6）、`saturationThumbSize`（24）。
- 滑块：`sliderHeight`（8）、`sliderThumbSize`（24）、`sliderThumbPadding`（3）。
- swatch：`swatchWidth`（24）、`swatchHeight`（24）、`swatchRadius`（`radius-small`）、`swatchActiveBorder`（`rgba(0,0,0,20%)`）、`swatchSpacing`。

## 验收标准

- [ ] `TColorPicker` 组件 `base`/`multiple` 两种类型渲染正确，交互（色板拖拽、色相条、透明条、预设点击、清除）与 mobile-vue 行为一致。
- [ ] `onChanged` 输出格式随 `format` 变化，`enableAlpha` 时自动升级为带 alpha 格式（HEX8/RGBA/HSLA/HSVA）。
- [ ] `swatchColors` 为 `null` 用内置色板，为空列表隐藏色板。
- [ ] `TColorObject` 各格式互转结果与预期一致（CMYK 舍入损耗锁定期望值），单元测试覆盖。
- [ ] `TColorPickerThemeData` 默认值对齐 mobile-vue CSS Variables，可被主题子树覆盖。
- [ ] 示例页分组对齐 mobile-vue `mobile.vue`（01 组件类型、02 组件状态）。
- [ ] 站点文档 README.md 提供与示例一致的使用代码。
- [ ] `flutter analyze` 0 error / 0 warning，`flutter@3.32.0` 与 `flutter@latest` 双版本兼容。
