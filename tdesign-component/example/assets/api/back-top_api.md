## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TBackTop

#### 声明

```dart
class TBackTop extends StatefulWidget
```

#### 默认构造方法


```dart
const TBackTop({
  Key? key,
  this.controller,
  this.onPressed,
  this.showText = false,
  this.visibilityOffset = 200,
  this.tooltip,
  this.shape = TBackTopShape.circle,
  this.colorPreset = TBackTopColorPreset.light,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| colorPreset | TBackTopColorPreset | TBackTopColorPreset.light | 局部配色预设，默认 `TBackTopColorPreset.light`；不切换全局明暗主题。 | 否 |
| controller | ScrollController? | - | 页面滚动控制器。 未传时组件始终可见，点击只触发 `onPressed`；传入后组件监听滚动偏移并 在点击时动画回到该滚动位置的最小边界。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onPressed | VoidCallback? | - | 回顶动画完成后的通知。 `null` 不表示禁用；只要提供 `controller`，组件仍可点击并执行回顶。 | 否 |
| shape | TBackTopShape | TBackTopShape.circle | 结构形态，默认 `TBackTopShape.circle`。 | 否 |
| showText | bool | false | 是否显示设计内置文案。 圆形显示“顶部”，半圆形显示“返回/顶部”，文案来自当前资源代理。 | 否 |
| tooltip | String? | - | 读屏和 Tooltip 提示；未传时使用当前资源代理的“返回顶部”。 | 否 |
| visibilityOffset | double | 200 | 绑定 `controller` 时的显示阈值，默认 200。 滚动偏移大于或等于该值时显示；未绑定 `controller` 时不参与显隐。 | 否 |


### TBackTopThemeData

#### 声明

```dart
class TBackTopThemeData extends ThemeExtension<TBackTopThemeData>
```

#### 默认构造方法


```dart
const TBackTopThemeData({
  this.backgroundColor,
  this.borderColor,
  this.contentColor,
  this.roundSize,
  this.halfCircleHeight,
  this.halfCircleMinWidth,
  this.iconSize,
  this.borderWidth,
  this.halfCircleHorizontalPadding,
  this.contentGap,
  this.textStyle,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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

```dart
TBackTopThemeData copyWith({
  Color? backgroundColor,
  Color? borderColor,
  Color? contentColor,
  double? roundSize,
  double? halfCircleHeight,
  double? halfCircleMinWidth,
  double? iconSize,
  double? borderWidth,
  double? halfCircleHorizontalPadding,
  double? contentGap,
  TextStyle? textStyle,
})
```


返回类型：`TBackTopThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景色；未设置时根据实例配色读取 TDesign 语义 Token。 | 否 |
| borderColor | Color? | - | 边框色；未设置时根据实例配色读取 TDesign 语义 Token。 | 否 |
| contentColor | Color? | - | 图标和文字颜色；未设置时根据实例配色读取 TDesign 语义 Token。 | 否 |
| roundSize | double? | - | 圆形宽高，默认 48。 | 否 |
| halfCircleHeight | double? | - | 半圆形高度，默认 40。 | 否 |
| halfCircleMinWidth | double? | - | 半圆形无文字时的最小宽度，默认 38。 | 否 |
| iconSize | double? | - | 图标尺寸，默认 20。 | 否 |
| borderWidth | double? | - | 边框宽度，默认 0.5。 | 否 |
| halfCircleHorizontalPadding | double? | - | 半圆形水平内边距，默认 8。 | 否 |
| contentGap | double? | - | 半圆形图标与文字间距，默认 2。 | 否 |
| textStyle | TextStyle? | - | 文案字体样式；未设置字段回退 Mark Extra Small 字体。 文字颜色与图标颜色统一由 `contentColor` 控制，传入样式中的 `color` 不参与解析，避免同一内容色存在两个 Theme 状态源。 | 否 |


##### TBackTopThemeData.lerp

```dart
TBackTopThemeData lerp(ThemeExtension<TBackTopThemeData>? other, double t)
```


返回类型：`TBackTopThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TBackTopThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


### TBackTopShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 48 × 48 的圆形返回顶部。 |
| halfCircle | 贴靠屏幕右侧的半圆形返回顶部。 |


### TBackTopColorPreset
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| light | 浅色容器配色。 |
| dark | 深色容器配色。 |
