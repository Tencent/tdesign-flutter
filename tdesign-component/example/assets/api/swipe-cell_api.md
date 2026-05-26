## API
### TSwipeCell
#### 简介
滑动单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cell | Widget | - | 单元格 [TCell] |
| closeWhenOpened | bool? | true | 当同一组（[groupTag]）中的一个[TSwipeCell]打开时，是否关闭组中的所有其他[TSwipeCell] |
| closeWhenTapped | bool? | true | 当同一组（[groupTag]）中的一个[TSwipeCell]被点击时，是否应该关闭组中的所有[TSwipeCell] [cell]组件被点击时必须传递点击事件，执行`TSwipeCellInherited.of(context)?.cellClick()` |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| disabled | bool? | false | 是否禁用滑动 |
| dragStartBehavior | DragStartBehavior? | DragStartBehavior.start | 处理拖动开始行为的方式[GestureDetector.dragStartBehavior] |
| duration | Duration? | const Duration(milliseconds: 200) | 打开关闭动画时长 |
| groupTag | Object? | - | 组，配置后，[closeWhenOpened]、[closeWhenTapped]才起作用 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| left | TSwipeCellPanel? | - | 左侧滑动操作项面板 |
| onChange | Function(TSwipeDirection direction, bool open)? | - | 滑动展开事件 |
| opened | List<bool>? | const [false, false] | 默认打开，[left, right] |
| right | TSwipeCellPanel? | - | 右侧滑动操作项面板 |
| slidableKey | Key? | - | 滑动组件的 Key |


#### 静态方法

##### TSwipeCell.close

根据[groupTag]关闭[TSwipeCell]

 current：保留当前不关闭

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| tag | Object? | - | - |
| current | SlidableController? | - | - |


##### TSwipeCell.of

获取上下文最近的[controller]

返回类型：`SlidableController?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |


### TSwipeDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| right | - |
| left | - |
