## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TBadge
#### 简介
在内容边角或独立位置展示短文本、圆点或角标状态。
默认使用 `TBadgeVariant.circle` 与 `TBadgeSize.medium`。当 `child` 非空时，
徽标叠加在 `child` 上；当 `child` 为空时，只渲染徽标本体。
TabBar、SideBar、ActionSheet 等内部拥有锚点的组合组件使用
`TBadgeConfig`，调用方不应向这些组件传入一个待拆解的 `TBadge`。

#### 声明

```dart
class TBadge extends StatelessWidget
```


#### 命名构造方法

##### TBadge.custom

```dart
const TBadge.custom({
  super.key,
  required this.badge,
  this.alignment,
  this.offset,
  this.child,
  this.onTap,
})
```


创建完全自定义外观的徽标；`badge` 是徽标本体，`child` 是可选锚点，未提供锚点时直接展示徽标本体。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| badge | Widget? | - | `TBadge.custom` 提供的完整徽标外观。 普通构造下为 null。该 Widget 仅表示徽标本体，不包含 `child`。 | 是 |
| alignment | AlignmentGeometry? | - | 徽标相对 `child` 的对齐方式。 为空时使用组合组件提供的对齐位置，最终回退为逻辑 右上角 `AlignmentDirectional.topEnd`，在 RTL 下对应物理左上角。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 当 `child` 为空时不参与布局。 | 否 |
| offset | Offset? | - | 相对默认锚点的逐实例位置偏移；未设置时使用组合组件提供的 默认偏移，最终回退为 `Offset.zero`。 显式值使用物理坐标：正 x 始终向右，RTL 下不会自动镜像。 默认徽标以中心点对齐内容的逻辑右上角，在 RTL 下对应物理左上角。 当 `child` 为空时不参与布局。 | 否 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 | 否 |
| onTap | GestureTapCallback? | - | 点击徽标及其 `child` 时触发；为空时不创建点击语义。 | 否 |

#### 默认构造方法


