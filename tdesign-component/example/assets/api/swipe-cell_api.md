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
| cell | Widget | - | 单元格 `TCell` |
| closeWhenOpened | bool | false | 展开时是否关闭同组其他单元格 |
| closeWhenTapped | bool | false | 点击单元格时是否关闭同组单元格 |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| dragStartBehavior | DragStartBehavior | DragStartBehavior.start | 拖动开始行为 |
| enabled | bool | true | 是否启用滑动（默认 true，false 表示禁用） |
| groupTag | Object? | - | 互斥滑动组标识 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | TSwipeCellPanel? | - | 左侧滑动操作项面板 |
| onChanged | TSwipeCellChanged? | - | 滑动展开事件 |
| opened | List<bool> | const <bool>[false, false] | 初始展开状态，依次表示左侧和右侧面板 |
| right | TSwipeCellPanel? | - | 右侧滑动操作项面板 |
| slidableKey | Key? | - | 底层滑动组件的 Key |


### TSwipeDirection
#### 简介
滑动方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| right | - |
| left | - |


### TSwipeCellChanged
#### 简介
滑动展开状态变化回调
#### 类型定义

```dart
typedef TSwipeCellChanged = void Function(TSwipeDirection direction, bool open);
```
