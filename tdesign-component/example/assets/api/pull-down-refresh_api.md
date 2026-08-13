## API
### TRefreshHeader
#### 简介
TDesign刷新头部
结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | Header 背景颜色。 |
| completeDuration | Duration? | - | 完成状态停留时长。 |
| enableHapticFeedback | bool | true | 是否启用震动反馈；默认开启。 与 `hapticFeedback` 的区别：本参数是构造后的公开字段（可直接读取）， 而 `hapticFeedback` 仅作为构造入参，为空时回退到本字段。 |
| extent | double? | - | Header 容器高度。 |
| float | bool? | - | 是否悬浮展示刷新头。 |
| hapticFeedback | bool? | - | 是否启用震动反馈；为空时使用 `enableHapticFeedback`。 |
| key | Key? | - | 刷新头容器使用的 Key，可用于在子树中定位该组件。 |
| loadingIcon | TLoadingIcon? | - | 自定义 loading 图标样式。 |
| overScroll | bool? | - | 是否允许越界滚动。 |
| position | IndicatorPosition | IndicatorPosition.above | 刷新头位置：位于内容上方（`IndicatorPosition.above`）或下方 （`IndicatorPosition.below`），默认在内容上方。 |
| processedDuration | Duration? | Duration.zero | 刷新完成后的处理动画时长。默认 `Duration.zero`，刷新任务一完成即可再次下拉刷新；如需完成动画停留，请显式传入时长。 |
| triggerDistance | double? | - | 触发刷新任务的偏移量。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| finalBackgroundColor | Color? | - | 背景颜色 |
| finalCompleteDuration | Duration? | - | 完成延时 |
| finalExtent | double | - | Header 容器高度 |
| finalFloat | bool | - | 是否悬浮 |
| finalLoadingIcon | TLoadingIcon? | - | loading 样式 |
| finalOverScroll | bool | - | 越界滚动 |
| finalTriggerDistance | double | - | 触发刷新任务的偏移量 |
