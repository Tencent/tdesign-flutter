## API

### TResult

用于展示成功、警告、失败或默认结果状态的内容块。

#### 构造方法

##### TResult

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| description | String? | - | 描述文本，用于提供额外信息；为空时不占布局空间。 | 否 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义，默认为 `TResultStatus.info`。 | 否 |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 | 否 |


### TResultThemeData

结果组件级 ThemeExtension

#### 构造方法

##### TResultThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| descriptionStyle | TextStyle? | - | 描述文字样式 未配置时使用 fontBodyMedium / textColorSecondary Token。 | 否 |
| iconSize | double? | - | 默认状态图标尺寸；自定义 icon 不使用该字段。 未配置时为 80 逻辑像素，必须大于 0。 | 否 |
| titleStyle | TextStyle? | - | 标题文字样式；默认使用 fontTitleMedium / textColorPrimary Token。 | 否 |


#### 实例方法

##### TResultThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| iconSize | double? | - | 字段含义：默认状态图标尺寸；自定义 icon 不使用该字段。 未配置时为 80 逻辑像素，必须大于 0。 调用时的空值行为见方法说明。 | 否 |
| titleStyle | TextStyle? | - | 字段含义：标题文字样式；默认使用 fontTitleMedium / textColorPrimary Token。 调用时的空值行为见方法说明。 | 否 |
| descriptionStyle | TextStyle? | - | 字段含义：描述文字样式 未配置时使用 fontBodyMedium / textColorSecondary Token。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TResultThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TResultThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TResultThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TResultThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TResultStatus

结果状态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| info | TResultStatus | - | 默认信息状态。 | - |
| success | TResultStatus | - | 成功结果状态。 | - |
| warning | TResultStatus | - | 警告结果状态。 | - |
| error | TResultStatus | - | 错误结果状态。 | - |
