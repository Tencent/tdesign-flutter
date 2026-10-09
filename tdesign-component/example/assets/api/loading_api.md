## API

### TLoading

#### 构造方法

##### TLoading

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 `icon`，并按当前 Loading 动画时长持续旋转。 | 否 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 | 否 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 | 否 |
| text | String? | - | 文案 | 否 |


### TLoadingIcon
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| circle | TLoadingIcon | - | 圆形 | - |
| point | TLoadingIcon | - | 点状 | - |
| activity | TLoadingIcon | - | 菊花状 | - |
