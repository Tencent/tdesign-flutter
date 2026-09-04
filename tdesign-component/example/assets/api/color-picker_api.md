## API
### TColorPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| clearable | bool | false | 是否可清空。为 true 时展示"清除"按钮。 |
| enableAlpha | bool | false | 是否开启透明通道。为 true 时展示透明条，并输出带 alpha 的格式。 |
| format | TColorPickerFormat | TColorPickerFormat.rgb | 输出格式。默认 `TColorPickerFormat.rgb`。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | void Function(String value, TColorPickerChangeContext change) | - | 选中色值变化时触发。 `value` 为按 `format` 格式化后的新色值；第二个参数含当前颜色对象与触发来源 （`TColorPickerChangeContext.color` / `TColorPickerChangeContext.trigger`）。 |
| onPaletteBarChange | ValueChanged<TColorObject>? | - | 调色板（饱和度/明度色板）拖拽过程回调，`color` 为当前颜色对象。 |
| swatchColors | List<String>? | - | 系统预设的颜色样例。`null` 使用内置默认色板； 空列表 `[]` 隐藏系统色板。 |
| themeData | TColorPickerThemeData? | - | 实例级主题覆盖。 |
| type | TColorPickerType | TColorPickerType.base | 颜色选择器类型。默认 `TColorPickerType.base`。 |
| value | String | - | 受控色值，支持 HEX / RGB / RGBA / HSL / HSLA / HSV / HSVA / CMYK / CSS 任一格式。为空时使用默认色 `#001F97`。 |


### TColorPickerThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| panelBackgroundColor | Color? | - | 面板背景色（对应 `--td-color-picker-panel-background`）。 |
| panelPadding | EdgeInsets? | - | 面板内边距（对应 `--td-color-picker-panel-padding`）。 |
| panelRadius | double? | - | 面板圆角（对应 `--td-color-picker-panel-radius`）。 |
| saturationHeight | double? | - | 饱和度-明度色板高度（对应 `--td-color-picker-saturation-height`）。 |
| saturationRadius | double? | - | 饱和度-明度色板圆角（对应 `--td-color-picker-saturation-radius`）。 |
| saturationThumbSize | double? | - | 饱和度-明度色板拖拽 thumb 尺寸（对应 `--td-color-picker-saturation-thumb-size`）。 |
| sliderHeight | double? | - | 色相 / 透明条高度（对应 `--td-color-picker-slider-height`）。 |
| sliderThumbPadding | double? | - | 色相 / 透明条 thumb 内边距（对应 `--td-color-picker-slider-thumb-padding`）。 |
| sliderThumbSize | double? | - | 色相 / 透明条 thumb 尺寸（对应 `--td-color-picker-slider-thumb-size`）。 |
| swatchActiveBorderColor | Color? | - | swatch 选中描边颜色（对应 `--td-color-picker-swatch-active`）。 |
| swatchHeight | double? | - | swatch 高度（对应 `--td-color-picker-swatch-height`）。 |
| swatchRadius | double? | - | swatch 圆角（对应 `--td-color-picker-swatch-border-radius`）。 |
| swatchWidth | double? | - | swatch 宽度（对应 `--td-color-picker-swatch-width`）。 |


### TColorPickerChangeContext
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | TColorObject | - | 当前调色板控制器的颜色对象。 |
| trigger | TColorPickerChangeTrigger | - | 触发颜色变化的来源。 |


### TColorPickerType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| base | 仅展示系统预设色板。 |
| multiple | 展示色板 + 色相条（+透明条）+ 系统预设色板。 |


### TColorPickerChangeTrigger
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| paletteHueBar | 色相条拖拽落定。 |
| paletteAlphaBar | 透明条拖拽落定。 |
| preset | 预设色板点击。 |
| clear | 清除按钮。 |
