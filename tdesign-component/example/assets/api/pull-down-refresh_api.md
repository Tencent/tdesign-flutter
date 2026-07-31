## API
### TRefreshHeader
#### 简介
TDesign刷新头部
结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | Header 背景颜色。 |
| clamping | bool? | - | 是否启用越界钳制。 |
| completeDuration | Duration? | - | 完成状态停留时长。 |
| enableHapticFeedback | bool | true | 是否启用震动反馈。 |
| enableInfiniteRefresh | bool | false | 是否启用无限刷新。 |
| extent | double? | - | Header 容器高度。 |
| float | bool? | - | 是否悬浮展示刷新头。 |
| frictionFactor | FrictionFactor? | - | 越界滚动摩擦系数。 |
| hapticFeedback | bool? | - | 是否启用震动反馈；为空时使用 `enableHapticFeedback`。 |
| hitOver | bool? | - | 滚动自身到达边界时是否判定越界。 |
| horizontalFrictionFactor | FrictionFactor? | - | 横向越界滚动摩擦系数。 |
| horizontalReadySpringBuilder | SpringBuilder? | - | 横向 ready 状态的弹簧构建器。 |
| horizontalSpring | physics.SpringDescription? | - | 横向回弹弹簧配置。 |
| infiniteHitOver | bool? | - | 无限刷新是否允许越界命中。 |
| infiniteOffset | double? | - | 无限刷新触发偏移量。 |
| key | Key? | - | Key |
| listenable | IndicatorStateListenable? | - | 指示器状态监听器。 |
| loadingIcon | TLoadingIcon? | - | 自定义 loading 图标样式。 |
| maxOverOffset | double | double.infinity | 最大越界滚动距离。 |
| notifyWhenInvisible | bool | false | 不可见时是否仍发送通知。 |
| overScroll | bool? | - | 是否允许越界滚动。 |
| position | IndicatorPosition | IndicatorPosition.above | 刷新头位置。 |
| processedDuration | Duration? | - | 刷新完成后的处理动画时长。 |
| readySpringBuilder | SpringBuilder? | - | ready 状态的弹簧构建器。 |
| safeArea | bool | false | 是否计算安全区。 |
| secondaryCloseTriggerOffset | double | kDefaultSecondaryCloseTriggerOffset | 二楼关闭触发偏移量。 |
| secondaryDimension | double? | - | 二楼尺寸。 |
| secondaryTriggerOffset | double? | - | 二楼触发偏移量。 |
| secondaryVelocity | double | kDefaultSecondaryVelocity | 二楼打开速度。 |
| spring | physics.SpringDescription? | - | 回弹弹簧配置。 |
| springRebound | bool | true | 弹簧是否允许回弹。 |
| triggerDistance | double? | - | 触发刷新任务的偏移量。 |
| triggerWhenReach | bool | false | 到达触发距离时是否立即触发。 |
| triggerWhenRelease | bool | false | 释放时是否立即触发。 |
| triggerWhenReleaseNoWait | bool | false | 释放时是否立即触发且不等待任务完成。 |

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
