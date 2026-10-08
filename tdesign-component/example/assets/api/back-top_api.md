## API

### TBackTop

返回顶部组件。

绑定 `controller` 后，滚动偏移达到 `visibilityOffset` 时显示；点击时先
动画回到顶部，再触发可选的 `onPressed` 完成通知。

#### 构造方法

##### TBackTop

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| colorPreset | TBackTopColorPreset | TBackTopColorPreset.light | 局部配色预设，默认 `TBackTopColorPreset.light`；不切换全局明暗主题。 | 否 |
| controller | ScrollController? | - | 页面滚动控制器。 未传时组件始终可见，点击只触发 `onPressed`；传入后组件监听滚动偏移并 在点击时以 500 毫秒、Curves.easeIn 动画回到该滚动位置的最小边界。 控制器由调用方创建和释放，组件只管理自己的滚动监听。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onPressed | VoidCallback? | - | 回顶动画完成后的通知。 `null` 不表示禁用；只要提供 `controller`，组件仍可点击并执行回顶。 | 否 |
| shape | TBackTopShape | TBackTopShape.circle | 结构形态，默认 `TBackTopShape.circle`。 | 否 |
| showText | bool | false | 是否显示设计内置文案。 圆形显示“顶部”，半圆形显示“返回/顶部”，文案来自当前资源代理。 | 否 |
| tooltip | String? | - | 读屏和 Tooltip 提示；未传时使用当前资源代理的“返回顶部”。 | 否 |
| visibilityOffset | double | 200 | 绑定 `controller` 时的显示阈值，默认 200；必须大于或等于 0。 滚动偏移大于或等于该值时显示；未绑定 `controller` 时不参与显隐。 | 否 |


### TBackTopThemeData

返回顶部组件 ThemeExtension。

只承载子树级具体视觉默认值；结构形态、配色选择和滚动显隐行为由
`TBackTop` 实例唯一拥有。

#### 构造方法

##### TBackTopThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色；未设置时根据实例配色读取 TDesign 语义 Token。 | 否 |
| borderColor | Color? | - | 边框色；未设置时根据实例配色读取 TDesign 语义 Token。 | 否 |
| borderWidth | double? | - | 边框宽度，默认 0.5。 | 否 |
| contentColor | Color? | - | 图标和文字颜色；未设置时根据实例配色读取 TDesign 语义 Token。 | 否 |
| contentGap | double? | - | 半圆形图标与文字间距，默认 2。 | 否 |
| halfCircleHeight | double? | - | 半圆形高度，默认 40。 | 否 |
| halfCircleHorizontalPadding | double? | - | 半圆形水平内边距，默认 8。 | 否 |
| halfCircleMinWidth | double? | - | 半圆形无文字时的最小宽度，默认 38。 | 否 |
| iconSize | double? | - | 图标尺寸，默认 20。 | 否 |
| roundSize | double? | - | 圆形宽高，默认 48。 | 否 |
| textStyle | TextStyle? | - | 文案字体样式；未设置字段回退 Mark Extra Small 字体。 文字颜色与图标颜色统一由 `contentColor` 控制，传入样式中的 `color` 不参与解析，避免同一内容色存在两个 Theme 状态源。 | 否 |


#### 实例方法

##### TBackTopThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 字段含义：背景色；未设置时根据实例配色读取 TDesign 语义 Token。 调用时的空值行为见方法说明。 | 否 |
| borderColor | Color? | - | 字段含义：边框色；未设置时根据实例配色读取 TDesign 语义 Token。 调用时的空值行为见方法说明。 | 否 |
| contentColor | Color? | - | 字段含义：图标和文字颜色；未设置时根据实例配色读取 TDesign 语义 Token。 调用时的空值行为见方法说明。 | 否 |
| roundSize | double? | - | 字段含义：圆形宽高，默认 48。 调用时的空值行为见方法说明。 | 否 |
| halfCircleHeight | double? | - | 字段含义：半圆形高度，默认 40。 调用时的空值行为见方法说明。 | 否 |
| halfCircleMinWidth | double? | - | 字段含义：半圆形无文字时的最小宽度，默认 38。 调用时的空值行为见方法说明。 | 否 |
| iconSize | double? | - | 字段含义：图标尺寸，默认 20。 调用时的空值行为见方法说明。 | 否 |
| borderWidth | double? | - | 字段含义：边框宽度，默认 0.5。 调用时的空值行为见方法说明。 | 否 |
| halfCircleHorizontalPadding | double? | - | 字段含义：半圆形水平内边距，默认 8。 调用时的空值行为见方法说明。 | 否 |
| contentGap | double? | - | 字段含义：半圆形图标与文字间距，默认 2。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：文案字体样式；未设置字段回退 Mark Extra Small 字体。 文字颜色与图标颜色统一由 `contentColor` 控制，传入样式中的 `color` 不参与解析，避免同一内容色存在两个 Theme 状态源。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TBackTopThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TBackTopThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TBackTopThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TBackTopThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TBackTopShape

返回顶部结构形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| circle | TBackTopShape | - | 48 × 48 的圆形返回顶部。 | - |
| halfCircle | TBackTopShape | - | 贴靠屏幕右侧的半圆形返回顶部。 | - |


### TBackTopColorPreset

返回顶部预设配色。

只选择一组协调的背景、边框和内容颜色，不改变组件结构或交互。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| light | TBackTopColorPreset | - | 浅色容器配色。 | - |
| dark | TBackTopColorPreset | - | 深色容器配色。 | - |
