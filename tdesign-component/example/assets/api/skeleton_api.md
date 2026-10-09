## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSkeleton

#### 声明

```dart
class TSkeleton extends StatefulWidget
```


#### 命名构造方法

##### TSkeleton.custom

```dart
const TSkeleton.custom({
  super.key,
  required TSkeletonLayout layout,
  this.animation,
  this.delay = Duration.zero,
})
```


使用自定义行列布局创建骨架屏。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TSkeletonLayout | - | 自定义布局；预设形态时为空。 | 是 |
| animation | TSkeletonAnimation? | - | 动画效果；为 null 时保持静态。 | 否 |
| delay | Duration | Duration.zero | 骨架屏的延迟显示时间，用于避免短请求产生闪烁。 | 否 |

#### 默认构造方法


```dart
const TSkeleton({
  super.key,
  TSkeletonVariant variant = TSkeletonVariant.text,
  this.animation,
  this.delay = Duration.zero,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| animation | TSkeletonAnimation? | - | 动画效果；为 null 时保持静态。 | 否 |
| delay | Duration | Duration.zero | 骨架屏的延迟显示时间，用于避免短请求产生闪烁。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| variant | TSkeletonVariant | TSkeletonVariant.text | 预设形态；自定义布局时为空。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| layout | TSkeletonLayout? | - | 自定义布局；预设形态时为空。 |


### TSkeletonLayout
#### 简介
骨架屏的行列布局。

#### 声明

```dart
class TSkeletonLayout
```

#### 默认构造方法


```dart
const TSkeletonLayout({required this.rows, this.rowSpacing})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| rows | List&lt;List&lt;TSkeletonBlock&gt;&gt; | - | 每个内层列表表示一行骨架块。 | 是 |
| rowSpacing | double? | - | 行间距；未设置时读取组件主题和 TDesign token。 | 否 |


### TSkeletonBlockStyle
#### 简介
单个骨架块的视觉样式。

#### 声明

```dart
class TSkeletonBlockStyle
```

#### 默认构造方法


