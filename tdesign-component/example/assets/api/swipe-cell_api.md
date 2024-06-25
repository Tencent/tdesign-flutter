## API
### TDSwipeCell
#### 简介
滑动单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| slidableKey | Key? | - | 滑动组件的 Key |
| cell | Widget | - | 单元格 [TDCell] |
| disabled | bool? | false | 是否禁用滑动 |
| opened | List<bool>? | const [false, false] | 默认打开，[left, rigth] |
| right | TDSwipePanel? | - | 右侧滑动操作项面板 |
| left | TDSwipePanel? | - | 左侧滑动操作项面板 |
| onChange |  Function(TDSwipeDirection direction, bool open)? | - | 滑动展开事件 |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| groupTag | Object? | - | 同一组中只有一个被打开 |
| closeOnScroll | bool? | true | 滚动时，是否关闭滑动操作项面板 |
| dragStartBehavior | DragStartBehavior? | DragStartBehavior.start | 处理拖动开始行为的方式[GestureDetector.dragStartBehavior] |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |

```
```
 ### TDSwipePanel
#### 简介
滑动单元格操作面板组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| extentRatio | double? | 0.3 | 宽度占比 |
| openThreshold | double? | - | 拖动多少占比触发打开动作，默认 [extentRatio] 的一半 |
| closeThreshold | double? | - | 拖动多少占比触发关闭动作，默认 [extentRatio] 的一半 |
| motionType | SwipeMotion? | - | 滑动动画展示方式 |
| dragDismissible | bool? | false | 是否可通过拖动操作来移除 [TDSwipeCell] 组件 |
| dismissThreshold | double? | 0.75 | 滑动到多少比例时，触发移除。dragDismissible为true才有效 |
| dismissalDuration | Duration? | const Duration(milliseconds: 300) | 触发移除的滑动动画时长。dragDismissible为true才有效 |
| resizeDuration | Duration? | const Duration(milliseconds: 300) | 移除动画（高度变为0）时长。dragDismissible为true才有效 |
| closeOnCancel | bool? | false | 移除取消后，是否关闭滑动单元格。dragDismissible为true才有效 |
| confirmDismiss | dismissible_pane.ConfirmDismissCallback? | - | 移除前回调，可阻止移除。dragDismissible为true才有效 |
| onDismissed | VoidCallback? | - | 移除后回调。dragDismissible为true才有效 |
| children | List<TDSwipeAction> | - | 操作组件列表 |
| confirms | List<TDSwipeAction>? | - | 二次确认操作组件列表 |

```
```
 ### TDSwipeAction
#### 简介
滑动单元格操作按钮
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| flex | int? | 1 | 宽度占比，默认为 1 |
| backgroundColor | Color? | - | 背景颜色 |
| autoClose | bool? | true | 点击后自动关闭 |
| onPressed | VoidCallback? | - | 点击回调 |
| icon | IconData? | - | 图标 |
| iconColor | Color? | - | 图标颜色，默认label字体颜色 |
| iconSize | double? | 18 | 图标大小 |
| spacing | double? | 2 | 图标和标题的间距 |
| label | String? | - | 标题 |
| labelStyle | TextStyle? | - | 标题样式 |
| direction | Axis? | Axis.horizontal | 图标和标题的排列方向 |
| confirmIndex | List<int>? | - | 指定[TDSwipePanel.children]的索引，来打开该[TDSwipeAction] |
| builder | WidgetBuilder? | - | 自定义构建 |

```
```
 ### TDSwipeAutoClose
#### 简介
滑动单元格自动关闭组件，需要[TDSwipeCell]组件配置相同的[TDSwipeCell.groupTag]
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| closeWhenOpened | bool? | true | 打开[TDSwipeCell]前是否自动关闭其它 |
| closeWhenTapped | bool? | true | 点击[TDSwipeAutoClose]组件时，关闭全部[TDSwipeCell] |
| child | Widget | - | 其后代必须有[TDSwipeCell] |
