## API
### TStepper
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | num | 100 | 最大值，必须大于或等于 `min`。 |
| min | num | 0 | 最小值，必须小于或等于 `max`。 |
| onChanged | ValueChanged<num>? | - | 数值变化请求。 点击按钮、提交有效输入或输入框失焦时触发；一次操作最多触发一次。 为 null 时整组禁用。 |
| size | TStepperSize? | - | 组件尺寸。 为空时依次使用 `TStepperThemeData.size` 和 `TStepperSize.medium`。 |
| step | num | 1 | 加减按钮使用的步长，必须大于 0。 输入提交不要求是步长的整数倍，但会限制在 `min` 与 `max` 之间。 |
| value | num | - | 唯一受控数值，必须位于 `min` 与 `max` 之间。 父组件需要在 `onChanged` 后以新值重建组件，否则输入内容会恢复。 |
| variant | TStepperVariant? | - | 组件形态。 为空时依次使用 `TStepperThemeData.variant` 和 `TStepperVariant.normal`。 |


### TStepperThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | filled 形态各段的背景色。 |
| borderColor | Color? | - | outline 形态的描边颜色。 |
| borderRadius | BorderRadius? | - | 分段圆角，默认使用 TDesign `radiusSmall`。 normal 和 filled 应用于每一段；outline 仅保留整组外侧圆角。 |
| borderWidth | double? | - | outline 形态的描边宽度，默认 1。 |
| controlSize | double? | - | 控件高度及单个按钮宽度。 为空时 small、medium、large 分别使用 20、24、26。 |
| disabledBackgroundColor | Color? | - | 整组禁用时 filled 和 outline 形态各段的背景色。 |
| disabledForegroundColor | Color? | - | 边界不可操作按钮及整组禁用时的前景色。 |
| foregroundColor | Color? | - | 输入文字和加减图标的默认前景色。 |
| iconSize | double? | - | 加减图标尺寸。 为空时 small、medium、large 分别使用 12、16、20。 |
| inputWidth | double? | - | 输入段宽度。 为空时 small、medium、large 分别使用 34、38、45。 |
| size | TStepperSize? | - | 默认尺寸；为空时使用 `TStepperSize.medium`。 |
| spacing | double? | - | normal 和 filled 形态的分段间距，默认 4。 outline 始终连续排列，不使用该值。 |
| textStyle | TextStyle? | - | 输入文字样式。 在继承 DefaultTextStyle 和 ThemeData.textTheme 后合并；非空字段可覆盖 默认字号、行高及 `foregroundColor`。 |
| variant | TStepperVariant? | - | 默认形态；为空时使用 `TStepperVariant.normal`。 |


### TStepperSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸：控件高度 20，输入段宽度 34，图标尺寸 12。 |
| medium | 中尺寸：控件高度 24，输入段宽度 38，图标尺寸 16。 这是默认尺寸。 |
| large | 大尺寸：控件高度 26，输入段宽度 45，图标尺寸 20。 |


### TStepperVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 透明分段形态，段间默认保留 4px 间距。 这是默认形态。 |
| filled | 填充分段形态，三段使用背景色并保留默认 4px 间距。 |
| outline | 连续描边形态，三段之间不保留间距。 |
