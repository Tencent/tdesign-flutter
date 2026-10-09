## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSwipeCell
#### 简介
滑动单元格组件。

#### 声明

```dart
class TSwipeCell extends StatefulWidget
```

#### 默认构造方法


```dart
const TSwipeCell({
  Key? key,
  required this.child,
  this.enabled = true,
  this.start,
  this.end,
  this.onOpenChanged,
  this.controller,
  this.initialOpenSide,
  this.closeOnScroll = true,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 要增强为可滑动单元格的内容。 | 是 |
| closeOnScroll | bool | true | 祖先滚动容器开始滚动时是否关闭面板，默认为 true。 | 否 |
| controller | TSwipeCellController? | - | 命令式控制器。 | 否 |
| enabled | bool | true | 是否允许用户拖动，默认为 true。 | 否 |
| end | TSwipeCellPanel? | - | 结束侧操作面板。 | 否 |
| initialOpenSide | TSwipeCellSide? | - | 首次布局后默认展开的面板；为空时保持关闭。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onOpenChanged | TSwipeCellChanged? | - | 面板展开状态变化回调。 | 否 |
| start | TSwipeCellPanel? | - | 起始侧操作面板。 | 否 |


### TSwipeCellController
#### 简介
`TSwipeCell` 的命令式控制器。
一个控制器同一时间只能绑定一个 `TSwipeCell`。通常无需使用控制器，用户拖动、
点击操作项、点击单元格外部或滚动列表时，组件会自行管理展开状态。

#### 声明

```dart
class TSwipeCellController
```

#### 默认构造方法


```dart
TSwipeCellController()
```


#### 实例方法

##### TSwipeCellController.close

```dart
Future<void> close()
```


关闭当前展开的操作面板。

返回类型：`Future<void>`

##### TSwipeCellController.open

```dart
Future<void> open(TSwipeCellSide side)
```


展开指定侧的操作面板。

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| side | TSwipeCellSide | - | - | 是 |


### TSwipeCellPanel
#### 简介
滑动单元格操作面板。

#### 声明

```dart
class TSwipeCellPanel
```

#### 默认构造方法


```dart
TSwipeCellPanel({required this.children})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| children | List&lt;TSwipeCellAction&gt; | - | 操作项列表。面板宽度由所有操作项的实际布局宽度自动确定。 | 是 |


#### 实例方法

##### TSwipeCellPanel.build

```dart
Widget build(BuildContext context)
```


返回类型：`Widget`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |


### TSwipeCellAction
#### 简介
滑动单元格操作项。
同一面板中的操作项可使用不同的颜色和文字样式。
未指定的图文视觉字段从全局 TDesign Token 取得默认值；
`TSwipeCellThemeData` 只提供共用内边距。
`builder` 自行绘制操作项，不能同时传入内置背景、图文或图文样式字段。

#### 声明

```dart
class TSwipeCellAction extends StatelessWidget
```

#### 默认构造方法


```dart
const TSwipeCellAction({
  Key? key,
  this.backgroundColor,
  this.onPressed,
  this.icon,
  this.iconColor,
  this.iconSize,
  this.iconLabelSpacing,
  this.label,
  this.labelStyle,
  this.builder,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 当前操作项背景颜色。 | 否 |
| builder | WidgetBuilder? | - | 自定义操作项。不可同时传入内置背景、图文或图文样式字段； 冲突配置会在构建时抛出 `FlutterError`，包括 release 构建。 其实际布局宽度会直接用于面板宽度，无需额外指定尺寸。 `onPressed` 仍负责点击回调，随后会自动关闭操作面板。 | 否 |
| icon | IconData? | - | 图标。 | 否 |
| iconColor | Color? | - | 图标颜色。 | 否 |
| iconLabelSpacing | double? | - | 图标和标签之间的水平间距，默认 8。 | 否 |
| iconSize | double? | - | 图标大小，默认 20。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| label | String? | - | 操作文字。 | 否 |
| labelStyle | TextStyle? | - | 操作文字样式。 | 否 |
| onPressed | void Function(BuildContext context)? | - | 点击回调。回调后组件会自动关闭操作面板。 | 否 |


### TSwipeCellThemeData
#### 简介
TSwipeCell 组件级 ThemeExtension
通过 Theme 子树注入操作项共享内边距；逐项图文样式由操作项实例控制。

#### 声明

```dart
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData>
```

#### 默认构造方法


```dart
const TSwipeCellThemeData({this.actionPadding})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| actionPadding | EdgeInsetsGeometry? | - | 操作项左右内边距。 | 否 |


#### 实例方法

##### TSwipeCellThemeData.copyWith

```dart
TSwipeCellThemeData copyWith({EdgeInsetsGeometry? actionPadding})
```


返回类型：`TSwipeCellThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| actionPadding | EdgeInsetsGeometry? | - | 操作项左右内边距。 | 否 |


##### TSwipeCellThemeData.lerp

```dart
TSwipeCellThemeData lerp(
  ThemeExtension<TSwipeCellThemeData>? other,
  double t,
)
```


返回类型：`TSwipeCellThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSwipeCellThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


##### TSwipeCellThemeData.merge

```dart
TSwipeCellThemeData merge(TSwipeCellThemeData? other)
```


合并两个 ThemeExtension，`other` 优先于 this

返回类型：`TSwipeCellThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TSwipeCellThemeData? | - | - | 是 |


### TSwipeCellSide
#### 简介
操作面板所在侧。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| start | - |
| end | - |


### TSwipeCellChanged
#### 简介
滑动展开状态变化回调。
#### 类型定义

```dart
typedef TSwipeCellChanged = void Function(TSwipeCellSide side, bool isOpen);
```
