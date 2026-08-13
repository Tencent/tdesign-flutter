## API
### TSwipeCell
#### 简介
滑动单元格组件

#### 静态方法

##### TSwipeCell.close

根据groupTag关闭`TSwipeCell`

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tag | Object? | - | 要关闭的互斥滑动组标识。 |
| current | SlidableController? | - | 保留不关闭的当前控制器。 |


##### TSwipeCell.of

获取上下文最近的`controller`

返回类型：`SlidableController?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找最近 `SlidableController` 的上下文。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 要增强为可滑动单元格的内容。 |
| closeOnScroll | bool | true | 祖先滚动容器开始滚动时是否关闭已展开的操作区。 注意：当配合 `initialOpenSide` 初始展开面板时，若本值为 true， 面板会在首次滚动发生时即被关闭（语义偏"粘滞"），请按需调整。 |
| closeWhenOpened | bool | false | 展开时是否关闭同组其他单元格 |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| direction | Axis | Axis.horizontal | 可拖动的方向 |
| dragStartBehavior | DragStartBehavior | DragStartBehavior.start | 拖动开始行为 |
| enabled | bool | true | 是否启用滑动（默认 true，false 表示禁用） |
| end | TSwipeCellPanel? | - | 结束侧滑动操作项面板。 |
| groupTag | Object? | - | 互斥滑动组标识 相同 `groupTag` 的 `TSwipeCell` 会互相影响（配合 `closeWhenOpened` 实现互斥关闭）。 **注意：需全局唯一**。不同类型 / 场景的互斥组请使用不同的标识， 避免传入 `==` 相同的值（如相同的字符串）导致意外串组。 |
| initialOpenSide | TSwipeCellSide? | - | 初始展开的面板；为空时保持关闭。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onOpenChanged | TSwipeCellChanged? | - | 滑动展开事件 |
| start | TSwipeCellPanel? | - | 起始侧滑动操作项面板。 |


### TSwipeCellPanel
#### 简介
滑动单元格操作面板组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TSwipeCellAction> | - | 操作组件列表 |
| closeOnCancel | bool | false | 移除取消后，是否关闭滑动单元格。dragDismissible为true才有效 |
| closeThreshold | double? | - | 拖动多少占比触发关闭动作，默认 `extentRatio` 的一半 |
| confirmDismiss | Future<bool> Function(BuildContext context)? | - | 移除前回调，可阻止移除。dragDismissible为true才有效 |
| confirms | List<TSwipeCellAction>? | - | 二次确认操作组件列表 通过 `TSwipeCellAction.confirmIndex` 与 `children` 中的索引关联。 点击 `children` 中某操作项后，若命中某个 confirm 的索引则展示二次确认。 **点击的 action 需与 `children` 中为同一实例**； 若使用 `copyWith` 等重建等价实例，请为两者设置相同的 `TSwipeCellAction.id`，按标识而非引用匹配。 |
| dismissalDuration | Duration | const Duration(milliseconds: 300) | 触发移除的滑动动画时长。dragDismissible为true才有效 |
| dismissThreshold | double | 0.75 | 滑动到多少比例时，触发移除。dragDismissible为true才有效 |
| dragDismissible | bool | false | 是否可通过拖动操作来移除 `TSwipeCell` 组件 |
| extentRatio | double | 0.3 | 宽度占比 |
| motionType | SwipeMotion? | - | 滑动动画展示方式 |
| onDismissed | void Function(BuildContext context)? | - | 移除后回调。dragDismissible为true才有效 |
| openThreshold | double? | - | 拖动多少占比触发打开动作，默认 `extentRatio` 的一半 |
| resizeDuration | Duration | const Duration(milliseconds: 300) | 移除动画（高度变为0）时长。dragDismissible为true才有效 |


### TSwipeCellAction
#### 简介
滑动单元格操作按钮
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoClose | bool | true | 点击后自动关闭 |
| backgroundColor | Color? | - | 背景颜色；为 null 时回退到组件级主题 `TSwipeCellThemeData.actionBackgroundColor`。 |
| builder | WidgetBuilder? | - | 自定义构建 |
| confirmIndex | List<int>? | - | 指定`TSwipeCellPanel.children`的索引，来打开该`TSwipeCellAction` `TSwipeCellPanel.confirms`参数下才配置该参数 |
| direction | Axis | Axis.horizontal | 图标和标题的排列方向 |
| flex | int | 1 | 宽度占比，默认为 1，`TSwipeCellPanel.confirms`下无效（失踪占满整个`TSwipeCellPanel`宽度） |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色；为 null 时依次回退到组件级主题 `TSwipeCellThemeData.actionIconColor`、label 字体颜色、P4 Token。 |
| iconSize | double? | - | 图标大小，默认 18；为 null 时回退到组件级主题 `TSwipeCellThemeData.actionIconSize`， 再回退到内置默认值。 |
| id | String? | - | 稳定标识，用于二次确认匹配。 二次确认通过 `TSwipeCellPanel.confirms` 的 `confirmIndex` 与 `TSwipeCellPanel.children` 的索引关联。默认依赖点击的 action 与 children 为同一实例（`==` 匹配）； 若通过 `copyWith` 等重建了等价实例，请为两者设置相同的 `id`， 以按标识而非实例引用匹配。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标题 |
| labelStyle | TextStyle? | - | 标题样式；为 null 时回退到组件级主题 `TSwipeCellThemeData.actionTextStyle`。 |
| onPressed | void Function(BuildContext context)? | - | 点击回调 |
| spacing | double? | - | 图标和标题的间距，默认 2；为 null 时回退到组件级主题 `TSwipeCellThemeData.actionSpacing`， 再回退到内置默认值。 |


### TSwipeCellSide
#### 简介
操作面板所在侧。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| start | - |
| end | - |


### SwipeMotion
#### 简介
滑动动画展示方式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| scroll | 滚动 |
| behind | 揭开 |
| drawer | 抽屉 |
| stretch | 拉伸 |


### TSwipeCellChanged
#### 简介
滑动展开状态变化回调
#### 类型定义

```dart
typedef TSwipeCellChanged = void Function(TSwipeCellSide side, bool isOpen);
```
