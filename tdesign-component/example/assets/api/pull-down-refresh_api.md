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
| enableHapticFeedback | bool | true | 是否启用震动反馈。 |
| extent | double? | - | Header 容器高度。 |
| float | bool? | - | 是否悬浮展示刷新头。 |
| hapticFeedback | bool? | - | 是否启用震动反馈；为空时使用 `enableHapticFeedback`。 |
| key | Key? | - | Key |
| loadingIcon | TLoadingIcon? | - | 自定义 loading 图标样式。 |
| overScroll | bool? | - | 是否允许越界滚动。 |
| position | IndicatorPosition | IndicatorPosition.above | 刷新头位置。 |
| processedDuration | Duration? | - | 刷新完成后的处理动画时长。 |
| triggerDistance | double? | - | 触发刷新任务的偏移量。 |

> 说明：TDesign 层仅暴露视觉参数与最常用行为参数；高级能力（弹簧配置、二楼、无限刷新、triggerWhen* 等）请直接使用 `easy_refresh` 原生 `Header`。


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
