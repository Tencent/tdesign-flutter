## API
### TSwipeCell
#### 简介
滑动单元格组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 要增强为可滑动单元格的内容。 |
| closeOnScroll | bool | true | 祖先滚动容器开始滚动时是否关闭面板，默认为 true。 |
| controller | TSwipeCellController? | - | 命令式控制器。 |
| enabled | bool | true | 是否允许用户拖动，默认为 true。 |
| end | TSwipeCellPanel? | - | 结束侧操作面板。 |
| initialOpenSide | TSwipeCellSide? | - | 首次布局后默认展开的面板；为空时保持关闭。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onOpenChanged | TSwipeCellChanged? | - | 面板展开状态变化回调。 |
| start | TSwipeCellPanel? | - | 起始侧操作面板。 |


### TSwipeCellController
#### 简介
`TSwipeCell` 的命令式控制器。
一个控制器同一时间只能绑定一个 `TSwipeCell`。通常无需使用控制器，用户拖动、
点击操作项、点击单元格外部或滚动列表时，组件会自行管理展开状态。

### TSwipeCellPanel
#### 简介
滑动单元格操作面板。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSwipeCellAction> | - | 操作项列表。面板宽度由所有操作项的实际布局宽度自动确定。 |


### TSwipeCellAction
#### 简介
滑动单元格操作项。
同一面板中的操作项可使用不同的颜色和文字样式。
未指定的图文视觉字段从标准 Flutter 主题或全局 Token 取得默认值；
`TSwipeCellThemeData` 只提供共用内边距。
`builder` 自行绘制操作项，不能同时传入内置背景、图文或图文样式字段。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 当前操作项背景颜色。 |
| builder | WidgetBuilder? | - | 自定义操作项。不可同时传入内置背景、图文或图文样式字段； 其实际布局宽度会直接用于面板宽度，无需额外指定尺寸。 |
| icon | IconData? | - | 图标。 |
| iconColor | Color? | - | 图标颜色。 |
| iconLabelSpacing | double? | - | 图标和标签之间的水平间距，默认 8。 |
| iconSize | double? | - | 图标大小，默认 20。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 操作文字。 |
| labelStyle | TextStyle? | - | 操作文字样式。 |
| onPressed | void Function(BuildContext context)? | - | 点击回调。回调后组件会自动关闭操作面板。 |


### TSwipeCellThemeData
#### 简介
TSwipeCell 组件级 ThemeExtension
通过 Theme 子树注入操作项共享内边距；逐项图文样式由操作项实例控制。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actionPadding | EdgeInsetsGeometry? | - | 操作项左右内边距。 |


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
