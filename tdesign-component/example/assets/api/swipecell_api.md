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
| opened | List<bool>? | const [false, false] | 默认打开，[left, right] |
| right | TDSwipeCellPanel? | - | 右侧滑动操作项面板 |
| left | TDSwipeCellPanel? | - | 左侧滑动操作项面板 |
| onChange |  Function(TDSwipeDirection direction, bool open)? | - | 滑动展开事件 |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| groupTag | Object? | - | 组，配置后，[closeWhenOpened]、[closeWhenTapped]才起作用 |
| closeWhenOpened | bool? | true | 当同一组（[groupTag]）中的一个[TDSwipeCell]打开时，是否关闭组中的所有其他[TDSwipeCell] |
| closeWhenTapped | bool? | true | 当同一组（[groupTag]）中的一个[TDSwipeCell]被点击时，是否应该关闭组中的所有[TDSwipeCell] |
| dragStartBehavior | DragStartBehavior? | DragStartBehavior.start | 处理拖动开始行为的方式[GestureDetector.dragStartBehavior] |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| duration | Duration? | const Duration(milliseconds: 200) | 打开关闭动画时长 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| close |  |   required Object? tag,  SlidableController? current, | 根据[groupTag]关闭[TDSwipeCell]      current：保留当前不关闭 |
| of |  |   required BuildContext context, | 获取上下文最近的[controller] |
