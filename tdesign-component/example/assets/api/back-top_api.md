## API
### TBackTop
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorScheme | TBackTopColorScheme | TBackTopColorScheme.light | 预设配色，默认 `TBackTopColorScheme.light`。 |
| controller | ScrollController? | - | 页面滚动控制器。 未传时组件始终可见，点击只触发 `onPressed`；传入后组件监听滚动偏移并 在点击时动画回到该滚动位置的最小边界。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 回顶动画完成后的通知。 `null` 不表示禁用；只要提供 `controller`，组件仍可点击并执行回顶。 |
| shape | TBackTopShape | TBackTopShape.circle | 结构形态，默认 `TBackTopShape.circle`。 |
| showText | bool | false | 是否显示设计内置文案。 圆形显示“顶部”，半圆形显示“返回/顶部”，文案来自当前资源代理。 |
| tooltip | String? | - | 读屏和 Tooltip 提示；未传时使用当前资源代理的“返回顶部”。 |
| visibilityOffset | double | 200 | 绑定 `controller` 时的显示阈值，默认 200。 滚动偏移大于或等于该值时显示；未绑定 `controller` 时不参与显隐。 |


### TBackTopThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色；未设置时根据实例配色读取 TDesign 语义 Token。 |
| borderColor | Color? | - | 边框色；未设置时根据实例配色读取 TDesign 语义 Token。 |
| borderWidth | double? | - | 边框宽度，默认 0.5。 |
| contentColor | Color? | - | 图标和文字颜色；未设置时根据实例配色读取 TDesign 语义 Token。 |
| contentGap | double? | - | 半圆形图标与文字间距，默认 2。 |
| halfCircleHeight | double? | - | 半圆形高度，默认 40。 |
| halfCircleHorizontalPadding | double? | - | 半圆形水平内边距，默认 8。 |
| halfCircleMinWidth | double? | - | 半圆形无文字时的最小宽度，默认 38。 |
| iconSize | double? | - | 图标尺寸，默认 20。 |
| roundSize | double? | - | 圆形宽高，默认 48。 |
| textStyle | TextStyle? | - | 文案字体样式；未设置字段回退 Mark Extra Small 字体。 文字颜色与图标颜色统一由 `contentColor` 控制，传入样式中的 `color` 不参与解析，避免同一内容色存在两个 Theme 状态源。 |


### TBackTopShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 48 × 48 的圆形返回顶部。 |
| halfCircle | 贴靠屏幕右侧的半圆形返回顶部。 |


### TBackTopColorScheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| light | 浅色容器配色。 |
| dark | 深色容器配色。 |