```dart
const TBadge({
  super.key,
  this.label = '0',
  this.variant = TBadgeVariant.circle,
  this.size = TBadgeSize.medium,
  this.border = false,
  this.showZero = true,
  this.alignment,
  this.offset,
  this.child,
  this.onTap,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| alignment | AlignmentGeometry? | - | 徽标相对 `child` 的对齐方式。 为空时使用组合组件提供的对齐位置，最终回退为逻辑 右上角 `AlignmentDirectional.topEnd`，在 RTL 下对应物理左上角。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 当 `child` 为空时不参与布局。 | 否 |
| border | bool | false | 是否为徽标增加对比色描边，默认为 false，适用于全部形态。 | 否 |
| child | Widget? | - | 被徽标标记的内容；为空时徽标可独立展示。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| label | String? | '0' | 徽标实际展示的短文本，例如 `8`、`99+` 或 `NEW`。 文本形态下为 null 时隐藏徽标；`TBadgeVariant.dot` 不读取该字段。 | 否 |
| offset | Offset? | - | 相对默认锚点的逐实例位置偏移；未设置时使用组合组件提供的 默认偏移，最终回退为 `Offset.zero`。 显式值使用物理坐标：正 x 始终向右，RTL 下不会自动镜像。 默认徽标以中心点对齐内容的逻辑右上角，在 RTL 下对应物理左上角。 当 `child` 为空时不参与布局。 | 否 |
| onTap | GestureTapCallback? | - | 点击徽标及其 `child` 时触发；为空时不创建点击语义。 | 否 |
| showZero | bool | true | `label` 恰好为字符串 `0` 时是否显示徽标，默认为 true。 `TBadgeVariant.dot` 始终显示，不受该字段影响。 | 否 |
| size | TBadgeSize | TBadgeSize.medium | 徽标的预设尺寸，默认为 `TBadgeSize.medium`。 `TBadgeVariant.dot` 与 `TBadge.custom` 不读取该字段。 | 否 |
| variant | TBadgeVariant | TBadgeVariant.circle | 徽标的结构形态，默认为 `TBadgeVariant.circle`。 `TBadge.custom` 不读取该字段。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | Widget? | - | `TBadge.custom` 提供的完整徽标外观。 普通构造下为 null。该 Widget 仅表示徽标本体，不包含 `child`。 |


### TBadgeConfig
#### 简介
由组合组件消费的徽标配置。
该对象不参与 Widget 树，也不拥有被标记的内容。仅当 TabBar、SideBar、
ActionSheet 等组件在内部创建徽标锚点时使用；组件会把配置和自己的锚点交给
与 `TBadge` 相同的渲染实现。
调用方已经拥有锚点 Widget 时，应直接使用 `TBadge`：

完全自定义徽标外观时使用 `TBadgeConfig.custom`。传入的 `badge` 是徽标本体，
不应包含锚点或自行使用 `Positioned` 定位。

#### 声明

```dart
class TBadgeConfig
```


#### 命名构造方法

##### TBadgeConfig.custom

```dart
const TBadgeConfig.custom({required this.badge, this.alignment, this.offset})
```


创建完全自定义外观的徽标配置。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| badge | Widget? | - | 仅定义徽标本体；最终锚点和默认位置由消费该配置的组合组件决定。 | 是 |
| alignment | AlignmentGeometry? | - | 徽标相对锚点的对齐方式。 为空时使用消费组件的默认值。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 | 否 |
| offset | Offset? | - | 在最终对齐位置上追加的偏移。 为空时使用消费组件的默认值。 显式值使用物理坐标：正 x 始终向右，RTL 下不会自动镜像；消费组件仅会 根据最终生效的 `alignment` 转换自己提供的默认偏移。 ribbon、triangle 始终贴住锚点的物理左上角或右上角，但仍读取该偏移。 | 否 |

#### 默认构造方法


```dart
const TBadgeConfig({
  this.label = '0',
  this.variant = TBadgeVariant.circle,
  this.size = TBadgeSize.medium,
  this.border = false,
  this.showZero = true,
  this.alignment,
  this.offset,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| alignment | AlignmentGeometry? | - | 徽标相对锚点的对齐方式。 为空时使用消费组件的默认值。 ribbon、triangle 的方位已编码在 `variant` 中，不读取该字段。 | 否 |
| border | bool | false | 是否为预设徽标增加对比色描边，默认为 false。 `TBadgeConfig.custom` 不读取该字段。 | 否 |
| label | String? | '0' | 预设徽标展示的短文本，例如 `8`、`99+` 或 `NEW`。 文本形态下为 null 时隐藏徽标；`TBadgeVariant.dot` 不读取该字段。 `TBadgeConfig.custom` 下固定为 null。 | 否 |
| offset | Offset? | - | 在最终对齐位置上追加的偏移。 为空时使用消费组件的默认值。 显式值使用物理坐标：正 x 始终向右，RTL 下不会自动镜像；消费组件仅会 根据最终生效的 `alignment` 转换自己提供的默认偏移。 ribbon、triangle 始终贴住锚点的物理左上角或右上角，但仍读取该偏移。 | 否 |
| showZero | bool | true | `label` 恰好为字符串 `0` 时是否显示，默认为 true。 `TBadgeVariant.dot` 与 `TBadgeConfig.custom` 不读取该字段。 | 否 |
| size | TBadgeSize | TBadgeSize.medium | 预设徽标尺寸，默认为 `TBadgeSize.medium`。 `TBadgeVariant.dot` 与 `TBadgeConfig.custom` 不读取该字段。 | 否 |
| variant | TBadgeVariant | TBadgeVariant.circle | 预设徽标的结构形态，默认为 `TBadgeVariant.circle`。 `TBadgeConfig.custom` 不读取该字段。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | Widget? | - | `TBadgeConfig.custom` 提供的完整徽标外观。 普通构造下为 null。该 Widget 不包含锚点，定位由消费组件负责。 |
| isCustom | bool | - | 当前配置是否使用完全自定义徽标外观。 |


### TBadgeThemeData
#### 简介
TDesign 徽标的子树级视觉默认值。
形态、内容、对齐和偏移由实例 API 控制，不从 Material BadgeTheme 读取。

#### 声明

```dart
class TBadgeThemeData extends ThemeExtension<TBadgeThemeData>
```

#### 默认构造方法


```dart
const TBadgeThemeData({
  this.backgroundColor,
  this.dotSize,
  this.labelHeight,
  this.textStyle,
  this.padding,
  this.borderColor,
  this.borderWidth,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 徽标背景色；为空时使用全局错误色 Token。 | 否 |
| borderColor | Color? | - | 开启描边时使用的颜色；为空时回退到当前容器背景色。 | 否 |
| borderWidth | double? | - | 开启描边时使用的宽度；为空时使用 1 逻辑像素。 | 否 |
| dotSize | double? | - | 圆点直径；为空时使用 8 逻辑像素。 | 否 |
| labelHeight | double? | - | 文字徽标高度；为空时由当前尺寸的字体 Token 决定。 | 否 |
| padding | EdgeInsetsGeometry? | - | 文字徽标内边距；为空时中、大尺寸分别使用左右 4、6 逻辑像素。 | 否 |
| textStyle | TextStyle? | - | 徽标文字的唯一组件级样式入口；未配置字段从字体与反色文字 Token 取得。 | 否 |


#### 实例方法

##### TBadgeThemeData.copyWith

```dart
TBadgeThemeData copyWith({
  Color? backgroundColor,
  double? dotSize,
  double? labelHeight,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Color? borderColor,
  double? borderWidth,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TBadgeThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 徽标背景色；为空时使用全局错误色 Token。 | 否 |
| dotSize | double? | - | 圆点直径；为空时使用 8 逻辑像素。 | 否 |
| labelHeight | double? | - | 文字徽标高度；为空时由当前尺寸的字体 Token 决定。 | 否 |
| textStyle | TextStyle? | - | 徽标文字的唯一组件级样式入口；未配置字段从字体与反色文字 Token 取得。 | 否 |
| padding | EdgeInsetsGeometry? | - | 文字徽标内边距；为空时中、大尺寸分别使用左右 4、6 逻辑像素。 | 否 |
| borderColor | Color? | - | 开启描边时使用的颜色；为空时回退到当前容器背景色。 | 否 |
| borderWidth | double? | - | 开启描边时使用的宽度；为空时使用 1 逻辑像素。 | 否 |


##### TBadgeThemeData.lerp

```dart
TBadgeThemeData lerp(ThemeExtension<TBadgeThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TBadgeThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TBadgeThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TBadgeVariant
#### 简介
徽标的结构形态；尺寸与描边分别由 `TBadge.size`、`TBadge.border` 控制。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 标准文本徽标；单字符呈圆形，多字符随内容扩展为胶囊形。 |
| dot | 不显示文本的圆点徽标，默认直径为 8 逻辑像素。 |
| square | 小圆角方形文本徽标；多字符时随内容横向扩展为矩形。 |
| bubble | 左下角收紧、其余角为圆角的气泡徽标。 |
| ribbonRight | 位于内容物理右上角的带状角标；RTL 下不交换方位。 |
| ribbonLeft | 位于内容物理左上角的带状角标；RTL 下不交换方位。 |
| triangleRight | 位于内容物理右上角的三角角标；RTL 下不交换方位。 |
| triangleLeft | 位于内容物理左上角的三角角标；RTL 下不交换方位。 |


### TBadgeSize
#### 简介
徽标的预设尺寸，控制文本徽标的文字 Token、标签行盒高度与水平内边距。
`TBadgeVariant.dot` 的直径由 `TBadgeThemeData.dotSize` 控制，不读取该值；
角标形态会按该值在 32 与 40 逻辑像素两档尺寸之间切换。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| medium | 中尺寸，使用 `fontMarkExtraSmall` 与 16 逻辑像素标签行盒。 |
| large | 大尺寸，使用 `fontMarkSmall` 与 20 逻辑像素标签行盒。 |
