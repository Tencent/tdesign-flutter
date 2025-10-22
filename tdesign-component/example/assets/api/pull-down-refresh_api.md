## API
### TDRefreshHeader
#### 简介
TDesign刷新头部
 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| clamping |  | - |  |
| completeDuration | Duration? | - | 完成延时 |
| enableHapticFeedback | bool | true | 开启震动反馈 |
| enableInfiniteRefresh | bool | false | 是否开启无限刷新 |
| extent | double? | 48.0 | Header容器高度 |
| float | bool | false | 是否悬浮 |
| frictionFactor |  | - |  |
| hapticFeedback |  | - |  |
| hitOver |  | - |  |
| horizontalFrictionFactor |  | - |  |
| horizontalReadySpringBuilder |  | - |  |
| horizontalSpring |  | - |  |
| infiniteHitOver |  | - |  |
| infiniteOffset | double? | - | 无限刷新偏移量 |
| key | Key? | - | Key |
| listenable |  | - |  |
| loadingIcon | TDLoadingIcon | TDLoadingIcon.circle | loading样式 |
| maxOverOffset |  | - |  |
| notifyWhenInvisible |  | - |  |
| overScroll | bool | true | 越界滚动([enableInfiniteRefresh]为true或[infiniteOffset]有值时生效) |
| position |  | - |  |
| processedDuration |  | - |  |
| readySpringBuilder |  | - |  |
| safeArea |  | false |  |
| secondaryCloseTriggerOffset |  | - |  |
| secondaryDimension |  | - |  |
| secondaryTriggerOffset |  | - |  |
| secondaryVelocity |  | - |  |
| spring |  | - |  |
| springRebound |  | - |  |
| triggerDistance | double | 48.0 | 触发刷新任务的偏移量，同[triggerOffset] |
| triggerOffset |  | - |  |
| triggerWhenReach |  | - |  |
| triggerWhenRelease |  | - |  |
| triggerWhenReleaseNoWait |  | - |  |
