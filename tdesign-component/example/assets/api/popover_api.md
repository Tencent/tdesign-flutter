## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TPopover
#### 简介
气泡弹层
可通过 `showPopover` 一次性弹出，或通过 `TPopoverAnchor` 建立可控制气泡，
支持 12 个方向定位和箭头。蒙层色与圆角由触发 `BuildContext` 最近的
`TPopoverThemeData` 控制；单个气泡可包裹局部 Theme。

#### 声明

```dart
class TPopover
```


#### 静态方法

##### TPopover.showPopover

```dart
static Future<void> showPopover({
  required BuildContext context,
  required Widget content,
  TPopoverColorPreset colorPreset = TPopoverColorPreset.defaultTheme,
  bool closeOnClickOutside = true,
  bool closeOnScroll = true,
  TPopoverPlacement placement = TPopoverPlacement.top,
  bool? showArrow,
  double? width,
  double? height,
  VoidCallback? onTap,
  VoidCallback? onLongTap,
})
```


显示气泡弹层

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 触发元素的上下文，用于计算气泡锚点位置。 | 是 |
| content | Widget | - | 气泡内容。 直接传入未设置样式的 `Text` 时使用气泡默认文字样式；组合内容应自行定义 子组件样式和布局。 | 是 |
| colorPreset | TPopoverColorPreset | TPopoverColorPreset.defaultTheme | 气泡预设配色。 | 否 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 外部目标仍会接收该次点击，因此可在单次点击中从一个气泡切换到另一个气泡。 | 否 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 默认为 true，避免触发元素移动后气泡停留在旧坐标。 | 否 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置，默认为 `TPopoverPlacement.top`。 | 否 |
| showArrow | bool? | - | 是否显示气泡箭头。 | 否 |
| width | double? | - | 内容外框宽度（包含 padding）。 未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。 | 否 |
| height | double? | - | 内容外框高度（包含 padding）。 未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。 | 否 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 | 否 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 | 否 |

#### 默认构造方法


```dart
TPopover()
```


### TPopoverAnchor
#### 简介
将可控制的气泡与 Widget 树中的触发区域绑定。
`TPopoverAnchor` 声明气泡内容、位置和视觉配置，`TPopoverController` 只负责
`open`、`close` 和 `isOpen`。简单的一次性展示仍可使用
`TPopover.showPopover`。
蒙层色与圆角由最近的 `TPopoverThemeData` 控制；单个气泡使用局部 Theme。
气泡展开时会读取当前的内容、位置、视觉配置和关闭策略；展开期间更新这些
配置不会刷新已显示的浮层，关闭后再次展开时生效。`builder` 和 `child` 仍按
普通 Widget 树的更新规则重建。

#### 声明

```dart
class TPopoverAnchor extends StatefulWidget
```

#### 默认构造方法


```dart
const TPopoverAnchor({
  super.key,
  required this.content,
  required this.builder,
  this.controller,
  this.child,
  this.colorPreset = TPopoverColorPreset.defaultTheme,
  this.closeOnClickOutside = true,
  this.closeOnScroll = true,
  this.placement = TPopoverPlacement.top,
  this.showArrow,
  this.width,
  this.height,
  this.onTap,
  this.onLongTap,
  this.onOpen,
  this.onClose,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| builder | TPopoverAnchorBuilder | - | 构建气泡所绑定的触发区域。 构建器会收到当前有效的控制器；未传入 `controller` 时由组件内部创建。 | 是 |
| child | Widget? | - | 传递给 `builder` 的可选子组件。 | 否 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 外部目标仍会接收该次点击，因此可在单次点击中从一个气泡切换到另一个气泡。 | 否 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 | 否 |
| colorPreset | TPopoverColorPreset | TPopoverColorPreset.defaultTheme | 气泡预设配色。 | 否 |
| content | Widget | - | 气泡内容。 | 是 |
| controller | TPopoverController? | - | 可选控制器，用于从触发区域外部展开或关闭气泡。 | 否 |
| height | double? | - | 内容外框高度（包含 padding）。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onClose | VoidCallback? | - | 气泡通过任意路径关闭后触发。 | 否 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 | 否 |
| onOpen | VoidCallback? | - | 气泡展开后触发。 | 否 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 | 否 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置。 | 否 |
| showArrow | bool? | - | 是否显示气泡箭头。 | 否 |
| width | double? | - | 内容外框宽度（包含 padding）。 | 否 |


### TPopoverController
#### 简介
控制与其绑定的 `TPopoverAnchor`。
气泡内容、位置和视觉配置由 `TPopoverAnchor` 声明，控制器只负责展开、关闭
和查询当前状态，不形成第二份配置来源。

#### 声明

```dart
class TPopoverController
```


#### 静态方法

##### TPopoverController.maybeOf

```dart
static TPopoverController? maybeOf(BuildContext context)
```


返回 `context` 最近的 `TPopoverAnchor` 所关联的控制器。
未处于 Anchor 的触发区域或气泡内容子树时返回 null。

返回类型：`TPopoverController?`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |

#### 默认构造方法


```dart
TPopoverController()
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isOpen | bool | - | 与该控制器绑定的气泡是否已展开。 |


