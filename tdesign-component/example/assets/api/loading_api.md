## API

### TLoading

展示局部或全屏加载状态的组件。

#### 构造方法

##### TLoading

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 `icon`，并按当前 Loading 动画时长持续旋转。 | 否 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 | 否 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20，必须大于 0。 | 否 |
| text | String? | - | 文案 | 否 |


### TLoadingController

用于命令式显示和关闭加载状态的控制器。

#### 构造方法

##### TLoadingController

无参数。

#### 静态方法

##### TLoadingController.dismiss

无参数。

移除并释放全局加载层；没有加载层时调用无效，可重复调用。

##### TLoadingController.show

位置参数：`context`


在 `context` 的 Overlay 中显示全局加载层。

已有加载层或找不到 Overlay 时不重复创建。`child` 非空时替代内置 TLoading；
否则使用 `size`、`icon` 和 `text` 构建加载内容，text 为空时读取资源代理。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |
| child | Widget? | - | 替代默认加载内容的自定义组件；为空时由 size、icon 和 text 构建 TLoading。 | 否 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20，必须大于 0。 | 否 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。 `customIcon` 不为 null 时仍优先显示自定义图标。 | 否 |
| text | String? | - | 加载文案；为空时使用资源代理的 loading 文案。 | 否 |
| theme | TLoadingThemeData? | - | 仅作用于本次加载层，未提供时保留捕获的祖先主题。 | 否 |


### TLoadingThemeData

TLoading 组件级 ThemeExtension

通过 Theme 子树注入，控制子树的默认加载样式。

#### 构造方法

##### TLoadingThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| axis | Axis? | - | 文案和图标相对方向 未配置时为 Axis.horizontal。 | 否 |
| duration | int? | - | 一次刷新的时间（毫秒），控制动画速度。 未指定时默认 `800`ms（对齐 TDesign 小程序 / Mobile Vue 的 `duration` 默认值）。 小于或等于 0 时归一化为 1 毫秒。 | 否 |
| iconColor | Color? | - | 图标颜色。 未指定时 circle / point 使用品牌主色，activity 使用主文字色； 不读取 Flutter ProgressIndicatorTheme 或 ColorScheme 的默认颜色。 | 否 |
| textColor | Color? | - | 文案颜色 未配置时使用 textColorPrimary Token。 | 否 |


#### 实例方法

##### TLoadingThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| iconColor | Color? | - | 字段含义：图标颜色。 未指定时 circle / point 使用品牌主色，activity 使用主文字色； 不读取 Flutter ProgressIndicatorTheme 或 ColorScheme 的默认颜色。 调用时的空值行为见方法说明。 | 否 |
| textColor | Color? | - | 字段含义：文案颜色 未配置时使用 textColorPrimary Token。 调用时的空值行为见方法说明。 | 否 |
| axis | Axis? | - | 字段含义：文案和图标相对方向 未配置时为 Axis.horizontal。 调用时的空值行为见方法说明。 | 否 |
| duration | int? | - | 字段含义：一次刷新的时间（毫秒），控制动画速度。 未指定时默认 `800`ms（对齐 TDesign 小程序 / Mobile Vue 的 `duration` 默认值）。 小于或等于 0 时归一化为 1 毫秒。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TLoadingThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TLoadingThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TLoadingThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TLoadingThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


##### TLoadingThemeData.merge

位置参数：`other`


合并主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TLoadingThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TLoadingThemeData | - | other 的非空字段优先的合并主题；other 为 null 时返回当前主题。 | - |


### TLoadingIcon

Loading图标
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| circle | TLoadingIcon | - | 圆形 | - |
| point | TLoadingIcon | - | 点状 | - |
| activity | TLoadingIcon | - | 菊花状 | - |
