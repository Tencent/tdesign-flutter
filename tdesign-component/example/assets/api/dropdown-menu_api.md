## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TDropdownMenu

#### 声明

```dart
class TDropdownMenu extends StatefulWidget
```

#### 默认构造方法


```dart
const TDropdownMenu({
  super.key,
  required this.items,
  this.controller,
  this.placement = TDropdownMenuPlacement.auto,
  this.scrollable = false,
  this.showOverlay = true,
  this.closeOnOverlayTap = true,
  this.useRootOverlay = false,
  this.animationDuration,
  this.onOpened,
  this.onClosed,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 展开、关闭及切换动画时长。 未指定时为 200ms。系统禁用动画时始终使用零时长。 | 否 |
| closeOnOverlayTap | bool | true | 点击外部区域是否关闭面板，默认 true；不依赖遮罩是否绘制。 | 否 |
| controller | TDropdownMenuController? | - | 外部筛选栏控制器；为空时由组件创建和释放内部控制器。 外部控制器由调用方释放，应只绑定一个筛选栏。 | 否 |
| items | List&lt;TDropdownMenuItem&gt; | - | 按顺序展示的筛选触发项和对应面板。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onClosed | TDropdownMenuClosedCallback? | - | 面板关闭流程完成后回调，携带筛选项下标和关闭原因。 | 否 |
| onOpened | ValueChanged&lt;int&gt;? | - | 面板打开动画完成后回调，参数为筛选项下标。 | 否 |
| placement | TDropdownMenuPlacement | TDropdownMenuPlacement.auto | 面板展开方向，默认 auto，根据上下可用空间决定。 | 否 |
| scrollable | bool | false | 筛选栏是否支持横向滚动，默认 false。 | 否 |
| showOverlay | bool | true | 是否绘制外部区域遮罩，默认 true。 | 否 |
| useRootOverlay | bool | false | 是否使用根 Overlay，默认 false。 | 否 |


### TDropdownMenuOption
#### 简介
下拉筛选面板中的不可变选项。

#### 声明

```dart
class TDropdownMenuOption<T>
```

#### 默认构造方法


```dart
const TDropdownMenuOption({
  required this.value,
  required this.label,
  this.disabled = false,
  this.group,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该选项，默认 false；禁用选项不能通过点击提交。 | 否 |
| group | String? | - | 多选面板中的分组标题；为空时归入无标题分组。 | 否 |
| label | String | - | 选项显示文案。 | 是 |
| value | T | - | 选项对应的业务值，用于选中判断和提交回调。 | 是 |


### TDropdownSingleSelectPanel
#### 简介
单选筛选面板。选择有效选项后立即提交并关闭。

#### 声明

```dart
class TDropdownSingleSelectPanel<T> extends StatelessWidget
```

#### 默认构造方法


```dart
const TDropdownSingleSelectPanel({
  super.key,
  required this.controller,
  required this.options,
  required this.value,
  required this.onChanged,
  this.maxHeight,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| controller | TDropdownMenuPanelController | - | 当前面板的局部控制器；选择后用它关闭面板。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxHeight | double? | - | 滚动主体的最大高度；默认 280dp。 | 否 |
| onChanged | ValueChanged&lt;T&gt; | - | 点击启用选项时提交其业务值，然后请求关闭面板；由使用方更新 `value`。 | 是 |
| options | List&lt;TDropdownMenuOption&lt;T&gt;&gt; | - | 按显示顺序排列的选项。 | 是 |
| value | T? | - | 受控选中值；为空时不主动指定选中项。 | 是 |


### TDropdownMultiSelectPanel
#### 简介
多选筛选面板。
`values` 表示已提交值，每次打开时用于初始化草稿。选项点击只更新面板内部草稿，
点击确认后才通过 `onConfirm` 提交。
打开期间 `values` 变化时，尚未修改的草稿会同步；已有修改的草稿保留用户编辑。
未确认即关闭会丢弃草稿，再次打开时使用最新的 `values`。

#### 声明

```dart
class TDropdownMultiSelectPanel<T> extends StatefulWidget
```

#### 默认构造方法


```dart
const TDropdownMultiSelectPanel({
  super.key,
  required this.controller,
  required this.options,
  required this.values,
  required this.onConfirm,
  this.columns = 1,
  this.maxHeight,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| columns | int | 1 | 每行选项列数，默认 1；支持 1 至 3 列。 | 否 |
| controller | TDropdownMenuPanelController | - | 当前面板的局部控制器，用于确认或取消时关闭面板。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxHeight | double? | - | 面板最大高度；默认滚动主体最多 280dp，底部操作区另计。 | 否 |
| onConfirm | ValueChanged&lt;Set&lt;T&gt;&gt; | - | 点击确认时提交草稿集合，再请求关闭面板；由使用方更新 `values`。 | 是 |
| options | List&lt;TDropdownMenuOption&lt;T&gt;&gt; | - | 可选择的选项；`TDropdownMenuOption.group` 决定显示分组。 | 是 |
| values | Set&lt;T&gt; | - | 已提交的受控值集合；打开时初始化草稿，未确认关闭不会提交草稿。 | 是 |


### TDropdownMenuTriggerState
#### 简介
自定义触发项可读取的不可变状态。

#### 声明

```dart
class TDropdownMenuTriggerState
```

#### 默认构造方法


```dart
const TDropdownMenuTriggerState({
  required this.index,
  required this.isOpen,
  required this.enabled,
  required this.toggle,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| enabled | bool | - | 当前触发项是否允许交互。 | 是 |
| index | int | - | 当前触发项在筛选栏中的下标。 | 是 |
| isOpen | bool | - | 当前触发项对应面板是否打开。 | 是 |
| toggle | VoidCallback | - | 切换当前面板开关状态的操作；禁用时不会打开面板。 | 是 |


### TDropdownMenuPanelController
#### 简介
当前面板可使用的局部控制器。

#### 声明

```dart
class TDropdownMenuPanelController
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| index | int | - | 当前面板所属筛选项的下标。 |


#### 实例方法

##### TDropdownMenuPanelController.close

```dart
Future<void> close([
  TDropdownMenuCloseReason reason = TDropdownMenuCloseReason.cancel,
])
```


请求关闭当前面板；`reason` 默认 cancel。返回的 Future 表示本次关闭请求处理结束。
## 返回值
当前关闭请求处理完毕时完成；被新操作打断时也可能提前完成，不保证面板已经关闭。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| reason | TDropdownMenuCloseReason | TDropdownMenuCloseReason.cancel | 关闭原因，默认 cancel。 | 否 |


### TDropdownMenuItem
#### 简介
一个筛选触发项及其对应面板。

#### 声明

```dart
class TDropdownMenuItem
```


#### 命名构造方法

##### TDropdownMenuItem.custom

```dart
const TDropdownMenuItem.custom({
  required this.triggerBuilder,
  required this.panelBuilder,
  this.enabled = true,
  this.flex = 1,
  this.width,
})
```


| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| triggerBuilder | TDropdownMenuTriggerBuilder? | - | 自定义触发项构建器；默认构造时为空。 | 是 |
| panelBuilder | TDropdownMenuPanelBuilder | - | 面板构建器，接收当前面板的局部控制器。 | 是 |
| enabled | bool | true | 是否启用触发项，默认 true。 | 否 |
| flex | int | 1 | 非滚动且父级宽度有界时的宽度分配权重，默认 1，必须大于 0。 | 否 |
| width | double? | - | 滚动模式或父级宽度无界时的触发项宽度，默认 112 逻辑像素； 非滚动且宽度有界时使用 `flex` 分配宽度，此字段不生效。 | 否 |

#### 默认构造方法


```dart
const TDropdownMenuItem({
  required this.label,
  required this.panelBuilder,
  this.enabled = true,
  this.flex = 1,
  this.width,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| enabled | bool | true | 是否启用触发项，默认 true。 | 否 |
| flex | int | 1 | 非滚动且父级宽度有界时的宽度分配权重，默认 1，必须大于 0。 | 否 |
| label | String? | - | 默认触发项文案；使用 custom 构造时为空。 | 是 |
| panelBuilder | TDropdownMenuPanelBuilder | - | 面板构建器，接收当前面板的局部控制器。 | 是 |
| width | double? | - | 滚动模式或父级宽度无界时的触发项宽度，默认 112 逻辑像素； 非滚动且宽度有界时使用 `flex` 分配宽度，此字段不生效。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| triggerBuilder | TDropdownMenuTriggerBuilder? | - | 自定义触发项构建器；默认构造时为空。 |


### TDropdownMenuController
#### 简介
类型安全的下拉筛选栏控制器。

#### 声明

```dart
class TDropdownMenuController extends ChangeNotifier
```

#### 默认构造方法


```dart
TDropdownMenuController()
```

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| isOpen | bool | - | 当前是否有打开的面板。 |
| openIndex | int? | - | 当前打开项的下标；没有打开的面板时为 null。 |


#### 实例方法

##### TDropdownMenuController.close

```dart
Future<void> close()
```


关闭当前面板；未绑定筛选栏时不执行操作。Future 等待本次关闭请求处理结束。
## 返回值
当前关闭请求处理完毕时完成；未绑定或被后续操作打断时也会完成，不代表面板一定已经关闭。

返回类型：`Future<void>`

##### TDropdownMenuController.open

```dart
Future<void> open(int index)
```


打开 `index` 对应面板；未绑定筛选栏时不执行操作。Future 等待本次打开请求处理结束。
## 返回值
当前打开请求处理完毕时完成；未绑定、索引无效、项目禁用或请求被打断时也会完成，不代表一定打开成功。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| index | int | - | 目标筛选项下标，从 0 开始。 | 是 |


##### TDropdownMenuController.toggle

```dart
Future<void> toggle(int index)
```


切换 `index` 对应面板；未绑定筛选栏时不执行操作。Future 等待本次切换请求处理结束。
## 返回值
当前切换请求处理完毕时完成；未绑定或请求无效、被打断时也会完成，不代表目标状态一定已达成。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| index | int | - | 目标筛选项下标，从 0 开始。 | 是 |


### TDropdownThemeData
#### 简介
DropdownMenu 的组件级视觉与布局默认值。
{@category ComponentTheme}

#### 声明

```dart
class TDropdownThemeData extends ThemeExtension<TDropdownThemeData>
```

#### 默认构造方法


```dart
const TDropdownThemeData({
  this.barHeight,
  this.barBackgroundColor,
  this.dividerColor,
  this.textStyle,
  this.activeTextStyle,
  this.disabledTextStyle,
  this.iconColor,
  this.activeIconColor,
  this.disabledIconColor,
  this.iconSize,
  this.panelBackgroundColor,
  this.overlayColor,
  this.optionHeight,
  this.optionPadding,
  this.optionTextStyle,
  this.selectedOptionTextStyle,
  this.disabledOptionTextStyle,
  this.optionColor,
  this.selectedOptionColor,
  this.disabledOptionColor,
  this.optionBorderRadius,
  this.actionAreaPadding,
  this.actionGap,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| actionAreaPadding | EdgeInsetsGeometry? | - | 多选面板底部操作区内边距。 | 否 |
| actionGap | double? | - | 多选面板底部按钮之间的间距；为空时读取全局 spacer2。 | 否 |
| activeIconColor | Color? | - | 打开面板的触发项箭头颜色。 | 否 |
| activeTextStyle | TextStyle? | - | 打开面板的触发项文本样式。 | 否 |
| barBackgroundColor | Color? | - | 筛选栏背景色；为空时读取全局 bgColorContainer。 | 否 |
| barHeight | double? | - | 筛选栏高度，默认 48 逻辑像素。 | 否 |
| disabledIconColor | Color? | - | 禁用触发项箭头颜色。 | 否 |
| disabledOptionColor | Color? | - | 多列选项禁用背景色。 | 否 |
| disabledOptionTextStyle | TextStyle? | - | 禁用选项文本样式。 | 否 |
| disabledTextStyle | TextStyle? | - | 禁用触发项文本样式。 | 否 |
| dividerColor | Color? | - | 筛选栏底部分隔线颜色；为空时读取全局 componentStroke。 | 否 |
| iconColor | Color? | - | 默认触发项箭头颜色。 | 否 |
| iconSize | double? | - | 触发项箭头尺寸，默认 24 逻辑像素。 | 否 |
| optionBorderRadius | BorderRadius? | - | 多列选项圆角；为空时读取全局 radiusDefault。 | 否 |
| optionColor | Color? | - | 多列选项默认背景色。 | 否 |
| optionHeight | double? | - | 单选列表行高度，默认 56 逻辑像素。 | 否 |
| optionPadding | EdgeInsetsGeometry? | - | 选项内边距；为空时使用全局 spacer2 水平间距。 | 否 |
| optionTextStyle | TextStyle? | - | 选项默认文本样式。 | 否 |
| overlayColor | Color? | - | 遮罩颜色，包含透明度。未指定时为黑色 60%，动画按展开进度缩放透明度。 | 否 |
| panelBackgroundColor | Color? | - | 面板背景色；为空时读取全局 bgColorContainer。 | 否 |
| selectedOptionColor | Color? | - | 多列选项选中背景色。 | 否 |
| selectedOptionTextStyle | TextStyle? | - | 选中选项文本样式。 | 否 |
| textStyle | TextStyle? | - | 默认触发项文本样式。 | 否 |


#### 实例方法

##### TDropdownThemeData.copyWith

```dart
TDropdownThemeData copyWith({
  double? barHeight,
  Color? barBackgroundColor,
  Color? dividerColor,
  TextStyle? textStyle,
  TextStyle? activeTextStyle,
  TextStyle? disabledTextStyle,
  Color? iconColor,
  Color? activeIconColor,
  Color? disabledIconColor,
  double? iconSize,
  Color? panelBackgroundColor,
  Color? overlayColor,
  double? optionHeight,
  EdgeInsetsGeometry? optionPadding,
  TextStyle? optionTextStyle,
  TextStyle? selectedOptionTextStyle,
  TextStyle? disabledOptionTextStyle,
  Color? optionColor,
  Color? selectedOptionColor,
  Color? disabledOptionColor,
  BorderRadius? optionBorderRadius,
  EdgeInsetsGeometry? actionAreaPadding,
  double? actionGap,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TDropdownThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| barHeight | double? | - | 筛选栏高度，默认 48 逻辑像素。 | 否 |
| barBackgroundColor | Color? | - | 筛选栏背景色；为空时读取全局 bgColorContainer。 | 否 |
| dividerColor | Color? | - | 筛选栏底部分隔线颜色；为空时读取全局 componentStroke。 | 否 |
| textStyle | TextStyle? | - | 默认触发项文本样式。 | 否 |
| activeTextStyle | TextStyle? | - | 打开面板的触发项文本样式。 | 否 |
| disabledTextStyle | TextStyle? | - | 禁用触发项文本样式。 | 否 |
| iconColor | Color? | - | 默认触发项箭头颜色。 | 否 |
| activeIconColor | Color? | - | 打开面板的触发项箭头颜色。 | 否 |
| disabledIconColor | Color? | - | 禁用触发项箭头颜色。 | 否 |
| iconSize | double? | - | 触发项箭头尺寸，默认 24 逻辑像素。 | 否 |
| panelBackgroundColor | Color? | - | 面板背景色；为空时读取全局 bgColorContainer。 | 否 |
| overlayColor | Color? | - | 遮罩颜色，包含透明度。未指定时为黑色 60%，动画按展开进度缩放透明度。 | 否 |
| optionHeight | double? | - | 单选列表行高度，默认 56 逻辑像素。 | 否 |
| optionPadding | EdgeInsetsGeometry? | - | 选项内边距；为空时使用全局 spacer2 水平间距。 | 否 |
| optionTextStyle | TextStyle? | - | 选项默认文本样式。 | 否 |
| selectedOptionTextStyle | TextStyle? | - | 选中选项文本样式。 | 否 |
| disabledOptionTextStyle | TextStyle? | - | 禁用选项文本样式。 | 否 |
| optionColor | Color? | - | 多列选项默认背景色。 | 否 |
| selectedOptionColor | Color? | - | 多列选项选中背景色。 | 否 |
| disabledOptionColor | Color? | - | 多列选项禁用背景色。 | 否 |
| optionBorderRadius | BorderRadius? | - | 多列选项圆角；为空时读取全局 radiusDefault。 | 否 |
| actionAreaPadding | EdgeInsetsGeometry? | - | 多选面板底部操作区内边距。 | 否 |
| actionGap | double? | - | 多选面板底部按钮之间的间距；为空时读取全局 spacer2。 | 否 |


##### TDropdownThemeData.lerp

```dart
TDropdownThemeData lerp(
  covariant ThemeExtension<TDropdownThemeData>? other,
  double t,
)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TDropdownThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TDropdownThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TDropdownThemeData.merge

```dart
TDropdownThemeData merge(TDropdownThemeData? other)
```


合并主题配置。
## 返回值
返回合并后的主题；`other` 的非空字段覆盖当前字段，other 为空时返回当前主题。

返回类型：`TDropdownThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TDropdownThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TDropdownMenuPlacement
#### 简介
下拉筛选面板相对筛选栏的展开位置。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| auto | 根据触发栏上下可用空间自动选择展开方向。 |
| below | 向触发栏下方展开。 |
| above | 向触发栏上方展开。 |


### TDropdownMenuCloseReason
#### 简介
下拉筛选面板关闭的原因。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| selection | 单选面板提交选项后关闭。 |
| confirm | 多选面板确认草稿后关闭。 |
| cancel | 面板取消操作或局部控制器默认关闭。 |
| overlay | 点击面板外部区域触发关闭。 |
| back | 返回键或路由返回操作触发关闭。 |
| trigger | 再次点击当前触发项关闭。 |
| controller | 全局控制器请求关闭。 |
| switchItem | 切换到其他筛选项时关闭原面板。 |


### TDropdownMenuClosedCallback
#### 简介
下拉筛选面板关闭回调。
`index` 关闭面板对应的筛选项索引，从 0 开始。
`reason` 本次面板关闭的原因。
## 返回值
无返回值。
#### 类型定义

```dart
typedef TDropdownMenuClosedCallback = void Function(int index, TDropdownMenuCloseReason reason);
```


### TDropdownMenuPanelBuilder
#### 简介
默认触发项的面板构建器。
`context` 筛选面板的构建上下文。
`controller` 当前面板控制器，用于请求关闭该面板。
## 返回值
当前筛选项的面板内容。
#### 类型定义

```dart
typedef TDropdownMenuPanelBuilder = Widget Function(BuildContext context, TDropdownMenuPanelController controller);
```


### TDropdownMenuTriggerBuilder
#### 简介
自定义触发项构建器。
`context` 筛选触发项的构建上下文。
`state` 当前触发项的状态及操作入口。
## 返回值
自定义筛选触发项内容。
#### 类型定义

```dart
typedef TDropdownMenuTriggerBuilder = Widget Function(BuildContext context, TDropdownMenuTriggerState state);
```
