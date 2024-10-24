## API
### TDLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| size | TDLoadingSize | - | 尺寸 |
| icon | TDLoadingIcon? | TDLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| iconColor | Color? | - | 图标颜色 |
| axis | Axis | Axis.vertical | 文案和图标相对方向 |
| text | String? | - | 文案 |
| refreshWidget | Widget? | - | 失败刷新组件 |
| customIcon | Widget? | - | 自定义图标，优先级高于icon |
| textColor | Color | Colors.black | 文案颜色 |
| duration | int | 2000 | 一次刷新的时间，控制动画速度 |
