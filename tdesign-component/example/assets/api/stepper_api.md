## API

### TStepper

#### 构造方法

##### TStepper

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | num | 100 | 最大值，必须大于或等于 `min`。 | 否 |
| min | num | 0 | 最小值，必须小于或等于 `max`。 | 否 |
| onChanged | ValueChanged&lt;num&gt;? | - | 数值变化请求。 点击按钮、提交有效输入或输入框失焦时触发；一次操作最多触发一次。 为 null 时加减按钮禁用、编辑器只读；不发出数值变化请求。 | 否 |
| size | TStepperSize? | - | 组件尺寸。 为空时使用 `TStepperSize.medium`。 | 否 |
| step | num | 1 | 加减按钮使用的步长，必须大于 0。 输入提交不要求是步长的整数倍，但会限制在 `min` 与 `max` 之间。 编辑时以合法输入草稿作为步进起点，并据此判断按钮是否达到边界。 | 否 |
| value | num | - | 唯一受控数值，必须位于 `min` 与 `max` 之间。 父组件需要在 `onChanged` 后以新值重建组件，否则输入内容会恢复。 | 是 |
| variant | TStepperVariant? | - | 组件形态。 为空时使用 `TStepperVariant.normal`。 | 否 |


### TStepperSize

步进器尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TStepperSize | - | 小尺寸：控件高度 20，输入段宽度 34，图标尺寸 12。 | - |
| medium | TStepperSize | - | 中尺寸：控件高度 24，输入段宽度 38，图标尺寸 16。 这是默认尺寸。 | - |
| large | TStepperSize | - | 大尺寸：控件高度 26，输入段宽度 45，图标尺寸 20。 | - |


### TStepperVariant

步进器形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| normal | TStepperVariant | - | 透明分段形态，段间默认保留 4px 间距。 这是默认形态。 | - |
| filled | TStepperVariant | - | 填充分段形态，三段使用背景色并保留默认 4px 间距。 | - |
| outline | TStepperVariant | - | 连续描边形态，三段之间不保留间距。 | - |


### TStepperThemeData

`TStepper` 的组件级主题。

通过 `ThemeData.extensions` 或 `ThemeData.mergeExtension` 注入。实例参数
优先于此主题；未设置的文字字段使用全局 TDesign Token，图标及输入装饰
仍按各自 Flutter 主题解析。

主题过渡保留未指定字段的继承语义，由组件结合当前实例尺寸与主题解析；
两端均未指定的字段仍为 null，端点返回原始配置。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | filled 形态各段的背景色。 null 时使用 bgColorSecondaryContainer Token。 | 否 |
| borderColor | Color? | - | outline 形态的描边颜色。 null 时使用 componentBorder Token。 | 否 |
| borderRadius | BorderRadius? | - | 分段圆角，默认使用 TDesign `radiusSmall`。 normal 和 filled 应用于每一段；outline 仅保留整组外侧圆角。 | 否 |
| borderWidth | double? | - | outline 形态的描边宽度，默认 1。 | 否 |
| controlSize | double? | - | 控件高度及单个按钮宽度。 为空时 small、medium、large 分别使用 20、24、26。 | 否 |
| disabledBackgroundColor | Color? | - | 整组禁用时 filled 和 outline 形态各段的背景色。 null 时使用 bgColorComponentDisabled Token。 | 否 |
| disabledForegroundColor | Color? | - | 边界不可操作按钮及整组禁用时的前景色。 | 否 |
| foregroundColor | Color? | - | 输入文字和加减图标的默认前景色。 | 否 |
| iconSize | double? | - | 加减图标尺寸。 为空时 small、medium、large 分别使用 12、16、20。 | 否 |
| inputWidth | double? | - | 输入段宽度。 为空时 small、medium、large 分别使用 34、38、45。 | 否 |
| spacing | double? | - | normal 和 filled 形态的分段间距，默认 4。 outline 始终连续排列，不使用该值。 | 否 |
| textStyle | TextStyle? | - | 输入文字样式。 在继承全局 TDesign Token 后合并；非空字段可覆盖 默认字号、行高及 `foregroundColor`。仅覆盖字号时会按最终字号重新计算 默认行高倍数；显式设置的 `TextStyle.height` 始终优先。最终字号或显式 物理行盒超过控件高度属于无效配置，并会在调试模式触发断言。 | 否 |
