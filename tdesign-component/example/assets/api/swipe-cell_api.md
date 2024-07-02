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
| right | TDSwipeCellPanel? | - | 右侧滑动操作项面板 |
| left | TDSwipeCellPanel? | - | 左侧滑动操作项面板 |
| onChange |  Function(TDSwipeDirection direction, bool open)? | - | 滑动展开事件 |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| groupTag | Object? | - | 同一组中只有一个被打开，[TDSwipeCell]必须为[TDSwipeCellClose]的后代组件才有效 |
| closeOnScroll | bool? | true | 滚动时，是否关闭滑动操作项面板 |
| dragStartBehavior | DragStartBehavior? | DragStartBehavior.start | 处理拖动开始行为的方式[GestureDetector.dragStartBehavior] |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| duration | Duration? | const Duration(milliseconds: 200) | 打开关闭动画时长 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| of |  |   required BuildContext context, |  |
