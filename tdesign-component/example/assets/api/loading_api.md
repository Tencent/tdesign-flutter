## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 `icon` |
| icon | TLoadingIcon? | TLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 |
| text | String? | - | 文案 |


### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
