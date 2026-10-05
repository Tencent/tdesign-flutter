## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 `icon`，并按当前 Loading 动画时长持续旋转。 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 |
| text | String? | - | 文案 |


### TLoadingController

#### 静态方法

##### TLoadingController.dismiss

移除并释放全局加载层；未展示或已因 Overlay 卸载而清理时无副作用。

返回类型：`void`

##### TLoadingController.show

在最近的 Overlay 中展示全局唯一加载层。
重复调用不替换当前加载层；无 Overlay 时忽略请求。
所属 Overlay 卸载后会释放会话，后续可在新的 Overlay 展示。
普通页面离开但所属 Overlay 尚存时不会自动关闭；调用方应在任务结束
或需要随页面关闭时调用 `dismiss`。

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找 Overlay 并捕获主题。 |
| child | Widget? | - | 自定义内容；传入后忽略 size、icon 和 text。 |
| size | double | 20 | 默认加载图标尺寸，默认 20。 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 默认图标类型，默认 circle；null 时隐藏图标。 |
| text | String? | - | 默认内容文案，null 时使用当前语言的加载文案。 |
| theme | TLoadingThemeData? | - | 仅覆盖本次加载层的组件主题，null 时继承捕获的主题。 |


### TLoadingThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis? | - | 文案和图标相对方向 |
| duration | int? | - | 一次刷新的时间（毫秒），控制动画速度。 未指定时默认 `800`ms（对齐 TDesign 小程序 / Mobile Vue 的 `duration` 默认值）。 |
| iconColor | Color? | - | 图标颜色。 未指定时 circle / point 使用品牌主色，activity 使用主文字色； Flutter `ProgressIndicatorThemeData.color` 或显式 `ColorScheme` 仍优先于内置默认色。 |
| textColor | Color? | - | 文案颜色 |


### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
