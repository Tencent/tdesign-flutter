## API

### TStepper

#### 构造方法

##### TStepper

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| max | num | 100 | 最大值，必须大于或等于 `min`。 | 否 |
| min | num | 0 | 最小值，必须小于或等于 `max`。 | 否 |
| onChanged | ValueChanged&lt;num&gt;? | - | 数值变化请求。 点击按钮、提交有效输入或输入框失焦时触发；一次操作最多触发一次。 为 null 时整组禁用。 | 否 |
| size | TStepperSize? | - | 组件尺寸。 为空时使用 `TStepperSize.medium`。 | 否 |
| step | num | 1 | 加减按钮使用的步长，必须大于 0。 输入提交不要求是步长的整数倍，但会限制在 `min` 与 `max` 之间。 编辑时以合法输入草稿作为步进起点，并据此判断按钮是否达到边界。 | 否 |
| value | num | - | 受控数值，必须位于 `min` 与 `max` 之间。 | 是 |
| variant | TStepperVariant? | - | 组件形态。 为空时使用 `TStepperVariant.normal`。 | 否 |


### TStepperThemeData

#### 构造方法

##### TStepperThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | filled 形态各段的背景色。 | 否 |
| borderColor | Color? | - | outline 形态的描边颜色。 | 否 |
| borderRadius | BorderRadius? | - | 分段圆角，默认使用 TDesign `radiusSmall`。 normal 和 filled 应用于每一段；outline 仅保留整组外侧圆角。 | 否 |
| borderWidth | double? | - | outline 形态的描边宽度，默认 1。 | 否 |
| controlSize | double? | - | 控件高度及单个按钮宽度。 为空时 small、medium、large 分别使用 20、24、26。 | 否 |
| disabledBackgroundColor | Color? | - | 整组禁用时 filled 和 outline 形态各段的背景色。 | 否 |
| disabledForegroundColor | Color? | - | 边界不可操作按钮及整组禁用时的前景色。 | 否 |
| foregroundColor | Color? | - | 输入文字和加减图标的默认前景色。 | 否 |
| iconSize | double? | - | 加减图标尺寸。 为空时 small、medium、large 分别使用 12、16、20。 | 否 |
| inputWidth | double? | - | 输入段宽度。 为空时 small、medium、large 分别使用 34、38、45。 | 否 |
| spacing | double? | - | normal 和 filled 形态的分段间距，默认 4。 outline 始终连续排列，不使用该值。 | 否 |
| textStyle | TextStyle? | - | 输入文字样式。 在继承全局 TDesign Token 后合并；非空字段可覆盖 默认字号、行高及 `foregroundColor`。仅覆盖字号时会按最终字号重新计算 默认行高倍数；显式设置的 `TextStyle.height` 始终优先。最终字号或显式 物理行盒超过控件高度属于无效配置，并会在调试模式触发断言。 | 否 |


#### 实例方法

##### TStepperThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| inputWidth | double? | - | 字段含义：输入段宽度；为空时 small、medium、large 分别为 34、38、45。 调用时的空值行为见方法说明。 | 否 |
| controlSize | double? | - | 字段含义：控件高度及按钮宽度；为空时三档尺寸分别为 20、24、26。 调用时的空值行为见方法说明。 | 否 |
| iconSize | double? | - | 字段含义：加减图标尺寸；为空时三档尺寸分别为 12、16、20。 调用时的空值行为见方法说明。 | 否 |
| spacing | double? | - | 字段含义：normal 和 filled 形态的分段间距，默认 4；outline 不使用。 调用时的空值行为见方法说明。 | 否 |
| borderRadius | BorderRadius? | - | 字段含义：分段圆角，默认使用 TDesign `radiusSmall`。 调用时的空值行为见方法说明。 | 否 |
| borderWidth | double? | - | 字段含义：outline 形态的描边宽度，默认 1。 调用时的空值行为见方法说明。 | 否 |
| foregroundColor | Color? | - | 字段含义：输入文字和加减图标的默认前景色。 调用时的空值行为见方法说明。 | 否 |
| disabledForegroundColor | Color? | - | 字段含义：边界按钮及整组禁用时的前景色。 调用时的空值行为见方法说明。 | 否 |
| backgroundColor | Color? | - | 字段含义：filled 形态各段的背景色。 调用时的空值行为见方法说明。 | 否 |
| disabledBackgroundColor | Color? | - | 字段含义：整组禁用时 filled 和 outline 形态各段的背景色。 调用时的空值行为见方法说明。 | 否 |
| borderColor | Color? | - | 字段含义：outline 形态的描边颜色。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：输入文本样式，可覆盖继承样式中的字号、行高和前景色。 仅覆盖字号时会按最终字号重新计算默认行高倍数；显式行高始终优先。最终 字号或显式物理行盒超过控件高度属于无效配置，并会在调试模式触发断言。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TStepperThemeData | - | - | - |


##### TStepperThemeData.lerp

位置参数：`other, t`


插值保留未指定字段的继承语义，由组件结合当前实例尺寸与主题解析。

两端均未指定的字段仍为 null；端点返回原始配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TStepperThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TStepperThemeData | - | - | - |


### TStepperSize
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TStepperSize | - | 小尺寸：控件高度 20，输入段宽度 34，图标尺寸 12。 | - |
| medium | TStepperSize | - | 中尺寸：控件高度 24，输入段宽度 38，图标尺寸 16。 这是默认尺寸。 | - |
| large | TStepperSize | - | 大尺寸：控件高度 26，输入段宽度 45，图标尺寸 20。 | - |


### TStepperVariant
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| normal | TStepperVariant | - | 透明分段形态，段间默认保留 4px 间距。 这是默认形态。 | - |
| filled | TStepperVariant | - | 填充分段形态，三段使用背景色并保留默认 4px 间距。 | - |
| outline | TStepperVariant | - | 连续描边形态，三段之间不保留间距。 | - |
