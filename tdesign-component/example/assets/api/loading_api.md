## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | Axis.vertical | 文案和图标相对方向 |
| customIcon | Widget? | - | 自定义图标，优先级高于icon |
| duration | int | 2000 | 一次刷新的时间，控制动画速度 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| iconColor | Color? | - | 图标颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 失败刷新组件 |
| size | TLoadingSize | - | 尺寸 |
| text | String? | - | 文案 |
| textColor | Color? | - | 文案颜色 |


### TLoadingSize
#### 简介
Loading 尺寸
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸 |
| medium | 中尺寸 |
| large | 大尺寸 |


### TLoadingIcon
#### 简介
Loading图标
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