#### 实例方法

##### TPopoverController.close

```dart
void close()
```


关闭与该控制器绑定的气泡。
未绑定或已经关闭时无副作用。

返回类型：`void`

##### TPopoverController.open

```dart
void open()
```


展开与该控制器绑定的气泡。
控制器必须先通过 `TPopoverAnchor.controller` 绑定到 Widget 树。

返回类型：`void`

### TPopoverThemeData
#### 简介
TPopover 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认气泡样式。

#### 声明

```dart
class TPopoverThemeData extends ThemeExtension<TPopoverThemeData>
```

#### 默认构造方法


```dart
const TPopoverThemeData({
  this.backgroundColor,
  this.padding,
  this.minWidth,
  this.maxWidth,
  this.maxHeight,
  this.borderRadius,
  this.barrierColor,
  this.arrowSize,
  this.offset,
  this.boxShadow,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| arrowSize | double? | - | 箭头尺寸 | 否 |
| backgroundColor | Color? | - | 气泡背景色 | 否 |
| barrierColor | Color? | - | 蒙层色；未设置时透明。单个气泡可用局部 Theme 覆盖。 | 否 |
| borderRadius | BorderRadius? | - | 气泡圆角；未设置时回退全局默认圆角。单个气泡可用局部 Theme 覆盖。 | 否 |
| boxShadow | List&lt;BoxShadow&gt;? | - | 气泡阴影 | 否 |
| maxHeight | double? | - | 最大高度 | 否 |
| maxWidth | double? | - | 文本内容的最大宽度 | 否 |
| minWidth | double? | - | 最小宽度 | 否 |
| offset | double? | - | 弹层与触发元素的间距 | 否 |
| padding | EdgeInsetsGeometry? | - | 内边距 | 否 |


#### 实例方法

##### TPopoverThemeData.copyWith

```dart
TPopoverThemeData copyWith({
  Color? backgroundColor,
  EdgeInsetsGeometry? padding,
  double? minWidth,
  double? maxWidth,
  double? maxHeight,
  BorderRadius? borderRadius,
  Color? barrierColor,
  double? arrowSize,
  double? offset,
  List<BoxShadow>? boxShadow,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TPopoverThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 气泡背景色 | 否 |
| padding | EdgeInsetsGeometry? | - | 内边距 | 否 |
| minWidth | double? | - | 最小宽度 | 否 |
| maxWidth | double? | - | 文本内容的最大宽度 | 否 |
| maxHeight | double? | - | 最大高度 | 否 |
| borderRadius | BorderRadius? | - | 气泡圆角；未设置时回退全局默认圆角。单个气泡可用局部 Theme 覆盖。 | 否 |
| barrierColor | Color? | - | 蒙层色；未设置时透明。单个气泡可用局部 Theme 覆盖。 | 否 |
| arrowSize | double? | - | 箭头尺寸 | 否 |
| offset | double? | - | 弹层与触发元素的间距 | 否 |
| boxShadow | List&lt;BoxShadow&gt;? | - | 气泡阴影 | 否 |


##### TPopoverThemeData.lerp

```dart
TPopoverThemeData lerp(ThemeExtension<TPopoverThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TPopoverThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TPopoverThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TPopoverThemeData.merge

```dart
TPopoverThemeData merge(TPopoverThemeData? other)
```


返回合并后的主题；`other` 的非空字段覆盖当前字段，other 为空时返回当前主题。

返回类型：`TPopoverThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TPopoverThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TPopoverColorPreset
#### 简介
弹出气泡的内置配色预设；不切换全局明暗主题。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认深色配色。 |
| light | 浅色。 |
| primary | 品牌主色。 |
| success | 成功。 |
| warning | 警告。 |
| danger | 危险色。 |


### TPopoverPlacement
#### 简介
气泡弹层定位方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| topLeft | 上左。 |
| top | 上方。 |
| topRight | 上右。 |
| rightTop | 右上。 |
| right | 右侧。 |
| rightBottom | 右下。 |
| bottomRight | 下右。 |
| bottom | 下方。 |
| bottomLeft | 下左。 |
| leftBottom | 左下。 |
| left | 左侧。 |
| leftTop | 左上。 |


### TPopoverAnchorBuilder
#### 简介
`TPopoverAnchor` 的触发区域构建器。
`controller` 用于展开、关闭气泡和查询展开状态；`child` 是传给
`TPopoverAnchor.child` 的可选、不依赖展开状态的子组件。
#### 类型定义

```dart
typedef TPopoverAnchorBuilder = Widget Function(BuildContext context, TPopoverController controller, Widget? child);
```