```dart
const TSkeletonBlockStyle({
  this.color,
  this.borderRadius,
  this.shape = TSkeletonBlockShape.rounded,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| borderRadius | double? | - | 骨架块圆角；优先于 `shape` 和组件主题。 | 否 |
| color | Color? | - | 骨架块颜色；优先于组件主题。 | 否 |
| shape | TSkeletonBlockShape | TSkeletonBlockShape.rounded | 骨架块形状。 | 否 |


### TSkeletonBlock
#### 简介
骨架屏中的一个占位块。

#### 声明

```dart
class TSkeletonBlock
```


#### 命名构造方法

##### TSkeletonBlock.circle

```dart
const TSkeletonBlock.circle({
  this.width = 48,
  this.height = 48,
  this.flex,
  this.margin = EdgeInsets.zero,
  this.style = const TSkeletonBlockStyle(shape: TSkeletonBlockShape.circle),
})
```


圆形占位块。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| width | double? | 48 | 宽度。 | 否 |
| height | double? | 48 | 高度。 | 否 |
| flex | int? | - | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle(shape: TSkeletonBlockShape.circle) | 视觉样式。 | 否 |


##### TSkeletonBlock.line

```dart
const TSkeletonBlock.line({
  this.width,
  this.height = 16,
  this.flex = 1,
  this.margin = EdgeInsets.zero,
  this.style = const TSkeletonBlockStyle(),
})
```


文本行占位块。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| width | double? | - | 宽度。 | 否 |
| height | double? | 16 | 高度。 | 否 |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle() | 视觉样式。 | 否 |


##### TSkeletonBlock.rectangle

```dart
const TSkeletonBlock.rectangle({
  this.width,
  this.height = 16,
  this.flex = 1,
  this.margin = EdgeInsets.zero,
  this.style = const TSkeletonBlockStyle(
    shape: TSkeletonBlockShape.rectangle,
  ),
})
```


无圆角矩形占位块。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| width | double? | - | 宽度。 | 否 |
| height | double? | 16 | 高度。 | 否 |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle(shape: TSkeletonBlockShape.rectangle) | 视觉样式。 | 否 |


##### TSkeletonBlock.spacer

```dart
const TSkeletonBlock.spacer({
  this.width,
  this.height,
  this.flex,
  this.margin = EdgeInsets.zero,
})
```


透明间隔块。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| width | double? | - | 宽度。 | 否 |
| height | double? | - | 高度。 | 否 |
| flex | int? | - | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |

#### 默认构造方法


```dart
const TSkeletonBlock({
  this.width,
  this.height = 16,
  this.flex = 1,
  this.margin = EdgeInsets.zero,
  this.style = const TSkeletonBlockStyle(),
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| flex | int? | 1 | 同一行内的弹性因子；为 null 时按固定宽度布局。 | 否 |
| height | double? | 16 | 高度。 | 否 |
| margin | EdgeInsets | EdgeInsets.zero | 外边距。 | 否 |
| style | TSkeletonBlockStyle | const TSkeletonBlockStyle() | 视觉样式。 | 否 |
| width | double? | - | 宽度。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isSpacer | bool | - | 是否是透明间隔块。 |


### TSkeletonThemeData
#### 简介
骨架屏组件级 ThemeExtension。
仅保存占位块的视觉和布局默认值；动画、延迟与具体布局由实例决定。
{@category ComponentTheme}

#### 声明

```dart
class TSkeletonThemeData extends ThemeExtension<TSkeletonThemeData>
```

#### 默认构造方法


```dart
const TSkeletonThemeData({
  this.blockColor,
  this.highlightColor,
  this.borderRadius,
  this.rowSpacing,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| blockColor | Color? | - | 占位块背景色。 未配置时使用 bgColorSecondaryContainer Token。 | 否 |
| borderRadius | double? | - | 普通占位块圆角。 未配置时使用 radiusSmall Token，必须大于或等于 0。 | 否 |
| highlightColor | Color? | - | 渐变动画高亮色。 未配置时使用 bgColorSecondaryContainerActive Token。 | 否 |
| rowSpacing | double? | - | 多行布局的默认行间距。 未配置时使用 spacer2 Token，必须大于或等于 0。 | 否 |


#### 实例方法

##### TSkeletonThemeData.copyWith

```dart
TSkeletonThemeData copyWith({
  Color? blockColor,
  Color? highlightColor,
  double? borderRadius,
  double? rowSpacing,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TSkeletonThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| blockColor | Color? | - | 占位块背景色。 未配置时使用 bgColorSecondaryContainer Token。 | 否 |
| highlightColor | Color? | - | 渐变动画高亮色。 未配置时使用 bgColorSecondaryContainerActive Token。 | 否 |
| borderRadius | double? | - | 普通占位块圆角。 未配置时使用 radiusSmall Token，必须大于或等于 0。 | 否 |
| rowSpacing | double? | - | 多行布局的默认行间距。 未配置时使用 spacer2 Token，必须大于或等于 0。 | 否 |


##### TSkeletonThemeData.lerp

```dart
TSkeletonThemeData lerp(TSkeletonThemeData? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TSkeletonThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TSkeletonThemeData? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TSkeletonAnimation
#### 简介
骨架屏动画。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| gradient | 高亮渐变扫过骨架块。 |
| flashed | 骨架块透明度闪烁。 |


### TSkeletonVariant
#### 简介
骨架屏预设形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| avatar | 头像占位。 |
| image | 图片占位。 |
| text | 双行文本占位。 |
| paragraph | 四行段落占位。 |


### TSkeletonBlockShape
#### 简介
骨架块形状。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| rounded | 使用组件主题或 TDesign token 提供的圆角。 |
| circle | 圆形或胶囊形。 |
| rectangle | 无圆角矩形。 |
