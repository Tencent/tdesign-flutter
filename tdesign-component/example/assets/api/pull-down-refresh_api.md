## API
### TDRefreshHeader
#### 简介
TDesign刷新头部
 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | Key |
| extent | double? | 48.0 | Header容器高度 |
| triggerOffset |  | - |  |
| triggerDistance | double | 48.0 | 触发刷新任务的偏移量，同[triggerOffset] |
| clamping |  | - |  |
| float | bool | false | 是否悬浮 |
| processedDuration |  | - |  |
| completeDuration | Duration? | - | 完成延时 |
| hapticFeedback |  | - |  |
| enableHapticFeedback | bool | true | 开启震动反馈 |
| infiniteOffset | double? | - | 无限刷新偏移量 |
| enableInfiniteRefresh | bool | false | 是否开启无限刷新 |
| infiniteHitOver |  | - |  |
| overScroll | bool | true | 越界滚动([enableInfiniteRefresh]为true或[infiniteOffset]有值时生效) |
| loadingIcon | TDLoadingIcon | TDLoadingIcon.circle | loading样式 |
| backgroundColor | Color? | - | 背景颜色 |
| spring |  | - |  |
| horizontalSpring |  | - |  |
| readySpringBuilder |  | - |  |
| horizontalReadySpringBuilder |  | - |  |
| springRebound |  | - |  |
| frictionFactor |  | - |  |
| horizontalFrictionFactor |  | - |  |
| safeArea |  | false |  |
| hitOver |  | - |  |
| position |  | - |  |
| secondaryTriggerOffset |  | - |  |
| secondaryVelocity |  | - |  |
| secondaryDimension |  | - |  |
| secondaryCloseTriggerOffset |  | - |  |
| notifyWhenInvisible |  | - |  |
| listenable |  | - |  |
| triggerWhenReach |  | - |  |
| triggerWhenRelease |  | - |  |
| triggerWhenReleaseNoWait |  | - |  |
| maxOverOffset |  | - |  |
