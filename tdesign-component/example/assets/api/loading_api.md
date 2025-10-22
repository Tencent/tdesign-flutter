## API
### TDLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | Axis.vertical | 文案和图标相对方向 |
| customIcon | Widget? | - | 自定义图标，优先级高于icon |
| duration | int | 2000 | 一次刷新的时间，控制动画速度 |
| icon | TDLoadingIcon? | TDLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| iconColor | Color? | - | 图标颜色 |
| key |  | - |  |
| refreshWidget | Widget? | - | 失败刷新组件 |
| size | TDLoadingSize | - | 尺寸 |
| text | String? | - | 文案 |
| textColor | Color? | - | 文案颜色 |
