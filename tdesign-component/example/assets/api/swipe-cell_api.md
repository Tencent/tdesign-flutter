## API

### TSwipeCell

滑动单元格组件。

#### 构造方法

##### TSwipeCell

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 要增强为可滑动单元格的内容。 | 是 |
| closeOnScroll | bool | true | 祖先滚动容器开始滚动时是否关闭面板，默认为 true。 | 否 |
| controller | TSwipeCellController? | - | 命令式控制器。 | 否 |
| enabled | bool | true | 是否允许用户拖动，默认为 true。 仅控制用户拖动，不阻止控制器命令。 | 否 |
| end | TSwipeCellPanel? | - | 结束侧操作面板。 | 否 |
| initialOpenSide | TSwipeCellSide? | - | 首次布局后默认展开的面板；为空时保持关闭。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onOpenChanged | TSwipeCellChanged? | - | 面板展开状态变化回调。 在展开状态改变时通知，早于动画结束；切换侧时先通知旧侧关闭，再通知新侧打开。 | 否 |
| start | TSwipeCellPanel? | - | 起始侧操作面板。 | 否 |


### TSwipeCellController

`TSwipeCell` 的命令式控制器。

一个控制器同一时间只能绑定一个 `TSwipeCell`。通常无需使用控制器，用户拖动、
点击操作项、点击单元格外部或滚动列表时，组件会自行管理展开状态。

#### 构造方法

##### TSwipeCellController

无参数。

#### 实例方法

##### TSwipeCellController.close

无参数。

关闭当前展开的操作面板。
返回的 Future 在动画结束后完成；未绑定组件时立即完成且不执行操作。

###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | 关闭请求的动画结束时完成；未绑定组件时立即完成且不执行操作。 | - |


##### TSwipeCellController.open

位置参数：`side`


展开指定侧的操作面板。
返回的 Future 在动画结束后完成；未绑定组件时立即完成且不执行操作。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| side | TSwipeCellSide | - | 需要展开的操作面板侧；该侧没有面板时关闭当前面板。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;void&gt; | - | 展开请求的动画结束时完成；未绑定组件时立即完成且不执行操作。 | - |


### TSwipeCellPanel

滑动单元格操作面板。

#### 构造方法

##### TSwipeCellPanel

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;TSwipeCellAction&gt; | - | 操作项列表。面板宽度由所有操作项的实际布局宽度自动确定。 列表必须非空。 | 是 |


#### 实例方法

##### TSwipeCellPanel.build

位置参数：`context`


构建操作项的横向布局，宽度由 `children` 的实际布局宽度决定。

操作项沿交叉轴拉伸；返回的布局由调用方放入滑动单元格。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 调用方的构建上下文；当前布局不读取其中的主题或尺寸。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 由 children 横向排列、沿交叉轴拉伸的操作面板布局。 | - |


### TSwipeCellAction

滑动单元格操作项。

同一面板中的操作项可使用不同的颜色和文字样式。
未指定的图文视觉字段从全局 TDesign Token 取得默认值；
`TSwipeCellThemeData` 只提供共用内边距。
`builder` 自行绘制操作项，不能同时传入内置背景、图文或图文样式字段。

#### 构造方法

##### TSwipeCellAction

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

TSwipeCell 组件级 ThemeExtension

通过 Theme 子树注入操作项共享内边距；逐项图文样式由操作项实例控制。

#### 构造方法

##### TSwipeCellThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| actionPadding | EdgeInsetsGeometry? | - | 操作项左右内边距。 | 否 |


#### 实例方法

##### TSwipeCellThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| actionPadding | EdgeInsetsGeometry? | - | 字段含义：操作项左右内边距。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwipeCellThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TSwipeCellThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSwipeCellThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwipeCellThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


##### TSwipeCellThemeData.merge

位置参数：`other`


合并主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TSwipeCellThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSwipeCellThemeData | - | other 的非空字段优先的合并主题；other 为 null 时返回当前主题。 | - |


### TSwipeCellSide

操作面板所在侧。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| start | TSwipeCellSide | - | 沿当前文字方向的起始侧；LTR 为左侧，RTL 为右侧。 | - |
| end | TSwipeCellSide | - | 沿当前文字方向的结束侧；LTR 为右侧，RTL 为左侧。 | - |


### TSwipeCellChanged

滑动展开状态变化回调。

位置参数：`side, isOpen`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| side | TSwipeCellSide | - | 发生变化的操作面板侧。 | 是 |
| isOpen | bool | - | 该侧面板是否展开。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | 无返回值。 | - |
