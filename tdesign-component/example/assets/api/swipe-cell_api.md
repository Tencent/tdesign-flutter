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
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色；为空时回退到 `TSwipeCellThemeData.actionBackgroundColor`。 |
| builder | WidgetBuilder? | - | 自定义操作项。其实际布局宽度会直接用于面板宽度，无需额外指定尺寸。 |
| icon | IconData? | - | 图标。 |
| iconColor | Color? | - | 图标颜色。 |
| iconSize | double? | - | 图标大小，默认 20。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 操作文字。 |
| labelStyle | TextStyle? | - | 操作文字样式。 |
| onPressed | void Function(BuildContext context)? | - | 点击回调。回调后组件会自动关闭操作面板。 |
| spacing | double? | - | 图标和文字的水平间距，默认 8。 |


### TSwipeCellThemeData
#### 简介
TSwipeCell 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认滑动单元格样式。
遵循多层级主题控制方案：P0 实例参数 > P1 组件 Theme > P4 Token。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actionBackgroundColor | Color? | - | 操作项默认背景色。 |
| actionIconColor | Color? | - | 操作项图标默认色。 |
| actionIconSize | double? | - | 操作项图标默认尺寸。 |
| actionPadding | EdgeInsetsGeometry? | - | 操作项左右内边距。 |
| actionSpacing | double? | - | 操作项图标与文字默认间距。 |
| actionTextStyle | TextStyle? | - | 操作项文字默认样式。 |


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
